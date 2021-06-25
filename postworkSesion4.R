#postwork
library(dplyr)

df_1718 = read.csv("https://www.football-data.co.uk/mmz4281/1718/SP1.csv")
df_1819 = read.csv("https://www.football-data.co.uk/mmz4281/1819/SP1.csv")
df_1920 = read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

str(df_1718)
str(df_1819)
str(df_1920)

head(df_1718)
head(df_1819)
head(df_1920)

summary(df_1718)
summary(df_1819)
summary(df_1920)

df_1718 = select(df_1718,Date:FTR)
df_1819 = select(df_1819,Date:FTR)
df_1920 = select(df_1920,Date:FTR)

df_1718 = mutate(df_1718,Date = as.Date(Date,"%d/%m/%y"))
df_1819 = mutate(df_1819,Date = as.Date(Date,"%d/%m/%Y"))
df_1920 = mutate(df_1920,Date = as.Date(Date,"%d/%m/%Y"))

df_1920 = df_1920[-2]

data = union_all(df_1718,df_1819)
data = union_all(data,df_1920)
