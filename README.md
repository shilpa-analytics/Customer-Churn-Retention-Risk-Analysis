# Customer Churn & Retention Risk Analysis Dashboard

## 📊 Project Overview

I built this project to analyze customer churn and understand which customers may be at higher risk of leaving.

I used **SQL Server** for the data analysis and **Microsoft Excel** to build the data model and interactive dashboard. My goal was to take the customer data from the database and turn it into something that could be used to understand churn patterns and potential revenue impact.

**Workflow:** SQL Server → SQL Analysis → Power Query → Power Pivot → Excel Dashboard → Business Insights

---

## 🎯 Business Questions

I wanted to use the data to answer questions such as:

* How many customers have churned?
* What is the overall churn rate?
* Which contract types have higher churn?
* How does churn vary by internet service and payment method?
* Does customer tenure appear to be related to churn?
* Which customers have higher retention risk?
* How much revenue has been lost from churn?
* Which high-value customers may need more attention?

---

## 🛠️ Tools Used

* SQL Server
* SQL
* Microsoft Excel
* Power Query
* Power Pivot
* PivotTables & PivotCharts
* Excel Slicers
* Excel Dashboarding

---

## 📁 Project Workflow

### 1. Data Preparation & SQL Analysis

I loaded the customer data into SQL Server and performed data validation and analysis using SQL.

I created SQL views for different parts of the analysis, including:

* Customer churn analysis
* Churn by contract
* Churn by tenure
* Customer retention risk
* High-value customers with elevated retention risk

I also created separate SQL scripts for database creation, table creation, data loading, validation, basic analysis, segmentation, and advanced analysis.

### 2. Customer Risk Analysis

I created a simple risk scoring approach based on several customer characteristics:

* Month-to-month contract
* Short customer tenure
* Higher monthly charges
* No online security
* No technical support

These factors were used to group customers into different retention-risk categories.

### 3. Excel Data Model

I connected the SQL Server views to Excel using **Power Query** and used **Power Pivot** to work with the data model.

This allowed me to build an interactive dashboard where the charts and KPIs change based on slicer selections.

### 4. Interactive Dashboard

The final dashboard includes:

* **8 KPI cards**
* **6 charts**
* **5 slicers**
* Reset Filters button
* Last Refreshed timestamp
* Business insights

The dashboard looks at:

* Churn rate by contract
* Churn rate by internet service
* Churn rate by payment method
* Monthly charge distribution
* Customer retention risk
* Revenue lost by contract

---

## 📈 Key Findings

Using the full dataset of **7,043 customers**, I found:

* Overall churn rate: **26.54%**
* Average customer tenure: **32.37 months**
* Revenue lost from churn: approximately **$139,131**
* High-value customers with elevated retention risk: **84**
* Estimated value associated with these customers: approximately **$454,250**

Some of the patterns I found were:

* Month-to-month customers had much higher churn than customers with one-year or two-year contracts.
* Electronic-check customers had the highest churn rate among the payment methods analyzed.
* Customers with higher monthly charges and shorter tenure were more likely to fall into higher-risk groups.

---

## 💡 Business Insights

A few areas stood out to me during the analysis:

1. **Month-to-month customers** had considerably higher churn, which suggests that encouraging longer-term contracts could be worth investigating.

2. **High-value customers with elevated retention risk** represent a potentially important group because losing these customers could have a larger financial impact.

3. **Electronic-check customers** had the highest churn rate among the payment methods. This could be an area for further investigation.

4. Customers with a combination of **short tenure, higher monthly charges, and limited support or security services** may need closer attention from a retention perspective.

These findings are based on the patterns in this dataset and would need further analysis before making actual business decisions.

---

## 📊 Dashboard

![Customer Churn & Retention Risk Analysis Dashboard](customer-churn-dashboard.png)
---

## 🔍 Project Validation

I compared the main Excel dashboard results with the corresponding SQL Server calculations to make sure the numbers were consistent.

I also tested the dashboard using different slicer selections to make sure the KPIs, charts, and business insights responded correctly.

---

## 📂 Project Files

* 📊 **[Dashboard Screenshot](customer-churn-dashboard.png)** — Preview of the completed dashboard
* 📗 **[Excel Dashboard Workbook](Customer_Churn_Retention_Risk_Analysis.xlsm)** — Excel workbook containing the dashboard, Power Query, Power Pivot, slicers, and VBA reset functionality
* 🗄️ **[SQL Analysis Scripts](02_SQL%20Scripts/)** — SQL scripts used for database setup, data preparation, validation, analysis, and view creation

---

## 🚀 Skills I Practiced

Through this project, I worked with:

* SQL querying
* SQL views
* Data validation
* Customer segmentation
* Risk scoring
* Excel data modeling
* Power Query
* Power Pivot
* PivotTables and PivotCharts
* Excel slicers
* Dashboard design
* KPI development
* Business insights
* Connecting SQL Server with Excel
