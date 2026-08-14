import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.Core
import qs.Components
import qs.Components.Control

ShellRoot {
    IpcHandler {
        target: "baihub"

        function open(): void {
            AppState.openHub();
        }

        function close(): void {
            AppState.closeHub();
        }

        function toggle(): void {
            AppState.toggleHub();
        }

        function next(): void {
            AppState.nextSection();
        }

        function previous(): void {
            AppState.previousSection();
        }

        function isOpen(): bool {
            return AppState.hubOpen;
        }

        function currentSection(): string {
            return AppState.sectionName;
        }

        function toggleControl(): void {
            AppState.toggleControl();
        }
    }

    BaiHub {}
    BaiControl {}
    
    Variants {
        model: Quickshell.screens

        delegate: Component {
            BaiRail {
                required property var modelData
                screen: modelData
            }
        }
    }

    // Software Brightness Overlay for all screens
    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                required property var modelData
                screen: modelData

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                color: "transparent"
                focusable: false
                exclusionMode: ExclusionMode.Ignore
                
                mask: Region {} // Completely input-transparent (click-through)
                
                WlrLayershell.layer: WlrLayer.Overlay // Draw on top of all windows

                Rectangle {
                    anchors.fill: parent
                    color: "#000000"
                    opacity: 1.0 - AppState.brightness
                }
            }
        }
    }
}
