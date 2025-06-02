Text {
    id: noteText
    width: parent.width
    text: "Note: Please select the subject to proceed"
    font.pixelSize: pr_fontSizeMultiple + 20
    color: Material.primaryTextColor
    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignHCenter

    anchors {
        bottom: parent.bottom
        bottomMargin: 30
        horizontalCenter: parent.horizontalCenter
    }
}
