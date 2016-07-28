defmodule Life.Human.Supervisor do
  use Supervisor

  # A simple module attribute that stores the supervisor name
  @name Life.Human.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_human do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    # TODO: play with changing the temporary if humans should be restarted
    children = [
      worker(Life.Human, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
