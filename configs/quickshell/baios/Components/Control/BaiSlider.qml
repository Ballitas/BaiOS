import QtQuick
import qs.Core

Item {
    id: root

    property string label: "VALUE"
    property real value: 0.5

    signal valueChangedByUser(real value)

    width: 300
    height: 72

    Text {
        anchors {
            left: parent.left
            top: parent.top
        }

        text: root.label

        color: AppState.colorTextActive

        font {
            family: AppState.fontUi
            pixelSize: 12
            bold: true
        }
    }

    Text {
        anchors {
            right: parent.right
            top: parent.top
        }

        text: Math.round(root.value * 100) + "%"

        color: AppState.colorTextActive
        opacity: 0.55

        font {
            family: AppState.fontMono
            pixelSize: 11
        }
    }

    Rectangle {
        id: track

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 14
        }

        height: 4
        color: AppState.colorPillBg

        Rectangle {
            width: track.width * root.value
            height: parent.height
            color: AppState.colorTextActive
        }

        Rectangle {
            width: 14
            height: 14
            radius: 7

            x: Math.max(
                0,
                Math.min(
                    track.width - width,
                    (track.width * root.value) - width / 2
                )
            )

            anchors.verticalCenter: parent.verticalCenter

            color: AppState.colorTextActive
        }

        MouseArea {
            anchors.fill: parent

            onPressed: mouse => updateValue(mouse.x)
            onPositionChanged: mouse => {
                if (pressed)
                    updateValue(mouse.x);
            }

            function updateValue(xPos) {
                root.value = Math.max(
                    0,
                    Math.min(1, xPos / track.width)
                );

                root.valueChangedByUser(root.value);
            }
        }
    }
}
