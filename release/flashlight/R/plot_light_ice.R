#' Visualize ICE profiles
#'
#' Minimal visualization of an object of class \code{light_ice} as \code{geom_line}. The object returned is of class \code{ggplot} and can be further customized.
#'
#' Each observation is visualized by a line. The first "by" variable is represented by the color, a second "by" variable or a multiflashlight by facets.
#'
#' @import ggplot2
#' @importFrom stats reformulate
#' @method plot light_ice
#' @author Michael Mayer
#' @param x An object of class \code{light_ice}.
#' @param facet_scales Scales argument passed to \code{facet_wrap}.
#' @param rotate_x Should x axis labels be rotated by 45 degrees? Default is FALSE.
#' @param ... Further arguments passed to \code{geom_line}.
#' @return An object of class \code{ggplot2}.
#' @export
#' @examples
#' fit_full <- lm(Sepal.Length ~ ., data = iris)
#' fit_part <- lm(Sepal.Length ~ Petal.Length, data = iris)
#' mod_full <- flashlight(model = fit_full, label = "full", data = iris, y = "Sepal.Length")
#' mod_part <- flashlight(model = fit_part, label = "part", data = iris, y = "Sepal.Length")
#' mods <- multiflashlight(list(mod_full, mod_part))
#' grid <- expand.grid(Species = levels(iris$Species), Petal.Length = 2:4)
#'
#' plot(light_ice(mod_full, v = "Species"), alpha = 0.2)
#' indices <- (1:15) * 10
#' plot(light_ice(mod_full, v = "Species"), rotate_x = TRUE)
#' plot(light_ice(mods, v = "Species", indices = indices))
#' plot(light_ice(mods, v = "Species", indices = indices, center = "first"))
#' plot(light_ice(mods, v = "Petal.Width", n_bins = 5, indices = indices))
#' plot(light_ice(mods, v = "Petal.Width", by = "Species", n_bins = 5, indices = indices))
#'
#' ir <- iris
#' ir$log_sl <- log(ir$Sepal.Length)
#' fit_lm <- lm(log_sl ~ Petal.Length + Petal.Width, data = ir)
#' fit_glm <- glm(Sepal.Length ~ Petal.Length + Petal.Width,
#'   data = ir, family = Gamma(link = log))
#' fl_lm <- flashlight(model = fit_lm, label = "lm", y = "log_sl", linkinv = exp)
#' fl_glm <- flashlight(model = fit_glm, label = "glm", y = "Sepal.Length",
#'   predict_function = function(m, X) predict(m, X, type = "response"))
#' fls <- multiflashlight(list(fl_lm, fl_glm), data = ir)
#' plot(light_ice(fls, v = "Petal.Length", indices = indices))
#' plot(light_ice(fls, v = "Petal.Length", indices = indices, center = "first"))
#' plot(light_ice(fls, v = "Petal.Length", indices = indices, by = "Species", center = "first"))
#' plot(light_ice(fls, v = "Petal.Length", indices = indices, use_linkinv = FALSE))
#' @seealso \code{\link{light_ice}}.
plot.light_ice <- function(x, facet_scales = "fixed", rotate_x = FALSE, ...) {
  nby <- length(x$by)
  multi <- is.light_ice_multi(x)
  if (nby + multi > 2L) {
    stop("Plot method not defined for more than two by variables or
         multiflashlight with more than one by variable.")
  }
  if (length(x$v) >= 2L) {
    stop("No plot method defined for two or higher dimensional grids.")
  }
  data <- x$data
  # Distinguish cases
  if (nby == 0L) {
    p <- ggplot(data, aes_string(y = x$value_name, x = x$v, group = x$id_name)) +
      geom_line(...)
  } else {
    stopifnot(!("temp_" %in% colnames(data)))
    data[["temp_"]] <- interaction(data[[x$id_name]], data[[x$by[1]]])
    p <- ggplot(data, aes_string(y = x$value_name, x = x$v, group = "temp_")) +
      geom_line(aes_string(color = x$by[1]), ...)
  }
  if (nby > 1L || multi) {
    p <- p + facet_wrap(reformulate(if (multi) x$label_name else x$by[2]), scales = facet_scales)
  }
  if (rotate_x) {
    p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
  }
  p
}

