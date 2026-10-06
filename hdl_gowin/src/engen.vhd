library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity engen is
    Generic(G_FCLK: natural := 40_000_000;
            G_FREQ: natural := 100_000);
    Port ( clk    : in  STD_LOGIC;
           rst    : in  STD_LOGIC;
           o_en   : out STD_LOGIC);
end engen;

architecture Behavioral of engen is
    function ceil_log2(n : natural) return natural is 
        variable valor      : natural := n;
        variable resultado  : natural := 0; 
    begin
        while valor > 0 loop
            valor := valor /2;
            resultado := resultado + 1;
        end loop;
        return resultado;
    end function;
    constant C_NBITS :  natural := ceil_log2(G_FCLK/G_FREQ);
    constant C_VAL   :  natural := G_FCLK/G_FREQ-1;
    signal cnt       :  unsigned(C_NBITS-1 downto 0);
    signal z         :  std_logic;
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1' or z = '1') then
            cnt <= to_unsigned(C_VAL,C_NBITS);
         else
            cnt <= cnt - 1;
         end if;
      end if;
   end process;
   z     <= '1' when cnt = to_unsigned(0,C_NBITS) else '0';
   o_en  <= z;
end Behavioral;
