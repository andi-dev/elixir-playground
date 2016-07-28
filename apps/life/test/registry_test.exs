defmodule Life.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, _} = Life.Registry.start_link(context.test)
    {:ok, registry: context.test}
  end

  test "spawns humans", %{registry: registry} do
    assert Life.Registry.lookup(registry, "hansi") == :error

    Life.Registry.create(registry, "hansi")
    assert {:ok, human} = Life.Registry.lookup(registry, "hansi")

    Life.Human.put(human, "age", 12)
    assert Life.Human.get(human, "age") == 12
  end

  test "removes humans on exit", %{registry: registry} do
    Life.Registry.create(registry, "hansi")
    {:ok, human} = Life.Registry.lookup(registry, "hansi")
    Agent.stop(human)

    # Do a call to ensure the registry processed the down message
   _ = Life.Registry.create(registry, "bogus")

    assert Life.Registry.lookup(registry, "hansi") == :error
  end

  test "removes human on crash", %{registry: registry} do
    Life.Registry.create(registry, "hansi")
    {:ok, human} = Life.Registry.lookup(registry, "hansi")

    # Stop the human with non-normal reason
    Process.exit(human, :shutdown)

    # Wait until the human is dead
    ref = Process.monitor(human)
    assert_receive {:DOWN, ^ref, _, _, _}

    # Do a call to ensure the registry processed the down message
    _ = Life.Registry.create(registry, "bogus")

    assert Life.Registry.lookup(registry, "hansi") == :error
  end

  test "age all humans", %{registry: registry} do
    Life.Registry.create(registry, "hansi")
    Life.Registry.create(registry, "emilia")
    {:ok, hansi} = Life.Registry.lookup(registry, "hansi")
    {:ok, emilia} = Life.Registry.lookup(registry, "hansi")
    Life.Registry.age_all_humans(registry)
    assert Life.Human.get(hansi, :age) == 1
    assert Life.Human.get(emilia, :age) == 1
  end

end
