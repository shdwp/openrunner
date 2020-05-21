cmake_minimum_required(VERSION 3.15)
project(glad)

set(CMAKE_CXX_STANDARD 17)

add_library(${PROJECT_NAME} src/glad.c)
target_include_directories(${PROJECT_NAME} PUBLIC include)