import QtQuick
import Quickshell
import Quickshell.Io

import qs.Core
import qs.Components

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
    }

    BaiHub {}
}
