---
title: docker
abbrlink: f255ffad
date: 2024-09-03 22:47:00
tags:
---
sswc31689
# 进入容器
docker exec -it wsy /bin/bash
# 退出容器，回到服务器宿主机
exit
# 查看所有容器
docker ps -a
# 安装python和pip
apt-get install -y python3 python3-pip
# 改名
ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip
# 验证python
python --version
pip --version
# 安装pytorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu116
# 验证安装和gpu可用性
python -c "import torch; print(torch.__version__); print('CUDA Available:', torch.cuda.is_available()); print('GPU Count:', torch.cuda.device_count()); print('Current GPU:', torch.cuda.get_device_name(0))"
# 在 Bash 终端中，输入 python 或 python3 进入 Python 解释器环境，然后输入 Python 代码：
python
# 当前是否可以使用 CUDA（即 GPU 资源）
import torch
print(torch.cuda.is_available())


```
docker run -it -v /mnt/lustre/GPU4/home/sushuang/siyi:/app -p 8822:22 --name wsy --gpus all  --restart=always iris-main /bin/bash

注意几个参数
-itd
-p
-v
--gpus
```
# 汉语
```
apt-get update
apt-get install -y locales fonts-noto-cjk
locale-gen zh_CN.UTF-8
echo 'export LANG=zh_CN.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=zh_CN.UTF-8' >> ~/.bashrc
source ~/.bashrc
```
# docker ssh


如果在容器中运行 `service ssh status` 时显示“ssh: unrecognized service”，可能是因为容器中没有安装 SSH 服务。通常，Docker 容器默认不安装 SSH 服务，特别是精简镜像或者仅用于运行特定应用的容器。

### 解决方案

1. **安装 SSH 服务**

   如果你需要在 Docker 容器中运行 SSH 服务，你可以尝试安装并配置它。以下是在基于 Debian/Ubuntu 镜像的容器中安装和配置 SSH 服务的步骤：

   ```bash
   apt-get update
   apt-get install -y openssh-server
   ```
   安装完成后，创建 SSH 服务的运行目录，并启动 SSH 服务：
   ```bash
   mkdir /var/run/sshd
   service ssh start
   ```
2. **配置 SSH**
   确保 SSH 配置文件正确，特别是 `sshd_config` 文件中的设置。例如，确保 `PermitRootLogin` 被设置为 `yes`，如果你要以 root 用户登录：
   ```bash
   sed -i 's/PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
   ```
3. **暴露 SSH 端口**
   确保 Docker 容器正确暴露了 SSH 端口（通常是端口 22）。你在启动容器时已经进行了端口映射，所以确保端口映射正确并且容器内部的服务配置无误。
4. **重新启动容器**
   重新启动容器以确保所有配置生效：
   ```bash
   docker restart wsy
   ```
5. **检查 SSH 服务**
   再次检查 SSH 服务是否正在运行：
   ```bash
   service ssh status
   ```
6. **连接到容器**
   使用 SSH 客户端连接到容器：
   ```bash
   ssh -p 8822 sushuang@127.0.0.1
   ```
### 如果不需要 SSH

如果你只是需要在容器内执行一些命令，而不需要通过 SSH 访问容器，可以直接使用 `docker exec` 进入容器：

```bash
docker exec -it wsy /bin/bash
```

```
sudo docker port [新的容器ID] 22
sudo docker port d92fd3e9f4a0  22
service ssh restart
```

# 设置docker root 密码
```
passwd
```
# 用docker的root链接

Host docker-container
  HostName 172.10.60.143
    User root
    Port 8822
csdn:
```
https://blog.csdn.net/weixin_43268590/article/details/129244984
```
rr notion
```
https://rylynn.notion.site/dockerfile-51925f5a19344df6a7d720485468fc19?pvs=4
```


# ssh免密登录
```
ssh-keygen
touch ~/.ssh/authorized_keys
```
```
ssh-copy-id username@ip
```