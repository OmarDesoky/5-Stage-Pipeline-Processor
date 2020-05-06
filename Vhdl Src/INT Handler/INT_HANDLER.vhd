library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity handler is
  port (
    clk:                   in std_logic;
    rst_async:             in std_logic;
    flip_next_cycle_INT:   in std_logic;
    INT_sig :              in std_logic;

    INT_1st_cycle:         out std_logic;
    INT_2nd_cycle:         out std_logic;
    INT_raised_before:     out std_logic; 
    PC_enb_from_INT:       out std_logic
  ) ;
end handler;

architecture INT_handler of handler is
    signal counter : integer range 0 to 4;
begin
process( clk,rst_async )
begin
        if rst_async = '1' then

            INT_1st_cycle <= '0';
            INT_2nd_cycle <= '0';
            INT_raised_before <= '0';
            PC_enb_from_INT <= '1';
            counter <= 0;

        elsif (rising_edge(clk)) then
            if(INT_sig = '1' and counter = 0) then 
                -- nested interrupts are not handled
                INT_1st_cycle <= '1';
                INT_2nd_cycle <= '0';
                INT_raised_before <= '1';
                PC_enb_from_INT <= '0';
                counter <= counter +1;

            elsif (flip_next_cycle_INT = '0' and counter = 1) then
                INT_1st_cycle <= '1';
                INT_2nd_cycle <= '0';
                INT_raised_before <= '1';
                PC_enb_from_INT <= '0';
                counter <= 1;
            elsif (flip_next_cycle_INT = '1' and counter = 1) then
                INT_1st_cycle <= '0';
                INT_2nd_cycle <= '1';
                PC_enb_from_INT <= '1';
                counter <= counter +1;

            elsif counter < 4 and counter > 1 then
                INT_2nd_cycle <= '0';
                counter <= counter +1;

            else --if counter = 4 or int never came 
                INT_raised_before <= '0';
                PC_enb_from_INT <= '1';
                counter <= 0;

            end if;
        end if;
end process ; 

end INT_handler ; -- INT_handler