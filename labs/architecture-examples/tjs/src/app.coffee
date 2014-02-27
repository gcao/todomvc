# Load initial data
@todos = TodosResource.load('todos')
# Save on changed event
$.subscribe TODOS_CHANGED, -> TodosResource.save('todos', todos)


# Trigger changed event on array change
watch @, 'todos', (-> $.publish TODOS_CHANGED), 1


# Render TODOs
todosView = new TodosView(todos)
todosView.render inside: '#todoapp'


# Router
router = new routes()
router.get '/'       ,       -> todosView.filterBy('all')
router.get '/:filter', (req) -> todosView.filterBy(req.params.filter)

