`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 12:57:27 PM
// Design Name: 
// Module Name: baud_rate_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baud_rate_gen#(parameter clk_hz =100000000, // 100Mhz 
                      parameter baud_rate = 9600 //baud rate 9600
        ) (
            input i_clk,
            input i_rst,
            output baud_en
    );
    parameter baud_limit = clk_hz / baud_rate - 1;
    
    reg baud_en_reg = 0;
    reg  [26:0] count; //
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            count <= 0;
        end
        else begin
            count <= count + 1;
            
            if(count == clk_hz - 1)begin
                count <= 0;
            end
        end
    end
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            baud_en_reg <= 0;
        end
        else begin
            if(count % baud_limit == 0)begin
                baud_en_reg <= 1;
            end
            else begin
                baud_en_reg <= 0;
            end
        end
    end
    
    assign baud_en = baud_en_reg;    
endmodule
