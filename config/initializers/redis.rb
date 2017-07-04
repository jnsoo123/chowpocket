uri = URI.parse(ENV["REDIS_URL"] || 'redis://localhost:9254/')
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
