library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programa is
    generic (
        NBITS : integer := 6
    );
    port (
        clk   : in  std_logic;
        addra : in  std_logic_vector(NBITS-1 downto 0);
        addrb : in  std_logic_vector(NBITS-1 downto 0);
        douta : out std_logic_vector(31 downto 0);
        doutb : out std_logic_vector(31 downto 0)
    );
end programa;

architecture Behavioral of programa is

    constant DEPTH : integer := 2**NBITS;

    type memoria_rom is array (0 to DEPTH-1) of
        std_logic_vector(31 downto 0);

    constant ROM : memoria_rom := (
         0 => x"08000113",
         1 => x"800001b7",
         2 => x"0e818193",
         3 => x"00000213",
         4 => x"00400293",
         5 => x"00520c63",
         6 => x"0001a303",
         7 => x"00622023",
         8 => x"00418193",
         9 => x"00420213",
        10 => x"fedff06f",
        11 => x"00400193",
        12 => x"00800213",
        13 => x"00418863",
        14 => x"0001a023",
        15 => x"00418193",
        16 => x"ff5ff06f",
        17 => x"04c0006f",
        18 => x"ff010113",
        19 => x"00112623",
        20 => x"00812423",
        21 => x"01010413",
        22 => x"00002703",
        23 => x"07f00793",
        24 => x"00e7f863",
        25 => x"00100713",
        26 => x"00e02023",
        27 => x"0100006f",
        28 => x"00002783",
        29 => x"00179713",
        30 => x"00e02023",
        31 => x"00000013",
        32 => x"00c12083",
        33 => x"00812403",
        34 => x"01010113",
        35 => x"00008067",
        36 => x"fe010113",
        37 => x"00112e23",
        38 => x"00812c23",
        39 => x"02010413",
        40 => x"000027b7",
        41 => x"fef42623",
        42 => x"00300713",
        43 => x"00e02223",
        44 => x"00002783",
        45 => x"00078713",
        46 => x"fec42783",
        47 => x"00e7a023",
        48 => x"00402783",
        49 => x"fff78713",
        50 => x"00e02223",
        51 => x"00402783",
        52 => x"00079863",
        53 => x"00300713",
        54 => x"00e02223",
        55 => x"f6dff0ef",
        56 => x"10500073",
        57 => x"fcdff06f",
        58 => x"00000001",
        others => x"00000013"
    );

begin
    process(clk)
    begin
        if rising_edge(clk) then
            douta <= ROM(to_integer(unsigned(addra)));
            doutb <= ROM(to_integer(unsigned(addrb)));
        end if;
    end process;
end architecture;
