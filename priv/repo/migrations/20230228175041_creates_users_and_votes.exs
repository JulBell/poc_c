defmodule PacC.Repo.Migrations.CreatesUsersAndVotes do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    execute "CREATE EXTENSION \"uuid-ossp\""

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :username, :string, null: false
      add :ip_address, :string
      add :user_agent, :text
      add :token, :text
      timestamps()
    end

    create table(:votes, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :value, :string, null: false
      add :user_id, :uuid, null: false
      timestamps()
    end
  end
end
