#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/projekte ~/Technische_Informatik_Bachelor -mindepth 1 -maxdepth 4 -type d | fzf)
fi

if [[ -z $selected ]]; then
    echo "Kein Ordner wurde ausgewählt"
    exit 1
fi

selected_name=$(basename "$selected" | tr . _)

# Prüfen, ob die tmux-Session existiert
if ! tmux has-session -t=$selected_name 2>/dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

# Prüfen, ob das Skript innerhalb von tmux läuft
if [[ -z $TMUX ]]; then
    tmux attach-session -t $selected_name
else
    tmux switch-client -t $selected_name
fi
