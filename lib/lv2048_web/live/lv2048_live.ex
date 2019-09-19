defmodule Lv2048Web.Lv2048Live do
  use Phoenix.LiveView
  @arrow_keys ~w(ArrowUp ArrowDown ArrowLeft ArrowRight)

  def render(assigns) do
    ~L"""
    <div class="2048-container" phx-keydown="keydown" phx-target="window">
      <h3 class="moves">Moves:&nbsp;<%= @moves %></h3>
      <section class="grid">
        <%= for value <- @grid do %>
        <div class="cell-<%= value %>"><%= value %></div>
        <% end %>
      </section>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, start_game(socket)}
  end

  def handle_event("keydown", %{"key" => key}, socket) do
    new_socket =
      socket
      |> move(key)
      |> count_moves()

    {:noreply, new_socket}
  end

  defp start_game(socket) do
    socket
    |> assign(:moves, 0)
    |> assign(:grid, Lv2048.Grid.new())
  end

  defp count_moves({socket, move}) do
    assign(socket, :moves, socket.assigns.moves + move)
  end

  defp move(socket, key) do
    grid = socket.assigns.grid

    case Lv2048.Grid.move(grid, key(key)) do
      ^grid -> {socket, 0}
      new_grid -> {assign(socket, :grid, new_grid), 1}
    end
  end

  defp key("ArrowUp"), do: :up
  defp key("ArrowDown"), do: :down
  defp key("ArrowLeft"), do: :left
  defp key("ArrowRight"), do: :right
  defp key(_), do: :invalid
end
