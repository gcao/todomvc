class @TodoView
  constructor: (@todos, @todo) ->
    $.subscribe TODOS_CHANGED, @todosChangedHandler

  destroy: ->
    $.unsubscribe TODOS_CHANGED, @todosChangedHandler

  todosChangedHandler: =>
    console.log TODOS_CHANGED + ' ' + @todo.title

  close: ->
    return if not @el.hasClass('editing')
    @el.removeClass('editing')

    if trimmedValue = @input.val().trim()
      @todo.title = trimmedValue

  process: ->
    self = @
    [ 'li'
      afterRender: (el) ->
        self.el = $(el)
        self.el.find('label').html(self.todo.title)
        self.el.toggleClass('completed', self.todo.completed)
        self.el.find('.toggle').attr('checked', self.todo.completed)
      [ '.view'
        dblclick: ->
          self.el.addClass('editing')
          self.input.focus()
        [ 'input.toggle'
          type: 'checkbox'
          click: -> self.todo.completed = !self.todo.completed
        ]
        [ 'label', @title ]
        [ 'button.destroy'
          click: -> self.todos.splice self.todos.indexOf(self.todo), 1
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
            $(@).val(self.todo.title)
            self.el.removeClass('editing')
        blur: -> self.close()
      ]
    ]

