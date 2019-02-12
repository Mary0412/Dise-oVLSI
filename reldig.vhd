----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:31:09 02/06/2019 
-- Design Name: 
-- Module Name:    reldig - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reldig is
    Port ( reloj : in  STD_LOGIC;
           AN : out  STD_LOGIC_VECTOR (3 downto 0);
           L : out  STD_LOGIC_VECTOR (6 downto 0);
	 alarma: out STD_LOGIC;
	apagado: out STD_LOGIC);
end reldig;

architecture Behavioral of reldig is

	signal segundo : std_logic; 
	signal rapido: std_logic;
	signal n : std_logic;
	signal Qs: std_logic_vector(3 downto 0);
	signal Qum: std_logic_vector(3 downto 0);
	signal Qdm: std_logic_vector(3 downto 0);
	signal e: std_logic;
	signal Qr: std_logic_vector(1 downto 0);
	signal Quh: std_logic_vector(3 downto 0);
	signal Qdh: std_logic_vector(3 downto 0);
	signal z: std_logic;
	signal u: std_logic;
	signal d: std_logic;
	signal reset: std_logic;

begin

	divisor : process (reloj)
		variable CUENTA: STD_LOGIC_VECTOR(27 downto 0) := x"0000000";
	begin
		if rising_edge (reloj) then
			if CUENTA =X"48009E0" then
				CUENTA := x"0000000";
			else
				CUENTA := CUENTA +1;
			end if;
		end if;
		segundo <= CUENTA(22);
		rapido <= CUENTA(10);
	end process;
	
	UNIDADES: process (segundo)
		variable CUENTA: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	begin
		if rising_edge (segundo) then
			if CUENTA ="1001" then
				CUENTA :="0000";
				N <= '1';
			else
				CUENTA := CUENTA +1;
				N <= '0';
			end if;
		end if;
		Qum <= CUENTA;
	end process;
	
	DECENAS: process (N)
		variable CUENTA: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	begin
		if rising_edge (N) then
			if CUENTA ="0101" then
				CUENTA :="0000";
				E <= '1';
			else
				CUENTA := CUENTA +1;
				E <= '0';
			end if;
		end if;
		Qdm <= CUENTA;
 end process;
 
	HoraU: Process(E,reset)
		variable cuenta: std_logic_vector(3 downto 0):="0000";
	begin
		if rising_edge(E) then
			if cuenta="1001" then
				cuenta:= "0000";
				Z<='1';
			else
				cuenta:=cuenta+1;
				Z<='0';
			end if;
		end if;
		if reset='1' then
			cuenta:="0000";
		end if;
		Quh<=cuenta;
		U<=cuenta(2);
 end Process;
 
	HORAD: Process(Z, reset)
		variable cuenta: std_logic_vector(3 downto 0):="0000";
 begin
		if rising_edge(Z) then
			if cuenta="0010" then
				cuenta:= "0000";
			else
				cuenta:=cuenta+1;
			end if;
		end if;
		if reset='1' then
			cuenta:="0000";
		end if;
		Qdh<=cuenta;
		D <=cuenta(1);
		
 end Process;

	inicia: process (U,D)
		begin
			reset <= (U and D);
		end process;
		
		CONTRAPID: process (rapido)
				variable CUENTA: STD_LOGIC_VECTOR(1 downto 0) := "00";
		begin
			if rising_edge (rapido) then
				CUENTA := CUENTA +1;
			end if;
			Qr <= CUENTA;
		end process;
		
		MUXY: PROCESS (Qr)
		BEGIN
			if Qr = "00" then
				Qs<= Qum;
			elsif Qr = "01" then
				Qs<= Qdm;
			elsif Qr = "10" then
				Qs<= Quh;
			elsif Qr = "11" then
				Qs<= Qdh;
			end if;
		end process;
		
 seledisplay: process (Qr)
 BEGIN
	case Qr is
		when "00" =>
			AN<= "1110";
		when "01" =>
			AN<= "1101";
		when "10" =>
			AN<= "1011";
		when others =>
			AN<= "0111";
	end case;
 end process;
 
 with Qs SELECT
	L <= "1000000" when "0000", --0
		"1111001" when "0001", --1
		"0100100" when "0010", --2
		"0110000" when "0011", --3
		"0011001" when "0100", --4
		"0010010" when "0101", --5
		"0000010" when "0110", --6
		"1111000" when "0111", --7
		"0000000" when "1000", --8
		"0010000" when "1001", --9
		"1000000" when others; --F
	if (Qum ="0000" and Qdm="0000" and Quh="0001" and Qdh="000") then
		alarma <='1';
		apagado<='0';
	end if;
	
	if (apagado='1')then
		alarma<='0';
	end if;

end Behavioral;

