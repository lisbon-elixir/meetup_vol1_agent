use Mix.Config

config :phoenix, ChannelTest.Router,
  http: [port: System.get_env("PORT") || 4001],
