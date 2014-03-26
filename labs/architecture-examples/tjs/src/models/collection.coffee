class @Collection
  constructor: ->
    @_data = []
    @_data.push(item) for item in arguments

  get: (i) -> @_data[i]

  children: -> @_data

  length: -> @_data.length

  self = @
  methods = Object.getOwnPropertyNames(Array.prototype)
  for method in methods
    if ['constructor', 'length'].indexOf(method) < 0
      ((m) -> 
        self.prototype[m] = -> @_data[m] arguments...
      )(method)

