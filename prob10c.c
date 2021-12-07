/*****************************************************************************
* This is the code for all the funtions
*****************************************************************************/

#include "prob10c.h"
#include <stdint.h>
#include <stdio.h>
#include "utils/uartstdio.h"


//Converts characters to integers
//********************************************
int char2int(char value)
{
		return (value - 48);
}

//********************************************


//Get an input for the character from the user

char getCharInput(char *Input_Character)
{
	UARTprintf("\nEnter letter (A-E):\n");
	Input_Character = UARTgetc();							//Getting the character from the user
	return Input_Character;
}

//********************************************
//Get an input for the number from the user

int getNumInput(int *Input_Number)
{
	UARTprintf("\nEnter Number (1-9):\n");
	Input_Number = char2int(UARTgetc());
	return Input_Number;
}

//********************************************
//Switch function to convert the letter that the user inputted to a number
//This can be edited, so that you can expant the range of your library

int ConvertLetter (char Input_Character)
{
	int value = 0;
	switch(Input_Character)
	{
		case 'A':
			value = 1;
		break;
		case 'B':
			value = 2;
		break;
		case 'C':
			value = 3;
		break;
		case 'D':
			value = 4;
		break;
		case 'E':
			value = 5;
		break;
	
}
	return value;
}
	

//*************************************************
// After the user inputs a letter and a number, the letter is converted into a number and the motor begins to step up


void loop_letter_up(int LetterAsNum, int Input_Number, int *Num_Hold) //do not need some of this
	{
		int i =0;
		int j =0;
		int PlaceHolder = 1; 							//A place holder for where the motor will start also known as A
while(LetterAsNum != PlaceHolder)			//Comparing the letter from the user input to the place holder
{
	for(i=0; i<10; i++)										//loop the numbers from 0-9
	{					
		UARTprintf("\nNumber: %d", i);			//printing as the number is going up
		//code to run motor
		extern  __MotorDrive();							//Branch to assembly code, so that I can drive the motor
		__MotorDrive();
	}
	UARTprintf("\nLetter Up");						//Once the number reaches 9, it will count up to the next letter
	PlaceHolder++;												//increasing the place holder so that the letter gets closer to what the user inputted
}																				//end of while loop

//If the letter that the user inputed is the same as the place holder, then this code will be exicuted
for(j=0; j<=Input_Number; j++)			
{
	UARTprintf("\nNumber: %d", j);
		extern  __MotorDrive();						//code to drive the motor
		__MotorDrive();
}
Num_Hold[0]= PlaceHolder;						//PlaceHolder to know what letter we are on (saving the letters for the main file)
Num_Hold[1]= Input_Number;					//PlaceHolder to know what number we are
}
	
//This code includes the delay for the motor after it reaches the value and then it will count back down to where it started
void loop_down(int *Num_Hold)
{
	int Letter_hold = Num_Hold[0]; //this is the letter that is stored in the jukebox
	int number = Num_Hold[1];			//this is the number that is stored in the jukebox
	int PlaceHolder =1;						//this is the code for the starting value of A
	
while(Letter_hold != PlaceHolder)		//compare where the motor is at to the start
{
	
//If the letter that you are on is not at zero then this code will run	
	if(number != 0)										//looking at the number that it is at. If it is not zero then this code will run
	{
		UARTprintf("\nGoing back to start");	 
		extern __MotorDelay();					//Delay in motor, so that the machine can grab the record
		__MotorDelay();
		
	for(int i=number-1; i>=0; i--)						//loop the numbers down
	{					
		UARTprintf("\nNumber: %d", i);
		//code to loop back down	
		extern __MotorDown();									//assembly to drive the motor backwards
	 __MotorDown();
	}
}	
	
//We have gotten back to the base of whatever letter you are on
	UARTprintf("\nLetter Down");
	number =0;

	for(int j=9; j>=0; j--)										//loop down the numbers again for the new letter that you are on
	{					
		UARTprintf("\nNumber: %d", j);
		//code to count steps down
			extern __MotorDown();								//assemby to drive the motor backwards
	 __MotorDown();
	}
	UARTprintf("\nLetter Down");
	Letter_hold--;

	}

//this code is for if you are alrady at the starting letter (A)
if(Letter_hold == PlaceHolder)
{
	if(number != 0)
	{
		UARTprintf("\nGoing back to start");
	for(int i=number-1; i>=0; i--)										//loop the numbers down
	{					
		UARTprintf("\nNumber: %d", i);
//code to count back down		
				extern __MotorDown();												//assembly to move the motor backwards
	 __MotorDown();
	}
}

	}
}



//improvement adding zeros, fine tune times and delays, add new function specifically for the delay
