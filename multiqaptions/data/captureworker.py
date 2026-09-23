import ctypes
from typing import final

import shiboken6
from gi.repository import Gst
from PySide6.QtCore import Property, QObject, Signal, Slot
from PySide6.QtQml import QmlElement
from PySide6.QtQuick import QQuickItem

QML_IMPORT_NAME = "io.github.microgamercz.multiqaptions"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
@final
class CaptureWorker(QObject):
    previewChanged = Signal()

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)

        # TODO: add checks if elements exist, pipeline was parsed successfully, plugins aren't missing, etc.
        self._pipeline: Gst.Pipeline = Gst.parse_launch("""
            pipewiresrc name=capture_src provide-clock=false !
            queue ! tee name=capture
            capture. ! valve name=video_valve ! queue !
                glsinkbin name=video_sink
            capture. ! valve name=frame_valve ! queue !
                videoconvert ! video/x-raw,format=RGB !
                appsink name=frame_sink emit-signals=true max-buffers=1 drop=true sync=false
        """)  # pyright: ignore[reportAttributeAccessIssue]

        self._video_valve = self._pipeline.get_by_name("video_valve")
        self._frame_valve = self._pipeline.get_by_name("frame_valve")

        self._frame_sink = self._pipeline.get_by_name("frame_sink")

        video_sink: Gst.Element = self._pipeline.get_by_name("video_sink")  # pyright: ignore[reportAssignmentType]
        self._qml_sink = Gst.ElementFactory.make("qml6glsink", "qml_sink")
        video_sink.set_property("sink", self._qml_sink)

        self._preview_item: QQuickItem | None = None

    @Property(QQuickItem, notify=previewChanged)
    def preview(self):  # pyright: ignore[reportRedeclaration]
        return self._preview_item

    @preview.setter
    def preview(self, preview_item: QQuickItem | None):
        self._preview_item = preview_item

        gobject = ctypes.cdll.LoadLibrary("libgobject-2.0.so")
        preview_item_ptr = (
            0 if preview_item is None else shiboken6.getCppPointer(preview_item)[0]
        )
        gobject.g_object_set(
            ctypes.c_void_p(hash(self._qml_sink)),
            b"widget",
            ctypes.c_void_p(preview_item_ptr),
            None,
        )
        del gobject

        if not self._pipeline:
            print("ERROR: This shouldn't have happened")
            return

    @Slot(int)
    def set_pw_nodeid(self, node_id: int):
        _, state, _ = self._pipeline.get_state(1200)
        if state == Gst.State.PLAYING:
            _ = self._pipeline.set_state(Gst.State.NULL)

        pipewiresrc: Gst.Element = self._pipeline.get_by_name("capture_src")  # pyright: ignore[reportAssignmentType]
        pipewiresrc.set_property("path", str(node_id))

        _ = self._pipeline.set_state(Gst.State.PLAYING)
