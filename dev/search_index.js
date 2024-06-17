var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/#Table-of-Contents","page":"API","title":"Table of Contents","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Pages = [\"api.md\"]","category":"page"},{"location":"api/#Docstrings","page":"API","title":"Docstrings","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Modules = [QGIS]","category":"page"},{"location":"api/#QGIS.df","page":"API","title":"QGIS.df","text":"QGIS.df\n\nA DataFrame containing the metadata for all available QGIS algorithms.\n\n\n\n\n\n","category":"constant"},{"location":"api/#QGIS.Algorithm","page":"API","title":"QGIS.Algorithm","text":"QGIS.Algorithm(name)\n\nObject representing a QGIS algorithm.  The struct contains the help, metadata, and default parameters for the algorithm.  Algorithms are callable and expect a String input (filename) and optional String output (filename).\n\nExample\n\nusing QGIS, GeoJSON, Plots, GeoInterfaceRecipes\n\nbuffer = QGIS.Algorithm(\"native:buffer\", DISTANCE=0.1)\n\ninput = joinpath(dirname(pathof(QGIS)), \"..\", \"test\", \"nc.geojson\")\n\nnc = GeoJSON.read(input)\n\noutput = buffer(input)\n\nnc_buffered = GeoJSON.read(output)\n\nplot(\n    plot(nc.geometry),\n    plot(nc_buffered.geometry),\n    layout = (2, 1)\n)\n\n\n\n\n\n","category":"type"},{"location":"api/#QGIS.help-Tuple{AbstractString}","page":"API","title":"QGIS.help","text":"help(alg)\n\nReturn the help (in JSON format) for the associated algorithm.\n\n\n\n\n\n","category":"method"},{"location":"api/#QGIS.metadata-Tuple{Any}","page":"API","title":"QGIS.metadata","text":"metadata(alg)\n\nReturn the associated metadata for a given algorithm.  Returns the associated DataFrameRow from QGIS.df.\n\n\n\n\n\n","category":"method"},{"location":"#QGIS.jl","page":"QGIS.jl","title":"QGIS.jl","text":"","category":"section"},{"location":"","page":"QGIS.jl","title":"QGIS.jl","text":"QGIS.jl provides a Julia interface to the QGIS geospatial processing library via QGIS' command line utilities.","category":"page"},{"location":"#Setup","page":"QGIS.jl","title":"Setup","text":"","category":"section"},{"location":"","page":"QGIS.jl","title":"QGIS.jl","text":"To install QGIS.jl, run","category":"page"},{"location":"tutorial/#Tutorial","page":"Tutorial","title":"Tutorial","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"This tutorial will guide you through the process of finding and running a QGIS algorithm on geospatial data in Julia.  What we'll do:","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"Read in some GeoJSON data using GeoJSON.\nFind an algorithm for adding a buffer around the boundaries of the data.\nRun the algorithm on the data.\nVisualize the results.","category":"page"},{"location":"tutorial/#Step-1:-Load-Required-Packages","page":"Tutorial","title":"Step 1: Load Required Packages","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: First, we need to load some Packages\nGeoJSON: for reading in GeoJSON data.\nQGIS: for finding and running algorithms.\nPlots: for visualizing the data.\nGeoInterfaceRecipes: for providing plot recipes for the GeoJSON data.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"using GeoJSON, QGIS, Plots, GeoInterfaceRecipes","category":"page"},{"location":"tutorial/#Step-2:-Read-in-GeoJSON-data","page":"Tutorial","title":"Step 2: Read in GeoJSON data","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: Data\nThe test/ directory of QGIS contains a GeoJSON file named nc.geojson (the state boundaries of North Carolina).","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"path = joinpath(dirname(pathof(QGIS)), \"..\", \"test\", \"nc.geojson\");\n\nnc = GeoJSON.read(path)\n\nplot(nc.geometry; aspect_ratio=:equal, linewidth=0);\n\nsavefig(\"nc.png\")  # hide","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"(Image: )","category":"page"},{"location":"tutorial/#Step-3:-Find-a-Buffer-Algorithm","page":"Tutorial","title":"Step 3: Find a Buffer Algorithm","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: Algorithm Metadata\nQGIS has an (unexported) df::DataFrame that holds all the metadata on the QGIS algorithms.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"QGIS.df","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: Search for Buffer Algorithms\nWe can search for algorithms that contain the word \"buffer\" in their name.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"filter(x -> occursin(\"buffer\", string(x.algorithm)), QGIS.df)","category":"page"},{"location":"tutorial/#Step-4:-Run-the-Buffer-Algorithm","page":"Tutorial","title":"Step 4: Run the Buffer Algorithm","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: `QGIS.Algorithm`\nThe QGIS.Algorithm holds the help, metadata, and parameters for a QGIS algorithm.\nThe constructor takes the algorithm name and parameters as keyword arguments.\nParameters and their assigned values are displayed in the Base.show method.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"alg = QGIS.Algorithm(\"native:buffer\", DISTANCE=0.1)","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"info: Running Algorithms\nQGIS.Algorithms are callable and accepts optional input/output arguments to override the INPUT and OUTPUT parameters.  Note that these arguments refer to file paths.","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"output = alg(GeoJSON.write(tempname() * \".geojson\", nc))\n\nnc_buffered = GeoJSON.read(output)\n\nplot(nc_buffered.geometry; aspect_ratio=:equal, linewidth=0, color=2);\n\nsavefig(\"nc_buffered.png\")  # hide","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"(Image: )","category":"page"},{"location":"tutorial/#Step-5:-Visualize-the-Results","page":"Tutorial","title":"Step 5: Visualize the Results","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"plot(nc_buffered.geometry; aspect_ratio=:equal, linewidth=0, label=\"Buffered\", color=2);\n\nplot!(nc.geometry; aspect_ratio=:equal, linewidth=0, label=\"Original\", color=1);\n\nsavefig(\"nc_comparison.png\")  # hide","category":"page"},{"location":"tutorial/","page":"Tutorial","title":"Tutorial","text":"(Image: )","category":"page"}]
}