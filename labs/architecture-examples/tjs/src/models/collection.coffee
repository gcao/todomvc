class @Collection
  constructor: ->
    @_data = []
    @_data.push(item) for item in arguments

  length: -> @_data.length

  methods = Object.getOwnPropertyNames(Array.prototype)
  for method in methods
    if ['constructor', 'length'].indexOf(method) < 0
      @prototype[method] = -> Array.prototype[method].apply(@_data, arguments)

