ARG BASEIMAGE
FROM ${BASEIMAGE}

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

ENV HOME=/home/redbot
RUN useradd -m -d $HOME -s /bin/sh -u 2055 redbot
RUN mkdir -p $HOME/.config/Red-DiscordBot

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends git; \
        rm -rf /var/lib/apt/lists/*;

RUN pip install --no-compile --no-cache-dir tabulate==0.9.0

ARG VERSION
ENV REDBOT_VERSION=${VERSION}

RUN pip install --no-compile --no-cache-dir Red-DiscordBot==$REDBOT_VERSION

USER redbot
