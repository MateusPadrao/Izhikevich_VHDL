library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity fc_cordic is
    port
        (
            clk: in std_logic;
            reset: in std_logic;
            x_in: in std_logic_vector(15 downto 0);
            y_in: in std_logic_vector(15 downto 0);
            y_out: out std_logic_vector(15 downto 0)
        )
    end fc_cordic;

architecture behavior of fc_cordic is

end behavior;