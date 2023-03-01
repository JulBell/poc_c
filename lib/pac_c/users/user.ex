defmodule PacC.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PacC.Repo
  alias __MODULE__
  alias PacC.Users.Username

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :username, :string
    field :ip_address, :string
    field :user_agent, :string
    field :token, :string
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :ip_address, :user_agent, :token])
    |> validate_username()
    |> validate_required([:username])
  end

  def to_map(user) do
    user
    |> Map.take([:id, :username, :ip_address, :user_agent, :token])
  end

  defp validate_username(changeset) do
    changeset
    |> unsafe_validate_unique(:username, PacC.Repo)
    |> unique_constraint(:usernames)
  end

  def find_or_create_user(token) do
    case Repo.get_by(User, token: token) do
      %User{} = user -> user
      _ -> User.generate_user(%{"username" => Username.generate(), "token" => token})
    end
  end
  def generate_user(attrs) do
    %User{}
    |> changeset(attrs)
    |> Repo.insert!()
  end
end
