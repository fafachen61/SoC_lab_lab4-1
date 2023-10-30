// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32,
    parameter DELAYS=10
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire wbs_ack_o;
    wire [31:0] wbs_dat_o;
    wire [127:0] la_data_out;
    wire [2:0] irq;

    reg wbs_ack_o_r, wbs_ack_o_w;
    reg [31:0] wbs_dat_o_r, wbs_dat_o_w;
    reg [127:0] la_data_out_r, la_data_out_w;
    reg [2:0] irq_r, irq_w;
    reg [`MPRJ_IO_PADS-1:0] io_out_r, io_out_w;
    reg [`MPRJ_IO_PADS-1:0] io_oeb_r, io_oeb_w;

    // BRAM interface
    wire [3:0] bram_WE0;
    wire [31:0] bram_Di0, bram_Do0, bram_A0;
    wire bram_EN0;
    assign bram_EN0 = 1;
    assign bram_WE0 = 4'b1111;
    assign wbs_ack_o = wbs_ack_o_r;
    assign wbs_dat_o = wbs_dat_o_r;
    assign io_out = io_out_r;
    assign io_oeb = io_oeb_r;
    assign irq = irq_r;
    assign la_data_out=la_data_out_r;
    // assign wbs_dat_o[31:16] = 16'hAB40;

    always @(posedge wb_clk_i) begin
        if(wb_rst_i) begin
            wbs_ack_o_r <= 0;
            wbs_dat_o_r <= 0;
            la_data_out_r <= 0;
            irq_r <= 0;
            io_out_r <= 0;
            io_oeb_r <= 0;
        end
        else begin
            wbs_ack_o_r <= 1;
            wbs_dat_o_r <= 57;
            la_data_out_r <= 56;
            irq_r <= 3'b000;
            io_out_r <= 97;
            io_oeb_r <= 1;
        end
    end

    bram user_bram (
        .CLK(wb_clk_i),
        .WE0(wbs_we_i),
        .EN0(bram_EN0),
        .Di0(bram_Di0),
        .Do0(bram_Do0),
        .A0(wbs_adr_i)
    );

endmodule



`default_nettype wire
