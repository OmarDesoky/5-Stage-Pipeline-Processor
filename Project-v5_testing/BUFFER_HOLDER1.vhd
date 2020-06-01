library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buffer_holder1 is
    port (
      clk:                   in std_logic;
      rst_async:             in std_logic;
      if_INT:                in std_logic;
  
      ENB_Buffer:         out std_logic
    ) ;
  end buffer_holder1;

architecture BFH1 of buffer_holder1 is
  
    signal counter : integer range 0 to 3;
begin
  
    process( clk,rst_async )
    begin
            if rst_async = '1' then

                ENB_Buffer <= '1';
                counter <= 0;

            elsif (rising_edge(clk)) then
                if(if_INT = '1' and counter = 0) then 
                    ENB_Buffer <= '0';
                    counter <= counter +1;

                elsif (counter = 1) then
                    ENB_Buffer <= '1';
                    counter <= 0;

                --elsif counter < 1 and counter > 0 then
                    --ENB_Buffer <= '0';
                    --counter <= counter +1;

                else --if counter = 0 and if_int never came 
                    ENB_Buffer <= '1';
                    counter <= 0;

                end if;
            end if;
    end process ;
end BFH1 ; -- BFH1