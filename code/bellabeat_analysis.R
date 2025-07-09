#installation packages 
install.packages("tidyverse")         #to facilitate data analysis and data science
install.packages("lubridate")         #to work with dates and times
install.packages("pscl")              #binaries regression
install.packages("broom")             #to convert models (like lm) into sorted data frames
install.packages("ggthemes")          #to improve the aesthetics of ggplot2 graphics
install.packages("scales")            #to control axes, percentages, scales in graphs

library(tidyverse)                    #to data science ggplot2, dplyr, readr, tidyr
library(lubridate)                    #to work with dates and hours
library(broom)                        #convert statistics results in order data frame
library(ggthemes)                     #aesthetic to graph
library(scales)                       #formatted numeric scale

#work directory
setwd("C:/Users/57322/Documents/Proyecto-bellabeat")

#charger all documents that I will need
daily_activity <- read.csv2("dailyActivity_merged.csv")
sleep_data <- read.csv2("minuteSleep_merged.csv")
steps_data <- read.csv2("hourlySteps_merged.csv")
hourly_intensities <- read.csv2("hourlyIntensities_merged.csv")

#clean steps data
colSums(is.na(steps_data))              #nules values
sum(duplicated(steps_data))             #duplicated values
steps_data <- steps_data %>%            #make sure about the time
  mutate(
    datetime = parse_date_time(ActivityHour,  #convert date in one format
                               orders = c("mdy HMS p", "mdy HM p", "dmy HMS",
                                          "mdy HMS", "dmy HM", "mdy HM",
                                          "mdy IMp")),
    datetime = update(datetime, year = 2016),
    hour = hour(datetime),              #extract the hour
    date = as_date(datetime)
  ) 

#group by hour to see steps average
activity_per_hour <- steps_data %>% #dataframe with the steps data per hour
  group_by(hour) %>% #group the data by hour
  summarise(steps_prom = mean(StepTotal, na.rm = TRUE)) #summarize the data by group, steps prom, calculate the average  of steps by hour in every day and users, na.rm=true indicateS that null  values are ignored

#see results
print(activity_per_hour)

#graphic average steps per hour of day
ggplot(activity_per_hour, aes(x = hour, y = steps_prom)) +
  geom_line(color = "darkblue", linewidth = 1.3) +    # line darkblue
  geom_point(color = "blue") +                        # point blue small
  labs(
    title = "Average steps per hour of day",
    x = "Hour",
    y = "Average steps"
  ) +
  theme_minimal(base_family = "sans") +               #change type 
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),   #center title and make it bold
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold"),
    axis.text = element_text(face = "bold"),                           #numbers in bols
    panel.grid.major.y = element_line(color = "gray30"),               #darker horizontal lines
    panel.background = element_rect(fill = "gray90", color = NA)       #light gray background
  )


ggsave("average_steps_per_hour.png", width = 8, height = 5, dpi = 300) #save image png
getwd()
#conclusions: The hour between 12 pm to 7 pm is average steps per hour of day for all users

#Group by user (Id) and date to obtain the total steps daily
steps_daily <- steps_data %>%
  group_by(Id, date) %>%                                            #group by user ID and date
  summarise(total_steps = sum(StepTotal, na.rm = TRUE), .groups = "drop")  #total sum per day
head(steps_daily, 10)                                               #show than firts files to check it

#graph daily steps evolution graph per user
ggplot(steps_daily, aes(x = date, y = total_steps)) +   #create a line plot of total daily steps for each user
  geom_line(color = "steelblue", size = 0.7) +          #add a line for daily steps
  geom_point(color = "gray60", size = 0.5) +            #add small gray points for each day
  geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "dashed", linewidth = 0.5) +
  facet_wrap(~ Id, scales = "free_y", labeller = labeller(Id = function(x) paste(x))) +   #Create one plot per user each with its own Y scale
  labs(                                                 #set chart title and axis labels
    title = "Daily step evolution by user",
    x = "Date",
    y = "Total steps per day"
  ) +
  theme_minimal(base_family = "sans") +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5), #center title and make it bold
    strip.text = element_text(size = 8, color = "gray20"),            #titule
    axis.title = element_text(face = "bold"),                         #bold axis labels
    axis.text.x = element_text(angle = 45, hjust = 1, size = 6),      #rotate axis x text 
    axis.text.y = element_text(size = 6),                             #smaller axis x
    panel.grid.major.x = element_blank(),                             #remove vertical grid lines
    panel.grid.minor = element_blank(),                               #removed minor grid
    panel.grid.major.y = element_line(color = "gray80"),              #horizontal lines  light
    plot.background = element_rect(fill = "gray95", color = NA),      #light gray
    panel.background = element_rect(fill = "gray95", color = NA)      #light gray panel background
  )

ggsave("daily_step_evolution_by_user.png", width = 8, height = 5, dpi = 300) #save image png
getwd()
#numeric Format
steps_daily <- steps_daily %>%                        #dataframe with numeric format
  mutate(date_num = as.numeric(date))

#calculate the slope per user using linear regression
slope <- steps_daily %>%                              #dataframe with slope
  group_by(Id) %>%
  do(tidy(lm(total_steps ~ date_num, data = .))) %>%  #user-based model adjustment
  filter(term == "date_num") %>%                      #only with the slope
  ungroup()

#see result
print(slope)

#total users
total_ids <- n_distinct(steps_daily$Id)

#users with positive slope
positive <- slope %>%
  filter(estimate > 0) %>%                            #filter to greather than 0
  nrow()

#percentaje 
porcentaje_positive <- round((positive / total_ids) * 100, 1)
#show
cat("Percentage of users with an increasing trend in steps:", porcentaje_positive, "%\n")

#now, go to clean sleep data to can to do relation between sleep and physical activity
#sleep data
colSums(is.na(sleep_data))                                                    #nules values
sum(duplicated(sleep_data))                                                   #duplicated values

#new colum called datatime that provides the correct format
sleep_data <- sleep_data %>%                                                  #modify the same document and save the results
  mutate(                                                                     #create one column or modify existing columns
    datetime = parse_date_time(date,                                          #create a new column called datetime from the column date, but change a date and hour format
                               orders = c("mdy HMS p", "mdy HM p", "dmy HMS", "mdy HMS", "dmy HM", "mdy HM", "mdy IMp")),#use various formats to recognize how to write the datetime
    datetime = update(datetime, year = 2016),                                 #corregir año si alguno estaba mal
    date = as_date(datetime),                                                 #extract only the date part without the time
    hour = format(datetime, "%H:%M:%S")                                       #extract only the hour in 24 hours format
  )
str(sleep_data)                                                               #Verify the data structure
nrow(sleep_data)                                                              #Number of rows 198034

sleeep_summary <- sleep_data %>%  #create new table to group by Id and date
  group_by(Id, date) %>%             #data is grouped only by date.
  summarise(                         #calculates totals for each full day.
    asleep_seconds = sum(value == 1, na.rm = TRUE),
    restless_seconds = sum(value == 2, na.rm = TRUE),
    awake_seconds = sum(value == 3, na.rm = TRUE),
    .groups = 'drop'                 #ungroup after summarizing
  ) %>%
  mutate(                            #adds the metric columns based on the daily totals
    total_seconds_in_bed = asleep_seconds + restless_seconds + awake_seconds, #summarize total seconds in bed
    hours_sleep=round(total_seconds_in_bed/60,2),                             #calculate hours sleep and convert seconds to hours
    sleep_efficiency = if_else(
      total_seconds_in_bed > 0,                              #if the seconds is more that 0, classify the sleep efficiency
      (asleep_seconds / total_seconds_in_bed) * 100,         #this is ecuation
      2
    ),
    efficiency_category = case_when(
      sleep_efficiency > 90 ~ "Excellent",
      sleep_efficiency > 75 ~ "Good",
      sleep_efficiency > 50 ~ "Regular",
      TRUE                  ~ "Bad"
    )
  )

#show final result
print(sleeep_summary)

#source to classify sleep efficiency: https://medlineplus.gov/spanish/pruebas-de-laboratorio/estudio-del-sueno/#:~:text=Un%20porcentaje%20de%20ox%C3%ADgeno%20inferior,por%20minuto%20se%20considera%20normal.  
#graph to show distribution of sleep hours per user 
ggplot(data = sleeep_summary, 
       aes(x = factor(Id), y = hours_sleep, fill = factor(Id))) +   #select axis x and y 
  geom_boxplot() +                                                  #add the box plot layer
  geom_jitter(width = 0.1, alpha = 0.6, color = "black") +          #add individual data points for more detail
  labs(                                                             #improve tags and title
    title = "Distribution of Sleep Hours per User",
    subtitle = "Each point represents the efficiency of a night's sleep",
    x = "User ID",
    y = "Sleep hours" 
  ) +
  theme_minimal() +                                                 #remove the legend, since the X axis already shows the ID
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5), #center title and make it bold
    plot.subtitle = element_text(size = 10, face = "bold", hjust = 0.5), 
    strip.text = element_text(size = 8, color = "gray20"),            #titule
    axis.title = element_text(face = "bold"),                         #bold axis labels
    axis.text.x = element_text(angle = 45, hjust = 1, size = 6),      #rotate axis x text 
    axis.text.y = element_text(size = 6),                             #smaller axis x
    panel.grid.major.x = element_blank(),                             #remove vertical grid lines
    panel.grid.minor = element_blank(),                               #removed minor grid
    panel.grid.major.y = element_line(color = "gray80"),              #horizontal lines  light
    plot.background = element_rect(fill = "gray95", color = NA),      #light gray
    panel.background = element_rect(fill = "gray95", color = NA),
    legend.position = "none")

ggsave("distribution_of_sleep_hours_per_user.png", width = 8, height = 5, dpi = 300) #save image png
getwd()

#now, remove the outliers from the graph above
#calculate limits for each user
outlier_bounds <- sleeep_summary %>%
  group_by(Id) %>%
  summarise(
    Q1 = quantile(hours_sleep, 0.25, na.rm = TRUE),  #quantile Q1
    Q3 = quantile(hours_sleep, 0.75, na.rm = TRUE),  #quantile Q3
    IQR = Q3 - Q1,
    lower_bound = Q1 - 1.5 * IQR,                   #lower bounds with Q1 quantile
    upper_bound = Q3 + 1.5 * IQR,                   #upper bounds Q3 quantile
    .groups = 'drop'
  )

print(outlier_bounds)  #to see outlier bounds

#join the limits to the original table and filter and use left_join to add the limits to each row corresponding to its ID
sleep_data_no_outliers <- sleeep_summary %>%
  left_join(outlier_bounds, by = "Id") %>%
  filter(hours_sleep >= lower_bound & hours_sleep <= upper_bound) #filter to keep only the rows within the limits

#recreate the chart with the filtered data
ggplot(data = sleep_data_no_outliers, aes(x = factor(Id), y = hours_sleep, fill = factor(Id))) +
  geom_boxplot(outlier.shape = NA) +         # outlier.shape NA that it doesn't draw points that might still be outliers in the recalculation
  geom_jitter(width = 0.1, alpha = 0.6, color = "black") +
  labs(
    title = "New distribution of Sleep Hours per User",
    subtitle = "Points that fell outside the whiskers of the original graph were removed",
    x = "User ID",
    y = "Sleep hours"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5), #center title and make it bold
    plot.subtitle = element_text(size = 10, face = "bold", hjust = 0.5), 
    strip.text = element_text(size = 8, color = "gray20"),            #titule
    axis.title = element_text(face = "bold"),                         #bold axis labels
    axis.text.x = element_text(angle = 45, hjust = 1, size = 6),      #rotate axis x text 
    axis.text.y = element_text(size = 6),                             #smaller axis x
    panel.grid.major.x = element_blank(),                             #remove vertical grid lines
    panel.grid.minor = element_blank(),                               #removed minor grid
    panel.grid.major.y = element_line(color = "gray80"),              #horizontal lines  light
    plot.background = element_rect(fill = "gray95", color = NA),      #light gray
    panel.background = element_rect(fill = "gray95", color = NA),
    legend.position = "none",
  )

ggsave("New_distribution_of_sleep_per_user.png", width = 8, height = 5, dpi = 300)
getwd()

#calculate percentage per category
percentage_by_quality <- sleep_data_no_outliers %>%
  group_by(avg_quality = efficiency_category) %>%     #rename the grouping variable to avg_quality for readability
  summarise(n = n()) %>%                              #we count how many rows fall in to categories
  mutate( 
    percent = round(n / sum(n) * 100, 1),             #new column percent and calculates the percentage that each sleep quality represents out of the total and rounds it to 1 decimal.
    label = paste0(percent, "%"),                     #column label is created for the plot, combining the percent value with the "%" symbol to use it as a label in a chart
    ypos = cumsum(percent) - 0.6 * percent            #calculates the vertical position for each label if used in a stacked or donut chart and center each slice
  )

show(percentage_by_quality)

#join data sets
#make sure that data sets are clean and have the same date per ID
comparasion_data <- sleeep_summary %>%       
  select(Id, date, hours_sleep) %>%                             #keep only the columns needed user ID, date, and sleep in hour
  inner_join(steps_daily, by = c("Id", "date"))                 #join steps_daily with total_steps

#restructure to graph easily
comparasion_long <- comparasion_data %>%
  pivot_longer(cols = c(hours_sleep, total_steps), #select the columns to reshape
               names_to = "variable",              #name for the new column
               values_to = "value")                #name for the new column


#scale sleep and step values per user between 0 and 1
comparasion_scaled <- comparasion_data %>%
  group_by(Id) %>%                              #scale values separately for each user
  mutate(
    sleep_scaled = ( hours_sleep - min(hours_sleep)) / (max(hours_sleep) - min(hours_sleep)), #normalize sleep
    steps_scaled = (total_steps - min(total_steps)) / (max(total_steps) - min(total_steps))  #normalize steps
  ) %>%
  select(Id, date, sleep_scaled, steps_scaled) %>%    #keep only the needed columns
  pivot_longer(cols = c(sleep_scaled, steps_scaled),   #Remodel the two new scaled columns
               names_to = "variable",                  #name for the column with variable name
               values_to = "value")

#graph daily comparison: sleep vs. steps per User
ggplot(comparasion_scaled, aes(x = date, y = value, color = variable)) +
  geom_line(size = 0.8) +                                             #add a line for comparasion scaled
  geom_point(size = 1) +
  facet_wrap(~ Id, scales = "free_x", labeller = labeller(Id = function(x) paste("ID:", x))) +   #create one plot per user each with its own Y scale
  scale_color_manual(
    values = c("sleep_scaled" = "#009E73", "steps_scaled" = "#0072B2"),
    labels = c("Sleep (scaled)", "Steps (scaled)")
  ) +
  labs(                                                                  #set chart title and axis labels
    title = "Daily comparison: sleep vs. steps per User",
    x = "Date",
    y = "Scaled value",
    color = "Metric"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5), #center title and make it bold
    strip.text = element_text(size = 8, color = "gray20"),            #titule
    axis.title = element_text(face = "bold"),                         #bold axis labels
    axis.text.x = element_text(angle = 45, hjust = 1, size = 6),      #rotate axis x text 
    axis.text.y = element_text(size = 6),                             #smaller axis x
    panel.grid.major.x = element_blank(),                             #remove vertical grid lines
    panel.grid.minor = element_blank(),                               #removed minor grid
    panel.grid.major.y = element_line(color = "gray80"),              #horizontal lines  light
    plot.background = element_rect(fill = "gray95", color = NA),      #light gray
    panel.background = element_rect(fill = "gray95", color = NA),
    legend.position = "none"                              #smaller axis x
  )

ggsave("daily_comparation_sleep_vs_steps.png", width = 8, height = 5, dpi = 300)
getwd()

correlation_per_user <- comparasion_data %>%
  group_by(Id) %>%                    #group the data by user ID
  summarise(
    correlation = cor(hours_sleep, total_steps, use = "complete.obs"), #pearson correlation by user
    n_dias = n()                      #number of days registered for that user
  )

#classify users according to the type of correlation they present
correlation_per_user <- correlation_per_user %>%
  mutate(
    type_correlation = case_when(
      correlation > 0.5 ~ "Hard positive",         #high positive correlation
      correlation >= 0.1 & correlation <= 0.5 ~ "Weak positive",
      correlation > -0.1 & correlation < 0.1 ~ "No correlation",
      correlation <= -0.1 & correlation >= -0.5 ~ "Weak negative",
      correlation < -0.5 ~ "Hard negative"
    )
  )

#print all users and their correlation category
print(correlation_per_user, n = Inf)
count(correlation_per_user, type_correlation)

#graph to see distribution of users by type of correlation
ggplot(correlation_per_user, aes(x = type_correlation)) +
  geom_bar(fill = "steelblue", color = "black", width = 0.7) +  #blue bars with black border
  geom_text(stat = "count", aes(label = ..count..), 
            vjust = -0.5, color = "black", fontface = "bold", size = 4) +  #show count above each bars
  labs(
    title = "Distribution of users by type of correlation",
    subtitle = "Between daily sleep hours and total daily steps",
    x = "Type of correlation",
    y = "Number of users"
  ) +
  theme_minimal(base_family = "sans") +                     #clean visual style
  theme(   
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),     #bold and centered title
    plot.subtitle = element_text(hjust = 0.5, size = 11, color = "gray30"),   #subtitle below the title
    axis.title = element_text(face = "bold", size = 12),                  #bold axis labels
    axis.text = element_text(size = 10),                                  #size of axis text
    panel.grid.major.x = element_blank(),                                 #remove vertical grid lines
    panel.grid.major.y = element_line(color = "gray80"),                  #light horizontal lines
    panel.grid.minor = element_blank(),                                   #no minor grid lines
    plot.background = element_rect(fill = "grey", color = NA),            #gray background
    axis.text.x = element_text(angle = 20, hjust = 1)                     #tilt x-axis labels
  )

ggsave("distribution_of_users_by_type_correlation.png", width = 8, height = 5, dpi = 300)
getwd()

#daily Activity's clean and processes
colSums(is.na(daily_activity))                      #count empty rows
sum(duplicated(daily_activity))                     #duplicated values
daily_activity <- daily_activity %>%
  rename(date = ActivityDate) %>%
  mutate(date = as.Date(date, format = "%m/%d/%Y"))

#see how many days different have each ID
daily_activity %>%
  group_by(Id) %>%                                  #group the data by user
  summarize(distinc_days = n_distinct(date)) %>%    #calculating how many unique days each user
  arrange(desc(distinc_days)) %>%                   #sorted the users started to have more register days
  print(n = Inf)

#select only the necessary columns
daily_activity <- daily_activity %>%
  select(Id, date, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories)

#classify the daily activity
daily_activity <- daily_activity %>% 
  mutate(activity_level_minutes = case_when(            #create one columns or modify existing columns
    VeryActiveMinutes > 60 ~ "Very Active",             #if more than 60 minutes very active is very active
    FairlyActiveMinutes > 30 ~ "Fairly Active",         #if more than 30 minutes fairly active is fairly active
    LightlyActiveMinutes > 60 ~ "Lightly Active",       #if more than 60 minutes lightly active is lightly active
    SedentaryMinutes > 1000 ~ "Sedentary",              #if more than 1000 minutes sedentary is sedentary
    TRUE ~ "Sedentary"
  ))
daily_activity <- daily_activity %>%                    #remove rows that were not classified
  filter(activity_level_minutes != "Unclassified")

#source: https://vidauniversitaria.uanl.mx/expertos/sedentarismo-amenaza-a-la-salud-mundial/

#verify the first results
head(daily_activity)

#graph that show the percentage of days according to activity level

daily_activity %>%
  count(activity_level_minutes) %>%                  #count how many days fall into each activity level category
  mutate(percent = round(n / sum(n) * 100, 1)) %>%   #calculate the percentage each category represents
  ggplot(aes(x = reorder(activity_level_minutes, -percent), y = percent, fill = activity_level_minutes)) +   #reorder categories from highst to lowest percentage
  geom_col() +                                       #create a bar chart
  geom_text(aes(label = paste0(percent, "%")), vjust = -0.5, fontface = "bold") +   #add percentage labels on top of each bar and adjust vertical position and make text bold
  labs(title = "Percentage of days according to activity level",          
       x = "Activity level",
       y = "Percentage") +
  theme_minimal() +                     #clean visual style
  theme(   
    plot.title = element_text(hjust = 1.2, face = "bold", size = 15),     #bold and centered title
    plot.subtitle = element_text(hjust = 0.5, size = 11, color = "gray30"),   #subtitle below the title
    axis.title = element_text(face = "bold", size = 12),                  #bold axis labels
    axis.text = element_text(size = 10),                                  #size of axis text
    panel.grid.major.x = element_blank(),                                 #remove vertical grid lines
    panel.grid.major.y = element_line(color = "gray80"),                  #light horizontal lines
    panel.grid.minor = element_blank(),                                   #no minor grid lines
    plot.background = element_rect(fill = "grey", color = NA),            #gray background
    axis.text.x = element_text(angle = 20, hjust = 1)                     #tilt x-axis labels
  )

ggsave("Percetage_of_days_according_to_activity_level.png", width = 8, height = 5, dpi = 300)
getwd()
#join daily activity y sleep
#join data sets
deam_activity <- inner_join(daily_activity, 
                            comparasion_data %>% 
                              mutate(hours_sleep = round(hours_sleep /1, 2)) %>%        #convert total sleep time from minutes to hours and rounded to 2 decimals
                              select(Id, date, hours_sleep),                               #keep only necessary columns
                            by = c("Id", "date"))                                        #join on matching user ID and date

#compare sleep averages
#bar chart showing average hours of sleep by activity level
deam_activity %>%
  group_by(activity_level_minutes) %>%                        #goup data by classified daily activity level
  summarise(avg_sleep = mean(hours_sleep, na.rm = TRUE)) %>%  #calculate average sleep hours per group
  ggplot(aes(x = reorder(activity_level_minutes, -avg_sleep),  #order bars from highest to lowest average sleep
             y = avg_sleep, fill = activity_level_minutes)) +  #fill bars by activity level
  geom_col() +                                                #create a bar chart
  geom_text(aes(label = paste0(round(avg_sleep, 1), " hrs")), #add average values on top of bars
            vjust = -0.5, fontface = "bold") +                #djust text position and make bold
  labs(
    title = "Average hours of sleep according to daily activity level",  #add chart title and axis labels
    x = "Activity Level",
    y = "Hours of Sleep"
  ) +
  theme_minimal() +                                          #apply clean minimalistic theme
  theme(
    plot.title = element_text(hjust = 0.6, face = "bold", size = 14),     #bold and centered title
    plot.subtitle = element_text(hjust = 0.5, size = 11, color = "gray30"),   #subtitle below the title
    axis.title = element_text(face = "bold", size = 12),                  #bold axis labels
    axis.text = element_text(size = 10),                                  #size of axis text
    panel.grid.major.x = element_blank(),                                 #remove vertical grid lines
    panel.grid.major.y = element_line(color = "gray80"),                  #light horizontal lines
    panel.grid.minor = element_blank(),                                   #no minor grid lines
    plot.background = element_rect(fill = "grey", color = NA),            #gray background
    axis.text.x = element_text(angle = 20, hjust = 1)
    )

ggsave("Percetage_of_days_according_to_activity_level.png", width = 8, height = 5, dpi = 300)
getwd()
