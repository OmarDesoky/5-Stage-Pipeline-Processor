library ieee;
use ieee.std_logic_1164.all;

entity mux_8to1 is
generic (size : integer := 32);

Port (
    a: in std_logic_vector(size-1 downto 0);
    b: in std_logic_vector(size-1 downto 0);
    c: in std_logic_vector(size-1 downto 0);
    d: in std_logic_vector(size-1 downto 0);
    e: in std_logic_vector(size-1 downto 0);
    f: in std_logic_vector(size-1 downto 0);
    g: in std_logic_vector(size-1 downto 0);
    h: in std_logic_vector(size-1 downto 0);
    sel: in std_logic_vector(2 downto 0);
    y: out std_logic_vector(size-1 downto 0)
);                        
end mux_8to1;

architecture general_mux_8to1 of mux_8to1 is
begin
process(a, b, c, d, e, f, g, h, sel)
begin
	case sel is
	when "000" => y <= a;
    when "001" => y <= b;
    when "010" => y <= c;
	when "011" => y <= d;
    when "100" => y <= e;
    when "101" => y <= f;
    when "110" => y <= g;
    when others => y <= h;
	end case;
end process;
end general_mux_8to1;