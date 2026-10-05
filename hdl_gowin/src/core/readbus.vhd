library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity readbus is
    Port ( addr_low  : in  STD_LOGIC_VECTOR ( 1 downto 0);
           din_bus   : in  STD_LOGIC_VECTOR (31 downto 0);
           dout      : out STD_LOGIC_VECTOR (31 downto 0));
end readbus;

architecture Behavioral of readbus is
    signal addr_i           : std_logic_vector(1 downto 0);
    signal lb0              : std_logic_vector(7 downto 0);
    signal lb1              : std_logic_vector(7 downto 0);
begin
   dout(31 downto 16)   <= din_bus(31 downto 16);
   dout(15 downto  0)   <= lb1&lb0;
   
   with addr_low select
      lb0   <= din_bus( 7 downto  0) when "00",
               din_bus(15 downto  8) when "01",
               din_bus(23 downto 16) when "10",
               din_bus(31 downto 24) when "11",
               (others => '0')       when others;
   
   with addr_low(1) select
      lb1   <= din_bus(15 downto  8) when '0',
               din_bus(31 downto 24) when '1',
               (others => '0')       when others;
    
end Behavioral;
