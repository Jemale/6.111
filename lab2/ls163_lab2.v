`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:51 09/18/2013 
// Design Name: 
// Module Name:    ls163_lab2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ls163_lab2(
    input clk,
    input ent,
    input enp,
    input load,
    input clear,
    input a,
    input b,
    input c,
    input d,
    output qa,
    output qb,
    output qc,
    output qd,
    output rco
    );
   

always @(posedge clk) begin //count on the rising clock edge
  if (!clear) begin
    {qd, qc, qb, qa} <= 4'b0; //if clear, set count to 0
  end
  
  if (clear && !load) begin  //if load asserted low, set output to input
    {qd, qc, qb, qa} <= {d,c,b,a};
  end
  
  if (clear && load && enp && ent) begin  //if ent and enp, increment count
    {qd, qc, qb, qa} <= {qd, qc, qb, qa} + 1;
    
  end
      
end


assign rco = ent ? qa && qb && qc && qd : 0; //only set rco when ent asserted


endmodule