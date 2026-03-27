#!/bin/bash

# Get the container name based on the project and service
get_container_id() {
    docker compose ps -q opencode
}

# Check if container exists (running or stopped)
CONTAINER_ID=$(get_container_id)

if [ -n "$CONTAINER_ID" ]; then
    CONTAINER_NAME=$(docker inspect --format='{{.Name}}' $CONTAINER_ID | sed 's/\///')
    STATUS=$(docker inspect --format='{{.State.Status}}' $CONTAINER_ID)
    
    if [ "$STATUS" = "running" ]; then
        echo "Container already running ($CONTAINER_NAME), attaching to tmux session..."
        # Check if tmux session exists, if not create it
        if ! docker exec $CONTAINER_NAME tmux has-session -t opencode 2>/dev/null; then
            echo "Creating new tmux session..."
            docker exec -d $CONTAINER_NAME tmux new -s opencode 'opencode -a system-analyze'
            sleep 2
        fi
        docker exec -it $CONTAINER_NAME tmux attach-session -t opencode
    else
        echo "Container exists but is not running, starting..."
        docker start $CONTAINER_NAME
        # Wait for container to start
        for i in {1..30}; do
            STATUS=$(docker inspect --format='{{.State.Status}}' $CONTAINER_ID)
            if [ "$STATUS" = "running" ]; then
                break
            fi
            sleep 1
        done
        
        if [ "$STATUS" != "running" ]; then
            echo "Failed to start container"
            exit 1
        fi
        
        echo "Attaching to tmux session..."
        # Check if tmux session exists, if not create it
        if ! docker exec $CONTAINER_NAME tmux has-session -t opencode 2>/dev/null; then
            echo "Creating new tmux session..."
            docker exec -d $CONTAINER_NAME tmux new -s opencode 'opencode -a system-analyze'
            sleep 2
        fi
        docker exec -it $CONTAINER_NAME tmux attach-session -t opencode
    fi
else
    echo "Building and starting container..."
    docker compose up -d --build
    
    # Wait for container to start
    for i in {1..30}; do
        CONTAINER_ID=$(get_container_id)
        if [ -n "$CONTAINER_ID" ]; then
            STATUS=$(docker inspect --format='{{.State.Status}}' $CONTAINER_ID)
            if [ "$STATUS" = "running" ]; then
                break
            fi
        fi
        sleep 1
    done
    
    if [ -z "$CONTAINER_ID" ]; then
        echo "Failed to start container"
        exit 1
    fi
    
    CONTAINER_NAME=$(docker inspect --format='{{.Name}}' $CONTAINER_ID | sed 's/\///')
    echo "Attaching to tmux session..."
    # Wait a bit for entrypoint to start tmux
    sleep 2
    docker exec -it $CONTAINER_NAME tmux attach-session -t opencode
fi
