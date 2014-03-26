// Generated by CoffeeScript 1.7.1
(function() {
  this.Collection = (function() {
    var method, methods, self, _i, _len;

    function Collection() {
      var item, _i, _len;
      this._data = [];
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        item = arguments[_i];
        this._data.push(item);
      }
    }

    Collection.prototype.get = function(i) {
      return this._data[i];
    };

    Collection.prototype.children = function() {
      return this._data;
    };

    Collection.prototype.length = function() {
      return this._data.length;
    };

    self = Collection;

    methods = Object.getOwnPropertyNames(Array.prototype);

    for (_i = 0, _len = methods.length; _i < _len; _i++) {
      method = methods[_i];
      if (['constructor', 'length'].indexOf(method) < 0) {
        (function(m) {
          return self.prototype[m] = function() {
            var _ref;
            return (_ref = this._data)[m].apply(_ref, arguments);
          };
        })(method);
      }
    }

    return Collection;

  })();

}).call(this);
