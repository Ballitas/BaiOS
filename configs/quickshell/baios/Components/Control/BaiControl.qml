import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Core
import qs.Components.Control

PanelWindow {
    id: control

    readonly property bool open: AppState.controlOpen

    // Keep window mapped during slide-out animation
    visible: open || (clipper.width > 0)

    anchors {
        bottom: true
        left: true
    }

    margins {
        left: 80
        bottom: 24
    }

    implicitWidth: 300
    implicitHeight: 400

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus:
        open
            ? WlrKeyboardFocus.OnDemand
            : WlrKeyboardFocus.None

    Item {
        id: clipper
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: open ? control.implicitWidth : 0
        clip: true

        Behavior on width {
            NumberAnimation {
                duration: 280
                easing.type: Easing.OutCubic
            }
        }

        transform: Translate {
            x: open ? 0 : -35
            Behavior on x {
                NumberAnimation {
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }
        }

        opacity: open ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: contentContainer
            width: control.implicitWidth
            height: parent.height
            
            // Curated dark gradient background for premium feel
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#141414" }
                GradientStop { position: 1.0; color: "#0a0a0a" }
            }
            
            // Crisp thin white border
            border.color: "#33ffffff"
            border.width: 1
            
            radius: 16
            clip: true

            Connections {
                target: AppState

                function onControlOpenChanged(): void {
                    if (AppState.controlOpen) {
                        contentContainer.forceActiveFocus();
                    }
                }
            }

            Column {
                anchors {
                    fill: parent
                    margins: 18
                }

                spacing: 14

                Text {
                    text: "SYSTEM"
                    color: AppState.colorTextActive

                    font {
                        family: AppState.fontHeader
                        pixelSize: 18
                        bold: true
                        letterSpacing: 2
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: AppState.colorTextActive
                    opacity: 0.06
                }

                BaiSlider {
                    width: parent.width
                    label: "AUDIO"
                    onValueChangedByUser: value => AppState.setVolume(value)
                    Binding on value { value: AppState.volume }
                }

                BaiSlider {
                    width: parent.width
                    label: "BRIGHTNESS"
                    onValueChangedByUser: value => AppState.setBrightness(value)
                    Binding on value { value: AppState.brightness }
                }

                Row {
                    width: parent.width
                    spacing: 12

                    BaiToggle {
                        width: (parent.width - 12) / 2
                        label: "WI-FI"
                        onToggled: checked => AppState.setWifi(checked)
                        Binding on checked { value: AppState.wifiEnabled }
                    }

                    BaiToggle {
                        width: (parent.width - 12) / 2
                        label: "BLUETOOTH"
                        onToggled: checked => AppState.setBluetooth(checked)
                        Binding on checked { value: AppState.bluetoothEnabled }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: AppState.colorTextActive
                    opacity: 0.06
                }

                Column {
                    spacing: 6

                    Text {
                        text: "NETWORK"
                        color: AppState.colorTextActive
                        opacity: 0.45

                        font {
                            family: AppState.fontMono
                            pixelSize: 9
                            letterSpacing: 1.5
                        }
                    }

                    Text {
                        text: AppState.networkName
                        color: AppState.colorTextActive

                        font {
                            family: AppState.fontBase
                            pixelSize: 13
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
}
