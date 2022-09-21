/****************************************************************************************
*
*    File Name:  MT8LSDT864H.V  
*      Version:  0.0a
*         Date:  December 18th, 1998
*        Model:  BUS Functional
*    Simulator:  Model Technology VLOG (PC version 4.7i)
*
* Dependencies:  MT48LC4M16A2.V
*
*       Author:  Son P. Huynh
*        Email:  sphuynh@micron.com
*        Phone:  (208) 368-3825
*      Company:  Micron Technology, Inc.
*        Model:  MT8LSDT864H
*
*  Description:  Micron 64MB SDRAM SODIMM Verilog model using 8 MT48LC4M16A2 components
*
*   Limitation:  Serial presence-detect (SPD) not implemented
*      
*   Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
*                WHATSOEVER AND MICRON SPECIFICALLY DISCLAIMS ANY 
*                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
*                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
*
*                Copyright © 1998 Micron Semiconductor Products, Inc.
*                All rights researved
*
* Rev   Author          Phone         Date        Changes
* ----  ----------------------------  ----------  ---------------------------------------
* 0.0A  Son Huynh       208-368-3825  12/18/1998  - First Release
*       Micron Technology Inc.
*
****************************************************************************************/

`timescale 1ns / 100ps

module mt8lsdt864h (Dq, Addr, Ba, Clk, Cke, Cs_n, Ras_n, Cas_n, We_n, Dqm);

    parameter addr_bits = 12;
    parameter data_bits = 64;

    inout     [data_bits - 1 : 0] Dq;
    input     [addr_bits - 1 : 0] Addr;
    input                 [1 : 0] Ba;
    input                 [1 : 0] Clk;
    input                 [1 : 0] Cke;
    input                 [1 : 0] Cs_n;
    input                         Ras_n;
    input                         Cas_n;
    input                         We_n;
    input                 [7 : 0] Dqm;

    mt48lc4m16a2 U0 (Dq[15 :  0], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[1 : 0]);
    mt48lc4m16a2 U4 (Dq[15 :  0], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[1 : 0]);

    mt48lc4m16a2 U1 (Dq[31 : 16], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[3 : 2]);
    mt48lc4m16a2 U5 (Dq[31 : 16], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[3 : 2]);

    mt48lc4m16a2 U2 (Dq[47 : 32], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[5 : 4]);
    mt48lc4m16a2 U6 (Dq[47 : 32], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[5 : 4]);

    mt48lc4m16a2 U3 (Dq[63 : 48], Addr, Ba, Clk[0], Cke[0], Cs_n[0], Ras_n, Cas_n, We_n, Dqm[7 : 6]);
    mt48lc4m16a2 U7 (Dq[63 : 48], Addr, Ba, Clk[1], Cke[1], Cs_n[1], Ras_n, Cas_n, We_n, Dqm[7 : 6]);

endmodule
