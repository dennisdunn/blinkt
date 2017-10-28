defmodule Blinkt.Tests do
    use ExUnit.Case, async: false
    
    test "fetch a pixel from the pixel bar state" do
        Blinkt.start_link
        p = Blinkt.get_pixel(1)
        assert p != nil
    end

    test "set a pixel to white" do
        Blinkt.start_link
        Blink.set_pixel(1, 255, 255, 255 0.2)
        <<red:size(8), _>> = Blinkt.get(1)
        assert red == 255
    end
end
