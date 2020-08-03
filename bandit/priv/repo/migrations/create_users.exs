defmodule Bandit.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :auth, :string
      add :reg, :string
      timestamps()
    end
  end

  def up do
    create unique_index(:users, [:auth, :reg], name: :users_auth_reg_index)
  end
end
