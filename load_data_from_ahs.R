#install.packages("readr")
library(readr)

### load household ####
year <- c("2019", "2017", "2013","2011","2009", "2007", "2005", "2003",
          "2001","1999","1997")
vol <- c("v1.1","v3.1","v2.0","v3.0", "v2.0", "v2.0","v2.0","v2.0","v2.0","v2.0",
         "v2.0")
url <- paste("https://www2.census.gov/programs-surveys/ahs/",year,
      "/AHS%20",year,"%20National%20PUF%20",vol,"%20CSV.zip", sep = "")

i = 1
for (u in url){
if (!exists(paste(year[i],"household",sep = "_"))){
temp <- tempfile()
download.file(u,temp)
assign(paste(year[i],"household",sep = "_"),read_csv(unz(temp, "household.csv")))
}
i = i + 1
}


### load person ####
i = 1
for (u in url){
  if (!exists(paste(year[i],"person",sep = "_"))){
    temp <- tempfile()
    download.file(u,temp)
    assign(paste(year[i],"person",sep = "_"),read_csv(unz(temp, "person.csv")))
  }
  i = i + 1
}

### load project ####
i = 1
for (u in url){
  if (!exists(paste(year[i],"project",sep = "_"))){
    temp <- tempfile()
    download.file(u,temp)
    assign(paste(year[i],"project",sep = "_"),read_csv(unz(temp, "project.csv")))
  }
  i = i + 1
}