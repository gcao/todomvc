// Generated by CoffeeScript 1.7.1
(function() {
  var callbacks, o,
    __slice = [].slice;

  this.ENTER_KEY = 13;

  this.ESC_KEY = 27;

  this.TODOS_CHANGED = 'todos_changed';

  this.bind = function(el, obj, props, options) {
    var callback, tagName;
    if (options.callback) {
      options.callback(el, obj, properties);
    }
    tagName = $(el).get(0).tagName;
    if (tagName === 'INPUT') {
      $(el).change(function() {
        return obj[props] = $(this).val();
      });
    }
    callback = options.callback || function() {
      if (tagName === 'INPUT') {
        return $(el).val(obj[props]);
      } else {
        return $(el).text(obj[props]);
      }
    };
    callback();
    return watch(obj, props, callback, 1);
  };

  o = $({});

  callbacks = {};

  FreeMart.register('subscribe', function(_, event, callback) {
    if (callbacks.hasOwnProperty(event)) {
      callbacks[event].push(callback);
    } else {
      callbacks[event] = [callback];
    }
    return o.on(event, callback);
  });

  FreeMart.register('unsubscribe', function(_, event, callback) {
    return o.off(event, callback);
  });

  FreeMart.register('publish', function() {
    var args, callback, event, i, myCallbacks, _, _i;
    _ = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    event = args[0];
    myCallbacks = callbacks[event];
    if (myCallbacks && myCallbacks.length > 0) {
      for (i = _i = myCallbacks.length - 1; _i >= 0; i = _i += -1) {
        callback = myCallbacks[i];
        if (callback.removeIf && callback.removeIf()) {
          myCallbacks.splice(i, 1);
          o.off(event, callback);
        }
      }
      if (myCallbacks.length > 0) {
        return o.trigger.apply(o, args);
      } else {
        return delete callbacks[event];
      }
    }
  });

}).call(this);