`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 03:48:22 PM
// Design Name: 
// Module Name: UART_Rx
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


module UART_Rx#(parameter data_width = 8)(
        
        input i_clk,
        input i_rst,
        
        input Rx_data,
        
        // master port 
        output [data_width-1:0] m_axis_data,
        output m_axis_valid,
        input m_axis_ready,
        
        input baud_en
    );
    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter TRANSFER = 2'b10;
    parameter END = 2'b11;
  
    assign m_axis_data = data_reg;
    assign m_axis_valid = valid;
  
    reg valid;
    reg [1:0] state;
    reg busy;
    reg [data_width - 1: 0] data_reg;
    reg [3:0] bit_cnt; 
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            state <= 2'b00;
            busy <= 0;
            data_reg <= 0;
            bit_cnt <= 0;
            valid <= 0;
        end
        else begin
            case(state) 
                IDLE : begin
                    if(baud_en)begin
                        if(Rx_data == 0)begin // transfer start bit == 0;
                            state <= RECEIVE;
                            busy <= 1; 
                            valid <= 0;
                        end
                    end
                end
                RECEIVE : begin
                    if(baud_en)begin
                        data_reg[bit_cnt] <= Rx_data;
                        bit_cnt <= bit_cnt + 1;
                        if(bit_cnt == 7)begin
                            state <= TRANSFER;
                        end
                    end
                end
                TRANSFER : begin
                    valid <= 1;
                    state<= END;
                end
                END : begin
                    valid <= 0;
                    state <= IDLE;
                    data_reg <= 0;
                    bit_cnt <= 0;
                    busy <= 0;
                end
            endcase
        end
    end


endmodule
