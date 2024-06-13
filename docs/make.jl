using Documenter
using QGIS

makedocs(
    sitename = "QGIS",
    format = Documenter.HTML(
        assets = [asset("https://rsms.me/inter/inter.css")],
        size_threshold_warn = 500 * 1024,
        size_threshold = 1000 * 1024
    ),
    modules = [QGIS],
    pages=["index.md", "tutorial.md", "api.md"]
)

deploydocs(repo="https://github.com/joshday/QGIS.jl")
