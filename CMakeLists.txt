cmake_minimum_required(VERSION 2.8)
project (dockerandjenkins CXX)
# Make building tests optional
OPTION (BUILD_TESTS "Build Tests" OFF)
set(libname "dockerandjenkinslib")

include_directories(include)
# Add all files in source and include to the sources
file(GLOB SOURCES src/*.* include/*.*)
# Remove main, as I want to build both a lib and an executable
list(REMOVE_ITEM SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp)

# If we want to build this in both shared and static version
add_definitions(-DSHARED_LIBS)

# This builds the library
add_library (${libname} SHARED ${SOURCES})

# This builds the executable and links it against the current lib
add_executable(dockerandjenkinsapp src/main.cpp)
target_link_libraries(dockerandjenkinsapp ${libname})

if(BUILD_TESTS)
	SET(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Modules)
	include(AddTests)
	ADD_TESTS(LIBNAME ${libname})
	
	if(UNIX)
		include(EnableCoverageReport)
		ENABLE_COVERAGE_REPORT(TARGETS ${libname})
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -O0 -W -Wshadow -Wno-system-headers -Wno-deprecated -Woverloaded-virtual -Wwrite-strings -fprofile-arcs -ftest-coverage")
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c++11 -g -O0 -Wall -W -fprofile-arcs -ftest-coverage")
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
		SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
		target_link_libraries(${libname} gcov)
    endif()
endif(BUILD_TESTS)