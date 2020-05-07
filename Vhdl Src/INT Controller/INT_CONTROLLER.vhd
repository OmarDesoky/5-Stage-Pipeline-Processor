library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port (
      clk:                                  in std_logic;
      rst_async:                            in std_logic;
      ALU_out:                              in std_logic_vector(31 downto 0);
      EA_IMM_SP :                           in std_logic_vector(31 downto 0);
      PC :                                  in std_logic_vector(31 downto 0);
      INT_RTI_call_RET_Dontuse :            in std_logic_vector(2 downto 0);
  
      ADDRESS_IN:                           out std_logic_vector(31 downto 0);
      DATA_IN:                              out std_logic_vector(31 downto 0)
    ) ;
  end controller;

  architecture INT_Controller of controller is
    signal counter : integer range 0 to 1;
begin
  
    process( clk,rst_async )
    begin
            if rst_async = '1' then

                ADDRESS_IN <= (others => '0');
                DATA_IN <= (others => '0');
                counter <= 0;

            elsif (rising_edge(clk)) then
                if(INT_RTI_call_RET_Dontuse = "100" ) then --INT
                    if counter = 0 then
                        ADDRESS_IN <= EA_IMM_SP;
                        DATA_IN <= PC;
                        counter <= counter +1;
                    else  --counter =1
                        ADDRESS_IN <= EA_IMM_SP;
                        DATA_IN <= ALU_out;
                        counter <= 0;
                    end if ;
                elsif (INT_RTI_call_RET_Dontuse = "101" ) then --RTI
                    if counter = 0 then
                        ADDRESS_IN <= EA_IMM_SP;
                        DATA_IN <= PC; --useless
                        counter <= counter +1;
                    else  --counter =1
                        ADDRESS_IN <= EA_IMM_SP;
                        DATA_IN <= ALU_out;--useless
                        counter <= 0;
                    end if ;
                elsif (INT_RTI_call_RET_Dontuse = "010" ) then --CALL
                        ADDRESS_IN <= EA_IMM_SP;
                        DATA_IN <= PC;
                elsif (INT_RTI_call_RET_Dontuse = "011" ) then --RET
                        ADDRESS_IN <= EA_IMM_SP;
                        DATA_IN <= PC;--useless
                else -- any other instruction 
                        ADDRESS_IN <= EA_IMM_SP;
                        DATA_IN <= ALU_out;
                end if;
            end if;
    end process ;
end INT_Controller ; -- INT_Controller