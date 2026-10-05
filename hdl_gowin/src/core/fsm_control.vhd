library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm_control is
    Port ( clk          : in    STD_LOGIC;
           rst          : in    STD_LOGIC;
           is_write     : in    STD_LOGIC;
           is_wfi       : in    STD_LOGIC;
           wake_up      : in    STD_LOGIC;
           is_alu       : in    STD_LOGIC;
           alu_ready    : in    STD_LOGIC;
           alu_start    : out   STD_LOGIC;
           ejecutar     : out   STD_LOGIC;
           wr_pulse     : out   STD_LOGIC);
end fsm_control;

architecture Behavioral of fsm_control is
   type estado is (S0, S1, S2, S3, S4, S5, S6);
   signal actual, futuro:  estado;
begin
   --FSM
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            actual      <= S0;
         else
            actual      <= futuro;
         end if;
      end if;
   end process;

   process(actual, is_write, is_alu, alu_ready, is_wfi, wake_up)
   begin
      case actual is
         when S0 =>  
                     --Voy a buscar.
                     futuro <= S1;
         when S1 =>
                     --Decodifico.
                     if is_wfi = '1' then
                        futuro <= S6;
                     elsif is_alu = '1' then
                        futuro <= S3;
                     else
                        futuro <= S5;
                     end if;
         when S5 =>
                     --Ejecuto
                     futuro <= S2;
         when S2 =>
                     --Escribo registros.
                     futuro <= S0;
         when S3 =>
                     futuro <= S4;
         when S4 =>
                     if alu_ready = '1' then
                        futuro <= S2;
                     else
                        futuro <= S4;
                     end if;
         when S6 =>
                     --Mande a "dormir" al core.
                     --Hasta que no venga wake_up en uno (nivel)
                     --se queda acá.
                     if wake_up = '1' then
                        futuro <= S0;
                     else
                        futuro <= S6;
                     end if;
      end case;
   end process;


   process(actual, is_write, wake_up)
   begin
      case actual is
         when S0 =>
                     ejecutar       <= '0';
                     wr_pulse       <= '0';
                     alu_start      <= '0';
         when S1 =>
                     ejecutar       <= '0';
                     wr_pulse       <= '0';
                     alu_start      <= '0';
        when S2 =>
                     ejecutar       <= '1';
                     wr_pulse       <= is_write;
                     alu_start      <= '0';
        when S3 =>
                     ejecutar       <= '0';
                     wr_pulse       <= '0';
                     alu_start      <= '1';
        when S4 =>
                     ejecutar       <= '0';
                     wr_pulse       <= '0';
                     alu_start      <= '0';
        when S5 =>
                     ejecutar       <= '0';
                     wr_pulse       <= '0';
                     alu_start      <= '0';
        when S6 =>
                     ejecutar       <= wake_up;
                     wr_pulse       <= '0';
                     alu_start      <= '0';
      end case;
   end process; 
end Behavioral;
