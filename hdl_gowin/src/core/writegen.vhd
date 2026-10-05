library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity writegen is
    Port ( genwr     : in  STD_LOGIC;
           largo     : in  STD_LOGIC_VECTOR ( 1 downto 0);
           dato      : in  STD_LOGIC_VECTOR (31 downto 0);
           addr_low  : in  STD_LOGIC_VECTOR ( 1 downto 0);
           dato_bus  : out STD_LOGIC_VECTOR (31 downto 0);
           wr        : out STD_LOGIC_VECTOR ( 3 downto 0));
end writegen;

architecture Behavioral of writegen is
   signal wr_i       :  std_logic_vector(3 downto 0);
   signal wr_g       :  std_logic_vector(3 downto 0);
begin
   dato_bus(7 downto 0) <= dato(7 downto 0);
   wr(3)                <= wr_g(3) and genwr;
   wr(2)                <= wr_g(2) and genwr;
   wr(1)                <= wr_g(1) and genwr;
   wr(0)                <= wr_g(0) and genwr;
   
   with largo select
      wr_i <= "0001"    when "00",
              "0011"    when "01",
              "1111"    when "10",
              "0000"    when others;


   with addr_low(0) select
      dato_bus(15 downto 8) <= dato(15 downto  8) when '0',
                               dato( 7 downto  0) when '1',
                               (others => '0')    when others;
                               
   with addr_low(1) select
      dato_bus(23 downto 16)  <= dato(23 downto 16) when '0' ,
                                 dato( 7 downto  0) when '1',
                                 (others => '0')    when others;  

   with addr_low  select
      dato_bus(31 downto 24)  <= dato(31 downto 24) when "00",
                                 dato(15 downto  8) when "10",
                                 dato( 7 downto  0) when "11",
                                 (others => '0')    when others;

   with addr_low select
      wr_g <=  wr_i(3)&wr_i(2)&wr_i(0)&wr_i(1)     when  "01",    --Solo se genera con byte.
               wr_i(1)&wr_i(0)&wr_i(3)&wr_i(2)     when  "10",    --Solo se genera con byte o half.
               wr_i(0)&wr_i(3)&wr_i(2)&wr_i(1)     when  "11",    --Solo se genera con byte.
               wr_i                                when others;   --Se genera como word, half, byte
end Behavioral;
