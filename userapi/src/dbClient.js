var redis = require("redis");

var db = redis.createClient({
  host: process.env.REDIS_HOST || "127.0.0.1",
  port: process.env.REDIS_PORT || 6379,
  retry_strategy: (options) => {
    if (options.total_retry_time > 1000 * 60 * 60) {
      // The connection is never going to get up again
      // kill the client with the error event
      return new Error('Retry time exhausted');
    }
    // attempt reconnect after this delay
    return Math.min(options.attempt * 100, 3000)
  }
})

process.on('SIGINT', function() {
  db.quit();
});

module.exports = db
