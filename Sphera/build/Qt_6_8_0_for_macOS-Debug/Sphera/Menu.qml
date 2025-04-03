import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    width: 290
    height: 240
    color: "#EEEEEE"
    signal openCatalog()

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Button {
            text: "Коллекция"
            onClicked: openCatalog()
        }
        Button {
            text: "Машина времени"
        }
        Button {
            text: "Дневник"
        }
        Button {
            text: "Настройки"
        }
    }
}
