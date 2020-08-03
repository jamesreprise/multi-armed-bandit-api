defmodule Game do
  defstruct user: nil, nick: nil, score: nil, bandits: nil, turns: nil

  def new(user, nick) do
    %Game{
        user: user,
        nick: nick,
        score: 0,
        bandits: (Enum.reduce(1..100, [], (fn _, list -> [SlotMachine.new | list] end))),
        turns: 100
    }
  end

  def pull(game, lever) do
    cond do
        Map.get(game, :turns) <= 0 -> {:error, "Game is finished."}
        true -> reward = SlotMachine.pull(Enum.at(Map.get(game, :bandits), lever))
                {:ok,
                 reward,
                 %Game{game | turns: Map.get(game, :turns) - 1, score: Map.get(game, :score) + reward}
                }
    end
  end
end