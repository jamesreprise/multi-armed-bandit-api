defmodule Bandit.Repo do
  use Ecto.Repo,
    otp_app: :bandit,
    adapter: Ecto.Adapters.Postgres
end
