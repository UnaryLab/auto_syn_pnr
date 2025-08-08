module adder_clk (
    input        iClk,
    input        iRstN,
    input  [3:0] a,
    input  [3:0] b,
    input        c_in,
    output reg   c_out,        // must be reg because assigned in always block
    output reg [3:0] sum       // already correctly declared as reg
);

    always @(posedge iClk) begin
        if (~iRstN)
            {c_out, sum} <= 5'b0;
        else
            {c_out, sum} <= a + b + c_in;
    end

endmodule