import QtQuick
import QtQuick.Scene3D
import QtQuick.Window

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Scene3D {
        anchors.fill: parent
        entity: Scene {
            id: scene
        }
        aspects: ["input", "logic"]
    }

    Text {
        color: "white"
        text: `ambient: ${scene.material.ambient},  diffuse: ${scene.material.diffuse}, specular: ${scene.material.specular}`
    }
}
