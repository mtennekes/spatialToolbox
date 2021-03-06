% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/convert_shape_data.R
\name{intersection_shapes}
\alias{intersection_shapes}
\title{Calculate intersection matrix of two shape objects}
\usage{
intersection_shapes(shp.from, shp.to, id.from = NULL, id.to = NULL,
  absolute = FALSE)
}
\arguments{
\item{shp.from}{the first shape object}

\item{shp.to}{the second shape object}

\item{id.from}{name of the data variable of \code{shp.from} that contains identification names of the polygons of \code{shp.from}. These are used as row names of the intersection matrix.}

\item{id.to}{name of the data variable of \code{shp.to} that contains identification names of the polygons of \code{shp.to}. These are used as column names of the intersection matrix.}

\item{absolute}{should the intersection matrix contain intersection area sizes rather than proportions?}
}
\value{
Intersection matrix with the number of rows equal to the number of polygons of \code{shp.from} and the number of columns equal to the number of polygons of \code{shp.to}.
}
\description{
The value of row i and column j in the intersection matrix corresponds to the proportion of the area of the i'th polygon of the first shape object that intersects the j'th polygon of the second shape object
}
\note{
Running time may be pretty slow.
}
\examples{
\dontrun{
data(NLD_prov)
data(NLD_muni)

m <- intersection_shapes(NLD_muni, NLD_prov, id.from="name", id.to="name")

}
}

