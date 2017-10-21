defmodule Blinkt.Pixelbar do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> %{} end)
  end

  def init(pixels) do
    0..7 
    |> Enum.map(fn (idx) -> Blinkt.Pixelbar.set(pixels, idx, %Blinkt.Pixel{}) end)
  end

  def get(pixels, idx) do
    Agent.get(pixels, &Map.get(&1, idx))
  end

  def set(pixels, idx, pixel) do
    Agent.update(pixels, &Map.put(&1, idx, pixel))
  end

end
