cmake_minimum_required(VERSION 3.16)

project(Sphera VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appSphera
    main.cpp
)

qt_add_qml_module(appSphera
    URI Sphera
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES Icons/pause.svg Icons/play.svg
        RESOURCES Icons/book.svg Icons/plus.svg Icons/settings.svg Icons/stack.svg Icons/timelapse.svg Icons/book.svg
        RESOURCES Icons/Background.png
        RESOURCES Icons/heart_0.svg Icons/heart.svg
        RESOURCES Icons/Background.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSphera PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSphera
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSphera
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appSphera
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
