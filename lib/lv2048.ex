defmodule Lv2048 do
  @moduledoc """
  Lv2048 keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  defstruct [:value, :id]

  def init_cells() do
    for n <- 0..15, do: %__MODULE__{value: trunc(:math.pow(2, n)), id: n}
  end
end
