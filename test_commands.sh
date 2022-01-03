echo "init pipe"

if [ ! -p ~/.test_commands ]; then
  mkfifo ~/.test_commands
fi

# reading from the pipe does not seem to clear it. This causes the while loop to run the same command over and over
# again. Echoing an empty string into the pipe fixes this. This doesn't happen on my Linux machine.
while true; do
  zsh -c "$(cat ~/.test_commands)";
  # zsh -c "$(cat ~/.test_commands && echo '' > ~/.test_commands)";
done
