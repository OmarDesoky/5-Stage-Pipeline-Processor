library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buffer_holder2 is
    port (
      clk:                                      in std_logic;
      rst_async:                                in std_logic;
      INT_RTI_call_RET_Dontuse:                 in std_logic_vector(2 downto 0);
      WB_signals_in:                            in std_logic_vector(4 downto 0);
  
      WB_signals_out:                           out std_logic_vector(4 downto 0)
    ) ;
  end buffer_holder2;

architecture BFH2 of buffer_holder2 is
    --signals order:
    --write_enable: out std_logic;
    --pc_wb: out std_logic;
    --mem_or_reg: out std_logic;
    --swap : out std_logic;
    --flag_register_wb : out std_logic;
    signal counter : integer range 0 to 1;
begin
  
    process( clk,rst_async,WB_signals_in )
    begin
            if rst_async = '1' then

                WB_signals_out <= "00000";
                counter <= 0;

            elsif (falling_edge(clk)) then
                if(INT_RTI_call_RET_Dontuse = "101" ) then --RTI
                    if counter = 0 then
                        WB_signals_out <=  WB_signals_in;
                        counter <= counter +1;
                    else  --counter =1
                        WB_signals_out(1)<= '0'; --pc wb disabled
                        WB_signals_out(4)<= '1'; --Flag register write back enabled
                        --unchanged
                        WB_signals_out(0)<= '0'; --wb disabled
                        WB_signals_out(2)<= '1'; --take from mem
                        WB_signals_out(3)<= '0'; --not swap
                        counter <= 0;
                        --00101
                    end if ;

                else --not RTI 
                    WB_signals_out <= WB_signals_in;
                    counter <= 0;

                end if;
            end if;
    end process ;
end BFH2 ; -- BFH2