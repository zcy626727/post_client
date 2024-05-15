//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <file_selector_windows/file_selector_windows.h>
#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <gal/gal_plugin_c_api.h>
#include <irondash_engine_context/irondash_engine_context_plugin_c_api.h>
#include <just_audio_windows/just_audio_windows_plugin.h>
#include <livekit_client/live_kit_plugin.h>
#include <media_kit_libs_windows_video/media_kit_libs_windows_video_plugin_c_api.h>
#include <media_kit_video/media_kit_video_plugin_c_api.h>
#include <screen_brightness_windows/screen_brightness_windows_plugin.h>
#include <super_native_extensions/super_native_extensions_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
    AudioplayersWindowsPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
    ConnectivityPlusWindowsPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
    FileSelectorWindowsRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("FileSelectorWindows"));
    FlutterWebRTCPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("FlutterWebRTCPlugin"));
    GalPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("GalPluginCApi"));
    IrondashEngineContextPluginCApiRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("IrondashEngineContextPluginCApi"));
    JustAudioWindowsPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("JustAudioWindowsPlugin"));
    LiveKitPluginRegisterWithRegistrar(
            registry->GetRegistrarForPlugin("LiveKitPlugin"));
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
