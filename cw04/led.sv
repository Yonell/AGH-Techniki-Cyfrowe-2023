module led (
	in_clk, 
	in_przycisk1, 
	in_przycisk2, 
	out_led
 );
 
	// Zakładam częstotliwość zegara 10MHz
	input in_clk;
	input in_przycisk1;
	input in_przycisk2;
	output out_led;
	 
	parameter minimalny_cykl_pracy = 0.1;
	parameter rozmiar_licznika = 16;
	
	// Funckja obliczająca granicę zakładając że są one w ciągu geometrycznym
	function int oblicz_granice(int n);
		return minimalny_cykl_pracy*(((1.0/minimalny_cykl_pracy)**(1.0/3))**n)*(2**rozmiar_licznika);
	endfunction
	
	//localparam cube_root10 = 2.15443469003;
	// Stałe - po ilu cyklach zegara sygnał ma zmienić wartość
	// Okres PWM to 65 536 cykli zegara, częstotliwość 153Hz
	// parameter granica_100 = 65536;
	localparam granica_10 = oblicz_granice(2);
	localparam granica_01 = oblicz_granice(1);
	localparam granica_00 = oblicz_granice(0);
	
	initial begin
		$display("granica_00 = %0d, granica_01 = %0d, granica_10 = %0d", 
			granica_00, 
			granica_01, 
			granica_10
		);
	end
 
	// Licznik cykli zegara
	reg [rozmiar_licznika-1:0] counter = 0;
	
	// Sygnały PWM
	localparam led_11 = 1'b1; // 100% - Zawsze 1
	wire led_10;
	wire led_01;
	wire led_00;
	
	always @ (posedge in_clk)
		counter <= counter + 1;
  
	// PWM 46% 
	assign led_10 = (counter < granica_10) ? 1'b1 : 1'b0;
   
	// PWM - 22%
	assign led_01 = (counter < granica_01) ? 1'b1 : 1'b0;
   
	// PWM - 10%
	assign led_00 = (counter < granica_00) ? 1'b1 : 1'b0;
  
	// Multiplexer wybiera synał PWM według stau inprzycisk1 i in_przycisk2
	assign out_led = in_przycisk1 ? (in_przycisk2 ? led_11 : led_10) : 
									(in_przycisk2 ? led_01 : led_00);
endmodule