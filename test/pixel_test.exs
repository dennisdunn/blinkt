defmodule Blinkt.PixelTest do
  use ExUnit.Case, async: true
  alias Blinkt.Pixel
  alias Blinkt.Pixels

  setup do
    start_supervised Pixels
    Pixels.init()
  end

  test "store pixel by index" do
    assert Pixels.get(0) == nil

    Pixels.set(3, %Pixel{})
    assert Pixels.get(3) != nil
  end

  test "is the bar initialized" do
    assert Pixels.get(3) != nil
  end

  test "change the lux of a pixel", %{pixel: pixel} do
    new = %Pixel{pixel | lux: 0.5}

    assert new.lux == 0.5
  end

  test "initialize a set of pixels and fetch one" do
    Pixels.init()
    assert Pixels.get(1) != nil
  end
end


