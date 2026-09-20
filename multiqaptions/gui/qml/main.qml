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
    title: qsTr("Multiqaptions")

    readonly property Controls.Action quitAction: Controls.Action {
        shortcut: StandardKey.Quit
        onTriggered: root.hide()
    }

    // TODO: app ui

    Labs.SystemTrayIcon {
        visible: true
        icon.name: "globe"

        onActivated: {
            hide();
            root.close()
        }
    }
}
