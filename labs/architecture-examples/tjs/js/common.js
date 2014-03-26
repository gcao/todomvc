// Generated by CoffeeScript 1.7.1
(function() {
  this.ENTER_KEY = 13;

  this.ESC_KEY = 27;

  this.CHANGED = 'changed';

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

}).call(this);
