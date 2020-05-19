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
signal flags : std_logic_vector(2 downto 0) := "000";
begin

z1 <= F_i(31 downto 0);

process (a,b,sel) is
begin
z2 <= b;
case sel is	
	when "0001" =>
		F_i <= std_logic_vector(resize(signed(a), 33) - resize(signed(b), 33));
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "0010" =>
		F_i <= '0' & (a and b);
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "0011" =>
		F_i <= '0' & (a or b);
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "0101" =>
		F_i <= std_logic_vector( resize(signed(a), 33) sll to_integer(unsigned(b)));
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "0110" =>
		F_i <= std_logic_vector( resize(signed(a), 33)  srl to_integer(signed(b)));
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "0111" =>
		F_i <= ('0' & a) + ('0' & b);
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "1000" =>
		F_i <= '0' & (not a);
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "1001" =>
		F_i <= ('0' & a) + 1;
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when "1010" =>
		F_i <= ('0' & a) - 1;
		flags(2) <= F_i(31);
		if (F_i(31 downto 0) = "00000000000000000000000000000000") then
			flags(1) <= '1';
		else
			flags(1) <= '0';
		end if;
		flags(0) <= F_i(32);
	when others =>
		F_i <= '0' & a;
end case;
	neg <= flags(2);
	zero <= flags(1);
	carry <= flags(0);
end process;
end Behavioral;