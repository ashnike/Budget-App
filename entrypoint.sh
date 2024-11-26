#!/bin/bash
set -e

# Ensure environment variables are loaded
: "${RAILS_ENV:=production}"

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

#bundle exec rake db:create
# Run database migrations (if necessary) and prepare the database
#echo "Running database migrations..."
bundle exec rake db:migrate

#echo "Preparing the database..."
bundle exec rake db:prepare

# Execute the container's main process
exec "$@"
