defmodule GameServer do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def new_game(user, nick) do
    GenServer.call(__MODULE__, {:new_game, user, nick})
  end

  def game_valid?(key) do
    GenServer.call(__MODULE__, {:valid, key})
  end

  def get_info(key) do
    GenServer.call(__MODULE__, {:get_info, key})
  end

  def get_all_info(key) do
    GenServer.call(__MODULE__, {:get_all_info, key})
  end

  def get_user(key) do
    GenServer.call(__MODULE__, {:get_user, key})
  end
  
  def pull_lever(key, lever) do
    GenServer.call(__MODULE__, {:pull_lever, key, lever})
  end

  def init(_) do
    {:ok, initial_state()}
  end

  defp initial_state do
    %{
      auto_id: 0,
      games: %{}
     }
  end

  def handle_call({:new_game, user, nick}, _, state) do
    {:reply,
     Map.get(state, :auto_id),
     %{state | auto_id: Map.get(state, :auto_id) + 1,
       games: Map.put(Map.get(state, :games), Map.get(state, :auto_id), Game.new(user, nick))}
    }
  end

  def handle_call({:get_user, key}, _, state) do
    {:reply, Map.take(get_game(key, state), [:user]), state}
  end

  def handle_call({:get_info, key}, _, state) do
    {:reply, Map.take(get_game(key, state), [:nick, :score, :turns]), state}
  end

  def handle_call({:get_all_info, key}, _, state) do
    %{bandits: bandits} = Map.take(get_game(key, state), [:bandits])
    {:reply, 
    Map.merge(
      Map.take(get_game(key, state), [:nick, :score, :turns]),
      %{bandits: Enum.map(bandits, &Map.from_struct/1)}
    ), 
    state}
  end

  def handle_call({:valid, key}, _, state) do
    case get_game(key, state) do
      nil -> {:reply, :error, state}
      _ -> {:reply, :ok, state}
    end
  end

  def handle_call({:pull_lever, key, lever}, _, state) do
    pull_result = Game.pull(get_game(key, state), String.to_integer(lever))
    case pull_result do
      {:ok, result, game} -> {:reply, {:ok, result}, %{state | games: Map.merge(Map.get(state, :games), %{String.to_integer(key) => game})}}
      {:error, _} -> {:reply, pull_result, state}
    end
  end

  defp get_game(key, state) when is_binary(key) do
    get_game(String.to_integer(key), state)
  end

  defp get_game(key, state) when is_integer(key) do
    Map.get(Map.get(state, :games), key)
  end
end