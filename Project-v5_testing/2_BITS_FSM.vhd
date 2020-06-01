library ieee;
use ieee.std_logic_1164.all;

entity fsm_2_bits is

port (
    rst_async: in std_logic;
    enb : in std_logic;
    input : in std_logic;
    current_state: in std_logic_vector(1 downto 0) ;
    output : out std_logic;
    output_state : out  std_logic_vector(1 downto 0) 
);  

end fsm_2_bits;

--  states:
-- 0 STRONG_NOT_TAKEN
-- 1 WEAK_NOT_TAKEN
-- 2 WEAK_TAKEN
-- 3 STRONG_TAKEN
architecture fsm_2_bit of fsm_2_bits is
    constant STRONG_NOT_TAKEN : std_logic_vector(1 downto 0)  := "00";
    constant WEAK_NOT_TAKEN : std_logic_vector(1 downto 0)  := "01";
    constant WEAK_TAKEN : std_logic_vector(1 downto 0)  := "10";
    constant STRONG_TAKEN : std_logic_vector(1 downto 0)  := "11";

    signal states : std_logic_vector(1 downto 0)  := "10";
begin

process (rst_async,enb,input,current_state)
    begin
        if rst_async = '1' then 
            states <= WEAK_TAKEN;
        elsif (enb = '0') then
            states <= current_state;
        elsif (enb ='1') then
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
                    states <= WEAK_NOT_TAKEN; 
                else 
                    states <= STRONG_TAKEN; 
                end if;
            elsif (current_state = STRONG_TAKEN) then
                if input = '1' then 
                    states <= WEAK_TAKEN; 
                else 
                    states <= STRONG_TAKEN; 
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