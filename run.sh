#!/bin/bash

# Get the container name based on the project and service
get_container_id() {
    docker compose ps -q opencode
}

# Wait for container to be running (max 30 seconds)
wait_for_container() {
    local container_id="$1"
    for i in {1..30}; do
        STATUS=$(docker inspect --format='{{.State.Status}}' "$container_id" 2>/dev/null)
        if [ "$STATUS" = "running" ]; then
            return 0
        fi
        sleep 1
    done
    return 1
}

# Create and attach to tmux session
attach_to_tmux() {
    local container_name="$1"
    
    # Check if tmux session exists, if not create it
    if ! docker exec "$container_name" tmux has-session -t opencode 2>/dev/null; then
        echo "Creating new tmux session..."
        docker exec -d "$container_name" tmux new -s opencode 'opencode -a system-analyze'
        sleep 2
    fi
    
    docker exec -it "$container_name" tmux attach-session -t opencode
}

# Main logic
CONTAINER_ID=$(get_container_id)

if [ -n "$CONTAINER_ID" ]; then
    CONTAINER_NAME=$(docker inspect --format='{{.Name}}' "$CONTAINER_ID" | sed 's/\///')
    STATUS=$(docker inspect --format='{{.State.Status}}' "$CONTAINER_ID")
    
    if [ "$STATUS" = "running" ]; then
        echo "Container already running ($CONTAINER_NAME), attaching to tmux session..."
        attach_to_tmux "$CONTAINER_NAME"
    else
        echo "Container exists but is not running, starting..."
        docker start "$CONTAINER_NAME"
        
        if ! wait_for_container "$CONTAINER_ID"; then
            echo "Failed to start container"
            exit 1
        fi
        
        echo "Attaching to tmux session..."
        attach_to_tmux "$CONTAINER_NAME"
    fi
else
    echo "Building and starting container..."
    docker compose up -d --build
    
    # Wait for container to start
    for i in {1..30}; do
        CONTAINER_ID=$(get_container_id)
        if [ -n "$CONTAINER_ID" ]; then
            STATUS=$(docker inspect --format='{{.State.Status}}' "$CONTAINER_ID" 2>/dev/null)
            if [ "$STATUS" = "running" ]; then
                break
            fi
        fi
        sleep 1
    done
    
    if [ -z "$CONTAINER_ID" ] || [ "$STATUS" != "running" ]; then
        echo "Failed to start container"
        exit 1
    fi
    
    CONTAINER_NAME=$(docker inspect --format='{{.Name}}' "$CONTAINER_ID" | sed 's/\///')
    echo "Attaching to tmux session..."
    attach_to_tmux "$CONTAINER_NAME"
fi
