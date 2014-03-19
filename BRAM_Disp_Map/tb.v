`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:23:52 03/18/2014 
// Design Name: 
// Module Name:    tb 
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
module tb(
    );

	 reg clk;
    wire rst;
    wire ren_fifo;
    wire [31:0] din_fifo;
    wire empty_fifo;
    wire [10:0] rd_data_count_fifo;
    wire wr_en_bram;
    wire wr_clk_bram;
    wire [3:0] we_bram;
    wire [31:0] addr_bram;
    wire [31:0] din_bram;
    wire busy;
	 
	 always
		#5 clk = ~clk;
		
		
	reg fake_data_sel;
	reg fake_en;
	reg [31:0] fake_data;
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			fake_en <=0;
			fake_data_sel <= 0;
			fake_data <= 0;
		end
		else
		begin
			fake_data_sel <= ~fake_data_sel;
			fake_en <= fake_data_sel;
			fake_data <= fake_data + 1;
		end
	end
		
	px_in_fifo px_in_fifo_inst (
	  .rst(rst),
		.wr_clk(clk),
	.rd_clk(clk),
	.din(fake_data),
	.wr_en(fake_en),
	.rd_en(ren_fifo),
	.dout(din_fifo),
	.full(),
	.empty(empty_fifo),
	.rd_data_count(rd_data_count_fifo),
	.wr_data_count()
	);
		
	bram my_bram (
  .clka(clk), // input clka
  .ena(wr_en_bram), // input ena
  .wea(we_bram), // input [3 : 0] wea
  .addra(addr_bram), // input [31 : 0] addra
  .dina(din_bram), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(), // input clkb
  .enb(), // input enb
  .web(), // input [3 : 0] web
  .addrb(), // input [31 : 0] addrb
  .dinb(), // input [31 : 0] dinb
  .doutb() // output [31 : 0] doutb
);

	load_bram load_bram_inst (
		    .clk(clk),
    .rst(rst),
    .ren_fifo(ren_fifo),
    .din_fifo(din_fifo),
    .empty_fifo(empty_fifo),
    .rd_data_count_fifo(rd_data_count_fifo),
    .wr_en_bram(wr_en_bram),
    .wr_clk_bram(wr_clk_bram),
    .we_bram(we_bram),
    .addr_bram(addr_bram),
    .din_bram(din_bram),
    .busy(busy)
	);

endmodule
