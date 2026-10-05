library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_micro_ejemplo is
-- Testbench sin puertos
end tb_micro_ejemplo;

architecture Behavioral of tb_micro_ejemplo is

-- Frecuencia de prueba: 27 MHz (periodo ~ 37.037 ns)
constant CLK_PERIOD : time := 10 ns;

-- Señales de prueba
signal pclk          : std_logic := '0';
signal anrst         : std_logic := '0'; -- Reset activo en bajo
signal puerto_salida : std_logic_vector(2 downto 0);


begin

-- Instanciación del UUT (Unit Under Test)
uut: entity work.micro_ejemplo
    port map(   clk     => pclk,
                key_a   => anrst, 
                key_b   => '1', -- No se utiliza en este testbench
                nled    => puerto_salida
            );

-- Generador de Reloj
clk_process : process
begin
    pclk <= '0';
    wait for CLK_PERIOD / 2;
    pclk <= '1';
    wait for CLK_PERIOD / 2;
end process;

-- Generador de Reset y Estímulo
stim_process: process
begin
    -- Estado inicial: Reset activo
    anrst <= '0';
    wait for 200 ns;

    -- Liberar Reset
    anrst <= '1';
    
    -- Dejar correr la simulación
    wait;
end process;


end Behavioral;