middleware = (options) ->

  _middle = (req, res, callback = ->) ->
    console.log res.url
    callback()

  return _middle

module.exports = middleware