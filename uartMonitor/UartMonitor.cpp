// UART VIA JTAG routine
// Written as part of the RISCVY-BUSINESS master thesis code repository.
// Written by Kris Monsen, utilizing the Digilent Adept SDK, extending
// the demo provided by the Digilent SDK.

// As a courtesy, we reproduce the original licence for the demo.
// Most of it is left as-is, but most things after printing out IDCODES is new.
// (except ErrorExit, ShowUsage and the actual API calls, obviously).

/************************************************************************/
/*                                                                      */
/*  DjtgDemo.cpp  --  DJTG DEMO Main Program                            */
/*                                                                      */
/************************************************************************/
/*  Author:    Aaron Odell                                              */
/*  Copyright:    2010 Digilent, Inc.                                   */
/************************************************************************/
/*  Module Description:                                                 */
/*        DJTG Demo demonstrates how to read in IDCODEs from the        */
/*        JTAG scan chain. Codes for some Digilent FPGA boards are      */
/*        given below.                                                  */
/*                                                                      */
/*        Nexys2: 0x41c22093                                            */
/*                0xf5046093                                            */
/*                                                                      */
/*        Basys2: 0x11c10093                                            */
/*                0xf5045093                                            */
/*                                                                      */
/************************************************************************/
/*  Revision History:                                                   */
/*                                                                      */
/*    03/16/2010(AaronO): created                                       */
/*                                                                      */
/************************************************************************/

#define _CRT_SECURE_NO_WARNINGS

/* ------------------------------------------------------------ */
/*                    Include File Definitions                  */
/* ------------------------------------------------------------ */

#if defined(WIN32)

    /* Include Windows specific headers here.
    */
    #include <windows.h>

#else

    /* Include Unix specific headers here.
    */
    

#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dpcdecl.h" 
#include "djtg.h"
#include "dmgr.h"
#include <signal.h>

/* ------------------------------------------------------------ */
/*                Local Type and Constant Definitions           */
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*                Global Variables                              */
/* ------------------------------------------------------------ */
HIF hif;

/* ------------------------------------------------------------ */
/*                Local Variables                               */
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*                Forward Declarations                          */
/* ------------------------------------------------------------ */

void ShowUsage(char* szProgName);
void ErrorExit();
void ResetThenIdle();
void UpdateInstructions(BYTE* instructions, int amount_of_bits);
void UpdateData(BYTE* payload, int amount_of_bits);
void ReadData(BYTE* readbuffer, int amount_of_bits);
void HandleInterrupt(int code);
void ReadWordFromAhb(BYTE* address, BYTE* readBuffer);
void BinaryPrintOfWord(BYTE* wordBuffer);
void WriteWordToAhb(BYTE* address, BYTE* writeBuffer);
void PrintUartRegisters();

/* ------------------------------------------------------------ */
/*                Procedure Definitions                         */
/* ------------------------------------------------------------ */
/***    main
**
**    Parameters:
**        cszArg        - number of command line arguments
**        rgszArg        - array of command line argument strings
**
**    Return Value:
**
**    Errors:
**
**    Description:
**        Run the program.
*/

// Source for ctrl+c interrupt handling: 
// https://stackoverflow.com/questions/4217037/catch-ctrl-c-in-c
// And also The C Programming Language: Second Edition
static volatile int exitProgram = 0;

// Important addresses to word-sized registers on the APBUART...
static BYTE uartData        []  = {0x00,0x01,0x00,0x80};
static BYTE uartStatus        []  = {0x04,0x01,0x00,0x80};
static BYTE uartControl        []  = {0x08,0x01,0x00,0x80};
static BYTE uartFifoDebug    []  = {0x10,0x01,0x00,0x80};

int main(int cszArg, char* rgszArg[]) {
    int i;
    int cCodes = 0;
    BYTE rgbSetup[] = {0xaa, 0x22, 0x00};
    BYTE rgbTdo[4];

    INT32 idcode;
    INT32 rgIdcodes[16];

    /* Command checking */
    if( cszArg < 3 ) {
        ShowUsage(rgszArg[0]);
        ErrorExit();
    }
    if( strcmp(rgszArg[1], "-d") != 0 ) {
        ShowUsage(rgszArg[0]);
        ErrorExit();
    }

    // DMGR API Call: DmgrOpen
    if(!DmgrOpen(&hif, rgszArg[2])) {
        printf("Error: Could not open device. Check device name\n");
        ErrorExit();
    }

    // DJTG API CALL: DjtgEnable
    if(!DjtgEnable(hif)) {
        printf("Error: DjtgEnable failed\n");
        ErrorExit();
    }

    /* Put JTAG scan chain in SHIFT-DR state. 
     * RgbSetup contains TMS/TDI bit-pairs. 
     */
    // DJTG API Call: DgtgPutTmsTdiBits
    if(!DjtgPutTmsTdiBits(hif, rgbSetup, NULL, 9, fFalse)) {
        printf("DjtgPutTmsTdiBits failed\n");
        ErrorExit();
    }

    /* Get IDCODES from device until we receive a value of 0x00000000 */
    do {

        // DJTG API Call: DjtgGetTdoBits
        if(!DjtgGetTdoBits(hif, fFalse, fFalse, rgbTdo, 32, fFalse)) {
            printf("Error: DjtgGetTdoBits failed\n");
            ErrorExit();
        }
        // Convert array of bytes into 32-bit value
        idcode = (rgbTdo[3] << 24) | (rgbTdo[2] << 16) 
                  | (rgbTdo[1] << 8) | (rgbTdo[0]);

        // Place the IDCODEs into an array for LIFO storage
        rgIdcodes[cCodes] = idcode;

        cCodes++;

    } while( idcode != 0 );

    /* Show the IDCODEs in the order that they are connected on the device */
    printf("Ordered JTAG scan chain:\n");
    for(i=cCodes-2; i >= 0; i--) {
        printf("0x%08x\n", rgIdcodes[i]);
    }

    // END OF DEMO, START OF OUR APPLICATION.

    // First, reset the TAPs, and then put ARM to BYPASS (1111), 
    // and Xilinx to USER1.
    ResetThenIdle();
    printf("\n");
    DWORD current_frequency;
    DWORD oneMHZ = 1000000;
    DjtgGetSpeed(hif, &current_frequency);
    printf("JTAG clock speed after reset: ");
    printf("%Id", current_frequency); 
    printf("\n");
    DjtgSetSpeed(hif, oneMHZ, &current_frequency);
    DjtgGetSpeed(hif, &current_frequency);
    printf("Successfully set JTAG clock speed to: ");
    printf("%Id", current_frequency);
    printf("\n\n");

    // Handle interrupts. A interrupt will cause the program to shutdown cleanly.
    signal(SIGINT, HandleInterrupt);

    // Perform an initial read on the UARTs data, status, control and debug reg.
    printf("========== INITIAL UART STATUS ==========\n");
    PrintUartRegisters();

    // Set APBUART to transmit and receive enable, receiver interrupt, 
    // and in FIFO debug mode, and with FIFOs available bit.
    BYTE setUartToDebug[] = {0x07, 0x08, 0x00, 0x80};
    WriteWordToAhb(uartControl, setUartToDebug);

    printf("========== UART SET TO FIFO DEBUG MODE ==========\n");
    PrintUartRegisters();

    printf("========== CHARACTER WRITE AND READ TEST ========== \n");
    BYTE writeH[] = {0x48, 0x00, 0x00,0x00};
    WriteWordToAhb(uartData, writeH);

    BYTE readBuffer[4];
    // Check status register...
    ReadWordFromAhb(uartStatus, readBuffer);
    BinaryPrintOfWord(readBuffer);

    // And read...
    ReadWordFromAhb(uartFifoDebug, readBuffer);
    printf("We got %c from the UART transmitter!\n\n", readBuffer[0]);

    printf("==================================================\n");
    printf("Now monitoring APBUART... Press Ctrl+C to stop.\n");
    printf("==================================================\n");

    char userInput;
    BYTE response[4] = {0x00,0x00,0x00,0x00};
    while (exitProgram == 0) {
        // Read the status register...
        ReadWordFromAhb(uartStatus, readBuffer);

        // If the status register indicates data exists (TE != 1)...
        if ( !(readBuffer[0] & 1<<2) ) {
            // Read that data....
            ReadWordFromAhb(uartFifoDebug, readBuffer);

            // If it is an enquiry (ENQ, 0x05), 
            // we should prompt for a char from the user.
            if (readBuffer[0] == '\x05') {
                printf("\n\n***UARTMONITOR*** Received ENQUIRY!");
                printf("Enter ONE character, then press enter, please: \n");
                userInput = getchar();
                getchar(); // We dont want the newline character.
                printf("***UARTMONITOR*** You entered %c!", userInput);
                printf("Sending it to Pico via UART...\n\n");
                response[0] = userInput;
                WriteWordToAhb(uartFifoDebug, response);
            }
            else {
                // Print that character.
                printf("%c", readBuffer[0]);
            }
        }
    }


    // Disable Djtg and close device handle
    if( hif != hifInvalid ) {
        // DGTG API Call: DjtgDisable
        DjtgDisable(hif);

        // DMGR API Call: DmgrClose
        DmgrClose(hif);
    }

    return 0;
}

void PrintUartRegisters(){
    BYTE readBuffer[4];

    printf("UART Data Register \n");
    ReadWordFromAhb(uartData, readBuffer);
    BinaryPrintOfWord(readBuffer);

    printf("UART Status Register \n");
    ReadWordFromAhb(uartStatus, readBuffer);
    BinaryPrintOfWord(readBuffer);

    printf("UART Control Register \n");
    ReadWordFromAhb(uartControl, readBuffer);
    BinaryPrintOfWord(readBuffer);

    printf("UART FIFO Debug Register \n");
    ReadWordFromAhb(uartFifoDebug, readBuffer);
    BinaryPrintOfWord(readBuffer);

}

void BinaryPrintOfWord(BYTE* wordBuffer){
    for (int i=3; i>=0; i--) {
        for (int j=0; j<8; j++){
            printf("%d", !!((wordBuffer[i] << j) & 0x80));
        }
        printf(" ");
    }
    printf("\n\n");
}

// Expects a 32-bit address, and a 32-bit buffer with valid bytes to write.
void WriteWordToAhb(BYTE* address, BYTE* writeBuffer){
    // Arm DAP to BYPASS, Xilinx TAP to USER1 ('AHBJTAG Command Register')
    BYTE xilinx_user1_and_arm_bypass[] = {0xc2, 0x03};
    UpdateInstructions(xilinx_user1_and_arm_bypass, 10);

    // AHBJTAG to perform desired write by setting AHBJTAG Command Register
    // 34: W/R, 33-32: Size, 31-0: Addr.
    BYTE grlib_uart_dr_write[] = {  address[0], 
                                    address[1], 
                                    address[2], 
                                    address[3], 
                                    0x06
                                 };
    UpdateData(grlib_uart_dr_write, 36);

    // Setting Arm DAP to BYPASS, Xilinx TAP to USER2 ('AHBJTAG Data Register')
    BYTE xilinx_user2_and_arm_bypass[] = {0xc3, 0x03};
    UpdateInstructions(xilinx_user2_and_arm_bypass, 10);
    
    // 32: SEQ (this is the next write), 31-0: Big-Endian AHB Read/Write data.
    // This write is not SEQ. Remember an extra bit for BYPASS reg.
    BYTE writeSequence[] = {    writeBuffer[0], 
                                writeBuffer[1], 
                                writeBuffer[2], 
                                writeBuffer[3], 
                                0x01};
    UpdateData(writeSequence, 34);

    // Read the 33-bit AHBJTAG data register until SEQ bit is 1
    BYTE ahbdata_tdo[5] = {0x00, 0x00, 0x00, 0x00, 0x00};
    do {
        ReadData(ahbdata_tdo, 40);
    } while(!(ahbdata_tdo[4] & 1) & exitProgram == 0);
}

// Expects a 32-bit address, and a 32-bit buffer to return the read word to.
void ReadWordFromAhb(BYTE* address, BYTE* readBuffer){
    // Arm DAP to BYPASS, Xilinx TAP to USER1 ('AHBJTAG Command Register')
    BYTE xilinx_user1_and_arm_bypass[] = {0xc2, 0x03};
    UpdateInstructions(xilinx_user1_and_arm_bypass, 10);

    // AHBJTAG to perform desired read by setting AHBJTAG Command Register
    // 34: W/R, 33-32: Size, 31-0: Addr.
    BYTE grlib_uart_dr_read[] = {   address[0], 
                                    address[1], 
                                    address[2], 
                                    address[3], 
                                    0x02};
    UpdateData(grlib_uart_dr_read, 36);

    // Setting Arm DAP to BYPASS, Xilinx TAP to USER2 ('AHBJTAG Data Register')
    BYTE xilinx_user2_and_arm_bypass[] = {0xc3, 0x03};
    UpdateInstructions(xilinx_user2_and_arm_bypass, 10);

    // Read the 33-bit AHBJTAG data register until SEQ is 1 (Read finished!)
    BYTE ahbdata_tdo[5] = {0x00, 0x00, 0x00, 0x00, 0x00};
    int counter = 0;
    do {
        ReadData(ahbdata_tdo, 40);
        counter++;
        if (counter>10) {
            printf("MONITOR: Possible bus thrashing detected!\n");
            counter = 0;
        }
    } while(!(ahbdata_tdo[4] & 1) && exitProgram == 0);

    memcpy(readBuffer, ahbdata_tdo, 4);
}

void HandleInterrupt(int code) {
    exitProgram = 1;
}

// Custom helpers.
void ResetThenIdle() {
    BYTE sequence[] = {0xaa, 0x02};
    if(!DjtgPutTmsTdiBits(hif, sequence, NULL, 6, fFalse)) {
        printf("DjtgPutTmsTdiBits failed\n");
        ErrorExit();
    }
}

void UpdateInstructions(BYTE* instructions, int bitCount) {
    BYTE IdleToShiftIr[] = {0x03}; // First hex is the only relevant.
    BYTE ShiftIrToIdle[] = {0x03}; // First three bits are the only relevant

    // Go from IDLE to SHIFT-IR state
    if(!DjtgPutTmsBits(hif, fFalse, IdleToShiftIr, NULL, 4, fFalse)) {
        printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Shift in instructions to IRs.
    if(!DjtgPutTdiBits(hif, 0, instructions, NULL, bitCount-1, fFalse)){
        printf("Pushing TDI bits failed!");
        ErrorExit();
    }

    // Go from SHIFT-IR to IDLE state.
    if(!DjtgPutTmsBits(hif, fFalse, ShiftIrToIdle, NULL, 3, fFalse)) {
        printf("Pushing TMS bits failed!");
        ErrorExit();
    }
}


void UpdateData(BYTE* payload, int amount_of_bits) {
    BYTE idle_to_shift_dr[] = {0x01}; // First three bits are relevant
    BYTE shift_dr_to_idle[] = {0x03}; // First three bits are the only relevant

    // Go from IDLE to SHIFT-DR state
    if(!DjtgPutTmsBits(hif, fFalse, idle_to_shift_dr, NULL, 3, fFalse)) {
        printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Shift in payload to DRs.
    // cbits != count of bits. The first bit seems to be clocked in anyway.
    if(!DjtgPutTdiBits(hif, fFalse, payload, NULL, amount_of_bits-1, fFalse)){
        printf("Pushing TDI bits failed!");
        ErrorExit();
    }

    // Go from SHIFT-DR to IDLE state.
    if(!DjtgPutTmsBits(hif, fFalse, shift_dr_to_idle, NULL, 3, fFalse)) {
        printf("Pushing TMS bits failed!");
        ErrorExit();
    }
}

void ReadData(BYTE* readbuffer, int amount_of_bits) {
    BYTE idle_to_shift_dr[] = {0x01}; // First three bits are relevant
    BYTE shift_dr_to_idle[] = {0x03}; // First three bits are the only relevant

    // Go from IDLE to SHIFT-DR state
    if(!DjtgPutTmsBits(hif, fFalse, idle_to_shift_dr, NULL, 3, fFalse)) {
        printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Read amount_of_bits of DR out via TDO
    // For some DRs, such as the AHBJTAG Data Register (USER2), it is vital
    // that we are careful about what we shift in. Shifting in a SEQ bit
    // will cause that unit to read from the next sequential address.
    if(!DjtgGetTdoBits(hif,fFalse,fFalse,readbuffer,amount_of_bits,fFalse)) {
        printf("Error: DjtgGetTdoBits failed\n");
        ErrorExit();
    }

    // Go from SHIFT-DR to IDLE state.
    if(!DjtgPutTmsBits(hif, fFalse, shift_dr_to_idle, NULL, 3, fFalse)) {
        printf("Pushing TMS bits failed!");
        ErrorExit();
    }
}



/* ------------------------------------------------------------ */
/***    ShowUsage
**
**    Parameters:
**        szProgName    - name of program as called (from rgszArg[0])
**
**    Return Value:
**        none
**
**    Errors:
**        none
**
**    Description:
**        Demonstrates proper paramater usage to the user
*/

void 
ShowUsage(char* szProgName) {
    printf("Error: Invalid paramaters\n");
    printf("Usage: %s -d <device> \n\n", szProgName);
}





/* ------------------------------------------------------------ */
/***    ErrorExit
**
**    Parameters:
**        none
**
**    Return Value:
**        none
**
**    Errors:
**        none
**
**    Description:
**        Disables DJTG, closes the device, and exits the program
*/
void ErrorExit() {
    if( hif != hifInvalid ) {

        // DJGT API Call: DjtgDisable
        DjtgDisable(hif);

        // DMGR API Call: DmgrClose
        DmgrClose(hif);
    }

    exit(1);
}

/* ------------------------------------------------------------ */

/************************************************************************/
