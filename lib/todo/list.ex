defmodule Todo.List do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %Todo.List{}
end
