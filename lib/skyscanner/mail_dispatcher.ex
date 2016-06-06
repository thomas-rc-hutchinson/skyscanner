defmodule EmailDispatcher do

  require Logger
  use GenServer

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
    :gen_smtp_client.send({'thomasrchutchinson@gmail.com', ['thomasrchutchinson@gmail.com'],
			  "Subject: testing\r\nFrom: Take Me Home \r\nTo: Some Dude \r\n\r\n#{message}"},
      [relay: 'smtp.gmail.com',
       port: 587,
       username: 'thomasrchutchinson@gmail.com',
       password: ''])
  end

  def test do
    start_link
    send_email(inspect(%SearchResult{}))
  end
end
