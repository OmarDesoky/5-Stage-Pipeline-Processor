LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
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
    signal last_taken_TO_decode,next_stall_TO_decode,int_TO_decode:std_logic;
    signal instruction_TO_decode :std_logic_vector(15 downto 0);
    signal pc_TO_decode :std_logic_vector(31 downto 0);

    --from decode
    signal IF_ANY_JUMP_FROM_decode,Flush_FROM_decode,IN_MIDDLE_OF_IMM_FROM_decode,IF_ID_ENB :std_logic;

    --from prediction
    signal take_jmp_addr_FROM_prediction,last_taken_FROM_prediction,next_stall_FROM_prediction :std_logic;
    signal PC_FROM_prediction :std_logic_vector(31 downto 0);

    --from WB
    signal pc_wb_FROM_WB :std_logic;
    signal PC_FROM_WB :std_logic_vector(31 downto 0);

    --from fetch
    signal instruction_fetched :std_logic_vector(15 downto 0);
    signal PC_FROM_fetch :std_logic_vector(31 downto 0);
    signal INT_FROM_fetch :std_logic;


begin
    fetch : entity work.Fetch_Stage
        port map(rst_async_test=>RST,int_test=>INT, pc_wb =>pc_wb_FROM_WB,take_jmp_addr_test=>take_jmp_addr_FROM_prediction
        ,IN_MIDDLE_OF_IMM=>IN_MIDDLE_OF_IMM_FROM_decode,IF_ANY_JUMP=>IF_ANY_JUMP_FROM_decode,CLK,flip_next_cycle_INT_test=>IF_ID_ENB
        ,PC_ENB_DATAHAZARD=>'1',Flush=>Flush_FROM_decode,pc_frm_wb_test=>PC_FROM_WB,calc_jmp_addr_test=>PC_FROM_prediction,
        instruction=>instruction_fetched,PC_Saved=>PC_FROM_fetch,INT_First_Cycle=>INT_FROM_fetch);

    IF_ID : entity work.if_id
        port map(CLK,RST,enable=>IF_ID_ENB,last_taken_in=>last_taken_FROM_prediction,next_stall_in=>next_stall_FROM_prediction
        ,int_in=>INT_FROM_fetch,instruction_in=>instruction_fetched,pc_in=>PC_FROM_fetch,last_taken_out=>last_taken_TO_decode
        ,next_stall_out=>next_stall_TO_decode,int_out=>int_TO_decode,instruction_out=>instruction_TO_decode,pc_out=>pc_TO_decode);

    
end Arch ; -- Arch