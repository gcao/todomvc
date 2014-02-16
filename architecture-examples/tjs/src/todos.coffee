this.Todos = (args...) ->
  @push arg for arg in args
  return

Todos.prototype = new Array

Todos.prototype.watchIgnore = ['el']

Todos.prototype.serialize = ->
  data = []
  for item in @
    data.push title: item.title, completed: item.completed

  JSON.stringify(data)

Todos.deserialize = (str) ->
  result = new Todos

  if str
    if data = JSON.parse str
      for item in data
        result.push new Todo(result, item.title, item.completed)

  result

Todos.load = (id) ->
  todos = @deserialize localStorage.getItem(id)
  todos.id = id
  todos

Todos.prototype.save = ->
  localStorage.setItem(@id, @serialize())

Todos.prototype.remaining = ->
  @filter (item) -> !item.completed
  .length

Todos.prototype.completed = ->
  @filter (item) -> item.completed
  .length

Todos.prototype.toggleAllCompleted = (completed) ->
  for child in @
    child.completed = completed

Todos.prototype.clearCompleted = ->
  for i in [@length - 1..0]
    if @[i].completed
      @splice i, 1

Todos.prototype.filterBy = (@_filterBy) ->
  @updateChildren()

Todos.prototype.updateUI = ->
  if @el
    @updateChildren()
    @updateRemaining()
    @updateCompleted()

Todos.prototype.updateChildren = ->
  T(@renderChildren()).render inside: @el.find('#todo-list')

Todos.prototype.renderChildren = ->
  for todo in @
    if @_filterBy is 'active' and todo.completed
      continue
    else if @_filterBy is 'completed' and !todo.completed
      continue
    else
      todo.render()

Todos.prototype.updateRemaining = ->
  T(@renderRemaining()).render replace: @el.find('#todo-count')

Todos.prototype.renderRemaining = ->
  [ 'span#todo-count'
    [ 'strong', @remaining() ]
    " item#{if @remaining() > 1 then 's' else '' } left"
  ]

Todos.prototype.updateCompleted = ->
  T(@renderCompleted()).render inside: @el.find('#clear-completed span')

Todos.prototype.renderCompleted = ->
  [ 'span'
    'Clear completed '
    if @completed() > 0 then @completed() else ''
  ]

Todos.prototype.render = ->
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
          self.push(new Todo(self, el.val().trim()))
          el.val('')
    ]
    [ 'section#main'
      [ 'input#toggle-all'
        type: 'checkbox'
        click: -> self.toggleAllCompleted($(@).is(':checked'))
      ]
      [ 'label'
        for: 'toggle-all'
        'Mark all as complete'
      ]
      [ 'ul#todo-list'
        @renderChildren()
      ]
    ]
    [ 'footer#footer'
      @renderRemaining()
      [ 'ul#filters'
        [ 'li'
          [ 'a', href: '#/', 'All' ]
          [ 'a', href: '#/active', 'Active' ]
          [ 'a', href: '#/completed', 'Completed' ]
        ]
      ]
      [ 'button#clear-completed'
        click: -> self.clearCompleted()
        @renderCompleted()
      ]
    ]
  ]

