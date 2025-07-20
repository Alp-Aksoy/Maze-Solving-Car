library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pwm is
Port (
clkk_100: in std_logic;
duty: in std_logic_vector(15 downto 0);
pwm:out std_logic
);
end pwm;
architecture Behavioral of pwm is
component clkdiv is
port(
clkk_100:in std_logic;
clr: in std_logic;
clkk_q:out std_logic
);
end component;
signal count : unsigned(15 DOWNTO 0);
    signal clk, pwm_sig : std_logic;
    signal period : unsigned(15 downto 0);
    signal clr : std_logic;
    signal duty_unsigned : unsigned(15 downto 0);
begin
period <= X"00C3";  --195 clock cycle

    clr <= '0';
    duty_unsigned <= unsigned(duty);

    process (clk, clr)
    begin
        if (clr = '1') then
            count <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (count = period - 1) then
                count <= (others => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    process (count, duty_unsigned)
    begin
        if (count < duty_unsigned) then -- duty cycle, which will determine the speed
            pwm_sig <= '1';
        else
            pwm_sig <= '0';
        end if;
    end process;
    pwm <= pwm_sig;
CLOCK : clkdiv PORT MAP(clkk_100 => clkk_100, clr => '0',clkk_q => clk);  
end Behavioral; 
