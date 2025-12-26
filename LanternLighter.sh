#!/bin/sh
echo -ne '\033c\033]0;LanternLighter\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/LanternLighter.x86_64" "$@"
