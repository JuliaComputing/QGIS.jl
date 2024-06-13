# Tutorial

This tutorial will guide you through the process of finding and running a QGIS algorithm on geospatial data in Julia.  What we'll do:

1. Read in some GeoJSON data using **GeoJSON**.
2. Find an algorithm for adding a buffer around the boundaries of the data.
3. Run the algorithm on the data.
4. Visualize the results.

## Step 1: Load Required Packages

!!! info "First, we need to load some Packages"
    1. **GeoJSON**: for reading in GeoJSON data.
    2. **QGIS**: for finding and running algorithms.
    3. **Plots**: for visualizing the data.
    4. **GeoInterfaceRecipes**: for providing [plot recipes](https://docs.juliaplots.org/latest/recipes/) for the GeoJSON data.

```@repl tutorial
using GeoJSON, QGIS, Plots, GeoInterfaceRecipes
```

## Step 2: Read in GeoJSON data


!!! info "Data"
    The `test/` directory of **QGIS** contains a GeoJSON file named `nc.geojson` (the state boundaries of North Carolina).

```@repl tutorial
path = joinpath(dirname(pathof(QGIS)), "..", "test", "nc.geojson");

nc = GeoJSON.read(path)

plot(nc.geometry; aspect_ratio=:equal, linewidth=0);

savefig("nc.png")  # hide
```

![](nc.png)

## Step 3: Find a Buffer Algorithm

!!! info "Algorithm Metadata"
    **QGIS** has an (unexported) `df::DataFrame` that holds all the metadata on the QGIS algorithms.

```@repl tutorial
QGIS.df
```

!!! info "Search for Buffer Algorithms"
    - We can search for algorithms that contain the word "buffer" in their name.

```@repl tutorial
filter(x -> occursin("buffer", string(x.algorithm)), QGIS.df)
```

## Step 4: Run the Buffer Algorithm

!!! info "`QGIS.Algorithm`"
    - The `QGIS.Algorithm` holds the help, metadata, and parameters for a QGIS algorithm.
    - The constructor takes the algorithm name and parameters as keyword arguments.
    - Parameters and their assigned values are displayed in the `Base.show` method.

```@repl tutorial
alg = QGIS.Algorithm("native:buffer", DISTANCE=0.1)
```

!!! info "Running Algorithms"
    - `QGIS.Algorithm`s are callable and accepts optional input/output arguments to override the
    `INPUT` and `OUTPUT` parameters.  Note that these arguments refer to **file paths**.

```@repl tutorial
output = alg(GeoJSON.write(tempname() * ".geojson", nc))

nc_buffered = GeoJSON.read(output)

plot(nc_buffered.geometry; aspect_ratio=:equal, linewidth=0, color=2);

savefig("nc_buffered.png")  # hide
```

![](nc_buffered.png)

## Step 5: Visualize the Results

```@repl tutorial
plot(nc_buffered.geometry; aspect_ratio=:equal, linewidth=0, label="Buffered", color=2);

plot!(nc.geometry; aspect_ratio=:equal, linewidth=0, label="Original", color=1);

savefig("nc_comparison.png")  # hide
```

![](nc_comparison.png)
