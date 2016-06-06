defmodule EmailDispatcher do

  require Logger
  use GenServer

  @email_address Application.get_env(:take_me_home, :email_address)
  @password Application.get_env(:take_me_home, :password)
  
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def send_email(itinery) do
    GenServer.cast(__MODULE__, {:send, itinery})
  end
  
  def handle_cast({:send, itinery}, state) do
    do_send_email(itinery)
    {:noreply, state}
  end
  
  def do_send_email(message) do
    :gen_smtp_client.send({@email_address, [@email_address],
			  "Subject: testing\r\nFrom: Take Me Home \r\nTo: Some Dude \r\n\r\n#{message}"},
      [relay: 'smtp.gmail.com',
       port: 587,
       username: @email_address,
       password: @password])
  end

  def test do
    start_link
    send_email(inspect(%SearchResult{}))
  end
end
