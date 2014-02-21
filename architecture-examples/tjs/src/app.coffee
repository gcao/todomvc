# Load initial data
@todos = TodosResource.load('todos')
watch @, 'todos', (-> $.publish TODOS_CHANGED), 1

# Save on changes
$.subscribe TODOS_CHANGED, -> TodosResource.save('todos', todos)

# Render TODOs
todosView = new TodosView(todos)
todosView.render inside: '#todoapp'

# Router
router = new routes()
router.get '/'       ,       -> todosView.filterBy('all')
router.get '/:filter', (req) -> todosView.filterBy(req.params.filter)

