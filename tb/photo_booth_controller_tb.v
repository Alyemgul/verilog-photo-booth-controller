`timescale 1ns/1ps

module photo_booth_controller_tb;

    reg clk;
    reg rst;
    reg start;
    reg confirm;
    reg retake;

    wire countdown_active;
    wire capture;
    wire preview;
    wire save;

    photo_booth_controller dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .confirm(confirm),
        .retake(retake),
        .countdown_active(countdown_active),
        .capture(capture),
        .preview(preview),
        .save(save)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, photo_booth_controller_tb);
    end

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        confirm = 0;
        retake = 0;

        // Reset
        #12 rst = 0;

        // Test 1: Start -> countdown -> capture -> preview -> save
        #10 start = 1;
        #10 start = 0;

        // Wait until preview, then confirm
        #40 confirm = 1;
        #10 confirm = 0;

        // Test 2: Start -> countdown -> capture -> preview -> retake
        #20 start = 1;
        #10 start = 0;

        // Wait until preview, then retake
        #40 retake = 1;
        #10 retake = 0;

        // After retake, countdown happens again, then confirm save
        #40 confirm = 1;
        #10 confirm = 0;

        #40 $finish;
    end

    initial begin
        $monitor("T=%0t rst=%b start=%b confirm=%b retake=%b state=%b countdown=%b capture=%b preview=%b save=%b",
                 $time, rst, start, confirm, retake, dut.state,
                 countdown_active, capture, preview, save);
    end

endmodule