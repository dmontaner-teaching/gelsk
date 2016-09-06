#! /usr/bin/Rscript --vanilla

##z_make.r
##Makes Genometra HTML tutorials

date ()
Sys.info ()[c("nodename", "user")]
commandArgs ()
rm (list = ls ())
R.version.string ##"R version 3.3.1 (2016-06-21)"
library (rmarkdown); packageDescription ("rmarkdown", fields = "Version") #"0.9.6"
library (knitr); packageDescription ("knitr", fields = "Version") #"1.13"
library (MASS); packageDescription ("MASS", fields = "Version") #"7.3-45" esta libreria se carga aqui para evitar conflictos de la funcion `select` en la libreria `dplyr`
##help (package = knitr)
##help (package = rmarkdown)

set.seed (20160728)

opts_chunk$set (comment = "#",  fig.show = "asis", warning = FALSE)   ## symbol preceding the R output. Needs to load knitr

## .fecha <- 2015-11-27
.fecha <- format (Sys.Date(), "%Y-%m-%d") ## automatic
.fecha

### GENOMETRA STAMP FUNCTION ############################################################################

.genometraStyle <- function (file) {

    micss <-"
#header {
  text-align: center ;
  border-bottom: 3px solid gray;
  margin-bottom: 2em;
  a:color: orange
}
#header a {
  color: orange;
}
#footer {
  text-align: center ;
  border-top: 3px solid gray;
  margin-top: 2em;
  margin-bottom: 1em;
  color: orange
}
  #footer a {
  color: orange;
}"

    mifooter <- '<div id="footer"><a target="_blank" href="http://www.dmontaner.com">www.dmontaner.com</a></div>'

    ## #################################

    ## TEST
    if (tolower (tail (unlist (strsplit (file, split = "\\.")), n = 1)) != "html")
        stop ("The file does not look like an HTML")

    ## READ
    lineas <- readLines (file)

    ## CSS
    pos <- max (grep ("</style>", lineas))
    N <- length (lineas)
    lineas <- c (lineas[1:(pos-1)], micss, lineas[pos:N])

    ## FOOTER
    pos <- max (grep ("</div>", lineas))
    N <- length (lineas)
    lineas <- c (lineas[1:(pos-1)], mifooter, lineas[pos:N])

    ## SALIDA
    writeLines (lineas, con = file)
}

################################################################################


## CLEAR ALL HTML and PDF
dir ()
#dir(recursive = TRUE)
##unlink ("*.html$") ## $ is not working
unlink (dir (pattern = ".html$", recursive = TRUE))
unlink (dir (pattern = ".pdf$", recursive = TRUE))
dir ()
#dir(recursive = TRUE)

################################################################################

## COMPILE THEORY
.ficheros <- dir (pattern = ".R$", recursive = TRUE)
.ficheros

for (.fichero in .ficheros) {
    .ficheroHTML <- sub (".R$", ".html", .fichero)
    print (.fichero)
    print (.ficheroHTML)
    system.time (render (.fichero, encoding = "UTF-8"))
    .genometraStyle (.ficheroHTML)
}


################################################################################

## COMPILE PRACTICAL
.ficheros <- dir (pattern = ".Rmd$", recursive = TRUE)
.ficheros

## with no answers
opts_chunk$set (echo = FALSE, results = "hide", fig.show = "hide") ##, fig.cap = ""

for (.fichero in .ficheros) {
    .ficheroHTML <- sub (".Rmd$", ".html", .fichero)
    print (.fichero)
    system.time (render (.fichero, encoding = "UTF-8"))
    .genometraStyle (.ficheroHTML)
}

## with answers
opts_chunk$set (echo = TRUE,  results = "hide", fig.show = "asis", warning = FALSE) ## 

for (.fichero in .ficheros) {
    .ficheroHTML <- sub (".Rmd$", "_responses.html", .fichero)
    .ficheroHTML_out <- strsplit(.ficheroHTML, "/")[[1]]
    if(length(.ficheroHTML_out) > 1) .ficheroHTML_out <- .ficheroHTML_out[length(.ficheroHTML_out)]
    print (.fichero)
    system.time (render (.fichero , output_file = .ficheroHTML_out, encoding = "UTF-8"))
    .genometraStyle (.ficheroHTML)
}
 

### PDF
## falla con la ultima version de pandoc ???
## .echo <- TRUE
## .results <- "markup"
## system.time (render (.fichero, output_format = "pdf_document"))



.genometraStyle <- function (file) {
    
    micss <-"
#header {
  text-align: center ;
  border-bottom: 3px solid gray;
  margin-bottom: 2em;
  a:color: orange
}
#header a {
  color: orange;
}
#footer {
  text-align: center ;
  border-top: 3px solid gray;
  margin-top: 2em;
  margin-bottom: 1em;
  color: orange
}
  #footer a {
  color: orange;
}"

    mifooter <- '<div id="footer"><a target="_blank" href="http://www.genometra.com">www.genometra.com</a></div>'

    ## #################################
    
    ## TEST
    if (tolower (tail (unlist (strsplit (file, split = "\\.")), n = 1)) != "html")
        stop ("The file does not look like an HTML")

    ## READ
    lineas <- readLines (file)

    ## CSS
    pos <- max (grep ("</style>", lineas))
    N <- length (lineas)
    lineas <- c (lineas[1:(pos-1)], micss, lineas[pos:N])

    ## FOOTER
    pos <- max (grep ("</div>", lineas))
    N <- length (lineas)
    lineas <- c (lineas[1:(pos-1)], mifooter, lineas[pos:N])

    ## SALIDA
    writeLines (lineas, con = file)
} 

################################################################################

################################################################################

##CLEAR FILES
.rmtype <- c(".txt", ".csv", ".pdf", ".png", ".jpeg", ".jpg", ".xls", ".xlsx", ".RData", ".Rhistory")
.grepPattern <- paste0(.rmtype, "$", collapse = "|")
.rmfiles <- dir (pattern = .grepPattern, recursive = TRUE)
.rmfiles <- .rmfiles[!.rmfiles %in% .rmfiles[grep("ej_", .rmfiles)]]

unlink (.rmfiles)

##CLEAR template html files
unlink ("z_template/*.html")

################################################################################

##CREATE ZIP
.ficheros <- c (dir(pattern = ".html$", recursive = TRUE), dir(pattern = ".R$", recursive = TRUE))

.zip_name <- paste0("materiales_r_", .fecha) 
#zip (zipfile = .zip_name, files = .ficheros)




###EXIT
warnings ()
sessionInfo ()
#q ("no")
