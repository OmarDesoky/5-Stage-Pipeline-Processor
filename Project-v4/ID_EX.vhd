library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity id_ex is 

port (
    clk: in std_logic;
    rst_async: in std_logic;
    buffer_enable: in std_logic;
    imm_reg_enable: in std_logic;
    wb_in: in std_logic_vector(4 downto 0); --edited 10/5
    mem_in: in std_logic_vector(6 downto 0); --edited 10/5
    alu_op_in: in std_logic_vector(3 downto 0);
    ex_in: in std_logic_vector(1 downto 0);
    data_1_in: in std_logic_vector(31 downto 0);
    data_2_in: in std_logic_vector(31 downto 0);
    src_1_in: in std_logic_vector(2 downto 0);
    src_2_in: in std_logic_vector(2 downto 0);
    ea_imm_in: in std_logic_vector(31 downto 0);
    pc_in: in std_logic_vector(31 downto 0);
    dst_in: in std_logic_vector(2 downto 0);
    prediction_result_in: in std_logic; --edited 20/5/2020 
    Zero_Flag_in , IF_JZ_IN : in std_logic;
    pc_incremented_in: in std_logic_vector(31 downto 0);
    last_taken_in : in std_logic;
    stop_forward_in :in std_logic;

    wb_out: out std_logic_vector(4 downto 0); --edited 10/5
    mem_out: out std_logic_vector(6 downto 0); --edited 10/5
    alu_op_out: out std_logic_vector(3 downto 0);
    ex_out: out std_logic_vector(1 downto 0);
    data_1_out: out std_logic_vector(31 downto 0);
    data_2_out: out std_logic_vector(31 downto 0);
    src_1_out: out std_logic_vector(2 downto 0);
    src_2_out: out std_logic_vector(2 downto 0);
    ea_imm_out: out std_logic_vector(31 downto 0);
    pc_out: out std_logic_vector(31 downto 0);
    dst_out: out std_logic_vector(2 downto 0);
    prediction_result_out: out std_logic; --edited 20/5/2020 
    Zero_Flag_out , IF_JZ_out : out std_logic;
    pc_incremented_out: out std_logic_vector(31 downto 0);
    last_taken_out : out std_logic;
    stop_forward_out :out std_logic
);
end id_ex ;


architecture id_ex_buffer of id_ex is

begin

process(clk,rst_async,imm_reg_enable,buffer_enable)
begin
    if rst_async = '1' then
        wb_out <= (others => '0');
        mem_out <= (others => '0');
        alu_op_out <= (others => '0');
        ex_out <= (others => '0');
        data_1_out <= (others => '0');
        data_2_out <= (others => '0');
        src_1_out <= (others => '0');
        src_2_out <= (others => '0');
        ea_imm_out <= (others => '0');
        pc_out <= (others => '0');
        dst_out <= (others => '0');
        pc_incremented_out<=(others => '0');
        prediction_result_out <= '0'; --edited 20/5/2020 
        Zero_Flag_out <= '0';
        IF_JZ_out <= '0';
        last_taken_out<='0';
        stop_forward_out <= '0';
    else
        if rising_edge(clk) then
            if imm_reg_enable = '0' then
                ea_imm_out <= ea_imm_in;
                pc_out <= pc_in;
            end if;
            if buffer_enable = '0' then
                src_1_out <= src_1_in;
                src_2_out <= src_2_in;
                dst_out <= dst_in;
            end if;
            data_1_out <= data_1_in;
            data_2_out <= data_2_in;
            wb_out <= wb_in;
            mem_out <= mem_in;
            alu_op_out <= alu_op_in;
            ex_out <= ex_in;
            prediction_result_out<=prediction_result_in; --edited 20/5/2020
            Zero_Flag_out <=  Zero_Flag_in;
            IF_JZ_out <= IF_JZ_IN;
            last_taken_out<=last_taken_in;
            pc_incremented_out<=pc_incremented_in;
            stop_forward_out <= stop_forward_in;
        end if;
    end if;

end process;    

end id_ex_buffer;




-- enables works in an inverted way.