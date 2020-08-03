defmodule Bandit.Repo.Migrations.UsersAddNickCol do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :nick, :string
    end
  end
end
