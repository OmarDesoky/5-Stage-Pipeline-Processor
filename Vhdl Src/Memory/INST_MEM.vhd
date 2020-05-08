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
		mem_loc_2_3 : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY inst_ram;

ARCHITECTURE syncram OF inst_ram IS
	TYPE ram_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);

	--SIGNAL ram : ram_type;
	SIGNAL ram : ram_type := (
	 0=> "1111100100000000",
 	1=> "1111100100000000",
 	2=> "1111100100000000",
 	3=> "0000001111000001",
	 4=> "0000000000000001",
 	5=> "0000001111000010",
 	6=> "0000000000000010",
	 7=> "0000001111000011",
 	8=> "0000000000000011",
	 9=> "0000001111000100",
 	10=> "0000000000000100",
 	11=> "0000001111000101",
	 12=> "0000000000000101",
	 13=> "1011001000000001",
 	14=> "1010101000000010",
 	15=> "1010011000000011",
 	16=> "1010010000000100",
 	17=> "1101000000000001",
	 18=> "1010000000000101",
 	19=> "1111101000000000",
 	20=> "0000000000010001",
 	21=> "1101000011110011",
 	22=> "0001000001000010",
	 23=> "1111100100000000",
 	24=> "1111101100000000",
 	others=>X"0000"
	);
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
		mem_loc_2 <= "00000000000000000000000000000010";
		mem_loc_3 <= "00000000000000000000000000000011";
		dataout <= ram(to_integer(unsigned(address(11 downto 0)))) when (rd = '1');
		mem_loc_2_3 <= ram(to_integer(unsigned(mem_loc_2)))& ram(to_integer(unsigned(mem_loc_3)));
END syncram;