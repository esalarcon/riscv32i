library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity programa is
   Port ( clk   : in    STD_LOGIC;
          addra : in    STD_LOGIC_VECTOR (10 downto 0);
          addrb : in    STD_LOGIC_VECTOR (10 downto 0);
          douta : out   STD_LOGIC_VECTOR (31 downto 0);
          doutb : out   STD_LOGIC_VECTOR (31 downto 0));
end programa;

architecture Behavioral of programa is
   type memoria_rom is array (natural range <>) of std_logic_vector(31 downto 0);
   function inicializar_rom return memoria_rom is
      variable ret : memoria_rom(2047 downto 0) := (others => x"00000013");
   begin
      ret( 0) := x"08000113";
      ret( 1) := x"800001b7";
      ret( 2) := x"0e818193";
      ret( 3) := x"00000213";
      ret( 4) := x"00400293";
      ret( 5) := x"00520c63";
      ret( 6) := x"0001a303";
      ret( 7) := x"00622023";
      ret( 8) := x"00418193";
      ret( 9) := x"00420213";
      ret(10) := x"fedff06f";
      ret(11) := x"00400193";
      ret(12) := x"00800213";
      ret(13) := x"00418863";
      ret(14) := x"0001a023";
      ret(15) := x"00418193";
      ret(16) := x"ff5ff06f";
      ret(17) := x"04c0006f";
      ret(18) := x"ff010113";
      ret(19) := x"00112623";
      ret(20) := x"00812423";
      ret(21) := x"01010413";
      ret(22) := x"00002703";
      ret(23) := x"07f00793";
      ret(24) := x"00e7f863";
      ret(25) := x"00100713";
      ret(26) := x"00e02023";
      ret(27) := x"0100006f";
      ret(28) := x"00002783";
      ret(29) := x"00179713";
      ret(30) := x"00e02023";
      ret(31) := x"00000013";
      ret(32) := x"00c12083";
      ret(33) := x"00812403";
      ret(34) := x"01010113";
      ret(35) := x"00008067";
      ret(36) := x"fe010113";
      ret(37) := x"00112e23";
      ret(38) := x"00812c23";
      ret(39) := x"02010413";
      ret(40) := x"000027b7";
      ret(41) := x"fef42623";
      ret(42) := x"00300713";
      ret(43) := x"00e02223";
      ret(44) := x"00002783";
      ret(45) := x"00078713";
      ret(46) := x"fec42783";
      ret(47) := x"00e7a023";
      ret(48) := x"00402783";
      ret(49) := x"fff78713";
      ret(50) := x"00e02223";
      ret(51) := x"00402783";
      ret(52) := x"00079863";
      ret(53) := x"00300713";
      ret(54) := x"00e02223";
      ret(55) := x"f6dff0ef";
      ret(56) := x"10500073";
      ret(57) := x"fcdff06f";
      ret(58) := x"00000001";
      return ret;
   end inicializar_rom;
   signal rom : memoria_rom(2047 downto 0) := inicializar_rom;
begin
   process(clk)
      variable ia : natural range 0 to 2047;
      variable ib : natural range 0 to 2047;
   begin
      if(rising_edge(clk)) then
         ia := to_integer(unsigned(addra));
         ib := to_integer(unsigned(addrb));
         douta <= rom(ia);
         doutb <= rom(ib);
      end if;
   end process;
end Behavioral;
