class @Todo
  constructor: (@parent, @title, @completed = false) ->
    Busbup.create(@)
    @subscribe CHANGED, => console.log "Todo <#{@title}> is changed"
    watch @, ['title', 'completed'], =>
      @publish CHANGED
      @parent.publish CHANGED

