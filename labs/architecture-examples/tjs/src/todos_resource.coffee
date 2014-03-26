class @TodosResource
  serialize = (todos) ->
    data = []
    #for item in todos
    for item in todos._data
      data.push title: item.title, completed: item.completed

    JSON.stringify(data)

  deserialize = (str) ->
    result = new Todos

    if str and data = JSON.parse(str)
      for item in data
        #result.push new Todo(result, item.title, item.completed)
        result._data.push new Todo(result, item.title, item.completed)

    result

  @load: (id) ->
    deserialize localStorage.getItem(id)

  @save: (id, todos) ->
    localStorage.setItem(id, serialize(todos))

FreeMart.register 'todos:load', (_, id) ->
  TodosResource.load(id)

FreeMart.register 'todos:save', (_, id, todos) ->
  TodosResource.save(id, todos)

