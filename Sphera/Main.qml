import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QtMultimedia
import QtQuick.Dialogs
import QtQuick.LocalStorage 2.0
Window {
    color: "black"
    width: 1000
    height: 600
    visible: true
    title: qsTr("Sphera")

    property string musicFile: ""

    AudioOutput {
        id: audioOut
    }
    MediaPlayer {
        id: player
        source: musicFile
        audioOutput: audioOut
    }

    Window {
            id: musicCatalog
            width: 800
            height: 500
            color: "white"
            visible: false
            ListView {
                anchors.fill: parent
                model: musicModel
                delegate: Item {
                    width: parent.width
                    height: 40
                    Rectangle {
                        width: parent.width
                        height: 44
                        color: "#EEEEEE"
                        anchors {
                        }

                        Text {
                            text: path
                            color: "Black"
                        }
                        Button {
                            anchors {
                                right: parent.right
                                rightMargin: 44
                            }
                            text: "Играть"
                            onClicked: {
                                musicFile = path
                                player.source = musicFile
                                player.play()
                            }
                        }
                    }
                }
            }
        }

        ListModel {
            id: musicModel
        }

        function loadMusicCatalog() {
            musicModel.clear()
            var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
            db.transaction(function(tx) {
                var result = tx.executeSql('SELECT path FROM music')
                for (var i = 0; i < result.rows.length; i++) {
                    musicModel.append({ "path": result.rows.item(i).path })  // Исправлено
                }
            })
        }


    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFile
        nameFilters: ["Audio Files (*.mp3 *.wav)"]
        onAccepted: {
            player.stop()  // Останавливаем воспроизведение
            player.source = ""  // Сбрасываем источник
            musicFile = selectedFile.toString().replace("file:///", "file://")
            player.source = musicFile  // Устанавливаем новый файл
            player.play()  // Запускаем воспроизведение
            saveMusicFile(musicFile)
        }
    }

    Button {
        height: 44
        width: 65

        anchors {
            top: parent.top
            right: parent.right
            margins: 44
        }
        icon.source: "Icons/plus.svg"
        icon.color: "transparent"
        display: Button.IconOnly
        text: ""
            onClicked: fileDialog.open()
    }

    Button {

        x: parent.width/2 - 169
        anchors {
            verticalCenter: parent.verticalCenter
        }

        onClicked: {
            if (player.playbackState === MediaPlayer.PlayingState) {
                player.pause()
            } else {
                player.play()
            }
        }

        background: Rectangle {
            radius: 10
            Image {
                anchors.centerIn: parent
                width: 56
                height: 56
                fillMode: Image.Pad
                source: player.playbackState === MediaPlayer.PlayingState ? "Icons/pause.svg" : "Icons/play.svg"
            }
        }

    }
    Rectangle{
        // id: MenuRow
        width: 290
        height: 240
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            left: undefined
            rightMargin: 44

        }
        radius: 10
        color: "#EEEEEE"
        ColumnLayout{
            anchors.centerIn: parent
            // anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Button {
                Layout.preferredWidth: 271
                Layout.preferredHeight: 50
                text: "Коллекция"
                spacing: 90
                font.pixelSize: 20
                icon.source: "Icons/stack.svg"
                icon.color: "transparent"
                display: Button.TextBesideIcon
            }
            Button {
                Layout.preferredWidth: 271
                Layout.preferredHeight: 50
                text: "Машина времени"
                font.pixelSize: 20
                spacing: 30
                icon.source: "Icons/timelapse.svg"
                icon.color: "transparent"
                display: Button.TextBesideIcon
                onClicked: {
                    loadMusicCatalog()
                    musicCatalog.show()
                }
            }
            Button {
                Layout.preferredWidth: 271
                Layout.preferredHeight: 50
                text: "Дневник"
                font.pixelSize: 20
                spacing: 105
                icon.source: "Icons/book.svg"
                icon.color: "transparent"
                display: Button.TextBesideIcon
            }
            Button {
                Layout.preferredWidth: 271
                Layout.preferredHeight: 50
                text: "Настройки"
                spacing: 85
                font.pixelSize: 20
                icon.source: "Icons/settings.svg"
                icon.color: "transparent"

                display: Button.TextBesideIcon
            }
        }

    }



    function saveMusicFile(file) {
            var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS music (path TEXT)')
                tx.executeSql('INSERT INTO music (path) VALUES (?)', [file])
            })
        }

    function loadMusicFile() {
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT path FROM music ORDER BY rowid DESC LIMIT 1')
            if (result.rows.length > 0) {
                musicFile = result.rows.item(0).path
                player.source = musicFile  // Устанавливаем источник после загрузки
            }
        })
    }
        Component.onCompleted: loadMusicFile()

}
