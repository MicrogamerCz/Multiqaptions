import QtQuick
import org.kde.kirigami as Kirigami

MouseArea {
    id: selectArea
    anchors.fill: parent
    clip: true

    property int originX: 0
    property int originY: 0
    property int pointerX: 0
    property int pointerY: 0

    readonly property int selectedX: Math.min(originX, pointerX)
    readonly property int selectedY: Math.min(originY, pointerY)
    readonly property int selectedWidth: Math.abs(originX - pointerX)
    readonly property int selectedHeight: Math.abs(originY - pointerY)

    onPressed: function (event: MouseEvent) {
        originX = pointerX = event.x;
        originY = pointerY = event.y;
    }

    onPositionChanged: function (event: MouseEvent) {
        pointerX = event.x;
        pointerY = event.y;
    }

    Rectangle {
        id: selectionRectangle

        border.width: 1
        border.color: Kirigami.Theme.linkColor
        color: Kirigami.Theme.linkBackgroundColor
        opacity: 0.35

        x: Math.min(parent.originX, parent.pointerX)
        y: Math.min(parent.originY, parent.pointerY)
        width: Math.abs(parent.originX - parent.pointerX)
        height: Math.abs(parent.originY - parent.pointerY)

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.DragMoveCursor

            onPositionChanged: function (event: MouseEvent) {
                event.accepted = true;

                let deltaX = event.x - (parent.width * 0.5);
                let deltaY = event.y - (parent.height * 0.5);

                selectArea.originX += deltaX;
                selectArea.originY += deltaY;
                selectArea.pointerX += deltaX;
                selectArea.pointerY += deltaY;
            }
        }
    }
}
