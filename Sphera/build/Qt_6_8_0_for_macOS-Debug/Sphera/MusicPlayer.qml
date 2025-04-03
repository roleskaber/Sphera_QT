import QtQuick
import QtQuick.Controls
import QtMultimedia

Rectangle {
    id: playerUI
    width: 100
    height: 50
    property alias player: player
    property alias fileDialog: fileDialog

    Button {
        anchors.centerIn: parent
        text: player.playbackState === MediaPlayer.PlayingState ? "❚❚" : "▶"
        onClicked: {
            if (player.playbackState === MediaPlayer.PlayingState) {
                player.pause()
            } else {
                player.play()
            }
        }
    }
}

