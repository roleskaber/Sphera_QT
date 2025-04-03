import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.LocalStorage 2.0

Rectangle {
    id: catalog
    width: 400
    height: 500
    color: "#222"
    signal musicSelected(string path)

    ListModel { id: musicModel }

    ListView {
        model: musicModel
        delegate: Item {
            width: parent.width
            height: 40
            RowLayout {
                spacing: 10
                Text {
                    text: model.path  // Используем model.path
                    color: "white"
                }
                Button {
                    text: "Играть"
                    onClicked: {
                        musicFile = model.path  // Используем model.path
                        player.source = musicFile
                        player.play()
                    }
                }
            }
        }
    }


    function loadMusicCatalog() {
        musicModel.clear()
        var db = LocalStorage.openDatabaseSync("MusicDB", "1.0", "Music Database", 1000000)
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT path FROM music')
            for (var i = 0; i < result.rows.length; i++) {
                musicModel.append({ "path": result.rows.item(i).path })
            }
        })
    }
}
