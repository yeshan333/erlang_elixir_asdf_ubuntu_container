#!/bin/bash

echo "Before removing files:"
sudo yes | docker system prune --force --all
sudo rm -rf /usr/share/dotnet
sudo rm -rf /opt/ghc
sudo rm -rf "/usr/local/share/boost"
sudo rm -rf "$AGENT_TOOLSDIRECTORY"
echo "After removing files:"
df -mh