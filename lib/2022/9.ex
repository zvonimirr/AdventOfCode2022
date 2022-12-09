import AOC

defmodule Rope do
  defstruct [:head, :tail]

  def new(head, tail) do
    %Rope{head: head, tail: tail}
  end
end

defmodule PosAgent do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{{0, 0} => 1} end)
  end

  def has_visited?(a, {_x, _y} = pos) do
    Agent.get(a, fn map -> Map.has_key?(map, pos) end)
  end

  def visit(a, {_x, _y} = pos) do
    Agent.update(a, fn map -> Map.put(map, pos, 1) end)
  end

  def get_all(a) do
    Agent.get(a, fn map -> map end)
  end
end

aoc 2022, 9 do
  def p1(input) do
    {:ok, agent} = PosAgent.start_link([])
    rope = Rope.new({0, 0}, {0, 0})

    steps =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&List.replace_at(&1, 1, String.to_integer(Enum.at(&1, 1))))

    # Head steps
    Enum.reduce(steps, rope, fn [direction, distance], rope ->
      # Head step by step
      Enum.reduce(1..distance, rope, fn _, rope ->
        moved = move_rope_head(rope, direction, 1)
        steps = get_tail_steps(moved)

        moved =
          Enum.reduce(steps, moved, fn step, rope ->
            [direction, distance] = step |> String.split(" ", trim: true)
            distance = String.to_integer(distance)

            Enum.reduce(1..distance, rope, fn _, rope ->
              move_rope_tail(rope, direction, 1)
            end)
          end)

        # Get tail position
        %Rope{tail: {x, y}} = moved

        # Check if tail has visited
        if PosAgent.has_visited?(agent, {x, y}) do
          moved
        else
          # Visit tail
          PosAgent.visit(agent, {x, y})

          # Continue
          moved
        end
      end)
    end)

    # Get the count
    agent |> PosAgent.get_all() |> Map.keys() |> Enum.count()
  end

  defp move_rope_tail(rope, direction, distance) do
    {x, y} = rope.tail

    case direction do
      "R" -> %Rope{rope | tail: {x + distance, y}}
      "L" -> %Rope{rope | tail: {x - distance, y}}
      "U" -> %Rope{rope | tail: {x, y + distance}}
      "D" -> %Rope{rope | tail: {x, y - distance}}
      _ -> rope
    end
  end

  defp move_rope_head(rope, direction, distance) do
    {x, y} = rope.head

    case direction do
      "R" -> %Rope{rope | head: {x + distance, y}}
      "L" -> %Rope{rope | head: {x - distance, y}}
      "U" -> %Rope{rope | head: {x, y + distance}}
      "D" -> %Rope{rope | head: {x, y - distance}}
      _ -> rope
    end
  end

  defp get_tail_steps(rope) do
    if is_tail_adjacent(rope) do
      []
    else
      {head_x, head_y} = rope.head
      {tail_x, tail_y} = rope.tail

      distance_x = head_x - tail_x
      distance_y = head_y - tail_y

      right_steps =
        if distance_x > 0,
          do: Enum.map(1..distance_x, fn _ -> "R 1" end) |> Enum.drop(-1),
          else: []

      left_steps =
        if distance_x < 0,
          do: Enum.map(1..-distance_x, fn _ -> "L 1" end) |> Enum.drop(-1),
          else: []

      up_steps =
        if distance_y > 0,
          do: Enum.map(1..distance_y, fn _ -> "U 1" end) |> Enum.drop(-1),
          else: []

      down_steps =
        if distance_y < 0,
          do: Enum.map(1..-distance_y, fn _ -> "D 1" end) |> Enum.drop(-1),
          else: []

      combo_steps = right_steps ++ left_steps ++ up_steps ++ down_steps
      # If after moving up we break the adjacent rule, we need to move the tail
      # left or right to make it adjacent again
      combo_steps =
        if up_steps != [] or down_steps != [] do
          # Calculate difference between head and tail x coordinates
          diff = head_x - tail_x

          cond do
            diff > 0 ->
              ["R #{diff}" | combo_steps] |> List.flatten()

            # combo_steps ++ ["L #{diff}"]

            diff < 0 ->
              ["L #{-diff}" | combo_steps] |> List.flatten()

            true ->
              combo_steps
          end
        else
          combo_steps
        end

      combo_steps =
        if right_steps != [] or left_steps != [] do
          diff = head_y - tail_y

          cond do
            diff > 0 ->
              ["U #{diff}" | combo_steps] |> List.flatten()

            # combo_steps ++ ["L #{diff}"]

            diff < 0 ->
              ["D #{-diff}" | combo_steps] |> List.flatten()

            true ->
              combo_steps
          end
        else
          combo_steps
        end

      combo_steps
    end
  end

  defp is_tail_adjacent(rope) do
    {x, y} = rope.head
    {x2, y2} = rope.tail

    is_covering = x == x2 and y == y2
    is_above = x == x2 and y - 1 == y2
    is_below = x == x2 and y + 1 == y2
    is_left = x - 1 == x2 and y == y2
    is_right = x + 1 == x2 and y == y2

    is_covering or is_above or is_below or is_left or is_right
  end

  def p2(input) do
  end
end
