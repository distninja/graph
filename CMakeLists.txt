cmake_minimum_required(VERSION 3.16)
project(graph)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Go library configuration
set(GO_SOURCE_DIR "${CMAKE_SOURCE_DIR}")
set(GO_OUTPUT_DIR "${CMAKE_BINARY_DIR}/graph")
set(GO_LIB_NAME "graph")

# Build Go shared library
add_custom_command(
    OUTPUT ${GO_OUTPUT_DIR}/lib${GO_LIB_NAME}.so ${GO_OUTPUT_DIR}/lib${GO_LIB_NAME}.h
    COMMAND ${CMAKE_COMMAND} -E make_directory ${GO_OUTPUT_DIR}
    COMMAND go build -buildmode=c-shared -o ${GO_OUTPUT_DIR}/lib${GO_LIB_NAME}.so ${GO_SOURCE_DIR}/main.go
    DEPENDS ${GO_SOURCE_DIR}/graph/graph.go
    WORKING_DIRECTORY ${GO_SOURCE_DIR}
    COMMENT "Building Go shared library"
)

# Create custom target for Go library
add_custom_target(go_library DEPENDS ${GO_OUTPUT_DIR}/lib${GO_LIB_NAME}.so)

# C++ executable
add_executable(test
    test/main.cc
)

# Add dependency on Go library
add_dependencies(test go_library)

# Include directories
target_include_directories(test PRIVATE
    ${GO_OUTPUT_DIR}
)

# Link libraries
target_link_libraries(test PRIVATE
    ${GO_OUTPUT_DIR}/lib${GO_LIB_NAME}.so
    pthread
)

# Set runtime path for shared library
set_target_properties(test PROPERTIES
    INSTALL_RPATH "${GO_OUTPUT_DIR}"
    BUILD_WITH_INSTALL_RPATH TRUE
)

# Copy Go library to output directory during build
add_custom_command(TARGET test POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${GO_OUTPUT_DIR}/lib${GO_LIB_NAME}.so
    $<TARGET_FILE_DIR:test>
)
