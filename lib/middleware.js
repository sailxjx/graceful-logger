// Generated by CoffeeScript 1.6.3
(function() {
  var middleware;

  middleware = function(options) {
    var _middle;
    _middle = function(req, res, callback) {
      if (callback == null) {
        callback = function() {};
      }
      console.log(res.url);
      return callback();
    };
    return _middle;
  };

  module.exports = middleware;

}).call(this);