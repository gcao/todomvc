@Todos = Todos = (args...) ->
  @push arg for arg in args
  Busbup.create(@)
  return

Todos.prototype = new Array

Todos.prototype.remaining = ->
  @filter (item) -> !item.completed
  .length

Todos.prototype.completed = ->
  @filter (item) -> item.completed
  .length

Todos.prototype.toggleAllCompleted = (completed) ->
  for child in @
    child.completed = completed

Todos.prototype.clearCompleted = ->
  for i in [@length - 1..0]
    if @[i].completed
      @splice i, 1

