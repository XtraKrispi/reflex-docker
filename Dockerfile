FROM ubuntu

RUN apt-get update --fix-missing && apt-get install \
    curl perl sudo locales bzip2 git -y

RUN apt-get clean && apt-get purge && apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/reflex -s /bin/bash reflex
RUN usermod -a -G sudo reflex
RUN echo " reflex      ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /home/reflex
USER reflex
ENV USER reflex

RUN git clone https://github.com/reflex-frp/reflex-platform

ADD run-reflex reflex-platform/run-reflex

RUN reflex-platform/try-reflex

RUN mkdir /home/reflex/src
VOLUME ["/home/reflex/src"]

WORKDIR /home/reflex/src

ENTRYPOINT ["../reflex-platform/run-reflex"]
CMD [""]