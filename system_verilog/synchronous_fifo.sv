module sync_fifo #(
	parameter int WIDTH=8,
  	parameter int DEPTH=8
)(
  input logic clk,reset,w_en,r_en,
  input logic [WIDTH-1:0] w_data,
  output logic [WIDTH-1:0] r_data,
  output logic full,empty,overflow,underflow
);
  
  localparam int N_WIDTH = $clog2(DEPTH);
  
	logic [WIDTH-1:0] fifo_ram [DEPTH-1:0];   
    logic [N_WIDTH-1:0] w_ptr, r_ptr;
    logic [N_WIDTH:0]   fifo_count;
  
  always_ff @(posedge clk or posedge reset) begin
    
    if(reset) begin
      w_ptr<=0;
      r_ptr<=0;
      r_data<=0;
      fifo_count<=0;
      overflow<=0;
      underflow<=0;
    end
    else begin
      if(w_en && !full) begin
        fifo_ram[w_ptr]<=w_data;
        w_ptr<=w_ptr+1;
      end
      
      if(r_en && !empty) begin
        r_data<=fifo_ram[r_ptr];
        r_ptr<=r_ptr+1;
      end  
      
      if(w_en && full) overflow<=1;
      else overflow<=0;
      
      if(r_en && empty) underflow<=1;
      else underflow<=0;
      
      case ({w_en && !full, r_en && !empty})

        2'b10: fifo_count <= fifo_count + 1;
        2'b01: fifo_count <= fifo_count - 1;
        2'b11: fifo_count <= fifo_count;
        default: ;
      endcase
      
    end
  end
  
  
  assign empty=(fifo_count==0);
  assign full=(fifo_count==DEPTH);
  
endmodule
