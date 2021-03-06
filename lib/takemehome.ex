defmodule TakeMeHome do
  use Application
  require Logger
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Logger.debug("Starting Take Me Home")

    children = [
      worker(TakeMeHome.EmailClient, [config(:email_credentials)]),
      worker(TakeMeHome.Scheduler, [{"MAN-Sky","STOC-Sky", config(:interval)}])
    ]

    opts = [strategy: :one_for_one, name: TakeMeHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config(key), do: Application.get_env(:take_me_home, key)
end
