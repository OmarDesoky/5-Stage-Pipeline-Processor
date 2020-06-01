LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_STD.ALL;
ENTITY Prediction_Stage IS  
PORT (
    instruction_test : 				                                        in STD_LOGIC_VECTOR (15 downto 0);
    clk_test : 						                                        in STD_LOGIC;
    reset_test : 					                                        in STD_LOGIC;
    DST_ID_EX,DST_EX_MEM,INSTRCTION_10_8_DECODE_STAGE,INSTRUCTION_7_5_DECODE_STAGE
    ,INSTRUCTION_4_2_DECODE_STAGE,SRC1_ID_EX,SRC2_ID_EX
    ,SRC1_EX_MEM,DST_MEM_WB :                                               IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    WB_SIG_DECODE_STAGE,WB_SIG_ID_EX,SWAP_SIG_DECODE_STAGE,SWAP_SIG_ID_EX,
    SWAP_SIG_EX_MEM,WB_SIG_MEM_WB,
    MEM_READ_SIG_DECODE_STAGE,MEM_READ_ID_EX,MEM_READ_EX_MEM,WB_SIG_EX_MEM :IN STD_LOGIC;
    ALU_OUT_EX_MEM,ALU_OUT_2_EX_MEM,MEM_OUT_MEM_WB :                        IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    ifjz_updt_fsm_FROM_dec:                                                 in std_logic;
    prediction_correct_FROM_comparator:                                     in std_logic;
    addr_fetched_FRMfetch:                                                  in std_logic_vector(31 downto 0);
    addr_executed_FRMfetch :                                                in std_logic_vector(31 downto 0);
    R0,R1,R2,R3,R4,R5,R6,R7 :                                               in std_logic_vector(31 downto 0);

    STALL_SIGNAL,take_jmp_address,last_taken:                               OUT STD_LOGIC;
    JMP_calculated_address_predict :                                        OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);
end Prediction_Stage;

architecture predict of Prediction_Stage is

    signal not_another_inst : 		    STD_LOGIC;
    signal fsm_take_decision : 		    STD_LOGIC;
    signal reg_src : 				    STD_LOGIC_VECTOR (2 downto 0);
    signal ret_rti_call_ready:		    STD_LOGIC;
    signal hazard_prediction_enb : 	    STD_LOGIC;
    signal FSM_decision : 	            STD_LOGIC;
    signal foward_selector    :         STD_LOGIC_VECTOR (1 DOWNTO 0);
    signal my_Reg :                     STD_LOGIC_VECTOR (31 DOWNTO 0);

    signal addr_executed_sig :                     STD_LOGIC_VECTOR (31 DOWNTO 0);
begin
    mini_decode : entity work.MINI_DECODER
        port map(instruction_test,clk_test,reset_test
        --outputs
        ,not_another_inst,fsm_take_decision,reg_src
        ,ret_rti_call_ready,hazard_prediction_enb);

    hazard_detect : entity work.Branch_Hazard_Predection_Unit
        port map(reg_src,DST_ID_EX,DST_EX_MEM,INSTRCTION_10_8_DECODE_STAGE,INSTRUCTION_7_5_DECODE_STAGE
        ,INSTRUCTION_4_2_DECODE_STAGE,SRC1_ID_EX,SRC2_ID_EX,hazard_prediction_enb,WB_SIG_DECODE_STAGE
        ,WB_SIG_ID_EX,SWAP_SIG_DECODE_STAGE,SWAP_SIG_ID_EX,MEM_READ_SIG_DECODE_STAGE,MEM_READ_ID_EX
        ,MEM_READ_EX_MEM,WB_SIG_EX_MEM
        --output
        ,STALL_SIGNAL);

    FWD_unit : entity work.Brach_Forwarding_Unit
        port map(reg_src,SRC1_EX_MEM,DST_EX_MEM,DST_MEM_WB,WB_SIG_EX_MEM,SWAP_SIG_EX_MEM
        ,WB_SIG_MEM_WB,ret_rti_call_ready
        --output
        ,foward_selector);

    forwarded_chooser :entity work.mux_4to1
        port map(a=>my_Reg,b=>ALU_OUT_EX_MEM,c=>ALU_OUT_2_EX_MEM,d=>MEM_OUT_MEM_WB
        ,sel=>foward_selector
        --output
        ,y=>JMP_calculated_address_predict);

    address_executed_BUF : entity work.n_bit_register
    port map(clk_test,reset_test,'1',addr_executed_FRMfetch,addr_executed_sig);

    FSM :entity work.fsm_block
        port map(clk=>clk_test,rst_async=>reset_test,ifjz_updt_fsm=>ifjz_updt_fsm_FROM_dec
        ,prediction_correct=>prediction_correct_FROM_comparator,decision_alwaystaken=>fsm_take_decision
        ,addr_fetched=>addr_fetched_FRMfetch,addr_executed=>addr_executed_sig,
        --output
        taken_not_taken=>FSM_decision); -- Taken = 1                NotTaken = 0

    take_jmp_address<=FSM_decision and not_another_inst;
    last_taken<=FSM_decision;
    
    REG_chooser : entity work.mux_8to1
        port map(R0,R1,R2,R3,R4,R5,R6,R7,sel=>reg_src
        --output
        ,y=>my_Reg);

end predict ; -- predict