FROM ruby:2.3

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  libsqlite3-dev \
  nodejs \
  postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Rails
RUN gem install rails

# Create a new Rails app under /src/my-app
RUN mkdir -p /src && cd /src && rails new my-app
WORKDIR /src/my-app

CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000
