defmodule TodoList do
	defstruct auto_id: 1, entries: %{}

	def new(), do: %TodoList{}

	def new(entries \\ []) do
		entries 
		|> Enum.reduce(
			TodoList.new(), #initial value
			fn entry, acc_list -> add_entry(acc_list, entry) end
		)
	end

	def add_entry(todo_list, entry) do
		entry = Map.put(entry, :id, todo_list.auto_id)
		new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
		%TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
	end

	def entries(todo_list, date) do
		todo_list.entries
		|> Stream.filter(fn {_, entry} -> (entry.date == date) end)
		|> Enum.map(fn {_, entry} -> entry end)
	end
end

defmodule TodoList.CsvImporter do
	def import(file) do
		File.stream!(file) # line by line
            |> Stream.map(&String.replace(&1, "\n", ""))
            |> Stream.map(&String.split(&1, ",")) # split each line on comma
            |> Stream.map(&IO.inspect(&1))
            |> Stream.map(fn [date, content] -> %{datedate, content: content}end)
            |> Stream.map(&IO.inspect(&1))
            |> Enum.to_list()
            |> TodoList.new()
	end
end