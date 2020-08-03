defmodule BanditWeb.RegisterController do
  alias Bandit.{Repo, User}
  import Ecto.Query
  use BanditWeb, :controller

  def create(conn, %{"auth" => auth, "nick" => nick}) do
    {auth, reg} = create_reg(auth)
    case check_reg(auth, reg, nick) do
      {:ok} -> json(conn, %{auth: auth, reg: reg, nick: nick})
      {:error} -> json(conn, %{error: "The student ID or nickname is already in use."})
    end
  end

  defp create_reg(auth) when is_number(auth) do
    create_reg(Integer.to_string(auth))
  end

  defp create_reg(auth) when is_binary(auth) do
    reg = 
      :crypto.hash(:sha256, auth <> "B4ND1T!")
      |> Base.url_encode64
    
    {auth, reg}
  end
 
  defp check_reg(auth, reg, nick) do
    unless (Repo.exists?(from u in User, select: u.auth, where: u.auth == ^auth or u.nick == ^nick)) do
      Repo.insert(%User{auth: auth, reg: reg, nick: nick})
      {:ok}
    else 
      {:error}
    end
  end
end
