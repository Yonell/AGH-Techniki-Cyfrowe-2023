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
  
  // Stałe - po ilu cyklach zegara sygnał ma zmienić wartość
  // Okres PWM to 65 536 cykli zegara, częstotliwość 153Hz
  // parameter granica_100 = 65536;
  parameter granica_46  = 30419;
  parameter granica_22  = 14119;
  parameter granica_10   = 6554;
 
  // Liczniki cykli zegara
  reg [15:0] counter_46 = 0;
  reg [15:0] counter_22 = 0;
  reg [15:0] counter_10 = 0;
  
  // Wartości PWM
  reg        led_100 = 1'b1; // 100% - Zawsze 1
  reg        led_46  = 1'b0;
  reg        led_22  = 1'b0;
  reg        led_10   = 1'b0;
  
  // PWM 46% 
  always @ (posedge in_clk)
    begin
      if(counter_46 == granica_46)
			led_46 <= 1'b0;
      else if(counter_46 == 16'h0000)
			led_46 <= 1'b1;
		
      counter_46 <= counter_46 + 1;
    end
	 
	// PWM - 22%
	always @ (posedge in_clk)
    begin
      if(counter_22 == granica_22)
			led_22 <= 1'b0;
      else if(counter_46 == 16'h0000)
			led_22 <= 1'b1;
		
      counter_22 <= counter_22 + 1;
    end
	 
	 // PWM - 10%
	 always @ (posedge in_clk)
    begin
      if(counter_10 == granica_10)
			led_10 <= 1'b0;
      else if(counter_46 == 16'h0000)
			led_10 <= 1'b1;
		
      counter_10 <= counter_10 + 1;
    end
	
  // Multiplexer wybiera synał PWM według stau inprzycisk1 i in_przycisk2
  assign out_led = in_przycisk1 ? (in_przycisk2 ? led_100 : led_46) : (in_przycisk2 ? led_22 : led_10);
endmodule