# Build an AI container for the GPU Cluster
## Information
- Base image: nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
- Python: 3.11.5
- Jupyter port: 8888
- Pytorch: 2.0.1+cu118
- Tensorflow: 2.12.0
- Conda: 23.3.1
- Cuda version: 11.8
- Nvidia driver: 525.85.05
- Git: 2.25.1
- gcc/g++: 9.4.0

## Base image
- Build the image with JupyterHub, JupyterLab, mamba, conda
```bash
docker build -f Dockerfile -t ai-base:0.5 .
```
- Add the VS code and VNC
```bash
cd vnc
docker build -f vnc.Dockerfile -t ai-base:0.5-vnc-vs .
```

## TF2
```bash
cd tf2
docker build -f Dockerfile -t aimc-tf2:0.5 .
```

## Pytorch
```bash
docker build -f Dockerfile -t aimc-pytorch:0.5 .
```

## ROS
Under testing

## Test
- With sudo privilege
```bash
docker run --gpus 1 --rm -it -p 8888:8888 --user root -e GRANT_SUDO=yes --name jupyter ai-base:0.5
```
- Access a running container
```bash
docker exec -it jupyter /bin/bash
```

## Other commands
- Delete all exited containers
```bash
docker rm $(docker ps -a -f status=exited -q)
```
- Remove docker cache
```bash
docker system prune -a
docker buildx prune -f
```
- Remove dangling images
```bash
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
```

# References
-  jupyter-remote-desktop-proxy: [990faf9](https://github.com/jupyterhub/jupyter-remote-desktop-proxy/tree/990faf9f5831e8ef54e99766af9c8780b0ad96b3)
- Jupyter - Docker stack: [docker-stacks](https://github.com/jupyter/docker-stacks/tree/main/images)

