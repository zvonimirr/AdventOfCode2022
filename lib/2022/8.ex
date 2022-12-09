import AOC

aoc 2022, 8 do
  def p1(input) do
    tree_grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

    columns = Enum.at(tree_grid, 0) |> Enum.count()
    rows = Enum.count(tree_grid)

    Enum.reduce(0..(rows - 1), {0, 0}, fn _column, {row, count} ->
      {_col, tree_count} =
        Enum.reduce(0..(columns - 1), {0, 0}, fn _column, {col, count} ->
          tree_height = Enum.at(tree_grid, row) |> Enum.at(col)

          row_trees = Enum.at(tree_grid, row) |> List.replace_at(col, nil)

          col_trees =
            Enum.map(0..(rows - 1), fn x -> Enum.at(tree_grid, x) |> Enum.at(col) end)
            |> List.replace_at(row, nil)

          trees_to_the_left = Enum.take_while(row_trees, &(not is_nil(&1)))

          trees_to_the_right =
            Enum.take_while(row_trees |> Enum.reverse(), &(not is_nil(&1))) |> Enum.reverse()

          trees_above = Enum.take_while(col_trees, &(not is_nil(&1)))

          trees_below =
            Enum.take_while(col_trees |> Enum.reverse(), &(not is_nil(&1))) |> Enum.reverse()

          tree_is_on_edge =
            Enum.any?(
              [trees_to_the_left, trees_to_the_right, trees_above, trees_below],
              &(&1 == [])
            )

          visible_above = Enum.all?(trees_above, &(&1 < tree_height))
          visible_below = Enum.all?(trees_below, &(&1 < tree_height))
          visible_left = Enum.all?(trees_to_the_left, &(&1 < tree_height))
          visible_right = Enum.all?(trees_to_the_right, &(&1 < tree_height))

          visible =
            visible_above or visible_below or visible_left or visible_right or tree_is_on_edge

          ncol = col + 1
          ncount = if visible, do: count + 1, else: count

          {ncol, ncount}
        end)

      {row + 1, count + tree_count}
    end)
    |> elem(1)
  end

  def p2(input) do
    tree_grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

    columns = Enum.at(tree_grid, 0) |> Enum.count()
    rows = Enum.count(tree_grid)

    Enum.reduce(0..(rows - 1), {0, []}, fn _column, {row, scores} ->
      {_col, tree_scores} =
        Enum.reduce(0..(columns - 1), {0, []}, fn _column, {col, scores} ->
          tree_height = Enum.at(tree_grid, row) |> Enum.at(col)

          row_trees = Enum.at(tree_grid, row) |> List.replace_at(col, nil)

          col_trees =
            Enum.map(0..(rows - 1), fn x -> Enum.at(tree_grid, x) |> Enum.at(col) end)
            |> List.replace_at(row, nil)

          ncol = col + 1

          trees_above = if(row > 0, do: Enum.slice(col_trees, 0, row), else: []) |> Enum.reverse()
          trees_below = if row < rows - 1, do: Enum.slice(col_trees, row + 1, rows - 1), else: []

          trees_to_the_left =
            if(col > 0, do: Enum.slice(row_trees, 0, col), else: []) |> Enum.reverse()

          trees_to_the_right =
            if col < columns - 1, do: Enum.slice(row_trees, col + 1, columns - 1), else: []

          view_count_above = get_tree_count(trees_above, tree_height)
          view_count_below = get_tree_count(trees_below, tree_height)
          view_count_left = get_tree_count(trees_to_the_left, tree_height)
          view_count_right = get_tree_count(trees_to_the_right, tree_height)

          scenic_score = view_count_above * view_count_below * view_count_left * view_count_right

          nscores = [scenic_score | scores]

          {ncol, nscores}
        end)

      {row + 1, scores ++ tree_scores}
    end)
    |> elem(1)
    |> Enum.max()
  end

  defp get_tree_count(trees, height) do
    Enum.reduce_while(trees, 0, fn x, acc ->
      halting_count = if x >= height, do: acc + 1, else: acc

      if x < height, do: {:cont, acc + 1}, else: {:halt, halting_count}
    end)
  end
end
