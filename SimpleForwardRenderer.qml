// Copyright (C) 2015 Klaralvdalens Datakonsult AB (KDAB).
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import Qt3D.Core 2.15
import Qt3D.Render 2.15

TechniqueFilter {
    // Expose camera to allow user to choose which camera to use for rendering
    property alias camera: cameraSelector.camera
    property alias clearColor: clearBuffer.clearColor
    property alias viewportRect: viewport.normalizedRect
    property alias window: surfaceSelector.surface
    property alias externalRenderTargetSize: surfaceSelector.externalRenderTargetSize
    property alias frustumCulling: frustumCulling.enabled

    property alias alphaLayer: alphaLayer

    // Select the forward rendering Technique of any used Effect
    matchAll: [ FilterKey { name: "renderingStyle"; value: "forward" } ]

    RenderSurfaceSelector {
        id: surfaceSelector

        // Use the whole viewport
        Viewport {
            id: viewport
            normalizedRect: Qt.rect(0.0, 0.0, 1.0, 1.0)

            // Use the specified camera
            CameraSelector {
                id : cameraSelector
                FrustumCulling {
                    id: frustumCulling

                    // Render opaque entities, with writing into depth buffer.
                    LayerFilter {
                        filterMode: LayerFilter.DiscardAnyMatchingLayers
                        layers: [alphaLayer]
                        ClearBuffers {
                            id: clearBuffer
                            clearColor: "white"
                            buffers : ClearBuffers.ColorDepthBuffer
                        }
                    }

                    // Render non-opaque entities, without writing into depth buffer.
                    // Depth test is still enabled.
                    LayerFilter {
                        filterMode: LayerFilter.AcceptAnyMatchingLayers
                        layers: [alphaLayer]
                        SortPolicy {
                            sortTypes: [SortPolicy.BackToFront]
                        }
                    }
                }
            }
        }
    }

    Layer {
        id: alphaLayer
    }
}
