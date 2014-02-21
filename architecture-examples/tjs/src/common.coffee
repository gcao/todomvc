# Global constants
@ENTER_KEY = 13
@ESC_KEY   = 27

# Events
@TODOS_CHANGED = 'todos_changed'

# Utility functions
@runThenWatch = (obj, properties, callback) ->
  callback()
  watch(obj, properties, callback)

# A tiny pubsub
# https://github.com/cowboy/jquery-tiny-pubsub/blob/master/src/tiny-pubsub.js
o = $({})
$.subscribe   = -> o.on     .apply o, arguments; return
$.unsubscribe = -> o.off    .apply o, arguments; return
$.publish     = -> o.trigger.apply o, arguments; return

