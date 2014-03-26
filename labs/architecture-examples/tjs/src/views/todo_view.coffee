class @TodoView
  constructor: (@todos, @todo) ->
    @todo.subscribe CHANGED, => @updateView()

  updateView: ->
    @el.find('label').html(@todo.title)
    @el.toggleClass('completed', @todo.completed)
    @el.find('.toggle').attr('checked', @todo.completed)

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
        self.updateView()
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

