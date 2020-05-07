library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench is
    --empty
end entity testbench;

architecture BENCH of testbench is
  signal clock, reset : STD_LOGIC;
  signal if_int : std_logic_vector(2 downto 0);
  signal ALU_out,SP,PC,add,data : std_logic_vector(31 downto 0);
  signal Stop : BOOLEAN;
begin
  Clock_gen: process
  begin
    while not Stop loop
      Clock <= '1';
      wait for 5 NS;
      Clock <= '0';
      wait for 5 NS;
	end loop;
    wait;
  end process Clock_gen;
  
  Stim: process
  begin
	  reset<='1';
      report "reset case";
 
      wait for 10 NS;
      -----------------------------------------------------
      reset<='0';
      SP <=x"00000050"; --80
      if_int<="111"; --normal operation
	  PC<=x"00000003"; --3
      ALU_out<=x"00000063"; --99
	  report "not RTI case";

      wait for 10 NS;
      ------------------------------------------------------
      SP <=x"0000004F"; --79
      if_int<="100"; --INT
      report "clock 2 case";

      wait for 10 NS;
      -------------------------------------------------------
      SP <=x"0000004E"; --78
      if_int<="100"; --INT
      report "clock 3 case";

      wait for 10 NS;
      -------------------------------------------------------
      SP <=x"0000004D"; --77
      if_int<="010"; --call
      report "clock 4 case";

      wait for 10 NS;
      -------------------------------------------------------
      report "clock 5 case";
	  SP <=x"0000004D"; --77
      if_int<="000"; --normal operation
      wait for 10 NS;
      -------------------------------------------------------
      report "clock 6 case";
	  SP <=x"0000004D"; --77
      if_int<="011"; --RET
      wait for 10 NS;
      -------------------------------------------------------
      report "clock 7 case";
	  SP <=x"0000004E"; --78
      if_int<="101"; --RTI
      wait for 10 NS;
      -------------------------------------------------------
      report "clock 8 case";
	  SP <=x"0000004F"; --79
      if_int<="011"; --RTI
      wait for 10 NS;
      -------------------------------------------------------
      report "clock 9 case";
	  SP <=x"00000050"; --80
      if_int<="000"; --normal operation

      wait for 10 NS;
      -------------------------------------------------------
	Stop <= TRUE;
	report "Simulation finished";
    wait;
  end process Stim;

  DUT : entity work.controller
    port map(clock,reset,
    ALU_out,SP,PC,if_int,add,data);

end architecture BENCH;
