//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <awesome_notifications/awesome_notifications_plugin.h>
#include <awesome_notifications_core/awesome_notifications_core_plugin.h>
#include <emoji_picker_flutter/emoji_picker_flutter_plugin.h>
#include <file_selector_linux/file_selector_plugin.h>
#include <gtk/gtk_plugin.h>
#include <isar_flutter_libs/isar_flutter_libs_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) awesome_notifications_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AwesomeNotificationsPlugin");
  awesome_notifications_plugin_register_with_registrar(awesome_notifications_registrar);
  g_autoptr(FlPluginRegistrar) awesome_notifications_core_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AwesomeNotificationsCorePlugin");
  awesome_notifications_core_plugin_register_with_registrar(awesome_notifications_core_registrar);
  g_autoptr(FlPluginRegistrar) emoji_picker_flutter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "EmojiPickerFlutterPlugin");
  emoji_picker_flutter_plugin_register_with_registrar(emoji_picker_flutter_registrar);
  g_autoptr(FlPluginRegistrar) file_selector_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileSelectorPlugin");
  file_selector_plugin_register_with_registrar(file_selector_linux_registrar);
  g_autoptr(FlPluginRegistrar) gtk_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GtkPlugin");
  gtk_plugin_register_with_registrar(gtk_registrar);
  g_autoptr(FlPluginRegistrar) isar_flutter_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "IsarFlutterLibsPlugin");
  isar_flutter_libs_plugin_register_with_registrar(isar_flutter_libs_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
