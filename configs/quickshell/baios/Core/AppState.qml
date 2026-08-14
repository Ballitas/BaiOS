pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: state

    property bool hubOpen: false
    property int currentSection: 0
    property int currentItem: 0
    property real ringRotation: 0

    // Monochromatic Theme Variables
    readonly property color colorBgStart: "#0a0a0a"
    readonly property color colorBgEnd: "#020202"
    readonly property color colorPanelStart: "#141414"
    readonly property color colorPanelEnd: "#0a0a0a"
    readonly property color colorPillBg: "#262626"
    readonly property color colorPillBorder: "#3a3a3a"
    readonly property color colorTextActive: "#ffffff"
    readonly property color colorTextInactive: "#666666"
    readonly property color colorAccent: "#ffffff"
    readonly property string fontBase: "Noto Sans, Inter, Roboto, Helvetica, sans-serif"
    readonly property string fontHeader: "Anton, Montserrat, Arial, sans-serif"
    readonly property string fontMono: "JetBrains Mono, Fira Code, Courier New, monospace"

    property var customApps: []

    property var sections: [
        {
            name: "ALL",
            items: state.customApps
        },
        {
            name: "APPS",
            items: [
                { name: "Firefox", command: ["firefox"] },
                { name: "Files", command: ["thunar"] },
                { name: "Steam", command: ["steam"] },
                { name: "Terminal", command: ["kitty"] }
            ]
        },
        {
            name: "GAMES",
            items: [
                { name: "Steam", command: ["steam"] },
                { name: "Heroic", command: ["heroic"] },
                { name: "Lutris", command: ["lutris"] }
            ]
        },
        {
            name: "DEVELOPMENT",
            items: [
                { name: "Visual Studio Code", command: ["code"] },
                { name: "Terminal", command: ["kitty"] },
                {
                    name: "GitHub",
                    command: ["firefox", "https://github.com"]
                }
            ]
        },
        {
            name: "SYSTEM",
            items: [
                { name: "Files", command: ["thunar"] },
                {
                    name: "Network",
                    command: ["nm-connection-editor"]
                },
                { name: "Audio", command: ["pavucontrol"] },
                {
                    name: "Bluetooth",
                    command: ["blueman-manager"]
                }
            ]
        },
        {
            name: "POWER",
            items: [
                { name: "Lock", command: ["hyprlock"] },
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

    property string searchQuery: ""

    readonly property var activeSection: sections[currentSection]
    readonly property string sectionName: activeSection.name
    readonly property var sectionItems: {
        var items = activeSection.items;
        if (searchQuery === "")
            return items;

        var query = searchQuery.toLowerCase();
        var filtered = [];
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item && item.name && item.name.toLowerCase().indexOf(query) !== -1) {
                filtered.push(item);
            }
        }
        return filtered;
    }

    onSectionItemsChanged: {
        if (currentItem >= sectionItems.length) {
            currentItem = 0;
        }
    }

    onCurrentSectionChanged: {
        searchQuery = "";
    }

    property bool controlOpen: false

    function toggleControl(): void {
        controlOpen = !controlOpen;

        if (controlOpen)
            closeHub();
    }

    function closeControl(): void {
        controlOpen = false;
    }

    function openHub(): void {
        if (hubOpen)
            return;

        hubOpen = true;
        ringRotation += 180;
        closeControl();
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
        currentItem = 0;
        ringRotation += 45;
    }

    function previousSection(): void {
        currentSection =
            (currentSection - 1 + sections.length) % sections.length;

        currentItem = 0;
        ringRotation -= 45;
    }

    function nextItem(): void {
        if (sectionItems.length === 0)
            return;

        currentItem = (currentItem + 1) % sectionItems.length;
    }

    function previousItem(): void {
        if (sectionItems.length === 0)
            return;

        currentItem =
            (currentItem - 1 + sectionItems.length)
            % sectionItems.length;
    }

    function launchCurrent(): void {
        if (sectionItems.length === 0)
            return;

        launch(sectionItems[currentItem]);
    }

    function launch(item): void {
        if (!item || !item.command)
            return;

        Quickshell.execDetached(item.command);
        closeHub();
    }

    Process {
        id: appLoader
        command: ["python3", Quickshell.shellDir + "/Core/get_apps.py"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var apps = JSON.parse(this.text);
                    if (apps && apps.length > 0) {
                        state.customApps = apps;
                    }
                } catch(e) {
                    console.log("Failed to load applications: " + e);
                }
            }
        }
    }
}
