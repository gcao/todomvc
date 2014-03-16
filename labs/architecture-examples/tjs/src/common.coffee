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
o         = $({})
callbacks = {}

FreeMart.register 'subscribe', (_, event, callback) ->
  if callbacks.hasOwnProperty(event)
    callbacks[event].push callback
  else
    callbacks[event] = [callback]

  o.on event, callback

FreeMart.register 'unsubscribe', (_, event, callback) ->
  o.off event, callback

FreeMart.register 'publish', (_, args...) ->
  # check callbacks before triggering the event
  event       = args[0]
  myCallbacks = callbacks[event]

  if myCallbacks and myCallbacks.length > 0
    for callback, i in myCallbacks by -1
      if callback.removeIf and callback.removeIf()
        myCallbacks.splice(i, 1)
        o.off event, callback

    if myCallbacks.length > 0
      o.trigger args...
    else
      delete callbacks[event]

