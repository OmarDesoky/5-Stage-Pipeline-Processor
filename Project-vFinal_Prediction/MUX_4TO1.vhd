library ieee;
use ieee.std_logic_1164.all;

entity mux_4to1 is
generic (size : integer := 32);

Port (
    a: in std_logic_vector(size-1 downto 0);
    b: in std_logic_vector(size-1 downto 0);
    c: in std_logic_vector(size-1 downto 0);
    d: in std_logic_vector(size-1 downto 0);
    sel: in std_logic_vector(1 downto 0);
    y: out std_logic_vector(size-1 downto 0)
);                        
end mux_4to1;

architecture general_mux_4to1 of mux_4to1 is
begin
process(a, b, c, d, sel)
begin
	case sel is
	when "00" => y <= a;
    when "01" => y <= b;
    when "10" => y <= c;
    when others => y <= d;
	end case;
end process;
end general_mux_4to1;