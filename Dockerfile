FROM ubuntu:xenial

# Set variables
ENV DOKERIZE_VERSION="0.6.1"

# make directory for rvm
RUN mkdir -p /usr/share/rvm

# change to Bash
SHELL ["/bin/bash", "-c"]

RUN \
  apt-get update && \
  apt-get install -y software-properties-common wget python3 locales \
  python-pip python-openssl curl

# rvm
RUN \
  apt-add-repository -y ppa:rael-gc/rvm && \
  apt-get update && \
  apt-get install -y rvm && \
  source /usr/share/rvm/scripts/rvm && \
  rvm requirements && \
  apt-get -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# dockerize
RUN \
  wget --progress=bar:force:noscroll https://github.com/jwilder/dockerize/releases/download/v$DOKERIZE_VERSION/dockerize-linux-amd64-v$DOKERIZE_VERSION.tar.gz && \
  tar -C /usr/local/bin -xvzf dockerize-linux-amd64-v$DOKERIZE_VERSION.tar.gz && \
  rm dockerize-linux-amd64-v$DOKERIZE_VERSION.tar.gz

# use en_US.UTF-8
RUN localedef en_US.UTF-8 -i en_US -fUTF-8 && \
  echo "LANG=en_US.UTF-8" >> /etc/default/locale

# update pip
RUN pip install --upgrade pip

# install swiftly (and six, a pre-req for swiftly)
RUN pip install --ignore-installed --no-cache-dir six && \
    pip install --no-cache-dir swiftly

# setup /root/.bashrc
RUN echo 'eval `ssh-agent -s`' >> /root/.bashrc && \
    echo "ssh-add" >> /root/.bashrc && \
    echo '[[ -s "/usr/share/rvm/scripts/rvm" ]] && source "/usr/share/rvm/scripts/rvm"' >> /root/.bashrc

CMD ["/bin/bash"]

