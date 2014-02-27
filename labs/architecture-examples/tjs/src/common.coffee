# Global constants
@ENTER_KEY = 13
@ESC_KEY   = 27

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


# A tiny pubsub
# https://github.com/cowboy/jquery-tiny-pubsub/blob/master/src/tiny-pubsub.js
o = $({})
$.subscribe   = -> o.on     .apply o, arguments; return
$.unsubscribe = -> o.off    .apply o, arguments; return
$.publish     = -> o.trigger.apply o, arguments; return

