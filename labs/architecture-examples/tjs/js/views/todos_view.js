// Generated by CoffeeScript 1.7.1
(function() {
  var __slice = [].slice;

  this.TodosView = (function() {
    function TodosView(todos) {
      this.todos = todos;
      this.todos.subscribe(CHANGED, (function(_this) {
        return function() {
          return _this.updateView();
        };
      })(this));
    }

    TodosView.prototype.filterBy = function(filter) {
      if (['all', 'active', 'completed'].indexOf(filter) < 0) {
        console.log("Filter is not supported: '" + filter + "'");
        return;
      }
      this.filter = filter;
      this.el.find('#filters a').removeClass('selected');
      this.el.find("li." + this.filter + " a").addClass('selected');
      return this.updateView();
    };

    TodosView.prototype.updateView = function() {
      this.updateChildren();
      return this.updateFooter();
    };

    TodosView.prototype.updateChildren = function() {
      return T(this.childrenView()).render({
        inside: this.el.find('#todo-list')
      });
    };

    TodosView.prototype.updateFooter = function() {
      this.el.find('#footer').toggle(this.todos.length() > 0);
      this.updateRemaining();
      return this.updateCompleted();
    };

    TodosView.prototype.childrenView = function() {
      var child, todo, _i, _len, _ref, _results;
      _ref = this.todos.children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        todo = _ref[_i];
        if ((this.filter === 'active' && todo.completed) || (this.filter === 'completed' && !todo.completed)) {
          continue;
        }
        child = new TodoView(this.todos, todo);
        _results.push(child.process());
      }
      return _results;
    };

    TodosView.prototype.updateRemaining = function() {
      this.el.find('#todo-count strong').text(this.todos.remaining());
      return this.el.find('#todo-count .plural').toggle(this.todos.remaining() > 1);
    };

    TodosView.prototype.updateCompleted = function() {
      this.el.find('#clear-completed').toggle(this.todos.completed() > 0);
      return this.el.find('.completed-value').text(this.todos.completed());
    };

    TodosView.prototype.process = function() {
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
                self.todos.push(new Todo(self.todos, el.val().trim()));
                return el.val('');
              }
            }
          }
        ], [
          'section#main', [
            'input#toggle-all', {
              type: 'checkbox',
              click: function() {
                return self.todos.toggleAllCompleted($(this).is(':checked'));
              }
            }
          ], [
            'label', {
              "for": 'toggle-all'
            }, 'Mark all as complete'
          ], ['ul#todo-list', this.childrenView()]
        ], [
          'footer#footer', [
            'span#todo-count', ['strong', this.todos.remaining()], " item", [
              'span.plural', this.todos.remaining() <= 1 ? {
                display: 'none'
              } : void 0, 's'
            ], " left"
          ], [
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
                return self.todos.clearCompleted();
              }
            }, ['span', 'Clear completed (', ['span.completed-value', this.todos.completed()], ')']
          ]
        ]
      ];
    };

    TodosView.prototype.render = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = T(this.process())).render.apply(_ref, args);
    };

    return TodosView;

  })();

}).call(this);
