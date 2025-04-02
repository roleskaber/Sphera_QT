import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
    width: 1000
    height: 600
    visible: true
    title: qsTr("Sphera")

    RowLayout{
        anchors.centerIn: parent
            spacing: 324

            Button {
                Layout.preferredHeight: 64
                Layout.preferredWidth: 64
                Image {
                    anchors.centerIn: parent
                    width: 25
                    height: 25
                    fillMode: Image.Stretch
                    source: "Icons/play.png"

                }
            }


            Rectangle{
                Layout.preferredHeight: 240
                Layout.preferredWidth: 290
                radius: 10
                color: "#EEEEEE"
                ColumnLayout{
                    anchors.centerIn: parent
                    spacing: 17
                    Button {
                        Layout.preferredHeight: 29
                        Layout.preferredWidth: 271
                        text: "Коллекция"
                        font.pixelSize: 20
                        icon.source: "Icons/stack.png"
                        icon.color: "white"
                        display: Button.TextBesideIcon
                    }
                    Button {
                        Layout.preferredHeight: 29
                        Layout.preferredWidth: 271
                        text: "Машина времени"
                        font.pixelSize: 20
                        icon.source: "Icons/timelapse.png"
                        icon.color: "white"
                        display: Button.TextBesideIcon
                    }
                    Button {
                        Layout.preferredHeight: 29
                        Layout.preferredWidth: 271
                        text: "Дневник"
                        font.pixelSize: 20
                        icon.source: "Icons/book.png"
                        icon.color: "white"
                        display: Button.TextBesideIcon
                    }
                    Button {
                        Layout.preferredHeight: 29
                        Layout.preferredWidth: 271
                        text: "Настройки"
                        font.pixelSize: 20
                        icon.source: "Icons/settings.png"
                        icon.color: "white"
                        display: Button.TextBesideIcon
                    }



                }

            }


        }



}
