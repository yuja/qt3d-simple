import QtQuick 2.15
import QtQuick.Scene3D 2.15
import QtQuick.Window 2.15

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
        text: [
            `camera.upVector: ${scene.camera.upVector}`,
            `ambient: ${scene.material.ambient},  diffuse: ${scene.material.diffuse}, specular: ${scene.material.specular}`,
        ].join("\n")
    }
}
