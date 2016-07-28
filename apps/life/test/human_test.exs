defmodule HumanTest do
  use ExUnit.Case, async: true
  doctest Life

  setup do
    {:ok, human} = Life.Human.start_link
    {:ok, human: human}
  end

  test "human can store values by key", %{human: human}  do
    Life.Human.put(human, :age, 12)
    assert Life.Human.get(human, :age) == 12
  end
end
