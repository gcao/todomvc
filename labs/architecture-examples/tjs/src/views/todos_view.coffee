class @TodosView
  constructor: (@todos) ->

  process: ->
    self = @
    [ 'header#header'
      afterRender: (el) -> self.el = $(el)

      [ 'h1', 'todos' ]
      [ 'input#new-todo'
        type: 'text'
        placeholder: 'What needs to be done?'
        autofocus: 'autofocus'
        keyup: (e) ->
          el = $(@)
          if e.which is ENTER_KEY && el.val().trim()
            self.todos.push(new Todo(self.todos, el.val().trim()))
            el.val('')
      ]
      [ 'section#main'
        [ 'input#toggle-all'
          type: 'checkbox'
          click: -> self.todos.toggleAllCompleted($(@).is(':checked'))
        ]
        [ 'label'
          for: 'toggle-all'
          'Mark all as complete'
        ]
        new TodosChildrenView(@todos).process()
      ]

      new TodosFooterView(@todos).process()
    ]

  render: (args...) ->
    T(@process()).render args...

class TodosChildrenView
  constructor: (@todos) ->
    @todos.subscribe CHANGED, =>
      T(@process()).render replace: @el

    Busbup.subscribe FILTER, =>
      T(@process()).render replace: @el

  process: ->
    self = @
    [ 'ul#todo-list'
      afterRender: (el) -> self.el = $(el)
      for todo in @todos.children()
        if (window.filter is 'active' and todo.completed) or (window.filter is 'completed' and not todo.completed)
          continue

        child = new TodoView(@todos, todo)
        child.process()
    ]

class @TodosFooterView
  constructor: (@todos) ->
    @todos.subscribe CHANGED, =>
      T(@process()).render replace: @el

    Busbup.subscribe FILTER, =>
      @setFilter(window.filter)

  setFilter: (filter) ->
    @el.find('#filters li a').removeClass('selected')
    @el.find("li.#{filter} a").addClass('selected')

  process: ->
    self = @
    [ 'footer#footer'
      afterRender: (el) ->
        self.el = $(el)
        self.setFilter(window.filter)
      if @todos.length() is 0
        style: display: 'none'
      [ 'span#todo-count'
        [ 'strong', @todos.remaining() ]
        " item"
        [ 'span.plural'
          if @todos.remaining() <= 1
            style: display: 'none'
          's'
        ]
        " left"
      ]
      [ 'ul#filters'
        [ 'li.all'
          [ 'a', href: '#/', 'All']
        ]
        [ 'li.active'
          [ 'a', href: '#/active', 'Active']
        ]
        [ 'li.completed'
          [ 'a', href: '#/completed', 'Completed']
        ]
      ]
      [ 'button#clear-completed'
        click: -> self.todos.clearCompleted()
        [ 'span'
          'Clear completed ('
          [ 'span.completed-value', @todos.completed() ]
          ')'
        ]
      ]
    ]

