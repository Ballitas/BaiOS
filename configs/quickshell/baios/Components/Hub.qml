import QtQuick
import Quickshell
import Quickshell.Wayland
import "../Core"

PanelWindow {
    id: hubWindow

    visible: AppState.hubOpen

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: true

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

        /*
         * Texto gigante decorativo de la sección.
         */
        Text {
            id: giantTitle

            anchors {
                left: sidePanel.right
                leftMargin: 140
                verticalCenter: parent.verticalCenter
            }

            text: AppState.sectionName
            color: "#FFFFFF"
            opacity: 0.09

            font {
                family: "Anton"
                pixelSize: AppState.sectionName === "DEVELOPMENT" ? 92 : 144
                bold: true
            }

            Behavior on opacity {
                SequentialAnimation {
                    NumberAnimation {
                        to: 0
                        duration: 80
                    }

                    NumberAnimation {
                        to: 0.09
                        duration: 180
                    }
                }
            }
        }

        /*
         * Panel izquierdo.
         */
        Rectangle {
            id: sidePanel

            width: 420
            height: parent.height
            color: "#111111"
            clip: true

            Column {
                anchors {
                    left: parent.left
                    leftMargin: 64
                    top: parent.top
                    topMargin: 112
                    right: parent.right
                    rightMargin: 48
                }

                spacing: 24

                Text {
                    text: AppState.sectionName
                    color: "#FFFFFF"

                    font {
                        family: "Anton"
                        pixelSize: AppState.sectionName === "DEVELOPMENT" ? 36 : 48
                    }
                }

                Rectangle {
                    width: 256
                    height: 2
                    color: "#444444"
                }

                Item {
                    width: 1
                    height: 8
                }

                Repeater {
                    model: AppState.sectionItems

                    delegate: Item {
                        id: menuItem

                        required property string modelData
                        required property int index

                        width: 300
                        height: 38

                        Text {
                            anchors.verticalCenter: parent.verticalCenter

                            text: menuItem.modelData
                            color: "#FFFFFF"
                            opacity: itemMouse.containsMouse ? 1.0 : 0.62

                            font {
                                family: "Noto Sans"
                                pixelSize: 18
                                weight: itemMouse.containsMouse
                                    ? Font.Medium
                                    : Font.Normal
                            }

                            transform: Translate {
                                x: itemMouse.containsMouse ? 12 : 0

                                Behavior on x {
                                    NumberAnimation {
                                        duration: 130
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 120
                                }
                            }
                        }

                        MouseArea {
                            id: itemMouse

                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                console.log(
                                    "Selected:",
                                    AppState.sectionName,
                                    menuItem.modelData
                                );
                            }
                        }
                    }
                }
            }
        }

        /*
         * BaiCore: el anillo.
         */
        Item {
            id: ringContainer

            width: 144
            height: 144
            rotation: AppState.ringRotation

            anchors {
                left: sidePanel.right
                leftMargin: -72
                verticalCenter: parent.verticalCenter
            }

            Behavior on rotation {
                NumberAnimation {
                    duration: 360
                    easing.type: Easing.OutBack
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "#000000"
                border.color: "#FFFFFF"
                border.width: 5
            }

            /*
             * Marca diagonal del anillo.
             */
            Rectangle {
                width: 44
                height: 8
                color: "#FFFFFF"

                anchors {
                    right: parent.right
                    rightMargin: -12
                    verticalCenter: parent.verticalCenter
                }

                transform: Rotation {
                    origin.x: 0
                    origin.y: 4
                    angle: -20
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: AppState.toggleHub()

                onWheel: wheel => {
                    if (wheel.angleDelta.y < 0)
                        AppState.nextSection();
                    else
                        AppState.previousSection();

                    wheel.accepted = true;
                }
            }
        }

        /*
         * Indicadores de las secciones.
         */
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
