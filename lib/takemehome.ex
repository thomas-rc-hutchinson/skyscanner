defmodule TakeMeHome do
  use Application
  require Logger
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Logger.debug("Starting Take Me Home")

    children = [
      worker(EmailDispatcher, []),
    ]

    opts = [strategy: :one_for_one, name: TakeMeHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
