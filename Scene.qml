// Copyright (C) 2014 Klaralvdalens Datakonsult AB (KDAB).
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick 2.15
import Qt3D.Core 2.15
import Qt3D.Extras 2.15
import Qt3D.Input 2.15
import Qt3D.Render 2.15

Entity {
    property alias material: material

    Camera {
        id: camera
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 45
        aspectRatio: 16/9
        nearPlane : 0.1
        farPlane : 1000.0
        position: Qt.vector3d( 0.0, 0.0, -40.0 )
        upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
    }

    OrbitCameraController {
        camera: camera
    }

    components: [
        RenderSettings {
            activeFrameGraph: ForwardRenderer {
                clearColor: Qt.rgba(0, 0.5, 1, 1)
                camera: camera
                showDebugOverlay: true
            }
        },
        InputSettings { }
    ]

    Entity {
        components: [
            DirectionalLight {
                color: "#ffaaaa"
                intensity: 1
                worldDirection: Qt.vector3d(-1, -1, 0)
            }
        ]
    }

    Entity {
        components: [
            DirectionalLight {
                color: "#aaaaff"
                intensity: 0.2
                worldDirection: Qt.vector3d(1, 1, 0)
            }
        ]
    }

    Entity {
        id: helperPlanes

        // XZ plane
        PlaneMesh {
            id: helperPlaneMesh
            width: 30
            height: 30
            primitiveType: GeometryRenderer.Lines
            meshResolution: Qt.size(width, height)
        }

        Entity {
            id: yzHelperPlane
            components: [
                helperPlaneMesh,
                yzHelperPlaneMaterial,
                yzHelperPlaneTransform,
            ]
            DiffuseSpecularMaterial {
                id: yzHelperPlaneMaterial
                ambient: "#ff0000"
            }
            Transform {
                id: yzHelperPlaneTransform
                // to XY plane
                rotation: fromAxisAndAngle(Qt.vector3d(0, 0, 1), 90)
            }
        }

        Entity {
            id: xzHelperPlane
            components: [
                helperPlaneMesh,
                xzHelperPlaneMaterial,
                xzHelperPlaneTransform,
            ]
            DiffuseSpecularMaterial {
                id: xzHelperPlaneMaterial
                ambient: "#008000"
            }
            Transform {
                id: xzHelperPlaneTransform
            }
        }

        Entity {
            id: xyHelperPlane
            components: [
                helperPlaneMesh,
                xyHelperPlaneMaterial,
                xyHelperPlaneTransform,
            ]
            DiffuseSpecularMaterial {
                id: xyHelperPlaneMaterial
                ambient: "#0000ff"
            }
            Transform {
                id: xyHelperPlaneTransform
                // to XY plane
                rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 90)
            }
        }
    }

    DiffuseSpecularMaterial {
        id: material
    }

    TorusMesh {
        id: torusMesh
        radius: 5
        minorRadius: 1
        rings: 100
        slices: 20
    }

    Transform {
        id: torusTransform
        scale3D: Qt.vector3d(1.5, 1, 0.5)
        rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 45)
    }

    Entity {
        id: torusEntity
        components: [ torusMesh, material, torusTransform ]
    }

    SphereMesh {
        id: sphereMesh
        radius: 3
    }

    Transform {
        id: sphereTransform
        property real userAngle: 0.0
        matrix: {
            var m = Qt.matrix4x4();
            m.rotate(userAngle, Qt.vector3d(0, 1, 0));
            m.translate(Qt.vector3d(20, 0, 0));
            return m;
        }
    }

    NumberAnimation {
        target: sphereTransform
        property: "userAngle"
        duration: 10000
        from: 0
        to: 360

        loops: Animation.Infinite
        running: true
    }

    Entity {
        id: sphereEntity
        components: [ sphereMesh, material, sphereTransform ]
    }
}
