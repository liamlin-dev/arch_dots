#!/usr/bin/env bash

set -uo pipefail

if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ]; then
  tmux detach-client
else
  tmux popup -d '#{pane_current_path}' -xC -yC -w90% -h90% -E "tmux attach -t popup || tmux new -s popup"
fi
