library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memoria_ram is
    Generic(N        : natural := 10);
    Port ( clk       : in  STD_LOGIC;
           addr      : in  STD_LOGIC_VECTOR (N-1 downto 0);
           cs        : in  STD_LOGIC;
           wr        : in  STD_LOGIC_VECTOR (  3 downto 0);
           datain    : in  STD_LOGIC_VECTOR ( 31 downto 0);
           dataout   : out STD_LOGIC_VECTOR ( 31 downto 0));
end memoria_ram;

architecture Behavioral of memoria_ram is
   type T_RAM  is array (natural range <>) of std_logic_vector(7 downto 0);
   constant C_LEN_RAM   : natural := 2**N;
   signal   ram0        : T_RAM(C_LEN_RAM-1 downto 0) := (others => (others =>'0'));
   signal   ram1        : T_RAM(C_LEN_RAM-1 downto 0) := (others => (others =>'0'));
   signal   ram2        : T_RAM(C_LEN_RAM-1 downto 0) := (others => (others =>'0'));
   signal   ram3        : T_RAM(C_LEN_RAM-1 downto 0) := (others => (others =>'0'));
begin
   
   process(clk)
      variable addr_i   : natural range 0 to C_LEN_RAM-1;
   begin
      if rising_edge(clk) then
         addr_i  := to_integer(unsigned(addr));
         dataout <= ram3(addr_i) & ram2(addr_i) & ram1(addr_i) & ram0(addr_i);
         if wr(0) = '1' and cs = '1' then
            ram0(addr_i) <= datain( 7 downto  0);
         end if;
         if wr(1) = '1' and cs = '1' then
            ram1(addr_i) <= datain(15 downto  8);
         end if;
         if wr(2) = '1' and cs = '1' then
            ram2(addr_i) <= datain(23 downto 16);
         end if;
         if wr(3) = '1' and cs = '1' then
            ram3(addr_i) <= datain(31 downto 24);
         end if;
      end if;
   end process;
end Behavioral;
