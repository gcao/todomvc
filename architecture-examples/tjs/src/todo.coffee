class @Todo
  constructor: (@parent, @title, @completed = false) ->

  watchIgnore: ['parent', 'el', 'input']

  close: ->
    return if not @el.hasClass('editing')
    @el.removeClass('editing')

    if trimmedValue = @input.val().trim()
      @title = trimmedValue

  render: ->
    self = @
    [ 'li'
      afterRender: (el) ->
        self.el = $(el)
        runThenWatch @, 'title', ->
          self.el.find('label').html(self.title)
        runThenWatch @, 'completed', ->
          self.el.toggleClass('completed', self.completed)
          self.el.find('.toggle').attr('checked', self.completed)
      [ '.view'
        dblclick: ->
          self.el.addClass('editing')
          self.input.focus()
        [ 'input.toggle'
          type: 'checkbox'
          click: -> self.completed = !self.completed
        ]
        [ 'label', @title ]
        [ 'button.destroy'
          click: -> self.parent.splice self.parent.indexOf(self), 1
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
            $(@).val(self.title)
            self.el.removeClass('editing')
        blur: -> self.close()
      ]
    ]

