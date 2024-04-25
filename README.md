# QGIS

[![Build Status](https://github.com/joshday/QGIS.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/joshday/QGIS.jl/actions/workflows/CI.yml?query=branch%3Amain)


This package uses the [command line processing](https://docs.qgis.org/3.34/en/docs/user_manual/processing/standalone.html) utilities of QGIS to run geoprocessing tasks from Julia.

## Usage

```julia
using QGIS

QGIS.find_algorithm("buffer")
# 12-element Vector{String}:
#  "gdal:buffervectors"
#  "gdal:onesidebuffer"
#  "grass:r.buffer"
#  "grass:r.buffer.lowmem"
#  "grass:v.buffer"
#  "native:buffer"
#  "native:bufferbym"
#  "native:multiringconstantbuffer"
#  "native:singlesidedbuffer"
#  "native:taperedbuffer"
#  "native:wedgebuffers"
#  "qgis:variabledistancebuffer"

QGIS.run("native:buffer"; INPUT="test/nc.geojson", DISTANCE=2, OUTPUT="test/ncbuffered.geojson")
```
