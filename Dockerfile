FROM ubuntu:latest
MAINTAINER John Andersen <johnandersenpdx@gmail.com>

RUN apt update -y && \
  apt install -y \
    bash \
    bash-completion \
    vim \
    tar \
    tmux \
    make \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    gdb-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib \
    libnewlib-arm-none-eabi \
    qemu-system-arm \
    openssh-server && \
  apt clean && \
  rm -rf /var/cache/apt/* && \
  mkdir /var/run/sshd && \
  /usr/sbin/useradd -m user && \
  echo "user:userpass" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
