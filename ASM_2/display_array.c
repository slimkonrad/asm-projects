
#include <stdio.h>

void display_array(double array[], int array_length)
{
//loop through array until each value in array has been printed for user to see
    for (int i = 0; i < array_length; i++)
    {
        printf("%1.5f  ", array[i]);
    }
    printf("\n");
}