# Global constants
@ENTER_KEY = 13
@ESC_KEY   = 27

@TODO_CHANGED  = 'todo_changed'
@TODOS_CHANGED = 'todos_changed'


# Utility functions
@bind = (el, obj, props, options) ->
  if options.callback
    options.callback(el, obj, properties)

  tagName = $(el).get(0).tagName
  if tagName is 'INPUT'
    $(el).change -> obj[props] = $(this).val()

  callback = options.callback || ->
    if tagName is 'INPUT'
      $(el).val(obj[props])
    else
      $(el).text(obj[props])

  callback()
  watch obj, props, callback, 1

