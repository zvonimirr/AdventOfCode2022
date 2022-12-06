import AOC

aoc 2022, 4 do
  def p1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [first, second] ->
      [ff, fs] = String.split(first, "-")
      [sf, ss] = String.split(second, "-")

      frange = String.to_integer(ff)..String.to_integer(fs) |> Enum.to_list()
      srange = String.to_integer(sf)..String.to_integer(ss) |> Enum.to_list()

      {frange, srange}
    end)
    |> Enum.map(fn {flist, slist} ->
      Enum.all?(flist, &(&1 in slist)) or Enum.all?(slist, &(&1 in flist))
    end)
    |> Enum.count(& &1)
  end

  def p2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [first, second] ->
      [ff, fs] = String.split(first, "-")
      [sf, ss] = String.split(second, "-")

      frange = String.to_integer(ff)..String.to_integer(fs) |> Enum.to_list()
      srange = String.to_integer(sf)..String.to_integer(ss) |> Enum.to_list()

      {frange, srange}
    end)
    |> Enum.map(fn {flist, slist} ->
      Enum.any?(flist, &(&1 in slist)) or Enum.any?(slist, &(&1 in flist))
    end)
    |> Enum.count(& &1)
  end
end
