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
        printf("Read another TDO 32 bits!");
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
    ReadInstructions();
    ResetThenIdle();
    ReadInstructions(); 

    DWORD current_frequency;
    DWORD oneMHZ = 1000000;
    DjtgGetSpeed(hif, &current_frequency);
    printf("Current JTAG clock speed: ");
    printf("%Id", current_frequency); 
    printf("\n");
    DjtgSetSpeed(hif, oneMHZ, &current_frequency);
    DjtgGetSpeed(hif, &current_frequency);
    printf("Current JTAG clock speed is now: ");
    printf("%Id", current_frequency);
    printf("\n");

    BYTE xilinx_user1_and_arm_bypass[] = {0xc2, 0x03};
    UpdateInstructions(xilinx_user1_and_arm_bypass, 10); // Arm IR is 4 bits, Xilinx is 6 bits. 10 total

    ReadInstructions();
	// Instruct a AHB Read to 0x40000000 (test), by writing to the DR of Xilinx TAP USER1 (Command Register)
    // Arm Bypass DR is 1 bit, Xilinx Tap USER1 is 35 bits
    BYTE grlib_uart_dr_read[] = {0x00, 0x00, 0x00, 0x40, 0x00};
    UpdateData(grlib_uart_dr_read, 36);
  
    BYTE xilinx_user2_and_arm_bypass[] = {0xc3, 0x03};
	UpdateInstructions(xilinx_user2_and_arm_bypass, 10);
    
	ReadInstructions();
    // Read the 33-bit AHBJTAG data register until the MSB is 1 (Read finished!)
	BYTE ahbdata_tdo[5];
    int counter = 0;
	do {
        // 33 LSB is from Xilinx USER 2 DR, the next is 1 for ARM DAP BYPASS, the final 6 are noise.
        ReadData(ahbdata_tdo, 40);
        printf("Got 40 bits from TDO!\n");

		// For every received byte, from MSB to LSB
		for( int i = 4; i>=0; i-- ) {
			// Creds for simple and elegant char-to-binary: https://stackoverflow.com/questions/18327439/printing-binary-representation-of-a-char-in-c
			for (int j = 0; j < 8; j++) {
				printf("%d", !!((ahbdata_tdo[i] << j) & 0x80));
			}
            printf(" ");
		}

		printf("\n");
        counter++;
 
	} while(!(ahbdata_tdo[4] & 1) & counter < 100); // While the SEQ bit is not set. TODO: Create new int array which only has the AHBJTAG DR data.
    

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
	BYTE sequence[] = {0x1f};
	if(!DjtgPutTmsBits(hif, fFalse, sequence, NULL, 6, fFalse)) {
		printf("Method ResetThenIdle failed!");
        ErrorExit();
    }
}

void UpdateInstructions(BYTE* instructions, int amount_of_bits) {
	BYTE idle_to_shift_ir[] = {0x03}; // First hex is the only relevant.
    BYTE shift_ir_to_idle[] = {0x03}; // First three bits are the only relevant

    // Go from IDLE to SHIFT-IR state
	if(!DjtgPutTmsBits(hif, fFalse, idle_to_shift_ir, NULL, 4, fFalse)) {
		printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Shift in instructions to IRs.
    if(!DjtgPutTdiBits(hif, fFalse, instructions, NULL, amount_of_bits, fFalse)){
		printf("Pushing TDI bits failed!");
        ErrorExit();
	}

    // Go from SHIFT-IR to IDLE state.
	if(!DjtgPutTmsBits(hif, fFalse, shift_ir_to_idle, NULL, 3, fFalse)) {
		printf("Pushing TMS bits failed!");
        ErrorExit();
    }
}

void ReadInstructions() {
	BYTE idle_to_shift_ir[] = {0x03}; // First hex is the only relevant.
    BYTE shift_ir_to_idle[] = {0x03}; // First three bits are the only relevant
    BYTE tdo_buffer[2];

    // Go from IDLE to SHIFT-IR state
	if(!DjtgPutTmsBits(hif, fFalse, idle_to_shift_ir, NULL, 4, fFalse)) {
		printf("Pushing TMS bits failed!");
        ErrorExit();
    }

    // Read amount_of_bits of DR out via TDO
	if(!DjtgGetTdoBits(hif, fFalse, fFalse, tdo_buffer, 16, fFalse)) {
		printf("Error: DjtgGetTdoBits failed\n");
		ErrorExit();
	}

    // Go from SHIFT-IR to IDLE state.
	if(!DjtgPutTmsBits(hif, fFalse, shift_ir_to_idle, NULL, 3, fFalse)) {
		printf("Pushing TMS bits failed!");
        ErrorExit();
    }

		for( int i = 1; i>=0; i-- ) {
			// Creds for simple and elegant char-to-binary: https://stackoverflow.com/questions/18327439/printing-binary-representation-of-a-char-in-c
			for (int j = 0; j < 8; j++) {
				printf("%d", !!((tdo_buffer[i] << j) & 0x80));
			}
            printf(" ");
		}
        printf("\n");
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
    if(!DjtgPutTdiBits(hif, fFalse, payload, NULL, amount_of_bits, fFalse)){
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
	if(!DjtgGetTdoBits(hif, fTrue, fFalse, readbuffer, amount_of_bits, fFalse)) {
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
