library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity n_bit_register is 

generic (size : integer := 32);

port (
    clk: in std_logic;
    rst_async: in std_logic;
    write_enb: in std_logic;
    d : in std_logic_vector(size-1 downto 0);
    q : out std_logic_vector(size-1 downto 0)
);
end n_bit_register ;


architecture general_register of n_bit_register is

begin

process(clk,rst_async,write_enb)
begin
    if rst_async = '1' then
        q <= (others => '0');
    else
        if ( rising_edge(clk) and write_enb ='1' ) then
            q <= d;
        end if;
    end if;

end process;    

end general_register;