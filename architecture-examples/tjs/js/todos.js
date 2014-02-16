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

  Todos.prototype.watchIgnore = ['el'];

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

  Todos.prototype.filterBy = function(_filterBy) {
    this._filterBy = _filterBy;
    this.el.find('#filters a').removeClass('selected');
    if (this._filterBy === 'active') {
      this.el.find('li.active a').addClass('selected');
    } else if (this._filterBy === 'completed') {
      this.el.find('li.completed a').addClass('selected');
    } else if (!this._filterBy) {
      this.el.find('li.all a').addClass('selected');
    }
    return this.updateUI();
  };

  Todos.prototype.updateUI = function() {
    this.updateChildren();
    return this.updateFooter();
  };

  Todos.prototype.updateChildren = function() {
    return T(this.renderChildren()).render({
      inside: this.el.find('#todo-list')
    });
  };

  Todos.prototype.updateFooter = function() {
    this.el.find('#footer').toggle(this.length > 0);
    this.updateRemaining();
    return this.updateCompleted();
  };

  Todos.prototype.renderChildren = function() {
    var todo, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      todo = this[_i];
      if (this._filterBy === 'active' && todo.completed) {
        continue;
      } else if (this._filterBy === 'completed' && !todo.completed) {
        continue;
      } else {
        _results.push(todo.render());
      }
    }
    return _results;
  };

  Todos.prototype.updateRemaining = function() {
    return T(this.renderRemaining()).render({
      replace: this.el.find('#todo-count')
    });
  };

  Todos.prototype.renderRemaining = function() {
    return ['span#todo-count', ['strong', this.remaining()], " item" + (this.remaining() > 1 ? 's' : '') + " left"];
  };

  Todos.prototype.updateCompleted = function() {
    this.el.find('#clear-completed').toggle(this.completed() > 0);
    return T(this.renderCompleted()).render({
      inside: this.el.find('#clear-completed span')
    });
  };

  Todos.prototype.renderCompleted = function() {
    return ['span', 'Clear completed ', this.completed()];
  };

  Todos.prototype.render = function() {
    var self;
    self = this;
    return [
      'header#header', {
        afterRender: function(el) {
          return self.el = $(el);
        }
      }, ['h1', 'todos'], [
        'input#new-todo', {
          type: 'text',
          placeholder: 'What needs to be done?',
          autofocus: 'autofocus',
          keyup: function(e) {
            var el;
            el = $(this);
            if (e.which === ENTER_KEY && el.val().trim()) {
              self.push(new Todo(self, el.val().trim()));
              return el.val('');
            }
          }
        }
      ], [
        'section#main', [
          'input#toggle-all', {
            type: 'checkbox',
            click: function() {
              return self.toggleAllCompleted($(this).is(':checked'));
            }
          }
        ], [
          'label', {
            "for": 'toggle-all'
          }, 'Mark all as complete'
        ], ['ul#todo-list', this.renderChildren()]
      ], [
        'footer#footer', this.renderRemaining(), [
          'ul#filters', [
            'li.all', [
              'a', {
                href: '#/'
              }, 'All'
            ]
          ], [
            'li.active', [
              'a', {
                href: '#/active'
              }, 'Active'
            ]
          ], [
            'li.completed', [
              'a', {
                href: '#/completed'
              }, 'Completed'
            ]
          ]
        ], [
          'button#clear-completed', {
            click: function() {
              return self.clearCompleted();
            }
          }, this.renderCompleted()
        ]
      ]
    ];
  };

}).call(this);
