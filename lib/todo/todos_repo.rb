require 'little_boxes'
require 'securerandom'

module Todo
  class TodosRepo
    include LittleBoxes::Configurable

    dependency(:store) { {} }
    dependency(:new_todo) { OpenStruct.method(:new) }

    def save(todo)
      todo.id = SecureRandom.uuid unless todo.id

      store[todo.id] = {
        id: todo.id,
        title: todo.title,
        completed: todo.completed,
        order: todo.order,
      }
    end

    def find(id)
      if data = store[id]
        new_todo.(data)
      end
    end

    def find_all
      store.values.map(&new_todo)
    end

    def delete(todo)
      store.delete(todo.id)
    end

    def delete_all
      store.clear
    end
  end
end
