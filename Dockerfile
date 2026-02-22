FROM debian:oldstable

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        docbook-xsl \
        doxygen \
        graphviz \
        libexpat1-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        locales \
        meson \
        ninja-build \
        pkg-config \
        xmlto \
        wget \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

VOLUME ["/data"]

COPY start.sh /start.sh

CMD ["/bin/bash", "/start.sh"]
