library ieee;
use ieee.std_logic_1164.all;

entity LDR_Buzzer is
    Port (
        Photo : in std_logic;
        Buzzer : out std_logic
    );
end LDR_Buzzer;

architecture Behavioral of LDR_Buzzer is
begin
    process(Photo)
    begin
        if Photo = '0' then
            Buzzer <= '1';
        else
            Buzzer <= '0';
        end if;
    end process;
end Behavioral;
