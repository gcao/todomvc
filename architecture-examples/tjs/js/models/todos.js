// Generated by CoffeeScript 1.7.1
(function() {
  var Todos,
    __slice = [].slice;

  this.Todos = Todos = function() {
    var arg, args, _i, _len;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (_i = 0, _len = args.length; _i < _len; _i++) {
      arg = args[_i];
      this.push(arg);
    }
  };

  Todos.prototype = new Array;

  Todos.prototype.remaining = function() {
    return this.filter(function(item) {
      return !item.completed;
    }).length;
  };

  Todos.prototype.completed = function() {
    return this.filter(function(item) {
      return item.completed;
    }).length;
  };

  Todos.prototype.toggleAllCompleted = function(completed) {
    var child, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      child = this[_i];
      _results.push(child.completed = completed);
    }
    return _results;
  };

  Todos.prototype.clearCompleted = function() {
    var i, _i, _ref, _results;
    _results = [];
    for (i = _i = _ref = this.length - 1; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
      if (this[i].completed) {
        _results.push(this.splice(i, 1));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

}).call(this);
