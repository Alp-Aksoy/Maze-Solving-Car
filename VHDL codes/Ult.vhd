library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Ult is
    port(Echo: in std_logic;
         clk: in std_logic;
         Trigger: out std_logic;
         Wall: out std_logic);

end entity;

architecture structure of Ult is


component trigger_module is
    port(clk: in std_logic;
         Trigger_out: out std_logic);
end component;
component Counter is
generic(n: positive:= 10);
    port(clk: in std_logic;
         enable: in std_logic;
         Reset: in std_logic;
         Q: out std_logic_vector(n-1 downto 0));
end component;
signal pulse_width: std_logic_vector(21 downto 0); 
signal trigg:std_logic; 
begin 
c :Counter generic map(22) port map(clk=>clk,enable=>Echo,Reset=>trigg,Q=>pulse_width); 
trigger_generation : Trigger_module port map(clk=>clk,Trigger_out=>trigg); 
Wall_detection: process(pulse_width) begin 
           if(pulse_width < 203000) then --35cm
                Wall <= '1';
           else
                Wall <= '0';
           end if;
     end process;
     Trigger <= trigg;
end architecture;
