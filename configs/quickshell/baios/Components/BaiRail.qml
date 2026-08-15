import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.Core
import qs.Components

PanelWindow {
    id: rail

    property int collapsedWidth: 72

    anchors {
        top: true
        bottom: true
        left: true
    }

    implicitWidth: collapsedWidth

    color: "transparent"

    // Reserve space so windows don't overlap the panel
    exclusiveZone: implicitWidth

    Rectangle {
        anchors.fill: parent
        color: "#080808"

        // Thin, premium translucent border on the right edge matching BaiPanel
        Rectangle {
            anchors.right: parent.right
            width: 1
            height: parent.height
            color: AppState.colorTextActive
            opacity: 0.06
        }

        /*
         * Top Zone: Access to BaiHub.
         */
        Item {
            id: hubButton

            width: parent.width
            height: 104

            // Polished micro-core icon mirroring the design of BaiCore
            Rectangle {
                id: miniCore

                width: 44
                height: 44
                radius: width / 2
                anchors.centerIn: parent

                color: "transparent"
                border.color: AppState.colorTextActive
                border.width: 1.5
                opacity: hubMouse.containsMouse ? 1.0 : 0.8

                rotation: AppState.hubOpen ? 180 : 0
                scale: hubMouse.containsMouse ? 1.05 : 1.0

                Behavior on rotation {
                    NumberAnimation {
                        duration: 360
                        easing.type: Easing.OutBack
                    }
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 140
                    }
                }

                // Micro spinning inner ring
                Rectangle {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    radius: 13
                    color: "transparent"
                    border.color: AppState.colorTextActive
                    border.width: 1
                    opacity: 0.2

                    NumberAnimation on rotation {
                        from: 0
                        to: 360
                        duration: 8000
                        loops: Animation.Infinite
                    }
                }

                // Micro central pulsing core dot
                Rectangle {
                    anchors.centerIn: parent
                    width: 8
                    height: 8
                    radius: 4
                    color: AppState.colorAccent

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        running: AppState.hubOpen
                        NumberAnimation { to: 1.3; duration: 1200; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 0.7; duration: 1200; easing.type: Easing.InOutSine }
                    }
                }
            }

            MouseArea {
                id: hubMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: AppState.toggleHub()
            }
        }

        // Section separator
        Rectangle {
            anchors {
                top: hubButton.bottom
                left: parent.left
                right: parent.right
                leftMargin: 16
                rightMargin: 16
            }

            height: 2
            color: AppState.colorTextActive
            opacity: 0.2
        }

        /*
         * Middle Zone: Workspace Selector.
         */
        Column {
            id: workspaceColumn

            anchors {
                top: hubButton.bottom
                topMargin: 20
                left: parent.left
                right: parent.right
            }

            spacing: 12

            Repeater {
                model: Hyprland.workspaces

                delegate: Item {
                    id: workspaceItem

                    required property var modelData
                    required property int index

                    readonly property bool validWorkspace:
                        modelData.id > 0 && modelData.id <= 10

                    visible: validWorkspace
                    width: workspaceColumn.width
                    height: validWorkspace ? 44 : 0

                    // Circular workspace number badge
                    Rectangle {
                        id: workspaceNumber

                        width: 36
                        height: 36
                        radius: width / 2
                        anchors.centerIn: parent

                        // Simple and clean styling:
                        // Active: Solid white badge with black text.
                        // Inactive: Transparent background, muted text.
                        // Hover: Subtle pill background highlight.
                        color: modelData.active
                            ? AppState.colorTextActive
                            : workspaceMouse.containsMouse
                                ? AppState.colorPillBg
                                : "transparent"

                        border.color: modelData.active ? "transparent" : AppState.colorPillBorder
                        border.width: modelData.active ? 0 : (workspaceMouse.containsMouse ? 1 : 0)

                        scale: modelData.active ? 1.05 : (workspaceMouse.containsMouse ? 1.02 : 1.0)

                        Behavior on color {
                            ColorAnimation {
                                duration: 140
                            }
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 140
                                easing.type: Easing.OutCubic
                            }
                        }

                        Text {
                            anchors.centerIn: parent

                            text: modelData.id

                            color: modelData.active
                                ? "#000000"
                                : AppState.colorTextActive

                            opacity: modelData.active ? 1.0 : (workspaceMouse.containsMouse ? 0.9 : 0.45)

                            font {
                                family: AppState.fontMono
                                pixelSize: 13
                                bold: modelData.active
                            }

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 140
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 140
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: workspaceMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: modelData.activate()
                    }
                }
            }
        }

        /*
         * Bottom Zone: Static Clock Widget.
         */
        Column {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 24
            }

            spacing: 16

            // Section separator
            Rectangle {
                width: parent.width - 32
                height: 1
                color: AppState.colorTextActive
                opacity: 0.06
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Wallpaper Selector Toggle Button
            Item {
                width: parent.width
                height: 48

                Rectangle {
                    id: wallpaperIcon
                    width: 22
                    height: 16
                    radius: 2
                    anchors.centerIn: parent
                    color: AppState.wallpaperOpen
                        ? AppState.colorTextActive
                        : "transparent"

                    border.color: AppState.colorTextActive
                    border.width: 1.5
                    clip: true

                    scale: wallpaperMouse.pressed 
                        ? 0.8 
                        : (wallpaperMouse.containsMouse ? 1.15 : 1.0)

                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 180
                        }
                    }

                    Rectangle {
                        width: 10
                        height: 10
                        color: AppState.wallpaperOpen ? "#000000" : AppState.colorTextActive
                        rotation: 45
                        x: 2
                        y: 9

                        Behavior on color {
                            ColorAnimation { duration: 180 }
                        }
                    }

                    Rectangle {
                        width: 8
                        height: 8
                        color: AppState.wallpaperOpen ? "#000000" : AppState.colorTextActive
                        rotation: 45
                        x: 10
                        y: 11

                        Behavior on color {
                            ColorAnimation { duration: 180 }
                        }
                    }

                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: AppState.wallpaperOpen ? "#000000" : AppState.colorTextActive
                        x: 14
                        y: 3

                        Behavior on color {
                            ColorAnimation { duration: 180 }
                        }
                    }
                }

                MouseArea {
                    id: wallpaperMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: AppState.toggleWallpaper()
                }
            }

            // Control Panel Toggle Button
            Item {
                width: parent.width
                height: 48

                Rectangle {
                    id: diamondIcon
                    width: 20
                    height: 20
                    anchors.centerIn: parent

                    color: AppState.controlOpen
                        ? AppState.colorTextActive
                        : "transparent"

                    border.color: AppState.colorTextActive
                    border.width: 1

                    // 90-degree spin on toggle
                    rotation: AppState.controlOpen ? 135 : 45
                    
                    // Tactile scale feedback
                    scale: railToggleMouse.pressed 
                        ? 0.8 
                        : (railToggleMouse.containsMouse ? 1.15 : 1.0)

                    Behavior on rotation {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 180
                        }
                    }
                }

                MouseArea {
                    id: railToggleMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: AppState.toggleControl()
                }
            }

            // Elegant, clean, static vertical clock
            Item {
                width: parent.width
                height: 52

                Column {
                    anchors.centerIn: parent
                    spacing: 0

                    Text {
                        id: hourText
                        text: Qt.formatTime(new Date(), "HH")
                        color: AppState.colorTextActive
                        opacity: 0.95
                        font {
                            family: AppState.fontMono
                            pixelSize: 15
                            bold: true
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: minText
                        text: Qt.formatTime(new Date(), "mm")
                        color: AppState.colorTextActive
                        opacity: 0.45
                        font {
                            family: AppState.fontMono
                            pixelSize: 15
                            bold: true
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true

                    onTriggered: {
                        hourText.text = Qt.formatTime(new Date(), "HH");
                        minText.text = Qt.formatTime(new Date(), "mm");
                    }
                }
            }
        }
    }
}
