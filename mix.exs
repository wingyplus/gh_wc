defmodule GhWc.MixProject do
  use Mix.Project

  def project do
    [
      app: :gh_wc,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: GhWc]
  end

  defp deps do
    [
      {:ghex, github: "wingyplus/ghex"}
    ]
  end
end
