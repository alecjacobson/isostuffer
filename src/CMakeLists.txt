## CMake specification for src directory

set(SOURCES config.h
    tables.h            IsoStuffer.hpp
    OctTree.h           OctTree.cpp
    DistValProc.h       DistValProc.cpp)

# utils/
set(UTILS_SRC
    utils/macros.h      utils/math.hpp)

# linearalgebra
set(LINEAR_SRC
    linearalgebra/eig3.h    linearalgebra/eig3.cpp)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${Boost_INCLUDE_DIR})
link_directories(${Boost_LIBRARY_DIRS})

if ( USE_GUI )
    # turn on the features of Qt for libQGLViewer
    set(QT_USE_QTXML 1)
    set(QT_USE_QTOPENGL 1)

    include(${QT_USE_FILE})

    include_directories(
        ${GLUT_INCLUDE_DIR}
        ${OPENGL_INCLUDE_DIR}
        ${QGLViewer_INCLUDE_DIR})

    # setup the qrc files
    set(UI_QRC_FILES ui/images.qrc)
    QT4_ADD_RESOURCES(UI_QRC_SRCS ${UI_QRC_FILES})

    # headers to be moc-ified
    set(UI_MOC_HEADERS 
        ui/IsoStufferFrame.h    ui/IsoStufferCanvas.h
        ui/ParamsDialog.h)
    # the ui files
    set(UI_UI_FILES ui/IsoStufferFrame.ui ui/Params.ui)

    QT4_WRAP_CPP(UI_MOC_SRCS ${UI_MOC_HEADERS})
    QT4_WRAP_UI(UI_UI_SRCS ${UI_UI_FILES})

    set(GUIAPP_SRCS GuiMain.cpp
        ui/IsoStufferFrame.h    ui/IsoStufferFrame.cpp
        io/TglMeshReader.hpp    io/TglMeshReader.cpp
        ui/IsoStufferCanvas.h   ui/IsoStufferCanvas.cpp
        ${UI_UI_SRCS} ${UI_MOC_SRCS} ${UI_QRC_SRCS} )
    
    # =========================================================================
    # set for the final executable for isostuffer
    add_executable(isostuffer-gui
        ${GUIAPP_SRCS}          ${SOURCES}              ${UTILS_SRC}
        ${LINEAR_SRC})

    target_link_libraries(isostuffer-gui
        ${GLUT_LIBRARIES}       ${QT_LIBRARIES}         ${QGLViewer_LIBRARY}
        ${ICC_LIBS})

    set_target_properties(isostuffer-gui PROPERTIES LINK_FLAGS ${LINK_FLAGS})
endif ( USE_GUI ) 


# =============================================================================
add_executable(isostuffer
    io/TglMeshReader.hpp    io/TglMeshReader.cpp
    main.cpp
    ${SOURCES}              ${UTILS_SRC}            ${LINEAR_SRC})

target_link_libraries(isostuffer ${ICC_LIBS}        boost_program_options)

set_target_properties(isostuffer PROPERTIES LINK_FLAGS ${LINK_FLAGS})

