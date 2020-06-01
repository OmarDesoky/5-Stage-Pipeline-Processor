library ieee;
use ieee.std_logic_1164.all;

entity mux_2to_1 is

generic (size : integer := 32);

Port (
    a: in std_logic_vector(size-1 downto 0);
    b: in std_logic_vector(size-1 downto 0);
    sel: in std_logic;
    y: out std_logic_vector(size-1 downto 0)
);                        
end mux_2to_1;

architecture general_mux_2to_1 of mux_2to_1 is

begin
    y <= b when (sel ='1') else a;
end general_mux_2to_1;