//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <file_selector_windows/file_selector_windows.h>
#include <gal/gal_plugin_c_api.h>
#include <irondash_engine_context/irondash_engine_context_plugin_c_api.h>
#include <just_audio_windows/just_audio_windows_plugin.h>
#include <media_kit_libs_windows_audio/media_kit_libs_windows_audio_plugin_c_api.h>
#include <media_kit_libs_windows_video/media_kit_libs_windows_video_plugin_c_api.h>
#include <media_kit_video/media_kit_video_plugin_c_api.h>
#include <screen_brightness_windows/screen_brightness_windows_plugin.h>
#include <super_native_extensions/super_native_extensions_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
    AudioplayersWindowsPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
    FileSelectorWindowsRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("FileSelectorWindows"));
    GalPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("GalPluginCApi"));
    IrondashEngineContextPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("IrondashEngineContextPluginCApi"));
    JustAudioWindowsPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("JustAudioWindowsPlugin"));
    MediaKitLibsWindowsAudioPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("MediaKitLibsWindowsAudioPluginCApi"));
    MediaKitLibsWindowsVideoPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("MediaKitLibsWindowsVideoPluginCApi"));
    MediaKitVideoPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("MediaKitVideoPluginCApi"));
    ScreenBrightnessWindowsPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("ScreenBrightnessWindowsPlugin"));
    SuperNativeExtensionsPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("SuperNativeExtensionsPluginCApi"));
    UrlLauncherWindowsRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
