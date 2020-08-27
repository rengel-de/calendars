defmodule Calendars.MixProject do
  use Mix.Project

  def project do
    [
      app: :calendars,
      version: "0.1.4",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      deps: deps(),
      name: "Calendars",
      source_url: "https://github.com/rengel-de/calendars"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:calixir, "~> 0.1.1"}
    ]
  end

  defp description() do
    """
    Calendars is a collection of calendars based on Calixir,
    the port of the Lisp calendar software calendrica-4.0.cl
    by Nachum Dershowitz and Edward M. Reingold to Elixir.
    """
  end

  defp package() do
    [
      name: "calendars",
      # These are the default files included in the package
      # files: ~w(.formatter.exs mix.exs README.md LICENSE*
      #          lib test),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/rengel-de/calendars"}
    ]
  end

end
