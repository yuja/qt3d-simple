// Copyright (C) 2014 Klaralvdalens Datakonsult AB (KDAB).
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick 2.15
import Qt3D.Core 2.15
import Qt3D.Extras 2.15
import Qt3D.Input 2.15
import Qt3D.Render 2.15

Entity {
    property alias camera: camera
    property alias clearColor: renderer.clearColor
    property alias sphereAnimationRunning: sphereAnimation.running
    property alias sphereAngle: sphereTransform.userAngle

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
            activeFrameGraph: SimpleForwardRenderer {
                id: renderer
                clearColor: Qt.rgba(0, 0.5, 1, 1)
                camera: camera
            }
            // Even if OnDemand rendering is set, Quick items will be re-rendered indefinitely.
            // https://bugreports.qt.io/browse/QTBUG-90856
            // https://bugreports.qt.io/browse/QTBUG-96373
            // https://bugreports.qt.io/browse/QTBUG-109366
            //renderPolicy: RenderSettings.OnDemand
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

        DiffuseSpecularMaterial {
            id: helperPlaneMaterial
            ambient: "#808080"
        }

        Entity {
            id: yzHelperPlane
            components: [
                helperPlaneMesh,
                helperPlaneMaterial,
                yzHelperPlaneTransform,
            ]
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
                helperPlaneMaterial,
                xzHelperPlaneTransform,
            ]
            Transform {
                id: xzHelperPlaneTransform
            }
        }

        Entity {
            id: xyHelperPlane
            components: [
                helperPlaneMesh,
                helperPlaneMaterial,
                xyHelperPlaneTransform,
            ]
            Transform {
                id: xyHelperPlaneTransform
                // to XY plane
                rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 90)
            }
        }

        CylinderMesh {
            id: axisMesh
            length: 20
            radius: 0.1
        }

        Entity {
            id: xAxis
            components: [
                axisMesh,
                xAxisMaterial,
                xAxisTransform,
            ]
            DiffuseSpecularMaterial {
                id: xAxisMaterial
                ambient: "#ff0000"
            }
            Transform {
                id: xAxisTransform
                translation: Qt.vector3d(10, 0, 0)
                rotation: fromAxisAndAngle(Qt.vector3d(0, 0, 1), 90)
            }
        }

        Entity {
            id: yAxis
            components: [
                axisMesh,
                yAxisMaterial,
                yAxisTransform,
            ]
            DiffuseSpecularMaterial {
                id: yAxisMaterial
                ambient: "#008000"
            }
            Transform {
                id: yAxisTransform
                translation: Qt.vector3d(0, 10, 0)
            }
        }

        Entity {
            id: zAxis
            components: [
                axisMesh,
                zAxisMaterial,
                zAxisTransform,
            ]
            DiffuseSpecularMaterial {
                id: zAxisMaterial
                ambient: "#0000ff"
            }
            Transform {
                id: zAxisTransform
                translation: Qt.vector3d(0, 0, 10)
                rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 90)
            }
        }
    }

    Entity {
        id: cuboidEntity
        components: [
            cuboidMesh,
            cuboidMaterial,
            cuboidTransform,
            renderer.alphaLayer,
        ]

        CuboidMesh {
            id: cuboidMesh
        }
        PhongAlphaMaterial {
            id: cuboidMaterial
            diffuse: "#cccccc"
            alpha: 0.5
            // By default, alpha value is overwritten by this material, and the FBO would get
            // translucent even if it was previously opaque. Since DiffuseSpecularMaterial
            // doesn't provide these properties, we use PhongAlphaMaterial instead.
            // See https://doc.qt.io/qt-6/qml-qtquick-scene3d-scene3d.html#details
            sourceAlphaArg: BlendEquationArguments.One
            destinationAlphaArg: BlendEquationArguments.OneMinusSourceAlpha
        }

        Transform {
            id: cuboidTransform
            translation: Qt.vector3d(0, 0, -10)
        }
    }

    DiffuseSpecularMaterial {
        id: torusMaterial
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
        scale3D: Qt.vector3d(1, 0.75, 0.25)
        rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 45)
    }

    Entity {
        id: torusEntity
        components: [ torusMesh, torusMaterial, torusTransform ]
    }

    SphereMesh {
        id: sphereMesh
        radius: 1
    }

    PhongAlphaMaterial {
        id: sphereMaterial
        diffuse: "#cccccc"
        alpha: 0.5
        // By default, alpha value is overwritten by this material, and the FBO would get
        // translucent even if it was previously opaque. Since DiffuseSpecularMaterial
        // doesn't provide these properties, we use PhongAlphaMaterial instead.
        // See https://doc.qt.io/qt-6/qml-qtquick-scene3d-scene3d.html#details
        sourceAlphaArg: BlendEquationArguments.One
        destinationAlphaArg: BlendEquationArguments.OneMinusSourceAlpha
    }

    Transform {
        id: sphereTransform
        property real userAngle: 0.0
        matrix: {
            var m = Qt.matrix4x4();
            m.rotate(userAngle, Qt.vector3d(0, 1, 0));
            m.translate(Qt.vector3d(10, 0, 0));
            return m;
        }

        NumberAnimation on userAngle {
            id: sphereAnimation
            duration: 10000
            from: 0
            to: 360
            loops: Animation.Infinite
        }
    }

    Entity {
        id: sphereEntity
        components: [
            sphereMesh,
            sphereMaterial,
            sphereTransform,
            renderer.alphaLayer,
        ]
    }
}
