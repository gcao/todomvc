// Generated by CoffeeScript 1.7.1
(function() {
  var BaseView, FooterFilterLink, TodoView, TodosChildrenView, TodosFooterView,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BaseView = (function() {
    function BaseView() {
      var children, data;
      data = arguments[0], children = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      this.data = data;
      this.children = children;
      this.isWidget = true;
      this.initialize();
    }

    BaseView.prototype.initialize = function() {};

    return BaseView;

  })();

  this.TodosView2 = (function(_super) {
    __extends(TodosView2, _super);

    function TodosView2() {
      return TodosView2.__super__.constructor.apply(this, arguments);
    }

    TodosView2.prototype.process = function() {
      var self;
      self = this;
      return [
        'header#header', ['h1', 'todos'], [
          'input#new-todo', {
            type: 'text',
            placeholder: 'What needs to be done?',
            autofocus: 'autofocus',
            keyup: function(e) {
              var el;
              el = $(this);
              if (e.which === ENTER_KEY && el.val().trim()) {
                self.data.todos.push(new Todo(self.data.todos, el.val().trim()));
                return el.val('');
              }
            }
          }
        ], [
          'section#main', [
            'input#toggle-all', {
              type: 'checkbox',
              click: function() {
                return self.data.todos.toggleAllCompleted($(this).is(':checked'));
              }
            }
          ], [
            'label', {
              "for": 'toggle-all'
            }, 'Mark all as complete'
          ], new TodosChildrenView({
            todos: this.data.todos,
            filter: this.data.filter
          }).process()
        ], new TodosFooterView({
          todos: this.data.todos,
          filter: this.data.filter
        }).process()
      ];
    };

    TodosView2.prototype.render = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = T(this.process())).render.apply(_ref, args);
    };

    return TodosView2;

  })(BaseView);

  TodoView = (function(_super) {
    __extends(TodoView, _super);

    function TodoView() {
      return TodoView.__super__.constructor.apply(this, arguments);
    }

    TodoView.prototype.initialize = function() {
      return this.data.todo.subscribe(CHANGED, (function(_this) {
        return function() {
          return T(_this.process()).render({
            replace: _this.el
          });
        };
      })(this));
    };

    TodoView.prototype.close = function() {
      var trimmedValue;
      if (!this.el.hasClass('editing')) {
        return;
      }
      this.el.removeClass('editing');
      if (trimmedValue = this.input.val().trim()) {
        return this.data.todo.title = trimmedValue;
      }
    };

    TodoView.prototype.process = function() {
      var self;
      self = this;
      return [
        'li', {
          "class": (this.todo.completed ? 'completed' : void 0),
          afterRender: function(el) {
            return self.el = $(el);
          }
        }, [
          '.view', {
            dblclick: function() {
              self.el.addClass('editing');
              return self.input.focus();
            }
          }, [
            "input.toggle", {
              type: 'checkbox',
              checked: (this.todo.completed ? 'checked' : void 0),
              click: function() {
                return self.data.todo.completed = !self.data.todo.completed;
              }
            }
          ], ['label', this.todo.title], [
            'button.destroy', {
              click: function() {
                return self.data.todos.splice(self.data.todos.indexOf(self.data.todo), 1);
              }
            }
          ]
        ], [
          'input.edit', {
            afterRender: function(el) {
              return self.input = $(el);
            },
            type: 'text',
            keypress: function(e) {
              if (e.which === ENTER_KEY) {
                return self.close();
              }
            },
            keydown: function(e) {
              if (e.which === ESC_KEY) {
                $(this).val(self.data.todo.title);
                return self.el.removeClass('editing');
              }
            },
            blur: function() {
              return self.close();
            }
          }
        ]
      ];
    };

    return TodoView;

  })(BaseView);

  TodosChildrenView = (function(_super) {
    __extends(TodosChildrenView, _super);

    function TodosChildrenView() {
      return TodosChildrenView.__super__.constructor.apply(this, arguments);
    }

    TodosChildrenView.prototype.initialize = function() {
      this.todos.subscribe(CHANGED, (function(_this) {
        return function() {
          return T(_this.process()).render({
            replace: _this.el
          });
        };
      })(this));
      return Busbup.subscribe(FILTER, (function(_this) {
        return function(_, filter) {
          _this.data.filter = filter;
          return T(_this.process()).render({
            replace: _this.el
          });
        };
      })(this));
    };

    TodosChildrenView.prototype.process = function() {
      var self, todo;
      self = this;
      return [
        'ul#todo-list', {
          afterRender: function(el) {
            return self.el = $(el);
          }
        }, (function() {
          var _i, _len, _ref, _results;
          _ref = this.data.todos.children();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            todo = _ref[_i];
            if ((this.data.filter === 'active' && todo.completed) || (this.filter === 'completed' && !todo.completed)) {
              continue;
            }
            _results.push(new TodoView({
              todos: this.data.todos,
              todo: todo
            }).process());
          }
          return _results;
        }).call(this)
      ];
    };

    return TodosChildrenView;

  })(BaseView);

  TodosFooterView = (function(_super) {
    __extends(TodosFooterView, _super);

    function TodosFooterView() {
      return TodosFooterView.__super__.constructor.apply(this, arguments);
    }

    TodosFooterView.prototype.initialize = function() {
      return Busbup.subscribe(FILTER, (function(_this) {
        return function(_, filter) {
          return _this.data.filter = filter;
        };
      })(this));
    };

    TodosFooterView.prototype.filters = function() {
      return [
        {
          name: 'all',
          label: 'All',
          selected: this.data.filter === 'all'
        }, {
          name: 'active',
          label: 'Active',
          selected: this.data.filter === 'active'
        }, {
          name: 'completed',
          label: 'Completed',
          selected: this.data.filter === 'completed'
        }
      ];
    };

    TodosFooterView.prototype.process = function() {
      var filter, self;
      self = this;
      return [
        'footer#footer', this.data.todos.length() === 0 ? {
          style: {
            display: 'none'
          }
        } : void 0, [
          'span#todo-count', ['strong', this.data.todos.remaining()], " item", [
            'span.plural', this.data.todos.remaining() <= 1 ? {
              style: {
                display: 'none'
              }
            } : void 0, 's'
          ], " left"
        ], [
          'ul#filters', (function() {
            var _i, _len, _ref, _results;
            _ref = this.filters();
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              filter = _ref[_i];
              _results.push(new FooterFilterLink(filter).process());
            }
            return _results;
          }).call(this)
        ], [
          'button#clear-completed', this.todos.completed() === 0 ? {
            style: {
              display: 'none'
            }
          } : void 0, {
            click: function() {
              return self.data.todos.clearCompleted();
            }
          }, ['span', 'Clear completed (', ['span.completed-value', this.data.todos.completed()], ')']
        ]
      ];
    };

    return TodosFooterView;

  })(BaseView);

  FooterFilterLink = (function(_super) {
    __extends(FooterFilterLink, _super);

    function FooterFilterLink() {
      return FooterFilterLink.__super__.constructor.apply(this, arguments);
    }

    FooterFilterLink.prototype.initialize = function() {
      return Busbup.subscribe(FILTER, (function(_this) {
        return function(_, filter) {
          _this.data.selected = filter === _this.data.name;
          return T(_this.process()).render({
            replace: _this.el
          });
        };
      })(this));
    };

    FooterFilterLink.prototype.process = function() {
      var self;
      self = this;
      return [
        'li', {
          afterRender: function(el) {
            return self.el = $(el);
          },
          "class": this.data.name
        }, [
          'a', this.data.selected ? {
            "class": 'selected'
          } : void 0, {
            href: "#/" + this.data.name
          }, this.data.label
        ]
      ];
    };

    return FooterFilterLink;

  })(BaseView);

}).call(this);
