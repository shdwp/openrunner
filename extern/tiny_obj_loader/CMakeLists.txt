cmake_minimum_required(VERSION 3.15)
project(tinyobjloader)

set(CMAKE_CXX_STANDARD 17)

add_library(${PROJECT_NAME} src/tiny_obj_loader.cc)
target_include_directories(${PROJECT_NAME} PUBLIC include)