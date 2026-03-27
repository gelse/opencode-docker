FROM ubuntu:22.04

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y curl tmux nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSfL https://opencode.ai/install | bash

ENV PATH="/root/.opencode/bin:$PATH"

WORKDIR /workdir

VOLUME ["/root/.opencode"]
VOLUME ["/root/.config/opencode"]
VOLUME [/workdir]

# Copy files needed by entrypoint
COPY agents /usr/local/share/agents.default
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
