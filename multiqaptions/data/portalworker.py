from typing import final

from gi.repository import Gio, Xdp
from PySide6.QtCore import QCoreApplication, QObject, Signal, Slot
from PySide6.QtQml import QmlElement

QML_IMPORT_NAME = "io.github.microgamercz.multiqaptions"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
@final
class PortalWorker(QObject):
    nodeIdReady = Signal(int)

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._portal = Xdp.Portal()
        self._session: Xdp.Session | None = None

        app: QCoreApplication = QCoreApplication.instance()  # pyright: ignore[reportAssignmentType]
        _ = app.aboutToQuit.connect(self._stop_session)

    @Slot()
    def getPwNodeId(self) -> None:
        self._portal.create_screencast_session(  # TODO: add session restoration
            Xdp.OutputType.WINDOW,
            Xdp.ScreencastFlags.NONE,
            Xdp.CursorMode.HIDDEN,
            Xdp.PersistMode.PERSISTENT,
            callback=self._screencast_session_finished,
        )

    def _screencast_session_finished(
        self, portal: Xdp.Portal, task: Gio.AsyncResult, data=None
    ) -> None:
        self._session = portal.create_remote_desktop_session_finish(task)
        # TODO: get the session restore token here
        self._session.start(callback=self._sc_session_started)

    def _sc_session_started(
        self, portal: Xdp.Portal, task: Gio.AsyncResult, data=None
    ) -> None:
        if not self._session:
            return

        node_id, _ = self._session.get_streams()[0]
        self.nodeIdReady.emit(node_id)

    @Slot()
    def _stop_session(self) -> None:
        if self._session:
            self._session.close()
