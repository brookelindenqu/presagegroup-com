@def title = "Presage Group presentation at JuliaCon 2025"
@def author = "Randy Boyes"
@def date = "2021-07-24"
@def tags = ["conferences", "open-source"]
@def short_text = ""

@def rss_pubdate = Date(2021, 07, 24)
@def img = "/assets/juliacon.svg"

Presage was represented by Randy Boyes at Juliacon in Pittsburg for the second year as part of our continuing support for open source data analysis. Randy presented the recent developments in TidierPlots.jl, a `ggplot`-inspired package for data visualization in Julia.

## Key developments

TidierPlots.jl has two new computation systems, one that uses DataFrames.jl and one that relies on TidierData.jl.

```julia
aes(x = :x => x -> x/10) # DataFrames-style
@aes(x = x/10)           # TidierData-style
```

New scales, including `scale_fill`, `scale_alpha`, and more have been added, along with support for `facet_grid`. More detail is available in the slide deck and presentation linked below!

## Slides

~~~
<iframe width="800" height="400" marginheight="10" marginwidth="10" src="https://rdboyes.github.io/juliacon_2024_tidierplots/presentation.html#/title-slide">
Your browser appears to not support revealjs.
</iframe>
~~~

## Video Recording

Randy's talk can be viewed [here](https://www.youtube.com/live/HMdBi9Lrbes?si=dhWGED2UUt2N6AmY&t=411)
