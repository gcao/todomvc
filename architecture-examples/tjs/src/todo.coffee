class @Todo
  constructor: (@parent, @title, @completed) ->
    self = @
    watch @, 'title', ->
      self.el.find('label').html(self.title)
    watch @, 'completed', ->
      self.updateStatus()

  watchIgnore: ['parent', 'el', 'input']

  updateStatus: ->
    if @completed
      @el.find('.toggle').attr('checked', 'checked')
    else
      @el.find('.toggle').removeAttr('checked')

  close: ->
    unless @el.hasClass('editing')
      return

    trimmedValue = @input.val().trim()
    if trimmedValue
      @title = trimmedValue

    @el.removeClass('editing')

  render: ->
    self = @
    [ 'li'
      afterRender: (el) -> self.el = $(el)
      [ '.view'
        dblclick: ->
          self.el.addClass('editing')
          self.input.focus()
        [ 'input.toggle'
          type: 'checkbox'
          if @completed
            checked: 'checked'
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
            self.el.removeClass('editing')
        blur: -> self.close()
      ]
    ]

