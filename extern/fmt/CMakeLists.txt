cmake_minimum_required(VERSION 3.15)
project(fmt)

set(CMAKE_CXX_STANDARD 17)

add_library(${PROJECT_NAME} src/format.cc src/posix.cc)

target_include_directories(${PROJECT_NAME} PUBLIC include)
