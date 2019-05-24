// UART VIA JTAG routine
// Written as part of the RISCVY-BUSINESS master thesis code repository.
// Written by Kris Monsen, utilizing the Digilent Adept SDK.

// As a courtesy, we reproduce the original licence for the demonstration program here (which was included in the SDK). 
// Most of it is left as-is, but most things after printing out IDCODES are original 
// (except ErrorExit, ShowUsage and the actual API calls, obviously).

/************************************************************************/
/*																		*/
/*  DjtgDemo.cpp  --  DJTG DEMO Main Program							*/
/*																		*/
/************************************************************************/
/*  Author:	Aaron Odell													*/
/*  Copyright:	2010 Digilent, Inc.										*/
/************************************************************************/
/*  Module Description: 												*/
/*		DJTG Demo demonstrates how to read in IDCODEs from the			*/
/*		JTAG scan chain. Codes for some Digilent FPGA boards are		*/
/*		given below.													*/
/*																		*/
/*		Nexys2: 0x41c22093												*/
/*				0xf5046093												*/
/*																		*/
/*		Basys2: 0x11c10093												*/
/*				0xf5045093												*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/*																		*/
/*	03/16/2010(AaronO): created											*/
/*																		*/
/************************************************************************/

#define _CRT_SECURE_NO_WARNINGS

/* ------------------------------------------------------------ */
/*					Include File Definitions					*/
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

/* ------------------------------------------------------------ */
/*				Local Type and Constant Definitions				*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */
HIF hif;

/* ------------------------------------------------------------ */
/*				Local Variables									*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*				Forward Declarations							*/
/* ------------------------------------------------------------ */

void ShowUsage(char* szProgName);
void ErrorExit();
void ResetThenIdle();
void UpdateInstructions(BYTE* instructions, int amount_of_bits);
void UpdateData(BYTE* payload, int amount_of_bits);
void ReadData(BYTE* readbuffer, int amount_of_bits);
void ReadInstructions();
void TdoBufferPrint(BYTE* tdo_buffer, int bitcount);
void UpdateInstructionsAndData(BYTE* Instructions, BYTE* Payload, int InstructionBits, int PayloadBits);

/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */
/***	main
**
**	Parameters:
**		cszArg		- number of command line arguments
**		rgszArg		- array of command line argument strings
**
**	Return Value:
**
**	Errors:
**
**	Description:
**		Run the program.
*/

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

	/* Put JTAG scan chain in SHIFT-DR state. RgbSetup contains TMS/TDI bit-pairs. */
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
		idcode = (rgbTdo[3] << 24) | (rgbTdo[2] << 16) | (rgbTdo[1] << 8) | (rgbTdo[0]);

		// Place the IDCODEs into an array for LIFO storage
		rgIdcodes[cCodes] = idcode;

		cCodes++;

	} while( idcode != 0 );

	/* Show the IDCODEs in the order that they are connected on the device */
	printf("Ordered JTAG scan chain:\n");
	for(i=cCodes-2; i >= 0; i--) {
		printf("0x%08x\n", rgIdcodes[i]);
	}

    // **************************************************
    // Routine which commands AHBJTAG to perform reads.
    // **************************************************

    // First, reset the TAPs, and then put ARM to BYPASS (1111), and Xilinx to USER1 (
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

    // It is important that we do not go into TEST-IDLE before we shift into the ABHJTAG Command Register...
    printf("Setting Arm DAP to BYPASS, Xilinx TAP to USER1 ('AHBJTAG Command Register').\n");
    BYTE xilinx_user1_and_arm_bypass[] = {0xc2, 0x03};
    BYTE grlib_uart_dr_read[] = {0x00, 0x00, 0x00, 0x50, 0x00};
    UpdateInstructionsAndData(xilinx_user1_and_arm_bypass, grlib_uart_dr_read, 10, 36);
  
    printf("Setting Arm DAP to BYPASS, Xilinx TAP to USER2 ('AHBJTAG Data Register').\n\n");
    BYTE xilinx_user2_and_arm_bypass[] = {0xc3, 0x03};
	UpdateInstructions(xilinx_user2_and_arm_bypass, 10);
    
    // Read the 33-bit AHBJTAG data register until the MSB is 1 (Read finished!)
	BYTE ahbdata_tdo[5] = {0x00, 0x00, 0x00, 0x00, 0x00};
    int counter = 0;
	do {
        // 33 LSB is from Xilinx USER 2 DR, the next is 1 for ARM DAP BYPASS, the final 6 are noise.
        ReadData(ahbdata_tdo, 40);
        printf("Got 40 bits from TDO!\nBeware that only the 34 lower order bits are relevant.\n");

		// For every received byte, from MSB to LSB
		for( int i = 4; i>=0; i-- ) {
			// Creds for simple and elegant char-to-binary: https://stackoverflow.com/questions/18327439/printing-binary-representation-of-a-char-in-c
			for (int j = 0; j < 8; j++) {
				printf("%d", !!((ahbdata_tdo[i] << j) & 0x80));
			}
            printf(" ");
		}

		printf("\n\n");
        counter++;
 
	} while(!(ahbdata_tdo[4] & 1) && counter<50); // While the SEQ bit is not set. TODO: Create new int array which only has the AHBJTAG DR data.
    

	// Disable Djtg and close device handle
	if( hif != hifInvalid ) {
		// DGTG API Call: DjtgDisable
		DjtgDisable(hif);

		// DMGR API Call: DmgrClose
		DmgrClose(hif);
	}

	return 0;
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

// This will set both the IR and DR before landing in TEST-IDLE state.
void UpdateInstructionsAndData(BYTE* instructions, BYTE* payload, int instructionBits, int payloadBits) {
	BYTE idleToShiftIr[] = {0x03}; // First hex is the only relevant.
    BYTE shiftIrToShiftDr[] = {0x7}; // First five bits relevant, does not go into RUN-TEST
    BYTE shiftDrToIdle[] = {0x03}; // First three bits are the only relevant

    // Go from IDLE to SHIFT-IR state
	if(!DjtgPutTmsBits(hif, fFalse, idleToShiftIr, NULL, 4, fFalse)) {
		printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Shift in instructions to IRs.
    if(!DjtgPutTdiBits(hif, fFalse, instructions, NULL, instructionBits-1, fFalse)){
		printf("Pushing TDI bits failed!");
        ErrorExit();
	}

    // Go from SHIFT-IR to SHIFT-DR state.
	if(!DjtgPutTmsBits(hif, fFalse, shiftIrToShiftDr, NULL, 5, fFalse)) {
		printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Write payload into DR
    if(!DjtgPutTdiBits(hif, fFalse, payload, NULL, payloadBits-1, fFalse)){
		printf("Pushing TDI bits failed!");
        ErrorExit();
	}

    // Go from SHIFT-DR to IDLE
	if(!DjtgPutTmsBits(hif, fFalse, shiftDrToIdle, NULL, 3, fFalse)) {
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
    printf("Reading from DR...\n");
	BYTE idle_to_shift_dr[] = {0x01}; // First three bits are relevant
    BYTE shift_dr_to_idle[] = {0x03}; // First three bits are the only relevant

    // Go from IDLE to SHIFT-DR state
	if(!DjtgPutTmsBits(hif, fFalse, idle_to_shift_dr, NULL, 3, fFalse)) {
		printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Read amount_of_bits of DR out via TDO
    // For some DRs, such as the AHBJTAG Data Register (USER2), it is very important
    // that we are careful about what we shift in. Shifting in a 1 on position 32 (SEQ)
    // will cause that unit to read from the next sequential address.
    // Practical if you need it, not so nice if you depend on it to only perform one read.
	if(!DjtgGetTdoBits(hif, fFalse, fFalse, readbuffer, amount_of_bits, fFalse)) {
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
/***	ShowUsage
**
**	Parameters:
**		szProgName	- name of program as called (from rgszArg[0])
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Demonstrates proper paramater usage to the user
*/

void 
ShowUsage(char* szProgName) {
	printf("Error: Invalid paramaters\n");
	printf("Usage: %s -d <device> \n\n", szProgName);
}





/* ------------------------------------------------------------ */
/***	ErrorExit
**
**	Parameters:
**		none
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Disables DJTG, closes the device, and exits the program
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
