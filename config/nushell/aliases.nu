alias v = nvim
alias r = ranger
alias cd = z

alias zka = zellij kill-all-sessions
alias zda = zellij delete-all-sessions
alias zl = zellij list-sessions
alias zc = zellij create-session

alias tl = tmux list-sessions
alias tc = tmux new -s
alias ta = tmux attach
alias tka = tmux kill-session -a

alias wget = wget -c 
alias grep = grep --color=auto
alias fgrep = fgrep --color=auto
alias egrep = egrep --color=auto
alias dir = dir --color=auto
alias vdir = vdir --color=auto

alias rip = expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl

alias cp = rsync -ah --progress

alias lg = lazygit

alias pinentry = pinentry-mac

alias rebuild = sudo darwin-rebuild switch --flake ~/.config/nix
alias flake-update = nix flake update

alias xdg-open = run-external open

alias icloud = cd `/Users/vinuka/Library/Mobile Documents/com~apple~CloudDocs`

('/usr/bin/paru' | path exists) and ('/usr/bin/yay' | path exists) and (alias yay = paru)
