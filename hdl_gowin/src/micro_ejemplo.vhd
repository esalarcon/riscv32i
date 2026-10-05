library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity micro_ejemplo is
    Port ( clk             : in  STD_LOGIC;
           key_a           : in  STD_LOGIC;
           key_b           : in  STD_LOGIC;
           nled            : out  STD_LOGIC_VECTOR (2 downto 0));
end micro_ejemplo;

architecture Behavioral of micro_ejemplo is
   constant C_FCLK            : natural := 27_000_000;
   constant C_FTIC            : natural := 27;
   constant CS_RAM            : std_logic_vector(1 downto 0) := "00";
   constant CS_OUTPORT        : std_logic_vector(1 downto 0) := "01";
   
   signal rst_in              : std_logic;
   signal rst                 : std_logic;
   signal data_in, data_out   : std_logic_vector(31 downto 0);
   signal data_addr           : std_logic_vector(31 downto 0);
   signal pin                 : std_logic_vector(31 downto 0);
   signal paddr               : std_logic_vector(31 downto 0);
   signal wr                  : std_logic_vector( 3 downto 0);
   signal data_ram            : std_logic_vector(31 downto 0);
   signal data_per            : std_logic_vector(31 downto 0);
   signal data_rom            : std_logic_vector(31 downto 0);
   signal c_ram               : std_logic;
   signal c_port              : std_logic;
   signal wake_up             : std_logic;
   signal puerto_salida       : std_logic_vector(7 downto 0);        
begin

    nled <= not puerto_salida(2 downto 0);

   --decodifico
   c_ram   <= not data_addr(31) when data_addr(14 downto 13) = CS_RAM       else '0';
   c_port  <= not data_addr(31) when data_addr(14 downto 13) = CS_OUTPORT   else '0'; 
  
   --Decodifico perifericos. 
   with data_addr(14 downto 13) select
      data_per <= data_ram          when CS_RAM,
                  (others => '0')   when others;
  
   --Lo hago Von Neumann. Los dos gigas mas altos son de programa.
   --Si, dos gigas. Aca tenes la estacion de poder...
   data_in <= data_rom when data_addr(31) = '1' else data_per;
   
        
   --Genero el reset
   rst_in <= key_a and key_b;
   genrst:  entity work.genrst(rtl) 
            port map(   clk         => clk,
                        i_anrst     => rst_in, 
                        o_rst       => rst);

   --Instancio el core rv32i
   core: entity work.rv32i(Behavioral)
         port map(clk          => clk,
                  rst          => rst,
                  wake_up      => wake_up,
                  program_in   => pin,
                  program_addr => paddr,
                  data_in      => data_in,
                  data_out     => data_out,
                  data_addr    => data_addr,
                  wr           => wr);

   --Memoria de programa 256 bytes. 64 palabras de 32 bits. 6 bits de direccion.
   rom:  entity work.programa(Behavioral)
         generic map(   NBITS  => 6)
         port map(clk          => clk,
                  addra        => paddr(7 downto 2),
                  douta        => pin,
                  addrb        => data_addr(7 downto 2),
                  doutb        => data_rom);  

   --Memoria de datos 128 bytes. 32 palabras de 32 bits. 5 bits de direccion.
   mram: entity work.memoria_ram(Behavioral) 
         generic map(   N      => 5)
         port map(clk          => clk,
                  addr         => data_addr(6 downto 2),
                  cs           => c_ram,
                  wr           => wr,
                  datain       => data_out,
                  dataout      => data_ram);

   --Genero un puerto de salida de 8 bits.
   op:   entity work.puerto_salida(Behavioral)
         generic map(   N      => 8)
         port map(clk          => clk,
                  rst          => rst,
                  wr           => wr(0),
                  cs           => c_port,
                  datain       => data_out(7 downto 0),
                  pins         => puerto_salida);

   --Despierto al micro periodicamente.
   tgen: entity work.engen(Behavioral)
         generic map(G_FCLK   => C_FCLK,
                     G_FREQ   => C_FTIC)
         port map(   clk      => clk,
                     rst      => rst,
                     o_en     => wake_up);

end Behavioral;

