defmodule Lv2048Web.Lv2048Live do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="2048-container" phx-keydown="keydown" phx-target="window">
      <h3 class="score">Score:&nbsp;<%= @score %></h3>
      <section class="cells">
        <%= for cell <- @cells do %>
        <div class="cell-<%= cell.value %>"">
          <%= cell.value %>
        </div>
        <% end %>
      </section>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, start_game(socket)}
  end

  def handle_event("keydown", %{"key" => key}, socket) do
    new_socket = socket |> score()
    {:noreply, new_socket}
  end

  defp start_game(socket) do
    socket
    |> assign(:score, 0)
    |> assign(:cells, Lv2048.init_cells())
  end

  defp score(socket) do
    assign(socket, :score, socket.assigns.score + 1)
  end
end
