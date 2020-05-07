library ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity Clock is

port (
clk_v : out std_logic
);
end Clock ;

ARCHITECTURE Clock_architecture OF Clock IS
Signal Clk: STD_LOGIC := '0';
Constant Clk_half_period: Time:= 0.05ns;
BEGIN
clk_v <= Clk;
Clk <= Not clk after Clk_half_period;
END Clock_architecture;
