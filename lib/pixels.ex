defmodule Blinkt.Pixels do
  use Agent
  alias Blinkt.Pixel

  def start_link(opts \\ %{}) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def init() do
    0..7 
    |> Enum.map(fn (i) -> Blinkt.Pixels.put(i, %Pixel{lux: 0.2}) end)
  end

  def get(idx) do
    Agent.get(__MODULE__, &Map.get(&1, idx))
  end

  def put(idx, pixel) do
    Agent.update(__MODULE__, &Map.put(&1, idx, pixel))
  end

  def set_pixel(idx, r, g, b, brightness) do
    pix = %Pixel{Blinkt.Pixels.get(idx) | red: r, green: g, blue: b, lux: brightness}
    Blinkt.Pixels.put(idx, pix)
  end

  def set_pixel(idx, r, g, b) do
    pix = %Pixel{Blinkt.Pixels.get(idx) | red: r, green: g, blue: b}
    Blinkt.Pixels.put(idx, pix)
  end

  def set_pixel(idx, brightness) do
    pix = %Pixel{Blinkt.Pixels.get(idx) | lux: brightness}
    Blinkt.Pixels.put(idx, pix)
  end

end
