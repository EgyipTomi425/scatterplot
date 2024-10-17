# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appscatterplot_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appscatterplot_autogen.dir/ParseCache.txt"
  "appscatterplot_autogen"
  )
endif()
