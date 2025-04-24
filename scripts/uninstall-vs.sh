#!/bin/sh

echo "Uninstall VisualStudio"

sudo rm -rf "/Applications/Visual Studio.app"
rm -rf ~/Library/Caches/VisualStudio
rm -rf ~/Library/Preferences/VisualStudio
rm -rf ~/Library/Preferences/Visual\ Studio
rm -rf ~/Library/Logs/VisualStudio
rm -rf ~/Library/VisualStudio
rm -rf ~/Library/Preferences/Xamarin/
rm -rf ~/Library/Application\ Support/VisualStudio
rm -rf ~/Library/Application\ Support/VisualStudio/7.0/LocalInstall/Addins/

echo "Uninstall Xamarin.Android"

sudo rm -rf /Developer/MonoDroid
rm -rf ~/Library/MonoAndroid
sudo pkgutil --forget com.xamarin.android.pkg
sudo rm -rf /Library/Frameworks/Xamarin.Android.framework

echo "Uninstall Xamarin.iOS"

rm -rf ~/Library/MonoTouch
sudo rm -rf /Library/Frameworks/Xamarin.iOS.framework
sudo rm -rf /Developer/MonoTouch
sudo pkgutil --forget com.xamarin.monotouch.pkg
sudo pkgutil --forget com.xamarin.xamarin-ios-build-host.pkg

echo "Uninstall Xamarin.Mac"

sudo rm -rf /Library/Frameworks/Xamarin.Mac.framework
rm -rf ~/Library/Xamarin.Mac

echo "Uninstall Workbooks and Inspector"

sudo /Library/Frameworks/Xamarin.Interactive.framework/Versions/Current/uninstall

echo "Uninstall the Visual Studio for Mac Installer"

rm -rf ~/Library/Caches/XamarinInstaller/
rm -rf ~/Library/Caches/VisualStudioInstaller/
rm -rf ~/Library/Logs/XamarinInstaller/
rm -rf ~/Library/Logs/VisualStudioInstaller/

echo "Uninstall the Xamarin Profiler"

sudo rm -rf "/Applications/Xamarin Profiler.app"

echo "Finished Uninstallation process."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

current_userid=$(id -u)
if [ $current_userid -ne 0 ]; then
    echo "$(basename "$0") uninstallation script requires superuser privileges to run" >&2
    exit 1
fi

dotnet_pkg_name_suffix="com.microsoft.dotnet"
dotnet_install_root="/usr/local/share/dotnet"
dotnet_path_file="/etc/paths.d/dotnet"
dotnet_tool_path_file="/etc/paths.d/dotnet-cli-tools"

remove_dotnet_pkgs(){
    installed_pkgs=($(pkgutil --pkgs | grep $dotnet_pkg_name_suffix))
    
    for i in "${installed_pkgs[@]}"
    do
        echo "Removing dotnet component - \"$i\"" >&2
        pkgutil --force --forget "$i"
    done
}

remove_dotnet_pkgs
[ "$?" -ne 0 ] && echo "Failed to remove dotnet packages." >&2 && exit 1

echo "Deleting install root - $dotnet_install_root" >&2
rm -rf "$dotnet_install_root"
rm -f "$dotnet_path_file"
rm -f "$dotnet_tool_path_file"

echo "dotnet packages removal succeeded." >&2

sudo rm -rf /Library/Frameworks/Mono.framework
sudo pkgutil --forget com.xamarin.mono-MDK.pkg
sudo rm -rf /etc/paths.d/mono-commands

sudo rm -rf /Developer/MonoDroid
rm -rf ~/Library/MonoAndroid
sudo pkgutil --forget com.xamarin.android.pkg
sudo rm -rf /Library/Frameworks/Xamarin.Android.framework

rm -rf ~/.android

rm -rf ~/Library/MonoTouch
sudo rm -rf /Library/Frameworks/Xamarin.iOS.framework
sudo rm -rf /Developer/MonoTouch
sudo pkgutil --forget com.xamarin.monotouch.pkg
sudo pkgutil --forget com.xamarin.xamarin-ios-build-host.pkg
sudo pkgutil --forget com.xamarin.xamarin.ios.pkg

rm -rf ~/Library/Preferences/com.microsoft.visual-studio-preview.plist

echo "com.microsoft.visual-studio-preview.plist removal succeeded." >&2
sudo /Library/Frameworks/Xamarin.Interactive.framework/Versions/Current/uninstall

sudo rm -rf "/Applications/Xamarin Profiler.app"
rm -rf ~/Library/Caches/XamarinInstaller/
rm -rf ~/Library/Caches/VisualStudioInstaller/
rm -rf ~/Library/Logs/XamarinInstaller/
rm -rf ~/Library/Logs/VisualStudioInstaller/
rm -rf ~/Library/Preferences/Xamarin/
rm -rf "~/Library/Preferences/Visual Studio/"

echo "All completed" >&2
exit 0
