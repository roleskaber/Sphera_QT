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

    // background: Image {
    //     anchors.fill: parent
    //     source: "Icons/Background.png"
    // }
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
                    Row {
                        anchors {
                            right: parent.right
                            rightMargin: 10
                        }
                        spacing: 10
                        Button {
                            text: "Играть"
                            onClicked: {
                                musicFile = path
                                player.source = musicFile
                                player.play()
                            }
                        }
                        Button {
                            text: isFavorite ? "★" : "☆"
                            onClicked: {
                                if (isFavorite) {
                                    removeFromFavorites(path)
                                } else {
                                    addToFavorites(path)
                                }
                                loadMusicCatalog()
                            }
                        }
                    }
                }
            }
        }
    }

    Window {
        id: favoritesWindow
        width: 800
        height: 500
        color: "white"
        visible: false
        title: "Избранное"

        ListView {
            anchors.fill: parent
            model: favoritesModel
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
                    Row {
                        anchors {
                            right: parent.right
                            rightMargin: 10
                        }
                        spacing: 10
                        Button {
                            text: "Играть"
                            onClicked: {
                                musicFile = path
                                player.source = musicFile
                                player.play()
                            }
                        }
                        Button {
                            text: "★"
                            onClicked: {
                                removeFromFavorites(path)
                                loadFavorites()
                            }
                        }
                    }
                }
            }
        }
    }

    Window {
        id: book
        width: 800
        height: 500
        color: "white"
        visible: false

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                TextField {
                    id: noteTitle
                    Layout.fillWidth: true
                    placeholderText: "Название заметки"
                }

                SpinBox {
                    id: moodRating
                    from: 1
                    to: 10
                    value: 5
                }

                Button {
                    text: "Добавить"
                    onClicked: {
                        if (noteTitle.text.trim() !== "") {
                            saveNote(noteTitle.text, noteContent.text, moodRating.value)
                            loadNotes()
                            noteTitle.text = ""
                            noteContent.text = ""
                            moodRating.value = 5
                        }
                    }
                }
            }

            TextArea {
                id: noteContent
                Layout.fillWidth: true
                Layout.fillHeight: true
                placeholderText: "Содержание заметки..."
            }

            ListView {
                id: notesList
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                model: notesModel
                spacing: 5

                delegate: Rectangle {
                    width: parent.width
                    height: 80
                    color: "#EEEEEE"
                    radius: 5

                    Column {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 2

                        Row {
                            width: parent.width
                            spacing: 10

                            Text {
                                text: title
                                font.bold: true
                                width: parent.width - moodText.width - 40
                                elide: Text.ElideRight
                            }

                            Text {
                                id: moodText
                                text: "Настроение: " + mood
                                color: getMoodColor(mood)
                            }

                            Button {
                                width: 30
                                text: "X"
                                onClicked: deleteNote(id)
                            }
                        }

                        Text {
                            width: parent.width
                            text: content.length > 100 ? content.substring(0, 100) + "..." : content
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            noteTitle.text = title
                            noteContent.text = content
                            moodRating.value = mood
                        }
                    }
                }
            }
        }

        Component.onCompleted: loadNotes()
    }

    ListModel {
        id: musicModel
    }

    ListModel {
        id: notesModel
    }

    ListModel {
        id: favoritesModel
    }

    function loadMusicCatalog() {
        musicModel.clear()
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            // Create favorites table if not exists
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites (path TEXT PRIMARY KEY)')

            // Load all music files
            var result = tx.executeSql('SELECT path FROM music')
            for (var i = 0; i < result.rows.length; i++) {
                var path = result.rows.item(i).path
                // Check if this path is in favorites
                var favResult = tx.executeSql('SELECT 1 FROM favorites WHERE path = ?', [path])
                var isFavorite = favResult.rows.length > 0
                musicModel.append({
                    "path": path,
                    "isFavorite": isFavorite
                })
            }
        })
    }

    function loadFavorites() {
        favoritesModel.clear()
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT path FROM favorites')
            for (var i = 0; i < result.rows.length; i++) {
                favoritesModel.append({ "path": result.rows.item(i).path })
            }
        })
    }

    function addToFavorites(path) {
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            tx.executeSql('INSERT OR IGNORE INTO favorites (path) VALUES (?)', [path])
        })
    }

    function removeFromFavorites(path) {
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM favorites WHERE path = ?', [path])
        })
    }

    function saveNote(title, content, mood) {
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, mood INTEGER)')
            tx.executeSql('INSERT INTO notes (title, content, mood) VALUES (?, ?, ?)', [title, content, mood])
        })
    }

    function loadNotes() {
        notesModel.clear()
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT id, title, content, mood FROM notes ORDER BY id DESC')
            for (var i = 0; i < result.rows.length; i++) {
                var item = result.rows.item(i)
                notesModel.append({
                    "id": item.id,
                    "title": item.title,
                    "content": item.content,
                    "mood": item.mood
                })
            }
        })
    }

    function deleteNote(id) {
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM notes WHERE id = ?', [id])
            loadNotes()
        })
    }

    function getMoodColor(mood) {
        if (mood <= 3) return "red"
        if (mood <= 6) return "orange"
        return "green"
    }

    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFile
        nameFilters: ["Audio Files (*.mp3 *.wav)"]
        onAccepted: {
            player.stop()
            player.source = ""
            musicFile = selectedFile.toString().replace("file:///", "file://")
            player.source = musicFile
            player.play()
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

    Rectangle {
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
        ColumnLayout {
            anchors.centerIn: parent
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
                onClicked: {
                    loadFavorites()
                    favoritesWindow.show()
                }
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
                onClicked: {
                    book.show()
                }
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
                player.source = musicFile
            }
        })
    }

    Component.onCompleted: loadMusicFile()
}
