library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity testbench is
end;

architecture arc OF testbench IS
	constant not_data_at_data_clk:std_logic_vector:="000000000000000000000011010111101111100110110110011011111001101111110011011110001101101100110111100011011011110101111100110101111110101010011110000000000000000000000000000000000000000011010111110111110011011011001101111100110111110011011110001101101100011011110001101101111010111110011010111110101010011110000000000000000000000000000000000000000000000000000000001101011110111110011011011001100111110011011111001101111000110110110011011110001101101111011011111001101011111010101001111000000000000000000000000000000000000000001101011110111110011011011001101111100110111110011011110000110110110011011110001101101111010111110011010111110101010001111000000000000000000000000000000000011010111101111100110110110011011111001101111100110111100001101101100110111100011011011110101111100110101111101010100011110000000000000000000000000000000000000110101111011111001101100110011011111001101111100110111100011011011001101111000110111011110101111100110101111101010100111100000000000000000000000000000110101111011111100110110110011011111001101111100110111100011011011001100111100011011011110101111100110101111101010100111100000000000000000000000000000000000000000000001101011110111110011011011001101111100111011111001101111000110110110011011110001101101111010111110001101011111010101001111000000000000000000000000000000000000000000000000000000000001101011110111110011011011001101111100110111111001101111000110110110011011110001101101111010111110011101011111010101001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110101111011111100110110110011011111001101111100110111100011011011001100111100011011011110101111100110101111101010100111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110101111011111001101101100110111110001101111100110111100011011011001101111000110110111101011111100110101111101010100111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100101111011111001101101100110111110011011111001101111000110111011001101111000110110111101011111001101011111010101001111000000000000000000000000000000000000000000011010111101111100110110110011101111100110111110011011110001101101100110111100011011011111010111110011010111110101010011110000000000000000";
	signal data_clk:std_logic:='0'; --clk2400hz
	signal pmod_1:std_logic;
	signal clk100mhz:std_logic:='0';
	signal pmod_2:std_logic;
	signal uart_rx:std_logic;
	signal led:std_logic_vector(7 downto 0);
	signal reset:std_logic:='0';
	signal uart_tx:std_logic;
	component reciever
		port(
			clk100mhz	:in std_logic;
			reset		:in std_logic;
			uart_rx		:in std_logic;
			led			:out std_logic_vector(7 downto 0);
			uart_tx		:out std_logic;
			pmod_1		:out std_logic; -- debug outputs
			pmod_2		:out std_logic
	);
	end component;
begin
	reciever_inst:reciever
		port map(
			clk100mhz	=>clk100mhz,
			reset		=>reset,
			uart_rx		=>uart_rx,
			led			=>led,
			uart_tx		=>uart_tx,
			pmod_1		=>pmod_1,
			pmod_2		=>pmod_2
		);
	clk100mhz<=not clk100mhz after 5 ns; -- 10 ns = (1/100Mhz)/2, T(50Mhz)=20ns
	reset<='0','1' after 1 us;
	data_clk<=not data_clk after 208333 ns;
	process(data_clk,reset)
		variable counter:integer;
		begin
		if reset='0' then
			counter:=0;
			uart_rx<='0';
		elsif rising_edge(data_clk) then
			counter:=counter+1;
			if counter<not_data_at_data_clk'length then
				uart_rx<=not not_data_at_data_clk(counter);
			else
				counter:=0;
			end if;
		end if;
	end process;
end;
