web: bundle exec rails s -p $PORT
webpacker: ./bin/webpack-dev-server
worker: QUEUE=* bundle exec rake environment resque:work
redis: redis-server
