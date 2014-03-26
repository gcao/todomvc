// Generated by CoffeeScript 1.7.1
(function() {
  var BusbupInternal, VERSION,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  VERSION = '0.1.0';

  BusbupInternal = (function() {
    function BusbupInternal() {
      this.unsubscribe = __bind(this.unsubscribe, this);
      this.publish = __bind(this.publish, this);
      this.subscribe = __bind(this.subscribe, this);
      this.callbacks = {};
    }

    BusbupInternal.prototype.version = VERSION;

    BusbupInternal.prototype.subscribe = function(event, callback) {
      if (this.callbacks.hasOwnProperty(event)) {
        return this.callbacks[event].push(callback);
      } else {
        return this.callbacks[event] = [callback];
      }
    };

    BusbupInternal.prototype.publish = function() {
      var args, callback, event, i, myCallbacks, _i, _j, _len, _results;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      myCallbacks = this.callbacks[event];
      if (myCallbacks && myCallbacks.length > 0) {
        for (i = _i = myCallbacks.length - 1; _i >= 0; i = _i += -1) {
          callback = myCallbacks[i];
          if (callback.removeIf && callback.removeIf()) {
            myCallbacks.splice(i, 1);
          }
        }
        if (myCallbacks.length > 0) {
          _results = [];
          for (_j = 0, _len = myCallbacks.length; _j < _len; _j++) {
            callback = myCallbacks[_j];
            _results.push(callback.apply(null, [event].concat(__slice.call(args))));
          }
          return _results;
        } else {
          return delete callbacks[event];
        }
      }
    };

    BusbupInternal.prototype.unsubscribe = function(event, callback) {
      var index;
      if (this.callbacks[event]) {
        index = this.callbacks[event].indexOf(callback);
        if (index >= 0) {
          this.callbacks[event].splice(index, 1);
        }
        if (this.callbacks[event].length === 0) {
          return delete this.callbacks[event];
        }
      }
    };

    return BusbupInternal;

  })();

  this.Busbup = new BusbupInternal;

  this.Busbup.create = function(owner) {
    var instance;
    instance = new BusbupInternal;
    if (owner) {
      owner.subscribe = instance.subscribe;
      owner.publish = instance.publish;
      owner.unsubscribe = instance.unsubscribe;
    }
    return instance;
  };

}).call(this);
