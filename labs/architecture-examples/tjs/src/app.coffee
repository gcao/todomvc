# Load initial data
@todos = FreeMart.request 'todos:load', 'todos'

# Save on changed event
Busbup.subscribe TODOS_CHANGED, -> FreeMart.request('todos:save', 'todos', todos)


# Trigger changed event on array change
watch @, 'todos', (-> Busbup.publish TODOS_CHANGED), 1


# Render TODOs
todosView = new TodosView(todos)
todosView.render inside: '#todoapp'


# Router
FreeMart.register '/'       ,             -> todosView.filterBy('all')
FreeMart.register '/:filter', (_, filter) -> todosView.filterBy(filter)

# Experimenting with before/after filters
FreeMart.register /\/.*/, (options) ->
  console.log "Before #{options.$key}"
  result = FreeMart.request arguments...
  console.log " After #{options.$key}"
  result

router = new routes()
router.get '/'       ,       -> FreeMart.request '/'
router.get '/:filter', (req) -> FreeMart.request '/:filter', req.params.filter

