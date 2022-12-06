import AOC

aoc 2022, 2 do
  @map %{
    # rock
    "A" => :rock,
    # paper
    "B" => :paper,
    # scissors
    "C" => :scissors,
    # rock
    "X" => :rock,
    # paper
    "Y" => :paper,
    # scissors
    "Z" => :scissors
  }

  @map2 %{
    # rock
    "A" => :rock,
    # paper
    "B" => :paper,
    # scissors
    "C" => :scissors,
    # lose
    "X" => :lose,
    # draw
    "Y" => :draw,
    # win
    "Z" => :win
  }

  def do_p1(player_move, computer_move) do
    case {player_move, computer_move} do
      # rock
      {:rock, :rock} -> {3, 1}
      {:rock, :paper} -> {0, 1}
      {:rock, :scissors} -> {6, 1}
      # paper
      {:paper, :rock} -> {6, 2}
      {:paper, :paper} -> {3, 2}
      {:paper, :scissors} -> {0, 2}
      # scissors
      {:scissors, :rock} -> {0, 3}
      {:scissors, :paper} -> {6, 3}
      {:scissors, :scissors} -> {3, 3}
    end
  end

  def do_p2(computer_move, needed_result) do
    case {computer_move, needed_result} do
      # rock
      {:rock, :lose} -> {0, 3}
      {:rock, :draw} -> {3, 1}
      {:rock, :win} -> {6, 2}
      # paper
      {:paper, :lose} -> {0, 1}
      {:paper, :draw} -> {3, 2}
      {:paper, :win} -> {6, 3}
      # scissors
      {:scissors, :lose} -> {0, 2}
      {:scissors, :draw} -> {3, 3}
      {:scissors, :win} -> {6, 1}
    end
  end

  def p1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&Enum.map(&1, fn x -> @map[x] end))
    |> Enum.map(fn [computer_move, player_move] ->
      do_p1(player_move, computer_move) |> Tuple.sum()
    end)
    |> Enum.sum()
  end

  def p2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&Enum.map(&1, fn x -> @map2[x] end))
    |> Enum.map(fn [computer_move, needed_result] ->
      do_p2(computer_move, needed_result) |> Tuple.sum()
    end)
    |> Enum.sum()
  end
end
