import QtQuick
import qs.Core

Rectangle {
    id: root

    width: 420
    clip: true
    color: "#080808"

    property alias listView: listView

    // Translucent right border line
    Rectangle {
        width: 1
        height: parent.height
        color: "#ffffff"
        opacity: 0.06
        anchors.right: parent.right
    }

    // ListView replacing the Repeater
    ListView {
        id: listView
        anchors {
            top: parent.top
            topMargin: 80
            left: parent.left
            leftMargin: 0
            right: parent.right
            rightMargin: 0
            bottom: parent.bottom
            bottomMargin: 56
        }
        
        model: AppState.sectionItems
        spacing: 12
        clip: true
        interactive: true
        
        currentIndex: AppState.currentItem
        
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 220
        
        delegate: Item {
            id: menuItem
            required property var modelData
            required property int index
            
            width: listView.width
            height: 44
            
            // Staggered entry transition when Hub is open
            opacity: AppState.hubOpen ? 1.0 : 0.0
            transform: Translate {
                x: AppState.hubOpen ? 0 : -32
                
                Behavior on x {
                    SequentialAnimation {
                        PauseAnimation {
                            duration: AppState.hubOpen ? index * 30 : 0
                        }
                        NumberAnimation {
                            duration: 350
                            easing.type: Easing.OutBack
                        }
                    }
                }
            }
            
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation {
                        duration: AppState.hubOpen ? index * 30 : 0
                    }
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutQuad
                    }
                }
            }
            
            property bool isSelected: index === AppState.currentItem
            
            Text {
                id: itemText
                anchors {
                    left: parent.left
                    leftMargin: 110 // Align neatly to clear the selection indicator on left edge
                    right: parent.right
                    rightMargin: 24 // Leave padding on the right to prevent overlapping the border
                    verticalCenter: parent.verticalCenter
                }
                
                text: modelData.name
                color: menuItem.isSelected ? AppState.colorTextActive : AppState.colorTextInactive
                elide: Text.ElideRight
                fontSizeMode: Text.HorizontalFit
                minimumPixelSize: 13
                
                font {
                    family: AppState.fontHeader
                    pixelSize: 22
                    weight: Font.Bold
                }
                
                transform: Translate {
                    x: menuItem.isSelected ? 10 : 0
                    Behavior on x {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                }
                
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                
                onEntered: {
                    AppState.currentItem = index;
                }
                
                onClicked: {
                    AppState.currentItem = index;
                    AppState.launch(modelData);
                }
            }
        }
    }

    // Background text for the silhouette fill (clipped to the panel's right edge)
    Column {
        id: verticalSectionBacking
        anchors {
            horizontalCenter: parent.right
            verticalCenter: parent.verticalCenter
        }
        
        property string displayedText: AppState.sectionName
        property real slideX: AppState.hubOpen ? 0 : -120

        transform: Translate {
            x: verticalSectionBacking.slideX
        }

        Behavior on slideX {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

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
            model: verticalSectionBacking.lettersCount
            delegate: Text {
                required property int index
                text: verticalSectionBacking.displayedText.charAt(index)
                color: "#ffffff" // solid white fill inside the panel
                opacity: AppState.hubOpen ? 1.0 : 0.0
                font {
                    family: AppState.fontMono
                    pixelSize: verticalSectionBacking.letterSize
                    weight: Font.Bold
                }

                transform: Translate {
                    x: AppState.hubOpen ? 0 : -20
                    Behavior on x {
                        SequentialAnimation {
                            PauseAnimation { duration: AppState.hubOpen ? index * 45 : 0 }
                            NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                        }
                    }
                }

                Behavior on opacity {
                    SequentialAnimation {
                        PauseAnimation { duration: AppState.hubOpen ? index * 45 : 0 }
                        NumberAnimation { duration: 300 }
                    }
                }
            }
        }

        Connections {
            target: AppState

            function onSectionNameChanged(): void {
                sectionChangeBackingAnim.restart();
            }
        }

        SequentialAnimation {
            id: sectionChangeBackingAnim

            ParallelAnimation {
                NumberAnimation {
                    target: verticalSectionBacking
                    property: "opacity"
                    to: 0.0
                    duration: 180
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: verticalSectionBacking
                    property: "slideX"
                    to: -120
                    duration: 180
                    easing.type: Easing.OutQuad
                }
            }

            PropertyAction {
                target: verticalSectionBacking
                property: "displayedText"
                value: AppState.sectionName
            }

            ParallelAnimation {
                NumberAnimation {
                    target: verticalSectionBacking
                    property: "opacity"
                    to: 1.0
                    duration: 300
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: verticalSectionBacking
                    property: "slideX"
                    to: 0
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
