# H & M Customer Segmentation

## Project Summary / Overview
The aim of this project is to amplify the efficiency of marketing strategies and boost sales through customer segmentation.
We aim to transform the transcational data into a customer-centric dataset by creating new features that will facilitate 
the segmentation of customers into distinct groups using the K-means clustering algorithm.
This segmentation will allow us to understand the distinct profiles and preferences of different customer groups.

## Project Files / Repository Contents
- **data** :
  - `raw/transaction.csv`, `raw/articles.csv` : original data
  - `merged_df.csv` : merged dataset from the original files
  - `customer_data.csv`: newly generated customer data with 14 main columns
- **notebook**
  - `Segmentation & recommendation.ipynb` : analysis and modeling
- **assets** : Visualisations, such as `Radar chart.png` and `histogram chart.png` after k-means clustering.


## Methodology ( Solution strategies )
- **Data Loading and New Data Creation** : Using the **Dask** module, import the over 3GB `transaction.csv` file, merge it with `article.csv`, and generate `merged_df.csv`.
- **Data Cleaning** : Clean the dataset by handling missing values, duplicates, and outliers, preparing it for effective clustering.
- **Feature Engineering** : Develop new features based on `merged_df.csv` to create a customer-centric dataset, setting the foundation for customer segmentation.
- **Data Preprocessing** : Undertake feature scaling and **dimensionality reduction(PCA, K-means, Silhouette Method)** to streamline the data, enhancing the efficiency of the clustering process.
- **Customer Segmentation using k-Means Clsutering** : Segment customers into distinct groups using **K-means**, facilitating targeted marketing and personalized strategies.
- **Cluster Analysis & Evaluation** : Analyze and profile each cluster to develop targeted marketing strategies and assess the quality of the clusters formed.
  
## Key findings
### Customer Profiles Derived from Radar Chart Analysis

![test](assets/Radarchart.png)
**Cluster 0: Casual Weekend Shoppers**
- Customers in this cluster usually shop less frequently and spend less money compared to other clusters.
- They generally have a smaller number of transactions and purchase fewer products.
- They prefer shopping during weekends, possibly engaging in casual or window shopping.
- Their spending habits are quite stable over time, showing little fluctuation in their monthly spending.
  
**Cluster 1: Occasional Big Spenders**
- Customers in this cluster shop infrequently, as indicated by a longer **Average_Days_Between_Purchases**.
- Their spending has been increasing, suggesting a growing interest or investment in their purchases.
- They tend to have high monthly spending with a large standard deviation, indicating variability in spending within the group.
- Their **Average_Transaction_Value** is high compared to other clusters.

**Cluster 2: Frequent Big Spenders**
- Customers in this cluster shop frequently, with a high total purchase volume and number of transactions.
- Although they shop often, they tend to spend less per transaction, buying a variety of products.
- They prefer shopping on weekdays.
- Their spending trend is decreasing, which might signal a future change in their shopping habits.

### Marketing strategies

<div align="center">
  
| Cluster | Suggested Marketing Strategies |
|:-------:|:-------------------------------|
| **Cluster 0** | - Weekend-only promotions<br>- Casual browsing incentives (e.g., "Weekend Flash Sales")<br>- Loyalty rewards for consistent shoppers |
| **Cluster 1** | - Personalized luxury or premium product offers<br>- Special discounts after periods of inactivity<br>- Exclusive early-access events |
| **Cluster 2** | - Weekday-only discounts<br>- Bundling offers ("Buy more, save more")<br>- Reactivation campaigns to counteract decreasing trend |

</div>

## Conclusions

- User end : personalized shopping experiences based on their purchase behavior
- Business end : personalized shopping experiences based on their purchase behavior, identify high-value or at-risk customers to improve retention and engagement, Supports personalized promotions, leading to improved ROI and reduced marketing costs.




## Used Datasets
- H & M H&M Apparel Data [h-and-m-personalized-fashion-recommendations](https://www.kaggle.com/competitions/h-and-m-personalized-fashion-recommendations)
- Reference : [Customer Segmentation & Recommendation System](https://www.kaggle.com/code/farzadnekouei/customer-segmentation-recommendation-system)
