library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity rv32i is
    Port ( clk          : in     STD_LOGIC;
           rst          : in     STD_LOGIC;
           wake_up      : in     STD_LOGIC;
           program_in   : in     STD_LOGIC_VECTOR (31 downto 0);
           program_addr : out    STD_LOGIC_VECTOR (31 downto 0);
           data_in      : in     STD_LOGIC_VECTOR (31 downto 0);
           data_out     : out    STD_LOGIC_VECTOR (31 downto 0);
           data_addr    : out    STD_LOGIC_VECTOR (31 downto 0);
           wr           : out    STD_LOGIC_VECTOR ( 3 downto 0));         
end rv32i;

architecture Behavioral of rv32i is
   signal ejecutar   :  std_logic;
     
   --IR.
   signal ir         :  std_logic_vector(31 downto 0);
   signal opcode     :  std_logic_vector(6 downto 0);
   
   --Banco de registros, seales.
   signal sel_rdin   :  std_logic_vector( 2 downto 0);
   signal rd_din     :  std_logic_vector(31 downto 0);
   signal rs1_dout   :  std_logic_vector(31 downto 0);
   signal rs2_dout   :  std_logic_vector(31 downto 0);
   signal wr_reg     :  std_logic;
   
   --Extendedor de signo LD
   signal din_sext   :  std_logic_vector(31 downto 0);
   signal din_32     :  std_logic_vector(31 downto 0);
   
   
   --Contador de programa (IP)
   signal pcout      :  std_logic_vector(31 downto 0);
   signal pcin       :  std_logic_vector(31 downto 0);
   signal pc_inc     :  std_logic;
   signal pc_en      :  std_logic;
   
   --ALU
   signal alu_out    :  std_logic_vector(31 downto 0);
   signal alu_op1    :  std_logic_vector(31 downto 0);
   signal alu_op2    :  std_logic_vector(31 downto 0);
   signal alu_inm    :  std_logic_vector(11 downto 0);
   signal alu_cmd    :  std_logic_vector( 2 downto 0);
   signal alu_sinm   :  std_logic;
   signal alu_param  :  std_logic;
   signal sel_op2    :  std_logic_vector( 1 downto 0);
   
   --Generador de saltos.
   signal branch     :  std_logic;
   signal jump_ok    :  std_logic;
   
   -- Generador de escrituras y lecturas.
   signal wr_pulse   :  std_logic;
   signal is_write   :  std_logic;
   
   --Instrucciones de saltos.
   signal adds_jalr  :  std_logic_vector(31 downto 0);
   signal adds_auipc :  std_logic_vector(31 downto 0);
   signal jal_op     :  std_logic_vector(31 downto 0);
   signal adds_jal   :  std_logic_vector(31 downto 0);
   signal brx_op     :  std_logic_vector(31 downto 0);
   signal adds_brx   :  std_logic_vector(31 downto 0);

   --Desplazamientos secuenciales
   signal alu_shift  :  std_logic;
   signal alu_ready  :  std_logic;
   signal alu_start  :  std_logic;
   
   --Instrucciones especiales
   --las codifico todas como wfi
   signal is_wfi     :  std_logic;
   
begin
   -- Seniales de control
   opcode      <= ir(6 downto 0);
   pc_en       <= ejecutar and jump_ok;
   pc_inc      <= (ejecutar and (not jump_ok));
   wr_reg      <= '0' when ir(5 downto 2)="1000" else ejecutar; 
   jump_ok     <= (branch or ir(2)) when ir(6 downto 4) = "110" else '0';
   is_write    <= '1' when ir(6 downto 2) = "01000" else '0';
   is_wfi      <= '1' when ir(6 downto 2) = "11100" else '0';
   alu_shift   <= '1' when ir(6 downto 2) = "01100" and ir(14 downto 12) = "101" else
                  '1' when ir(6 downto 2) = "00100" and ir(14 downto 12) = "101" else
                  '1' when ir(6 downto 2) = "00100" and ir(14 downto 12) = "001" else
                  '0';
   data_addr   <= alu_out;
   program_addr<= pcout;
   ir          <= program_in;

   --Discrimino si es un inmediato o Sx
   alu_inm(11 downto 5) <= ir(31 downto 25);
   alu_inm(4 downto 0)  <= ir(11 downto 7) when ir(5) = '1' and ir(2) = '0' else ir(24 downto 20);
 
   --Parmetro de la ALU para saber si suma o resta
   --o si desplaza a derecha con o sin signo.
   alu_param <= ir(30) when opcode(6)&opcode(4 downto 2) = "0100" else '0';
 
   --Cmd de la ALU
   alu_cmd  <= ir(14 downto 12) when ir(4 downto 2) = "100" else "000";
   alu_sinm <= '1' when    opcode(6 downto 2) = "11001" or
                           opcode(6 downto 2) = "00000" or
                           opcode(6 downto 2) = "01000" or
                           opcode(6 downto 2) = "00100" else '0';  
   
   --Elijo el op_1 de la ALU (AUIPC)
   with opcode(6 downto 2) select
   alu_op1 <=  pcout                   when  "00101", --AUIPC 
               pcout                   when  "11011", --JAL
               pcout                   when  "11000", --Bxx
               rs1_dout                when others;
 
   --Elijo el op_2 de la ALU.
   sel_op2 <= ir(4)&ir(2);
   with sel_op2 select
      alu_op2    <=  adds_brx                            when "00",     --Bxx
                     adds_jal                            when "01",     --JAL
                     rs2_dout                            when "10",     --RS2
                     adds_auipc                          when others;   --AUIPC
                     
   -- Elijo que guardo en RD                 
   sel_rdin  <= ir(5)&ir(4)&ir(2);
   with sel_rdin select
      rd_din     <=  din_sext                            when "000",    --LD
                     adds_jalr                           when "101",    --JALR
                     ir(31 downto 12) & x"000"           when "111",    --LUI
                     alu_out                             when others;   --OPs. 
   
   --Obtengo parametros para saltos.
   adds_jalr <= std_logic_vector(unsigned(pcout)+4);
   adds_auipc<= ir(31 downto 12)&x"000";
   adds_jal  <= jal_op; 
   jal_op    <= std_logic_vector(resize(signed(
                ir(31)&ir(19 downto 12)&ir(20)&ir(30 downto 21)&"0"
                ),32));
   adds_brx  <= brx_op;
   brx_op    <= std_logic_vector(resize(signed(
                ir(31)&ir(7)&ir(30 downto 25)&ir(11 downto 8)&"0"
                ),32));
   
   --JALR tambien pone a cero el bit 0 de PC
   pcin(31 downto 2) <= alu_out(31 downto 2);
   pcin(0) <= '0';
   
    --La memoria de programa tiene que estar alineada a 32 bits.
    --para este core.
   pcin(1)  <= '0';
   pcout(0) <= '0';
   pcout(1) <= '0';

   --FSM control
   cmp_fsm: entity work.fsm_control(Behavioral)
            port map(   clk         => clk,
                        rst         => rst,
                        ejecutar    => ejecutar,
                        is_write    => is_write,
                        is_wfi      => is_wfi,
                        wake_up     => wake_up,
                        is_alu      => alu_shift,
                        alu_ready   => alu_ready,
                        alu_start   => alu_start,
                        wr_pulse    => wr_pulse);

    -- Modulo de lectura del BUS.
    -- Lo usan las funciones LOAD
    -- La memoria debe estar alineada para que esto funcione.
    cmp_rd: entity work.readbus(Behavioral)
            port map(   addr_low    => alu_out(1 downto 0),
                        din_bus     => data_in,
                        dout        => din_32);

    -- Modulo de escritura en del BUS.
    -- Lo usan las funciones SW, SH, SB
    -- En funcion de si es byte, half o word.
    -- La memoria debe estar alineada.
    cmp_wr: entity work.writegen(Behavioral)
            port map(   genwr       => wr_pulse,
                        largo       => ir(13 downto 12),
                        dato        => rs2_dout,
                        addr_low    => alu_out(1 downto 0),
                        dato_bus    => data_out,
                        wr          => wr);

    --Contador de programa PC.
    cmp_pc: entity work.cnt(Behavioral)
            generic map(N        => 30)
            port map(   clk      => clk,
                        rst      => rst,
                        din      => pcin(31 downto 2),
                        load     => pc_en,
                        plus     => pc_inc,
                        dout     => pcout(31 downto 2));

    -- Registros del procesador.
    -- el registro 0 siempre queda en cero.
    cmp_rg: entity work.regs(Behavioral)
            port map(   clk      => clk,
                        wr       => wr_reg,
                        rd_addr  => ir(11 downto 7),
                        rs1_addr => ir(19 downto 15),
                        rs2_addr => ir(24 downto 20),
                        rd_din   => rd_din,
                        rs1_dout => rs1_dout,
                        rs2_dout => rs2_dout);
                        
    -- Bloque de extension de signo. Funciona con LOAD.
    cmp_ex: entity work.extendersigno(Behavioral)
            port map(   ain      => din_32,
                        noext    => ir(13),
                        usext    => ir(14),
                        ext16    => ir(12),
                        bout     => din_sext);

    -- Bloque que genera las comparaciones para los saltos.
    cmp_br: entity work.genb(Behavioral)
            port map(   rs1      => rs1_dout,
                        rs2      => rs2_dout,
                        cmd      => ir(14 downto 12),
                        bok      => branch);
 
   -- ALU
   cmp_alu: entity work.alu(Behavioral)
            generic map(N        => 32)
            port map(   clk      => clk,
                        start    => alu_start,
                        cmd      => alu_cmd,
                        param    => alu_param,
                        selinm   => alu_sinm,
                        inm      => alu_inm,
                        rs1      => alu_op1,
                        rs2      => alu_op2,
                        rd       => alu_out,
                        rdy      => alu_ready); 
end Behavioral;
