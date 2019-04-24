echo "init pipe"

if [ ! -p .test_commands ]; then
  mkfifo .test_commands
fi

while true; do
  zsh -c "$(cat .test_commands)";
done
