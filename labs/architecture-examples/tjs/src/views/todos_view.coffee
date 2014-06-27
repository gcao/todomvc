class @TodosView
  constructor: (@todos, @filter) ->
    console.log 'TodosView.constructor'

  process: ->
    self = @
    [ 'header#header'
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
        new TodosChildrenView(@todos, @filter).process()
      ]

      new TodosFooterView(@todos, @filter).process()
    ]

  render: (args...) ->
    T(@process()).render args...

class TodosChildrenView
  constructor: (@todos, @filter) ->
    @todos.subscribe CHANGED, =>
      T(@process()).render replace: @el

    Busbup.subscribe FILTER, (_, filter) =>
      @filter = filter
      T(@process()).render replace: @el

  process: ->
    self = @
    [ 'ul#todo-list'
      afterRender: (el) -> self.el = $(el)
      for todo in @todos.children()
        if (@filter is 'active' and todo.completed) or (@filter is 'completed' and not todo.completed)
          continue

        new TodoView(@todos, todo).process()
    ]

class TodosFooterView
  constructor: (@todos, @filter) ->
    Busbup.subscribe FILTER, (_, filter) =>
      @filter = filter

  filters: ->
    [
      name: 'all'
      label: 'All'
      selected: @filter is 'all'
    ,
      name: 'active'
      label: 'Active'
      selected: @filter is 'active'
    ,
      name: 'completed'
      label: 'Completed'
      selected: @filter is 'completed'
    ]

  process: ->
    self = @
    [ 'footer#footer'
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
        new FooterFilterLink(filter).process() for filter in @filters()
      ]
      [ 'button#clear-completed'
        if @todos.completed() is 0
          style: display: 'none'
        click: -> self.todos.clearCompleted()
        [ 'span'
          'Clear completed ('
          [ 'span.completed-value', @todos.completed() ]
          ')'
        ]
      ]
    ]

class FooterFilterLink
  constructor: (@filter) ->
    Busbup.subscribe FILTER, (_, filter) =>
      @filter.selected = filter is @filter.name
      T(@process()).render replace: @el

  process: ->
    self = @
    [ 'li'
      afterRender: (el) -> self.el = $(el)
      class: @filter.name
      [ 'a'
        class: 'selected' if @filter.selected
        href: "#/#{@filter.name}"
        @filter.label
      ]
    ]

