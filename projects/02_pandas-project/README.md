# Project: Data Cleaning and Manipulation with Pandas
In this projected a data set on world wide shark attacs was was edited and cleaned.

The original data set contained a total of 5992 shark attacs (rows) and 24 columns. For more inforation on the original data set, see [Shark Attack](https://www.kaggle.com/teajay/global-shark-attacks/version/1).

The cleaned data set also contains a total of 5992 shark attacs (rows) but only 18 of the original columns and one extra column. The following steps were taken to get this result.

1. Column names were changed to all lower case and without any special characters
* Columns with only little information were dropped:
	* more than 99.9% of the columns *unnamed 22* and *unnamed 23* were missing values, hence they were dropped
	* there were two column with links to data sources that were almost identical. Therefore, the one with some non-functioning links was dropped
* For some shark attacks, especially more recent ones, proper dates (JJJJ-MM-DD) are available in the original data set. Those dates were extracted, and stored in a new column *proper_date*
* The old ID column with inconsistent identifyers was substituted by a ID column with values ranging from 1 to 5992
* In the name column, the value *male* was substitued with *NaN*, since no name is available
* the sex-column was cleaned to having values *M, W, NaN*

