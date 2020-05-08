library ieee;
use ieee.std_logic_1164.all;

entity fsm_2_bits is

port (
    clk : in std_logic;
    rst_async: in std_logic;
    enb : in std_logic;
    input : in std_logic;
    current_state: in integer;
    output : out std_logic;
    output_state : out  integer
);  

end fsm_2_bits;

--  states:
-- 0 STRONG_NOT_TAKEN
-- 1 WEAK_NOT_TAKEN
-- 2 WEAK_TAKEN
-- 3 STRONG_TAKEN
architecture fsm_2_bit of fsm_2_bits is
    constant STRONG_NOT_TAKEN : integer := 0;
    constant WEAK_NOT_TAKEN : integer := 1;
    constant WEAK_TAKEN : integer := 2;
    constant STRONG_TAKEN : integer := 3;

    signal states : integer := 2;
begin

process (clk,rst_async,enb)
    begin
        if rst_async = '1' then 
            states <= WEAK_TAKEN;
        elsif (enb = '0') then
            states <= current_state;
        elsif rising_edge(clk) and (enb ='1') then
            if (current_state = STRONG_NOT_TAKEN) then
                if (input = '1') then
                    states <= WEAK_NOT_TAKEN;
                else
                    states <= STRONG_NOT_TAKEN;
                end if;
            elsif (current_state = WEAK_NOT_TAKEN) then
                if input = '1' then 
                    states <= WEAK_TAKEN; 
                else 
                    states <= STRONG_NOT_TAKEN; 
                end if;  
            elsif (current_state = WEAK_TAKEN) then
                if input = '1' then 
                    states <= STRONG_TAKEN; 
                else 
                    states <= WEAK_NOT_TAKEN; 
                end if;
            elsif (current_state = STRONG_TAKEN) then
                if input = '1' then 
                    states <= STRONG_TAKEN; 
                else 
                    states <= WEAK_TAKEN; 
                end if;                                   
            end if;                 
                
        end if;
end process;


    process (states)
        begin
            if ( states = STRONG_TAKEN ) or ( states = WEAK_TAKEN ) then
                output<='1';
            elsif ( states = STRONG_NOT_TAKEN ) or ( states = WEAK_NOT_TAKEN ) then
                output<='0';
            end if;
    end process;

    output_state <= states;
end fsm_2_bit;