import QtQuick
import qs.Core

Rectangle {
    id: root

    width: 420
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

                required property var modelData
                required property int index

                width: 300
                height: 40

                Text {
                    anchors.verticalCenter: parent.verticalCenter

                    text: menuItem.modelData.name
                    color: "#FFFFFF"
                    opacity: mouseArea.containsMouse ? 1.0 : 0.62

                    font {
                        family: "Noto Sans"
                        pixelSize: 18
                        weight: mouseArea.containsMouse
                            ? Font.Medium
                            : Font.Normal
                    }

                    transform: Translate {
                        x: mouseArea.containsMouse ? 12 : 0

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
                    id: mouseArea

                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
    AppState.launch(menuItem.modelData);
}
                }
            }
        }
    }
}
