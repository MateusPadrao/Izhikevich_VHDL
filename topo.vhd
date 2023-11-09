library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity topo is
    port (
        clk : in std_logic;
        reset : in std_logic;
        v_n: in std_logic_vector(15 downto 0);
        u_n: in std_logic_vector(15 downto 0);
        v_n1: out std_logic_vector(15 downto 0);
        u_n1: out std_logic_vector(15 downto 0)
    );
end entity topo;

architecture behavior of topo is

end architecture behavior;