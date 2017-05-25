# This module is taken from CMake original find-modules and adapted for the
# needs of this project:
# * load Vulkan headers from third_party/vulkan
# * load Vulkan-Hpp headers from third_party/vulkan-hpp
# Below notice is from original file:

# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# FindVulkan
# ----------
#
# Try to find Vulkan
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines :prop_tgt:`IMPORTED` target ``Vulkan::Vulkan``, if
# Vulkan has been found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables::
#
#   Vulkan_FOUND           - True if Vulkan was found
#   Vulkan_INCLUDE_DIRS    - include directories for Vulkan and third-party Vulkan-Hpp
#   Vulkan_LIBRARIES       - link against this library to use Vulkan
#
# The module will also define the following cache variables::
#
#   Vulkan_INCLUDE_DIR     - the Vulkan include directory
#   Vulkan_Hpp_INCLUDE_DIR - the Vulkan-Hpp include directory
#   Vulkan_LIBRARY         - the path to the Vulkan library
#

# Vulkan header file
find_path(Vulkan_INCLUDE_DIR
  NAMES vulkan/vulkan.h
  PATHS "../third_party/vulkan/src/"
  NO_DEFAULT_PATH
  )

# Vulkan-Hpp header file
find_path(Vulkan_Hpp_INCLUDE_DIR
  NAMES vulkan/vulkan.hpp
  PATHS "../third_party/vulkan-hpp/"
  NO_DEFAULT_PATH
  )

# Vulkan library
if(WIN32)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    find_library(Vulkan_LIBRARY
      NAMES vulkan-1
      PATHS
        "$ENV{VULKAN_SDK}/Lib"
        "$ENV{VULKAN_SDK}/Bin"
        )
  elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
    find_library(Vulkan_LIBRARY
      NAMES vulkan-1
      PATHS
        "$ENV{VULKAN_SDK}/Lib32"
        "$ENV{VULKAN_SDK}/Bin32"
        NO_SYSTEM_ENVIRONMENT_PATH
        )
  endif()
else()
    find_library(Vulkan_LIBRARY
      NAMES vulkan
      PATHS
        "$ENV{VULKAN_SDK}/lib")
endif()

set(Vulkan_LIBRARIES ${Vulkan_LIBRARY})
set(Vulkan_INCLUDE_DIRS ${Vulkan_INCLUDE_DIR} ${Vulkan_Hpp_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Vulkan
  DEFAULT_MSG
  Vulkan_LIBRARY Vulkan_INCLUDE_DIR Vulkan_Hpp_INCLUDE_DIR)

mark_as_advanced(Vulkan_INCLUDE_DIR Vulkan_Hpp_INCLUDE_DIR Vulkan_LIBRARY)

if(Vulkan_FOUND AND NOT TARGET Vulkan::Vulkan)
  add_library(Vulkan::Vulkan UNKNOWN IMPORTED)
  set_target_properties(Vulkan::Vulkan PROPERTIES
    IMPORTED_LOCATION "${Vulkan_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${Vulkan_INCLUDE_DIRS}")
endif()
