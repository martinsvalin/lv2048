defmodule Lv2048.Grid do
  @moduledoc """
  The grid is a 4x4 list of cells. This module creates and manipulates the grid.

  ## KNOWN BUGS

  1) 0222 moving right will become 0042 instead of 0024
  2) Inserts new value even when grid doesn't change
  3) Crashes when it can't find empty to insert in, instead of game over.
  """
  @size 4
  @type grid() :: [pos_integer()]

  @spec new() :: grid()
  def new() do
    List.duplicate(:empty, @size * @size)
    |> seed()
    |> seed()
  end

  defp seed(grid) do
    empties = for {:empty, i} <- Enum.with_index(grid), do: i
    List.replace_at(grid, Enum.random(empties), new_value())
  end

  defp new_value() do
    if :rand.uniform() < 0.9, do: 2, else: 4
  end

  @spec move(grid(), :down | :invalid | :left | :right | :up) :: any
  def move(grid, :invalid), do: grid

  def move(grid, :right) do
    rows(grid)
    |> Enum.map(&move_row_left/1)
    |> insert(:left)
    |> List.flatten()
  end

  def move(grid, :left) do
    rows(grid)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&move_row_left/1)
    |> Enum.map(&Enum.reverse/1)
    |> insert(:right)
    |> List.flatten()
  end

  def move(grid, :up) do
    columns(grid)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&move_row_left/1)
    |> Enum.map(&Enum.reverse/1)
    |> insert(:right)
    |> transpose()
    |> List.flatten()
  end

  def move(grid, :down) do
    columns(grid)
    |> Enum.map(&move_row_left/1)
    |> insert(:left)
    |> transpose()
    |> List.flatten()
  end

  defp transpose([[] | _]), do: []

  defp transpose(grid) do
    [Enum.map(grid, &hd/1) | transpose(Enum.map(grid, &tl/1))]
  end

  defp columns(grid) do
    for col <- 0..(@size - 1), do: Enum.drop(grid, col) |> Enum.take_every(@size)
  end

  defp rows(grid) do
    Enum.chunk_every(grid, 4)
  end

  defp move_row_left(row, acc \\ [])
  defp move_row_left([:empty | t], acc), do: move_row_left(t, acc)
  defp move_row_left([n | t], [n | acc]), do: move_row_left(t, [n + n | acc])
  defp move_row_left([n | t], acc), do: move_row_left(t, [n | acc])
  defp move_row_left([], acc), do: pad(Enum.reverse(acc))

  defp pad(acc) when length(acc) == 4, do: acc
  defp pad(acc) when length(acc) < 4, do: pad([:empty | acc])

  defp insert(grid, :right) do
    grid |> Enum.map(&Enum.reverse/1) |> insert(:left) |> Enum.map(&Enum.reverse/1)
  end

  defp insert(grid, :left) do
    empties = for {[:empty | _], i} <- Enum.with_index(grid), do: i
    List.update_at(grid, Enum.random(empties), fn [_ | t] -> [new_value() | t] end)
  end
end
