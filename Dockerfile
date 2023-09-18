FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu20.04


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

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

#CMD ["/sbin/init"] 
