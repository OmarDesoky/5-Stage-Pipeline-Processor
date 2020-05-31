library ieee;
use ieee.std_logic_1164.all;

entity fsm_2_bits is

port (
    clk : in std_logic;
    rst_async: in std_logic;
    enb : in std_logic; -- enable to write the right data in the FSM when you know the right answer from the decode stage
                        --  1=> write // 0=> read
    input : in std_logic; -- right answer  1=> correct // 0=> not correct
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
begin

process (enb,input,current_state)
    begin

        if (enb = '0') then
            output_state <= current_state;
            if ((current_state = STRONG_NOT_TAKEN) or (current_state = WEAK_NOT_TAKEN)) then
                output<='0';
            else
                output<='1';
            end if;
            -- if input = 1 => prediction is true
            -- else prediction is false
        else
            if (current_state = STRONG_NOT_TAKEN) then
                if (input = '1') then
                    output_state <= STRONG_NOT_TAKEN;
                    output<='0';
                else
                    output_state <= WEAK_NOT_TAKEN;
                    output<='0';
                end if;
            elsif (current_state = WEAK_NOT_TAKEN) then
                if input = '1' then 
                    output_state <= STRONG_NOT_TAKEN; 
                    output<='0';
                else 
                    output_state <= WEAK_TAKEN; 
                    output<='1';
                end if;  
            elsif (current_state = WEAK_TAKEN) then
                if input = '1' then 
                    output_state <= STRONG_TAKEN; 
                    output<='1';
                else 
                    output_state <= WEAK_NOT_TAKEN; 
                    output<='0';
                end if;
            elsif (current_state = STRONG_TAKEN) then
                if input = '1' then 
                    output_state <= STRONG_TAKEN; 
                    output<='1';
                else 
                    output_state <= WEAK_TAKEN; 
                    output<='1';
                end if;                                   
            end if;                 
                
        end if;
end process;

end fsm_2_bit;