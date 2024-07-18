`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 04:11:32 PM
// Design Name: 
// Module Name: UART_INTERFACE
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


module UART_INTERFACE#(parameter data_width = 8 )(
    input i_clk,
    input i_rst,
    
    
    // slave port AXI
    input [data_width - 1 : 0] s_axis_data,
    input                      s_axis_valid,
    output                     s_axis_ready,
    
    // master port AXI
    output [data_width - 1: 0] m_axis_data,
    output                     m_axis_valid,
    input                      m_axis_ready
    );
    
    wire baud_rate;
    wire uart_data;
    
    baud_rate_gen generator(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .baud_en(baud_rate)
    );
    
    UART_Tx Tx(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .s_axis_data(s_axis_data),
        .s_axis_valid(s_axis_valid),
        .baud_en(baud_rate),
        .Tx_data(uart_data)
    );
    
    UART_Rx Rx(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .Rx_data(uart_data),
        .m_axis_data(m_axis_data),
        .m_axis_valid(m_axis_valid),
        .m_axis_ready(m_axis_ready),
        .baud_en(baud_rate)
    );
    
endmodule
