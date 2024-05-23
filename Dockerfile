# Use the official Ruby image as a parent image
FROM ruby:3.3.1

# Install dependencies for Active Storage preview support and clean up afterwards
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Set environment variables for Rails
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development"

# Set the working directory for the Rails app
WORKDIR /rails

# Copy Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock package*.json ./

RUN gem install bundler
RUN bundle install --jobs 4 --retry 3
RUN npm install

COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Specify the default command to run when the container starts
CMD ["sh", "-c", "bundle exec rails db:create db:migrate && rails server -b 0.0.0.0"]
