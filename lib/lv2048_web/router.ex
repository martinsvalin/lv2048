defmodule Lv2048Web.Router do
  use Lv2048Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lv2048Web do
    pipe_through :browser

    get "/", PageController, :index
    live "/2048", Lv2048Live
  end

  # Other scopes may use custom stacks.
  # scope "/api", Lv2048Web do
  #   pipe_through :api
  # end
end
