defmodule Bandit.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users" do
    field :auth, :string, primary_key: true
    field :reg, :string
    field :nick, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:auth, :reg, :nick])
    |> validate_required([:auth, :reg])
    |> unique_constraint(:auth)
  end
end
