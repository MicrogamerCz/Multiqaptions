// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Micro <microgamercz@proton.me>

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import Qt.labs.platform as Labs
import org.kde.kirigami as Kirigami

Controls.ApplicationWindow {
    id: root
    visible: true
    title: "Multiqaptions"

    readonly property Controls.Action quitAction: Controls.Action {
        shortcut: StandardKey.Quit
        onTriggered: root.hide()
    }

    ColumnLayout {
        anchors.fill: parent

        Kirigami.AbstractCard {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: false

            contentItem: RowLayout {
                Controls.Button {
                    text: "Select window"
                    flat: true
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

        // qml6glsinkitem
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
            root.show();
        }
    }
}
