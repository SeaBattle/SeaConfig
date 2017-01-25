#!/bin/sh
set -e

if [ ! -d "$HOME/etcd" ]; then
  mkdir -p $HOME/etcd
  curl -L https://github.com/coreos/etcd/releases/download/v3.1.0/etcd-v3.1.0-linux-amd64.tar.gz \
       -o $HOME/etcd/etcd-v3.1.0-linux-amd64.tar.gz
  tar xzvf $HOME/etcd/etcd-v3.1.0-linux-amd64.tar.gz -C $HOME/etcd/etcd --strip-components=1
else
  echo "Using cached etcd."
fi

if [ ! -d "$HOME/consul" ]; then
  mkdir -p $HOME/consul
  curl -L http://releases.hashicorp.com/consul/0.7.2/consul_0.7.2_linux_amd64.zip \
       -o $HOME/consul/consul_0.7.2_linux_amd64.zip
  unzip $HOME/consul/consul_0.7.2_linux_amd64.zip
else
  echo "Using cached consul."
fi