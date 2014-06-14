# Load initial data
@todos = FreeMart.request 'todos:load', 'todos'

# Save on changed event
todos.subscribe CHANGED, -> FreeMart.request('todos:save', 'todos', todos)

todosView = new TodosView(todos)
todosView.render inside: '#todoapp'

