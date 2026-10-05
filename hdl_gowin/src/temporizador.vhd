library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.MATH_REAL.ALL;

entity temporizador is
  Generic(G_FCLK: natural := 40_000_000;
          G_FREQ: natural := 100_000);
    Port ( clk       : in  STD_LOGIC;
           rst       : in  STD_LOGIC;
           cs        : in  STD_LOGIC;
           wr        : in  STD_LOGIC;
           desborde  : out STD_LOGIC);
end temporizador;

architecture Behavioral of temporizador is
   signal tic        :  std_logic;
begin

    --Genero los ticks de 1ms
   tgen: entity work.engen(Behavioral)
         generic map(G_FCLK   => G_FCLK,
                     G_FREQ   => G_FREQ)
         port map(   clk      => clk,
                     rst      => rst,
                     o_en     => tic);

   process(clk)
   begin
      if rising_edge(clk) then
         if (cs = '1' and wr = '1') or rst = '1' then 
            desborde <= '0';
         elsif tic = '1' then
            desborde <= '1';
         end if;
      end if;
   end process;   
end Behavioral;
