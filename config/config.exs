# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the router
config :phoenix, ChannelTest.Router,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "Gft61D52UwyJu1rR3azxODCwjnZvwiGEUpY6CmkrZ/QtXiOvvFIe2fq9RKN/nwbuDizBdVgZsWa9gPeSDTyslA==",
  debug_errors: false,
  error_controller: ChannelTest.PageController

# Session configuration
config :phoenix, ChannelTest.Router,
  session: [store: :cookie,
            key: "_channel_test_key"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
