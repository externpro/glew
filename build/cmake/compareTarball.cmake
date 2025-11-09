# Get the most recent git tag (e.g., 'glew-2.2.0' or 'v2.2.0.1')
execute_process(COMMAND git describe --tags --abbrev=0
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_TAG
  OUTPUT_STRIP_TRAILING_WHITESPACE
  RESULT_VARIABLE GIT_RESULT
  )
if(GIT_RESULT)
  message(FATAL_ERROR "Failed to get git tag: ${GIT_RESULT}")
endif()
# Extract just the version number (X.Y.Z) from the git tag
# Handles both 'glew-X.Y.Z' and 'vX.Y.Z' formats by stripping the prefix
string(REGEX REPLACE "^(glew-|v)([0-9]+\\.[0-9]+\\.[0-9]+).*$" "\\2" GLEW_VERSION "${GIT_TAG}")
message(STATUS "Git tag: ${GIT_TAG}")
message(STATUS "Extracted GLEW version: ${GLEW_VERSION}")
# Set up download URL and target directory for the GLEW source tarball
# The URL follows SourceForge's format: /glew/X.Y.Z/glew-X.Y.Z.tgz
set(GLEW_URL "https://downloads.sourceforge.net/project/glew/glew/${GLEW_VERSION}/glew-${GLEW_VERSION}.tgz")
set(GLEW_SOURCE_DIR "${CMAKE_BINARY_DIR}/glewTarball")
# Configure FetchContent to download and extract the tarball
include(FetchContent)
FetchContent_Declare(glewTarball
  URL ${GLEW_URL}
  # TRICKY: current hash is for glew-1.13.0 TODO: update hash and comment
  URL_HASH SHA256=aa25dc48ed84b0b64b8d41cdd42c8f40f149c37fa2ffa39cd97f42c78d128bc7
  SOURCE_DIR ${GLEW_SOURCE_DIR}
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  )
# Download and extract the GLEW source tarball
FetchContent_MakeAvailable(glewTarball)
if(NOT EXISTS "${GLEW_SOURCE_DIR}")
  message(FATAL_ERROR "Failed to download GLEW source to ${GLEW_SOURCE_DIR}")
endif()
message(STATUS "GLEW source downloaded to: ${GLEW_SOURCE_DIR}")
# Function to compare directories and report differences
function(compare_directories dir1 dir2)
  if(NOT IS_DIRECTORY "${dir1}")
    message(FATAL_ERROR "Directory does not exist: ${dir1}")
  endif()
  if(NOT IS_DIRECTORY "${dir2}")
    message(FATAL_ERROR "Directory does not exist: ${dir2}")
  endif()
  # Get list of files in both directories (only files, not directories)
  file(GLOB_RECURSE dir1_files_list RELATIVE "${dir1}" "${dir1}/*")
  file(GLOB_RECURSE dir2_files_list RELATIVE "${dir2}" "${dir2}/*")
  # Filter out directories, keep only regular files
  set(dir1_files "")
  set(dir2_files "")
  foreach(file ${dir1_files_list})
    if(EXISTS "${dir1}/${file}" AND NOT IS_DIRECTORY "${dir1}/${file}")
      list(APPEND dir1_files "${file}")
    endif()
  endforeach()
  foreach(file ${dir2_files_list})
    if(EXISTS "${dir2}/${file}" AND NOT IS_DIRECTORY "${dir2}/${file}")
      list(APPEND dir2_files "${file}")
    endif()
  endforeach()
  set(MISSING_FILES "")
  set(DIFF_FILES "")
  # Find files that are in dir1 but not in dir2
  foreach(file ${dir1_files})
    if(NOT EXISTS "${dir2}/${file}" OR IS_DIRECTORY "${dir2}/${file}")
      list(APPEND MISSING_FILES "File only in ${dir1}: ${file}")
    endif()
  endforeach()
  # Find files that are in dir2 but not in dir1
  foreach(file ${dir2_files})
    if(NOT EXISTS "${dir1}/${file}" OR IS_DIRECTORY "${dir1}/${file}")
      list(APPEND MISSING_FILES "File only in ${dir2}: ${file}")
    endif()
  endforeach()
  # Compare common files
  foreach(file ${dir1_files})
    if(EXISTS "${dir2}/${file}" AND NOT IS_DIRECTORY "${dir2}/${file}")
      # Compare file contents
      file(READ "${dir1}/${file}" file1_content)
      file(READ "${dir2}/${file}" file2_content)
      if(NOT "${file1_content}" STREQUAL "${file2_content}")
        list(APPEND DIFF_FILES "${file}")
      endif()
    endif()
  endforeach()
  # Report and fail if there are differences
  if(MISSING_FILES OR DIFF_FILES)
    message(STATUS "\n=== DIFFERENCES FOUND ===")
    if(MISSING_FILES)
      message(STATUS "\nMissing files:")
      foreach(msg ${MISSING_FILES})
        message(STATUS "  ${msg}")
      endforeach()
    endif()
    if(DIFF_FILES)
      message(STATUS "\nFiles with differences:")
      foreach(file ${DIFF_FILES})
        message(STATUS "  ${file}")
        # Uncomment the following line to see a diff
        # execute_process(COMMAND diff -u "${dir1}/${file}" "${dir2}/${file}")
      endforeach()
    endif()
    message(FATAL_ERROR "\nDifferences found between source directories. See above for details.")
  else()
    message(STATUS "No differences found.")
  endif()
endfunction()
# After downloading the tarball, compare the directories
if(EXISTS "${GLEW_SOURCE_DIR}")
  # Compare include directories
  message(STATUS "Comparing include directories...")
  compare_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
    "${GLEW_SOURCE_DIR}/include"
    )
  # Compare src directories
  message(STATUS "Comparing source directories...")
  compare_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${GLEW_SOURCE_DIR}/src"
    )
  message(STATUS "Comparison complete")
endif()
