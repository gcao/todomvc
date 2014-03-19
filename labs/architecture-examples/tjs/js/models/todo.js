// Generated by CoffeeScript 1.7.1
(function() {
  this.Todo = (function() {
    function Todo(title, completed) {
      this.title = title;
      this.completed = completed != null ? completed : false;
      watch(this, ['title', 'completed'], function() {
        return Busbup.publish(TODOS_CHANGED);
      });
    }

    return Todo;

  })();

}).call(this);
