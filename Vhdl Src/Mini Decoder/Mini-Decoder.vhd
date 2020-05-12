library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_STD.ALL;

entity MINI_DECODER is
 Port ( inst : in STD_LOGIC_VECTOR (15 downto 0);
 clk : in STD_LOGIC;
 reset : in STD_LOGIC;
 type_bit_1 : out STD_LOGIC;
 type_bit_2 : out STD_LOGIC;
 reg_src : out STD_LOGIC_VECTOR (2 downto 0);
 op_code : out STD_LOGIC_VECTOR (4 downto 0));
end MINI_DECODER;

architecture mini_decoder of MINI_DECODER is

signal counter : integer range 0 to 1;

begin
	process (clk, reset) is
	begin
		if (reset = '1') then
			type_bit_1 <= '0';
			type_bit_2 <= '0';
			reg_src <= "000";
			op_code <= "01111";

		elsif (rising_edge(clk)) then
			reg_src <= inst(7 downto 5);
			
			-- JZ
			if ((inst(15 downto 11) = "11000") and (counter = 0)) then
				type_bit_1 <= '1';
				type_bit_2 <= '1';
				op_code <= inst(15 downto 11);
				
			-- JMP
			elsif ((inst(15 downto 11) = "11001") and counter = 0) then
				type_bit_1 <= '1';
				type_bit_2 <= '0';
				op_code <= inst(15 downto 11);
				
			-- Other Operation
			else
				type_bit_1 <= '0';
				type_bit_2 <= '0';
				
				if (counter = 1) then 
					op_code <= "01111";
					counter <= 0;
				else
					op_code <= inst(15 downto 11);
					if (((inst(15 downto 11)) = "00010") or ((inst(15 downto 11)) = "00000") or ((inst(15 downto 11)) = "00001") or ((inst(15 downto 11)) = "10010") or ((inst(15 downto 11)) = "10011") or ((inst(15 downto 11)) = "10100")) then
						counter <= 1;
					end if;
				end if;
			end if;
		end if;
	end process;
end mini_decoder;