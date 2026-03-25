FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y curl tmux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSfL https://opencode.ai/install | bash

ENV PATH="/root/.opencode/bin:$PATH"

WORKDIR /host

VOLUME ["/root/.opencode"]

# Start tmux in background and keep container running
CMD ["sh", "-c", "tmux new -d -s opencode 'opencode'; sleep infinity"]
