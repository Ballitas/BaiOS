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

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: panel.width
        opacity: AppState.hubOpen ? 1.0 : 0.0
        color: "#080808"

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

Keys.onUpPressed: event => {
    AppState.previousItem();
    event.accepted = true;
}

Keys.onDownPressed: event => {
    AppState.nextItem();
    event.accepted = true;
}

Keys.onLeftPressed: event => {
    AppState.previousSection();
    event.accepted = true;
}

Keys.onRightPressed: event => {
    AppState.nextSection();
    event.accepted = true;
}

Keys.onReturnPressed: event => {
    AppState.launchCurrent();
    event.accepted = true;
}

Keys.onEnterPressed: event => {
    AppState.launchCurrent();
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

    transform: Translate {
        x: AppState.hubOpen ? 0 : -panel.width

        Behavior on x {
            NumberAnimation {
                duration: 320
                easing.type: Easing.OutCubic
            }
        }
    }
}

        BaiCore {
            id: baiCore
            width: 180
            height: 180

            x: -90 // center is exactly on the left screen edge
            anchors.verticalCenter: parent.verticalCenter

            opacity: AppState.hubOpen ? 1.0 : 0.0
            scale: AppState.hubOpen ? 1.0 : 0.82

            transform: Translate {
                x: AppState.hubOpen ? 0 : -96

                Behavior on x {
                    NumberAnimation {
                        duration: 360
                        easing.type: Easing.OutBack
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 180
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutBack
                }
            }
        }

        // Giant vertical Section Name text outline centered on the right border of the panel
        Column {
            id: verticalSectionName
            anchors {
                horizontalCenter: panel.right
                verticalCenter: parent.verticalCenter
            }

            property string displayedText: AppState.sectionName
            property real slideX: AppState.hubOpen ? 0 : -120

            transform: Translate {
                x: verticalSectionName.slideX
            }

            Behavior on slideX {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
            
            // Dynamic size and spacing depending on word length to always look as large as possible
            property int lettersCount: displayedText.length
            property real letterSize: {
                if (lettersCount <= 4) return 100;
                else if (lettersCount == 5) return 90;
                else if (lettersCount <= 7) return 76;
                else return 52;
            }
            spacing: {
                if (lettersCount <= 4) return 24;
                else if (lettersCount == 5) return 20;
                else if (lettersCount <= 7) return 14;
                else return 8;
            }

            Repeater {
                model: verticalSectionName.lettersCount
                delegate: Item {
                    id: letterItem
                    required property int index

                    width: dummyText.width
                    height: dummyText.height

                    Text {
                        id: dummyText
                        visible: false
                        text: verticalSectionName.displayedText.charAt(letterItem.index)
                        font {
                            family: AppState.fontMono
                            pixelSize: verticalSectionName.letterSize
                            weight: Font.Bold
                        }
                    }

                    // Multi-layer outline drawing to simulate a thicker border (approx. 2px-3px thick)
                    Text { x: -1; y: -1; text: dummyText.text; color: "transparent"; style: Text.Outline; styleColor: "#ffffff"; font: dummyText.font }
                    Text { x: 1; y: -1; text: dummyText.text; color: "transparent"; style: Text.Outline; styleColor: "#ffffff"; font: dummyText.font }
                    Text { x: -1; y: 1; text: dummyText.text; color: "transparent"; style: Text.Outline; styleColor: "#ffffff"; font: dummyText.font }
                    Text { x: 1; y: 1; text: dummyText.text; color: "transparent"; style: Text.Outline; styleColor: "#ffffff"; font: dummyText.font }
                    Text { x: 0; y: 0; text: dummyText.text; color: "transparent"; style: Text.Outline; styleColor: "#ffffff"; font: dummyText.font }

                    opacity: AppState.hubOpen ? 1.0 : 0.0
                    transform: Translate {
                        x: AppState.hubOpen ? 0 : -20
                        Behavior on x {
                            SequentialAnimation {
                                PauseAnimation { duration: AppState.hubOpen ? letterItem.index * 45 : 0 }
                                NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                            }
                        }
                    }

                    Behavior on opacity {
                        SequentialAnimation {
                            PauseAnimation { duration: AppState.hubOpen ? letterItem.index * 45 : 0 }
                            NumberAnimation { duration: 300 }
                        }
                    }
                }
            }

            Connections {
                target: AppState

                function onSectionNameChanged(): void {
                    sectionChangeAnim.restart();
                }
            }

            SequentialAnimation {
                id: sectionChangeAnim

                ParallelAnimation {
                    NumberAnimation {
                        target: verticalSectionName
                        property: "opacity"
                        to: 0.0
                        duration: 180
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: verticalSectionName
                        property: "slideX"
                        to: -120
                        duration: 180
                        easing.type: Easing.OutQuad
                    }
                }

                PropertyAction {
                    target: verticalSectionName
                    property: "displayedText"
                    value: AppState.sectionName
                }

                ParallelAnimation {
                    NumberAnimation {
                        target: verticalSectionName
                        property: "opacity"
                        to: 1.0
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: verticalSectionName
                        property: "slideX"
                        to: 0
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        // Background section container removed to keep center screen clean

        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 56
            }

            spacing: 10

            Repeater {
                model: AppState.sections.length

                delegate: Rectangle {
                    required property int index

                    width: index === AppState.currentSection ? 36 : 6
                    height: 6
                    radius: 3

                    color: index === AppState.currentSection
                        ? AppState.colorTextActive
                        : AppState.colorTextInactive

                    opacity: index === AppState.currentSection ? 0.9 : 0.3

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
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
            color: AppState.colorTextInactive
            opacity: AppState.hubOpen ? 0.5 : 0.0

            font {
                family: AppState.fontMono
                pixelSize: 10
                letterSpacing: 2
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }
    }
}
