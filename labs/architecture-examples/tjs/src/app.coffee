# Load initial data
@todos = FreeMart.request 'todos:load', 'todos'

# Save on changed event
FreeMart.request 'subscribe', TODOS_CHANGED, -> FreeMart.request('todos:save', 'todos', todos)


# Trigger changed event on array change
watch @, 'todos', (-> FreeMart.request 'publish', TODOS_CHANGED), 1


# Render TODOs
todosView = new TodosView(todos)
todosView.render inside: '#todoapp'


# Router
router = new routes()
router.get '/'       ,       -> todosView.filterBy('all')
router.get '/:filter', (req) -> todosView.filterBy(req.params.filter)

