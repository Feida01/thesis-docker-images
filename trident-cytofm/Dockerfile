FROM nvidia/cuda:12.9.1-base-ubuntu24.04
LABEL org.opencontainers.image.authors="feida.wei@radboudumc.nl"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends --yes \
    ca-certificates \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    openssh-server \
    g++ \
    libvips42 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ── uv ────────────────────────────────────────────────────────────────────────
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# ── TRIDENT ───────────────────────────────────────────────────────────────────
ARG trident_version
ADD https://github.com/mahmoodlab/trident.git /trident
WORKDIR /trident
RUN uv venv --python 3.10
ENV PATH="/trident/.venv/bin:$PATH"

# PyTorch with CUDA 12.9 support
RUN uv pip install --index-url https://download.pytorch.org/whl/cu129 \
    torch \
    torchvision \
    torchaudio

# TRIDENT core (no deps — pytorch already installed above)
RUN uv pip install -e . --no-deps

# General + TRIDENT runtime dependencies
RUN uv pip install \
    ipywidgets \
    numpy \
    pandas \
    tqdm \
    h5py \
    matplotlib \
    opencv-python \
    "scikit-image>=0.20" \
    openslide-python \
    openslide-bin \
    Pillow \
    geopandas \
    shapely \
    requests \
    huggingface_hub \
    aicsimageio \
    pyvips \
    "transformers>=4.40,<5" \
    "timm==0.9.16" \
    einops \
    einops_exts \
    scipy \
    segmentation-models-pytorch \
    safetensors \
    scikit-learn \
    umap-learn \
    wandb \
    jupyterlab \
    notebook \
    ipykernel

# ── iBOT (CytoFM backbone) ────────────────────────────────────────────────────
# Cloned to /opt/ibot; the run_batch_cytofm.py script expects --ibot_dir /opt/ibot
RUN git clone https://github.com/bytedance/ibot.git /opt/ibot

RUN uv pip install setuptools && \
    uv pip install --no-build-isolation \
        mmcv \
        torchmetrics