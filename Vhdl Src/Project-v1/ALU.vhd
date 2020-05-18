library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_STD.ALL;

entity alu is
 Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
 b : in STD_LOGIC_VECTOR (31 downto 0);
 z1 : out STD_LOGIC_VECTOR (31 downto 0);
 z2 : out STD_LOGIC_VECTOR (31 downto 0);
 zero: out std_logic;
 carry: out std_logic;
 neg: out std_logic;
 sel : in STD_LOGIC_VECTOR (3 downto 0));
end alu;

architecture Behavioral of alu is

signal F_i : std_logic_vector(32 downto 0) := "000000000000000000000000000000000";
begin

neg <= F_i(31);
zero <= '1' when F_i(31 downto 0) = "00000000000000000000000000000000" else '0';
carry <= F_i(32);
z1 <= F_i(31 downto 0);

process (a,b,sel) is
begin
z2 <= a;
case sel is	
	when "0000" =>
		F_i <= '0' & (a);
	when "0001" =>
		F_i <= std_logic_vector(resize(signed(a), 33) - resize(signed(b), 33));
	when "0010" =>
		F_i <= '0' & (a and b);
	when "0011" =>
		F_i <= '0' & (a or b);
	when "0100" =>
		F_i <= '0' & (b);
	when "0101" =>
		F_i <= std_logic_vector(unsigned(('0' & a)) sll to_integer(unsigned(b)));
	when "0110" =>
		F_i <= std_logic_vector(unsigned((a & '0')) srl to_integer(unsigned(b)));
	when "0111" =>
		F_i <= ('0' & a) + ('0' & b);
	when "1000" =>
		F_i <= '0' & (not a);
	when "1001" =>
		F_i <= ('0' & a) + 1;
	when "1010" =>
		F_i <= ('0' & a) - 1;
	when others =>
		F_i <= '0' & a;
end case;
end process;
end Behavioral;