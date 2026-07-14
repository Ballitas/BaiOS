import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Core
import qs.Components

PanelWindow {
    id: root

    visible: AppState.hubOpen
    focusable: true

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus:
        AppState.hubOpen
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

    Rectangle {
        id: background

        anchors.fill: parent
        color: "#000000"
        focus: AppState.hubOpen

        Keys.onEscapePressed: event => {
            AppState.closeHub();
            event.accepted = true;
        }

        Keys.onUpPressed: event => {
            AppState.previousSection();
            event.accepted = true;
        }

        Keys.onDownPressed: event => {
            AppState.nextSection();
            event.accepted = true;
        }

        Connections {
            target: AppState

            function onHubOpenChanged(): void {
                if (AppState.hubOpen)
                    background.forceActiveFocus();
            }
        }

        BaiPanel {
            id: panel

            height: parent.height
            anchors.left: parent.left
        }

        BaiCore {
            anchors {
                left: panel.right
                leftMargin: -72
                verticalCenter: parent.verticalCenter
            }
        }

        Text {
            anchors {
                left: panel.right
                leftMargin: 140
                verticalCenter: parent.verticalCenter
            }

            text: AppState.sectionName
            color: "#FFFFFF"
            opacity: 0.09

            font {
                family: "Anton"
                pixelSize: AppState.sectionName === "DEVELOPMENT" ? 92 : 144
            }
        }

        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 56
            }

            spacing: 12

            Repeater {
                model: AppState.sections.length

                delegate: Rectangle {
                    required property int index

                    width: index === AppState.currentSection ? 32 : 8
                    height: 8

                    color: index === AppState.currentSection
                        ? "#FFFFFF"
                        : "#444444"

                    Behavior on width {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 180
                        }
                    }
                }
            }
        }

        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 24
            }

            text: "SCROLL OR USE ↑ ↓ TO NAVIGATE"
            color: "#444444"

            font {
                family: "JetBrains Mono"
                pixelSize: 11
                letterSpacing: 2
            }
        }
    }
}
