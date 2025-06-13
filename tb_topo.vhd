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

    -- Sinal para monitorar o valor do contador na simulacao
    signal contador_sig : integer := 1;

    -- Sinais de enable para cada grupo de registradores
    signal enable_entrada      : std_logic := '0';
    signal enable_reg1_3     : std_logic := '0';
    signal enable_reg4_8     : std_logic := '0';
    signal enable_reg9_10    : std_logic := '0';
    signal enable_reg11_15   : std_logic := '0';

    file f_saida : text open write_mode is "saida_neuronio.txt";

    -- Componente a ser testado
    component topo
        port (
            clk            : in  std_logic;
            reset          : in  std_logic;
            enable_entrada   : in  std_logic;
            enable_reg1_3  : in  std_logic;
            enable_reg4_8  : in  std_logic;
            enable_reg9_10 : in  std_logic;
            enable_reg11_15: in  std_logic;
            v_n_out        : out std_logic_vector(32 downto 0);
            u_n_out        : out std_logic_vector(32 downto 0)
        );
    end component;

begin

    -- Instanciacao do DUT
    uut: topo
        port map (
            clk            => clk,
            reset          => reset,
            enable_entrada   => enable_entrada,
            enable_reg1_3  => enable_reg1_3,
            enable_reg4_8  => enable_reg4_8,
            enable_reg9_10 => enable_reg9_10,
            enable_reg11_15=> enable_reg11_15,
            v_n_out        => v_n_out,
            u_n_out        => u_n_out
        );

    -- Geracao do clock (20ns de periodo => 50MHz)
    clk <= not clk after 10 ns;

    process
        variable linha : line;
        variable contador : integer := 1; -- Inicia em 1
    begin
        -- Reset ativo por 40 ns
        wait for 40 ns;
        reset <= '0';

        for i in 0 to 50000 loop 
            wait until rising_edge(clk);

            -- Atualiza o sinal para visualizacao na simulacao
            contador_sig <= contador;

            -- Geracao dos enables conforme o valor do contador
            if contador = 1 then
                enable_entrada  <= '1';
                enable_reg1_3   <= '0';
                enable_reg4_8   <= '0';
                enable_reg9_10  <= '0';
                enable_reg11_15 <= '0';
                
            elsif contador = 2 then
                enable_entrada  <= '0';
                enable_reg1_3   <= '1';
                enable_reg4_8   <= '0';
                enable_reg9_10  <= '0';
                enable_reg11_15 <= '0';
                
            elsif contador = 3 then
                enable_entrada  <= '0';
                enable_reg1_3   <= '0';
                enable_reg4_8   <= '1';
                enable_reg9_10  <= '0';
                enable_reg11_15 <= '0';
                
            elsif contador = 4 then
                enable_entrada  <= '0';
                enable_reg1_3   <= '0';
                enable_reg4_8   <= '0';
                enable_reg9_10  <= '1';
                enable_reg11_15 <= '0';
                
            elsif contador = 5 then
                enable_entrada  <= '0';
                enable_reg1_3   <= '0';
                enable_reg4_8   <= '0';
                enable_reg9_10  <= '0';
                enable_reg11_15 <= '1';
                
            end if;

            -- Coleta dados apenas a cada 5 ciclos
            if contador = 3 then
                write(linha, string'("Ciclo "));
                write(linha, i+1);
                write(linha, string'(": v_n = "));
                write(linha, v_n_out);
                write(linha, string'(", u_n = "));
                write(linha, u_n_out);
                writeline(f_saida, linha);
            end if;

            -- Incrementa e reinicia o contador de 1 a 5
            if contador = 5 then
                contador := 1;
            else
                contador := contador + 1;
            end if;
        end loop;

        wait; -- Fim da simulacao
    end process;

end architecture;

