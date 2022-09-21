/******************************************************************************
*
*    File Name:  TEST.V
*      Version:  1.0
*         Date:  November 4th, 1998
*        Model:  BUS Functional
*    Simulator:  Model Technology VLOG (PC version 4.7h)
*
* Dependencies:  MT48LC4M16A2.V and MT8LSDT864H.V
*
*       Author:  Son P. Huynh
*        Email:  sphuynh@micron.com
*        Phone:  (208) 368-3825
*      Company:  Micron Technology, Inc.
*
*  Description:  This is a testbench for MT48LC4M16A2.V
*
*   Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
*                WHATSOEVER AND MICRON SPECIFICALLY DISCLAIMS ANY 
*                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
*                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
*
*                Copyright © 1998 Micron Semiconductor Products, Inc.
*                All rights researved
*
******************************************************************************/

`timescale 1ns / 100ps

module test;

    parameter addr_bits = 12;
    parameter data_bits = 64;

    reg  [data_bits - 1 : 0] dq;                            // SDRAM I/O
    reg  [addr_bits - 1 : 0] addr;                          // SDRAM Address
    reg              [1 : 0] ba;                            // Bank Address
    reg                      clk;                           // Clock
    reg                      cke;                           // Synchronous Clock Enable
    reg                      cs_n;                          // CS#
    reg                      ras_n;                         // RAS#
    reg                      cas_n;                         // CAS#
    reg                      we_n;                          // WE#
    reg              [1 : 0] dqm;                           // I/O Mask

    wire [data_bits - 1 : 0] DQ   = dq;
    wire             [1 : 0] CLK  = {clk, clk};
    wire             [1 : 0] CKE  = {cke, cke};
    wire             [1 : 0] CS_N = {cs_n, cs_n};
    wire             [7 : 0] DQM  = {dqm, dqm, dqm, dqm};

    parameter                hi_z = {data_bits{1'bz}};      // Hi-Z

    mt8lsdt864h sdram0 (DQ, addr, ba, CLK, CKE, CS_N, ras_n, cas_n, we_n, DQM);

    initial begin
        clk = 1'b0;
        cke = 1'b0;
        cs_n = 1'b1;
        dq  = hi_z;
    end

    always #5 clk = ~clk;

    always @ (posedge clk) begin
        $display ("Clk = %b, Cke = %b, Cs# = %b, Ras# = %b, Cas# = %b, We# = %b, Dqm = %b, Ba = %d, Addr = %d, Dq = %d",
                    clk, cke, cs_n, ras_n, cas_n, we_n, dqm, ba, addr, DQ);
    end

    task active;
        input             [1 : 0] bank;
        input [addr_bits - 1 : 0] row;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 1;
            we_n  = 1;
            dqm   = 0;
            ba    = bank;
            addr  = row;
            dq    = dq_in;
        end
    endtask

    task auto_refresh;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 0;
            we_n  = 1;
            dqm   = 0;
            ba    = 0;
            addr  = 0;
            dq    = hi_z;
        end
    endtask

    task burst_term;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 1;
            cas_n = 1;
            we_n  = 0;
            dqm   = 0;
            ba    = 0;
            addr  = 0;
            dq    = dq_in;
        end
    endtask

    task load_mode_reg;
        input [addr_bits - 1 : 0] op_code;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 0;
            we_n  = 0;
            dqm   = 0;
            ba    = 0;
            addr  = op_code [addr_bits - 1 :  0];
            dq    = hi_z;
        end
    endtask

    task nop;
        input             [1 : 0] dqm_in;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 1;
            cas_n = 1;
            we_n  = 1;
            dqm   = dqm_in;
            ba    = 0;
            addr  = 0;
            dq    = dq_in;
        end
    endtask

    task precharge_bank_0;
        input             [1 : 0] dqm_in;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 1;
            we_n  = 0;
            dqm   = dqm_in;
            ba    = 0;
            addr  = 0;
            dq    = dq_in;
        end
    endtask

    task precharge_bank_1;
        input             [1 : 0] dqm_in;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 1;
            we_n  = 0;
            dqm   = dqm_in;
            ba    = 1;
            addr  = 0;
            dq    = dq_in;
        end
    endtask

    task precharge_bank_2;
        input             [1 : 0] dqm_in;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 1;
            we_n  = 0;
            dqm   = dqm_in;
            ba    = 2;
            addr  = 0;
            dq    = dq_in;
        end
    endtask

    task precharge_bank_3;
        input             [1 : 0] dqm_in;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 1;
            we_n  = 0;
            dqm   = dqm_in;
            ba    = 3;
            addr  = 0;
            dq    = dq_in;
        end
    endtask

    task precharge_all_bank;
        input             [1 : 0] dqm_in;
        input [data_bits - 1 : 0] dq_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 0;
            cas_n = 1;
            we_n  = 0;
            dqm   = dqm_in;
            ba    = 0;
            addr  = 1024;            // A10 = 1
            dq    = dq_in;
        end
    endtask

    task read;
        input             [1 : 0] bank;
        input [addr_bits - 1 : 0] column;
        input [data_bits - 1 : 0] dq_in;
        input             [1 : 0] dqm_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 1;
            cas_n = 0;
            we_n  = 1;
            dqm   = dqm_in;
            ba    = bank;
            addr  = column;
            dq    = dq_in;
        end
    endtask

    task write;
        input             [1 : 0] bank;
        input [addr_bits - 1 : 0] column;
        input [data_bits - 1 : 0] dq_in;
        input             [1 : 0] dqm_in;
        begin
            cke   = 1;
            cs_n  = 0;
            ras_n = 1;
            cas_n = 0;
            we_n  = 0;
            dqm   = dqm_in;
            ba    = bank;
            addr  = column;
            dq    = dq_in;
        end
    endtask

    integer Case;

initial begin
    begin
//
        // Alternate bank Write-Write-Read-Read with manual precharge (CL = 3, BL = 8)
        #10; nop    (0, hi_z);                  // Nop
        #60; precharge_all_bank(0, hi_z);       // Precharge ALL Bank
        #10; nop    (0, hi_z);                  // Nop
        #20; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; load_mode_reg (51);                // Load Mode: Lat = 3, BL = 8, Seq
        #10; nop    (0, hi_z);                  // Nop
        #10; active (0, 0, hi_z);               // Active: Bank = 0, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; write  (0, 7, 7, 0);               // Write : Bank = 0, Col = 7, Dqm = 0
        #10; nop    (0, 8);                     // Nop
        #10; nop    (0, 9);                     // Nop
        #10; nop    (0, 10);                    // Nop
        #10; nop    (0, 11);                    // Nop
        #10; active (1, 0, 12);                 // Active: Bank = 1, Row = 0
        #10; nop    (0, 13);                    // Nop
        #10; nop    (0, 14);                    // Nop

        #10; write  (1, 107, 107, 0);           // Write : Bank = 1, Col = 107, Dqm = 0
        #10; precharge_bank_0 (0, 108);         // Prech : Bank 0
        #10; nop    (0, 109);                   // Nop
        #10; nop    (0, 110);                   // Nop
        #10; nop    (0, 111);                   // Nop
        #10; active (0, 0, 112);                // Active: Bank = 0, Row = 0
        #10; nop    (0, 113);                   // Nop
        #10; nop    (0, 114);                   // Nop
        #10; read   (0, 7, hi_z, 0);            // Read  : Bank = 0, Col = 7
        #10; precharge_bank_1 (0, hi_z);        // Prech : Bank 1
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; active (1, 0, hi_z);               // Active: Bank = 1, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; read   (1, 107, hi_z, 0);          // Nop
        #10; precharge_bank_0 (0, hi_z);        // Prech : Bank 0
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; precharge_bank_1 (0, hi_z);        // Prech : Bank 1
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10;
//
/*
        // Read with auto precharge interrupt by a Read (with or without auto precharge) (CL = 3, BL = 4)
        #10; nop    (0, hi_z);                  // Nop
        #60; precharge_all_bank(0, hi_z);       // Precharge ALL Bank
        #10; nop    (0, hi_z);                  // Nop
        #20; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; load_mode_reg (50);                // Load Mode: Lat = 3, BL = 4, Seq
        #10; nop    (0, hi_z);                  // Nop
        #10; active (0, 0, hi_z);               // Active: Bank = 0, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; active (1, 0, hi_z);               // Active: Bank = 1, Row = 0;
        #10; nop    (0, hi_z);                  // Nop
        #10; read   (0, 1024, hi_z, 0);         // Read  : Bank = 0, Col = 0, Auto Precharge
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; read   (1, 1024, hi_z, 0);         // Read  : Bank = 1, Col = 0, Auto Precharge (Terminate Previous Read)
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #60;
*/
/*
        // Read with auto precharge interrupt by a Write (with or without auto precharge) (CL = 3, BL = 4)
        #10; nop    (0, hi_z);                  // Nop
        #60; precharge_all_bank(0, hi_z);       // Precharge ALL Bank
        #10; nop    (0, hi_z);                  // Nop
        #20; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; load_mode_reg (50);                // Load Mode: Lat = 3, BL = 4, Seq
        #10; nop    (0, hi_z);                  // Nop
        #10; active (0, 0, hi_z);               // Active: Bank = 0, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; active (1, 0, hi_z);               // Active: Bank = 1, Row = 0;
        #10; nop    (0, hi_z);                  // Nop
        #10; read   (0, 1024, hi_z, 0);         // Read  : Bank = 0, Col = 0, Auto Precharge
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (1, hi_z);                  // Nop   : DQM = 1 to avoid bus contending
        #10; nop    (0, hi_z);                  // Nop
        #10; write  (1, 1024, 100, 0);          // Write : Bank = 1, Col = 0, Auto Precharge (Terminate Previous Read)
        #10; nop    (0,       101);             // Nop
        #10; nop    (0,       102);             // Nop
        #10; nop    (0,       103);             // Nop
        #10; nop    (0, hi_z);                  // Nop
        #20;
*/
/*
        // Write with auto precharge interrupt by a Read (with or without auto precharge) (CL = 3, BL = 4)
        #10; nop    (0, hi_z);                  // Nop
        #60; precharge_all_bank(0, hi_z);       // Precharge ALL Bank
        #10; nop    (0, hi_z);                  // Nop
        #20; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; load_mode_reg (50);                // Load Mode: Lat = 3, BL = 4, Seq
        #10; nop    (0, hi_z);                  // Nop
        #10; active (0, 0, hi_z);               // Active: Bank = 0, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; active (1, 0, hi_z);               // Active: Bank = 1, Row = 0;
        #10; nop    (0, hi_z);                  // Nop
        #10; write  (0, 1024, 100, 0);          // Read  : Bank = 0, Col = 0, Auto Precharge
        #10; nop    (0,       101);             // Nop
        #10; read   (1, 1024, hi_z, 0);         // Read  : Bank = 1, Col = 0, Auto Precharge (Terminate Previous Write)
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #60;
*/
/*
        // Write with auto precharge interrupt by a Write (with or without auto precharge) (CL = 3, BL = 4)
        #10; nop    (0, hi_z);                  // Nop
        #60; precharge_all_bank(0, hi_z);       // Precharge ALL Bank
        #10; nop    (0, hi_z);                  // Nop
        #20; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; load_mode_reg (50);                // Load Mode: Lat = 3, BL = 4, Seq
        #10; nop    (0, hi_z);                  // Nop
        #10; active (0, 0, hi_z);               // Active: Bank = 0, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; active (1, 0, hi_z);               // Active: Bank = 1, Row = 0;
        #10; nop    (0, hi_z);                  // Nop
        #10; write  (0, 1024, 100, 0);          // Read  : Bank = 0, Col = 0, Auto Precharge
        #10; nop    (0,       101);             // Nop
        #10; write  (1, 1024, 102, 0);          // Write : Bank = 1, Col = 0, Auto Precharge (Terminate Previous Write)
        #10; nop    (0,       103);             // Nop
        #10; nop    (0,       104);             // Nop
        #10; nop    (0,       105);             // Nop
        #10; nop    (0, hi_z);                  // Nop
        #30;
*/
/*
        // Single WRITE-READ with manual precharge (CL = 2, BL = 4)
        #10; nop    (0, hi_z);                  // Nop
        #60; precharge_all_bank(0, hi_z);       // Precharge ALL Bank
        #10; nop    (0, hi_z);                  // Nop
        #20; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; auto_refresh;                      // Auto Refresh
        #10; nop    (0, hi_z);                  // Nop
        #80; load_mode_reg (34);                // Load Mode: Lat = 2, BL = 4, Seq
        #10; nop    (0, hi_z);                  // Nop
        #10; active (0, 0, hi_z);               // Active: Bank = 0, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; write  (0, 0, 100, 0);             // Write : Bank = 0, Col = 0, Dqm = 0
        #10; nop    (3, hi_z);                  // Nop
        #10; nop    (3, hi_z);                  // Nop
        #10; precharge_all_bank(3, hi_z);       // Precharge ALL Banks (terminate Write)
        #10; nop    (0, hi_z);                  // Nop
        #10; active (0, 0, hi_z);               // Active: Bank = 0, Row = 0
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; nop    (0, hi_z);                  // Nop
        #10; read   (0, 0, hi_z, 0);            // Read  : Bank = 0, Col = 0
        #10; precharge_all_bank(3, hi_z);       // Precharge ALL Banks (terminate Write)
        #10; nop    (0, hi_z);                  // Nop
        #20;    
*/
    end
$stop;
$finish;
end

endmodule

