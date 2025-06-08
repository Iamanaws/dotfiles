#!/usr/bin/env bash

volume_data=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
read -r _ vol_float muted_status <<<"$volume_data"
dunstify_args=(-a "osd" -u "low")

if [[ -n "$muted_status" ]]; then
  icon=""
  message="Muted"
else
  # Convert float (e.g., 0.55) to integer (55)
  volume=$(printf "%.0f" "${vol_float}e2")
  icon=""
  message="Volume: ${volume}%"
  dunstify_args+=(-h "int:value:${volume}")
fi

dunstify "${dunstify_args[@]}" "${icon} ${message}"
