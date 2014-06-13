# Global constants
@ENTER_KEY = 13
@ESC_KEY   = 27

@CHANGED   = 'changed'

run = ->
  func = arguments[arguments.length - 1]
  func.apply(func, arguments)

#run 1, 2, (a, b, self) ->
#  console.log a, b, self

