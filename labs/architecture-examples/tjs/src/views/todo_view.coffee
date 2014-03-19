class @TodoView
  constructor: (@todos, @todo) ->

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

        callback = -> console.log TODOS_CHANGED + ' ' + self.todo.title
        callback.removeIf = -> not $.contains(document.body, el)
        subscribe TODOS_CHANGED, callback

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

