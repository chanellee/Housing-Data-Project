# The data from this script can be found in the Data.zip folder
# person_merged, household_merged RData files

######### MERGE PERSON DATA 
#### load person.RData
load(unz("Data.zip", "person.RData"))

year <- c("2019", "2017", "2013","2011","2009", "2007", "2005", "2003",
          "2001","1999","1997")
vars <- paste(year,"person",sep = "_")

#### add YEAR column
i = 1
for(v in vars){
  assign(v, cbind(get(v), YEAR = strtoi(year[i])))
  i = i+1
}

#### find cols in common for all person datasets
A <- names(get(vars[1]))
for (v in vars[-1]){
  B <- names(get(v)) 
  A <- intersect(A,B)
}
common_cols <- A[!(substring(A,1,1) == "J")]

#### combined person datasets for common cols
A <- get(vars[1])[common_cols]
for (v in vars[-1]){
  B <- get(v)[common_cols]
  A <- rbind(A,B)
}
person <- A

save(person, file = "person_merged.RData")

#######################################
# rm(list = ls())
######### MERGE household DATA 
#### load household.RData
load(unz("Data.zip", "household.RData"))

year <- c("2019", "2017", "2013","2011","2009", "2007", "2005", "2003",
          "2001","1999","1997")
vars <- paste(year,"household",sep = "_")

#### add YEAR column
i = 1
for(v in vars){
  assign(v, cbind(get(v), YEAR = strtoi(year[i])))
  i = i+1
}

#### find cols in common for all household datasets
A <- names(get(vars[1]))
for (v in vars[-1]){
  B <- names(get(v)) 
  A <- intersect(A,B)
}
common_cols <- A[!(substring(A,1,1) == "J")]

#### combined household datasets for common cols
A <- get(vars[1])[common_cols]
for (v in vars[-1]){
  B <- get(v)[common_cols]
  A <- rbind(A,B)
}
household <- A

save(household, file = "household_merged.RData")

#######################################