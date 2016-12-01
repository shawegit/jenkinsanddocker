cmake_minimum_required(VERSION 2.8)
project (dockerandjenkins CXX)
include_directories(include)

# Add all files in source and include to the sources
file(GLOB SOURCES src/*.* include/*.*)
# Remove main, as I want to build both a lib and an executable
list(REMOVE_ITEM SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp)

# If we want to build this in both shared and static version
add_definitions(-DSHARED_LIBS)

# This builds the library
add_library (dockerandjenkinslib SHARED ${SOURCES})

# This builds the executable and links it against the current lib
add_executable(dockerandjenkinsapp src/main.cpp)
target_link_libraries(dockerandjenkinsapp dockerandjenkinslib)