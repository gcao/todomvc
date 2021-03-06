// Generated by CoffeeScript 1.7.1
(function() {
  this.Todo = (function() {
    function Todo(parent, title, completed) {
      this.parent = parent;
      this.title = title;
      this.completed = completed != null ? completed : false;
      Busbup.create(this);
      this.subscribe(CHANGED, (function(_this) {
        return function() {
          return console.log("Todo <" + _this.title + "> is changed");
        };
      })(this));
      watch(this, ['title', 'completed'], (function(_this) {
        return function() {
          _this.publish(CHANGED);
          return _this.parent.publish(CHANGED);
        };
      })(this));
    }

    return Todo;

  })();

}).call(this);
