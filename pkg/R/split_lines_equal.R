#' Split lines in segments of equal length
#' 
#' Split lines in segments of equal length. (Experimental, see note)
#' 
#' @param shp The shape object that contains the lines, i.e. \code{\link[sp:SpatialLinesDataFrame]{SpatialLinesDataFrame}}
#' @param dist Distance per segment
#' @param include.last Include last point, even though the distance is less than dist from the previous point?
#' @return Shape object, i.e. \code{\link[sp:SpatialLinesDataFrame]{SpatialPolygons(DataFrame)}}.
#' @note This function is still in experimental phase, which means that it may not be stable and it may be changed significantly in future versions. Moreover, it is unsure if it will stay in tmap; instead, it may be put in a different package, along with functions of similar tasks.
#' @export
split_lines_equal <- function(shp, dist=1000, include.last=FALSE) {
	co <- coordinates(shp)
	
	lines <- mapply(function(x, id) {
		x2 <- lapply(x, function(y) {
			z <- cbind(y[-nrow(y),, drop=FALSE], y[-1,,drop=FALSE])
			d <- sqrt((z[,3] - z[,1])^2 + (z[,4] - z[,2])^2)
			
			y <- as.data.frame(y)
			y$d <- c(0, d)
			y$cd <- c(0, cumsum(d))
			y$id <- y$cd %/% dist
			
			nseg <- floor(max(y$cd)/dist)
			names(y)[1:2] <- c("V1", "V2")
			if (include.last) y$id[nrow(y)] <- -1
			y$id[1] <- -1

			if (nseg!=0) {
				y <- rbind(y, data.frame(V1=NA, V2=NA, d=NA, cd=dist * 1:floor(max(y$cd)/dist),id=-1))
			}
			
			y <- y[order(y$cd),]
			
			y$V1 <- approx(x=y$cd, y=y$V1, xout=y$cd)$y
			y$V2 <- approx(x=y$cd, y=y$V2, xout=y$cd)$y
			
			sel <- y$id==-1
			if (sum(sel)<2) return(NULL)
			Line(as.matrix(y[y$id==-1, 1:2]))
		})
		isnull <- sapply(x2, is.null)
		if (all(isnull)) return(NULL)
		Lines(x2[!isnull], ID=id)
	}, co, get_IDs(shp), SIMPLIFY=FALSE)
	sel <- !sapply(lines, is.null)
	
	lines <- lines[sel]
	data <- shp@data[sel, , drop=FALSE]
	
	shp2 <- SpatialLinesDataFrame(SpatialLines(lines, proj4string=shp@proj4string), data=data, match.ID=FALSE)
	
	shp2
}

