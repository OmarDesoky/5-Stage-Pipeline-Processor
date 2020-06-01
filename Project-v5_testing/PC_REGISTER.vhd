library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity PC_REGISTER is 

generic (size : integer := 32);

port (
    clk: in std_logic;
    rst_async: in std_logic;
    write_enb: in std_logic;
    d : in std_logic_vector(size-1 downto 0);
    mem_loc_0_1 : in std_logic_vector(size-1 downto 0);
    q : out std_logic_vector(size-1 downto 0)
);
end PC_REGISTER ;


architecture general_register of PC_REGISTER is

begin

process(clk,rst_async,write_enb,mem_loc_0_1)
begin
    if rst_async = '1' then
        q <= mem_loc_0_1;
    else
        if ( rising_edge(clk) and write_enb ='1' ) then
            q <= d;
        end if;
    end if;

end process;    

end general_register;