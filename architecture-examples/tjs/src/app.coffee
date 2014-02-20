# Load initial data
@todos = TodosResource.load('todos')

# Render TODOs
todosView = new TodosView(@todos)
todosView.render inside: '#todoapp'

# Respond to changes
watch @, 'todos', ->
  TodosResource.save('todos', todos)
  todosView.updateUI()

# Router
router = new routes()
router.get '/'       ,       -> todosView.filterBy('all')
router.get '/:filter', (req) -> todosView.filterBy(req.params.filter)

