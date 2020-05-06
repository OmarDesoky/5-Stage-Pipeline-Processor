library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench is
    --empty
end entity testbench;

architecture BENCH of testbench is
  signal clock, reset, flip, int, int_1st, int_2nd ,int_before, PC_enb : STD_LOGIC;
  signal Stop : BOOLEAN;
begin
  Clock_gen: process
  begin
    while not Stop loop
      Clock <= '0';
      wait for 5 NS;
      Clock <= '1';
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
      int<='1';
      report "int is up case";

      wait for 10 NS;
      ------------------------------------------------------
      int<='0';
      flip<='0'; -- no flip yet
      report "no flip case";

      wait for 10 NS;
      -------------------------------------------------------
      flip<='1'; 
      report "flip raised case";

      wait for 10 NS;
      -------------------------------------------------------
      report "counter =2 case";

      wait for 10 NS;
      -------------------------------------------------------
      report "counter =3 case";

      wait for 10 NS;
      -------------------------------------------------------
      report "counter =4 case";

      wait for 10 NS;
      -------------------------------------------------------
      report "all done case";

      wait for 10 NS;
      -------------------------------------------------------
	Stop <= TRUE;
	report "Simulation finished";
    wait;
  end process Stim;

  DUT : entity work.handler
    port map(clock, reset, flip, int, int_1st, int_2nd ,int_before, PC_enb);

end architecture BENCH;
