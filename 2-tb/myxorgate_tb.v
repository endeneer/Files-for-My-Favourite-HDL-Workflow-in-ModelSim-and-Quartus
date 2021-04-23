`timescale  1ns/1ps
module myxorgate_tb();
    reg        i_A, i_B, o_C_expected;  //testvectors values
    wire       o_C;                     //circuit output     
    reg        clk;                     //internal variables
    reg [2:0]  vectornum, errors;       //bookkeeping variables, make sure extra bit to allow increment into xxx
    reg [2:0]  testvectors[4:0];        //testvectors array, make sure extra bit to allow xxx

    myxorgate dut(i_A, i_B, o_C);

    //generate clock with period #10
    always begin
        clk = 1; #5; clk=0; #5;
    end

    //load vectors and initialize bookkeeping variables
    initial begin
        $readmemb("../2-tb/myxorgate.tv", testvectors); //path WRT modelsim project
        vectornum = 0; errors = 0;
    end

    //apply test vectors on rising edge
    always @(posedge clk) begin
        {i_A, i_B, o_C_expected} = testvectors[vectornum];
    end

    //check results on falling edge
    always @(negedge clk) begin
        if (o_C !== o_C_expected) begin
            $display("Error: inputs=%b", {i_A, i_B});
            $display(" outputs=%b (%b expected)", o_C, o_C_expected);
            errors=errors+1;
        end
        vectornum = vectornum + 1;
        if (testvectors[vectornum] === 3'bx) begin
            $display("%2d tests completed with %2d errors",
                        vectornum, errors);
            $finish;
        end
    end

    //print out in transcript window
    initial begin
        $monitor("Time=%3dns, i_A=%b, i_B=%b, o_C=%b", $time, i_A, i_B, o_C);
    end
endmodule
