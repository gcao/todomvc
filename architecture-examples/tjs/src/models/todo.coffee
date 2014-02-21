class @Todo
  constructor: (@title, @completed = false) ->
    watch @, ['title', 'completed'], -> $.publish TODOS_CHANGED

