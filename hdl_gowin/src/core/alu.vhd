library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Generic(N      : natural := 32);
    Port (  clk    : in  STD_LOGIC;
            start  : in  STD_LOGIC;
            cmd    : in  STD_LOGIC_VECTOR (2 downto 0);
            param  : in  STD_LOGIC;
            selinm : in  STD_LOGIC;
            inm    : in  STD_LOGIC_VECTOR (11 downto 0);
            rs1    : in  STD_LOGIC_VECTOR (N-1 downto 0);
            rs2    : in  STD_LOGIC_VECTOR (N-1 downto 0);
            rd     : out STD_LOGIC_VECTOR (N-1 downto 0);
            rdy    : out STD_LOGIC);
end alu;

architecture Behavioral of alu is
   signal rd_add_sub :  std_logic_vector(N-1 downto 0);
   signal add_param  :  std_logic;
   signal rd_slt     :  std_logic;
   signal srla_msb   :  std_logic;
   signal op2        :  std_logic_vector(N-1 downto 0);
   signal rd_des     :  std_logic_vector(N-1 downto 0);
   signal ready_des  :  std_logic;
   signal start_des  :  std_logic;
begin
   
   srla_msb    <= rs1(N-1) and param;
   add_param   <= param and (not selinm);
   op2         <= rs2 when selinm = '0' else std_logic_vector(resize(signed(inm),N));
   rdy         <= ready_des when cmd = "101" or cmd = "001" else '1';          
   start_des   <= start     when cmd = "101" or cmd = "001" else '0'; 
   as:   entity work.addsub(Behavioral)
         generic map(N     => N)
         port map(   ans   => add_param,
                     rs1   => rs1,
                     rs2   => op2,
                     rd    => rd_add_sub);
   
   slt:  entity work.cmp(Behavioral)
         generic map(N     => N)
         port map   (rs1   => rs1,
                     rs2   => op2,
                     uns   => cmd(0),
                     eq    => open,
                     lt    => rd_slt);

   srdl: entity work.desplazamientos(Behavioral)
         port map (  clk   => clk,
                     load  => start_des,
                     r_nl  => cmd(2),
                     sr_in => srla_msb,
                     d     => rs1,
                     r     => op2(4 downto 0),
                     q     => rd_des,
                     ready => ready_des);

   with cmd select
      rd <= rd_add_sub                    when "000", --ADD/SUB
            rd_des                        when "001", --SLL
            (0 => rd_slt, others => '0')  when "010", --SLT
            (0 => rd_slt, others => '0')  when "011", --SLTU
             rs1 xor op2                  when "100", --XOR
             rd_des                       when "101", --SRL/SRA
             rs1  or op2                  when "110", --OR
             rs1 and op2                  when "111", --AND
            (others =>'0')                when others;
end Behavioral;
