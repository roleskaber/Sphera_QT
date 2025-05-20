import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import QtMultimedia

import QtQuick.Dialogs
import QtQuick.LocalStorage 2.0

Window {
    color: "white"
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
            spacing: 18
            Layout.fillWidth: true
            anchors.fill: parent
            model: musicModel
            delegate: Item {
                width: parent.width
                height: 40
                Rectangle {
                    width: parent.width == null ? 0 : parent.width
                    height: 60
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
                            text: ""
                            icon.source: "Icons/play.svg"
                            onClicked: {
                                musicFile = path
                                player.source = musicFile
                                player.play()
                            }
                        }
                        Button {
                            text: isFavorite ? "★" : "☆"
                            icon.source: isFavorite ? "Icons/heart.svg" : "Icons/heart_0.svg"
                            icon.color: "transparent"
                            display: Button.IconOnly
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
        width: 1000
        height: 600
        color: "#75938F"
        visible: false

        ColumnLayout {
            anchors.fill: parent
            spacing: 0 // Убрали промежутки между элементами

            // Область создания заметки (теперь с z-индексом)
            Rectangle {
                id: createNoteArea
                Layout.fillWidth: true
                implicitHeight: column.implicitHeight + 40
                color: "#75938F"
                z: 1 // Ниже чем заметки
                opacity: 1
                Behavior on opacity { NumberAnimation { duration: 300 } }

                Column {
                    id: column
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10

                    Row {
                        width: parent.width
                        spacing: 10

                        TextField {
                            id: noteTitle
                            width: parent.width - moodRating.width - addButton.width - 20
                            placeholderText: "Написать"
                        }

                        SpinBox {
                            id: moodRating
                            from: 1
                            to: 10
                            value: 5
                        }

                        Button {
                            id: addButton
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
                        width: parent.width
                        height: 150
                        placeholderText: "Содержание заметки..."
                    }
                }
            }

            // Контейнер для ListView с заметками (теперь с отрицательными отступами)
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                z: 2 // Выше чем область создания

                ListView {
                    id: notesList
                    anchors.fill: parent
                    anchors.topMargin: 0 // Заметки будут заходить сверху
                    rightMargin: 20
                    leftMargin: 20
                    model: notesModel
                    spacing: 5
                    clip: false

                    // Обработчик скролла
                    onContentYChanged: {
                        if (contentY > 20) {
                            createNoteArea.opacity = 0.7
                        } else {
                            createNoteArea.opacity = 1.0
                        }
                    }

                    delegate: Rectangle {
                        id: noteDelegate
                        width: parent.width
                        height: 80
                        color: "#EEEEEE"
                        radius: 5
                        opacity: 0
                        transform: Translate { y: 20 }

                        // Анимация появления
                        Component.onCompleted: {
                            appearAnimation.start()
                        }

                        SequentialAnimation {
                            id: appearAnimation
                            PauseAnimation { duration: index * 100 }
                            ParallelAnimation {
                                NumberAnimation { target: noteDelegate; property: "opacity"; to: 1; duration: 300 }
                                NumberAnimation { target: noteDelegate.transform; property: "y"; to: 0; duration: 300 }
                            }
                        }

                        Row {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
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

                        Column {
                            topPadding: 20
                            bottomPadding: 20
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 4

                            Row {
                                width: parent.width
                                spacing: 30

                                Text {
                                    anchors.left: parent.left
                                    text: title
                                    font.bold: true
                                    font.pixelSize: 20
                                    width: parent.width - moodText.width - 40
                                    elide: Text.ElideRight
                                }
                            }

                            Text {
                                width: parent.width
                                font.pixelSize: 16
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
        }

        // Остальные модели и функции...
        ListModel {
            id: musicModel
        }

        ListModel {
            id: notesModel
        }

        ListModel {
            id: favoritesModel
        }


    }

    function loadMusicCatalog() {
        musicModel.clear()
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites (path TEXT PRIMARY KEY)')
            var result = tx.executeSql('SELECT path FROM music')
            for (var i = 0; i < result.rows.length; i++) {
                var path = result.rows.item(i).path
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
        background: Rectangle {
            color : "#848D8B"
            radius: 10

        }
        anchors {
            top: parent.top
            right: parent.right
            margins: 44
        }
        icon.source: "Icons/plus.svg"
        icon.color: "white"
        display: Button.IconOnly
        text: ""
        onClicked: fileDialog.open()
    }

    Column {
        width: 120
        height: 120
        x: parent.width/2 - 169
        anchors {
            verticalCenter: parent.verticalCenter
        }
        spacing: 20
    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 70
        height: 70



        background: Rectangle {
            radius: 10
            color: "#D7D7D7"
            opacity: 0
            MouseArea {
               anchors.fill: parent; hoverEnabled: true
               onEntered: parent.opacity = 0.3
               onExited: parent.opacity = 0
           }

        }
        Image {
            anchors.centerIn: parent
            width: 56
            height: 56
            fillMode: Image.Pad
            source: player.playbackState === MediaPlayer.PlayingState ? "Icons/pause.svg" : "Icons/play.svg"
        }
        onClicked: {
            if (player.playbackState === MediaPlayer.PlayingState) {
                player.pause()
            } else {
                player.play()
            }
        }
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Сейчас играет: " + musicFile.split('/').pop().split('.').slice(0, -1).join('.'))
        font.pixelSize: 18
        opacity: 60
        color: "white"
    }

    }

    Rectangle {
        width: 263
        height: 226
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 44
        }
        radius: 10
        color: "#848D8B"
        Column {
            topPadding: 20
            bottomPadding: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3

            Repeater {
                model: [
                    { icon: "Icons/stack.svg", text: "Коллекция", width: 30, handler: function() { loadFavorites(); favoritesWindow.show() } },
                    { icon: "Icons/timelapse.svg", text: "История", width: 29, handler: function() { loadMusicCatalog(); musicCatalog.show() } },
                    { icon: "Icons/book.svg", text: "Дневник", width: 28, handler: function() { book.show() } },
                    { icon: "Icons/settings.svg", text: "Настройки", width: 26 }
                ]

                Button {

                    width: 263
                    height: 40



                    contentItem: Row {


                        spacing: 25
                        leftPadding: 30
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            source: modelData.icon
                            width: modelData.width
                            height: 26
                            anchors.verticalCenter: parent.verticalCenter
                            z : 2

                        }

                        Text {
                            text: modelData.text
                            font.pixelSize: 20
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            z: 2
                        }
                    }

                    background: Rectangle {
                        radius: 7
                        color: "transparent"
                         MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onEntered: parent.color = '#767F7D'
                            onExited: parent.color = 'transparent'
                        }
                        z: -1
                    }

                    onClicked: if (modelData.handler) modelData.handler()

                }
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

    Image {
        id: back
        source: "Icons/Background.png"
        width: parent.width
        height: parent.height
        z: -1
    }

    Component.onCompleted: loadMusicFile()
}
