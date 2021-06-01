defmodule Todo.List do
  defstruct auto_id: 1, entries: %{}

  @spec new :: %Todo.List{auto_id: 1, entries: %{}}
  def new(), do: %Todo.List{}

  @spec add_entry(atom | %{:auto_id => any, optional(any) => any}, map) :: %{
          :id => any,
          optional(any) => any
        }
  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    %Todo.List{todo_list |
      entries: new_entries,
      auto_id: todo_list.auto_id + 1
    }
  end
end
