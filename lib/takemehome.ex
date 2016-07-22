defmodule TakeMeHome.Application do
  use Application
  require Logger
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Logger.debug("Starting Take Me Home")

    children = [
      worker(TakeMeHome.EmailDispatcher, []),
      worker(TakeMeHome.Scheduler,
	[{"MAN-Sky","STOC-Sky", interval}])
    ]

    opts = [strategy: :one_for_one, name: TakeMeHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def interval, do: Application.get_env(:take_me_home, :interval)
end
