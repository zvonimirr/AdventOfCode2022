import AOC

aoc 2022, 3 do
  def p1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split_at(&1, div(String.length(&1), 2)))
    |> Enum.map(fn {a, b} -> {String.to_charlist(a), String.to_charlist(b)} end)
    |> Enum.map(fn {a, b} -> Enum.filter(a, &Enum.member?(b, &1)) end)
    |> Enum.map(fn [a | _] -> a end)
    |> Enum.map(fn chr ->
      if chr in ?a..?z do
        chr - ?a + 1
      else
        chr - ?A + 1 + 26
      end
    end)
    |> Enum.sum()
  end

  def p2(input) do
    input
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] ->
      [String.to_charlist(a), String.to_charlist(b), String.to_charlist(c)]
    end)
    |> Enum.map(fn [a, b, c] ->
      Enum.filter(a, &(Enum.member?(b, &1) and Enum.member?(c, &1)))
    end)
    |> Enum.map(fn [a | _] -> a end)
    |> Enum.map(fn chr ->
      if chr in ?a..?z do
        chr - ?a + 1
      else
        chr - ?A + 1 + 26
      end
    end)
    |> Enum.sum()
  end
end
