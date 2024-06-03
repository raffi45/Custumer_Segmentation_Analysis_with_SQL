# customer segmentation analysis

## Project Overview
The project initiates by setting up a Transaction_Data table to house transactional details, importing data from a CSV file. It then focuses on segmenting German customers utilizing the RFM (Recency, Frequency, Monetary) analysis method. Segmentation is categorized into four groups: 'Best Customers', 'Loyal Customers', 'Potential Loyalists', and 'Regular Customers', based on their RFM scores. SQL queries are employed to compute RFM scores and assign customers to respective segments. This segmentation enables tailored marketing strategies and enhances customer engagement approaches. Through this analysis, businesses can better understand customer behavior, leading to improved marketing tactics and increased customer satisfaction, ultimately fostering business growth and success.

## Customer Segmentation

- Focus on German Customers: The segmentation analysis focuses on customers from Germany.
- RFM Methodology: The Recency, Frequency, Monetary (RFM) analysis method is used to segment customers based on their transactional behavior.
- Segmentation Criteria:
    - Customers are segmented into four categories:
        - Best Customers: Customers with an RFM score of 12 or higher.
        - Loyal Customers: Customers with an RFM score between 9 and 11.
        - Potential Loyalists: Customers with an RFM score between 6 and 8.
        - Regular Customers: All other customers who do not fit into the above categories.

## RFM
RFM, which stands for Recency, Frequency, Monetary, is a method used for customer segmentation based on their transactional behavior. Each aspect of RFM represents a different dimension of a customer's interaction with a business:

- Recency (R): Refers to how recently a customer has made a purchase. Customers who have made purchases more recently are likely to be more engaged with the business and may have higher retention rates.
- Frequency (F): Indicates how often a customer makes purchases within a given time period. Customers who make frequent purchases are often more loyal and valuable to the business.
- Monetary (M): Represents the total monetary value of purchases made by a customer within a given time period. This dimension helps identify high-value customers who contribute significantly to the business's revenue.

<br>
By analyzing these three dimensions together, businesses can segment their customers into distinct groups, allowing for targeted marketing strategies and personalized approaches to customer engagement. RFM segmentation enables businesses to identify their most valuable customers, re-engage inactive customers, and tailor marketing efforts to specific customer segments, ultimately leading to improved customer retention and increased profitability.
#### set the RFM score

```
-- Update segment based on RFM Score
UPDATE RFM_german
SET Segment = CASE
    WHEN RFMScore >= 12 THEN 'Best Customers'
    WHEN RFMScore BETWEEN 9 AND 11 THEN 'Loyal Customers'
    WHEN RFMScore BETWEEN 6 AND 8 THEN 'Potential Loyalists'
    ELSE 'Regular Customers'
END;

SAVE TRANSACTION SP7;
```
