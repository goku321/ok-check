defmodule Todo.List do
  defstruct auto_id: 1, entries: %{}

  # default values are already defined during struct definition,
  # so no need to define in new method.
  @spec new :: %Todo.List{auto_id: 1, entries: %{}}
  def new(), do: %Todo.List{}

  @spec new(any) :: any
  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %Todo.List{},
      &add_entry(&2, &1)
    )
  end

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

  @spec entries(atom | %{:entries => any, optional(any) => any}, any) :: list
  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  @spec update_entry(atom | %{:entries => map, optional(any) => any}, any, any) ::
          atom | %{:entries => map, optional(any) => any}
  def update_entry(todo_list, entry_id, updater_lambda) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = %{} = updater_lambda.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  @spec delete_entry(atom | %{:entries => map, optional(any) => any}, any) ::
          atom | %{:entries => keyword | map, optional(any) => any}
  def delete_entry(todo_list, entry_id) do
    %Todo.List{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end
end
