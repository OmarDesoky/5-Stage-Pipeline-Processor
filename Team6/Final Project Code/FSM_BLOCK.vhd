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


type mem_fsm is array (0 to 6710886) of std_logic_vector(1 downto 0) ;
signal memory : mem_fsm := (others=>"10");
signal output : std_logic;
signal state_out :  std_logic_vector(1 downto 0) ;
signal state_in :  std_logic_vector(1 downto 0);
signal prediction_correct_inverted :std_logic; 

signal addr : std_logic_vector(size-1 downto 0);
-- signal addr_fetched_sig : std_logic_vector(size-1 downto 0);
-- signal addr_executed_sig : std_logic_vector(size-1 downto 0);

constant STRONG_NOT_TAKEN : std_logic_vector(1 downto 0)  := "00";
constant WEAK_NOT_TAKEN : std_logic_vector(1 downto 0)  := "01";
constant WEAK_TAKEN : std_logic_vector(1 downto 0)  := "10";
constant STRONG_TAKEN : std_logic_vector(1 downto 0)  := "11";

begin

    -- address_fetched_BUF : entity work.n_bit_register
    -- port map(clk,rst_async,'1',addr_fetched,addr_fetched_sig);

    -- address_executed_BUF : entity work.n_bit_register
    -- port map(clk,rst_async,'1',addr_executed,addr_executed_sig);

    prediction_correct_inverted <= not (prediction_correct);

    addr <= addr_executed when (ifjz_updt_fsm ='1') else addr_fetched;

    process (clk,addr,prediction_correct_inverted,state_in)
    begin
        state_in <= memory(to_integer(unsigned(addr)));
        if (state_in = STRONG_NOT_TAKEN) then
            if (prediction_correct_inverted = '1') then
                state_out <= STRONG_NOT_TAKEN;
                output<='0';
            else
                state_out <= WEAK_NOT_TAKEN;
                output<='0';
            end if;
        elsif (state_in = WEAK_NOT_TAKEN) then
            if prediction_correct_inverted = '1' then 
                state_out <= STRONG_NOT_TAKEN; 
                output<='0';
            else 
                state_out <= WEAK_TAKEN; 
                output<='1';
            end if;  
        elsif (state_in = WEAK_TAKEN) then
            if prediction_correct_inverted = '1' then 
                state_out <= STRONG_TAKEN; 
                output<='1';
            else 
                state_out <= WEAK_NOT_TAKEN; 
                output<='0';
            end if;
        elsif (state_in = STRONG_TAKEN) then
            if prediction_correct_inverted = '1' then 
                state_out <= STRONG_TAKEN; 
                output<='1';
            else 
                state_out <= WEAK_TAKEN; 
                output<='1';
            end if;                                   
        end if;
    end process;

    process (clk,state_out,ifjz_updt_fsm)
    begin
        if (ifjz_updt_fsm='1')  then
            memory(to_integer(unsigned(addr))) <= state_out;
        end if;
    end process;
    
    taken_not_taken<= '1'  when (decision_alwaystaken='1' and ifjz_updt_fsm ='0') else output;
    

end fsmblock;