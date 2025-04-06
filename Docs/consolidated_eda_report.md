# Sales Data Analysis Report

## Full Analysis Summary

```text
=== Sales Analysis Summary ===


--- Sales by Category ---

      category  sales_amount
1        Bikes      28316272
0  Accessories        700262
2     Clothing        339716


--- Top 10 Products by Sales ---

product_name
Mountain-200 Black- 46     1373454
Mountain-200 Black- 42     1363128
Mountain-200 Silver- 38    1339394
Mountain-200 Silver- 46    1301029
Mountain-200 Black- 38     1294854
Mountain-200 Silver- 42    1257368
Road-150 Red- 48           1205786
Road-150 Red- 62           1202208
Road-150 Red- 52           1080556
Road-150 Red- 56           1055510


--- Customer Demographics ---


Gender Distribution Summary:

   gender  total_sales  order_count  customer_count
0  Female     14804168        13737            9128
1    Male     14522393        13906            9341
2     n/a        29689           16              15


Age Distribution Statistics:

count    60319.000000
mean        55.839752
std         11.325568
min         39.000000
25%         47.000000
50%         54.000000
75%         63.000000
max        109.000000


Average Order Value by Marital Status:

  marital_status  average_sales  order_count
0        Married     456.405644        33273
1         Single     522.406083        27125


--- Temporal Analysis ---


Sales by Day of Week:

day_of_week
Monday       4234993
Tuesday      4342322
Wednesday    4231322
Thursday     4154501
Friday       4155309
Saturday     4124471
Sunday       4113332


Monthly Sales Pivot (Year vs Month):

month   January  February      March      April        May       June       July     August  September    October   November   December
year                                                                                                                                   
2010        NaN       NaN        NaN        NaN        NaN        NaN        NaN        NaN        NaN        NaN        NaN    43419.0
2011   469795.0  466307.0   485165.0   502042.0   561647.0   737793.0   596710.0   614516.0   603047.0   708164.0   660507.0   669395.0
2012   495363.0  506992.0   373478.0   400324.0   358866.0   555142.0   444533.0   523887.0   486149.0   535125.0   537918.0   624454.0
2013   857758.0  771218.0  1049732.0  1045860.0  1284456.0  1642948.0  1371595.0  1550862.0  1447324.0  1673301.0  1780688.0  1874128.0
2014    45642.0       NaN        NaN        NaN        NaN        NaN        NaN        NaN        NaN        NaN        NaN        NaN


--- Geographic Analysis ---


Sales Summary by Country:

          country  total_sales  average_sales  order_count
5   United States      9162327     447.532213        20473
0       Australia      9060172     678.918846        13345
4  United Kingdom      3391376     491.076745         6906
3         Germany      2894066     514.500622         5625
2          France      2643751     475.665887         5558
1          Canada      1977738     259.545669         7620
6             n/a       226820     260.413318          871


--- Advanced Metrics & Customer Behavior ---


Customer Lifetime Value (Total Sales per Customer) Statistics:

count    18484.000000
mean      1588.197901
std       2124.157912
min          2.000000
25%         50.000000
50%        271.500000
75%       2511.000000
max      13294.000000


Order Frequency (Number of Orders per Customer) Statistics:

count    18484.000000
mean         1.496375
std          1.101139
min          1.000000
25%          1.000000
50%          1.000000
75%          2.000000
max         28.000000


--- Numeric Variable Distributions & Correlation ---


Summary Statistics for Key Numeric Variables:

       sales_amount      quantity         price           age
count  60398.000000  60398.000000  60398.000000  60319.000000
mean     486.046723      1.000414    486.037783     55.839752
std      928.450537      0.044011    928.454329     11.325568
min        2.000000      1.000000      2.000000     39.000000
25%        8.000000      1.000000      8.000000     47.000000
50%       30.000000      1.000000     30.000000     54.000000
75%      540.000000      1.000000    540.000000     63.000000
max     3578.000000     10.000000   3578.000000    109.000000


Correlation Matrix:

              sales_amount  quantity     price       age
sales_amount      1.000000 -0.003994  0.999999 -0.036747
quantity         -0.003994  1.000000 -0.004705  0.008177
price             0.999999 -0.004705  1.000000 -0.036753
age              -0.036747  0.008177 -0.036753  1.000000


--- Bivariate Analysis Highlights ---


Sales vs Age OLS Trendline Summary:\n                            OLS Regression Results                            
==============================================================================
Dep. Variable:                      y   R-squared:                       0.000
Model:                            OLS   Adj. R-squared:                  0.000
Method:                 Least Squares   F-statistic:                     2.022
Date:                Sat, 05 Apr 2025   Prob (F-statistic):              0.155
Time:                        21:39:26   Log-Likelihood:                -41225.
No. Observations:                4989   AIC:                         8.245e+04
Df Residuals:                    4987   BIC:                         8.247e+04
Df Model:                           1                                         
Covariance Type:            nonrobust                                         
==============================================================================
                 coef    std err          t      P>|t|      [0.025      0.975]
------------------------------------------------------------------------------
const        587.8995     67.485      8.712      0.000     455.600     720.199
x1            -1.6869      1.186     -1.422      0.155      -4.013       0.639
==============================================================================
Omnibus:                     1670.973   Durbin-Watson:                   1.998
Prob(Omnibus):                  0.000   Jarque-Bera (JB):             4156.988
Skew:                           1.898   Prob(JB):                         0.00
Kurtosis:                       5.365   Cond. No.                         289.
==============================================================================

Notes:
[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.


Sales Amount Statistics per Category:\n               count         mean         std    min    25%     50%     75%     max
category                                                                           
Accessories  36092.0    19.402139   20.597601    2.0    5.0    10.0    35.0   159.0
Bikes        15205.0  1862.300033  944.119069  540.0  783.0  2071.0  2384.0  3578.0
Clothing      9101.0    37.327327   22.803065    9.0    9.0    50.0    54.0   256.0
```


## Monthly Sales Trend

[View Interactive Plot: Monthly Sales Trend](analysis_output/1_monthly_sales_trend.html)


## Sales By Category

![Sales By Category](analysis_output/2a_sales_by_category.png)


## Top 10 Products

[View Interactive Plot: Top 10 Products](analysis_output/2b_top_10_products.html)


## Sales Sunburst Category Subcategory

[View Interactive Plot: Sales Sunburst Category Subcategory](analysis_output/2c_sales_sunburst_category_subcategory.html)


## Sales By Gender Pie

[View Interactive Plot: Sales By Gender Pie](analysis_output/3a_sales_by_gender_pie.html)


## Customer Count By Gender Bar

[View Interactive Plot: Customer Count By Gender Bar](analysis_output/3b_customer_count_by_gender_bar.html)


## Customer Age Distribution

[View Interactive Plot: Customer Age Distribution](analysis_output/3c_customer_age_distribution.html)


## Avg Sales By Marital Status

[View Interactive Plot: Avg Sales By Marital Status](analysis_output/3d_avg_sales_by_marital_status.html)


## Sales By Day Of Week

[View Interactive Plot: Sales By Day Of Week](analysis_output/4a_sales_by_day_of_week.html)


## Monthly Sales Heatmap

![Monthly Sales Heatmap](analysis_output/4b_monthly_sales_heatmap.png)


## Sales By Country Map

[View Interactive Plot: Sales By Country Map](analysis_output/5a_sales_by_country_map.html)


## Top Countries Sales Bar

[View Interactive Plot: Top Countries Sales Bar](analysis_output/5b_top_countries_sales_bar.html)


## Clv Distribution

[View Interactive Plot: Clv Distribution](analysis_output/6a_clv_distribution.html)


## Order Frequency Distribution

[View Interactive Plot: Order Frequency Distribution](analysis_output/6b_order_frequency_distribution.html)


## Distribution Age

[View Interactive Plot: Distribution Age](analysis_output/7a_distribution_age.html)


## Distribution Price

[View Interactive Plot: Distribution Price](analysis_output/7a_distribution_price.html)


## Distribution Quantity

[View Interactive Plot: Distribution Quantity](analysis_output/7a_distribution_quantity.html)


## Distribution Sales Amount

[View Interactive Plot: Distribution Sales Amount](analysis_output/7a_distribution_sales_amount.html)


## Correlation Heatmap

![Correlation Heatmap](analysis_output/7b_correlation_heatmap.png)


## Sales Vs Age Scatter

[View Interactive Plot: Sales Vs Age Scatter](analysis_output/8a_sales_vs_age_scatter.html)


## Sales By Category Boxplot

[View Interactive Plot: Sales By Category Boxplot](analysis_output/8b_sales_by_category_boxplot.html)
