defmodule SlotMachine do
  # The global maximum reward is 100.
  @max_reward 100
  # The global maximum probability is 100.
  @probability 100
  defstruct reward: nil, probability: nil

  def new do
    %SlotMachine{reward: :rand.uniform(@max_reward), probability: :rand.uniform(@probability)}
  end

  def pull(%SlotMachine{reward: reward, probability: probability}) do
    case (:rand.uniform(@probability) <= :rand.uniform(probability)) do
      true -> reward
      false -> 0
    end
  end
end

