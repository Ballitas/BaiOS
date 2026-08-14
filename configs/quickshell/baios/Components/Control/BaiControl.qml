import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Core
import qs.Components.Control

PanelWindow {
    id: control

    readonly property bool open: AppState.controlOpen

    visible: open

    anchors {
        top: true
        bottom: true
        left: true
    }

    implicitWidth: 380

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus:
        open
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

    Rectangle {
        anchors.fill: parent

        color: "#080808"

        Rectangle {
            anchors.right: parent.right
            width: 1
            height: parent.height

            color: AppState.colorTextActive
            opacity: 0.06
        }

        Column {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 40
            }

            spacing: 28

            Text {
                text: "SYSTEM"

                color: AppState.colorTextActive

                font {
                    family: AppState.fontDisplay
                    pixelSize: 40
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: AppState.colorTextActive
                opacity: 0.08
            }

            BaiSlider {
                label: "AUDIO"
                value: 0.72

                onValueChangedByUser:
                    value => console.log("Audio:", value)
            }

            BaiSlider {
                label: "BRIGHTNESS"
                value: 0.80

                onValueChangedByUser:
                    value => console.log("Brightness:", value)
            }

            Row {
                spacing: 16

                BaiToggle {
                    label: "WI-FI"
                    checked: true

                    onToggled:
                        checked => console.log("WiFi:", checked)
                }

                BaiToggle {
                    label: "BLUETOOTH"

                    onToggled:
                        checked => console.log("Bluetooth:", checked)
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: AppState.colorTextActive
                opacity: 0.08
            }

            Column {
                spacing: 8

                Text {
                    text: "NETWORK"
                    color: AppState.colorTextActive
                    opacity: 0.45

                    font {
                        family: AppState.fontMono
                        pixelSize: 10
                        letterSpacing: 2
                    }
                }

                Text {
                    text: "Connected network"

                    color: AppState.colorTextActive

                    font {
                        family: AppState.fontUi
                        pixelSize: 14
                    }
                }
            }
        }

        Keys.onEscapePressed: event => {
            AppState.closeControl();
            event.accepted = true;
        }
    }
}
