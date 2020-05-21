library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_STD.ALL;

entity MINI_DECODER is
 Port ( 
 instruction : 				in STD_LOGIC_VECTOR (15 downto 0);
 clk : 						in STD_LOGIC;
 reset : 					in STD_LOGIC;
 not_another_inst : 		out STD_LOGIC;
 fsm_take_decision : 		out STD_LOGIC;
 reg_src : 					out STD_LOGIC_VECTOR (2 downto 0);
 ret_rti_call_ready:		out STD_LOGIC;
 hazard_prediction_enb : 	out STD_LOGIC);
end MINI_DECODER;

architecture mini_decoder of MINI_DECODER is

signal counter 	: integer range 0 to 1;
signal counter2 : integer range 0 to 4;
--signal old_instruction : STD_LOGIC_VECTOR (15 downto 0);
signal opcode  : std_logic_vector(4 downto 0);
constant IADD : std_logic_vector(4 downto 0) := "00010";
constant SHL : std_logic_vector(4 downto 0) := "00000";
constant SHR : std_logic_vector(4 downto 0) := "00001";
constant LDM : std_logic_vector(4 downto 0) := "10010";
constant LDD : std_logic_vector(4 downto 0) := "10011";
constant STD : std_logic_vector(4 downto 0) := "10100";
constant JZ : std_logic_vector(4 downto 0) := "11000";
constant JMP : std_logic_vector(4 downto 0) := "11001";
constant CALL : std_logic_vector(4 downto 0) := "11010";
constant RET : std_logic_vector(4 downto 0) := "11110";
constant RTI : std_logic_vector(4 downto 0) := "11111";

begin
	process (clk, reset,instruction)
	variable old_instruction:std_logic_vector(15 downto 0);
	variable old_opcode  	: std_logic_vector(4 downto 0);
	begin
		opcode <= instruction(15 downto 11);
		if (reset = '1') then
			not_another_inst <= '0';
			fsm_take_decision <= '0';
			counter<=0;
			hazard_prediction_enb <= '0';
			ret_rti_call_ready<='0';
			reg_src <= "000";
		elsif (counter > 0) then 
			hazard_prediction_enb <= '0';
			counter<=0;
			not_another_inst <= '0';
			fsm_take_decision <= '1'; --don't care
			ret_rti_call_ready<='0';
		elsif(opcode =JZ or opcode = JMP) then
			reg_src <= instruction(7 downto 5);
			-- JZ
			if (opcode = JZ) then
				not_another_inst <= '1';
				fsm_take_decision <= '0';
				hazard_prediction_enb <= '1';
				ret_rti_call_ready<='0';
				
			-- JMP
			elsif (opcode = JMP) then
				not_another_inst <= '1';
				fsm_take_decision <= '1';
				hazard_prediction_enb <= '1';
				ret_rti_call_ready<='0';
			end if;
		--check old
		elsif(old_opcode =JZ or old_opcode = JMP) then
			reg_src <= old_instruction(7 downto 5);
		-- Other Operation
		else
			not_another_inst <= '0';
			fsm_take_decision <= '1'; --don't care
			hazard_prediction_enb <= '0';
			ret_rti_call_ready<='0';

			if (opcode=IADD or opcode=SHL or opcode=SHR or opcode=LDM or opcode=LDD or opcode=STD) then
				--skip next instruction
				counter<=1;
			elsif (opcode=CALL or opcode=RET or opcode=RTI) then
				counter2<=1;
			end if;
		end if;
		old_instruction := instruction;
		old_opcode := opcode;
	end process;
end mini_decoder;