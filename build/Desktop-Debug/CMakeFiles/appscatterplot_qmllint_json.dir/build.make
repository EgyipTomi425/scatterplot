# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.29

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/kecyke/Qt/Tools/CMake/bin/cmake

# The command to remove a file.
RM = /home/kecyke/Qt/Tools/CMake/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/kecyke/Dokumentumok/qt/scatterplot

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug

# Utility rule file for appscatterplot_qmllint_json.

# Include any custom commands dependencies for this target.
include CMakeFiles/appscatterplot_qmllint_json.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/appscatterplot_qmllint_json.dir/progress.make

CMakeFiles/appscatterplot_qmllint_json: /usr/lib/qt6/bin/qmllint
CMakeFiles/appscatterplot_qmllint_json: /home/kecyke/Dokumentumok/qt/scatterplot/Main.qml
	cd /home/kecyke/Dokumentumok/qt/scatterplot && /usr/lib/qt6/bin/qmllint --bare -I /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug -I /usr/lib/x86_64-linux-gnu/qt6/qml --resource /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug/.rcc/qmake_scatterplot.qrc --resource /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug/.rcc/appscatterplot_raw_qml_0.qrc /home/kecyke/Dokumentumok/qt/scatterplot/Main.qml --json /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug/appscatterplot_qmllint.json

appscatterplot_qmllint_json: CMakeFiles/appscatterplot_qmllint_json
appscatterplot_qmllint_json: CMakeFiles/appscatterplot_qmllint_json.dir/build.make
.PHONY : appscatterplot_qmllint_json

# Rule to build all files generated by this target.
CMakeFiles/appscatterplot_qmllint_json.dir/build: appscatterplot_qmllint_json
.PHONY : CMakeFiles/appscatterplot_qmllint_json.dir/build

CMakeFiles/appscatterplot_qmllint_json.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/appscatterplot_qmllint_json.dir/cmake_clean.cmake
.PHONY : CMakeFiles/appscatterplot_qmllint_json.dir/clean

CMakeFiles/appscatterplot_qmllint_json.dir/depend:
	cd /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/kecyke/Dokumentumok/qt/scatterplot /home/kecyke/Dokumentumok/qt/scatterplot /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug /home/kecyke/Dokumentumok/qt/scatterplot/build/Desktop-Debug/CMakeFiles/appscatterplot_qmllint_json.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/appscatterplot_qmllint_json.dir/depend
