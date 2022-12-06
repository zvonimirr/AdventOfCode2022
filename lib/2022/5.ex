import AOC

aoc 2022, 5 do
  def p1(input) do
    # Separate by blank line
    [crates, instructions] =
      input
      |> String.split("\n\n")

    # Parse instructions
    instructions =
      instructions
      |> String.split("\n")

    # Parse number of stacks
    stacks =
      crates
      |> String.split("\n")
      |> Enum.take(-1)
      |> List.first()
      |> String.split(" ")
      |> Enum.filter(&(&1 != ""))
      |> List.last()
      |> String.to_integer()

    # Parse crates
    crates =
      crates
      |> String.split("\n")
      |> Enum.drop(-1)

    crates =
      for stack <- 1..stacks do
        line =
          crates
          |> Enum.at(stack - 1)

        if not is_nil(line) do
          line
          |> String.to_charlist()
          |> Enum.chunk_every(4)
          |> Enum.map(&List.to_string/1)
          |> Enum.map(&String.trim/1)
        else
          []
        end
      end
      |> Enum.reverse()

    # Parse crates into stacks
    crates =
      for stack <- 1..stacks do
        crates
        |> Enum.map(&Enum.at(&1, stack - 1))
        |> Enum.filter(&(&1 != ""))
        |> Enum.filter(&(&1 != nil))
        |> Enum.reverse()
      end

    # Execute instructions
    Enum.reduce(instructions, crates, fn instruction, stacks ->
      [no, src, dst] =
        instruction
        |> String.split(" ")
        |> Enum.drop_every(2)
        |> Enum.map(&String.to_integer/1)

      Enum.reduce(1..no, stacks, fn _op, stacks ->
        src_stack = Enum.at(stacks, src - 1)
        dst_stack = Enum.at(stacks, dst - 1)

        taken = Enum.take(src_stack, 1)
        src_stack = Enum.drop(src_stack, 1)
        dst_stack = taken ++ dst_stack

        List.replace_at(stacks, src - 1, src_stack)
        |> List.replace_at(dst - 1, dst_stack)
      end)
    end)
    |> Enum.map(&List.first/1)
    |> Enum.join("")
    |> String.replace(~r/\[|\]/, "")
  end

  def p2(input) do
    # Separate by blank line
    [crates, instructions] =
      input
      |> String.split("\n\n")

    # Parse instructions
    instructions =
      instructions
      |> String.split("\n")

    # Parse number of stacks
    stacks =
      crates
      |> String.split("\n")
      |> Enum.take(-1)
      |> List.first()
      |> String.split(" ")
      |> Enum.filter(&(&1 != ""))
      |> List.last()
      |> String.to_integer()

    # Parse crates
    crates =
      crates
      |> String.split("\n")
      |> Enum.drop(-1)

    crates =
      for stack <- 1..stacks do
        line =
          crates
          |> Enum.at(stack - 1)

        if not is_nil(line) do
          line
          |> String.to_charlist()
          |> Enum.chunk_every(4)
          |> Enum.map(&List.to_string/1)
          |> Enum.map(&String.trim/1)
        else
          []
        end
      end
      |> Enum.reverse()

    # Parse crates into stacks
    crates =
      for stack <- 1..stacks do
        crates
        |> Enum.map(&Enum.at(&1, stack - 1))
        |> Enum.filter(&(&1 != ""))
        |> Enum.filter(&(&1 != nil))
        |> Enum.reverse()
      end

    # Execute instructions
    Enum.reduce(instructions, crates, fn instruction, stacks ->
      [no, src, dst] =
        instruction
        |> String.split(" ")
        |> Enum.drop_every(2)
        |> Enum.map(&String.to_integer/1)

      src_stack = Enum.at(stacks, src - 1)
      dst_stack = Enum.at(stacks, dst - 1)

      # Take X crates from source stack
      taken = Enum.take(src_stack, no)
      src_stack = Enum.drop(src_stack, no)

      # Put X crates on destination stack
      dst_stack = taken ++ dst_stack

      List.replace_at(stacks, src - 1, src_stack)
      |> List.replace_at(dst - 1, dst_stack)
    end)
    |> Enum.map(&List.first/1)
    |> Enum.join("")
    |> String.replace(~r/\[|\]/, "")
  end
end
