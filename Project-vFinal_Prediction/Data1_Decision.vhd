library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data1_Decision is
Port (
    int :in std_logic;
    opcode :in std_logic_vector(4 downto 0);
    Reg_data1 :in std_logic_vector(31 downto 0);
    flags :in std_logic_vector(31 downto 0);
    DataIN_IOModule :in std_logic_vector(31 downto 0);
    output :out std_logic_vector(31 downto 0)
);                        
end Data1_Decision;

architecture COMP_ARCH of Data1_Decision is
begin
process(int, opcode, Reg_data1, flags, DataIN_IOModule)
begin 
if (int = '1')then 
    output <= flags;
elsif (opcode = "01100")then
    output<= DataIN_IOModule;
else
    output <= Reg_data1;
end if; 
end process;
end COMP_ARCH;