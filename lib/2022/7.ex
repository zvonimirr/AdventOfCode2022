import AOC

aoc 2022, 7 do
  def p1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({"", %{}}, fn command, {current_dir, fs_map} ->
      case command do
        "$ cd " <> dir ->
          new_dir = if dir == "/", do: "/", else: current_dir <> "/" <> dir

          {Path.expand(new_dir), fs_map}

        "$ ls" ->
          {current_dir, fs_map}

        "dir " <> _dir ->
          {current_dir, fs_map}

        file ->
          [fsize, _fname] = String.split(file, " ", trim: true)

          paths =
            ["/"] ++
              (current_dir
               |> String.split("/", trim: true)
               |> Enum.map(&("/" <> &1)))

          fp = paths |> List.first()

          fs_map =
            Enum.reduce(paths, {fp, fs_map}, fn path, {cp, fs_map} ->
              np = Path.expand(cp <> "/" <> path)
              current_size = Map.get(fs_map, np, 0)

              {np, Map.put(fs_map, np, current_size + String.to_integer(fsize))}
            end)
            |> elem(1)

          {current_dir, fs_map}
      end
    end)
    |> elem(1)
    |> Map.filter(fn {_dir, size} -> size <= 100_000 end)
    |> Map.values()
    |> Enum.sum()
  end

  @total_space 70_000_000
  @needed_space 30_000_000

  def p2(input) do
    fs_map =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({"", %{}}, fn command, {current_dir, fs_map} ->
        case command do
          "$ cd " <> dir ->
            new_dir = if dir == "/", do: "/", else: current_dir <> "/" <> dir

            {Path.expand(new_dir), fs_map}

          "$ ls" ->
            {current_dir, fs_map}

          "dir " <> _dir ->
            {current_dir, fs_map}

          file ->
            [fsize, _fname] = String.split(file, " ", trim: true)

            paths =
              ["/"] ++
                (current_dir
                 |> String.split("/", trim: true)
                 |> Enum.map(&("/" <> &1)))

            fp = paths |> List.first()

            fs_map =
              Enum.reduce(paths, {fp, fs_map}, fn path, {cp, fs_map} ->
                np = Path.expand(cp <> "/" <> path)
                current_size = Map.get(fs_map, np, 0)

                {np, Map.put(fs_map, np, current_size + String.to_integer(fsize))}
              end)
              |> elem(1)

            {current_dir, fs_map}
        end
      end)
      |> elem(1)

    used_space = @total_space - fs_map["/"]

    fs_map
    |> Map.filter(fn {_dir, size} -> used_space + size >= @needed_space end)
    |> Map.values()
    |> Enum.sort()
    |> List.first()
  end
end
