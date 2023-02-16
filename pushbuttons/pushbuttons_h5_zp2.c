#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <wiringPi.h>


// === Paramètres personnalisables ===
# define num 2                                        // Number of PINs used

unsigned int nums = 2;                                // Number of PINs used again
unsigned int WpiPinsSelection[] = {12,26};   		  // List of GPIO used by buttons in Wpi semantics
unsigned char script_path[50] = "/usr/local/bin/";    // Folder where the scripts will be executed
unsigned int delay_time = 40;                         // Delay in ms between each check of GPIO
// Calculer en fonction du nombre total de boutons.

// === Global Variables ===

unsigned int curr_state[num];       // array of current states
unsigned int old_state[num];        // array of previous states
unsigned int trigg_0;               // trigger event for all inactive inputs
unsigned int act_inputs = 0;        // variable of the number of active inputs

unsigned int i;                     // counter
unsigned int CountTime = 0;         // counter for the time of pressed buttons
unsigned int MaxCountTime = 40;     //  Number of CountTime periods before running a long pression action for example : 40 * 40 = 1600 ms + execution time
unsigned char presstype[7];			// short press , long press or realease


// following pins assignation is probably good only for Orange Pi Zero Plus 2
unsigned int OpiPinsAvailable[] = {3, 5, 7, 8, 10, 11, 12, 13, 15, 16, 18, 19, 21, 22, 23, 24, 26}; // physical pins
unsigned int WpiPinsAvailable[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}; // wiringPi pins


// === FONCTIONS ===

// Find the physical PIN on opi from selected wiringPi pin
unsigned int find_OpiPin(unsigned int WpiPin )
{
  int j;
  for (j = 0; j < 17; j++)    // We loop through all the pins to find the correct PIN
  {

    if (WpiPin == WpiPinsAvailable[j])
    {
      return OpiPinsAvailable[j];
    }
  }

}


// Function of starting an external process
void run_script(unsigned int act_butt_num, unsigned char ActionType[] )
{
  printf("  =============    Action : %s from WPI pin %d (physical pin %d)    =============\n", ActionType, WpiPinsSelection[i], find_OpiPin(WpiPinsSelection[i]));
  unsigned char command[50];
  sprintf(command, "%s" "%s" "%u" "%s" "%s", script_path, "run", act_butt_num, ActionType, ".sh");  // Create command
  system (command);                 // Run the child process
  return;
}

 // GPIO initialization function
void init_gpio()
{
  wiringPiSetup();              // Select the output numbering system - wiringPi, look at the output wPi column gpio readall
  for (i = 0; i < nums; i++)    // We loop through all the pins and set each parameter
  {
    printf("init WiringOP GPIO %d - Physical Opi PC Pinout : %d \n", WpiPinsSelection[i], find_OpiPin(WpiPinsSelection[i]));
    pinMode(WpiPinsSelection[i], INPUT);            // Set the port function to input
    pullUpDnControl(WpiPinsSelection[i], PUD_UP);  // Connect the pull-up extension.  resistor from the power bus
  }
  return;
}

 // Input polling function
void scan_inputs()
{
  act_inputs = 0;                             // Reset the active input counter
  for (i = 0; i < nums; i++)                  // We loop through all the inputs
  {
    curr_state[i] = digitalRead(WpiPinsSelection[i]);    // Record the state of each entry in the array of current states
    /*  // For debugging !
        printf("i : %d", i);
        printf("       Pin: %d", WpiPinsSelection[i]);
        printf("       Oldstate: %d", old_state[i]);
        printf("       State: %d\n", curr_state[i]);*/

    if (curr_state[i] == 0)                 // If the input is active - the increment of the counter
    {
      act_inputs++;
      //      printf("act_input: %u\n" ,  act_inputs);
    }
  }
  //printf("-----\n");
  return;
}

 // Function of copying state arrays from new to old
void copy_states()
{
  for (i = 0; i < nums; i++)
  {
    old_state[i] = curr_state[i];
  }
  return;
}

 // Initialize the previous state array
 // After startup, no input is active
void old_state_init()
{
  for (i = 0; i < nums; i++)
  {
    old_state[i] = 1;
  }
  return;
}


 // Function of comparing states and performing actions - the logic of actions
void logic()
{
  if (act_inputs == 0)   // === If there are no active inputs ...
  {

    for (i = 0; i < nums; i++)
    {
      // if state is now desactivated
      if (curr_state[i] == 1 && old_state[i] == 0)
      {
        printf("      ----- info : PIN %d has been activate during %d periods -----   \n", WpiPinsSelection[i], CountTime);
        if (CountTime < MaxCountTime)
        {
          //    unsigned char command[50];
          //printf("short press released on PIN %d\n",WpiPinsSelection[i] );
          run_script(WpiPinsSelection[i], "release");
          //    sprintf(command, "%s" "%s" "%u" "%s", script_path, "run", act_butt_num, ".sh");  // Forme la commande en tant que texte
          //  system (command);                 // Exécute le processus fils
        }
      }

    }

    copy_states();
    CountTime = 0 ;
    if (trigg_0 == 1)     // ... and if the inactivity event trigger is set ...
    {
      return;          // ... complete the function
    }
    else                 // ... otherwise cock the trigger and execute the zero-action script
    {
      trigg_0 = 1; // ...
      // run_script(0);
      return;
    }
  }
  else if (act_inputs > 1)     // === If there are more than two active inputs - update the state and exit
  {
    printf("act_inputs > 1");

    return;
  }
  else if (act_inputs == 1)    // === If there is one active input - start comparison
  {
    trigg_0 = 0;             // Reset the Zero Activity Trigger
    for (i = 0; i < nums; i++)
    {
      // if state changed in activated state
      if (curr_state[i] == 0 && old_state[i] == 1)
      {

        old_state[i] = curr_state[i];
        run_script(WpiPinsSelection[i], "short");
      }
      // if state is desactivated
      else if (curr_state[i] == 1 && old_state[i] == 0)
      {
        old_state[i] = curr_state[i];
        printf("Never Ever ! Never Ever ! Never Ever ! Never Ever ! Never Ever !");
      }
      else if (curr_state[i] == 0 && old_state[i] == 0)
      {
        CountTime++;
        if (CountTime == MaxCountTime)
        {
          //    printf("Long Press from %d !!!!!     ----->    ", WpiPinsSelection[i]);
          run_script(WpiPinsSelection[i], "long");
        }
      }
    }
    return;

  }
}


 // === Controller ===
int main(void)
{
  //  printf ("start\n"); // debug

  init_gpio();      // Initialize GPIO
  old_state_init(); // Initial initialization of the array of old states
  scan_inputs();    // We make the first poll of the inputs
  while (1)
  {
    logic();             // process states and perform actions
    scan_inputs();       // scan the inputs
    delay (delay_time);  // delay between polls
  }
  return 0;
}