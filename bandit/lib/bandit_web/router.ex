defmodule BanditWeb.Router do
  use BanditWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BanditWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", BanditWeb do
     pipe_through :api

     post "/register", RegisterController, :create
     post "/game/new", GameController, :create
     post "/game/:id", GameController, :show
     post "/game/:id/:lever", GameController, :pull
     delete "/game/:id", GameController, :delete

     # resources "/users", UserController, only: [:index, :edit, :show, :create]
   end
end
