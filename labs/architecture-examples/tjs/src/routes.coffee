# TODO: trigger default route when location.hash is empty
# TODO: start application from route callbacks
location.hash = "#/" if location.hash is ""

FreeMart.register '/'       ,             -> window.filterBy('all')
FreeMart.register '/:filter', (_, filter) -> window.filterBy(filter)

# Experimenting with before/after filters
FreeMart.register /\/.*/, (options) ->
  console.log "Before #{options.$key}"
  result = FreeMart.request arguments...
  console.log " After #{options.$key}"
  result

router = new routes()
router.get '/'       ,       -> FreeMart.request '/'
router.get '/:filter', (req) -> FreeMart.request '/:filter', req.params.filter

