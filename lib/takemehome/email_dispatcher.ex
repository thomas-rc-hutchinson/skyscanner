defmodule TakeMeHome.EmailDispatcher do

  require Logger
  use GenServer

  defp email_address, do: Application.get_env(:take_me_home, :email_address)
  defp password, do: Application.get_env(:take_me_home, :password)
  
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def send_email(itinery) do
    GenServer.cast(__MODULE__, {:send, email})
  end
  
  def handle_cast({:send, email}, state) do
    do_send_email(email)
    {:noreply, state}
  end
  
  def do_send_email(message) do
    :gen_smtp_client.send({@email_address, [@email_address],
			  "Subject: Flights\r\nFrom: Take Me Home \r\nTo: You \r\n\r\n#{message}"},
      [relay: 'smtp.gmail.com',
       port: 587,
       username: email_address,
       password: password])
  end
end
