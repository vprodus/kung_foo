defmodule KungFoo.Repo do
  use Ecto.Repo,
    otp_app: :kung_foo,
    adapter: Ecto.Adapters.Postgres
end
