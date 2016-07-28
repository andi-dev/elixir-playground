defmodule Life.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Life.Registry, [Life.Registry]),
      supervisor(Life.Human.Supervisor, []),
      worker(Task, [Life.Time, :start, []])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
