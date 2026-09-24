// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Micro <microgamercz@proton.me>

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import Qt.labs.platform as Labs
import org.kde.kirigami as Kirigami
import org.kde.config as KConfig
import io.github.microgamercz.multiqaptions
import org.freedesktop.gstreamer.Qt6GLVideoItem
import "."

Controls.ApplicationWindow {
    id: root
    visible: true
    title: "Multiqaptions"
    minimumWidth: appToolbar.width

    readonly property Controls.Action quitAction: Controls.Action {
        shortcut: StandardKey.Quit
        onTriggered: root.hide()
    }

    PortalWorker {
        id: portal

        onNodeIdReady: function (nodeid: int) {
            capture.set_pw_nodeid(nodeid);
        }
    }

    CaptureWorker {
        id: capture
        preview: videoItem
    }

    KConfig.WindowStateSaver {
        configGroupName: "Window"
    }

    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            Layout.fillWidth: true
            Item {
                Layout.fillWidth: true
            }
            Controls.Control {
                id: appToolbar
                Layout.margins: Kirigami.Units.mediumSpacing

                contentItem: RowLayout {
                    Controls.Button {
                        text: "Select window"
                        flat: true
                        onClicked: portal.getPwNodeId()
                    }

                    Kirigami.Separator {
                        Layout.fillHeight: true
                    }

                    Controls.ButtonGroup {
                        id: alignButtons
                        exclusive: true
                    }

                    Controls.Button {
                        icon.name: "align-vertical-top"
                        checkable: true
                        flat: true
                        Controls.ButtonGroup.group: alignButtons
                    }
                    Controls.Button {
                        icon.name: "align-horizontal-right"
                        checkable: true
                        flat: true
                        Controls.ButtonGroup.group: alignButtons
                    }
                    Controls.Button {
                        icon.name: "align-vertical-bottom"
                        checked: true
                        checkable: true
                        flat: true
                        Controls.ButtonGroup.group: alignButtons
                    }
                    Controls.Button {
                        icon.name: "align-horizontal-left"
                        checkable: true
                        flat: true
                        Controls.ButtonGroup.group: alignButtons
                    }

                    Kirigami.Separator {
                        Layout.fillHeight: true
                    }

                    Controls.ComboBox {
                        enabled: false
                        Layout.minimumWidth: font.pointSize * displayText.length
                        displayText: "Source Language"
                        flat: true
                    }
                    Controls.ComboBox {
                        enabled: false
                        Layout.minimumWidth: font.pointSize * displayText.length
                        displayText: "Output Language"
                        flat: true
                    }

                    Kirigami.Separator {
                        Layout.fillHeight: true
                    }

                    Controls.Button {
                        text: "Start"
                        flat: true
                    }
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "black"

            GstGLQt6VideoItem {
                id: videoItem
                anchors.fill: parent
                objectName: "videoItem"
            }

            SelectionRectangle {
                visible: capture.capturing
            }
        }
    }

    Labs.SystemTrayIcon {
        id: trayIcon
        visible: true
        icon.name: "globe"

        menu: Labs.Menu {
            Labs.MenuItem {
                text: "Start/Stop"
                // TODO: implement
            }
            Labs.MenuItem {
                text: "Open"
                onTriggered: root.show()
            }
            Labs.MenuItem {
                text: "Quit"
                onTriggered: {
                    trayIcon.hide();
                    root.close();
                }
            }
        }

        onActivated: {
            if (root.visible)
                root.hide();
            else
                root.show();
        }
    }
}
