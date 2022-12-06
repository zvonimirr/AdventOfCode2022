import AOC

aoc 2022, 1 do
  def p1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn value ->
      case value do
        :error -> :error
        {value, _} -> value
      end
    end)
    |> Enum.chunk_by(&(&1 == :error))
    |> Enum.filter(fn chunk -> chunk != [:error] end)
    |> Enum.map(fn chunk -> Enum.sum(chunk) end)
    |> Enum.max()
  end

  def p2(input) do
  end
end
