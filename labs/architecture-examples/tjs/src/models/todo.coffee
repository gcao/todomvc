class @Todo
  constructor: (@parent, @title, @completed = false) ->
    Busbup.create(@)
    watch @, ['title', 'completed'], =>
      @publish TODO_CHANGED
      @parent.publish TODOS_CHANGED

