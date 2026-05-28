yabai -m window --toggle float

yabai_float=$(yabai -m query --windows --window | jq '."is-floating"')

case "$yabai_float" in
    false)
    sketchybar --set yabai_float label=""
    ;;
    true)
    sketchybar --set yabai_float label=""
    ;;
esac
