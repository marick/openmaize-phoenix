defmodule Welcome.User do
  use Welcome.Web, :model

  schema "users" do
    field :name, :string
    field :password_hash, :string
    field :role, :string

    timestamps
  end

  @required_fields ~w(name password_hash role)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end