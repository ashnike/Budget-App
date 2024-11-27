# Use a specific Ruby version image
FROM ruby:3.1.2-slim-bullseye

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential curl bash nodejs npm tzdata \
    libpq-dev postgresql-client git libxslt-dev libxml2-dev imagemagick && \
    rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock for dependency installation
COPY Gemfile Gemfile.lock package*.json /app/
WORKDIR /app

# Install Ruby gems
RUN gem install bundler
RUN bundle install --jobs=4 --retry=5
RUN npm install

# Copy the rest of the application files
COPY . .

# Precompile assets for Rails
RUN bundle exec rails assets:precompile

# Final image with only necessary files
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Set the entrypoint and CMD for the container
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb"]
