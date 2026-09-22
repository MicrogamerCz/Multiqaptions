# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-FileCopyrightText: 2026 Micro <microgamercz@proton.me>

import os
import signal
import sys

from PySide6.QtCore import QUrl
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication

import multiqaptions.data.portalworker  # pyright: ignore[reportUnusedImport]  # noqa: F401


def main():
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    signal.signal(signal.SIGINT, signal.SIG_DFL)

    base_path = os.path.abspath(os.path.dirname(__file__))
    engine.load(f"file://{base_path}/qml/main.qml")

    if len(engine.rootObjects()) == 0:
        sys.exit()

    _ = app.exec()


if __name__ == "__main__":
    main()
