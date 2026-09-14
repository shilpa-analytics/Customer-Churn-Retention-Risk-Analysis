Customer Churn & Retention Risk Analysis Dashboard
📊 Project Overview 
This project analyzes customer churn, retention risk, and revenue impact using SQL Server and Microsoft Excel.
The goal was to transform raw customer data into an interactive analytical solution that identifies key churn drivers, high-risk customer segments, and potential revenue at risk.
The project demonstrates an end-to-end data analytics workflow:
SQL Server → SQL Analysis → Power Query → Power Pivot → Excel Dashboard → Business Insights
________________________________________
🎯 Business Objective
The analysis was designed to answer questions such as:
•	How many customers have churned?
•	What is the overall customer churn rate?
•	Which contract types have the highest churn?
•	Which internet service and payment methods are associated with higher churn?
•	How does customer tenure relate to churn?
•	Which customers have elevated retention risk?
•	How much revenue has been lost due to churn?
•	Which high-value customers should be prioritized for retention?
________________________________________
🛠️ Tools & Technologies
•	SQL Server
•	SQL
•	Microsoft Excel
•	Power Query
•	Power Pivot
•	PivotTables & PivotCharts
•	Excel Slicers
•	Excel Dashboarding
________________________________________
📁 Project Workflow
1. Data Preparation & SQL Analysis
Customer data was loaded into SQL Server and analyzed using SQL.
SQL views were created to support different areas of the analysis, including:
•	Customer churn analysis
•	Churn by contract
•	Churn by tenure
•	Customer retention risk
•	High-value customers with elevated retention risk
________________________________________
2. Customer Risk Analysis
A customer risk scoring approach was developed using factors such as:
•	Month-to-month contract
•	Short customer tenure
•	Higher monthly charges
•	Lack of online security
•	Lack of technical support
Customers were then categorized into retention-risk groups.
________________________________________
3. Excel Data Model
SQL analysis results were connected to Excel using Power Query and incorporated into a Power Pivot data model.
This allowed the dashboard to dynamically respond to slicer selections while maintaining a reusable analytical structure.
________________________________________
4. Interactive Dashboard
The final Excel dashboard includes:
•	8 KPI cards
•	6 interactive charts
•	5 slicers
•	Dynamic filtering
•	Reset Filters functionality
•	Last Refreshed timestamp
•	Business insight section
Dashboard Analysis
The dashboard provides analysis of:
•	Churn rate by contract
•	Churn rate by internet service
•	Churn rate by payment method
•	Monthly charge distribution
•	Customer retention risk
•	Revenue lost by contract
________________________________________
📈 Key Findings
Using the full customer dataset:
•	7,043 customers were analyzed.
•	Overall customer churn rate was 26.54%.
•	Average customer tenure was approximately 32.37 months.
•	Revenue lost from churn was approximately $139,131.
•	84 high-value customers were identified as having elevated retention risk.
•	The estimated value associated with these high-value at-risk customers was approximately $454,250.
•	Month-to-month customers showed substantially higher churn than customers on longer-term contracts.
•	Electronic-check customers showed the highest churn rate among the payment methods analyzed.
________________________________________
💡 Business Insights
The analysis highlights several areas where a business could focus retention efforts:
1.	Month-to-month customers represent a particularly important churn-risk segment and may benefit from incentives to move to longer-term contracts.
2.	High-value customers with elevated retention risk should receive priority because losing these customers can have a larger financial impact.
3.	Electronic-check customers show significantly higher churn and may warrant further investigation into payment experience, customer behavior, or related service factors.
4.	Customers with combinations of short tenure, higher monthly charges, and limited support/security services may require proactive retention strategies.
________________________________________
📊 Dashboard
 
________________________________________
🔍 Project Validation
The Excel dashboard results were validated against the corresponding SQL Server calculations to ensure that the reported KPIs and analytical results were accurate.
Slicer interactions and dashboard behavior were also tested to ensure that the interactive reporting experience worked correctly.
________________________________________
🚀 Skills Demonstrated
This project demonstrates practical experience with:
•	SQL querying and analytical views
•	Data transformation
•	Relational data analysis
•	Customer segmentation
•	Risk scoring
•	KPI development
•	Excel data modeling
•	Power Query
•	Power Pivot
•	PivotTables and PivotCharts
•	Interactive dashboard design
•	Business intelligence reporting
•	Translating data into business recommendations
