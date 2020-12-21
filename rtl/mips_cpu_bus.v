module mips_cpu_bus(
  input logic clk,
  input logic reset,
  output logic active,
  output logic [31:0] register_v0,

  output logic[31:0] address,
  output logic write,
  output logic read,
  input logic waitrequest,
  output logic [31:0] writedata,
  output logic [3:0] byteenable,
  input logic [31:0] readdata

  );
   logic altclk;
   logic altwaitrequest;
   logic altactive;
   logic altreset;
   logic [31:0] altreaddata;
   logic [3:0] state;
   assign altwaitrequest = 0;
   assign altclk = (clk && (!waitrequest));


   always_ff @(posedge clk) begin
   if (reset == 1)
   active <= 1;
   else if (state == 4'b0101)
   active <=0;
   else
   active <= active;
   end


   always_ff @(negedge altclk) begin
   if( reset == 1 )
   altreset <= 1;
   else
   altreset <= 0;
   end

  // always_ff @(negedge altclk) begin
   //altreaddata <= readdata;
   //end

  //always_comb begin
  // if (waitrequest == 1 )
  // altreaddata = altreaddata;
  // else
  // altreaddata = readdata;
//   end

   mips_cpu_bus_alt mips_cpu_bus_a(
   .clk (altclk),
   .reset (altreset),
   .active (altactive),
   .register_v0 (register_v0),
   .address (address),
   .write (write),
   .read (read),
   .waitrequest (altwaitrequest),
   .writedata (writedata),
   .byteenable (byteenable),
   .readdata (readdata),
   .state (state)
   );

endmodule
