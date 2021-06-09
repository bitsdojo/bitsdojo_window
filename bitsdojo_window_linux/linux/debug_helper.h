#ifndef _BDW_DEBUG_HELPER_
#define _BDW_DEBUG_HELPER_

#include <gtk/gtk.h>

namespace bitsdojo_window {

void printWindowStateMask(const char *description, GdkWindowState state);
void printGdkEvent(const char *description, GdkEventType state);

}  // namespace bitsdojo_window

#endif  //_BDW_DEBUG_HELPER_