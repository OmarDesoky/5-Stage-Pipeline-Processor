library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_STD.ALL;
entity decode_stage IS  
port (
    clk:in std_logic;
    rst_async : in std_logic;
    swap_wb : in std_logic;
    write_enb_wb: in std_logic;
    flag_enb_wb : in std_logic;
    int : in std_logic;
    stall_next : in std_logic;
    last_taken : in std_logic;
    instruction : in std_logic_vector(31 downto 0);
    dest_mem_wb : in std_logic_vector(2 downto 0);
    data_out_wb: in std_logic_vector(31 downto 0);
    data_swp_wb : in std_logic_vector(31 downto 0);
    reg_swap_mem_wb : in std_logic_vector(2 downto 0);
    pc_in : in std_logic_vector(31 downto 0);                       -----------------------------
    zero_flg : in std_logic;
    carry_flg: in std_logic;
    neg_flg : in std_logic;
    insert_bubble: in std_logic;                                    -------------------------------
    io_data: in std_logic_vector(31 downto 0);


    dst_out, src1_out, src2_out : out std_logic_vector(2 downto 0);     ------------------------
    pc_out,em_imm_out,data1_out,data2_out  : out std_logic_vector(31 downto 0);
    execute : out std_logic_vector(1 downto 0);                 ----------------------------------
    wb_out : out std_logic_vector(4 downto 0);                  ----------------------------------
    mem_out : out std_logic_vector(6 downto 0);                 ----------------------------------
    alu_op : out std_logic_vector(3 downto 0);                  ----------------------------------
    imm_reg_enb_out : out std_logic;                            ----------------------------------
    reg_enb_out : out std_logic;                                ----------------------------------
    stall_for_int : out std_logic;                              ----------------------------------
    stall_for_jmp_pred: out std_logic;                          ----------------------------------
    ifjmp_upd_fsm : out std_logic;                              ----------------------------------
    zero_flag_compara : out std_logic;                          ----------------------------------
    last_taken_compara : out std_logic;                         ----------------------------------
    inmiddleofimm: out std_logic;                            ----------------------------------
    ifanyjmp: out std_logic                                     ----------------------------------

    );
end decode_stage;

architecture flow of decode_stage IS


signal flags_out : out std_logic_vector(31 downto 0);
signal read_data_1: out std_logic_vector(31 downto 0);

--wb signals
signal _write_enable: out std_logic;
signal _pc_wb: out std_logic;
signal _mem_or_reg: out std_logic;
signal _swap : out std_logic;
signal _flag_register_wb : out std_logic;
-- mem signals
signal _mem_write: out std_logic;
signal _mem_read: out std_logic;
signal _int_rti_dntuse: out std_logic_vector(2 downto 0);
signal _sp_enb: out std_logic_vector(1 downto 0);
-- alu op
signal _alu_op: out std_logic_vector(3 downto 0);
-- execute signals
signal _alu_source: out std_logic;
signal _io_enable: out std_logic;
-- used in decode and fetch signals
signal _imm_ea: out std_logic;


signal sign_extend1 : std_logic_vector(15 downto 0):=(others => '0');
signal sign_extend2 : std_logic_vector(11 downto 0):=(others => '0');
signal out_first4 : std_logic_vector(3 downto 0);

begin
pc_out <= pc_in;
dst_out <= instruction (10 downto 8);
src1_out <= instruction (7 downto 5);
src2_out <= instruction (4 downto 2);
last_taken_compara <=last_taken;
stall_for_jmp_pred <= last_taken and stall_next;
zero_flag_compara <= flags_out(1);

RegisterFile : entity work.registers
port map(clk,rst_async,write_enb_wb,swap_wb,flag_enb_wb,carry_flg,zero_flg,neg_flg,instruction (7 downto 5),
instruction (4 downto 2),dest_mem_wb,data_out_wb,reg_swap_mem_wb,data_swp_wb,flags_out,read_data_1,data2_out);

Control : entity work.control_unit
port map(clk,int,instruction(15 downto 11),_write_enable,_pc_wb,_mem_or_reg,_swap,_flag_register_wb
,_mem_write,_mem_read,_int_rti_dntuse,_sp_enb,_alu_op,_alu_source,_io_enable,_imm_ea,
ifjmp_upd_fsm,imm_reg_enb_out,reg_enb_out,inmiddleofimm,ifanyjmp,stall_for_int);

                                -------------- NEEDS MODIFICATIONS (REARRANGE BITS) --------------
wb_out <= _write_enable&_pc_wb&_mem_or_reg&_swap&_flag_register_wb  when insert_bubble='0' else (others => '0');    
mem_out <= _mem_write&_mem_read&_int_rti_dntuse&_sp_enb when insert_bubble='0' else (others => '0');
execute <= _alu_source&_io_enable when insert_bubble='0' else (others => '0');
                                -------------------------------------------------------------------
alu_op <= _alu_op  when insert_bubble='0' else (others => '0');


--  when _imm_ea is 1 we select effecive address 
--  when _imm_ea is 0 we select immediate address 
first4 : entity work.n_bit_register generic map(4)
port map(clk, rst_async,/*inmiddleofimm*/,instruction(3 downto 0),out_first4);

em_imm_out <= (sign_extend1 & instruction)  when _imm_ea ='0' else (sign_extend2 & out_first4 & instruction);




-- SELECTORRRRRRRRRRRRRRRRRRRRRRRRRR => we have to change op codes to select between (ordinary, flag , IN/OUT)
data1_decision :  entity work.mux_4to1 generic map(32)
port map(read_data_1,flags_out,io_data,X"00000000",SELECTORRRRRRRRRRRRRRRRRRRRRRRRRR,data1_out);

end flow; 