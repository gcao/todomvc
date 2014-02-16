class @TodosResource
  serialize = (todos) ->
    data = []
    for item in todos
      data.push title: item.title, completed: item.completed

    JSON.stringify(data)

  deserialize = (str) ->
    result = new Todos

    if str
      if data = JSON.parse str
        for item in data
          result.push new Todo(result, item.title, item.completed)

    result

  @load: (id) ->
    deserialize localStorage.getItem(id)

  @save: (id, todos) ->
    localStorage.setItem(id, serialize(todos))

