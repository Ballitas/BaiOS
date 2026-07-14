import QtQuick
import qs.Core

Item {
    id: root

    width: 144
    height: 144
    rotation: AppState.ringRotation

    Behavior on rotation {
        NumberAnimation {
            duration: 360
            easing.type: Easing.OutBack
        }
    }

    scale: mouseArea.containsMouse ? 1.04 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: 140
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent

        radius: width / 2
        color: "#000000"
        border.color: "#FFFFFF"
        border.width: 5
    }

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
        id: mouseArea

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
