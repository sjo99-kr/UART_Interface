`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 01:34:18 PM
// Design Name: 
// Module Name: UART_Tx
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


module UART_Tx#(    parameter data_width = 8)(

        // input port
        input i_clk,
        input i_rst,
        
        // slave port 
        input [data_width-1:0] s_axis_data,
        input s_axis_valid,
        output s_axis_ready,
        
        // enable signal based on baud_rate
        input baud_en,
        
        // output to UART_Rx
        output Tx_data
    );
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter TRANSFER = 2'b10;
    parameter END = 2'b11;
    
    reg [data_width-1:0] data_reg;
    reg Tx_data_reg;
    reg busy;
    reg [1:0] state;
    reg [3:0] bit_cnt;
    assign Tx_data = Tx_data_reg;
    assign s_axis_ready = (baud_en && !busy);
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            busy <= 0;
            Tx_data_reg <= 1;
            data_reg <= 0;
            bit_cnt <= 0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE : begin
                    if(s_axis_valid) begin
                        busy <= 1;
                        data_reg <= s_axis_data;
                        bit_cnt <= 7;
                        state <= START;
                    end
                end
                START : begin
                    if(baud_en)begin
                        Tx_data_reg <= 0;
                        state <= TRANSFER;
                    end
                end
                TRANSFER : begin
                    if(baud_en)begin
                        Tx_data_reg <= data_reg[7-bit_cnt];
                        bit_cnt <= bit_cnt - 1;
                        if(bit_cnt == 0)begin
                            state <= END;
                        end
                    end
                end
                END : begin
                    if(baud_en)begin
                        Tx_data_reg <= 1;
                        state <= IDLE;
                        bit_cnt <= 0;
                        busy <= 0;
                        data_reg <= 0;
                    end
                end
            endcase 
        end
    end
    
    
endmodule
