# Load initial data
@todos = FreeMart.request 'todos:load', 'todos'

# Save on changed event
todos.subscribe CHANGED, -> FreeMart.request('todos:save', 'todos', todos)


# Render TODOs
todosView = new TodosView(todos)
todosView.render inside: '#todoapp'


# Router
FreeMart.register '/'       ,             -> window.filterBy('all')
FreeMart.register '/:filter', (_, filter) -> window.filterBy(filter)

# Experimenting with before/after filters
FreeMart.register /\/.*/, (options) ->
  console.log "Before #{options.$key}"
  result = FreeMart.request arguments...
  console.log " After #{options.$key}"
  result

router = new routes()
router.get '/'       ,       -> FreeMart.request '/'
router.get '/:filter', (req) -> FreeMart.request '/:filter', req.params.filter

