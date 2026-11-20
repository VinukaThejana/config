# Converts each selected file to a PDF next to it with headless LibreOffice.
# The dedicated profile keeps conversion working while the LibreOffice app is open.
soffice=/Applications/LibreOffice.app/Contents/MacOS/soffice
failed=()
for f in "$@"; do
  "$soffice" -env:UserInstallation="file://$HOME/Library/Caches/pdf-quick-action" \
    --headless --convert-to pdf --outdir "${f:h}" "$f" >/dev/null 2>&1 \
    && [[ -f "${f:r}.pdf" ]] || failed+=("${f:t}")
done
if (( $#failed )); then
  osascript -e 'on run argv' -e 'display alert "PDF conversion failed" message (item 1 of argv)' -e 'end run' "${(F)failed}"
fi
