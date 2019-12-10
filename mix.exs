defmodule ExAws.CloudWatchLogs.MixProject do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :ex_aws_cloudwatchlogs,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/JustinTangg/ex_aws_cloudwatchlogs",
      homepage_url: "https://github.com/JustinTangg/ex_aws_cloudwatchlogs",
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"],
        source_ref: "v#{@version}"
      ]
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
      {:hackney, "1.6.3 or 1.6.5 or 1.7.1 or 1.8.6 or ~> 1.9", only: [:dev, :test]},
      {:ex_doc, "~> 0.19.2", only: [:dev, :test]},
      {:ex_aws, "~> 2.0"}
    ]
  end

  defp package do
    [
      description: "AWS CloudWatchLogs service for ex_aws",
      maintainers: ["Justin Tang"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/JustinTangg/ex_aws_cloudwatchlogs"}
    ]
  end
end
