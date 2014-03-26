class @Todo
  constructor: (@parent, @title, @completed = false) ->
    Busbup.create(@)
    watch @, ['title', 'completed'], =>
      @publish CHANGED
      @parent.publish CHANGED

