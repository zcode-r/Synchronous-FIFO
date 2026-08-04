module sync_fifo_tb;

    logic clk = 0;
    always #10 clk = ~clk; 

    sync_fifo_if #( .WIDTH(8) ) vif (clk);

    sync_fifo #(
        .WIDTH(8),
        .DEPTH(8)
    ) uut (
        .clk       (vif.clk),
        .reset     (vif.reset),
        .w_en      (vif.w_en),
        .r_en      (vif.r_en),
        .w_data    (vif.w_data),
        .r_data    (vif.r_data),
        .full      (vif.full),
        .empty     (vif.empty),
        .overflow  (vif.overflow),
        .underflow (vif.underflow)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, sync_fifo_tb);

        reset_dut();

        $display("\n--- TEST 1: WRITING 10 BYTES (Testing Overflow) ---");
        for (int i = 1; i <= 10; i++) begin
            write_byte(i);
        end
        
        $display("\n--- TEST 2: READING 10 BYTES (Testing Underflow) ---");
        for (int i = 1; i <= 10; i++) begin
            read_byte();
        end

        $display("\n--- TEST 3: MIXED READ/WRITE OPERATIONS ---");
        // Write 4 items
        for (int i = 1; i <= 4; i++) write_byte(10 + i);
        // Read 2 items
        for (int i = 1; i <= 2; i++) read_byte();
        // Write 6 items
        for (int i = 1; i <= 6; i++) write_byte(20 + i);
        // Read 8 items
        for (int i = 1; i <= 8; i++) read_byte();

        repeat(5) @(posedge clk);
        $display("\n====================================");
        $display("   ALL SIMULATION TESTS COMPLETED   ");
        $display("====================================\n");
        $finish;
    end

    // =========================================================
    // VERIFICATION TASKS (Clock-Synchronized & Reusable)
    // =========================================================

    task reset_dut();
        vif.reset  <= 1'b1;
        vif.w_en   <= 1'b0;
        vif.r_en   <= 1'b0;
        vif.w_data <= '0;
        
        repeat(3) @(posedge clk);
        vif.reset  <= 1'b0;
        repeat(2) @(posedge clk);
        $display("[TB] Hardware Reset Complete.");
    endtask

    task write_byte(input logic [7:0] data);
        @(posedge clk);
        vif.w_en   <= 1'b1;
        vif.w_data <= data;
        
        @(posedge clk);
        vif.w_en   <= 1'b0; 
        
        if (vif.full) begin
            $display("[WARN] Write attempt to FULL FIFO! Data: 0x%h, Overflow: %b", data, vif.overflow);
        end else begin
            $display("[WRITE] Pushed Data: 0x%h | Full: %b, Empty: %b", data, vif.full, vif.empty);
        end
    endtask

    task read_byte();
        @(posedge clk);
        vif.r_en <= 1'b1;
        
        @(posedge clk);
        vif.r_en <= 1'b0; 
        
        if (vif.empty) begin
            $display("[WARN] Read attempt from EMPTY FIFO! Underflow: %b", vif.underflow);
        end else begin
            $display("[READ]  Popped Data: 0x%h | Full: %b, Empty: %b", vif.r_data, vif.full, vif.empty);
        end
    endtask

endmodule
