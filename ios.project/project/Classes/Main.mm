#include <stdio.h>
#include "vr/gvr/capi/include/gvr.h"

extern "C" const char *hxRunLibrary();
extern "C" void hxcpp_set_top_of_stack();

extern "C" int SDL_main(int argc, char *argv[]) {

    hxcpp_set_top_of_stack();
    
    gvr_context* _c = gvr_create();

    const char *err = NULL;
    err = hxRunLibrary();

    if (err) {
        printf(" Error %s\n", err );
        return -1;
    }

    return 0;
}
