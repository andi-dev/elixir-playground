defmodule Life.Time do
  def start do
    #:timer.apply_interval(:timer.seconds(1), Life.Time, :tick, [])
    :timer.sleep(:infinity)
  end

  def tick do
    Life.Registry.age_all_humans(Life.Registry)
  end
end
