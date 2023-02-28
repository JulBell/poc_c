defmodule PacC.Repo do
  use Ecto.Repo,
    otp_app: :pac_c,
    adapter: Ecto.Adapters.Postgres
end
