require IEx;

defmodule Life.Human do
  @doc """
    Starts a new human
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
    gets some attribute from the given human
  """
  def get(human, key) do
    Agent.get(human, &Map.get(&1, key))
  end

  def start_living(human) do
    :timer.apply_interval(:timer.seconds(1), Life.Human, :age, [human])
  end

  @doc """
  increases the age of the given human by 5
  """
  def age({name, pid}) do
    age = Life.Human.get(pid, :age)
    new_age = ((age || 1) + 1)
    if age && (Float.floor(new_age, 0) > Float.floor(age, 0))  do
      IO.inspect([name, Float.floor(new_age, 0)])
    else
      IO.inspect([name, "idling"])
    end
    IO.inspect([name, new_age])
    Life.Human.put(pid, :age, new_age)
    # TODO: Test missing
    if(new_age > 99) do
      IO.inspect([name, "just died"])
      Agent.stop(pid)
    end
  end

  @doc """
    updates some value on the given human
  """
  def put(human, key, value) do
    Agent.update(human, &Map.put(&1, key, value))
  end

end
