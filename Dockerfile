FROM ruby:3.1
ENV DEBIAN_FRONTEND=noninteractive

LABEL MAINTAINER="Amir Pourmand"

# Install required packages (excluding ruby-full since Ruby is already included)
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    locales \
    imagemagick \
    build-essential \
    zlib1g-dev \
    jupyter-nbconvert \
    inotify-tools \
    procps && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production

# Update RubyGems and install Bundler and Jekyll
RUN gem update --system && gem install bundler jekyll

WORKDIR /srv/jekyll
COPY Gemfile /srv/jekyll/

RUN bundle install --no-cache

EXPOSE 8080

COPY bin/entry_point.sh /tmp/entry_point.sh
CMD ["/tmp/entry_point.sh"]
