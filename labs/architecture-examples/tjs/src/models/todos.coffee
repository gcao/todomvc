class @Todos extends @Collection
  constructor: ->
    super
    Busbup.create(@)
    @subscribe CHANGED, -> console.log 'Todos are changed'
    watch @, '_data', => @publish CHANGED

  remaining: ->
    @filter (item) -> !item.completed
    .length

  completed: ->
    @filter (item) -> item.completed
    .length

  toggleAllCompleted: (completed) ->
    for child in @_data
      child.completed = completed

  clearCompleted: ->
    for i in [@_data.length - 1..0]
      if @_data[i].completed
        @splice i, 1

