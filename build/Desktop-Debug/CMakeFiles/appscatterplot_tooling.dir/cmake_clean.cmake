file(REMOVE_RECURSE
  "scatterplot/Main.qml"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/appscatterplot_tooling.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
