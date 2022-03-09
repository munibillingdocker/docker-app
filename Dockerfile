FROM ubuntu:focal

# Set variables
ENV \
  DOKERIZE_VERSION="0.6.1" \
  DEBIAN_FRONTEND=noninteractive \
  TZ="America/Chicago"

# change to Bash
SHELL ["/bin/bash", "-c"]

RUN \
  apt-get update && \
  apt-get install -y software-properties-common wget python3 locales \
    python3-pip python3-openssl curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \

  # timezone config
  ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata

# dockerize
RUN \
  wget --progress=bar:force:noscroll https://github.com/jwilder/dockerize/releases/download/v$DOKERIZE_VERSION/dockerize-linux-amd64-v$DOKERIZE_VERSION.tar.gz && \
  tar -C /usr/local/bin -xvzf dockerize-linux-amd64-v$DOKERIZE_VERSION.tar.gz && \
  rm dockerize-linux-amd64-v$DOKERIZE_VERSION.tar.gz

# use en_US.UTF-8
RUN localedef en_US.UTF-8 -i en_US -fUTF-8 && \
  echo "LANG=en_US.UTF-8" >> /etc/default/locale

# update pip
RUN pip3 install --upgrade pip

# install swiftly (and six, a pre-req for swiftly)
RUN pip3 install --ignore-installed --no-cache-dir six && \
    pip3 install --no-cache-dir swiftly

CMD ["/bin/bash"]

