defmodule Bandit.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :auth, :string, primary_key: true
      add :reg, :string

      timestamps()
    end

  end
end
