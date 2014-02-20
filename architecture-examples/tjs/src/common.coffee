# Global constants
@ENTER_KEY = 13
@ESC_KEY   = 27

# Utility functions
@runThenWatch = (obj, properties, callback) ->
  callback()
  watch(obj, properties, callback)

