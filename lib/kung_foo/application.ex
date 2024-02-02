defmodule KungFoo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {NodeJS.Supervisor, [path: LiveSvelte.SSR.NodeJS.server_path(), pool_size: 4]},
      KungFooWeb.Telemetry,
      KungFoo.Repo,
      {DNSCluster, query: Application.get_env(:kung_foo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KungFoo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: KungFoo.Finch},
      # Start a worker by calling: KungFoo.Worker.start_link(arg)
      # {KungFoo.Worker, arg},
      # Start to serve requests, typically the last entry
      KungFooWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KungFoo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KungFooWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
