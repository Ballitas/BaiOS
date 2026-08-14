import QtQuick
import qs.Core

Rectangle {
    id: root

    property string label: "TOGGLE"
    property bool checked: false

    signal toggled(bool checked)

    width: 140
    height: 64

    color: checked
        ? AppState.colorTextActive
        : AppState.colorPillBg

    border.color: checked
        ? "transparent"
        : AppState.colorPillBorder

    border.width: 1

    Behavior on color {
        ColorAnimation {
            duration: 160
        }
    }

    Column {
        anchors {
            left: parent.left
            leftMargin: 16
            verticalCenter: parent.verticalCenter
        }

        spacing: 4

        Text {
            text: root.label
            color: root.checked
                ? "#000000"
                : AppState.colorTextActive

            font {
                family: AppState.fontUi
                pixelSize: 12
                bold: true
            }
        }

        Text {
            text: root.checked ? "ON" : "OFF"

            color: root.checked
                ? "#000000"
                : AppState.colorTextActive

            opacity: 0.45

            font {
                family: AppState.fontMono
                pixelSize: 10
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.checked = !root.checked;
            root.toggled(root.checked);
        }
    }
}
