defmodule Welcome.UserController do
  use Welcome.Web, :controller

  alias Welcome.User
  alias Openmaize.Signup

  plug :scrub_params, "user" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def login(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "login.html", changeset: changeset
  end

  def login_user(conn, _params) do
    IO.puts "*****Should we be seeing this?*****"
    Openmaize.Login.call(conn, [])
  end

  def logout(conn, _params) do
    IO.puts "*****Should we be seeing this?*****"
    Openmaize.Logout.call(conn, [])
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    create_new(conn, Signup.create_user(user_params))
  end

  def create_new(conn, {:ok, user_params}) do
    changeset = User.changeset(%User{}, user_params)
    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: user_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create_new(conn, {:error, message}) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: user_path(conn, :new))
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: user_path(conn, :index))
    else
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    Repo.delete(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

end
