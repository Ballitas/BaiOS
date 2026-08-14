import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Core
import qs.Components.Control

PanelWindow {
    id: control

    readonly property bool open: AppState.controlOpen

    // Keep window mapped during slide-up / fade-in animation
    visible: open || (translation.y < 30)

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

    Rectangle {
        id: contentContainer
        anchors.fill: parent
        
        // Curated dark gradient background for premium feel
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#141414" }
            GradientStop { position: 1.0; color: "#0a0a0a" }
        }
        
        // Crisp thin white border
        border.color: "#33ffffff"
        border.width: 1
        opacity: AppState.controlOpen ? 1.0 : 0.0
        
        radius: 16
        clip: true

        transform: Translate {
            id: translation
            y: AppState.controlOpen ? 0 : 30
            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutQuad
            }
        }

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
