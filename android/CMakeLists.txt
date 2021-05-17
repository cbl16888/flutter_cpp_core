cmake_minimum_required(VERSION 3.4.1)

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")

find_library(log-lib log)

add_library(native_with_opencv SHARED ../ios/Classes/native_add.cpp)
