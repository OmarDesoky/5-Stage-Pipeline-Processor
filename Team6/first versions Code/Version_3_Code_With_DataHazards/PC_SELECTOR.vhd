library IEEE;
use ieee.std_logic_1164.all;

entity pc_selector is 

generic (size : integer := 32);

port (
    rst_async: in std_logic;
    int : in std_logic;
    pc_wb: in std_logic;
    take_jmp_addr: in std_logic;
    mem_loc_0_1 : in std_logic_vector(size-1 downto 0);
    mem_loc_2_3 : in std_logic_vector(size-1 downto 0);
    pc_frm_wb : in std_logic_vector(size-1 downto 0);
    calc_jmp_addr: in std_logic_vector(size-1 downto 0);
    pc_updated : in std_logic_vector(size-1 downto 0);
    pc_out : out std_logic_vector(size-1 downto 0)
);
end pc_selector ;


architecture pc_select of pc_selector is

begin

process(rst_async,int, pc_wb,take_jmp_addr, pc_updated, calc_jmp_addr, pc_frm_wb)
begin
    if rst_async ='1' then
        pc_out <= mem_loc_0_1;
    elsif int ='1' then
        pc_out <=  mem_loc_2_3;
    elsif pc_wb ='1' then
        pc_out <=  pc_frm_wb;
    elsif take_jmp_addr ='1' then
        pc_out <= calc_jmp_addr;
    else
        pc_out <= pc_updated;
    end if;

end process;    

end pc_select;