options=("By name" "By email" "Last commit")
result=$(printf "%s\n" "${options[@]}" | fzf \
  --ansi \
  --prompt="Show git Log: " \
  --height=20%)

case "$result" in
"By name")
  git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %aN%Creset %s"
  ;;
"By email")
  git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %ae%Creset %s"
  ;;
"Last commit")
  git log -1 --pretty=%s
  ;;
esac
