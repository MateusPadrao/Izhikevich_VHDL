-- Arquivo: tb_topo.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_topo is
end entity;

architecture sim of tb_topo is

    -- Sinais para conectar ao DUT (Device Under Test)
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '1';
    signal v_n_out   : std_logic_vector(32 downto 0);
    signal u_n_out   : std_logic_vector(32 downto 0);

    file f_saida : text open write_mode is "saida_neuronio.txt";

    -- Componente a ser testado
    component topo
        port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            v_n_out   : out std_logic_vector(32 downto 0);
            u_n_out   : out std_logic_vector(32 downto 0)
        );
    end component;

begin

    -- Instanciação do DUT
    uut: topo
        port map (
            clk     => clk,
            reset   => reset,
            v_n_out => v_n_out,
            u_n_out => u_n_out
        );

    -- Geração do clock (20ns de período => 50MHz)
    clk <= not clk after 10 ns;

    process
        variable linha : line;
        variable contador : integer := 0;
    begin
        -- Reset ativo por 40 ns
        wait for 40 ns;
        reset <= '0';

        -- Coleta de dados por 200 ciclos de clock
        for i in 0 to 199 loop -- verificar se 200 ciclos é o bastante
            wait until rising_edge(clk);
            
            -- Coleta dados apenas a cada 6 ciclos
            if contador = 0 then
                write(linha, string'("Ciclo "));
                write(linha, i);
                write(linha, string'(": v_n = "));
                write(linha, v_n_out);
                write(linha, string'(", u_n = "));
                write(linha, u_n_out);
                writeline(f_saida, linha);
            end if;
            
            -- Incrementa e reinicia o contador a cada 6 ciclos
            contador := (contador + 1) mod 6;
        end loop;

        wait; -- Fim da simulação
    end process;

end architecture;