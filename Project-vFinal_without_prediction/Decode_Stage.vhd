library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_STD.ALL;
entity decode_stage IS  
port (
    clk:in std_logic;
    rst_async : in std_logic;
    prediction_result : in std_logic;
    swap_wb : in std_logic;
    write_enb_wb: in std_logic;
    flag_enb_wb : in std_logic;
    int : in std_logic;
    stall_next : in std_logic;
    last_taken : in std_logic;
    instruction : in std_logic_vector(15 downto 0);
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
    pc_incremented: in std_logic_vector(31 downto 0);


    wb_outt: out std_logic_vector(4 downto 0); --edited 10/5
    mem_outt: out std_logic_vector(6 downto 0); --edited 10/5
    alu_op_outt: out std_logic_vector(3 downto 0);
    ex_outt: out std_logic_vector(1 downto 0);
    data_1_outt: out std_logic_vector(31 downto 0);
    data_2_outt: out std_logic_vector(31 downto 0);
    src_1_outt: out std_logic_vector(2 downto 0);
    src_2_outt: out std_logic_vector(2 downto 0);
    ea_imm_outt: out std_logic_vector(31 downto 0);
    pc_outt: out std_logic_vector(31 downto 0);
    dst_outt: out std_logic_vector(2 downto 0);
    prediction_result_outt : out std_logic;
    pc_incremented_outt: out std_logic_vector(31 downto 0);
    last_taken_outt : out std_logic;

    stall_for_int : out std_logic;                              ----------------------------------
    stall_for_jmp_pred: out std_logic;                          ----------------------------------
    ifjmp_upd_fsm : out std_logic;                              ----------------------------------
    zero_flag_compara : out std_logic;                          ----------------------------------
    last_taken_compara : out std_logic;                         ----------------------------------
    inmiddleofimm: out std_logic;                               ----------------------------------
    ifanyjmp: out std_logic;                                     ----------------------------------
    swap_before_buffer,wb_enb_before_buffer,mem_read_before_buffer: out std_logic; ----------------------------------

    R0,R1,R2,R3,R4,R5,R6,R7: out std_logic_vector(31 downto 0); ----------------------------------
    zero_flag_outt,if_jz_outt :out std_logic;
    Flush_out_from_controlUnit :out std_logic;
    stop_forward_to_ex :out std_logic
    );
end decode_stage;

architecture flow of decode_stage IS
signal dst_out, src1_out, src2_out : std_logic_vector(2 downto 0);     
signal pc_out,em_imm_out,data1_out,data2_out  : std_logic_vector(31 downto 0);

signal flags_out : std_logic_vector(31 downto 0);
signal read_data_1: std_logic_vector(31 downto 0);

--wb signals
signal write_enable_sig: std_logic;
signal pc_wb_sig: std_logic;
signal mem_or_reg_sig: std_logic;
signal swap_sig : std_logic;
signal flag_register_wb_sig : std_logic;
-- mem signals
signal mem_write_sig: std_logic;
signal mem_read_sig: std_logic;
signal int_rti_dntuse_sig: std_logic_vector(2 downto 0);
signal sp_enb_sig: std_logic_vector(1 downto 0);
-- alu op
signal alu_op_sig: std_logic_vector(3 downto 0);
-- execute signals
signal alu_source_sig: std_logic;
signal io_enable_sig: std_logic;
-- used in decode and fetch signals
signal imm_ea_sig: std_logic;
signal reg_enb_sig:std_logic;
signal negated_reg_enb_sig:std_logic;
signal imm_reg_enb_out : std_logic; 
signal execute : std_logic_vector(1 downto 0);                 ----------------------------------
signal wb_out : std_logic_vector(4 downto 0);                  ----------------------------------
signal mem_out : std_logic_vector(6 downto 0);                 ----------------------------------
signal alu_op : std_logic_vector(3 downto 0);

signal sign_extend1 : std_logic_vector(15 downto 0):=(others => '0');
signal sign_extend2 : std_logic_vector(11 downto 0):=(others => '0');
signal out_first4 : std_logic_vector(3 downto 0);

-- these signals are made to made decode happens in the 2nd cycle
signal sig_src_1_outt : std_logic_vector(2 downto 0);
signal sig_src_2_outt : std_logic_vector(2 downto 0);
signal src_1_chosen : std_logic_vector(2 downto 0);
signal src_2_chosen : std_logic_vector(2 downto 0);

signal if_jz : std_logic; 
signal if_jz_sig : std_logic; 
signal negated_clk :std_logic;
signal prediction_result_sig : std_logic;

signal stop_forward_sig :std_logic;
begin
negated_reg_enb_sig<=not(reg_enb_sig);
negated_clk<=not(clk);
pc_out <= pc_in;
dst_out <= instruction (10 downto 8);
src1_out <= instruction (7 downto 5);
src2_out <= instruction (4 downto 2);
last_taken_compara <=last_taken;
stall_for_jmp_pred <= last_taken and stall_next;
--zero_flag_compara <= flags_out(1);
zero_flag_compara <=zero_flg;
-- these signals are made to made decode happens in the 2nd cycle
src_1_outt <= sig_src_1_outt;
src_2_outt <= sig_src_2_outt;
src_1_chosen <= sig_src_1_outt  when ( reg_enb_sig ='1') else instruction (7 downto 5);
src_2_chosen <= sig_src_2_outt  when ( reg_enb_sig ='1') else instruction (4 downto 2);


RegisterFile : entity work.registers
port map(clk,rst_async,write_enb_wb,swap_wb,flag_enb_wb,carry_flg,zero_flg,neg_flg,src_1_chosen,
src_2_chosen,dest_mem_wb,data_out_wb,reg_swap_mem_wb,data_swp_wb
--outputs
,flags_out,read_data_1,data2_out,R0,R1,R2,R3,R4,R5,R6,R7);

Control : entity work.control_unit
port map(clk,int,instruction(15 downto 11),write_enable_sig,pc_wb_sig,mem_or_reg_sig,swap_sig,flag_register_wb_sig
,mem_write_sig,mem_read_sig,int_rti_dntuse_sig,sp_enb_sig,alu_op_sig,alu_source_sig,io_enable_sig,imm_ea_sig,
if_jz,imm_reg_enb_out,reg_enb_sig,inmiddleofimm,ifanyjmp,stall_for_int,Flush_out_from_controlUnit,stop_forward_sig);

                                -------------- NEEDS MODIFICATIONS (REARRANGE BITS) --------------
wb_out <=  flag_register_wb_sig&swap_sig&mem_or_reg_sig&pc_wb_sig&write_enable_sig  when insert_bubble='0' else (others => '0');    
mem_out <= sp_enb_sig&int_rti_dntuse_sig&mem_read_sig&mem_write_sig when insert_bubble='0' else (others => '0');
execute <= alu_source_sig&io_enable_sig when insert_bubble='0' else (others => '0');
                                -------------------------------------------------------------------
alu_op <= alu_op_sig  when insert_bubble='0' else (others => '0');
prediction_result_sig<= prediction_result when insert_bubble='0' else '0';
if_jz_sig <= if_jz when insert_bubble='0' else '0';
--  when _imm_ea is 1 we select effecive address 
--  when _imm_ea is 0 we select immediate address 
first4 : entity work.n_bit_register generic map(4)
port map(clk, rst_async,negated_reg_enb_sig,instruction(3 downto 0),out_first4);

em_imm_out <= (sign_extend1 & instruction)  when imm_ea_sig ='0' else (sign_extend2 & out_first4 & instruction);

-- SELECTORRRRRRRRRRRRRRRRRRRRRRRRRR => we have to change op codes to select between (ordinary, flag , IN/OUT)
data1_Selector :  entity work.Data1_Decision
port map(int,instruction(15 downto 11),read_data_1,flags_out,io_data,data1_out);

swap_before_buffer<=swap_sig;
wb_enb_before_buffer<=write_enable_sig;
mem_read_before_buffer<=mem_read_sig;

Buffer_ID_EX :  entity work.id_ex 
--edited 20/5/2020 
port map(clk,rst_async,reg_enb_sig,imm_reg_enb_out, wb_out, mem_out, alu_op, execute, data1_out, 
data2_out, src1_out,src2_out, em_imm_out, pc_out
,dst_out,prediction_result_sig,zero_flg,if_jz_sig,pc_incremented,last_taken,stop_forward_sig
--outputs
,wb_outt, mem_outt, alu_op_outt, ex_outt, data_1_outt, data_2_outt, sig_src_1_outt ,sig_src_2_outt,
 ea_imm_outt ,pc_outt,dst_outt,prediction_result_outt,zero_flag_outt,if_jz_outt,pc_incremented_outt,last_taken_outt,stop_forward_to_ex);

ifjmp_upd_fsm<=if_jz_sig;

end flow;