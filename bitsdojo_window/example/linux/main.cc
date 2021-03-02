#include <bitsdojo_window_linux/bitsdojo_window_plugin.h>
auto bdw = bitsdojo_window_configure(BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP);

#include "my_application.h"

int main(int argc, char** argv) {
  g_autopt(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
