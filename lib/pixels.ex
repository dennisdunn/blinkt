defmodule Blinkt.Pixels do
  use Agent
  alias Blinkt.Pixel

  def start_link(opts \\ %{}) do
    Agent.start_link(fn -> %{} end, name: :pixels)
  end

  def init() do
    0..7 
    |> Enum.map(fn (i) -> Blinkt.Pixels.set(i, %Pixel{lux: 0.2}) end)
  end

  def get(idx) do
    Agent.get(:pixels, &Map.get(&1, idx))
  end

  def set(idx, pixel) do
    Agent.update(:pixels, &Map.put(&1, idx, pixel))
  end

  def set_lux(idx, lux) do
    pix = %Pixel{Blinkt.Pixels.get(idx) | lux: lux}
    Blinkt.Pixels.set(idx, pix)
  end

end
