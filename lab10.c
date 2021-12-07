/*****************************************************************************
* Lab 10 main file
*****************************************************************************/

#include <stdint.h>
#include <stdio.h>
#include "utils/uartstdio.h"
#include "../ECE251_util.h"
#include "prob10c.h"

int main(void)
{
		// Set up
		// Set up GPIO to output to LEDs
    SystemInit();
    // Initialize the UART.
    ConfigureUART();


    UARTprintf("Selct a record\n");
		
		
		// Code goes here!	
	//setting up the arrays and integers
int Input_Number;
int Num_hold	[2] = {0,0};
char Input_Character;
int LetterAsNum;

//calling the metods to get my outputs
do{
Input_Character = getCharInput(&Input_Character);
Input_Number = getNumInput(&Input_Number);
LetterAsNum = ConvertLetter (Input_Character);
loop_letter_up(LetterAsNum, Input_Number,&Num_hold);
loop_down(&Num_hold);
}
while(Input_Character != 'Z');
	
    
    while(1)
    {
       
    }
}

