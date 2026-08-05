import QtQuick
import QtQuick.Shapes
import qs.Core

Item {
    id: root

    width: 180
    height: 180

    // Core scale feedback on hover
    scale: mouseArea.containsMouse ? 1.05 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    // 1. Five Pie-slice Segments for Sections (Right Semi-circle)
    Repeater {
        model: AppState.sections.length

        delegate: Item {
            id: segmentDelegate
            required property int index
            anchors.fill: parent

            Shape {
                id: segmentShape
                anchors.fill: parent
                layer.enabled: true
                layer.samples: 4 // Anti-aliasing for smooth rendering

                // Dynamic radius to make the active slice protrude
                property real currentRadius: segmentDelegate.index === AppState.currentSection ? 86 : 70
                
                // Dynamic slice angle calculation (divides the 180-degree semi-circle evenly)
                property real anglePerSection: 180.0 / AppState.sections.length
                
                Behavior on currentRadius {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutBack
                    }
                }

                ShapePath {
                    strokeColor: "#ffffff"
                    strokeWidth: 2
                    fillColor: segmentDelegate.index === AppState.currentSection ? "#000000" : "#ffffff"

                    Behavior on fillColor {
                        ColorAnimation { duration: 220 }
                    }

                    startX: 90
                    startY: 90

                    PathLine {
                        x: 90 + segmentShape.currentRadius * Math.cos((270 + segmentDelegate.index * segmentShape.anglePerSection) * Math.PI / 180)
                        y: 90 + segmentShape.currentRadius * Math.sin((270 + segmentDelegate.index * segmentShape.anglePerSection) * Math.PI / 180)
                    }

                    PathAngleArc {
                        centerX: 90
                        centerY: 90
                        radiusX: segmentShape.currentRadius
                        radiusY: segmentShape.currentRadius
                        startAngle: 270 + segmentDelegate.index * segmentShape.anglePerSection
                        sweepAngle: segmentShape.anglePerSection
                    }

                    PathLine {
                        x: 90
                        y: 90
                    }
                }
            }
        }
    }

    // 2. Slow spinning subtle inner ring (shows dynamic movement)
    Rectangle {
        id: innerSpinningRing
        anchors.centerIn: parent
        width: 110
        height: 110
        radius: 55
        color: "transparent"
        border.color: "#ffffff"
        border.width: 1.5
        opacity: 0.15
        
        NumberAnimation on rotation {
            from: 360
            to: 0
            duration: 16000
            loops: Animation.Infinite
        }
    }

    // 3. Minimalist central core dot
    Rectangle {
        id: centralDot
        anchors.centerIn: parent
        width: 16
        height: 16
        radius: 8
        color: "#ffffff"
        opacity: 0.8
        
        // Very subtle pulsing scale animation
        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: AppState.hubOpen
            
            NumberAnimation { to: 1.2; duration: 1500; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.8; duration: 1500; easing.type: Easing.InOutSine }
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
