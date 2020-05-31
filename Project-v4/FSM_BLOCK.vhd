library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_block is 

generic (size : integer := 32);

port (
    clk : in std_logic;
    rst_async : in std_logic;
    ifjz_updt_fsm: in std_logic;
    prediction_correct: in std_logic;
    decision_alwaystaken: in std_logic;
    addr_fetched: in std_logic_vector(size-1 downto 0);
    addr_executed : in std_logic_vector(size-1 downto 0);
    taken_not_taken : out std_logic             -- Taken = 1                NotTaken = 0
);
end fsm_block ;


architecture fsmblock of fsm_block is

component fsm_2_bits is

port (
    clk : in std_logic;
    rst_async: in std_logic;
    enb : in std_logic;
    input : in std_logic;
    current_state: in  std_logic_vector(1 downto 0);
    output : out std_logic;
    output_state : out std_logic_vector(1 downto 0) 
);  

end component;

type mem_fsm is array (0 to 4095) of std_logic_vector(1 downto 0) ;
signal memory : mem_fsm;
signal output : std_logic;
signal state_out :  std_logic_vector(1 downto 0) ;
signal addr : std_logic_vector(size-1 downto 0);
signal state_in :  std_logic_vector(1 downto 0) ;
signal prediction_correct_inverted :std_logic; 
begin
    prediction_correct_inverted <= not (prediction_correct);
    f: fsm_2_bits port map(clk,rst_async,ifjz_updt_fsm,prediction_correct_inverted,state_in,output,state_out);
    process (decision_alwaystaken,ifjz_updt_fsm,state_out,addr_executed,addr_fetched)
    begin
        
        if ifjz_updt_fsm = '1' then
            state_in <=memory(to_integer(unsigned(addr_executed)));
            -- addr <= addr_executed;
            memory(to_integer(unsigned(addr_executed))) <= state_out;
        elsif decision_alwaystaken = '1' then
            taken_not_taken <= '1';
        else
            state_in <=memory(to_integer(unsigned(addr_fetched)));
            --addr <= addr_fetched;
            -- check if jz is already in mem or not
            -- memory[addr][0] => exist or not
            -- memory[addr][1] => state (integer [will be convert from std_logic_vector to integer] )
            -- 0 means empty, so we need initialize a state ("2"=> weak_taken) and save it in memory.
            if( memory(to_integer(unsigned(addr_fetched))) = "UU") then
                memory(to_integer(unsigned(addr_fetched))) <= "10";
            end if;
            taken_not_taken <= output;

        end if;
        
    end process;   

end fsmblock;