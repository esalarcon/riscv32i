library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity desplazamientos is
    Port (  clk     : in    STD_LOGIC;
            load    : in    STD_LOGIC;
            r_nl    : in    STD_LOGIC;
            sr_in   : in    STD_LOGIC;
            d       : in    STD_LOGIC_VECTOR (31 downto 0);
            r       : in    STD_LOGIC_VECTOR ( 4 downto 0);
            q       : out   STD_LOGIC_VECTOR (31 downto 0);
            ready   : out   STD_LOGIC);
end desplazamientos;

architecture Behavioral of desplazamientos is
    signal cnt      : unsigned(4 downto 0) := (others => '0');
    signal sr       : std_logic_vector(31 downto 0) := (others => '0');
    signal z        : std_logic := '0';
    
begin
    z       <= '1'   when cnt = "00000" else '0';
    
    process(clk)
    begin
      if rising_edge(clk) then
         ready <= z and not load;
      end if;
    end process;
    
    process(sr,r_nl)
        variable i : natural range 0 to 31;
    begin
        if r_nl = '0' then
            q <= sr;
        else
            for i in 0 to 31 loop
                q(31-i) <= sr(i);
            end loop;
        end if;
    end process;

    process(clk)
    variable i : natural;
    begin
        if(rising_edge(clk)) then
            if load = '1' then
                cnt <= unsigned(r);
            elsif z = '0' then
                cnt <= cnt - 1;
            end if;
        end if;
    end process;

    process(clk)
        variable i : natural range 0 to 31;
    begin
        if(rising_edge(clk)) then
            if load = '1' then
                if r_nl = '0' then
                    sr <= d;
                else
                    for i in 0 to 31 loop
                        sr(31-i) <= d(i);
                    end loop;
                end if;
            elsif z = '0' then
                sr(31 downto 1) <= sr(30 downto 0);
                sr(0) <= sr_in;
            end if;
        end if;
    end process;
end Behavioral;
