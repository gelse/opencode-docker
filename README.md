# OpenCode Docker

A Docker-based AI assistant for analyzing Linux systems. The container mounts the host system read-only, enabling safe inspection without modifications.

## About the Project

OpenCode Docker is an AI-powered tool that runs in a Docker container and mounts the host system's root filesystem as read-only. This enables comprehensive system analysis without altering or compromising the system.

### Key Features

- **Read-Only System Access**: The host system is safely mounted as read-only
- **AI-Powered Analysis**: Intelligent analysis of system configurations, logs, and processes
- **Isolated Environment**: All operations take place within the container
- **Home Lab Optimized**: Designed specifically for private users and home lab environments

## Project Analysis

A detailed analysis of the project with identified issues and improvement suggestions can be found in [`issues-analysis.md`](issues-analysis.md).

## Installation

### Prerequisites

- Docker
- Docker Compose

### Quick Start

1. Clone the repository:
```bash
git clone https://github.com/gelse/opencode-docker.git
cd opencode-docker
```

2. Start the container:
```bash
./run.sh
```

Or manually with Docker Compose:
```bash
docker compose up -d --build
```

## Usage

The [`run.sh`](run.sh) script provides a simple user interface:

- **First Start**: Builds the container and starts a tmux session
- **Attach**: Attaches to a running tmux session
- **Restart**: Restarts a stopped container

### Manual Usage

```bash
# Start container
docker compose up -d --build

# Attach to tmux session
docker exec -it opencode tmux attach-session -t opencode
```

## Architecture

```
opencode-docker/
├── docker-compose.yml      # Docker Compose configuration
├── run.sh                  # Startup script
├── build/
│   ├── Dockerfile          # Container definition
│   ├── entrypoint.sh       # Container entry point
│   └── agents/
│       └── system-analyze.md  # AI agent configuration
└── issues-analysis.md      # Project analysis
```

## Security Notes

- The host system is mounted **read-only** - the container cannot make changes to the host
- The container runs as root (acceptable in home lab context)
- All analyses take place isolated within the container

## Development

This project was created with AI assistance and developed under human supervision.

## License

This project is open source. More information can be found in the repository.

## Links

- **GitHub Repository**: https://github.com/gelse/opencode-docker
- **Project Analysis**: [`issues-analysis.md`](issues-analysis.md)
