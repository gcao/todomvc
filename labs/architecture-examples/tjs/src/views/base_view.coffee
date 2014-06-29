class BaseView
  constructor: (@data, @children...) ->
    @isWidget = true
    @initialize()

  initialize: ->

  process: ->
    self = @
    result = @template()

    # Add afterRender callback to set @el
    callback = (el) -> self.el = el
    if result[1]and typeof result[1] is "object" and (result[1] not instanceof Array)
      if result[1].afterRender
        result[1].afterRender.unshift callback
      else
        result[1].afterRender = callback
    else
      result.splice(1, 0, afterRender: callback)

    result

  render: (args...) ->
    T(@process()).render args...

class @TodosView2 extends BaseView
  template: ->
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
            self.data.todos.push(new Todo(self.data.todos, el.val().trim()))
            el.val('')
      ]
      [ 'section#main'
        [ 'input#toggle-all'
          type: 'checkbox'
          click: -> self.data.todos.toggleAllCompleted($(@).is(':checked'))
        ]
        [ 'label'
          for: 'toggle-all'
          'Mark all as complete'
        ]
        new TodosChildrenView(todos: @data.todos, filter: @data.filter).process()
        #TodosChildrenView(todos: @data.todos, filter: @data.filter)
      ]

      new TodosFooterView(todos: @data.todos, filter: @data.filter).process()
    ]

class TodoView extends BaseView
  initialize: ->
    @data.todo.subscribe CHANGED, =>
      T(@process()).render replace: @el

  close: ->
    return if not @el.hasClass('editing')
    @el.removeClass('editing')

    if trimmedValue = @input.val().trim()
      @data.todo.title = trimmedValue

  template: ->
    self = @
    [ 'li'
      class: 'completed' if @data.todo.completed
      [ '.view'
        dblclick: ->
          self.el.addClass('editing')
          self.input.focus()
        [ "input.toggle"
          type: 'checkbox'
          checked: ('checked' if @data.todo.completed)
          click: -> self.data.todo.completed = !self.data.todo.completed
        ]
        [ 'label', @data.todo.title ]
        [ 'button.destroy'
          click: -> self.data.todos.splice self.data.todos.indexOf(self.data.todo), 1
        ]
      ]
      [ 'input.edit'
        afterRender: (el) -> self.input = $(el)
        type: 'text'
        keypress: (e) ->
          if e.which is ENTER_KEY
            self.close()
        keydown: (e) ->
          if e.which is ESC_KEY
            $(@).val(self.data.todo.title)
            self.el.removeClass('editing')
        blur: -> self.close()
      ]
    ]

class TodosChildrenView extends BaseView
  initialize: ->
    @data.todos.subscribe CHANGED, =>
      T(@process()).render replace: @el

    Busbup.subscribe FILTER, (_, filter) =>
      @data.filter = filter
      T(@process()).render replace: @el

  template: ->
    [ 'ul#todo-list'
      for todo in @data.todos.children()
        if (@data.filter is 'active' and todo.completed) or (@data.filter is 'completed' and not todo.completed)
          continue

        new TodoView(todos: @data.todos, todo: todo).process()
    ]

class TodosFooterView extends BaseView
  initialize: ->
    @data.todos.subscribe CHANGED, =>
      T(@process()).render replace: @el

    Busbup.subscribe FILTER, (_, filter) =>
      @data.filter = filter

  filters: ->
    [
      name: 'all'
      label: 'All'
      selected: @data.filter is 'all'
    ,
      name: 'active'
      label: 'Active'
      selected: @data.filter is 'active'
    ,
      name: 'completed'
      label: 'Completed'
      selected: @data.filter is 'completed'
    ]

  template: ->
    self = @
    [ 'footer#footer'
      if @data.todos.length() is 0
        style: display: 'none'
      [ 'span#todo-count'
        [ 'strong', @data.todos.remaining() ]
        " item"
        [ 'span.plural'
          if @data.todos.remaining() <= 1
            style: display: 'none'
          's'
        ]
        " left"
      ]
      [ 'ul#filters'
        new FooterFilterLink(filter).process() for filter in @filters()
      ]
      [ 'button#clear-completed'
        if @data.todos.completed() is 0
          style: display: 'none'
        click: -> self.data.todos.clearCompleted()
        [ 'span'
          'Clear completed ('
          [ 'span.completed-value', @data.todos.completed() ]
          ')'
        ]
      ]
    ]

class FooterFilterLink extends BaseView
  initialize: ->
    Busbup.subscribe FILTER, (_, filter) =>
      @data.selected = filter is @data.name
      T(@process()).render replace: @el

  template: ->
    [ "li.#{@data.name}"
      [ 'a'
        class: 'selected' if @data.selected
        href: "#/#{@data.name}"
        @data.label
      ]
    ]

