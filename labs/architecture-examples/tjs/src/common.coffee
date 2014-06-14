# Global constants
@ENTER_KEY = 13
@ESC_KEY   = 27

@CHANGED   = 'changed'
@FILTER    = 'filter'

run = ->
  func = arguments[arguments.length - 1]
  func.apply(func, arguments)

#run 1, 2, (a, b, self) ->
#  console.log a, b, self

@filter   = 'all'
@filterBy = (filter) ->
  if ['all', 'active', 'completed'].indexOf(filter) < 0
    console.log "Filter is not supported: '#{filter}'"
  else
    @filter = filter
    Busbup.publish FILTER, filter

