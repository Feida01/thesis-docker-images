FROM nvidia/cuda:12.9.1-base-ubuntu24.04

LABEL org.opencontainers.image.authors="feida.wei@radboudumc.nl"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends --yes \
        ca-certificates \
        git \
        # for opencv
        ffmpeg libsm6 libxext6 \
        # for remote development
        openssh-server \
        # for torch compile
        g++ \
        && rm -rf /var/lib/apt/lists/* \
        > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

ADD https://github.com/mahmoodlab/trident.git /trident
WORKDIR /trident

RUN uv venv --python 3.10 && uv pip install -e . && uv pip install \
      scikit-learn \
      pandas \
      scipy \
      matplotlib \
      wandb \
      jupyterlab \
      notebook \
      ipykernel \
      scikit-image==0.24.0

ENV PATH="/trident/.venv/bin:$PATH"
