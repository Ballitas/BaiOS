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
                "Firefox",
                "Files",
                "Steam",
                "Terminal"
            ]
        },
        {
            name: "GAMES",
            items: [
                "Steam",
                "Heroic",
                "Lutris",
                "Emulators"
            ]
        },
        {
            name: "DEVELOPMENT",
            items: [
                "Visual Studio Code",
                "Terminal",
                "GitHub",
                "Docker"
            ]
        },
        {
            name: "SYSTEM",
            items: [
                "Settings",
                "Files",
                "Network",
                "Bluetooth"
            ]
        },
        {
            name: "POWER",
            items: [
                "Lock",
                "Suspend",
                "Restart",
                "Shut Down"
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
}
