defmodule Exsaml.MixProject do
  use Mix.Project

  def project do
    [
      app: :exsaml,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

      # Docs
      name: "exsaml",
      source_url: "https://github.com/dlacreme/exsaml",
      homepage_url: "https://github.com/dlacreme/exsaml",
      docs: [
        # The main page in the docs
        main: "exsaml",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :xmerl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  # Commands ; usage: `$ mix {command_name}`
  defp aliases do
    [
      setup: ["deps.get"],
      docs: ["docs"]
    ]
  end
end
