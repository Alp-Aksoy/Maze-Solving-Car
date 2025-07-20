library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity counter is
 generic(n: positive:= 10);
    port(clk: in std_logic;
         enable: in std_logic;
         Reset: in std_logic;
         Q: out std_logic_vector(n-1 downto 0));
end counter;
architecture behavioral of counter is
signal count: std_logic_vector(n-1 downto 0):=(others => '0');
begin
counter_process: PROCESS(Reset, clk, count)
                        begin
                        if rising_edge(clk) then 
                            if Reset = '1' then
                                count <= (others => '0');
                            elsif enable = '1' then
                                count <= count + 1;
                            else
                                count <= count;
                            end if;
                        end if;                                       
                        end PROCESS;
            Q <= count; 
end behavioral;
