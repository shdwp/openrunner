cmake_minimum_required(VERSION 3.15)
project(glfw)

set(CMAKE_CXX_STANDARD 17)

add_library(${PROJECT_NAME} OBJECT libglfw3.a)
target_include_directories(${PROJECT_NAME} INTERFACE include)