library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity if_id is 

port (
    clk : in std_logic;
    rst_async : in std_logic;
    last_taken_in : in std_logic;
    next_stall_in : in std_logic;
    pc_in: in std_logic_vector(31 downto 0);

    last_taken_out : out std_logic;
    next_stall_out : out std_logic;
    pc_out: out std_logic_vector(31 downto 0)
);
end if_id ;


architecture if_id_buffer of if_id is

begin

process(clk,rst_async)
begin
    if rst_async = '1' then
        last_taken_out <= '0';
        next_stall_out <= '0';
        pc_out <= (others => '0');
    
    else
        if rising_edge(clk) then
            last_taken_out <= last_taken_in;
            next_stall_out <= next_stall_in;
            pc_out <= pc_in;
        end if;
    end if;

end process;    

end if_id_buffer;