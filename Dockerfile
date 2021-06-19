FROM ruby:2.5-slim

# Create temp dir for installations
WORKDIR /tmp/install

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
        apt \
        ca-certificates \
        curl \
        git \
        wget \
        autoconf \
        automake \
        build-essential \
        pkg-config \
				&& rm -rf /var/lib/apt/lists/*

RUN rm -rf /tmp/install

WORKDIR /apps/datawrangler

COPY . /apps/datawrangler

RUN gem install bundler && bundle install -j4 --retry 3
