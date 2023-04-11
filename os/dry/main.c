/*
 * dry (Don't Repeat Yourself)
 *
 * Usage: `dry 300`
 *
 * Sets the key repeat interval without requiring a logout.
 * from: https://github.com/wincent/wincent/
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <IOKit/hidsystem/event_status_driver.h>

int main(int argc, const char * argv[]) {
    NXEventHandle handle;
    double interval = 0 ;
    double ori_interval = 0 ;
    if (argc != 2) {
        printf("Expected 1 argument (key repeat in seconds); got %d\n", argc - 1);
        return EXIT_FAILURE;
    }

    handle = NXOpenEventStatus();
    if (!handle) {
        perror("NXOpenEventStatus");
        return EXIT_FAILURE;
    }

    interval = NXKeyRepeatInterval(handle);
    /* printf("Old interval: %lf\n", interval); */
    ori_interval = interval;

    sscanf(argv[1], "%lf", &interval);
    /* printf("New interval: %lf\n", interval); */

    /* printf("%lf\n", ori_interval); */
    /* printf("%lf\n", interval); */
    /* printf("%lf\n", fabs(ori_interval - interval)); */
    NXSetKeyRepeatInterval(handle, interval);
    if (fabs(ori_interval - interval) <= 0.001){

        printf("same\n");
    }
    else{
        printf("updated\n");
        return 1;
    }

    return 0;
}
