// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Todos = (function(_super) {
    __extends(Todos, _super);

    function Todos() {
      Todos.__super__.constructor.apply(this, arguments);
      Busbup.create(this);
      watch(this, '_data', (function(_this) {
        return function() {
          return _this.publish(CHANGED);
        };
      })(this));
    }

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
      var child, _i, _len, _ref, _results;
      _ref = this._data;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.completed = completed);
      }
      return _results;
    };

    Todos.prototype.clearCompleted = function() {
      var i, _i, _ref, _results;
      _results = [];
      for (i = _i = _ref = this._data.length - 1; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
        if (this._data[i].completed) {
          _results.push(this.splice(i, 1));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return Todos;

  })(this.Collection);

}).call(this);
