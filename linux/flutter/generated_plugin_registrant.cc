//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_linux/audioplayers_linux_plugin.h>
#include <file_selector_linux/file_selector_plugin.h>
#include <irondash_engine_context/irondash_engine_context_plugin.h>
#include <media_kit_libs_linux/media_kit_libs_linux_plugin.h>
#include <media_kit_video/media_kit_video_plugin.h>
#include <super_native_extensions/super_native_extensions_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
    g_autoptr(FlPluginRegistrar)
    audioplayers_linux_registrar =
            fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
    audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
    g_autoptr(FlPluginRegistrar)
    file_selector_linux_registrar =
            fl_plugin_registry_get_registrar_for_plugin(registry, "FileSelectorPlugin");
    file_selector_plugin_register_with_registrar(file_selector_linux_registrar);
    g_autoptr(FlPluginRegistrar)
    irondash_engine_context_registrar =
            fl_plugin_registry_get_registrar_for_plugin(registry, "IrondashEngineContextPlugin");
    irondash_engine_context_plugin_register_with_registrar(irondash_engine_context_registrar);
    g_autoptr(FlPluginRegistrar)
    media_kit_libs_linux_registrar =
            fl_plugin_registry_get_registrar_for_plugin(registry, "MediaKitLibsLinuxPlugin");
    media_kit_libs_linux_plugin_register_with_registrar(media_kit_libs_linux_registrar);
    g_autoptr(FlPluginRegistrar)
    media_kit_video_registrar =
            fl_plugin_registry_get_registrar_for_plugin(registry, "MediaKitVideoPlugin");
    media_kit_video_plugin_register_with_registrar(media_kit_video_registrar);
    g_autoptr(FlPluginRegistrar)
    super_native_extensions_registrar =
            fl_plugin_registry_get_registrar_for_plugin(registry, "SuperNativeExtensionsPlugin");
    super_native_extensions_plugin_register_with_registrar(super_native_extensions_registrar);
    g_autoptr(FlPluginRegistrar)
    url_launcher_linux_registrar =
            fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
    url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
