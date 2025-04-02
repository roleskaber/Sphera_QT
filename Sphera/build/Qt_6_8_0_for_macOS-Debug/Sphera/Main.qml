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
                background: Rectangle {
                    height: 64
                    width: 64
                    color: "#EEEEEE"
                    radius: 10
                    Image {
                        anchors.centerIn: parent
                        width: 25
                        height: 25
                        fillMode: Image.Stretch
                        source: "Icons/play.png"

                    }
                }

            }


            Rectangle{
                Layout.preferredHeight: 240
                Layout.preferredWidth: 290
                radius: 10
                color: "#EEEEEE"
                ColumnLayout{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 44
                    spacing: 24
                    Button {
                        background: Rectangle{
                            Layout.preferredHeight: 29
                            Layout.preferredWidth: 271
                            color: "#EEEEEE"
                            radius: 5
                            RowLayout {
                                spacing: 20
                                Image {
                                    Layout.preferredHeight: 19
                                    Layout.preferredWidth: 26
                                    fillMode: Image.Stretch
                                    source: "Icons/stack.png"
                                }
                                Text {
                                    text: "Коллекция"
                                    font.pixelSize: 20
                                }

                            }
                        }
                    }
                    Button {
                        background: Rectangle{
                            Layout.preferredHeight: 29
                            Layout.preferredWidth: 271
                            color: "#EEEEEE"
                            radius: 5
                            RowLayout {
                                spacing: 20
                                Image {
                                    Layout.preferredHeight: 23
                                    Layout.preferredWidth: 26
                                    fillMode: Image.Stretch
                                    source: "Icons/timelapse.png"
                                }
                                Text {
                                    text: "Машина времени"
                                    font.pixelSize: 20
                                }

                            }
                        }
                    }
                    Button {
                        background: Rectangle{
                            Layout.preferredHeight: 29
                            Layout.preferredWidth: 271
                            color: "#EEEEEE"
                            radius: 5
                            RowLayout {
                                spacing: 20
                                Image {
                                    Layout.preferredHeight: 17
                                    Layout.preferredWidth: 26
                                    fillMode: Image.Stretch
                                    source: "Icons/book.png"
                                }
                                Text {
                                    text: "Дневник"
                                    font.pixelSize: 20
                                }

                            }
                        }
                    }
                    Button {
                        display: Button.TextBesideIcon
                        background: Rectangle{
                            Layout.preferredHeight: 29
                            Layout.preferredWidth: 271
                            color: "#EEEEEE"
                            radius: 5
                            RowLayout {
                                spacing: 20
                                Image {
                                    Layout.preferredHeight: 23
                                    Layout.preferredWidth: 26
                                    fillMode: Image.Stretch
                                    source: "Icons/settings.png"
                                }
                                Text {
                                    text: "Настройки"
                                    font.pixelSize: 20
                                }

                            }
                        }
                    }

                }

            }


        }



}
