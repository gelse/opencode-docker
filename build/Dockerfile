FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y curl tmux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSfL https://opencode.ai/install | bash

ENV PATH="/root/.opencode/bin:$PATH"

WORKDIR /host

VOLUME ["/root/.opencode"]

# Start tmux and keep container running until tmux session ends
CMD ["sh", "-c", "tmux new -d -s opencode 'opencode'; while tmux has-session -t opencode 2>/dev/null; do sleep 1; done; exit 0"]
