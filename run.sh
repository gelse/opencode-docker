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
        docker exec -it $CONTAINER_NAME tmux attach-session -t opencode
    else
        echo "Container exists but is not running, removing and recreating..."
        docker rm -f $CONTAINER_NAME
        docker compose up -d --build
    fi
else
    echo "Starting container..."
    docker compose up -d --build
fi

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
docker exec -it $CONTAINER_NAME tmux attach-session -t opencode
