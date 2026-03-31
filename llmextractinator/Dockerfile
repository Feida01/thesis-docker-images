FROM ollama/ollama:latest

LABEL org.opencontainers.image.authors="feida.wei@radboudumc.nl"

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV UV_LINK_MODE=copy

RUN apt-get update && apt-get install --no-install-recommends --yes \
    ca-certificates \
    curl \
    git \
    openssh-server \
    bash \
    ffmpeg \
    libsm6 \
    libxext6 \
    g++ \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

WORKDIR /app

ARG LLM_EXTRACTINATOR_REF=main
RUN git clone --depth 1 --branch ${LLM_EXTRACTINATOR_REF} https://github.com/DIAGNijmegen/llm_extractinator.git /app

RUN uv venv --python 3.11 /app/.venv && \
    . /app/.venv/bin/activate && \
    uv pip install -e .

ENV PATH="/app/.venv/bin:${PATH}"

RUN mkdir -p /app/data /app/examples /app/tasks /app/output /root/.ollama /run/sshd /var/run/sshd

COPY llmextractinator/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8501 11434 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["app"]