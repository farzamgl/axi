// Copyright (c) 2020 ETH Zurich, University of Bologna
// All rights reserved.
//
// This code is under development and not yet released to the public.
// Until it is released, the code is under the copyright of ETH Zurich and
// the University of Bologna, and may contain confidential and/or unpublished
// work. Any reuse/redistribution is strictly forbidden without written
// permission from ETH Zurich.
//
// Thomas Benz <tbenz@ethz.ch>

// transaction id generator. just increase the transaction id on every request

module transfer_id_gen #(
    parameter int unsigned  ID_WIDTH  = -1
) (
    input  logic                clk_i,
    input  logic                rst_ni,
    // new request is pushed
    input  logic                issue_i,
    // request is popped
    input  logic                retire_i,
    // next id is
    output logic [ID_WIDTH-1:0] next_o,
    // last id completed is
    output logic [ID_WIDTH-1:0] completed_o
);

    //--------------------------------------
    // counters
    //-------------------------------------- 
    logic [ID_WIDTH-1:0] next_d,      next_q;
    logic [ID_WIDTH-1:0] completed_d, completed_q;

    // count up on events
    assign next_d      = (issue_i  == 1'b1) ? next_q + 'h1      : next_q;
    assign completed_d = (retire_i == 1'b1) ? completed_q + 'h1 : completed_q;

    // assign outputs
    assign next_o      = next_q;
    assign completed_o = completed_q;

    //--------------------------------------
    // state
    //-------------------------------------- 
    always_ff @(posedge clk_i or negedge rst_ni) begin : proc_id_gen
        if(~rst_ni) begin
            next_q      <= 1;
            completed_q <= 0;
        end else begin
            next_q      <= next_d;
            completed_q <= completed_d;
        end
    end

endmodule : transfer_id_gen

