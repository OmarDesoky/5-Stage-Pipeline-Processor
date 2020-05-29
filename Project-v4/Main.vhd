LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_STD.ALL;

entity processor is
  port (
    CLK,RST,INT:    in std_logic;
    DATA_fromIO :   in std_logic_vector(31 downto 0);

    DATA_toIO :     out std_logic_vector(31 downto 0);
    IO_enb :        out std_logic
  ) ;
end processor;

architecture Arch of processor is

    --to decode
    signal last_taken_TO_decode,next_stall_TO_decode,int_TO_decode: std_logic;
    signal instruction_TO_decode :                                  std_logic_vector(15 downto 0);
    signal pc_TO_decode :                                           std_logic_vector(31 downto 0);
    signal PC_incremented_TO_decode :                               std_logic_vector(31 downto 0);

    --from decode
    signal IF_ANY_JUMP_FROM_decode,IN_MIDDLE_OF_IMM_FROM_decode : std_logic;
    signal ifJZ_FROM_decode,zero_flag_FROM_decode,last_taken_FROM_decode :          std_logic;
    signal R0_FROM_decode,R1_FROM_decode,R2_FROM_decode,R3_FROM_decode:             std_logic_vector(31 downto 0);
    signal R4_FROM_decode,R5_FROM_decode,R6_FROM_decode,R7_FROM_decode:             std_logic_vector(31 downto 0);
    signal swap_before_buffer_FROM_decode,wb_enb_before_buffer_FROM_decode:         std_logic;
    signal mem_read_before_buffer_FROM_decode:                                      std_logic;

    --to execute
    signal wb_out_TO_execute:                                             std_logic_vector(4 downto 0); 
    signal mem_out_TO_execute:                                            std_logic_vector(6 downto 0); 
    signal alu_op_out_TO_execute:                                         std_logic_vector(3 downto 0);
    signal ex_out_TO_execute:                                             std_logic_vector(1 downto 0);
    signal data_1_out_TO_execute:                                         std_logic_vector(31 downto 0);
    signal data_2_out_TO_execute:                                         std_logic_vector(31 downto 0);
    signal src_1_out_TO_execute:                                          std_logic_vector(2 downto 0);
    signal src_2_out_TO_execute:                                          std_logic_vector(2 downto 0);
    signal ea_imm_out_TO_execute:                                         std_logic_vector(31 downto 0);
    signal pc_out_TO_execute:                                             std_logic_vector(31 downto 0);
    signal dst_out_TO_execute:                                            std_logic_vector(2 downto 0);
    signal PC_incremented_TO_execute:                                     std_logic_vector(31 downto 0);
    signal zero_flag_TO_execute,if_jz_TO_execute,last_taken_TO_execute :  std_logic;
    signal stop_forwarding_to_execute : std_logic;

    --from execute
    signal ENB_Buffer_EX_MEM:                               std_logic;
    signal wb_out_FROM_execute:                             std_logic_vector(4 downto 0); 
    signal mem_out_FROM_execute:                            std_logic_vector(6 downto 0); 
    signal alu_out1_FROM_execute, alu_out2_FROM_execute:    std_logic_vector(31 downto 0);
    signal EA_IMM_out_FROM_execute, pc_out_FROM_execute:    std_logic_vector(31 downto 0);
    signal src1_out_FROM_execute, DST_out_FROM_execute:     std_logic_vector (2 downto 0);

    --from prediction
    signal take_jmp_addr_FROM_prediction,last_taken_FROM_prediction,next_stall_FROM_prediction :std_logic;
    signal PC_FROM_prediction :                                                                 std_logic_vector(31 downto 0);
    
    --to prediction
    signal PC_fetched_TO_prediction,PC_executed_TO_prediction:                      std_logic_vector(31 downto 0);
    signal PC_correct_forwarded_TO_prediction:                                      std_logic_vector(31 downto 0);          

    --from WB
    signal pc_wb_FROM_WB,swap_wb_FROM_WB,reg_wb_FROM_WB,flag_wb_FROM_WB : std_logic;
    signal wb_sigs_FROM_WB:                                               std_logic_vector(4 downto 0);
    signal DATA_FROM_WB,ALUout1_FROM_WB,ALUout2_FROM_WB,Mem_out_FROM_WB : std_logic_vector(31 downto 0);
    signal dst_FROM_WB,SRC1_FROM_WB :                                     std_logic_vector(2 downto 0);

    -- for printing flags 
    signal carry_flag_final:                             std_logic;
    signal zero_flag_final:                              std_logic;
    signal neg_flag_final:                               std_logic;

    --from memory
    signal Memout_FROM_Memory :                                         std_logic_vector(31 downto 0);
    signal wb_out_FROM_Memory:                                          std_logic_vector(4 downto 0); 

    -- to memory
    signal wb_out_TO_Memory:                          std_logic_vector(4 downto 0); 
    signal mem_out_TO_Memory:                         std_logic_vector(6 downto 0); 
    signal alu_out1_TO_Memory, alu_out2_TO_Memory:    std_logic_vector(31 downto 0);
    signal EA_IMM_out_TO_Memory, pc_out_TO_Memory:    std_logic_vector(31 downto 0);
    signal src1_out_TO_Memory, DST_out_TO_Memory:     std_logic_vector (2 downto 0);

     -- for printing flags 
     signal carry_out_TO_Memory:                       std_logic;
     signal zero_out_TO_Memory:                        std_logic;
     signal neg_out_TO_Memory:                         std_logic;

    --from fetch
    signal instruction_fetched :                  std_logic_vector(15 downto 0);
    signal PC_FROM_fetch :                        std_logic_vector(31 downto 0);
    signal PC_incremented_FROM_fetch :            std_logic_vector(31 downto 0);
    signal INT_FROM_fetch :                       std_logic;

    -- from alu
    signal zero_FROM_ALU,neg_FROM_ALU,carry_FROM_ALU :std_logic;

    -- from data hazard  the difference between lines (88-93) in v2 we convert TO -> FROM in the phrase
    signal PC_ENB_FROM_DATAHAZARD                     : std_logic := '1' ;
    signal insert_bubble_FROM_DATAHAZARD              : std_logic := '0' ;
    signal stall_for_INT_TO_DATAHAZARD                : std_logic        ;
    signal stall_for_jump_prediction_TO_DATAHAZARD    : std_logic        ;
    signal IF_ID_ENB_FROM_DATAHAZARD                  : std_logic := '1' ;

    -- from forwarding unit 
    signal enb_1st_mux_FROM_FW_UNIT, enb_2nd_mux_FROM_FW_UNIT: std_logic_vector(2 downto 0) := "000";

    --from comparator
    signal prediction_result_FROM_comparator          : std_logic        ;
    signal prediction_result_FROM_decode              : std_logic        ;
    signal prediction_result_FROM_execute             : std_logic        ;
begin
    fetch : entity work.Fetch_Stage
        port map(rst_async_test=>RST,int_test=>INT, pc_wb =>pc_wb_FROM_WB
        ,take_jmp_addr_test=>take_jmp_addr_FROM_prediction,take_correct_jmp_addr_test=>prediction_result_FROM_execute
        ,IN_MIDDLE_OF_IMM=>IN_MIDDLE_OF_IMM_FROM_decode,IF_ANY_JUMP=>IF_ANY_JUMP_FROM_decode
        ,CLK=>CLK,flip_next_cycle_INT_test=>IF_ID_ENB_FROM_DATAHAZARD
        ,PC_ENB_DATAHAZARD=>PC_ENB_FROM_DATAHAZARD,Flush=>prediction_result_FROM_comparator
        ,pc_frm_wb_test=>DATA_FROM_WB,calc_jmp_addr_test=>PC_FROM_prediction
        ,pc_forwarded_test=>PC_correct_forwarded_TO_prediction,predection_stall=>next_stall_FROM_prediction
        --outputs
        ,instruction=>instruction_fetched,PC_Saved=>PC_FROM_fetch
        ,address_fetched=>PC_fetched_TO_prediction,address_executed=>PC_executed_TO_prediction
        ,INT_First_Cycle=>INT_FROM_fetch,PC_incremented=>PC_incremented_FROM_fetch);

    IF_ID : entity work.if_id
        port map(CLK,RST,enable=>IF_ID_ENB_FROM_DATAHAZARD,last_taken_in=>last_taken_FROM_prediction
        ,next_stall_in=>next_stall_FROM_prediction
        ,int_in=>INT_FROM_fetch,instruction_in=>instruction_fetched
        ,pc_in=>PC_FROM_fetch,pc_incremented_in=>PC_incremented_FROM_fetch
        --outputs
        ,last_taken_out=>last_taken_TO_decode,pc_incremented_out=>PC_incremented_TO_decode
        ,next_stall_out=>next_stall_TO_decode,int_out=>int_TO_decode
        ,instruction_out=>instruction_TO_decode,pc_out=>pc_TO_decode);

    decode : entity work.decode_stage
        port map(CLK,RST,prediction_result=>prediction_result_FROM_comparator,swap_wb=>swap_wb_FROM_WB,write_enb_wb=>reg_wb_FROM_WB,flag_enb_wb=>flag_wb_FROM_WB
        ,int=>int_TO_decode,stall_next=>next_stall_TO_decode,last_taken=>last_taken_TO_decode
        ,instruction=>instruction_TO_decode,dest_mem_wb=>dst_FROM_WB,data_out_wb=>DATA_FROM_WB
        ,data_swp_wb=>ALUout2_FROM_WB,reg_swap_mem_wb=>SRC1_FROM_WB,pc_in=>pc_TO_decode
        ,zero_flg=>zero_FROM_ALU,carry_flg=>carry_FROM_ALU,neg_flg=>neg_FROM_ALU
        ,insert_bubble=>insert_bubble_FROM_DATAHAZARD,io_data=>DATA_fromIO,pc_incremented=>PC_incremented_TO_decode
        --outputs
        ,wb_outt=>wb_out_TO_execute,mem_outt=>mem_out_TO_execute,alu_op_outt=>alu_op_out_TO_execute
        ,ex_outt=>ex_out_TO_execute,data_1_outt=>data_1_out_TO_execute,data_2_outt=>data_2_out_TO_execute
        ,src_1_outt=>src_1_out_TO_execute,src_2_outt=>src_2_out_TO_execute, ea_imm_outt=> ea_imm_out_TO_execute
        ,pc_outt=>pc_out_TO_execute,dst_outt=>dst_out_TO_execute,prediction_result_outt=>prediction_result_FROM_decode
        ,stall_for_int=>stall_for_INT_TO_DATAHAZARD,stall_for_jmp_pred=>stall_for_jump_prediction_TO_DATAHAZARD
        ,ifjmp_upd_fsm=>ifJZ_FROM_decode,zero_flag_compara=>zero_flag_FROM_decode
        ,last_taken_compara=>last_taken_FROM_decode,inmiddleofimm=>IN_MIDDLE_OF_IMM_FROM_decode
        ,ifanyjmp=>IF_ANY_JUMP_FROM_decode,pc_incremented_outt=>PC_incremented_TO_execute,last_taken_outt=>last_taken_TO_execute
        ,swap_before_buffer=>swap_before_buffer_FROM_decode,wb_enb_before_buffer=>wb_enb_before_buffer_FROM_decode
        ,mem_read_before_buffer=>mem_read_before_buffer_FROM_decode
        ,R0=>R0_FROM_decode,R1=>R1_FROM_decode,R2=>R2_FROM_decode
        ,R3=>R3_FROM_decode,R4=>R4_FROM_decode,R5=>R5_FROM_decode,R6=>R6_FROM_decode,R7=>R7_FROM_decode,
        zero_flag_outt=>zero_flag_TO_execute,if_jz_outt=>if_jz_TO_execute,stop_forward_to_ex=>stop_forwarding_to_execute);

    Execution :  entity work.Execution_Stage
      port map(wb_in=>wb_out_TO_execute,mem_in=>mem_out_TO_execute,alu_op=>alu_op_out_TO_execute
      ,ex_in=>ex_out_TO_execute,reg1_data=>data_1_out_TO_execute, reg2_data=>data_2_out_TO_execute
      ,alu_out2_MEM_WB=>ALUout2_FROM_WB, alu_out_MEM_WB=>ALUout1_FROM_WB
      ,alu_out_EX_MEM=>alu_out1_TO_Memory, alu_out2_EX_MEM=>alu_out2_TO_Memory
      ,mem_out_MEM_WB=>Mem_out_FROM_WB,src1=>src_1_out_TO_execute, src2=>src_2_out_TO_execute
      ,dst=>dst_out_TO_execute,ea_imm_in=>ea_imm_out_TO_execute, pc_in=>pc_out_TO_execute
      ,enb_1st_mux=>enb_1st_mux_FROM_FW_UNIT, enb_2nd_mux=>enb_2nd_mux_FROM_FW_UNIT
      ,zero_flag_in=>zero_flag_TO_execute,if_jz_in=>if_jz_TO_execute,pc_incremented_in=>PC_incremented_TO_execute
      ,last_taken_in=>last_taken_TO_execute,prediction_result_in=>prediction_result_FROM_decode
      --outputs
      ,Mem_out=>mem_out_FROM_execute,wb_out=>wb_out_FROM_execute,alu_out1=>alu_out1_FROM_execute 
      ,alu_out2=>alu_out2_FROM_execute, EA_IMM_out=>EA_IMM_out_FROM_execute, pc_out=>pc_out_FROM_execute
      ,src1_out=>src1_out_FROM_execute, DST_out=>DST_out_FROM_execute, IO_out=>DATA_toIO
      ,forwarded_jmp_addr=>PC_correct_forwarded_TO_prediction
      ,zero_flag=>zero_FROM_ALU, carry_flag=>carry_FROM_ALU, neg_flag=>neg_FROM_ALU,take_jump_Correct=>prediction_result_FROM_execute);
    
    Buffer_Holder_1 :entity work.buffer_holder1
      port map(CLK,RST,mem_out_FROM_execute(4)
      --outputs
      ,ENB_Buffer=>ENB_Buffer_EX_MEM);
    
    EX_MEM_Buffer :  entity work.ex_mem
      port map(CLK,RST,ENB_Buffer_EX_MEM,wb_in=>wb_out_FROM_execute,mem_in=>mem_out_FROM_execute
      ,alu_out_1_in=>alu_out1_FROM_execute,alu_out_2_in=>alu_out2_FROM_execute,ea_imm_in=>EA_IMM_out_FROM_execute
      ,src_1_in=>src1_out_FROM_execute,pc_in=>pc_out_FROM_execute,dst_in=>DST_out_FROM_execute,
      carry_in=>carry_FROM_ALU,zero_in=>zero_FROM_ALU,neg_in=>neg_FROM_ALU
      --outputs
      ,wb_out=>wb_out_TO_Memory,mem_out=>mem_out_TO_Memory,alu_out_1_out=>alu_out1_TO_Memory
      ,alu_out_2_out=>alu_out2_TO_Memory,ea_imm_out=>EA_IMM_out_TO_Memory
      ,src_1_out=>src1_out_TO_Memory,pc_out=>pc_out_TO_Memory,dst_out=>DST_out_TO_Memory,
      carry_out=>carry_out_TO_Memory,zero_out=>zero_out_TO_Memory,neg_out=>neg_out_TO_Memory);
    
    Memory :entity work.Memory_Stage
      port map(CLK,RST,wb_in=>wb_out_TO_Memory,mem_in=>mem_out_TO_Memory
      ,alu_out_1_in=>alu_out1_TO_Memory,ea_imm_in=>EA_IMM_out_TO_Memory
      ,pc_in=>pc_out_TO_Memory
      --outputs
      ,Mem_out=>Memout_FROM_Memory,wb_out=>wb_out_FROM_Memory);
    
    MEM_WB_Buffer :  entity work.mem_wb
      port map(CLK,RST,enable=>'1',wb_in=>wb_out_FROM_Memory
      ,mem_out_in=>Memout_FROM_Memory,alu_out_1_in=>alu_out1_TO_Memory
      ,alu_out_2_in=>alu_out2_TO_Memory,src_1_in=>src1_out_TO_Memory,dst_in=>DST_out_TO_Memory,
      carry_in=>carry_out_TO_Memory,zero_in=>zero_out_TO_Memory,neg_in=>neg_out_TO_Memory
      --outputs
      ,wb_out=>wb_sigs_FROM_WB,mem_out_out=>Mem_out_FROM_WB,alu_out_1_out=>ALUout1_FROM_WB
      ,alu_out_2_out=>ALUout2_FROM_WB,src_1_out=>SRC1_FROM_WB,dst_out=>dst_FROM_WB,
      carry_out=>carry_flag_final,zero_out=>zero_flag_final,neg_out=>neg_flag_final);

      pc_wb_FROM_WB<=   wb_sigs_FROM_WB(1);
      swap_wb_FROM_WB<= wb_sigs_FROM_WB(3);
      reg_wb_FROM_WB<=  wb_sigs_FROM_WB(0);
      flag_wb_FROM_WB<= wb_sigs_FROM_WB(4);

    Output_Chooser :entity work.mux_2to_1
      port map(ALUout1_FROM_WB,Mem_out_FROM_WB,
      wb_sigs_FROM_WB(2)
      --outputs
      ,DATA_FROM_WB);

---------------------------------------------adding forwarding unit---------------------------------------------

    FW_Unit :entity work.ForwardingUnit
    port map(SRC1=>src_1_out_TO_execute,SRC2=>src_2_out_TO_execute,DST_MEM_WB=>dst_FROM_WB
    ,DST_EX_MEM=>DST_out_TO_Memory,DST2_EX_MEM=>src1_out_TO_Memory,DST2_MEM_WB=>SRC1_FROM_WB
    ,SWAP_SIGNAL_EX_MEM=>wb_out_TO_Memory(3),SWAP_SIGNAL_MEM_WB=>swap_wb_FROM_WB
    ,WB_MEM_WB=>reg_wb_FROM_WB,WB_EX_MEM=>wb_out_TO_Memory(0),MEM_OR_REG_MEM_WB=>wb_sigs_FROM_WB(2),disable=>stop_forwarding_to_execute
    --outputs
    ,ENABLE_1ST_MUX=>enb_1st_mux_FROM_FW_UNIT, ENABLE_2ND_MUX=>enb_2nd_mux_FROM_FW_UNIT);

------------------------------------------adding hazard detection unit--------------------------------------------

    Hazard_detect :entity work.data_hazard_detection_unit
    port map(SRC1=>instruction_TO_decode(7 downto 5), SRC2=>instruction_TO_decode(4 downto 2)
    ,DST=> dst_out_TO_execute,MEM_READ_ID_EX=>mem_out_TO_execute(1)
    ,STALL_FOR_JUMP_PREDECTION=>stall_for_jump_prediction_TO_DATAHAZARD,STALL_FOR_INT=>stall_for_INT_TO_DATAHAZARD
    --outputs
    ,INSERT_BUBBLE=>insert_bubble_FROM_DATAHAZARD,PC_ENB=>PC_ENB_FROM_DATAHAZARD
    ,IF_ID_ENB=>IF_ID_ENB_FROM_DATAHAZARD);

------------------------------------------adding perdiction--------------------------------------------------------
    prediction_result :entity work.comparator
    port map(zero_flag=>zero_flag_FROM_decode,last_taken=>last_taken_FROM_decode,if_JZ=>ifJZ_FROM_decode
    --output
    ,flush=>prediction_result_FROM_comparator);

    prediction_stage :entity work.Prediction_Stage
    port map(instruction_test=>instruction_fetched,clk_test=>CLK,reset_test=>RST
    ,DST_ID_EX=>dst_out_TO_execute,DST_EX_MEM=>DST_out_TO_Memory
    ,INSTRCTION_10_8_DECODE_STAGE=>instruction_TO_decode(10 downto 8)
    ,INSTRUCTION_7_5_DECODE_STAGE=>instruction_TO_decode(7 downto 5)
    ,INSTRUCTION_4_2_DECODE_STAGE=>instruction_TO_decode(4 downto 2)
    ,SRC1_ID_EX=>src_1_out_TO_execute,SRC2_ID_EX=>src_2_out_TO_execute
    ,SRC1_EX_MEM=>src1_out_TO_Memory,DST_MEM_WB=>dst_FROM_WB,WB_SIG_DECODE_STAGE=>wb_enb_before_buffer_FROM_decode
    ,WB_SIG_ID_EX=>wb_out_TO_execute(0),SWAP_SIG_DECODE_STAGE=>swap_before_buffer_FROM_decode
    ,SWAP_SIG_ID_EX=>wb_out_TO_execute(3),SWAP_SIG_EX_MEM=>wb_out_TO_Memory(3),WB_SIG_MEM_WB=>reg_wb_FROM_WB
    ,MEM_READ_SIG_DECODE_STAGE=>mem_read_before_buffer_FROM_decode,MEM_READ_ID_EX=>mem_out_TO_execute(1)
    ,MEM_READ_EX_MEM=>mem_out_TO_Memory(1),WB_SIG_EX_MEM=>wb_out_TO_Memory(0)
    ,ALU_OUT_EX_MEM=>alu_out1_TO_Memory,ALU_OUT_2_EX_MEM=>alu_out2_TO_Memory,MEM_OUT_MEM_WB=>Mem_out_FROM_WB
    ,ifjz_updt_fsm_FROM_dec=>ifJZ_FROM_decode,prediction_correct_FROM_comparator=>prediction_result_FROM_comparator
    ,addr_fetched_FRMfetch=>PC_fetched_TO_prediction,addr_executed_FRMfetch=>PC_executed_TO_prediction
    ,R0=>R0_FROM_decode,R1=>R1_FROM_decode,R2=>R2_FROM_decode,R3=>R3_FROM_decode,R4=>R4_FROM_decode,
    R5=>R5_FROM_decode,R6=>R6_FROM_decode,R7=>R7_FROM_decode,
    --outputs
    STALL_SIGNAL=>next_stall_FROM_prediction,take_jmp_address=>take_jmp_addr_FROM_prediction
    ,last_taken=>last_taken_FROM_prediction,JMP_calculated_address_predict=>PC_FROM_prediction);

end Arch ; -- Arch
