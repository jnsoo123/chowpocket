web: bundle exec rails s -p $PORT
webpacker: ./bin/webpack-dev-server
worker: QUEUE=* rake environment resque:work
redis: redis-server
