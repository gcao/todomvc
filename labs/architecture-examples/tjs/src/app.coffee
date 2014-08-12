todos = undefined
getTodos = ->
  if not todos
    todos = TodosResource.load('todos')
    # Save on change
    todos.subscribe CHANGED, -> TodosResource.save('todos', todos)

  todos

todosView = undefined
showTodos = (todos, filter) ->
  if todosView
    Busbup.publish FILTER, filter
  else
    #todosView = new TodosView(todos, filter)
    todosView = TodosView2(todos: todos, filter: filter)
    todosView.render inside: '#todoapp'

isValidFilter = (filter) ->
  ['all', 'active', 'completed'].indexOf(filter) >= 0


# Routes and handlers
router = new routes()

router.get '/', -> showTodos(getTodos(), 'all')

router.get '/:filter', (req) ->
  filter = req.params.filter
  if isValidFilter filter
    showTodos(getTodos(), filter)
  else
    console.log "Filter is not supported: '#{filter}'"


# Trigger default route when location.hash is empty
window.location.hash = "#/" if location.hash is ""

