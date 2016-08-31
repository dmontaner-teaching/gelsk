##' % Data Wrangling: dplyr
##' % [David Montaner](http://dmontaner.com)
##' % `r .fecha`

##' This script introduces the `dplyr` R library for data handling.
##'
##' Clear the session first

rm (list = ls ())

##' Library
library (dplyr)
#help (package = dplyr)

searchpaths ()

##' Data
datos <- head (mtcars)
datos[6, "carb"] <- NA
datos[1, "mpg"] <- NA
datos


##' Basic functions for data manipulation
##' ============================================================================


##' select columns
##' ----------------------------------------------------------------------------
select (datos, mpg, carb)
datos ## select does not change the data, it just returns some columns of the data.set

datos.cortos <- select (datos, mpg, carb) ## this saves the formatted data.set
datos.cortos
class (datos.cortos)

select (datos, - mpg, - carb) ## exclude columns


##' rename columns
##' ----------------------------------------------------------------------------
rename (datos, CONSUMO = mpg, CARBURADORES = carb)


##' filter rows fulfilling a condition
##' ----------------------------------------------------------------------------
filter (datos, carb == 4)
filter (datos, carb == 2) # a single column keeps its data.frame structure
class (filter (datos, carb == 2))

filter (datos, mpg > 20)
filter (datos, mpg > 20 & carb == 4)
filter (datos, mpg > 20 , carb == 4) ## coma is equivalent to &

##' when filtering row names are discarded
add_rownames (datos)

slice (datos, 1:3) ## select rows by its position

slice (datos, n()) ## LAST ROW operator
slice (datos, 4:n())


##' reorder rows
##' ----------------------------------------------------------------------------

arrange (datos, carb)
arrange (datos, carb, mpg)
arrange (datos, mpg, carb) ## changes the order

arrange (datos, -carb) ## decreasing order


##' create new (derived) columns
##' ----------------------------------------------------------------------------

mutate (datos, NUEVA = gear + carb)
mutate (datos, NUEVA = gear + carb, OTRA = sqrt (gear))

transmute (datos, NUEVA = gear + carb, OTRA = sqrt (gear)) ## returns just the new created columns


##' get unique rows
##' ----------------------------------------------------------------------------

datos[,c ("gear", "carb")]
distinct (datos[,c ("gear", "carb")])


##' collapse or summarize data
##' ----------------------------------------------------------------------------

summarise (datos, var  (disp))
var (datos$disp)
summarise (datos, mean (disp))
mean (datos$disp)

summarise (datos, mean (disp), var (disp))

summarise (datos, mean (mpg)) ## with NAs
summarise (datos, mean (mpg, na.rm = TRUE))

mifun <- function (x) sum (x^2)  ## you can define your function
summarise (datos, mifun (disp))


##' collapse withing GROUP CATEGORY
summarise (group_by (datos, carb), 
           mean (mpg)) ## with NAs

summarise (group_by (datos, carb), 
           mean (mpg, na.rm = TRUE)) ## with NAs

by (datos$mpg, datos$carb, mean)
by (datos$mpg, datos$carb, mean, na.rm = TRUE)


##' several "summaries" may be applied at a time
summarise (group_by (datos, carb), 
           media  = mean (mpg, na.rm = TRUE),
           minimo = min (mpg))


##' CHAINING STEPS: PIPE OPERATOR
##' ============================================================================

datos %>% summary

summary (datos)


select (datos, mpg, carb)

datos %>% select (mpg, carb)


datos %>%
    rename (CONSUMO = mpg, CARBURADORES = carb) %>%
    select (CONSUMO, CARBURADORES) %>%
    mutate (nueva = CONSUMO / CARBURADORES)

datos %>%
    rename (CONSUMO = mpg, CARBURADORES = carb) %>%
    select (CONSUMO, CARBURADORES) %>%
    mutate (nueva = CONSUMO / CARBURADORES) %>%
    filter (nueva > 8)

datos %>%
    rename (CONSUMO = mpg, CARBURADORES = carb) %>%
    select (CONSUMO, CARBURADORES) %>%
    mutate (nueva = CONSUMO / CARBURADORES) %>%
    filter (nueva > 8) %>%
    select (CARBURADORES) %>%
    table
