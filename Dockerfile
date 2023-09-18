FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04


ENV HOME=/root
ENV TZ=Asia/Bangkok
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL en_US.UTF-8

USER root
WORKDIR $HOME

RUN apt-get update && apt-get dist-upgrade -y 
#RUN apt-get dist-upgrade -y 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils software-properties-common \ 
	sudo wget vim zip python3-pip build-essential \ 
	unzip traceroute iputils-ping net-tools git-core \
	openssh-server lsb-release curl locales tzdata fonts-thai-tlwg

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen /etc/locale.gen && locale-gen
RUN locale-gen th_TH.UTF-8

# ANACONDA
# Reference 
# https://dev.to/ordigital/nvidia-525-cuda-118-python-310-pytorch-gpu-docker-image-1l4a
# https://pytorch.org/get-started/locally/

RUN wget -O /tmp/anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Linux-x86_64.sh \
    && bash /tmp/anaconda.sh -b -p /root/anaconda \
    && eval "$(/root/anaconda/bin/conda shell.bash hook)" \
    && conda init \
    && conda update -n base -c defaults conda \
    && conda create --name env \
    && conda activate env \
    && conda install -y pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia

#CMD ["/sbin/init"] 
