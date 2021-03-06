cmake_minimum_required(VERSION 3.15)
project(openrunner)

set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_VERBOSE_MAKEFILE ON)

# ------------------
# Shared libs
# ------------------
add_subdirectory(extern/glad)
add_subdirectory(extern/Shadinclude)
add_subdirectory(extern/shaderprintf)

add_subdirectory(extern/fmt)
add_subdirectory(extern/glm)
add_subdirectory(extern/stb_image)
add_subdirectory(extern/tiny_obj_loader)
add_subdirectory(extern/LuaBridge)

# ---------------
# Lib
# ---------------
set(LIB openrunner_lib)
set(LIB_SOURCES
        src/engine/Camera.cpp
        src/engine/Entity.cpp
        src/engine/Scene.cpp
        src/render/Material.cpp
        src/render/Model.cpp
        src/render/ShaderProgram.cpp
        src/render/Texture2D.cpp
        src/render/UniformBufferObject.cpp
        src/render/VertexBufferObject.cpp
        src/env/env.cpp
        src/scripting/LuaHost.cpp
        src/util/Debug.cpp
        src/render/Label.cpp
        src/font/Font.cpp
        src/ui/Input.cpp
        src/ui/UILayer.cpp
        src/ui/LayoutStack.cpp
        extern/debugger.lua/embed/debugger_lua.c
        )

add_library(${LIB} ${LIB_SOURCES})
target_include_directories(${LIB} PUBLIC include)
target_include_directories(${LIB} PUBLIC extern/debugger.lua/embed)

if (UNIX)
    target_link_libraries(${LIB} /usr/lib/liblua5.2.so /usr/lib/libglfw.so /usr/lib/libfreetype.so ${CMAKE_DL_LIBS})
    target_include_directories(${LIB} PUBLIC /usr/include/freetype2 /usr/include /usr/include/lua5.2)
else()
    target_link_libraries(${LIB} ${CMAKE_CURRENT_SOURCE_DIR}/extern/glfw/libglfw3.a)
    target_include_directories(${LIB} PUBLIC extern/glfw/include)

    target_link_libraries(${LIB} ${CMAKE_CURRENT_SOURCE_DIR}/extern/liblua/liblua53.a)
    target_include_directories(${LIB} PUBLIC extern/liblua/include)

    target_link_libraries(${LIB} ${CMAKE_CURRENT_SOURCE_DIR}/extern/freetype/lib/libfreetyped.a)
    target_include_directories(${LIB} PUBLIC extern/freetype/include)
    target_include_directories(${LIB} PUBLIC extern/freetype/include/freetype)
endif()

target_link_libraries(${LIB} LuaBridge)
target_link_libraries(${LIB} glad)
target_link_libraries(${LIB} glm)
target_link_libraries(${LIB} stb_image)
target_link_libraries(${LIB} tinyobjloader)
target_link_libraries(${LIB} Shadinclude)
target_link_libraries(${LIB} shaderprintf)
target_link_libraries(${LIB} fmt)

# ---------------
# App
# ---------------
set(APP openrunner_app)
file(GLOB APP_SOURCES app/*.cpp)

add_executable(${APP} ${APP_SOURCES}
        app/model/board/GameBoard.cpp
        app/model/board/GameBoard.h
        app/model/card/Card.cpp
        app/model/card/Card.h
        app/view/widgets/StackWidget.cpp
        app/view/widgets/StackWidget.h
        app/model/card/Deck.cpp
        app/model/card/Deck.h
        app/view/materials/CardMaterial.cpp
        app/view/materials/CardMaterial.h
        app/view/board/GameBoardView.cpp
        app/view/board/GameBoardView.h
        app/view/board/CardView.cpp
        app/view/board/CardView.h
        app/controller/Scripting.cpp
        app/controller/Scripting.h
        app/view/widgets/ActionWidget.cpp
        app/view/widgets/ActionWidget.h
        app/view/board/SlotView.cpp
        app/view/board/SlotView.h
        app/view/board/DeckView.cpp app/view/board/DeckView.h app/view/board/SlotInteractable.cpp app/view/board/SlotInteractable.h app/view/board/ZoomCardView.cpp app/view/board/ZoomCardView.h app/view/widgets/CardSelectWidget.cpp app/view/widgets/CardSelectWidget.h app/view/widgets/OptionSelectWidget.cpp app/view/widgets/OptionSelectWidget.h)

# ---------------
# Link
# ---------------
target_link_libraries(${APP} ${LIB})
