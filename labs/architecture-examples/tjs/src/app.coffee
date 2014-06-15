@filter   = 'all'
filterBy = (_filter) ->
  if ['all', 'active', 'completed'].indexOf(_filter) < 0
    console.log "Filter is not supported: '#{_filter}'"
  else
    @filter = _filter
    Busbup.publish FILTER, @filter

loadTodos = ->
  todos = FreeMart.request 'todos:load', 'todos'
  # Save on change
  todos.subscribe CHANGED, -> FreeMart.request('todos:save', 'todos', todos)
  todos

todosView = undefined
showTodos = ->
  unless todosView
    todosView = new TodosView(loadTodos())
    todosView.render inside: '#todoapp'

FreeMart.register '/', -> 
  filterBy('all')
  showTodos()

FreeMart.register '/:filter', (_, filter) -> 
  filterBy(filter)
  showTodos()

# Experimenting with before/after filters
FreeMart.register /\/.*/, (options) ->
  console.log "Before #{options.$key}"
  result = FreeMart.request arguments...
  console.log " After #{options.$key}"
  result

router = new routes()
router.get '/'       ,       -> FreeMart.request '/'
router.get '/:filter', (req) -> FreeMart.request '/:filter', req.params.filter

# Trigger default route when location.hash is empty
FreeMart.request '/' if location.hash is ""

