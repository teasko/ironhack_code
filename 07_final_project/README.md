# Pollution at new year

This is my final project for the Ironhack bootcamp. In this project I analyze pollution (Particulate Matter - PM) at new year in different cities in Germany. The analysis is based on data from PM sensors that are part of a citizen science project. The overall question is whether local bans on private fireworks have a measurable effect on the city wide pollution at new years eve.

## Data
Data is obtained from a network of DIY sensors. Those sensors send their data to a local server that provides an API to retrieve them. Since the sensor project is relatively new and many sensors were just put up in the last two years, I restricted my analysis to the years 2018-2020. 

Most sensors are within a so called box with multiple sensors, e.g. for PM, humidity, temperature, ...

**The open sensor project**:
https://luftdaten.info
https://opensensemap.org


**The API for getting the data**:
https://api.opensensemap.org

** Other APIs used**
https://developer.here.com/
https://www.worldweatheronline.com/developer/api/

## Notebooks
1. *get_relevant_sensor_boxes*
	* identyfing boxes that submitted data for the time spans I am interested in
	* identifying boxes that are in Germany
	* adding information in location (country, city, district) based on coordinates with HERE API
* *get_data_new_years*
	* for the boxes previously identified, this notebook requests data from the opensourcemap-API for new year 2018/2019 and 2019/2020 and transforms it into dataframes with hourly data
* *get_data_new_years_PM25*
	* same as *get_data_new_years* but for PM2.5 instead of PM10
* *get_1_year_data*
	* for 27 previosly identified sensors in Berlin, this notebook requests data from the opensourcemap-API for 2018-12-30 - 2020-01-05 and transforms it into a dataframe with hourly data
* *get_weather_info_for_cities*
	* retrieves weather info for the german cities of interest for new year 2018/2019 and 2019/2020 from worldweatheronline-API
* *analyze_1_year_data*
	* for the data created by *get_1_year_data*, this mainly produces a plot of the mean and median development of pollution in Berlin for 2019
	* sensors with too many missing data are identified and dropped
* *analyze_newyears_data*
	A. for every german city under consideration, check all the sensors and drop those which have too many missing data or seem to be malfunctioning
	B. for the remaining sensors, calculate averages for every sensor over a definied time-frame
	C. for every city, calculate the median of all sensor averages
	D. make a bar plot to illustrate city-comparison
* *analyze_newyears_data_PM25*
	* same as *analyze_newyears_data* but for PM2.5 instead of PM10
* *make_video_4_presentation*
	* illustrate "typical" new years by looking at one sensor in Berlin between 2019-12-31-4pm and 2020-01-01-4am
	* make a video with matplotlib for that sensor suitable for presentation
	




	




