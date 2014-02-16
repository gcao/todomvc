@ENTER_KEY = 13
@ESC_KEY   = 27

@todos = todos = TodosResource.load('todos')

T(@todos.render()).render inside: '#todoapp'

watch @, 'todos', ->
  TodosResource.save('todos', todos)
  todos.updateUI()

router = new routes()
router.get '/'       ,       -> todos.filterBy('all')
router.get '/:filter', (req) -> todos.filterBy(req.params.filter)

