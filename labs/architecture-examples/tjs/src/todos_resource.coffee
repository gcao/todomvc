class @TodosResource
  serialize = (todos) ->
    data = []
    for item in todos
      data.push title: item.title, completed: item.completed

    JSON.stringify(data)

  deserialize = (str) ->
    result = new Todos

    if str and data = JSON.parse(str)
      for item in data
        result.push new Todo(item.title, item.completed)

    result

  @load: (id) ->
    deserialize localStorage.getItem(id)

  @save: (id, todos) ->
    localStorage.setItem(id, serialize(todos))

FreeMart.register 'todos:load', (_, id) ->
  TodosResource.load(id)

FreeMart.register 'todos:save', (_, id, todos) ->
  TodosResource.save(id, todos)

