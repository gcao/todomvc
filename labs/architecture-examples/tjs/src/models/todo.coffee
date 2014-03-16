class @Todo
  constructor: (@title, @completed = false) ->
    watch @, ['title', 'completed'], -> FreeMart.request 'publish', TODOS_CHANGED

