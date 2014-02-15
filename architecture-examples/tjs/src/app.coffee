this.ENTER_KEY = 13
this.ESC_KEY   = 27

this.todos = Todos.load('todos')

T(todos.render()).render inside: '#todoapp'

watch this, 'todos', ->
  console.log 'watch this.todos handler'
  todos.save()
  todos.updateUI()

router = new routes()
router.get '/'       ,       -> todos.filterBy()
router.get '/:filter', (req) -> todos.filterBy(req.params.filter)

