% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_counts.R
\name{plot_counts}
\alias{plot_counts}
\title{Add Counts to Effects Plot}
\usage{
plot_counts(
  p,
  x,
  text_size = 3,
  facet_scales = "free_x",
  show_labels = TRUE,
  big.mark = "'",
  scientific = FALSE,
  digits = 0,
  ...
)
}
\arguments{
\item{p}{The result of \code{plot.light_effects}.}

\item{x}{An object of class \code{light_effects}.}

\item{text_size}{Size of count labels.}

\item{facet_scales}{Scales argument passed to \code{facet_wrap}.}

\item{show_labels}{Should count labels be added as text?}

\item{big.mark}{Parameter passed to \code{format} the labels. Default is "'".}

\item{scientific}{Parameter passed to \code{format} the labels. Default is FALSE.}

\item{digits}{Used to round the labels. Default is 0.}

\item{...}{Further arguments passed to \code{geom_bar}.}
}
\value{
An object of class \code{ggplot2}.
}
\description{
Add counts as labelled bar plot on top of light_effects plot.
}
\details{
Experimental. Uses package \code{ggpubr} to rearrange the figure. Thus, the resulting plot cannot be easily modified. Furthermore, adding counts only works if the legend in \code{plot.light_effects} is not placed on the left or right side of the plot. It has to be placed inside or at the bottom.
}
\examples{
fit_full <- lm(Sepal.Length ~ ., data = iris)
fit_part <- glm(Sepal.Length ~ Petal.Length, data = iris)
mod_full <- flashlight(model = fit_full, label = "full", data = iris, y = "Sepal.Length")
mod_part <- flashlight(model = fit_part, label = "part", data = iris, y = "Sepal.Length")
mods <- multiflashlight(list(mod_full, mod_part))

x <- light_effects(mod_full, v = "Petal.Width", stats = "quartiles")
plot_counts(plot(x), x, width = 0.3, alpha = 0.2)
}
\seealso{
\code{\link{plot.light_effects}}.
}
