`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:29:50 03/18/2014 
// Design Name: 
// Module Name:    load_bram 
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
module load_bram(
    input clk,
    input rst,
    output reg ren_fifo,
    input [31:0] din_fifo,
    input empty_fifo,
    input [10:0] rd_data_count_fifo,
    output reg wr_en_bram,
    output wr_clk_bram,
    output reg [3:0] we_bram,
    output reg [31:0] addr_bram,
    output reg [31:0] din_bram,
    output busy
    );
	 
	 assign busy = 1'b0;
	 
	 wire [15:0]din_bram_hi;
	 wire [15:0]din_bram_low;
	 
	 wire din_bram_low_red;
	 wire din_bram_low_blue;
	 wire din_bram_low_green;

	 wire din_bram_low_add;
	
	 wire din_bram_low_grey;
	 wire din_bram_hi_red;
	 wire din_bram_hi_blue;
	 wire din_bram_hi_green;

	 wire din_bram_hi_add;
	
	 wire din_bram_hi_grey;
	 
//	 reg [31:0]din_bram;
//	 reg wr_en_bram;
//	 reg [3:0]we_bram;
//	 reg [31:0]addr_bram;
	 
	 assign wr_clk_bram = clk;
	 
	 	
	assign din_bram_low_red = (((din_bram[15:0] & 32'hf800) >> 11) << 3);
	assign din_bram_low_blue = (((din_bram[15:0] & 32'h07e0) >> 5) << 2);
	assign din_bram_low_green = ((din_bram[15:0] & 32'h001f) << 3);

	assign din_bram_low_add = din_bram_low_red + din_bram_low_blue + din_bram_low_green;
	
	assign din_bram_low_grey = din_bram_low_add / 3;
	
	assign din_bram_hi_red = (((din_bram[15:0] & 32'hf800) >> 11) << 3);
	assign din_bram_hi_blue = (((din_bram[15:0] & 32'h07e0) >> 5) << 2);
	assign din_bram_hi_green = ((din_bram[15:0] & 32'h001f) << 3);

	assign din_bram_hi_add = din_bram_hi_red + din_bram_hi_blue + din_bram_hi_green;
	
	assign din_bram_hi_grey = din_bram_hi_add / 3;

	always @ (posedge clk)
	begin
		begin
			if(~empty_fifo)
			begin
				ren_fifo <= 1'b1;
			end
			else
			begin
				ren_fifo <= 1'b0;
			end
		end
	end
	
	always @ (posedge clk)
	begin
		if(rst)
		begin
			din_bram <= 32'h0;
			we_bram <= 4'hf;
			wr_en_bram <= 1'b0;
			addr_bram <= 32'h0;
		end
		else
		begin
			if(wr_en_bram)
			begin
				din_bram <= din_bram_hi_grey;
				we_bram <= 4'hf;
				wr_en_bram <= 1'b0;
				addr_bram <= addr_bram + 1;
			end
			else
			begin
				wr_en_bram <= 1'b0;
			end
		end
	end

	
	

endmodule
