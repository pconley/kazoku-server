

# $redis = Redis.new(url: ENV["REDIS_URL"])

$redis = Redis.new(:host => 'localhost', :port => 6379)