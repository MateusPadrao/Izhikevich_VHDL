library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity topo is
    
    -- dt: time := 1 ms -> 0.001 s

    port (
        clk : in std_logic;
        reset : in std_logic;
        v_n_out : out std_logic_vector(32 downto 0); -- saida do neurônio para o testbench
        u_n_out : out std_logic_vector(32 downto 0)  -- saida do neurônio para o testbench
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
    signal saida_reg16: std_logic_vector(32 downto 0);

    -- Auxiliares para shifts compostos --
    signal saida_reg11_aux: std_logic_vector(32 downto 0);
    signal saida_reg11_aux_p1: std_logic_vector(32 downto 0);
    signal saida_reg11_aux_p2: std_logic_vector(32 downto 0);

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
                v_n <= "111111111101111111111111111111111"; -- valor inicial de v_n = -65
                u_n <= "111111111111100111111111111111111"; -- valor inicial de u_n = -13
            elsif rising_edge(clk) then
                v_n <= saida_MUX_top;
                u_n <= saida_MUX_down;
            end if;
        end process;
        
        v_n_out <= v_n;
        u_n_out <= u_n;

        -- MULTIPLEXADORES --
        saida_MUX_top <= saida_reg15 when saida_comparador = '0' else saida_reg16;
        saida_MUX_down <= saida_reg12 when saida_comparador = '0' else (saida_reg12 + saida_reg13);

        -- COMPARADOR --
        process (saida_reg14, saida_reg15)
        begin
            if saida_reg15 >= saida_reg14 then
                saida_comparador <= '1';
            else
                saida_comparador <= '0';
            end if;
        end process;

        -- REGISTRADORES DE 14 A 16 -- Ciclo 6
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg14 <= (others => '0');
                saida_reg15 <= (others => '0');
                saida_reg16 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg14 <= vth;
                saida_reg15 <= saida_reg11 + v_n;
                saida_reg16 <= c;
            end if;
        end process;

        -- REGISTRADORES DE 11 A 13 -- Ciclo 5
        -- saida_reg11 recebe saida_reg 9 deslocada tantos bits a direita, que eh uma divisao por 1000 feita com shifts a direita
        saida_reg11_aux_p1 <= to_stdlogicvector((to_bitvector(saida_reg9) srl 10)); -- parte 1 da composicao de somas
        saida_reg11_aux_p2 <= to_stdlogicvector((to_bitvector(saida_reg9) srl 16)); -- parte 2 da composicao de somas
        saida_reg11_aux <= saida_reg11_aux_p1 + saida_reg11_aux_p2; -- soma das partes

        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg11 <= (others => '0');
                saida_reg12 <= (others => '0');
                saida_reg13 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg11 <= saida_reg11_aux; -- dv_n/dt
                saida_reg12 <= saida_reg10 + u_n;
                saida_reg13 <= d; -- constante d
            end if;
        end process;

        -- REGISTRADORES DE 9 E 10 -- Ciclo 4
        -- saida_reg10 recebe saida_reg8 deslocada tantos bits a direita, que eh uma divisao por 5000 feita com shifts a direita
        saida_reg10_aux_p1 <= to_stdlogicvector((to_bitvector(saida_reg8) srl 13)); -- parte 1 da composicao de somas
        saida_reg10_aux_p2 <= to_stdlogicvector((to_bitvector(saida_reg8) srl 14)); -- parte 2 da composicao de somas
        saida_reg10_aux_p3 <= to_stdlogicvector((to_bitvector(saida_reg8) srl 16)); -- parte 3 da composicao de somas
        saida_reg10_aux <= saida_reg10_aux_p1 + saida_reg10_aux_p2 + saida_reg10_aux_p3; -- soma das partes
        
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg9 <= (others => '0');
                saida_reg10 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg9 <= saida_reg4 + saida_reg5 + saida_reg6 + saida_reg7 - saida_reg3;
                saida_reg10 <= saida_reg10_aux; -- du_n/(a*dt) -> du_n
        end if;
        end process;

        -- REGISTRADORES DE 4 A 8 -- Ciclo 3
        -- saida_reg4 recebe saida_reg1 deslocada tantos bits a direita, que eh uma divisao por 25 feita com shifts a direita
        saida_reg4_aux_p1 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 5)); -- parte 1 da composicao de somas
        saida_reg4_aux_p2 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 7)); -- parte 2 da composicao de somas
        saida_reg4_aux_p3 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 11)); -- parte 3 da composicao de somas
        saida_reg4_aux_p4 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 12)); -- parte 4 da composicao de somas
        saida_reg4_aux_p5 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 13)); -- parte 5 da composicao de somas
        saida_reg4_aux_p6 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 14)); -- parte 6 da composicao de somas
        saida_reg4_aux_p7 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 16)); -- parte 7 da composicao de somas
        saida_reg4_aux <= saida_reg4_aux_p1 + saida_reg4_aux_p2 + saida_reg4_aux_p3 + saida_reg4_aux_p4 + saida_reg4_aux_p5 + saida_reg4_aux_p6 + saida_reg4_aux_p7; -- soma das partes

        saida_reg5_aux_p1 <= to_stdlogicvector((to_bitvector(v_n) sll 2)); 
        saida_reg5_aux <= saida_reg5_aux_p1 + v_n; -- saida_reg2 * 5

        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg4 <= (others => '0');
                saida_reg5 <= (others => '0');
                saida_reg6 <= (others => '0');
                saida_reg7 <= (others => '0');
                saida_reg8 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg4 <= saida_reg4_aux;
                saida_reg5 <= saida_reg5_aux; -- saida_reg1 * 5
                saida_reg6 <= "000000000000101000000000000000000"; -- I_n = 10
                saida_reg7 <= "000000000100011000000000000000000"; -- 140 
                saida_reg8 <= saida_reg2 - saida_reg3;
            end if;
        end process;

        -- REGISTRADORES DE 1 A 3 -- Ciclo 2
        -- saida_reg2 recebe b * v_n, onde b = 0.2, logo, saida_reg2 recebe v_n deslocado tantos bits a direita, que eh uma divisao por 5 feita com shifts a direita
        saida_reg2_aux_p1 <= to_stdlogicvector((to_bitvector(v_n) srl 3)); -- parte 1 da composicao de somas
        saida_reg2_aux_p2 <= to_stdlogicvector((to_bitvector(v_n) srl 4)); -- parte 2 da composicao de somas
        saida_reg2_aux_p3 <= to_stdlogicvector((to_bitvector(v_n) srl 7)); -- parte 3 da composicao de somas
        saida_reg2_aux_p4 <= to_stdlogicvector((to_bitvector(v_n) srl 8)); -- parte 4 da composicao de somas
        saida_reg2_aux_p5 <= to_stdlogicvector((to_bitvector(v_n) srl 11)); -- parte 5 da composicao de somas
        saida_reg2_aux_p6 <= to_stdlogicvector((to_bitvector(v_n) srl 12)); -- parte 6 da composicao de somas
        saida_reg2_aux_p7 <= to_stdlogicvector((to_bitvector(v_n) srl 15)); -- parte 7 da composicao de somas
        saida_reg2_aux_p8 <= to_stdlogicvector((to_bitvector(v_n) srl 16)); -- parte 8 da composicao de somas
        saida_reg2_aux <= saida_reg2_aux_p1 + saida_reg2_aux_p2 + saida_reg2_aux_p3 + saida_reg2_aux_p4 + saida_reg2_aux_p5 + saida_reg2_aux_p6 + saida_reg2_aux_p7 + saida_reg2_aux_p8; -- soma das partes

        multiplicacao <= v_n * v_n;
        
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg1 <= (others => '0');
                saida_reg2 <= (others => '0');
                saida_reg3 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg1 <= multiplicacao(65 downto 33); -- v_n * v_n, 66 bits, pega os 33 bits mais significativos
                saida_reg2 <= saida_reg2_aux; -- b * v_n
                saida_reg3 <= u_n;
            end if;
        end process;
end behavior;