@Todos = Todos = (args...) ->
  @push arg for arg in args
  return

Todos.prototype = new Array

Todos.prototype.watchIgnore = ['el']

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

Todos.prototype.filterBy = (filter) ->
  if ['all', 'active', 'completed'].indexOf(filter) >= 0
    @_filter = filter
  else
    console.log "Filter is not supported: '#{filter}'"
    return

  @el.find('#filters a').removeClass('selected')
  @el.find("li.#{@_filter} a").addClass('selected')

  @updateUI()

Todos.prototype.updateUI = ->
  @updateChildren()
  @updateFooter()

Todos.prototype.updateChildren = ->
  T(@renderChildren()).render inside: @el.find('#todo-list')

Todos.prototype.updateFooter = ->
  @el.find('#footer').toggle(@length > 0)
  @updateRemaining()
  @updateCompleted()

Todos.prototype.renderChildren = ->
  for todo in @
    if @_filter is 'active' and todo.completed
      continue
    else if @_filter is 'completed' and !todo.completed
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
  @el.find('#clear-completed').toggle(@completed() > 0)
  T(@renderCompleted()).render inside: @el.find('#clear-completed span')

Todos.prototype.renderCompleted = ->
  [ 'span'
    'Clear completed '
    @completed()
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
        click: -> self.clearCompleted()
        @renderCompleted()
      ]
    ]
  ]

