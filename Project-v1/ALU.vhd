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
signal carry_reg: std_logic := '0';
signal zero_reg: std_logic := '0';
signal neg_reg: std_logic := '0';

-- signal flags : std_logic_vector(2 downto 0) := "000";
begin

z1 <= F_i(31 downto 0);

process (a,b,sel,F_i,carry_reg,neg_reg,zero_reg) is
begin
z2 <= b;
case sel is	
	when "0001" =>																			-- SUB
		F_i <= std_logic_vector(resize(signed(a), 33) - resize(signed(b), 33));
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "0010" =>																			-- AND
		F_i <= '0' & (a and b);
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "0011" =>																			-- OR
		F_i <= '0' & (a or b);
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "0100" =>																			-- SWAP
		F_i <= '0' & (b);
		z2 <= a;

		neg <=  neg_reg;
		zero <= zero_reg;
		carry <= carry_reg;
	when "0101" =>																			-- SHL
		F_i <= std_logic_vector( resize(signed(a), 33) sll to_integer(unsigned(b)));
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "0110" =>																			-- SHR
		F_i(31 downto 0)  <= std_logic_vector(shift_right(signed(a), to_integer(unsigned(b)) ) );
		F_i(32) <= '0';																
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "0111" =>																			-- ADD
		F_i <= ('0' & a) + ('0' & b);
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "1000" =>																			-- NOT
		F_i <= '0' & (not a);
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "1001" =>																			-- INC
		F_i <= ('0' & a) + 1;
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when "1010" =>																			-- DEC
		F_i <= ('0' & a) - 1;
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		carry <= carry_reg ;
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		zero <= zero_reg;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		neg<= neg_reg;
		-----------------------------------------------------------------
	when others =>																			-- NOP
		F_i <= '0' & a;

		neg <=  neg_reg;
		zero <= zero_reg;
		carry <= carry_reg;
end case;
end process;
end Behavioral;