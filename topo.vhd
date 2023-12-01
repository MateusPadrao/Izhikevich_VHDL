library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity topo is
    port (
        clk : in std_logic;
        reset : in std_logic;
        v_n: in std_logic_vector(32 downto 0);
        u_n: in std_logic_vector(32 downto 0);
        v_n1: out std_logic_vector(32 downto 0);
        u_n1: out std_logic_vector(32 downto 0)
    );
end entity topo;

architecture behavior of topo is
    -- tonic spiking
    constant a: real := 0.02;
    constant b: real := 0.2;
    constant c: real := -65;
    constant d: real := 8;

    -- tonic bursting
    -- constant a: real := 0.02;
    -- constant b: real := 0.2;
    -- constant c: real := -50;
    -- constant d: real := 2;

    constant vth: real := 30; -- conferir
    constant l_n: real := 0.5; -- conferir

    signal saida_MUX_norte: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_MUX_sul: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_comparador: std_logic := '0';
    
    -- Registradores numerados conforme PNG na pasta --
    signal saida_reg1: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg2: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg3: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg4: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg5: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg6: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg7: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg8: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg9: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg12: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg13: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg14: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg15: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg16: std_logic_vector(32 downto 0):= (others => '0');

    signal 

    begin
        -- REGISTRADORES DE SAÍDA --
        process (clk, reset)
        begin
            if reset = '1' then
                v_n1 <= (others => '0');
                u_n1 <= (others => '0');
            elsif rising_edge(clk) then
                v_n1 <= saida_MUX_norte;
                u_n1 <= saida_MUX_sul;
            end if;
        end process;

        -- MULTIPLEXADORES --
        saida_MUX_norte <= saida_reg13 when saida_comparador = '0' else saida_reg14;
        saida_MUX_sul <= saida_reg15 when saida_comparador = '0' else (saida_reg15 + saida_reg16);

        -- COMPARADOR --
        process (saida_reg12, saida_reg13)
        begin
            if saida_reg12 = saida_reg13 then
                saida_comparador <= '1';
            else
                saida_comparador <= '0';
            end if;
        end process;

        -- REGISTRADORES DE 12 A 16 --
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg12 <= (others => '0');
                saida_reg13 <= (others => '0');
                saida_reg14 <= (others => '0');
                saida_reg15 <= (others => '0');
                saida_reg16 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg12 <= vth;
                saida_reg13 <= v_n + saida_reg9;
                saida_reg14 <= c;
                saida_reg15 <= saida_reg11 + u_n;
                saida_reg16 <= d;
            end if;
        end process;

        -- REGISTRADORES DE 9 A 11 --
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg9 <= (others => '0');
                saida_reg10 <= (others => '0');
                saida_reg11 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg9 <= saida_reg10 sll (d * v_n); -- conferir
                saida_reg10 <= saida_reg3 + saida_reg5 + saida_reg6 + saida_reg7 + saida_reg8;
                saida_reg11 <= saida_reg4 srl (d * u_n); -- conferir
            end if;
        end process;

        -- REGISTRADORES DE 5 A 8 --
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg5 <= (others => '0');
                saida_reg6 <= (others => '0');
                saida_reg7 <= (others => '0');
                saida_reg8 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg5 <= saida_reg1 srl (0.04 * (v_n * v_n)); -- conferir
                saida_reg6 <= v_n sll (5 * v_n); -- conferir
                saida_reg7 <= l_n;
                saida_reg8 <= 140;
            end if;
        end process;
        
        -- FC_CORDIC -- 

        fc_cordic <= v_n * v_n;
        
        -- REGISTRADORES DE 1 A 4 --
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg1 <= (others => '0');
                saida_reg2 <= (others => '0');
                saida_reg3 <= (others => '0');
                saida_reg4 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg1 <= fc_cordic;
                saida_reg2 <= v_n srl (b * v_n); -- conferir
                saida_reg3 <= (others => '0') - u_n; -- inversão de sinal
                saida_reg4 <= saida_reg2 + saida_reg3;
            end if;
        end process;
end behavior;