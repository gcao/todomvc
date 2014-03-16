class @TodosView
  constructor: (@todos) ->
    FreeMart.request 'subscribe', TODOS_CHANGED, => @updateUI()

  filterBy: (filter) ->
    if ['all', 'active', 'completed'].indexOf(filter) < 0
      console.log "Filter is not supported: '#{filter}'"
      return

    @filter = filter

    @el.find('#filters a').removeClass('selected')
    @el.find("li.#{@filter} a").addClass('selected')
    @updateUI()

  updateUI: ->
    @updateChildren()
    @updateFooter()

  updateChildren: ->
    T(@childrenView()).render inside: @el.find('#todo-list')

  updateFooter: ->
    @el.find('#footer').toggle(@todos.length > 0)
    @updateRemaining()
    @updateCompleted()

  childrenView: ->
    @children = []
    for todo in @todos
      if (@filter is 'active' and todo.completed) or (@filter is 'completed' and not todo.completed)
        continue

      child = new TodoView(@todos, todo)
      @children.push child
      child.process()

  updateRemaining: ->
    @el.find('#todo-count strong').text(@todos.remaining())
    @el.find('#todo-count .plural').toggle(@todos.remaining() > 1)

  updateCompleted: ->
    @el.find('#clear-completed').toggle(@todos.completed() > 0)
    @el.find('.completed-value').text(@todos.completed())

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
            self.todos.push(new Todo(el.val().trim()))
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
        [ 'ul#todo-list'
          @childrenView()
        ]
      ]
      [ 'footer#footer'
        [ 'span#todo-count'
          [ 'strong', @todos.remaining() ]
          " item"
          [ 'span.plural'
            if @todos.remaining() <= 1 then display: 'none'
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
    ]

  render: (args...) ->
    T(@process()).render args...

