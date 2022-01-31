function find_projects
{
    for name in *; do
        # Filter out actual files.
        [[ ! -d "$name" ]] && continue;
        # Filter anything which doesn't specify compiler type.
        [[ ! "$name" =~ ([a-zA-Z0-9]+)\.([a-zA-Z0-9]+) ]] && continue;

        echo "$name/${BASH_REMATCH[1]}\.*"
    done
}
## echo ${TEMPLATE/%FMT_BUILD_TARGETS%/"${PROJECT_LIST[@]}"}

function print_find_projects
{
    for filename_main in $(find_projects); do
        [[ ! "$filename_main" =~ ([a-zA-Z0-9\.]+)/([a-zA-Z0-9\.]+) ]] && continue;
        echo """
# Project ${BASH_REMATCH[1]}
add_executable(${BASH_REMATCH[1]} ${BASH_REMATCH[0]})
target_include_directories(${BASH_REMATCH[1]} PRIVATE $(realpath ${BASH_REMATCH[1]}))
set_target_properties(${BASH_REMATCH[1]} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG \${CMAKE_CURRENT_BINARY_DIR})"""
    done

}

echo """
set(CMP0048 NEW)
cmake_minimum_required(VERSION 3.10)
project(exercises)
$(print_find_projects)
""" | tee CMakeLists.txt


cmake -S. -Bbuild
cmake --build build

rm CMakeLists.txt