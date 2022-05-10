library(stringr)
library(plyr)

#depression posts
url = str_c("http://api.pushshift.io/reddit/search/submission/?subreddit=depression&after=1577836800&limit=100") 

#^code explanation:
#  after represents date epoch, here Jan 1st 2020 (from here: https://www.epochconverter.com/)
#  limit = max no of posts in one query is 100
# documentation for api: https://github.com/pushshift/api

#GET a url
r = GET(url)
r_text = content(r, as="text")
data_json = jsonlite::fromJSON(r_text, flatten=T)
data = as.data.frame(data_json)
head(data)  

last_epoch = tail(data$data.created_utc,n=1)

#looping through all dates by setting last item's date as starting point for next query until date is Jan 1st 2021
while (last_epoch<1609459200)
{
  
  url = sprintf('http://api.pushshift.io/reddit/search/submission/?subreddit=depression&after=%s&limit=100',last_epoch)
  r = GET(url)
  r_text = content(r, as="text")
  data_json = jsonlite::fromJSON(r_text, flatten=T)
  data_temp = as.data.frame(data_json)
  
  data <- rbind.fill(data,data_temp) 
  last_epoch = tail(data$data.created_utc,n=1)
  print(anytime(last_epoch))
  
}

save(data,file="~/Documents/Sem 2/Collecting/dep_raw_data.Rda")

#casual conversation posts (https://www.researchgate.net/publication/301446050_An_Analysis_of_Domestic_Abuse_Discourse_on_Reddit/link/575966f008ae9a9c954ed745/download)

url = str_c("http://api.pushshift.io/reddit/search/submission/?subreddit=CasualConversation&after=1577836800&limit=100") 

#GET a url
r = GET(url)
r_text = content(r, as="text")
data_json = jsonlite::fromJSON(r_text, flatten=T)
data_casual = as.data.frame(data_json)
head(data_casual)  

last_epoch = tail(data_casual$data.created_utc,n=1)

#looping through all dates by setting last item's date as starting point for next query until date is Jan 1st 2021
while (last_epoch<1609459200)
{
  
  url = sprintf('http://api.pushshift.io/reddit/search/submission/?subreddit=CasualConversation&after=%s&limit=100',last_epoch)
  r = GET(url)
  r_text = content(r, as="text")
  data_json = jsonlite::fromJSON(r_text, flatten=T)
  data_temp = as.data.frame(data_json)
  
  data_casual <- rbind.fill(data_casual,data_temp) 
  last_epoch = tail(data_casual$data.created_utc,n=1)
  print(anytime(last_epoch))
  
}

save(data_casual,file="~/Documents/Sem 2/Collecting/cas_raw_data.Rda")
