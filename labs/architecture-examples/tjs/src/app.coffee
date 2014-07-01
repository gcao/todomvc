todos = undefined
getTodos = ->
  if todos
    todos
  else
    todos = FreeMart.request 'todos:load', 'todos'
    # Save on change
    todos.subscribe CHANGED, -> FreeMart.request('todos:save', 'todos', todos)
    todos

todosView = undefined
showTodos = (todos, filter) ->
  if todosView
    Busbup.publish FILTER, filter
  else
    #todosView = new TodosView(todos, filter)
    todosView = TodosView2 todos: todos, filter: filter
    todosView.render inside: '#todoapp'

isValidFilter = (filter) ->
  ['all', 'active', 'completed'].indexOf(filter) >= 0


# Routes and handlers
FreeMart.register '/', -> 
  showTodos(getTodos(), 'all')

FreeMart.register '/:filter', (_, filter) -> 
  if isValidFilter filter
    showTodos(getTodos(), filter)
  else
    console.log "Filter is not supported: '#{filter}'"

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

