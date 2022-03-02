##############################################################################
#           Downloading the covid CASE TOTALS and DEATHS data
##################                                      ######################

#1. edit `destfile` below to be of the form
#destfile <- "C:/ folder I want to put data in / desired filename.csv

destfile <- "D:/STAT 605 Project/Covid data/time_series_covid19_confirmed_US.csv"

#2. run the following two lines

url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/
csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"

download.file(url,destfile)

#3. now change `destfile` for DEATHS data

destfile <- "D:/STAT 605 Project/Covid data/time_series_covid19_deaths_US.csv"
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/
csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
download.file(url,destfile)

#data is now in the computer




#############################################################################
#         importing the data into R; simplifying and organizing the data
#############################################################################

#I just go to file -> import dataset -> from text (base)
#make sure to set "heading" = yes
#then, we need to clean the data:

confirmed_full <- time_series_covid19_confirmed_US
deaths_full <- time_series_covid19_deaths_US

#theres some extra stuff.. here are simplified versions:


confirmed <- confirmed_full[,-c(1,2,3,4,5,8,9,10,11)]
deaths <- deaths_full[,-c(1,2,3,4,5,8,9,10,11,12)]


counties <- confirmed[,1]                       #the list of counties
states <- confirmed[,2]                         #the list of states
 
latitudes <- confirmed_full[,9]                 #more geographic info
longitudes <- confirmed_full[,10]               #longitudes...
populations <- deaths_full[,12]                 #number of people in county

#I double checked `populations` by googling some county populations.. seems ok



#If we want to know Covid case totals or deaths in Harris county, Texas, do this:

#first, find which row is Harris county, texas
which(counties == "Harris")
states[483] #that's Harris county, georgia..
states[2801] #Harris county, texas

#then, here it is
Harris <- confirmed[2801,-c(1,2)]
length(Harris)
plot(1:769,Harris, xlab='days after 1-21-2020', 
                    ylab = 'number of positive cases',
main = "Covid cases in Harris county, Texas",
type = "l")




#############################################################################
#         basic growth curve visualizer
#############################################################################




#this block will show case and death totals 
#for 16 randomly selected counties
#notice some county data is bad
#run the block a few times..
################################################################
indices <- sample(c(1:3342), 16)
par(mfrow = c(4,4))
for(i in 1:16){
  Timeseries <- confirmed[indices[i],-c(1,2)]
  Dead <- deaths[indices[i],-c(1,2)]
  L = length(Timeseries)
  plot(1:L,Timeseries, xlab='days after 1-21-2020', 
       ylab = 'number of positive cases',
       main = paste('Covid cases in', counties[indices[i]],
                    'county, ', states[indices[i]], sep = " "),
       type = "l")
  lines(1:L, Dead , col = "red")
}
###############################################################


#looks like a lot of death curves are small
#lets look at the sixteen counties w/ greatest number of deaths (today)


################################################################
MaxDeaths <- sort(deaths[,769], decreasing = TRUE, index.return = TRUE)$ix
indices <- MaxDeaths[1:16]
par(mfrow = c(4,4))
for(i in 1:16){
  Timeseries <- confirmed[indices[i],-c(1,2)]
  Dead <- deaths[indices[i],-c(1,2)]
  L = length(Timeseries)
  plot(1:L,Timeseries, xlab='days after 1-21-2020', 
       ylab = 'number of positive cases',
       main = paste('Covid cases in', counties[indices[i]],
                    'county, ', states[indices[i]], sep = " "),
       type = "l")
  lines(1:L, Dead , col = "red")
}
###############################################################


#Ok, let's just see the sixteen greatest deaths
################################################################
MaxDeaths <- sort(deaths[,769], decreasing = TRUE, index.return = TRUE)$ix
indices <- MaxDeaths[1:16]
par(mfrow = c(4,4))
for(i in 1:16){
  Dead <- deaths[indices[i],-c(1,2)]
  L = length(Dead)
  plot(1:L,Dead, xlab='days after 1-21-2020', 
       ylab = 'number of positive cases',
       main = paste('Covid deaths in', counties[indices[i]],
                    'county, ', states[indices[i]], sep = " "),
       type = "l", col = "red")
}
###############################################################




###############################################################
#             map
###############################################################

#use packages
install.packages('usmap')
library(usmap)
library(ggplot2)

#create plots
par(mfrow = c(1,1))

plot_usmap(regions = "counties") + 
  labs(title = "US Counties",
       subtitle = "I'm trying to put COVID data into the counties...") + 
  theme(panel.background = element_rect(color = "black", fill = "black"))


#################################################
df <- data.frame(
  fips = deaths_full[,5],
  values = deaths[,771]
)
plot_usmap(data = df)+ 
  scale_fill_continuous(
    low = "white", high = "red", name = "uhh", label = scales::comma
  )
#################################################



#################################################
v = quantile(deaths[,771], 
             probs = c(0.2,0.4,0.6,0.8,1))              
names(v) = c("20% quantile","40% quantile","60% quantile",
             "80% quantile","100% quantile")
plot_usmap(data = df)+ 
  labs(title = "Covid Deaths on 2-28-22", subtitle = "") + 
  theme(panel.background = element_rect(color = "black", fill = "black"))+
  scale_fill_stepsn(colours=c("white","red","blue","green"),
                    breaks=v   ,
                    limits=c(0,500))
#################################################



#   experimentation with ggplot
# dim(deaths)
# 
# par(mfrow = c(1,1))
# hist(deaths[,771])
# summary(deaths[,771])
# 
# 
# deads <- deaths[,771]
# dead_bin <- cut_interval(deaths[,771], 
#                             n = 4, 
#                          labels = c("0-25", "26-50", "51-75", "76-40000"))
# 
# ?cut_interval
# 
# 
# 
# df2 <- data.frame(
#   fips = deaths_full[,5],
#   values = dead_bin
# )
# 
# plot_usmap(data = df)+ 
#   labs(title = "Covid Deaths on 2-28-22", subtitle = "") + 
#   theme(panel.background = element_rect(color = "black", fill = "black"))+
#   scale_fill_stepsn(colours=c("white","red","blue","green"),
#                     breaks=v   ,
#                     limits=c(0,500))
# 
# 
# summary(deads)
# 
# str(quantile(deaths[,771], probs = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))                         )
#                          
#                          
# v = quantile(deaths[,771], 
#          probs = c(0.2,0.4,0.6,0.8,1))              
# names(v) = c("20% quantile","40% quantile","60% quantile","80% quantile","100% quantile")                      
#                          
                         
                         
                         
                         
                         
                         
                         
                         
