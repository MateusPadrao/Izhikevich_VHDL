library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity topo is
    
    -- dt: time := 1 ms -> 0.001 s

    port (
        clk : in std_logic;
        reset : in std_logic;
        enable_entrada : in std_logic; -- habilita a saida do topo
        enable_reg1_3 : in std_logic;
        enable_reg4_8 : in std_logic;
        enable_reg9_10 : in std_logic;
        enable_reg11_15 : in std_logic;
        v_n_out : out std_logic_vector(32 downto 0);
        u_n_out : out std_logic_vector(32 downto 0)
    );
end entity topo;

architecture behavior of topo is
    -- tonic spiking
    -- constant a: real := 0.02; 
    -- constant b: real := 0.2;
    -- constante c recebe -65 formatado em 33 bits, sendo o bit mais significativo o sinal, os 16 bits seguintes a parte inteira e os 16 bits restantes a parte decimal
    constant c: std_logic_vector(32 downto 0) := "111111111101111111111111111111111";
    -- constante d recebe 8 formatado em 33 bits, sendo o bit mais significativo o sinal, os 16 bits seguintes a parte inteira e os 16 bits restantes a parte decimal
    constant d: std_logic_vector(32 downto 0) := "000000000000010000000000000000000"; -- 8

    -- tonic bursting
    -- constant a: real := 0.02;
    -- constant b: real := 0.2;
    -- constant c: real := -50;
    -- constant d: real := 2;

    constant vth: std_logic_vector(32 downto 0) := "000000000000111100000000000000000"; -- 30

    signal saida_MUX_top: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_MUX_down: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_comparador: std_logic := '0';
    signal v_n: std_logic_vector(32 downto 0);
    signal u_n: std_logic_vector(32 downto 0);
    signal first_cycle : std_logic := '1';
    
    -- Registradores numerados conforme PNG na pasta --
    signal saida_reg1: std_logic_vector(32 downto 0);
    signal saida_reg2: std_logic_vector(32 downto 0);
    signal saida_reg3: std_logic_vector(32 downto 0);
    signal saida_reg4: std_logic_vector(32 downto 0);
    signal saida_reg5: std_logic_vector(32 downto 0);
    signal saida_reg6: std_logic_vector(32 downto 0);
    signal saida_reg7: std_logic_vector(32 downto 0);
    signal saida_reg8: std_logic_vector(32 downto 0);
    signal saida_reg9: std_logic_vector(32 downto 0);
    signal saida_reg10: std_logic_vector(32 downto 0);
    signal saida_reg11: std_logic_vector(32 downto 0);
    signal saida_reg12: std_logic_vector(32 downto 0);
    signal saida_reg13: std_logic_vector(32 downto 0);
    signal saida_reg14: std_logic_vector(32 downto 0);
    signal saida_reg15: std_logic_vector(32 downto 0);

    -- Auxiliares para shifts compostos --
    signal saida_desloc: std_logic_vector(32 downto 0);
    signal saida_desloc_p1: std_logic_vector(32 downto 0);
    signal saida_desloc_p2: std_logic_vector(32 downto 0);

    signal saida_reg10_aux: std_logic_vector(32 downto 0);
    signal saida_reg10_aux_p1: std_logic_vector(32 downto 0);
    signal saida_reg10_aux_p2: std_logic_vector(32 downto 0);
    signal saida_reg10_aux_p3: std_logic_vector(32 downto 0);
    
    signal saida_reg4_aux: std_logic_vector(32 downto 0);
    signal saida_reg4_aux_p1: std_logic_vector(32 downto 0);
    signal saida_reg4_aux_p2: std_logic_vector(32 downto 0);
    signal saida_reg4_aux_p3: std_logic_vector(32 downto 0);
    signal saida_reg4_aux_p4: std_logic_vector(32 downto 0);
    signal saida_reg4_aux_p5: std_logic_vector(32 downto 0);
    signal saida_reg4_aux_p6: std_logic_vector(32 downto 0);
    signal saida_reg4_aux_p7: std_logic_vector(32 downto 0);

    signal saida_reg5_aux: std_logic_vector(32 downto 0);
    signal saida_reg5_aux_p1: std_logic_vector(32 downto 0);

    signal saida_reg2_aux: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p1: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p2: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p3: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p4: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p5: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p6: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p7: std_logic_vector(32 downto 0);
    signal saida_reg2_aux_p8: std_logic_vector(32 downto 0);

    signal multiplicacao: std_logic_vector(65 downto 0);

    begin
        -- SAÍDA -- Ciclo 1
        process (clk, reset)
        begin
            if reset = '1' then
                v_n <= c; -- valor inicial de v_n = -65
                u_n <= "111111111111100111111111111111111"; -- valor inicial de u_n = d
                first_cycle <= '1';
            elsif rising_edge(clk) then
                if enable_entrada = '1' then
                  if first_cycle = '1' then
                    v_n <= c; -- valor inicial de v_n = -65
                    u_n <= "111111111111100111111111111111111"; -- valor inicial de u_n = -13
                    first_cycle <= '0';
                  elsif first_cycle = '0' then
                    v_n <= saida_MUX_top; -- v_n recebe o valor do multiplexador de cima
                    u_n <= saida_MUX_down; -- u_n recebe o valor do multiplexador de baixo

                 	end if;
                end if;
            end if;
        end process;
        
        v_n_out <= v_n;
        u_n_out <= u_n;

        -- MULTIPLEXADORES --
        saida_MUX_top <= saida_reg12 when saida_comparador = '0' else saida_reg13;
        saida_MUX_down <= saida_reg14 when saida_comparador = '0' else (saida_reg14 + saida_reg15);

        -- COMPARADOR --
        process (saida_reg11, saida_reg12)
        begin
            if saida_reg12 >= saida_reg11 then
                saida_comparador <= '1';
            else
                saida_comparador <= '0';
            end if;
        end process;

        -- REGISTRADORES DE 11 A 15 -- Ciclo 5
        -- saida_desloc recebe saida_reg 9 deslocada tantos bits a direita, que eh uma divisao por 1000 feita com shifts a direita
        saida_desloc_p1 <= std_logic_vector((signed(saida_reg9) sra 10)); -- parte 1 da composicao de somas
        saida_desloc_p2 <= std_logic_vector((signed(saida_reg9) sra 16)); -- parte 2 da composicao de somas
        saida_desloc <= saida_desloc_p1 + saida_desloc_p2; -- soma das partes

        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg11 <= vth;
                saida_reg12 <= (others => '0');
                saida_reg13 <= c;
                saida_reg14 <= (others => '0');
                saida_reg15 <= d;
            elsif rising_edge(clk) then
                if enable_reg11_15 = '1' then
                    saida_reg11 <= vth;
                    saida_reg12 <= saida_desloc + v_n;
                    saida_reg13 <= c;
                    saida_reg14 <= saida_reg10 + u_n;
                    saida_reg15 <= d;
                end if;
            end if;
        end process;

        -- REGISTRADORES DE 9 E 10 -- Ciclo 4
        -- saida_reg10 recebe saida_reg8 deslocada tantos bits a direita, que eh uma divisao por 5000 feita com shifts a direita
        saida_reg10_aux_p1 <= std_logic_vector((signed(saida_reg8) sra 13)); -- parte 1 da composicao de somas
        saida_reg10_aux_p2 <= std_logic_vector((signed(saida_reg8) sra 14)); -- parte 2 da composicao de somas
        saida_reg10_aux_p3 <= std_logic_vector((signed(saida_reg8) sra 16)); -- parte 3 da composicao de somas
        saida_reg10_aux <= saida_reg10_aux_p1 + saida_reg10_aux_p2 + saida_reg10_aux_p3; -- soma das partes
        
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg9 <= (others => '0');
                saida_reg10 <= (others => '0');
            elsif rising_edge(clk) then
                if enable_reg9_10 = '1' then
                    saida_reg9 <= saida_reg4 + saida_reg5 + saida_reg6 + saida_reg7 - saida_reg3;
                    saida_reg10 <= saida_reg10_aux; -- du_n/(a*dt) -> du_n
                end if;
            end if;
        end process;

        -- REGISTRADORES DE 4 A 8 -- Ciclo 3
        -- saida_reg4 recebe saida_reg1 deslocada tantos bits a direita, que eh uma divisao por 25 feita com shifts a direita
        saida_reg4_aux_p1 <= std_logic_vector((signed(saida_reg1) sra 5)); -- parte 1 da composicao de somas
        saida_reg4_aux_p2 <= std_logic_vector((signed(saida_reg1) sra 7)); -- parte 2 da composicao de somas
        saida_reg4_aux_p3 <= std_logic_vector((signed(saida_reg1) sra 11)); -- parte 3 da composicao de somas
        saida_reg4_aux_p4 <= std_logic_vector((signed(saida_reg1) sra 12)); -- parte 4 da composicao de somas
        saida_reg4_aux_p5 <= std_logic_vector((signed(saida_reg1) sra 13)); -- parte 5 da composicao de somas
        saida_reg4_aux_p6 <= std_logic_vector((signed(saida_reg1) sra 14)); -- parte 6 da composicao de somas
        saida_reg4_aux_p7 <= std_logic_vector((signed(saida_reg1) sra 16)); -- parte 7 da composicao de somas
        saida_reg4_aux <= saida_reg4_aux_p1 + saida_reg4_aux_p2 + saida_reg4_aux_p3 + saida_reg4_aux_p4 + saida_reg4_aux_p5 + saida_reg4_aux_p6 + saida_reg4_aux_p7; -- soma das partes

        saida_reg5_aux_p1 <= std_logic_vector((signed(v_n) sll 2)); 
        saida_reg5_aux <= saida_reg5_aux_p1 + v_n; -- saida_reg2 * 5

        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg4 <= (others => '0');
                saida_reg5 <= (others => '0');
                saida_reg6 <= "000000000000101000000000000000000"; -- I_n = 10
                saida_reg7 <= "000000000100011000000000000000000"; -- 140 
                saida_reg8 <= (others => '0');
            elsif rising_edge(clk) then
                if enable_reg4_8 = '1' then
                    saida_reg4 <= saida_reg4_aux;
                    saida_reg5 <= saida_reg5_aux; -- saida_reg1 * 5
                    saida_reg6 <= "000000000000101000000000000000000"; -- I_n = 10
                    saida_reg7 <= "000000000100011000000000000000000"; -- 140 
                    saida_reg8 <= saida_reg2 - saida_reg3;
                end if;
            end if;
        end process;

        -- REGISTRADORES DE 1 A 3 -- Ciclo 2
        -- saida_reg2 recebe b * v_n, onde b = 0.2, logo, saida_reg2 recebe v_n deslocado tantos bits a direita, que eh uma divisao por 5 feita com shifts a direita
        saida_reg2_aux_p1 <= std_logic_vector((signed(v_n) sra 3)); -- parte 1 da composicao de somas
        saida_reg2_aux_p2 <= std_logic_vector((signed(v_n) sra 4)); -- parte 2 da composicao de somas
        saida_reg2_aux_p3 <= std_logic_vector((signed(v_n) sra 7)); -- parte 3 da composicao de somas
        saida_reg2_aux_p4 <= std_logic_vector((signed(v_n) sra 8)); -- parte 4 da composicao de somas
        saida_reg2_aux_p5 <= std_logic_vector((signed(v_n) sra 11)); -- parte 5 da composicao de somas
        saida_reg2_aux_p6 <= std_logic_vector((signed(v_n) sra 12)); -- parte 6 da composicao de somas
        saida_reg2_aux_p7 <= std_logic_vector((signed(v_n) sra 15)); -- parte 7 da composicao de somas
        saida_reg2_aux_p8 <= std_logic_vector((signed(v_n) sra 16)); -- parte 8 da composicao de somas
        saida_reg2_aux <= saida_reg2_aux_p1 + saida_reg2_aux_p2 + saida_reg2_aux_p3 + saida_reg2_aux_p4 + saida_reg2_aux_p5 + saida_reg2_aux_p6 + saida_reg2_aux_p7 + saida_reg2_aux_p8; -- soma das partes

        multiplicacao <= std_logic_vector(signed(v_n) * signed(v_n));
        
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg1 <= (others => '0');
                saida_reg2 <= (others => '0');
                saida_reg3 <= (others => '0');
            elsif rising_edge(clk) then
                if enable_reg1_3 = '1' then
                    saida_reg1 <= multiplicacao(48 downto 16); -- v_n * v_n, 66 bits, pega os 33 bits mais significativos
                    saida_reg2 <= saida_reg2_aux; -- b * v_n
                    saida_reg3 <= u_n;
                end if;
            end if;
        end process;
end behavior;

