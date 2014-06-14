// Generated by CoffeeScript 1.7.1
(function() {
  var router, todosView;

  this.todos = FreeMart.request('todos:load', 'todos');

  todos.subscribe(CHANGED, function() {
    return FreeMart.request('todos:save', 'todos', todos);
  });

  todosView = new TodosView(todos);

  todosView.render({
    inside: '#todoapp'
  });

  FreeMart.register('/', function() {
    return window.filterBy('all');
  });

  FreeMart.register('/:filter', function(_, filter) {
    return window.filterBy(filter);
  });

  FreeMart.register(/\/.*/, function(options) {
    var result;
    console.log("Before " + options.$key);
    result = FreeMart.request.apply(FreeMart, arguments);
    console.log(" After " + options.$key);
    return result;
  });

  router = new routes();

  router.get('/', function() {
    return FreeMart.request('/');
  });

  router.get('/:filter', function(req) {
    return FreeMart.request('/:filter', req.params.filter);
  });

}).call(this);
