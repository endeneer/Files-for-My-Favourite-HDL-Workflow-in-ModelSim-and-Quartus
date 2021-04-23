`timescale  1ns/1ps
module myxorgate_tb();
    reg        i_A, i_B, o_C_expected;  //testvectors values
    wire       o_C;                     //circuit output     
    reg        clk, reset;              //internal variables
    reg [31:0] vectornum, errors;       //bookkeeping variables
    reg [2:0]  testvectors[7:0];       //testvectors array

    myxorgate dut(i_A, i_B, o_C);

    //generate clock with period #10
    always begin
        clk = 1; #5; clk=0; #5;
    end

    //load vectors and initialize bookkeeping variables
    // hold then release reset initially
    initial begin
        $readmemb("../2-tb/myxorgate.tv", testvectors); //path WRT modelsim project not this tb
        vectornum = 0; errors = 0;
        reset = 1; #17; reset = 0; //let's give 2 cycles of reset time
    end

    //apply test vectors on rising edge
    always @(posedge clk) begin
        #1; {i_A, i_B, o_C_expected} = testvectors[vectornum];
    end

    //check results on falling edge
    always @(negedge clk)
        if (~reset) begin
            if (o_C !== o_C_expected) begin
                $display("Error: inputs=%b", {i_A, i_B});
                $display(" outputs=%b (%b expected)", o_C, o_C_expected);
                errors=errors+1;
            end
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 3'bx) begin
                $display("%d test completed with %d errors",
                         vectornum, errors);
                $finish;
            end
        end

    initial begin
        $monitor("Time=%3dns, i_A=%b, i_B=%b, o_C=%b", $time, i_A, i_B, o_C);
        $dumpfile("myxorgate.vcd");
        $dumpvars(0, myxorgate_tb);
    end

    // initial begin
    //         i_A = 0; i_B = 0;
    //     #10 i_A = 0; i_B = 1;
    //     #10 i_A = 1; i_B = 0;
    //     #10 i_A = 1; i_B = 1;  
    //     #10 ;
    // end
endmodule
