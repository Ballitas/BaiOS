pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: state

    property bool hubOpen: false
    property int currentSection: 0
    property real ringRotation: 0

    readonly property var sections: [
    {
        name: "APPS",
        items: [
            {
                name: "Firefox",
                command: ["firefox"]
            },
            {
                name: "Files",
                command: ["thunar"]
            },
            {
                name: "Steam",
                command: ["steam"]
            },
            {
                name: "Terminal",
                command: ["kitty"]
            }
        ]
    },
    {
        name: "GAMES",
        items: [
            {
                name: "Steam",
                command: ["steam"]
            },
            {
                name: "Heroic",
                command: ["heroic"]
            },
            {
                name: "Lutris",
                command: ["lutris"]
            }
        ]
    },
    {
        name: "DEVELOPMENT",
        items: [
            {
                name: "Visual Studio Code",
                command: ["code"]
            },
            {
                name: "Terminal",
                command: ["kitty"]
            },
            {
                name: "GitHub",
                command: ["firefox", "https://github.com"]
            }
        ]
    },
    {
        name: "SYSTEM",
        items: [
            {
                name: "Files",
                command: ["thunar"]
            },
            {
                name: "Network",
                command: ["nm-connection-editor"]
            },
            {
                name: "Audio",
                command: ["pavucontrol"]
            },
            {
                name: "Bluetooth",
                command: ["blueman-manager"]
            }
        ]
    },
    {
        name: "POWER",
        items: [
            {
                name: "Lock",
                command: ["hyprlock"]
            },
            {
                name: "Suspend",
                command: ["systemctl", "suspend"]
            },
            {
                name: "Restart",
                command: ["systemctl", "reboot"]
            },
            {
                name: "Shut Down",
                command: ["systemctl", "poweroff"]
            }
        ]
    }
]

    readonly property var activeSection: sections[currentSection]
    readonly property string sectionName: activeSection.name
    readonly property var sectionItems: activeSection.items

    function openHub(): void {
        if (hubOpen)
            return;

        hubOpen = true;
        ringRotation += 180;
    }

    function closeHub(): void {
        if (!hubOpen)
            return;

        hubOpen = false;
        ringRotation -= 180;
    }

    function toggleHub(): void {
        if (hubOpen)
            closeHub();
        else
            openHub();
    }

    function nextSection(): void {
        currentSection = (currentSection + 1) % sections.length;
        ringRotation += 45;
    }

    function previousSection(): void {
        currentSection =
            (currentSection - 1 + sections.length) % sections.length;

        ringRotation -= 45;
    }
    function launch(item): void {
    if (!item || !item.command)
        return;

    Quickshell.execDetached(item.command);
    closeHub();
}
}
