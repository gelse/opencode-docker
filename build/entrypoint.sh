#!/bin/bash

# Copy agents directory if it doesn't exist in volume
if [ ! -d /root/.config/opencode/agents ]; then
    cp -r /usr/local/share/agents.default /root/.config/opencode/agents
fi

# Start tmux session, exit if session ends
tmux new -s opencode 'opencode --hostname 0.0.0.0 --port 8088' && exit 0
