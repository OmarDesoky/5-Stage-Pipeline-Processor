library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is 

port (
    clk: in std_logic;
    rst_async: in std_logic;
    write_enb: in std_logic;
    swap : in std_logic;
    flag_enb: in std_logic;

    carry: in std_logic;
    zero: in std_logic;
    neg: in std_logic;

    read_reg_1: in std_logic_vector(2 downto 0);
    read_reg_2: in std_logic_vector(2 downto 0);

    write_reg: in std_logic_vector(2 downto 0);
    write_data: in std_logic_vector(31 downto 0);

    write_reg_swap: in std_logic_vector(2 downto 0);
    write_data_swap: in std_logic_vector(31 downto 0);

    flags_out : out std_logic_vector(31 downto 0);
    read_data_1: out std_logic_vector(31 downto 0);
    read_data_2: out std_logic_vector(31 downto 0)

);
end registers ;


architecture registers_file of registers is

    component  n_bit_register is 
    generic (size : integer := 32);
    port (
        clk: in std_logic;
        rst_async: in std_logic;
        write_enb: in std_logic;
        d : in std_logic_vector(size-1 downto 0);
        q : out std_logic_vector(size-1 downto 0)
    );
    end component ;

    component mux_2to_1 is

        generic (size : integer := 32);
        
        Port (
            a: in std_logic_vector(size-1 downto 0);
            b: in std_logic_vector(size-1 downto 0);
            sel: in std_logic;
            y: out std_logic_vector(size-1 downto 0)
        );                        
    end component;

type array_reg is array (0 to 7) of std_logic_vector(31 downto 0);
signal chosen_data : array_reg ;
signal out_data : array_reg ;
signal check_wb : std_logic_vector(7 downto 0);
signal check_wb_swap : std_logic_vector(7 downto 0);
signal final_check :std_logic_vector(7 downto 0);

signal flag_bits:std_logic_vector(2 downto 0);
signal chosen_data_flags: std_logic_vector(2 downto 0);
signal out_data_flags: std_logic_vector(2 downto 0);
signal sign_extend : std_logic_vector(28 downto 0);
begin

    genCompReg:for i in 0 to 7 generate
        check_wb(i) <= '1' when (to_integer(unsigned(write_reg)) = i ) else '0';
        check_wb_swap(i) <= '1' when (to_integer(unsigned(write_reg_swap)) = i ) else '0';
        mux_reg: mux_2to_1 generic map(size=>32) port map(write_data,write_data_swap,check_wb_swap(i),chosen_data(i));
        final_check(i)<=  ( check_wb(i) or check_wb_swap(i)  ) and write_enb;
        r: n_bit_register generic map(size=>32) port map (clk,rst_async, final_check(i),chosen_data(i),out_data(i));

    end generate genCompReg;
    read_data_1 <=out_data( to_integer(unsigned(read_reg_1)) );
    read_data_2 <=out_data( to_integer(unsigned(read_reg_2)) );

    flag_bits<=carry&zero&neg;
    mux_flags: mux_2to_1 generic map(size=>3) port map (flag_bits,write_data(2 downto 0),flag_enb,chosen_data_flags);
    flags: n_bit_register generic map(size=>3) port map (clk,rst_async,'1',chosen_data_flags,out_data_flags);

    sign_extend <= (others => '0');
    flags_out <= sign_extend & out_data_flags;

end registers_file;