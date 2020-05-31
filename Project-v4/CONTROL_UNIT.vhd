library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is 

port (
    clk : in std_logic;
    int : in std_logic;
    op : in std_logic_vector(4 downto 0);
    --wb signals
    write_enable: out std_logic;
    pc_wb: out std_logic;
    mem_or_reg: out std_logic;
    swap : out std_logic;
    flag_register_wb : out std_logic;
    -- mem signals
    mem_write: out std_logic;
    mem_read: out std_logic;
    int_rti_dntuse: out std_logic_vector(2 downto 0);
    sp_enb: out std_logic_vector(1 downto 0);
    -- alu op
    alu_op: out std_logic_vector(3 downto 0);
    -- execute signals
    alu_source: out std_logic;
    io_enable: out std_logic;

    -- used in decode and fetch signals
    imm_ea: out std_logic;
    jz_upt_fsm: out std_logic;
    imm_reg_enb: out std_logic;
    reg_enb: out std_logic;
    mid_imm: out std_logic;
    any_jmp: out std_logic;
    stall_int: out std_logic;
    flush_Decode : out std_logic
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



--  ALU Operations
constant NOP_ALU : std_logic_vector(3 downto 0) := "0000";
constant SUB_ALU : std_logic_vector(3 downto 0) := "0001";
constant AND_ALU : std_logic_vector(3 downto 0) := "0010";
constant OR_ALU : std_logic_vector(3 downto 0) := "0011";
constant SWAP_ALU : std_logic_vector(3 downto 0) := "0100";
constant SHL_ALU : std_logic_vector(3 downto 0) := "0101";
constant SHR_ALU : std_logic_vector(3 downto 0) := "0110";
constant ADD_ALU : std_logic_vector(3 downto 0) := "0111";
constant NOT_ALU : std_logic_vector(3 downto 0) := "1000";
constant INC_ALU : std_logic_vector(3 downto 0) := "1001";
constant DEC_ALU : std_logic_vector(3 downto 0) := "1010";


signal counter : integer range 0 to 1;
signal counter2 : integer range 0 to 4;
signal counter3 : integer range 0 to 3;
signal last_op: std_logic_vector(4 downto 0);
signal last_op2: std_logic_vector(4 downto 0);

begin

    process(clk,op, int)
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
        stall_int<='0';
	    flush_Decode <= '0';
        if(falling_edge(clk)) then
            if counter > 0 then
                if (last_op = IADD) or (last_op = SHL) or (last_op = SHR) or (last_op = LDM) then
                    write_enable<='1';
                    if(last_op=IADD) then
                        alu_op<= ADD_ALU;
                    elsif(last_op=SHL) then
                        alu_op<=SHL_ALU;
                    elsif(last_op=SHR) then 
                        alu_op<=SHR_ALU;
                    else
                        alu_op<=SWAP_ALU;
                    end if;
                    alu_source <='1';
                -- elsif last_op = LDM then    ~changed 5/19 OMAR
                --      mem_read<='1';               
                --     write_enable<='1';
                --     mem_or_reg<='1';
                elsif last_op = LDD then
                    mem_read<='1';
                    imm_ea<='1';
                    write_enable<='1';
                    mem_or_reg<='1';
                elsif last_op = STD then
                    mem_write<='1';
                    imm_ea<='1';
                end if;
                reg_enb<='1';
                counter<=0;
                    
            elsif counter2 > 0 then

                --if last_op2 = RTI then
                    --stall_int<='1';
                    --if counter2 = 4 then 
                        --counter2<=0;
                    --else
                        --counter2<=counter2+1;
                    --end if;
                --else
                stall_int<='1';
                    --if counter2 = 2 then 
                 counter2<=0;
                    --else
                    --    counter2<=counter2+1;
                    --end if;                
                --end if;
            elsif counter3 = 2 then
                stall_int <= '1';
                counter3 <= 0;
            elsif counter3 = 1 then
                stall_int <= '1';
                counter3 <= counter3+1;
    
            elsif (op=IADD) or (op = SHL) or (op = SHR) or (op = LDD) or (op = LDM) or (op = STD) then
                mid_imm <= '1';
                imm_reg_enb <= '1';
                counter <= counter +1;
                last_op <= op;
            elsif (op = RTI) then
                mem_read<='1';
                mem_or_reg<='1';
                sp_enb<="10";
                pc_wb<= '1';
                any_jmp<='1';
                int_rti_dntuse<="101";
                flush_Decode <= '1';
                counter3 <= counter3+1;

            elsif (int='1') then
                sp_enb <="11";
                mem_write <='1';
                int_rti_dntuse<= "100";
                counter2 <= counter2 +1;

                flush_Decode <= '1';
                -- counter3 <= counter3+1; --31/5/2020 ahmed and mostafa
    
            elsif (op = ADD) or (op = SUB) or (op = ANDD) or (op = ORR) or (op = INC) or (op = DEC) or (op =NOTT) then
                write_enable<='1';
                if op = ADD then
                    alu_op <= ADD_ALU;
                elsif (op = SUB) then
                    alu_op <= SUB_ALU;
                elsif (op = ORR) then
                    alu_op <= OR_ALU;
                elsif (op = ANDD) then
                    alu_op <= AND_ALU;               
                elsif (op = INC) then
                    alu_op <= INC_ALU;                    
                elsif (op = DEC) then
                    alu_op <= DEC_ALU;
                elsif (op =NOTT) then
                    alu_op <= NOT_ALU;
                end if;
            elsif (op = INN) then
                write_enable<='1';
            elsif (op = OUTT) then
                io_enable<='1';
            elsif (op = PUSH) then
                --write_enable<='1';
		        mem_write <='1';
                sp_enb<="11";
            elsif (op = POP) then
                mem_read<='1';
                mem_or_reg<='1';
                sp_enb<="10";
                write_enable<='1';
            elsif (op = JZ) then
                jz_upt_fsm<='1';
                any_jmp<='1';
            elsif (op = JMP) then
                any_jmp<='1';
		        flush_Decode<='1';                                           
            elsif (op = CALL) then
                sp_enb<="11";
                mem_write<='1';
                any_jmp<='1';
		        flush_Decode<='1';
                int_rti_dntuse<="010";
                -- modification by ahmed waleed in 29/5/2020
                -- we should write back in pc so i will add
                pc_wb<='1';
            elsif (op = RET) then
                pc_wb<='1';
                sp_enb<="10";
                mem_read<='1';
                any_jmp<='1';
                int_rti_dntuse<="011";
                mem_or_reg<='1';
                flush_Decode <= '1';
                counter3 <= counter3+1;
            elsif (op = SWAPP) then
                alu_op <= NOP_ALU ;
                swap<='1';
                write_enable<='1';
    
            end if;

        end if;

    end process; 

end control;