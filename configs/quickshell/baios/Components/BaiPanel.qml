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

    property bool selected: index === AppState.currentItem

    width: 300
    height: 40

    Rectangle {
        anchors.fill: parent
        color: menuItem.selected ? "#222222" : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    Rectangle {
        width: menuItem.selected ? 10 : 0
        height: 3
        color: "#FFFFFF"

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        Behavior on width {
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter

        text: menuItem.modelData.name
        color: "#FFFFFF"

        opacity:
            menuItem.selected || mouseArea.containsMouse
                ? 1.0
                : 0.45

        font {
            family: "Noto Sans"
            pixelSize: menuItem.selected ? 19 : 18
            weight:
                menuItem.selected || mouseArea.containsMouse
                    ? Font.DemiBold
                    : Font.Normal
        }

        transform: Translate {
            x:
                menuItem.selected || mouseArea.containsMouse
                    ? 20
                    : 0

            Behavior on x {
                NumberAnimation {
                    duration: 140
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }

        Behavior on font.pixelSize {
            NumberAnimation {
                duration: 120
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            AppState.currentItem = menuItem.index;
        }

        onClicked: {
            AppState.currentItem = menuItem.index;
            AppState.launch(menuItem.modelData);
        }
    }
}
                }
            }
        }
    

