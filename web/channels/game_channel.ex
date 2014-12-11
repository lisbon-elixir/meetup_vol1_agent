defmodule ChannelTest.GameChannel do
  use Phoenix.Channel

  def join(socket, "topic", %{"id" => user_id}) do
    get_agent
    |> update_number_of_players(user_id)
    |> represent_game_state
    |> inform_game_state(socket)
    |> inform_player_join(socket)

    {:ok, socket}
  end

  def event(socket, "player:add_value", %{"value" => value}) do
    get_agent
    |> add_to_current_number(value, socket)
    |> represent_game_state
    |> inform_game_state(socket)

    socket
  end


  defp add_to_current_number(agent, value, socket) do
    Agent.get_and_update(agent, fn state ->
      current_number = Map.get(state, "current_number") + String.to_integer(value)
      target_number = Map.get(state, "target_number")

      new_state = make_play(socket, state, current_number, target_number)

      {new_state, new_state}
    end)
  end

  defp make_play(socket, state, current_number, target_number) when current_number >= target_number do
    broadcast socket, "game:end", %{game_won: current_number == target_number}
    new_state = Map.put state, "target_number", :random.uniform(500)
    Map.put new_state, "current_number", 0
  end

  defp make_play(socket, state, current_number, target_number) do
    Map.put state, "current_number", current_number
  end

  defp get_agent do
    Process.whereis(:game_agent)
  end

  defp update_number_of_players(agent, user_id) do
    Agent.get_and_update(agent, fn state ->
      new_state = Map.put state, "players", Enum.concat(Map.get(state, "players"), [user_id])
      {new_state, new_state}
    end)
  end

  defp represent_game_state(current_state) do
    %{
      number_of_players: Map.get(current_state, "players") |> Enum.count,
      target_number: Map.get(current_state, "target_number"),
      current_number: Map.get(current_state, "current_number")
    }
  end

  defp inform_player_join(state, socket) do
    broadcast socket, "players:join", state
  end

  defp inform_game_state(state, socket) do
    reply socket, "game:state", state
    broadcast socket, "game:state", state
    state
  end

end
