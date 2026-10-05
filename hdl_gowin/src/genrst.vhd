library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity genrst is 
    port (  clk     :   in  STD_LOGIC;
            i_anrst :   in  STD_LOGIC; 
            o_rst   :   out STD_LOGIC);
end entity;

architecture rtl of genrst is
    signal d    :   std_logic_vector(1 downto 0);
begin  
    process(clk, i_anrst)
    begin
        if i_anrst = '0' then
            d <= (others => '1');
        elsif rising_edge(clk) then
            d(1) <= d(0);
            d(0) <= '0';
        end if;
    end process;
    o_rst <= d(1);
end architecture;
