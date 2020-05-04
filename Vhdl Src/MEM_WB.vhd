library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mem_wb is 

port (
    clk: in std_logic;
    rst_async: in std_logic;
    wb_in: in std_logic_vector(3 downto 0);
    mem_out_in: in std_logic_vector(31 downto 0);
    alu_out_1_in: in std_logic_vector(31 downto 0);
    alu_out_2_in: in std_logic_vector(31 downto 0);
    src_1_in: in std_logic_vector(2 downto 0);
    dst_in: in std_logic_vector(2 downto 0);
    

    wb_out: out std_logic_vector(3 downto 0);
    mem_out_out: out std_logic_vector(31 downto 0);
    alu_out_1_out: out std_logic_vector(31 downto 0);
    alu_out_2_out: out std_logic_vector(31 downto 0);
    src_1_out: out std_logic_vector(2 downto 0);
    dst_out: out std_logic_vector(2 downto 0)
);
end mem_wb ;


architecture mem_wb_buffer of mem_wb is

begin

process(clk,rst_async)
begin
    if rst_async = '1' then
        wb_out <= (others => '0');
        mem_out_out <= (others => '0');
        alu_out_1_out <= (others => '0');
        alu_out_2_out <= (others => '0');
        src_1_out <= (others => '0');
        dst_out <= (others => '0');
    
    else
        if rising_edge(clk) then
            wb_out <= wb_in;
            mem_out_out <= mem_out_in;
            alu_out_1_out <= alu_out_1_in;
            alu_out_2_out <= alu_out_2_in;
            src_1_out <= src_1_in;
            dst_out <= dst_in;
        end if;
    end if;

end process;    

end mem_wb_buffer;