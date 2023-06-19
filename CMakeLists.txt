cmake_minimum_required(VERSION 3.16)

project(qt3d-simple VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appqt3d-simple
    main.cpp
)

qt_add_qml_module(appqt3d-simple
    URI qt3d-simple
    VERSION 1.0
    QML_FILES
        Main.qml
        Scene.qml
        SimpleForwardRenderer.qml
    )

set_target_properties(appqt3d-simple PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appqt3d-simple
    PRIVATE Qt6::Quick
)

install(TARGETS appqt3d-simple
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
