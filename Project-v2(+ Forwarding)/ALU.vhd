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

begin

z1 <= F_i(31 downto 0);

process (a,b,sel,F_i) is
begin
z2 <= b;
	if sel = "0001" then																		-- SUB
		F_i <= std_logic_vector(resize(signed(a), 33) - resize(signed(b), 33));
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;

		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------

	elsif sel = "0010" then																		-- AND
		F_i <= '0' & (a and b);
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------
	elsif sel = "0011" then																			-- OR
		F_i <= '0' & (a or b);
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------
	elsif sel = "0100" then																			-- SWAP
		F_i <= '0' & (b);
		z2 <= a;

	elsif sel = "0101" then																			-- SHL
		F_i <= std_logic_vector( resize(signed(a), 33) sll to_integer(unsigned(b)));
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------
	elsif sel = "0110" then																			-- SHR
		F_i(31 downto 0)  <= std_logic_vector(shift_right(signed(a), to_integer(unsigned(b)) ) );
		F_i(32) <= '0';																
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------
	elsif sel = "0111" then 																		-- ADD
		F_i <= ('0' & a) + ('0' & b);
		-- F_i <= std_logic_vector(resize(signed(a), 33) + resize(signed(b), 33));
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------
	elsif sel = "1000" then																			-- NOT
		F_i <= '0' & (not a);
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------
	elsif sel = "1001" then																			-- INC
		F_i <= ('0' & a) + 1;
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);
		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;
		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);
		-----------------------------------------------------------------
	elsif sel = "1010" then																			-- DEC
		F_i <= ('0' & a) - 1;
		------------------------------Carry FLAG-------------------------
		carry_reg <= F_i(32);

		------------------------------Zero FLAG-------------------------
		if F_i = (F_i'range => '0') then
			zero_reg <= '1';
		else
			zero_reg <= '0';
		end if;

		------------------------------neg FLAG-------------------------
		neg_reg <= F_i(31);

		-----------------------------------------------------------------
	else																						-- NOP																						-- NOP
		F_i <= '0' & a;
	end if;
end process;

neg <=  neg_reg;
carry <= carry_reg;
zero <= zero_reg;

end Behavioral;