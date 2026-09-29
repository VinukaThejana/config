---
name: scaffolding-axum-services
description: Use when starting a new Rust HTTP service/API, or adding a new resource, endpoint, config field, or error case to an existing axum-based Rust service and unsure where it belongs
---

# Scaffolding Axum Services

## Overview

A small set of conventions for structuring a Rust HTTP service on `axum` so
error handling, validation, config, and API docs stay consistent as the
service grows. One module owns each concern; nothing improvises a new pattern
for something that already has a home.

## When to Use

- Bootstrapping a new Rust web service from scratch
- Adding a new endpoint/handler and unsure where the route, handler, and
  request/response types each go
- Adding a new failure case (validation, not-found, conflict, auth) and
  unsure whether it needs a new error variant
- Wiring config/env vars, logging, or OpenAPI docs for a Rust API
- NOT for: non-HTTP Rust binaries/libraries, or projects already committed to
  a different framework's idioms (actix-web, warp) — the module boundaries
  here are axum-specific (extractors, `IntoResponse`, `utoipa::path`)

## Project Layout

```
src/
  main.rs              # wiring only: layers, router, serve — no business logic
  lib.rs               # re-exports config/doc/handler/util for main.rs and tests
  config/
    env.rs             # typed Env struct, loaded + validated once at startup
    log.rs             # logging setup (dev: colored/verbose, prod: plain/quieter)
    state.rs           # AppState (DB pools, clients) built once, cloned into handlers
  routes/mod.rs         # Router construction — maps paths to handler fns
  handler/mod.rs        # one fn per endpoint, #[utoipa::path] doc + IntoResponse
  schemas/
    error.rs           # the one error response shape ALL failing endpoints return
    <resource>.rs       # request/response DTOs for one resource, derive ToSchema
  error.rs              # AppError — see Error Handling below
  util/
    extractor.rs        # custom extractors (e.g. ValidatedJson)
    mod.rs               # small cross-cutting helpers (shutdown, rate-limit config)
```

Each module answers one question: `config` how do we start up, `routes`
where do requests go, `handler` what does an endpoint do, `schemas` what
shape does data have, `error` what does failure look like, `util` what
doesn't belong anywhere more specific. If a change touches business logic
*and* wiring, that's a sign the handler is doing too much — push logic into
a service/repository layer, keep the handler thin.

## Error Handling

**One enum, one conversion point.** All failures become `AppError`, which
implements `IntoResponse` exactly once. Handlers return
`Result<impl IntoResponse, AppError>` and use `?` — never build an error
`Response` by hand in a handler.

**Category variants collapse into one shape.** `BadRequest`, `NotFound`,
`Conflict`, `Unauthorized`, etc. all carry the same three things — don't
give each its own struct:

```rust
#[derive(Debug, thiserror::Error)]
pub enum AppError {
    #[error("{user_message}")]
    Http {
        status: StatusCode,
        tag: &'static str,           // machine-readable category, e.g. "not_found"
        user_message: String,        // safe to show the client
        #[source]
        source: Option<anyhow::Error>, // internal detail, logged only, never serialized
    },
    #[error("{0}")]
    Validation(#[from] validator::ValidationErrors),
    #[error(transparent)]
    Other(#[from] anyhow::Error),      // unexpected errors — client sees a generic message
}
```

Constructors per category (`AppError::not_found(msg)`, `AppError::conflict(msg)`,
...) build `Http` with `source: None`. A second `*_from(msg, err)` constructor
per category attaches a source for logging.

**The rule that matters most: never derive the client-facing message from an
internal error's `Display`/`to_string()`.** `err.to_string()` on a DB, IO, or
driver error can contain table names, connection strings, or file paths.
Require an explicit, already-safe `msg` at every call site; pass the real
error in separately as `source` so it still reaches the logs:

```rust
// Wrong — leaks whatever the source error says to the client
AppError::not_found(err.to_string())

// Right — client sees a message you chose; err is logged, not shown
AppError::not_found_from("user not found", err)
```

The one exception is a framework-generated rejection whose message is
already written to be user-facing (e.g. axum's `JsonRejection` from a bad
request body) — there, using its own text as `msg` is a deliberate, visible
choice at the call site, not a default anyone falls into by accident.

**`Other`/`anyhow::Error` is the catch-all for anything unexpected:** log the
real error at `error!` level, return a fixed generic message
("something went wrong") and 500 — never the source text.

**Validation errors report every invalid field**, not just the first one
found — one round trip should tell the client everything wrong with the
request.

**Test the mapping, not the framework.** A handful of `#[tokio::test]`s
per category (status code + JSON body) plus one proving a source error's
text never appears in the response body is enough; don't test axum itself.

## Config & Logging

- One `Env` struct (`config/env.rs`), `derive(Deserialize, Validate)`,
  loaded via `envy::from_env()` behind a `once_cell::Lazy` static (or
  equivalent lazy-static) so it's read once and panics fast on invalid
  config at startup — not on first request.
- `dotenvy::dotenv()` before reading env vars, so `.env` works in dev
  without affecting prod deploys that set real env vars.
- Logging setup (`config/log.rs`) branches on an `APP_ENV`/dev-vs-prod flag:
  colored + verbose (Trace) locally, plain + quieter (Debug) in prod. Do
  this once at the top of `main`, before anything else logs.

## Handlers & OpenAPI

- One `#[utoipa::path(...)]`-annotated async fn per endpoint in `handler/`;
  doc comment above it becomes the OpenAPI summary/description.
- Every documented error response references the same
  `schemas::error::Response` type — the OpenAPI spec should show one error
  shape, matching what `AppError::into_response` actually produces.
- `routes/mod.rs` (or `main.rs` for a small service) is the only place that
  assembles the `Router` — handlers never construct routers.
- Request bodies needing validation go through a custom extractor
  (`ValidatedJson<T>`) that runs `T: Validate` and converts both the axum
  extraction failure and the validation failure into `AppError` — handlers
  receive already-valid data, never call `.validate()` themselves.

## Common Mistakes

| Mistake | Why it's wrong |
|---|---|
| New status code → new struct-like enum variant | Duplicates the same 3 fields per category; use one `Http` variant with `status`/`tag` |
| `AppError::not_found(err.to_string())` on a DB/IO error | Leaks internal error text into the client-facing JSON body |
| Manually setting `Content-Type: application/json` next to `Json(...)` | `Json` already sets it; the explicit header is redundant |
| Building `Response` by hand in a handler for an error case | Bypasses the single logging/serialization point in `IntoResponse for AppError` |
| Reading env vars ad hoc with `std::env::var` in handler code | Config drifts from what's validated at startup; keep it all in `Env` |
| Validation response showing only the first invalid field | Forces the client into a fix-one-resubmit-repeat loop |
