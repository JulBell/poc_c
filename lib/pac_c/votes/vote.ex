defmodule PacC.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias __MODULE__
  alias PacC.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "votes" do
    field :value, :string
    belongs_to :user, PacC.Users.User, type: :binary_id
    timestamps()
  end

  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:value, :user_id])
    |> validate_required([:value, :user_id])
  end

  def create_vote(attrs) do
    %Vote{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def recent_votes() do
    Repo.all(
      from(
        v in Vote,
        order_by: [desc: v.inserted_at],
        limit: 5,
        preload: [:user]
      )
    )
  end

  def count_choco() do
      from(
        v in Vote,
        where: v.value == "chocolatine")
      |> Repo.aggregate(:count)
  end

  def count_pac() do
      from(
        v in Vote,
        where: v.value == "pain_au_chocolat")
      |> Repo.aggregate(:count)
  end
end
