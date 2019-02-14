library ieee;
use ieee.std_logic_1164.ALL;

entity practica2 is 
	-- port (a,b: in std_logic; o: OUT std_logic);
	-- Creacion de vectores
	port(v: in std_logic_vector(1 downto 0); 
			f: out std_logic);
	
end practica2;


architecture arq_p2 of practica2 is
	begin
		with v select 
			f <=  '0' when "00",
				   '0' when "01",
					'0' when "10",
					'1' when others;
end architecture arq_p2;
	