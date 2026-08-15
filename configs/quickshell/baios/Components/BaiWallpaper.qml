import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Core
import qs.Components

PanelWindow {
    id: wallpaperPanel

    readonly property bool open: AppState.wallpaperOpen

    // Keep window mapped during slide-out animation
    visible: open || (clipper.width > 0)

    anchors {
        bottom: true
        left: true
    }

    margins {
        left: 80
        bottom: 24
    }

    implicitWidth: 340
    implicitHeight: 480

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus:
        open
            ? WlrKeyboardFocus.OnDemand
            : WlrKeyboardFocus.None

    Item {
        id: clipper
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: open ? wallpaperPanel.implicitWidth : 0
        clip: true

        Behavior on width {
            NumberAnimation {
                duration: 280
                easing.type: Easing.OutCubic
            }
        }

        transform: Translate {
            x: open ? 0 : -35
            Behavior on x {
                NumberAnimation {
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }
        }

        opacity: open ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: contentContainer
            width: wallpaperPanel.implicitWidth
            height: parent.height
            
            // Curated dark gradient background for premium feel
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#141414" }
                GradientStop { position: 1.0; color: "#0a0a0a" }
            }
            
            // Crisp thin white border
            border.color: "#33ffffff"
            border.width: 1
            
            radius: 16
            clip: true

            Connections {
                target: AppState

                function onWallpaperOpenChanged(): void {
                    if (AppState.wallpaperOpen) {
                        contentContainer.forceActiveFocus();
                    }
                }
            }

            Column {
                id: headerColumn
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 18
                }
                spacing: 14

                Text {
                    text: "WALLPAPERS"
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
            }

            // GridView of wallpapers anchored below the headerColumn
            GridView {
                id: wallpaperGrid
                anchors {
                    top: headerColumn.bottom
                    topMargin: 4
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    leftMargin: 18
                    rightMargin: 18
                    bottomMargin: 18
                }
                clip: true
                
                model: AppState.wallpapersModel

                cellWidth: 152 // 140 card width + 12 spacing
                cellHeight: 110 // 100 card height + 10 spacing

                delegate: Item {
                    width: 140
                    height: 100

                    required property string name
                    required property string path
                    required property bool active

                    Rectangle {
                        id: card
                        anchors.fill: parent
                        color: active ? "#1c1c1c" : "transparent"
                        radius: 8
                        border.color: active 
                            ? AppState.colorAccent 
                            : (mouseArea.containsMouse ? "#55ffffff" : "#11ffffff")
                        border.width: active ? 1.5 : 1

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        // Thumbnail image container
                        Item {
                            id: imageContainer
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                margins: 4
                            }
                            height: 72
                            clip: true

                            Rectangle {
                                anchors.fill: parent
                                radius: 6
                                color: "#111111"
                                clip: true

                                Image {
                                    anchors.fill: parent
                                    source: "file://" + path
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    sourceSize.width: 180  // Low resolution thumbnail for performance
                                    sourceSize.height: 100
                                    
                                    // Smooth fade in once image is loaded
                                    opacity: status == Image.Ready ? 1.0 : 0.0
                                    Behavior on opacity {
                                        NumberAnimation { duration: 200 }
                                    }
                                }
                            }
                        }

                        // Truncated text label
                        Text {
                            anchors {
                                bottom: parent.bottom
                                bottomMargin: 4
                                left: parent.left
                                right: parent.right
                                leftMargin: 8
                                rightMargin: 8
                            }
                            text: {
                                var dotIdx = name.lastIndexOf('.');
                                if (dotIdx !== -1) {
                                    return name.substring(0, dotIdx);
                                }
                                return name;
                            }
                            color: active ? AppState.colorTextActive : AppState.colorTextInactive
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            
                            font {
                                family: AppState.fontUi
                                pixelSize: 10
                                bold: active
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            AppState.setWallpaper(path);
                        }
                    }
                }
            }

            Keys.onEscapePressed: event => {
                AppState.closeWallpaper();
                event.accepted = true;
            }
        }
    }
}
