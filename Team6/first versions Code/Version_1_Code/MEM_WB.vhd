library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mem_wb is 

port (
    clk: in std_logic;
    rst_async: in std_logic;
    enable: in std_logic;
    wb_in: in std_logic_vector(4 downto 0);  --edited 10/5
    mem_out_in: in std_logic_vector(31 downto 0);
    alu_out_1_in: in std_logic_vector(31 downto 0);
    alu_out_2_in: in std_logic_vector(31 downto 0);
    src_1_in: in std_logic_vector(2 downto 0);
    dst_in: in std_logic_vector(2 downto 0);
    
    -- for printing flags 
    carry_in: in std_logic;
    zero_in: in std_logic;
    neg_in: in std_logic;
    ----------------------

    wb_out: out std_logic_vector(4 downto 0);  --edited 10/5
    mem_out_out: out std_logic_vector(31 downto 0);
    alu_out_1_out: out std_logic_vector(31 downto 0);
    alu_out_2_out: out std_logic_vector(31 downto 0);
    src_1_out: out std_logic_vector(2 downto 0);
    dst_out: out std_logic_vector(2 downto 0);


    -- for printing flags 
    carry_out: out std_logic;
    zero_out: out std_logic;
    neg_out: out std_logic
    --------------------
);
end mem_wb ;


architecture mem_wb_buffer of mem_wb is

begin

process(clk,rst_async,enable)
begin
    if rst_async = '1' then
        wb_out <= (others => '0');
        mem_out_out <= (others => '0');
        alu_out_1_out <= (others => '0');
        alu_out_2_out <= (others => '0');
        src_1_out <= (others => '0');
        dst_out <= (others => '0');

        -- for printing flags 
        carry_out <= '0';
        zero_out <= '0';
        neg_out <= '0';
        ----------------
    
    else
        if ( rising_edge(clk) and enable ='1' ) then
            wb_out <= wb_in;
            mem_out_out <= mem_out_in;
            alu_out_1_out <= alu_out_1_in;
            alu_out_2_out <= alu_out_2_in;
            src_1_out <= src_1_in;
            dst_out <= dst_in;

            -- for printing flags 
            carry_out <= carry_in;
            zero_out <= zero_in;
            neg_out <= neg_in;
            ----------------
        end if;
    end if;

end process;    

end mem_wb_buffer;