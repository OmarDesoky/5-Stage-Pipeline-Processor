library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is 

port (
    op : in std_logic_vector(4 downto 0);
    int : in std_logic;
    write_enable: out std_logic;
    pc_wb: out std_logic;
    mem_or_reg: out std_logic;
    swap : out std_logic;
    flag_register_wb : out std_logic;
    mem_write: out std_logic;
    mem_read: out std_logic;
    int_rti_dntuse: out std_logic_vector(2 downto 0);
    alu_op: out std_logic_vector(3 downto 0);
    sp_enb: out std_logic_vector(1 downto 0);
    alu_source: out std_logic;
    io_enable: out std_logic;
    imm_ea: out std_logic;
    jz_upt_fsm: out std_logic;
    imm_reg_enb: out std_logic;
    reg_enb: out std_logic;
    mid_imm: out std_logic;
    any_jmp: out std_logic
);
end control_unit ;


architecture control of control_unit is

constant ADD : std_logic_vector(4 downto 0) := "00100";
constant SUB : std_logic_vector(4 downto 0) := "00101";
constant ANDD : std_logic_vector(4 downto 0) := "00110";
constant ORR : std_logic_vector(4 downto 0) := "00111";
constant SWAPP : std_logic_vector(4 downto 0) := "00011";
constant IADD : std_logic_vector(4 downto 0) := "00010";
constant SHL : std_logic_vector(4 downto 0) := "00000";
constant SHR : std_logic_vector(4 downto 0) := "00001";

-- constant NOP : std_logic_vector(4 downto 0) := "01111";
constant NOTT : std_logic_vector(4 downto 0) := "01000";
constant INC : std_logic_vector(4 downto 0) := "01001";
constant DEC : std_logic_vector(4 downto 0) := "01010";
constant OUTT : std_logic_vector(4 downto 0) := "01011";
constant INN : std_logic_vector(4 downto 0) := "01100";

constant PUSH : std_logic_vector(4 downto 0) := "10000";
constant POP : std_logic_vector(4 downto 0) := "10001";
constant LDM : std_logic_vector(4 downto 0) := "10010";
constant LDD : std_logic_vector(4 downto 0) := "10011";
constant STD : std_logic_vector(4 downto 0) := "10100";

constant JZ : std_logic_vector(4 downto 0) := "11000";
constant JMP : std_logic_vector(4 downto 0) := "11001";
constant CALL : std_logic_vector(4 downto 0) := "11010";
constant RET : std_logic_vector(4 downto 0) := "11110";
constant RTI : std_logic_vector(4 downto 0) := "11111";


begin

    process(op, int)
    begin
        write_enable<='0';
        pc_wb<='0';
        mem_or_reg<='0';
        swap<='0';
        flag_register_wb<='0';
        mem_write<='0';
        mem_read<='0';

        int_rti_dntuse<= (others => '0');
        alu_op<= (others => '0');
        sp_enb<= (others => '0');

        alu_source<='0';
        io_enable<='0';
        imm_ea<='0';
        jz_upt_fsm<='0';
        imm_reg_enb<='0';
        reg_enb<='0';
        mid_imm<='0';
        any_jmp<='0';
        if (op = ADD) or (op = SUB) or (op = ANDD) or (op = ORR) or (op = INC) or (op = DEC) or (op =NOTT) then
            write_enable<='1';
            -- alu_op <= ;
        elsif (op = INN) then
            write_enable<='1';
        elsif (op = OUTT) then
            io_enable<='1';
        elsif (op = PUSH) then
            write_enable<='1';
            sp_enb<="01";
            -- alu_op <= NOOP ;
        elsif (op = POP) then
            mem_read<='1';
            mem_or_reg<='1';
            sp_enb<="00";
            write_enable<='1';
            -- alu_op <= NOOP ;
        elsif (op = JZ) then
            jz_upt_fsm<='1';
            -- alu_op <= NOOP ;
            any_jmp<='1';
        elsif (op = JMP) then
            -- alu_op <= NOOP ;
            any_jmp<='1';
        elsif (op = CALL) then
            sp_enb<="01";
            mem_write<='1';
            any_jmp<='1';
            int_rti_dntuse<="011";
        elsif (op = SWAPP) then
            -- alu_op <= NOOP ;
            swap<='1';
            write_enable<='1';
        -- elsif (op = int) or (op = RTI) then
            -- 
        -- elsif(op= (IADD/SHL/SHR || LDD || LDI ||STD) )
            -- 

        end if;

    end process; 


end control;