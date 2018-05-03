defmodule Hitbtc.Mixfile do
  use Mix.Project

  @description """
    HitBTC Elixir API client
  """

  def project do
    [
      app: :hitbtc,
      version: "0.2.0",
      elixir: "~> 1.3",
      name: "HitBTC REST API",
      description: @description,
      docs: [extras: ["README.md"]],
      start_permanent: Mix.env == :prod,
      package: package(),
      deps: deps(),
      source_url: "https://github.com/konstantinzolotarev/hitbtc"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:websockex, "~> 0.4"},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp package do
   [ maintainers: ["Konstantin Zolotarev"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/konstantinzolotarev/hitbtc"} ]
  end
end
