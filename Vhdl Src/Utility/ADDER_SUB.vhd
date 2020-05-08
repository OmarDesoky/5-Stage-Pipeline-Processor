library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
generic (size : integer := 32);

Port (
    a: in std_logic_vector(size-1 downto 0);
    sel: in std_logic_vector(1 downto 0);
    y: out std_logic_vector(size-1 downto 0)
);                        
end add_sub;

architecture adder_sub of add_sub is
    signal result: std_logic_vector(size downto 0); 
    signal temp : std_logic_vector(1 downto 0);
begin
    temp(0)<='1';
    temp(1)<='0';
process(a,sel,result)
begin
    if(sel ="10") then
        result <= std_logic_vector(resize(signed(a), size+1)+ signed(temp) );
        y<=result(size-1 downto 0);
    elsif(sel = "11") then
        result <= std_logic_vector(resize(signed(a), size+1)- signed(temp) );
        y<=result(size-1 downto 0);
    else
        y<=a;
    end if;
end process;
end adder_sub;