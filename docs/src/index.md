[![CI](https://github.com/JuliaComputing/QGIS.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaComputing/QGIS.jl/actions/workflows/CI.yml)
[![DOCS](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliacomputing.github.io/QGIS.jl/dev)

# QGIS.jl

**QGIS.jl** provides a Julia interface to the [QGIS](https://qgis.org) geospatial processing library via QGIS' [command line utilities](https://docs.qgis.org/3.34/en/docs/user_manual/processing/standalone.html).  QGIS.jl is unafliliated with the [QGIS](https://qgis.org/en/site/) project.

!!! note "Julia Geospatial Ecosystem"
    Note that since QGIS.jl works directly with file names, you will likely need other packages to read and write geospatial files, such as:
    - [GeoJSON.jl](https://github.com/JuliaGeo/GeoJSON.jl)
    - [Shapefile.jl](https://github.com/JuliaGeo/Shapefile.jl)
    - [ArchGDAL.jl](https://github.com/yeesian/ArchGDAL.jl)
    - Other packages within the [JuliaGeo](https://github.com/JuliaGeo) GitHub organization.

## Installation

To install QGIS.jl, run:

```julia
using Pkg

Pkg.add("QGIS")
```

## Loading QGIS

To load the QGIS package, run

```julia
using QGIS
```
