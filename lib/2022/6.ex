import AOC

aoc 2022, 6 do
  def p1(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce_while({"", 0}, fn l, {str, pos} ->
      if String.length(str) < 4 do
        {:cont, {str <> l, pos + 1}}
      else
        uniq =
          str
          |> String.to_charlist()
          |> Enum.uniq()

        if length(uniq) == 4 do
          {:halt, pos}
        else
          cut_str =
            str
            |> String.to_charlist()
            |> Enum.drop(1)
            |> List.to_string()

          {:cont, {cut_str <> l, pos + 1}}
        end
      end
    end)
  end

  def p2(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce_while({"", 0}, fn l, {str, pos} ->
      if String.length(str) < 14 do
        {:cont, {str <> l, pos + 1}}
      else
        uniq =
          str
          |> String.to_charlist()
          |> Enum.uniq()

        if length(uniq) == 14 do
          {:halt, pos}
        else
          cut_str =
            str
            |> String.to_charlist()
            |> Enum.drop(1)
            |> List.to_string()

          {:cont, {cut_str <> l, pos + 1}}
        end
      end
    end)
  end
end
