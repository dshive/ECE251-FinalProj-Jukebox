
#ifndef __PROB10C_H__
#define __PROB10C_H__
#define GPIO_PORTF_DATA_BITS_R  ((volatile unsigned long *)0x400253FC)
int char2int(char value);
char getCharInput(char *Input_Character);
int getNumInput(int *Input_Number);
int ConvertLetter (char Input_Character);
void loop_letter_up(int LetterAsNum, int Input_Number, int *Num_Hold);
void loop_down(int *Num_Hold);

#endif /* __PROB10C_H__ */