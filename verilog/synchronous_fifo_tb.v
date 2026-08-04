module sync_fifo_tb;

  reg clk;
  reg reset;
  reg w_en;
  reg r_en;
  reg [7:0] w_data;

  wire [7:0] r_data;
  wire full;
  wire empty;
  wire overflow;
  wire underflow;

  sync_fifo uut(
    .clk(clk),
    .reset(reset),
    .w_en(w_en),
    .r_en(r_en),
    .w_data(w_data),
    .r_data(r_data),
    .full(full),
    .empty(empty),
    .overflow(overflow),
    .underflow(underflow)
  );

 
  initial clk = 0;
  always #10 clk = ~clk;


  initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0,sync_fifo_tb);

    reset = 1;
    w_en = 0;
    r_en = 0;
    w_data = 0;

    #50;
    reset = 0;
    
    w_en=1;
    for(int i=1; i<=10; ++i) begin
      @(posedge clk);
      w_data=i;
    end
    
    @(posedge clk);
    w_en=0;
    #40;

    r_en=1;
    for(int i=1; i<=10; ++i) begin
      @(posedge clk);
    end

    @(posedge clk);
    r_en=0;
    #40;
    
    ////////////////////////////////////////////////////////
    
        w_en=1;
    for(int i=1; i<=4; ++i) begin
      @(posedge clk);
      w_data=i;
    end
    w_en=0;
    #1;
            r_en=1;
    for(int i=1; i<=2; ++i) begin
      @(posedge clk);
    end
    r_en=0;
    #20;
    
            w_en=1;
    for(int i=1; i<=6; ++i) begin
      @(posedge clk);
      w_data=i;
    end
    w_en=0;
    #1;
    
                r_en=1;
    for(int i=1; i<=8; ++i) begin
      @(posedge clk);
    end
    r_en=0;
    #20;
    
    
    $finish;

  end

endmodule
