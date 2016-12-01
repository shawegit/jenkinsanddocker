include(ParseArguments)
include(CTest)

FUNCTION(ADD_TESTS_AND_COVERAGE)
	PARSE_ARGUMENTS(ARG "LIBNAME" "" ${ARGN})
    set(Boost_USE_STATIC_LIBS        ON) # only find static libs
    set(Boost_USE_MULTITHREADED      ON)
    set(Boost_USE_STATIC_RUNTIME    OFF)
    find_package(Boost COMPONENTS system filesystem unit_test_framework)
    include_directories (${Boost_INCLUDE_DIRS})
    #I like to keep test files in a separate source directory called test
    file(GLOB TEST_SRCS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} test/*.cpp)
    # Taken from https://eb2.co/blog/2015/06/driving-boost-dot-test-with-cmake/
    foreach(SOURCE_FILE_NAME  ${TEST_SRCS})
        #Extract the filename without an extension (NAME_WE)
        get_filename_component(testSuiteName ${SOURCE_FILE_NAME} NAME_WE)
        #Rename Test_... for better ordering
        string(REGEX REPLACE "Test" "" testSuiteName ${testSuiteName})
        set(testSuiteName Test_${testSuiteName})
        #Add compile target
        add_executable(${testSuiteName} ${SOURCE_FILE_NAME})
        #link to Boost libraries AND your targets and dependencies
        target_link_libraries(${testSuiteName} ${ARG_LIBNAME} ${Boost_LIBRARIES} )
        #Open the current source file, i.e. some test/.cpp
        file(READ "${SOURCE_FILE_NAME}" SOURCE_FILE_CONTENTS)
        #Get all test functions of the form BOOST_FIXTURE_TEST_CASE(NAME, FIXTURE), but only the part BOOST_FIXTURE_TEST_CASE(NAME
        string(REGEX MATCHALL "BOOST_FIXTURE_TEST_CASE\\( *([A-Za-z_0-9]+) *" FOUND_TESTS ${SOURCE_FILE_CONTENTS})
        # Get the test suits name. This is necessary for calling the respective subtests in run_test
        string(REGEX MATCHALL "BOOST_AUTO_TEST_SUITE\\( *([A-Za-z_0-9]+) *\\)" TEST_SUIT_NAMES ${SOURCE_FILE_CONTENTS})
        list(GET TEST_SUIT_NAMES 0 SUITE_NAME)
        string(REGEX REPLACE ".*\\( *([A-Za-z_0-9]+) *.*" "\\1" REAL_NAME ${SUITE_NAME})
        # Iterate over all tests, and add them to CTest
        foreach(singleBoostTest ${FOUND_TESTS})
            string(REGEX REPLACE ".*\\( *([A-Za-z_0-9]+) *.*" "\\1" TEST_NAME ${singleBoostTest})
            add_test(NAME "${testSuiteName}.${TEST_NAME}" COMMAND ${testSuiteName} --run_test=${REAL_NAME}/${TEST_NAME} --detect_memory_leaks=0)
        endforeach()
    endforeach(SOURCE_FILE_NAME)

    add_custom_target(RUN_TEST_WITH_OUTPUT ${CMAKE_COMMAND} -E env CTEST_OUTPUT_ON_FAILURE=1 ${CMAKE_CTEST_COMMAND} 
        -C $<CONFIG> --verbose WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
    
    if(UNIX)
		include(EnableCoverageReport)
		ENABLE_COVERAGE_REPORT(TARGETS ${ARG_LIBNAME})
    endif()
ENDFUNCTION()
#