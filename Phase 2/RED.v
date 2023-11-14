module RED (
    input [15:0]a,
    input [15:0]b,
    output [15:0]sum
    );
    

    wire [8:0] ac;
    wire ca;
    wire ca1;

    wire [8:0]bd;
    wire cb;
    wire cb1;

    wire cab30;
    wire cab74;

    wire [3:0]temp;

    // sum a
    addsub_4bit U_CLA4_00(
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(bd[3:0]),
        .cout(ca),
        .ovfl(),
        .gen(),
        .prop()
        );

    addsub_4bit U_CLA4_01(
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(ca),
        .sum(bd[7:4]),
        .cout(ca1),
        .ovfl(),
        .gen(),
        .prop()
        );
    
    assign bd[8] = a[7] ^ a[15] ^ ca1;

    // sum b
    addsub_4bit U_CLA4_02(
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(ac[3:0]),
        .cout(cb),
        .ovfl(),
        .gen(),
        .prop()
        );

    addsub_4bit U_CLA4_03(
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(cb),
        .sum(ac[7:4]),
        .cout(cb1),
        .ovfl(),
        .gen(),
        .prop()
        );

    assign ac[8] = b[7] ^ b[15] ^ cb1;

    // suma + sumb
    addsub_4bit U_CLA4_10(
        .a(bd[3:0]),
        .b(ac[3:0]),
        .cin(1'b0),
        .sum(sum[3:0]),
        .cout(cab30),
        .ovfl(),
        .gen(),
        .prop()
        );

    addsub_4bit U_CLA4_11(
        .a(bd[7:4]),
        .b(ac[7:4]),
        .cin(cab30),
        .sum(sum[7:4]),
        .cout(cab74),
        .ovfl(),
        .gen(),
        .prop()
        );

    addsub_4bit U_CLA4_12(
        .a({4{bd[8]}}),
        .b({4{ac[8]}}),
        .cin(cab74),
        .sum(temp),
        .cout(),
        .ovfl(),
        .gen(),
        .prop()
        );

    assign sum[8] = temp[0];
    assign sum[15:9] = {7{temp[1]}};

endmodule
