class @TodosResource
  serialize = (todos) ->
    data = todos.map (item) ->
      {title: item.title, completed: item.completed}

    JSON.stringify(data)

  deserialize = (str) ->
    result = new Todos

    if str and data = JSON.parse(str)
      for item in data
        result.push new Todo(result, item.title, item.completed)

    result

  @load: (id) ->
    deserialize localStorage.getItem(id)

  @save: (id, todos) ->
    localStorage.setItem(id, serialize(todos))

