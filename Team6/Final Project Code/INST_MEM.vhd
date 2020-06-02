LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY inst_ram IS
	PORT(
		clk : IN std_logic;
		wr  : IN std_logic;
		rd	: IN std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0);
		mem_loc_0_1 : OUT std_logic_vector(31 DOWNTO 0);
		mem_loc_2_3 : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY inst_ram;

ARCHITECTURE syncram OF inst_ram IS
	TYPE ram_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
-- INC R2,R2	
-- INC R3,R3	
-- DEC R4,R4	
-- ADD R1,R5,R2
-- STD R2,12
-- NOT R4
-- PUSH R1
	--SIGNAL ram : ram_type;
	SIGNAL ram : ram_type := (
	0=> "0100101001000000",
	1=> "0100101101100000",
	2=> "0101010010000000",
 	3=> "0010000110101000",
 	4=> "1010000001001111",
 	5=> "0000000000001100",
	6=> "0100010010000000",
	7=> "1000000000100000",
 	others=>"0111100000000000"
	);
	-- reset
	signal mem_loc_0 :std_logic_vector(31 DOWNTO 0);
	signal mem_loc_1 :std_logic_vector(31 DOWNTO 0);
	-- int
	signal mem_loc_2 :std_logic_vector(31 DOWNTO 0);
	signal mem_loc_3 :std_logic_vector(31 DOWNTO 0);
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF wr = '1' THEN
						ram(to_integer(unsigned(address(11 downto 0)))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		mem_loc_0 <= "00000000000000000000000000000000";
		mem_loc_1 <= "00000000000000000000000000000001";

		mem_loc_2 <= "00000000000000000000000000000010";
		mem_loc_3 <= "00000000000000000000000000000011";

		dataout <= ram(to_integer(unsigned(address(11 downto 0)))) when (rd = '1');
		mem_loc_0_1 <= ram(to_integer(unsigned(mem_loc_1)))& ram(to_integer(unsigned(mem_loc_0)));
		mem_loc_2_3 <= ram(to_integer(unsigned(mem_loc_3)))& ram(to_integer(unsigned(mem_loc_2)));
END syncram;