library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
Port (
    zero_flag :     in std_logic;
    last_taken :    in std_logic;
    if_JZ :         in std_logic;

    flush :         out std_logic
);                        
end comparator;

architecture COMP_ARCH of comparator is

begin
    if(if_JZ ='0') then
        flush <= '0';
    else
        if zero_flag = last_taken then
            flush <= '0';
        else
            flush <= '1';
        end if ;
    end if;
end COMP_ARCH;