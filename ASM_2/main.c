#include <stdio.h>

extern double manager();

int main() {
    printf("Welcome to Arrays of Integers\n");
    printf("Bought to you by Konner Rigby\n\n");

    double final_magnitude = manager();

    printf("\nMain received %0.12f, and will keep it for future use.\n", final_magnitude);
    printf("Main will return 0 to the operating system.   Bye.\n");
    printf("============================================================\n");

    return 0;
}