# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-FileCopyrightText: 2026 Micro <microgamercz@proton.me>

import os
import signal
import sys

from gi.repository import Gst
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication

import multiqaptions.data.captureworker  # pyright: ignore[reportUnusedImport]
import multiqaptions.data.portalworker  # pyright: ignore[reportUnusedImport]  # noqa: F401

os.environ["QT_QUICK_BACKEND"] = "opengl"


def main():
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    Gst.init()

    app = QApplication(sys.argv)
    _ = Gst.ElementFactory.make("qml6glsink")

    engine = QQmlApplicationEngine()
    base_path = os.path.abspath(os.path.dirname(__file__))
    engine.load(f"file://{base_path}/qml/main.qml")

    if len(engine.rootObjects()) == 0:
        sys.exit()

    _ = app.exec()


if __name__ == "__main__":
    main()
