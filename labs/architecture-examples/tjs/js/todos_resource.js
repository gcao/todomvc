// Generated by CoffeeScript 1.7.1
(function() {
  this.TodosResource = (function() {
    var deserialize, serialize;

    function TodosResource() {}

    serialize = function(todos) {
      var data;
      data = todos.map(function(item) {
        return {
          title: item.title,
          completed: item.completed
        };
      });
      return JSON.stringify(data);
    };

    deserialize = function(str) {
      var data, item, result, _i, _len;
      result = new Todos;
      if (str && (data = JSON.parse(str))) {
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          item = data[_i];
          result.push(new Todo(result, item.title, item.completed));
        }
      }
      return result;
    };

    TodosResource.load = function(id) {
      return deserialize(localStorage.getItem(id));
    };

    TodosResource.save = function(id, todos) {
      return localStorage.setItem(id, serialize(todos));
    };

    return TodosResource;

  })();

}).call(this);
