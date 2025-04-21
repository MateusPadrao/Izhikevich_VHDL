library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity topo is
    
    -- dt: time := 1 ms -> 0.001 s

    port (
        clk : in std_logic;
        reset : in std_logic
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
    constant I_n: std_logic_vector(32 downto 0) := "000000000000000001000000000000000"; -- 0.5

    signal saida_MUX_norte: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_MUX_sul: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_comparador: std_logic := '0';
    signal fc_cordic: std_logic_vector(65 downto 0):= (others => '0');
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

    -- Auxiliares --

    signal saida_reg9_aux: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg10_aux: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux2: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg1_aux: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2: std_logic_vector(32 downto 0):= (others => '0');

    -- Auxiliares para shifts compostos --

    signal saida_reg9_aux_p1: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg9_aux_p2: std_logic_vector(32 downto 0):= (others => '0');
    
    signal saida_reg11_aux_p1: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux_p2: std_logic_vector(32 downto 0):= (others => '0');
    
    signal saida_reg11_aux2_p1: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux2_p2: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux2_p3: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux2_p4: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux2_p5: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg11_aux2_p6: std_logic_vector(32 downto 0):= (others => '0');

    signal saida_reg1_aux_p1: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg1_aux_p2: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg1_aux_p3: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg1_aux_p4: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg1_aux_p5: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg1_aux_p6: std_logic_vector(32 downto 0):= (others => '0');
    signal saida_reg1_aux_p7: std_logic_vector(32 downto 0):= (others => '0');

    signal v_n_aux_p1: std_logic_vector(32 downto 0):= (others => '0');

    signal v_n_aux2_p1: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2_p2: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2_p3: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2_p4: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2_p5: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2_p6: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2_p7: std_logic_vector(32 downto 0):= (others => '0');
    signal v_n_aux2_p8: std_logic_vector(32 downto 0):= (others => '0');


    begin
        -- SAÍDA --
        process (clk, reset)
        begin
            if reset = '1' then
                v_n <= "111111111101111111111111111111111"; -- valor inicial de v_n = -65
                u_n <= "111111111111100111111111111111111"; -- valor inicial de u_n = -13
            elsif rising_edge(clk) then
                v_n <= saida_MUX_norte;
                u_n <= saida_MUX_sul;
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
        -- saida_reg9 recebe dv_n/dt * dt => (0,04 * (v_n ** 2) + 5 * v_n + 140 - u_n + I_n) * dt
        -- logo, saida_reg9 recebe saida_reg10 deslocada tantos bits a esquerda, que é 0,001, então é uma divisão por 1000 feita com shifts a direita
        saida_reg9_aux_p1 <= to_stdlogicvector((to_bitvector(saida_reg10) srl 10)); -- parte 1 da composição de somas
        saida_reg9_aux_p2 <= to_stdlogicvector((to_bitvector(saida_reg10) srl 16)); -- parte 2 da composição de somas
        saida_reg9_aux <= saida_reg9_aux_p1 + saida_reg9_aux_p2; -- soma das partes
        
        saida_reg10_aux <= saida_reg3 + saida_reg5 + saida_reg6 + saida_reg7 + saida_reg8; -- u_n + 0,04 * (v_n ** 2) + 5 * v_n + 140 + I_n
        
        -- saida_reg11 recebe du_n/a*dt * dt => a * (b * v_n - u_n) * dt
        -- logo, saida_reg11 recebe saida_reg4 deslocada tantos bits à direita a depender do valor resultante em du_n
        saida_reg11_aux_p1 <= to_stdlogicvector((to_bitvector(saida_reg4) srl 10)); -- parte 1 da composição de somas
        saida_reg11_aux_p2 <= to_stdlogicvector((to_bitvector(saida_reg4) srl 16)); -- parte 2 da composição de somas
        saida_reg11_aux <= saida_reg11_aux_p1 + saida_reg11_aux_p2; -- soma das partes

        saida_reg11_aux2_p1 <= to_stdlogicvector((to_bitvector(saida_reg11_aux) srl 6)); -- parte 1 da composição de somas
        saida_reg11_aux2_p2 <= to_stdlogicvector((to_bitvector(saida_reg11_aux) srl 8)); -- parte 2 da composição de somas
        saida_reg11_aux2_p3 <= to_stdlogicvector((to_bitvector(saida_reg11_aux) srl 12)); -- parte 3 da composição de somas
        saida_reg11_aux2_p4 <= to_stdlogicvector((to_bitvector(saida_reg11_aux) srl 13)); -- parte 4 da composição de somas
        saida_reg11_aux2_p5 <= to_stdlogicvector((to_bitvector(saida_reg11_aux) srl 14)); -- parte 5 da composição de somas
        saida_reg11_aux2_p6 <= to_stdlogicvector((to_bitvector(saida_reg11_aux) srl 15)); -- parte 6 da composição de somas
        saida_reg11_aux2 <= saida_reg11_aux2_p1 + saida_reg11_aux2_p2 + saida_reg11_aux2_p3 + saida_reg11_aux2_p4 + saida_reg11_aux2_p5 + saida_reg11_aux2_p6; -- soma das partes

        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg9 <= (others => '0');
                saida_reg10 <= (others => '0');
                saida_reg11 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg9 <= saida_reg9_aux;               
                saida_reg10 <= saida_reg10_aux;
                saida_reg11 <= saida_reg11_aux2;                
            end if;
        end process;

        -- REGISTRADORES DE 4 A 8 --
        saida_reg1_aux_p1 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 5)); -- parte 1 da composição de somas
        saida_reg1_aux_p2 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 7)); -- parte 2 da composição de somas
        saida_reg1_aux_p3 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 11)); -- parte 3 da composição de somas
        saida_reg1_aux_p4 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 12)); -- parte 4 da composição de somas
        saida_reg1_aux_p5 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 13)); -- parte 5 da composição de somas
        saida_reg1_aux_p6 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 14)); -- parte 6 da composição de somas
        saida_reg1_aux_p7 <= to_stdlogicvector((to_bitvector(saida_reg1) srl 16)); -- parte 7 da composição de somas
        saida_reg1_aux <= saida_reg1_aux_p1 + saida_reg1_aux_p2 + saida_reg1_aux_p3 + saida_reg1_aux_p4 + saida_reg1_aux_p5 + saida_reg1_aux_p6 + saida_reg1_aux_p7; -- soma das partes
         
        v_n_aux_p1 <= to_stdlogicvector((to_bitvector(v_n) sll 2)); -- parte 1 da composição de somas
        v_n_aux <= v_n_aux_p1 + v_n; -- 4 * v_n + v_n = 5 * v_n  

        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg4 <= (others => '0');
                saida_reg5 <= (others => '0');
                saida_reg6 <= (others => '0');
                saida_reg7 <= (others => '0');
                saida_reg8 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg4 <= saida_reg2 - saida_reg3;
                saida_reg5 <= saida_reg1_aux;
                saida_reg6 <= v_n_aux;
                saida_reg7 <= I_n;
                saida_reg8 <= "000000000100011000000000000000000"; -- 140
            end if;
        end process;
        
        -- FC_CORDIC -- 

        fc_cordic <= v_n * v_n;
        
        -- REGISTRADORES DE 1 A 3 --
        v_n_aux2_p1 <= to_stdlogicvector((to_bitvector(v_n) srl 3)); -- parte 1 da composição de somas
        v_n_aux2_p2 <= to_stdlogicvector((to_bitvector(v_n) srl 4)); -- parte 2 da composição de somas
        v_n_aux2_p3 <= to_stdlogicvector((to_bitvector(v_n) srl 7)); -- parte 3 da composição de somas
        v_n_aux2_p4 <= to_stdlogicvector((to_bitvector(v_n) srl 8)); -- parte 4 da composição de somas
        v_n_aux2_p5 <= to_stdlogicvector((to_bitvector(v_n) srl 11)); -- parte 5 da composição de somas
        v_n_aux2_p6 <= to_stdlogicvector((to_bitvector(v_n) srl 12)); -- parte 6 da composição de somas
        v_n_aux2_p7 <= to_stdlogicvector((to_bitvector(v_n) srl 15)); -- parte 7 da composição de somas
        v_n_aux2_p8 <= to_stdlogicvector((to_bitvector(v_n) srl 16)); -- parte 8 da composição de somas
        v_n_aux2 <= v_n_aux2_p1 + v_n_aux2_p2 + v_n_aux2_p3 + v_n_aux2_p4 + v_n_aux2_p5 + v_n_aux2_p6 + v_n_aux2_p7 + v_n_aux2_p8; -- soma das partes
    
        
        process (clk, reset)
        begin
            if reset = '1' then
                saida_reg1 <= (others => '0');
                saida_reg2 <= (others => '0');
                saida_reg3 <= (others => '0');
            elsif rising_edge(clk) then
                saida_reg1 <= fc_cordic(65 downto 33);
                saida_reg2 <= v_n_aux2;
                saida_reg3 <= u_n;
            end if;
        end process;
end behavior;
