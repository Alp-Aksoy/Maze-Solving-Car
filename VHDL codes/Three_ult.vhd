library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Three_ultrasonic is
Port ( 
fpgaclk: in std_logic;
Echo: in std_logic_vector(2 downto 0);
trigout:out std_logic_vector(2 downto 0); 
ultrasens_out:out std_logic_vector(2 downto 0)
);
end Three_ultrasonic;

architecture Behavioral of Three_ultrasonic is
component Ult is
Port (
Echo: in std_logic;
clk: in std_logic;
Trigger: out std_logic;
Wall: out std_logic
 );
end component;
component Ult_front is
Port (
Echo: in std_logic;
clk: in std_logic;
Trigger: out std_logic;
Wall: out std_logic
 );
end component; 
begin
ultrasonic_Left: Ult port map(clk=>fpgaclk,Echo=>Echo(0),Trigger=>trigout(0),Wall=>ultrasens_out(0));
ultrasonic_Middle: Ult_front port map(clk=>fpgaclk,Echo=>Echo(1),Trigger=>trigout(1),Wall=>ultrasens_out(1)); 
ultrasonic_Right: Ult port map(clk=>fpgaclk,Echo=>Echo(2),Trigger=>trigout(2),Wall=>ultrasens_out(2)); 
end Behavioral;
