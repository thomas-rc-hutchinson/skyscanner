defmodule TakeMeHome.EmailClient do
  use GenServer

  def start_link([address: address, password: password] = credentials) do
    GenServer.start_link(__MODULE__, credentials, name: __MODULE__)
  end

  def send_email(message) do
    GenServer.cast(__MODULE__, {:send, message})
  end
  
  def handle_cast({:send, email}, credentials) do
		:gen_smtp_client.send({credentials[:address], [credentials[:address]],
			  "Subject: Flights\r\nFrom: Take Me Home \r\nTo: You \r\n\r\n#{email}"},
      [relay: 'smtp.gmail.com',
       port: 587,
       username: credentials[:address],
       password: credentials[:password]])
    {:noreply, credentials}
  end
end
