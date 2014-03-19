class @Todo
  constructor: (@title, @completed = false) ->
    watch @, ['title', 'completed'], -> Busbup.publish TODOS_CHANGED

