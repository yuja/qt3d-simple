import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Scene3D 2.15
import QtQuick.Window 2.15

Window {
    id: root

    readonly property real defaultCameraDisplacement: -40

    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#0080ff" }
            GradientStop { position: 1; color: "#000020" }
        }
    }

    Scene3D {
        anchors.fill: parent
        entity: Scene {
            id: scene
            clearColor: "transparent"
        }
        aspects: ["input", "logic"]
    }

    Pane {
        anchors.left: parent.left
        anchors.top: parent.top
        padding: 2

        background: Rectangle {
            color: "black"
            opacity: 0.2
        }

        RowLayout {
            anchors.fill: parent

            Slider {
                enabled: !scene.sphereAnimationRunning
                from: 0
                to: 360
                value: scene.sphereAngle
                onMoved: scene.sphereAngle = value
            }

            CheckBox {
                checked: scene.sphereAnimationRunning
                onClicked: scene.sphereAnimationRunning = checked
                text: "Animated"
            }

            Text {
                color: "white"
                text: [
                    `camera.position: ${scene.camera.position}, camera.upVector: ${scene.camera.upVector}, camera.viewCenter: ${scene.camera.viewCenter}`,
                    `ambient: ${scene.material.ambient},  diffuse: ${scene.material.diffuse}, specular: ${scene.material.specular}`,
                ].join("\n")
            }
        }
    }

    Pane {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        padding: 2

        background: Rectangle {
            color: "black"
            opacity: 0.2
        }

        RowLayout {
            anchors.fill: parent

            RoundButton {
                radius: 5
                text: "X-Y"
                onClicked: {
                    scene.camera.upVector = Qt.vector3d(0, 1, 0);
                    scene.camera.position = Qt.vector3d(0, 0, root.defaultCameraDisplacement);
                    scene.camera.viewCenter = Qt.vector3d(0, 0, 0);
                }
            }

            RoundButton {
                radius: 5
                text: "X-Z"
                onClicked: {
                    scene.camera.upVector = Qt.vector3d(0, 0, 1);
                    scene.camera.position = Qt.vector3d(0, root.defaultCameraDisplacement, 0);
                    scene.camera.viewCenter = Qt.vector3d(0, 0, 0);
                }
            }

            RoundButton {
                radius: 5
                text: "Z-Y"
                onClicked: {
                    scene.camera.upVector = Qt.vector3d(0, 1, 0);
                    scene.camera.position = Qt.vector3d(root.defaultCameraDisplacement, 0, 0);
                    scene.camera.viewCenter = Qt.vector3d(0, 0, 0);
                }
            }
        }
    }
}
