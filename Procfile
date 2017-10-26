web: bundle exec rails s -p $PORT
webpacker: ./bin/webpack-dev-server
resque: env TERM_CHILD=1 QUEUE='*' bundle exec rake resque:work
redis: redis-server
