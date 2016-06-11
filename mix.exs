defmodule Skyscanner.Mixfile do
  use Mix.Project

  def project do
    [app: :take_me_home,
     description: "find your way home",
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications:
     [:logger, :httpoison,
      :poison, :calendar, :gen_smtp, :logger_file_backend],
    mod: {TakeMeHome, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:poison, "~> 2.1"},
      {:calendar, "~> 0.14.0"},
      {:gen_smtp, "~> 0.10.0"},
      {:exrm, "~> 1.0"},
      {:logger_file_backend, "~> 0.0.8"}
    ]
  end
end
