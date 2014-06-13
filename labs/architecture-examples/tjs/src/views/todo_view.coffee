class @TodoView
  constructor: (@todos, @todo) ->
    @todo.subscribe CHANGED, =>
      T(@process()).render replace: @el

  close: ->
    return if not @el.hasClass('editing')
    @el.removeClass('editing')

    if trimmedValue = @input.val().trim()
      @todo.title = trimmedValue

  process: ->
    self = @
    [ 'li'
      class: ('completed' if @todo.completed)
      afterRender: (el) -> self.el = $(el)
      [ '.view'
        dblclick: ->
          self.el.addClass('editing')
          self.input.focus()
        [ "input.toggle"
          type: 'checkbox'
          checked: ('checked' if @todo.completed)
          click: -> self.todo.completed = !self.todo.completed
        ]
        [ 'label', @todo.title ]
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

