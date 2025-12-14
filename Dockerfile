FROM ruby:3.2.2-bullseye AS builder

# Install build dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      git \
      curl \
      pkg-config \
      libxml2-dev \
      libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

COPY . .

FROM ruby:3.2.2-bullseye AS app

# Install runtime libraries only
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      libpq5 \
      curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app
