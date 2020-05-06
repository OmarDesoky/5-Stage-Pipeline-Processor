library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ex_mem is 

port (
    clk: in std_logic;
    rst_async: in std_logic;
    enable: in std_logic;
    wb_in: in std_logic_vector(3 downto 0);
    mem_in: in std_logic_vector(3 downto 0);
    alu_out_1_in: in std_logic_vector(31 downto 0);
    alu_out_2_in: in std_logic_vector(31 downto 0);
    ea_imm_in: in std_logic_vector(31 downto 0);
    src_1_in: in std_logic_vector(2 downto 0);
    pc_in: in std_logic_vector(31 downto 0);
    dst_in: in std_logic_vector(2 downto 0);


    wb_out: out std_logic_vector(3 downto 0);
    mem_out: out std_logic_vector(3 downto 0);
    alu_out_1_out: out std_logic_vector(31 downto 0);
    alu_out_2_out: out std_logic_vector(31 downto 0);
    ea_imm_out: out std_logic_vector(31 downto 0);
    src_1_out: out std_logic_vector(2 downto 0);
    pc_out: out std_logic_vector(31 downto 0);
    dst_out: out std_logic_vector(2 downto 0)
);
end ex_mem ;


architecture ex_mem_buffer of ex_mem is

begin

process(clk,rst_async,enable)
begin
    if rst_async = '1' then
        wb_out <= (others => '0');
        mem_out <= (others => '0');
        alu_out_1_out <= (others => '0');
        alu_out_2_out <= (others => '0');
        ea_imm_out <= (others => '0');
        src_1_out <= (others => '0');
        pc_out <= (others => '0');
        dst_out <= (others => '0');
    
    else
        if ( rising_edge(clk) and enable ='1' ) then
            wb_out <= wb_in;
            mem_out <= mem_in;
            alu_out_1_out <= alu_out_1_in;
            alu_out_2_out <= alu_out_2_in;
            ea_imm_out <= ea_imm_in;
            src_1_out <= src_1_in;
            pc_out <= pc_in;
            dst_out <= dst_in;
        end if;
    end if;

end process;    

end ex_mem_buffer;