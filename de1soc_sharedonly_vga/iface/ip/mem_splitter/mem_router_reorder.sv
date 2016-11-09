
module mem_router_reorder #(    
    parameter integer DATA_W = 256,                 // > 0
    parameter integer BURSTCOUNT_W = 1,             // > 0
    parameter integer ADDRESS_W = 32,               // > 0 (word address)
    parameter integer BYTEENA_W = DATA_W / 8,       // > 0

    parameter integer NUM_BANKS = 8,                // > 1
    parameter integer BANK_SEL_BIT = ADDRESS_W-$clog2(NUM_BANKS),   // ADDRESS_W-$clog2(NUM_BANKS) > x >= BURSTCOUNT_W

    parameter integer BANK_MAX_PENDING_READS = 2*2**BURSTCOUNT_W-4,   // > 0
    parameter integer BANK_MAX_PENDING_WRITES = 2047   // > 0
)
(
    input logic clock,
    input logic resetn,

    // Bank select (one-hot)
    input logic [NUM_BANKS-1:0] bank_select,

    // Master
    input logic m_arb_request,
    input logic m_arb_read,
    input logic m_arb_write,
    input logic [DATA_W-1:0] m_arb_writedata,
    input logic [BURSTCOUNT_W-1:0] m_arb_burstcount,
    input logic [ADDRESS_W-1:0] m_arb_address,
    input logic [BYTEENA_W-1:0] m_arb_byteenable,

    output logic m_arb_stall,

    output logic m_wrp_ack,

    output logic m_rrp_datavalid,
    output logic [DATA_W-1:0] m_rrp_data,

    // To each bank
    output logic b_arb_request [NUM_BANKS],
    output logic b_arb_read [NUM_BANKS],
    output logic b_arb_write [NUM_BANKS],
    output logic [DATA_W-1:0] b_arb_writedata [NUM_BANKS],
    output logic [BURSTCOUNT_W-1:0] b_arb_burstcount [NUM_BANKS],
    output logic [ADDRESS_W-$clog2(NUM_BANKS)-1:0] b_arb_address [NUM_BANKS],
    output logic [BYTEENA_W-1:0] b_arb_byteenable [NUM_BANKS],

    input logic b_arb_stall [NUM_BANKS],

    input logic b_wrp_ack [NUM_BANKS],  // MUST BE USED OR WILL HANG! Set to 1

    input logic b_rrp_datavalid [NUM_BANKS],
    input logic [DATA_W-1:0] b_rrp_data [NUM_BANKS]
);
    // +3 : bank data FIFO latency
    // +1 : do not stall when pipeline is full
    localparam READ_DATA_FIFO_DEPTH = BANK_MAX_PENDING_READS + 3 + 1;

    // READ_BANK_SELECT_FIFO_DEPTH = max( NUM_BANKS, READ_DATA_FIFO_DEPTH );
    localparam READ_BANK_SELECT_FIFO_DEPTH = NUM_BANKS > READ_DATA_FIFO_DEPTH ? NUM_BANKS : READ_DATA_FIFO_DEPTH;

    // +1 : do not stall when pipeline is full
    localparam WRITE_ACK_FIFO_DEPTH = BANK_MAX_PENDING_WRITES * NUM_BANKS + 1;

    genvar i;

    logic [NUM_BANKS-1:0] m_arb_bank_sel;
    logic [ADDRESS_W-$clog2(NUM_BANKS)-1:0] m_arb_bank_address;

    // Split address into bank_sel and bank_address (within a bank)
    acl_iface_address_to_bankaddress #(
      .ADDRESS_W( ADDRESS_W ),
      .NUM_BANKS( NUM_BANKS ),
      .BANK_SEL_BIT( BANK_SEL_BIT))
      a2b (
        .address(m_arb_address),
        .bank_sel_1hot(m_arb_bank_sel),
        .bank_address(m_arb_bank_address));

    // Request.
    generate
    begin:req
        integer req_b;
        logic stall;

        always_comb
        begin
            stall = 1'b0;

            for( req_b = 0; req_b < NUM_BANKS; req_b = req_b + 1 )
            begin:bank
                b_arb_request[req_b] = m_arb_request & m_arb_bank_sel[req_b] & ~(rrp.stall | wrp.stall);
                b_arb_read[req_b] = m_arb_read & m_arb_bank_sel[req_b] & ~(rrp.stall | wrp.stall);
                b_arb_write[req_b] = m_arb_write & m_arb_bank_sel[req_b] & ~(rrp.stall | wrp.stall);
                b_arb_writedata[req_b] = m_arb_writedata;
                b_arb_burstcount[req_b] = m_arb_burstcount;
                b_arb_address[req_b] = m_arb_bank_address;
                b_arb_byteenable[req_b] = m_arb_byteenable;

                stall |= b_arb_stall[req_b] & m_arb_bank_sel[req_b];
            end
        end
    end
    endgenerate

    // Read return path. Need to handle the two problems:
    //  1) Data is returned in a different bank order than the order in which
    //     the banks were issued.
    //  2) Multiple data words arrive in the same cycle (from different banks).
    generate
    begin:rrp
        integer rrp_b;
        logic stall;

        logic [NUM_BANKS-1:0] bs_in, bs_out, bank_df_valid, bank_df_no_free;
        logic [BURSTCOUNT_W-1:0] bs_burstcount, bs_burstcounter;
        logic bs_read, bs_write, bs_full, bs_empty, bs_valid, bs_doneburst;
        logic [DATA_W-1:0] bank_df_out [NUM_BANKS];

        // Bank select FIFO. Tracks which bank the next valid read data
        // should come from. Data is assumed to be one-hot encoded.
        acl_iface_ll_fifo #(
            .DEPTH(READ_BANK_SELECT_FIFO_DEPTH),
            .WIDTH(BURSTCOUNT_W+NUM_BANKS)
        )
        bs_fifo (
            .clk( clock ),
            .reset( ~resetn ),
            .data_in( {m_arb_burstcount,bs_in} ),
            .write( bs_write ),
            .data_out( {bs_burstcount,bs_out} ),
            .read( bs_doneburst && bs_read ),
            .empty( bs_empty ),
            .full( bs_full )
        );

        assign bs_doneburst = (bs_burstcounter == bs_burstcount);
        always @( posedge clock or negedge resetn )
          if (!resetn)
            bs_burstcounter <= 'b01;
          else if (bs_doneburst && bs_read)
            bs_burstcounter <= 'b01;
          else if (bs_read)
            bs_burstcounter <= bs_burstcounter + 'b01;


        // Per-bank logic.
        for( i = 0; i < NUM_BANKS; i = i + 1 )
        begin:bank
            // Data FIFO.
            logic [DATA_W-1:0] df_in, df_out;
            logic df_read, df_write, df_full, df_empty;

            scfifo #(
                .lpm_width( DATA_W ),
                .lpm_widthu( $clog2(READ_DATA_FIFO_DEPTH) ),
                .lpm_numwords( READ_DATA_FIFO_DEPTH ),
                .add_ram_output_register( "ON" ),
                .lpm_showahead( "ON" ),
                .intended_device_family( "stratixiv" )
            )
            data_fifo (
                .aclr( ~resetn ),
                .clock( clock ),
                .empty( df_empty ),
                .full( df_full ),
                .data( df_in ),
                .q( df_out ),
                .wrreq( df_write ),
                .rdreq( df_read ),
                .sclr(),
                .usedw(),
                .almost_full(),
                .almost_empty()
            );

            // Number of free entries in the data FIFO minus one.
            // This means that the data FIFO will be full if df_free == -1.
            // This allows for a single-bit to indicate no more free entries.
            //
            // The range of values that need to be stored in this counter is
            // [-1, READ_DATA_FIFO_DEPTH - 1]. Initial value is
            // READ_DATA_FIFO_DEPTH - 1.
            logic [$clog2(READ_DATA_FIFO_DEPTH):0] df_free;
            logic incr_df_free, decr_df_free;

            // Data FIFO assignments.
            assign df_in = b_rrp_data[i];
            assign df_write = b_rrp_datavalid[i];
            assign df_read = bs_valid & bs_out[i] & bank_df_valid[i];

            assign bank_df_valid[i] = ~df_empty;
            assign bank_df_out[i] = df_out;

            // Logic to track number of free entries in the data FIFO.
            always @( posedge clock or negedge resetn )
                if( !resetn )
                    df_free <= READ_DATA_FIFO_DEPTH - 1;
                else
                    df_free <= df_free + incr_df_free - ((decr_df_free) ? m_arb_burstcount : 1'b0);

            assign incr_df_free = df_read;
            assign decr_df_free = m_arb_read & bs_in[i] & ~(req.stall | bs_full | bank_df_no_free[i]);

            // If MSB is high, then df_free == -1 and that means all data FIFO
            // entries are in use.
            assign bank_df_no_free[i] = df_free < (2**(BURSTCOUNT_W-1));
            //assign bank_df_no_free[i] = df_free[$bits(df_free) - 1];
        end

        // Bank select FIFO assignments.
        assign bs_in = m_arb_bank_sel;
        assign bs_write = m_arb_read & ~(req.stall | stall);
        assign bs_read = bs_valid & |(bs_out & bank_df_valid);
        assign bs_valid = ~bs_empty;

        // Stall the current read request if the bank select FIFO is full or
        // if the bank data FIFO has no free entries.
        assign stall = m_arb_read & (bs_full | |(bs_in & bank_df_no_free));

        // RRP output signals.
        logic [DATA_W-1:0] rrp_data;
        always_comb
        begin
            rrp_data = '0;

            for( rrp_b = 0; rrp_b < NUM_BANKS; rrp_b = rrp_b + 1 )
                rrp_data |= bs_out[rrp_b] ? bank_df_out[rrp_b] : '0;
        end

        always @( posedge clock or negedge resetn )
            if( !resetn )
                m_rrp_datavalid <= 1'b0;
            else
                m_rrp_datavalid <= bs_read;

        always @( posedge clock )
            m_rrp_data <= rrp_data;
    end
    endgenerate

    // Write return path. Need to handle one problem:
    //  1) Multiple write acks arrive in the same cycle (from different banks).
    generate
    begin:wrp
        integer wrp_b;
        logic stall;

        // "FIFO" of acks to send out. This is just a counter that counts
        // the number of wrp acks still left to send out, minus one (so a value
        // of -1 indicates no wrp acks left to send out). This allows for
        // a single bit to mean zero.
        //
        // The range of values stored by this counter is 
        // [-1, WRITE_ACK_FIFO_DEPTH - 1]. Initial value is -1.
        logic [$clog2(WRITE_ACK_FIFO_DEPTH):0] ack_counter;
        logic decr_ack_counter;
        logic [$clog2(NUM_BANKS + 1)-1:0] ack_counter_incr;
        logic has_acks;

        // Counter to track the number of free entries in the ack "FIFO",
        // minus one (so a value of -1 indicates no more free entries). This
        // allows for a single bit to mean no more free entries.
        //
        // The range of values stored by this counter is
        // [-1. WRITE_ACK_FIFO_DEPTH - 1]. Initial value is
        // WRITE_ACK_FIFO_DEPTH - 1.
        logic [$clog2(WRITE_ACK_FIFO_DEPTH):0] ack_free;
        logic incr_ack_free, decr_ack_free;
        logic ack_no_free;

        // Logic for ack counter.
        always @( posedge clock or negedge resetn )
            if( !resetn )
                ack_counter <= {$bits(ack_counter){1'b1}};  // -1
            else
                ack_counter <= ack_counter + ack_counter_incr - decr_ack_counter;

        assign decr_ack_counter = has_acks;
        assign has_acks = ~ack_counter[$bits(ack_counter) - 1];

        always_comb
        begin
            // In any given cycle, each bank can assert its wrp ack signal
            // and so the ack counter can increase by
            ack_counter_incr = '0;

            for( wrp_b = 0; wrp_b < NUM_BANKS; wrp_b = wrp_b + 1 )
                ack_counter_incr += b_wrp_ack[wrp_b];
        end

        // Logic for free entries counter.
        always @( posedge clock or negedge resetn )
            if( !resetn )
                ack_free <= WRITE_ACK_FIFO_DEPTH - 1;
            else
                ack_free <= ack_free + incr_ack_free - decr_ack_free;

        assign incr_ack_free = decr_ack_counter;
        assign decr_ack_free = m_arb_write & ~(req.stall | ack_no_free);
        assign ack_no_free = ack_free[$bits(ack_free) - 1];

        // Stall if the current request is a write and the write ack fifo has
        // no more free entries.
        assign stall = m_arb_write & ack_no_free;

        // Wrp ack signal.
        assign m_wrp_ack = has_acks;
    end
    endgenerate

    // Stall signal.
    assign m_arb_stall = req.stall | rrp.stall | wrp.stall;

endmodule

