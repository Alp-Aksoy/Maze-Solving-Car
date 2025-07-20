library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Car is
port(
basysclk: in std_logic;
echo: in std_logic_vector(2 downto 0);
trigger: out std_logic_vector(2 downto 0);
LED : out std_logic_vector(2 downto 0);
Leftm_forw: out std_logic;
Rightm_forw: out std_logic;
Leftm_backw: out std_logic;
Rightm_backw: out std_logic;
Photo: in std_logic;
Pled: out std_logic;
Buzzer: out std_logic
);
end entity;
architecture behaviour of car is
component LDR_Buzzer is
Port (
        Photo : in std_logic;
        Buzzer : out std_logic
    );
end component;
component pwm is
port(
           clkk_100: in std_logic;
           duty: in std_logic_vector(15 downto 0);
           pwm : out std_logic);
end component;
component Three_ultrasonic is
Port ( 
fpgaclk: in std_logic;
Echo: in std_logic_vector(2 downto 0);
trigout:out std_logic_vector(2 downto 0); 
ultrasens_out:out std_logic_vector(2 downto 0)
);
end component;
signal ultrasonic: std_logic_vector(2 downto 0); 
signal pwm_1: std_logic;
signal pwm_2 : std_logic;
signal forw: std_logic;
signal backw: std_logic;
signal turnL: std_logic;
signal turnR: std_logic;
signal duty_1: std_logic_vector(15 downto 0);
signal duty_2: std_logic_vector(15 downto 0);
signal memory_element: std_logic_vector(2 downto 0);
signal lock: std_logic:='0';
signal lower_clock: std_logic;
begin 
Pwm1:pwm port map(clkk_100=>basysclk,duty=>duty_1,pwm=>pwm_1); 
Pwm2:pwm port map(clkk_100=>basysclk,duty=>duty_2,pwm=>pwm_2);
process(forw,backw,turnL,turnR,Photo) begin 
     if(forw = '1') then
          Rightm_forw <= pwm_1;
          Leftm_forw <= pwm_2;
          Leftm_backw <= '0';
          Rightm_backw <= '0';
     elsif(backw = '1') then
          Rightm_backw <= '0';
          Leftm_backw <= pwm_2;
          Rightm_forw <= pwm_1;
          Leftm_forw <= '0';
     elsif(turnR = '1') then
          Leftm_forw <= pwm_2;
          Rightm_backw <= pwm_1;
          Rightm_forw <= '0';
          Leftm_backw <= '0';
     elsif(turnL = '1') then
          Rightm_forw <= pwm_1;
          Leftm_backw <= pwm_2;
          Rightm_backw <= '0';
          Leftm_forw <= '0';
     elsif(Photo = '0') then
        Rightm_forw <= '0';
        Leftm_backw <= '0';
        Rightm_backw <= '0';
        Leftm_forw <= '0';
     end if;
end process;
Ultrasonics:Three_ultrasonic port map(fpgaclk=>basysclk,Echo=>echo,trigout=>trigger,ultrasens_out=>ultrasonic);
process(ultrasonic)
    begin
    if rising_edge(basysclk) then
        if Photo='1' then
            case (ultrasonic) is
                when "000" =>
                    forw <= '1'; backw <= '0'; turnR <= '0'; turnL <= '0';
                    duty_1 <= X"0077"; duty_2 <= X"0070";

                when "001" =>
                    forw <= '0'; backw <= '0'; turnR <= '1'; turnL <= '0';
                    duty_1 <= X"0070"; duty_2 <= X"0070";
                    if lock = '0' then
                        memory_element<="001";
                        lock <= '1';
                    end if;
                when "010" =>
                    if memory_element="001" then
                        backw <= '0'; forw <= '0'; turnR <= '1'; turnL <= '0';
                        duty_1 <= X"0070"; duty_2 <= X"0070";
                        
                    elsif memory_element="100" then
                        backw <= '0'; forw <= '0'; turnR <= '0'; turnL <= '1';
                        duty_1 <= X"0070"; duty_2 <= X"0070";

                    end if;
                when "011" =>
                    turnL <= '0'; backw <= '0'; forw <= '0'; turnR <= '1';
                    duty_1 <= X"0070"; duty_2 <= X"0070";


                when "100" =>
                    forw <= '0'; backw <= '0'; turnR <= '0'; turnL <= '1';
                    duty_1 <= X"0050"; duty_2 <= X"0070";
                    if lock = '0' then
                        memory_element<="100";    
                        lock <= '1';
                    end if;
                    
                when "101" =>
                    forw <= '1'; backw <= '0'; turnR <= '0'; turnL <= '0';
                    duty_1 <= X"0077"; duty_2 <= X"0070";


                when "110" =>
                    turnR <= '0'; turnL <= '1'; backw <= '0'; forw <= '0';
                    duty_1 <= X"0070"; duty_2 <= X"0070";


                when "111" =>
                    backw <= '1'; forw <= '0'; turnR <= '0'; turnL <= '0';
                    duty_1 <= X"0070"; duty_2 <= X"0070";

        end case;
        else
        forw <= '0'; backw <= '0'; turnR <= '0'; turnL <= '0';
        duty_1 <= X"0000"; duty_2 <= X"0000";
        memory_element<="000";
        lock<='0';
        end if;
    end if;
    end process;
LED(2)<= not(ultrasonic(2));
LED(1)<= not(ultrasonic(1));
LED(0)<= not(ultrasonic(0));
Pled <= Photo;
Buzz: LDR_Buzzer port map(Photo=>Photo,Buzzer=>Buzzer);
end architecture;
