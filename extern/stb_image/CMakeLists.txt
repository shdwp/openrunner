cmake_minimum_required(VERSION 3.15)
project(stb_image)

set(CMAKE_CXX_STANDARD 17)

add_library(${PROJECT_NAME} src/stb_image.cpp src/stb_image_write.cpp)
target_include_directories(${PROJECT_NAME} PUBLIC include)