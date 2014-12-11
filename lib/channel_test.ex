defmodule ChannelTest do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [

    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChannelTest.Supervisor]
    Supervisor.start_link(children, opts)
    Agent.start_link(fn -> %{
                        "players" => [],
                        "target_number" => :random.uniform(500),
                        "current_number" => 0
                        }
                      end,
                      name: :game_agent)
  end
end
