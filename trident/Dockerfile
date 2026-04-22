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

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

ADD https://github.com/mahmoodlab/trident.git /trident
WORKDIR /trident

RUN uv venv --python 3.10
ENV PATH="/trident/.venv/bin:$PATH"

# Install the CUDA 12.9 PyTorch
RUN uv pip install --index-url https://download.pytorch.org/whl/cu129 \
    torch \
    torchvision \
    torchaudio

RUN uv pip install -e . --no-deps

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

RUN python - <<'PY'
import torch, cv2
print("torch:", torch.__version__)
print("cuda:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("cv2:", cv2.__version__)
PY