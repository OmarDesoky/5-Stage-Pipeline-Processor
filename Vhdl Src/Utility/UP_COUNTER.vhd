library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_counter is

generic (size : integer := 32);

Port (
    clk : in std_logic;
    rst_async : in std_logic;
    enable : in std_logic;
    y: out std_logic_vector(size-1 downto 0)
);                        
end up_counter;

architecture general_counter of up_counter is
begin

    process(clk,enable,rst_async)
        VARIABLE cnt : INTEGER:= 0;
        begin
            if rst_async = '1' then
                cnt := 0;
            else
                if(rising_edge(clk) and enable ='1') then
                    cnt := cnt + 1;
                end if;
            end if;
            y <= std_logic_vector(to_unsigned( cnt,y'length));
    end process;

end general_counter;


-- this counter when enabled increments counter by 1 (always increments when enabled)
-- it starts from zero when reseted