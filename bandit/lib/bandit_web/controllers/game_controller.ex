defmodule BanditWeb.GameController do
  alias Bandit.{Repo, User}
  use BanditWeb, :controller
  import Ecto.Query
  
  plug :auth_general

  def create(conn, _params) do
    case conn.assigns[:auth] do
      true ->  game_id = GameServer.new_game(conn.params["reg"], Repo.one(from u in User, select: u.nick, where: u.reg == ^conn.params["reg"]))
               %{nick: nick, score: score, turns: turns} = GameServer.get_info(game_id)
               json(conn, %{game_id: game_id, nick: nick, score: score, turns: turns})
      false -> json(conn, %{error: "Unauthorised."})
    end
  end

  def pull(conn, %{"id" => id, "lever" => lever}) do
    case {parse_int(id), parse_int(lever), GameServer.game_valid?(id)} do
      {{:ok, _}, {:ok, _}, :ok} -> pull_response(conn, id)
      _ -> json(conn, %{error: "Invalid input."})
    end
  end

  def show(conn, %{"id" => id}) do
    case {parse_int(id), GameServer.game_valid?(id)} do
      {{:ok, _}, :ok} -> show_response(conn, id)
      _ -> json(conn, %{error: "Invalid input."})
    end
  end

  defp pull_response(conn, id) do
    %{user: user} = GameServer.get_user(id)
    cond do
      user == conn.params["reg"] && String.to_integer(lever) >= 0 && String.to_integer(lever) < 100 -> lever_result = GameServer.pull_lever(id, lever)
        case lever_result do
          {:error, _} -> json(conn, Map.merge(GameServer.get_all_info(id), %{error: "No turns left."}))
          {:ok, result} -> json(conn, Map.merge(GameServer.get_info(id), %{reward: result}))
        end
      true -> json(conn, %{error: "Invalid input."})
  
  defp show_response(conn, id) do
    %{user: user} = GameServer.get_user(id)
    cond do
      user == conn.params["reg"] -> json(conn, Map.merge(GameServer.get_info(id), %{game_id: id}))
      true -> json(conn, %{error: "Unauthorised."})
    end

  defp auth_general(conn, _) do
    if Repo.exists?(from u in User, select: u.reg, where: u.reg == ^conn.params["reg"]) do
      assign(conn, :auth, true)
    else
      assign(conn, :auth, false)
    end
  end

  defp parse_int(input) do
    case Integer.parse(input) do
      {num, ""} -> {:ok, num}
      {_, rest} -> {:error, :unparsable}
      :error -> {:error, :unparsable}
    end
  end
end
