class @Widget
  constructor: (@data, @children...) ->
    @isWidget = true
    @initialize()

  initialize: ->

  process: ->
    self = @
    result = @template()

    # Add afterRender callback to set @el
    callback = (el) -> self.el = el
    if result[1]and typeof result[1] is "object" and (result[1] not instanceof Array)
      if result[1].afterRender
        result[1].afterRender.unshift callback
      else
        result[1].afterRender = callback
    else
      result.splice(1, 0, afterRender: callback)

    T(result)

  update: =>
    @process().render replace: @el

  @create: (props) ->
    class Child extends @
    Child.prototype[k] = v for k, v of props
    (data, children...) -> new Child(data, children...).process()

  @inline: (data, widgetProps) ->
    @create(widgetProps)(data)

