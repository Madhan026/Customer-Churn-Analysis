# 📊 Customer Churn Analysis & Prediction

## 📌 Project Overview

Customer churn is a major challenge for subscription-based businesses because losing existing customers can reduce recurring revenue and increase customer acquisition costs.

This project develops an end-to-end **Customer Churn Analysis and Prediction** solution using SQL Server, Python, Machine Learning, MLflow, LIME, and Power BI.

The project analyzes customer behavior, identifies patterns associated with churn, handles class imbalance, compares multiple machine learning models, explains individual predictions, and converts prediction results into business-oriented retention actions.

### End-to-End Workflow

```text
SQL Server
    ↓
Data Cleaning & EDA
    ↓
Python / Pandas
    ↓
Feature Engineering
    ↓
Train-Test Split
    ↓
SMOTE
    ↓
Machine Learning
    ↓
Model Evaluation
    ↓
MLflow Experiment Tracking
    ↓
LIME Explainability
    ↓
Customer Churn Predictions
    ↓
Risk Classification
    ↓
Retention Strategy
    ↓
Power BI Dashboard
```

---

## 🎯 Project Objectives

- Analyze customer churn patterns.
- Clean and prepare customer data using SQL Server.
- Perform Exploratory Data Analysis using SQL and Python.
- Engineer additional customer-level features.
- Build machine learning models for churn prediction.
- Handle class imbalance using SMOTE.
- Compare Logistic Regression, Random Forest, and XGBoost.
- Track experiments using MLflow.
- Explain individual predictions using LIME.
- Generate customer-level churn probabilities and risk categories.
- Build an interactive Power BI dashboard.
- Create a business-oriented **Retention Strategy** as an independent extension.
- Present the complete project in a manager-ready format.

---

# 📂 Dataset

### Dataset

**Telco Customer Churn Dataset**

The dataset contains customer demographic information, services, account information, contract details, payment method, monthly charges, total charges, tenure, and churn status.

### Dataset Size

| Item | Value |
|---|---:|
| Customers | 7,043 |
| Original columns | 21 |
| Modeling source features | 20 |
| Target variable | `Churn` |

### Important Features

- CustomerID
- Gender
- SeniorCitizen
- Partner
- Dependents
- Tenure
- PhoneService
- MultipleLines
- InternetService
- OnlineSecurity
- OnlineBackup
- DeviceProtection
- TechSupport
- StreamingTV
- StreamingMovies
- Contract
- PaperlessBilling
- PaymentMethod
- MonthlyCharges
- TotalCharges
- Churn

---

# 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| SQL Server | Data storage, cleaning, transformation and EDA |
| Python | Data processing and machine learning |
| Pandas | Data manipulation |
| NumPy | Numerical operations |
| Scikit-learn | Machine learning |
| SMOTE | Class imbalance handling |
| XGBoost | Gradient boosting |
| MLflow | Experiment tracking |
| LIME | Model explainability |
| Power BI | Interactive dashboard |
| Jupyter Notebook | Development and analysis |
| Streamlit | Optional prediction application |
| Docker | Optional application containerization |
| GitHub | Version control and documentation |

---

# 🔄 Project Architecture

```text
                  Telco Customer Churn Dataset
                              │
                              ▼
                         SQL Server
                              │
                 ┌────────────┴────────────┐
                 │                         │
           Data Cleaning               SQL EDA
                 │                         │
                 └────────────┬────────────┘
                              ▼
                       vw_ChurnData
                              │
                              ▼
                       Python / Pandas
                              │
                              ▼
                     Data Preprocessing
                              │
                              ▼
                     Feature Engineering
                              │
                              ▼
                       Train / Test Split
                              │
                              ▼
                            SMOTE
                              │
                              ▼
                    Machine Learning Models
                       /       |        \
                      /        |         \
                     ▼         ▼          ▼
              Logistic     Random      XGBoost
             Regression    Forest
                     \        |         /
                      \       |        /
                       ▼      ▼       ▼
                         Model Evaluation
                              │
                              ▼
                           MLflow
                              │
                              ▼
                            LIME
                              │
                              ▼
                     Churn Predictions
                              │
                              ▼
                       Risk Categories
                              │
                              ▼
                     Retention Strategy
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
                 Power BI           Streamlit
```

---

# 🗄️ 1. SQL Server Data Preparation

The dataset was imported into SQL Server and stored in the following database and table:

```text
Database: ChurnDB
Table:    dbo.CustomerChurn
View:     vw_ChurnData
```

### SQL Processing

The SQL stage included:

- Data import
- Missing-value handling
- Data type conversion
- Duplicate checking
- Data cleaning
- Derived categories
- Churn analysis
- Contract analysis
- Tenure analysis
- Charge analysis
- Internet-service analysis
- Creation of the final SQL view

---

# 📈 2. SQL Exploratory Data Analysis

The dataset contains **7,043 customers**, of which **1,869 customers are churned**.

| Customer Status | Customers |
|---|---:|
| No Churn | 5,174 |
| Churn | 1,869 |
| **Total** | **7,043** |

### Overall Churn Rate

**26.54%**

This is the observed churn rate in the complete dataset.

---

## Contract-wise Churn

| Contract | Total Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| Month-to-month | 3,875 | 1,655 | 42.71% |
| One year | 1,473 | 166 | 11.27% |
| Two year | 1,695 | 48 | 2.83% |

---

## Tenure-wise Churn

| Tenure Group | Total Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| 0–12 months | 2,186 | 1,037 | 47.44% |
| 13–24 months | 1,024 | 294 | 28.71% |
| 25–48 months | 1,594 | 325 | 20.39% |
| 49+ months | 2,239 | 213 | 9.51% |

---

## Internet Service-wise Churn

| Internet Service | Total Customers | Churned Customers | Churn Rate |
|---|---:|---:|---:|
| Fiber optic | 3,096 | 1,297 | 41.89% |
| DSL | 2,421 | 459 | 18.96% |
| No Internet | 1,526 | 113 | 7.40% |

---

## Charge Category Analysis

| Charge Category | Churn Rate |
|---|---:|
| High | 35.48% |
| Medium | 23.65% |
| Low | 11.59% |

These are descriptive associations observed in the dataset and should not be interpreted as proof of causation.

---

# 🐍 3. Python Data Processing

The cleaned SQL view was loaded into Python using Pandas.

```text
SELECT * FROM vw_ChurnData
```

### Data Shape

```text
Initial SQL view:       (7043, 20)
Processed dataset:      (7043, 32)
Feature matrix X:       (7043, 31)
```

The Python preprocessing stage included:

- Missing-value checks
- Data-type checks
- Duplicate checks
- Numerical/categorical feature identification
- One-hot encoding
- Feature preparation for machine learning

---

# ⚙️ 4. Feature Engineering

Two additional features were created:

### `TotalServicesUsed`

Represents the number of services used by a customer.

### `AvgMonthlySpend`

Represents the customer's average monthly spending based on the available customer/account information.

These engineered features were included in the modeling dataset.

---

# 🤖 5. Machine Learning

The data was divided into training and testing sets.

```text
Training samples: 5,634
Testing samples:  1,409
```

### Models Evaluated

1. Logistic Regression
2. Random Forest
3. XGBoost

The models were evaluated using:

- Precision
- Recall
- F1-score
- Cross-validation F1-score

---

# ⚖️ 6. Handling Class Imbalance with SMOTE

The training dataset contained fewer churn cases than non-churn cases.

### Before SMOTE

```text
No Churn: 4,139
Churn:    1,495
```

SMOTE was applied **only to the training data**.

### After SMOTE

```text
No Churn: 4,139
Churn:    4,139
```

The test dataset was kept unchanged.

This prevents synthetic samples from being introduced into the test set.

---

# 📊 7. Model Evaluation

### Model Comparison

| Model | Precision | Recall | F1-score |
|---|---:|---:|---:|
| Logistic Regression | 0.5524 | 0.6765 | 0.6082 |
| Random Forest | 0.5700 | 0.6096 | 0.5891 |
| XGBoost | 0.5752 | 0.6444 | 0.6078 |

The downstream prediction workflow used **Logistic Regression**.

### Logistic Regression Test Performance

```text
Precision : 0.5524
Recall    : 0.6765
F1-score  : 0.6082
```

The selected workflow was then used to generate churn probabilities for the test/prediction population.

---

# 🧪 8. MLflow Experiment Tracking

MLflow was used to record machine learning experiments.

The tracked information included:

- Model parameters
- Model metrics
- Model artifacts
- Experiment runs

Models evaluated through MLflow included:

- Logistic Regression
- Random Forest
- XGBoost

MLflow provides an experiment history that makes model development easier to review and reproduce.

---

# 🔍 9. LIME Model Explainability

LIME (Local Interpretable Model-Agnostic Explanations) was used to explain individual churn predictions.

Instead of only showing:

```text
Customer → High Churn Risk
```

LIME helps identify which customer features contributed to that individual prediction.

Examples of features examined include:

- Contract type
- Monthly charges
- Tenure
- Internet service
- Payment method
- Services used

This makes model output easier to interpret from a business perspective.

---

# 📋 10. Customer Churn Prediction Output

The final prediction dataset contains **1,409 test/prediction records** and **9 columns**.

```text
ChurnPredictions_Final.csv
```

### Prediction Columns

| Column | Description |
|---|---|
| CustomerID | Customer identifier |
| MonthlyCharges | Customer's monthly charge |
| Contract_One year | Encoded contract feature |
| Contract_Two year | Encoded contract feature |
| ChurnProbability | Model-generated churn probability |
| PredictedChurn | Predicted churn status |
| Contract | Customer contract type |
| RiskCategory | Customer risk classification |
| RetentionStrategy | Business retention action |

### Important Population Note

The **1,409 records are the held-out test/prediction population**, not the complete 7,043-customer dataset.

---

# 🎯 11. Risk Classification

The churn probability was converted into a risk category for dashboard and business analysis.

The prediction output contains:

```text
ChurnProbability
PredictedChurn
RiskCategory
```

These fields allow the business dashboard to move from raw model probabilities to customer-level risk monitoring.

---

# 💡 12. Independent Extension — Retention Strategy

As the independent extension for the final milestone, a **Retention Strategy Recommendation** layer was added.

The machine learning model predicts churn risk. The retention strategy is a separate business-rule layer that converts risk and customer characteristics into suggested actions.

### Strategy Logic

```text
High Risk
   │
   ├── Month-to-month → Offer contract upgrade discount
   ├── High monthly charges → Offer personalized pricing or discount
   └── Other high-risk → Provide proactive customer support

Medium Risk
   │
   ├── Month-to-month → Offer loyalty benefits and contract upgrade
   ├── High monthly charges → Offer targeted discount
   └── Other medium-risk → Send customer engagement campaign

Low Risk
   │
   └── Standard retention monitoring
```

### Final Strategy Distribution

| Retention Strategy | Customers |
|---|---:|
| Standard retention monitoring | 862 |
| Offer loyalty benefits and contract upgrade | 276 |
| Offer contract upgrade discount | 248 |
| Offer targeted discount | 15 |
| Send customer engagement campaign | 8 |
| **Total** | **1,409** |

This extension connects the prediction output to an actionable business workflow.

---

# 📊 13. Power BI Dashboard

The Power BI dashboard contains three pages.

## Page 1 — Overview

The Overview page presents the overall customer and churn analysis, including:

- Total Customers
- Churned Customers
- Overall Churn %
- Revenue-related metrics
- Churn by Contract
- Churn by Tenure Group
- Customer/service analysis

### Screenshot

Add the final screenshot:

```markdown
![Power BI Dashboard Overview](./Screenshots/dashboard_overview.png)
```

---

## Page 2 — Prediction Insights

The Prediction Insights page focuses on machine-learning predictions.

It includes:

- Predicted churn customers
- Churn probability
- Predicted churn status
- Risk categories
- Contract-wise prediction analysis
- Revenue at risk
- High-risk customer count

### Screenshot

```markdown
![Power BI Prediction Insights](./Screenshots/prediction_insights.png)
```

---

## Page 3 — Retention Strategy

The Retention Strategy page was created as part of the independent Task 20 extension.

It presents:

- Predicted Customers
- Predicted Churn
- High Risk Customers
- Customers by Retention Strategy
- Monthly Revenue at Risk by Contract
- Revenue at Risk by Contract
- Key business insights

### Final Prediction Population

```text
Predicted Customers : 1,409
Predicted Churn     : 458
High Risk Customers : 248
```

### Screenshot

```markdown
![Power BI Retention Strategy](./Screenshots/retention_strategy.png)
```

---

# 💰 14. Revenue at Risk

Revenue at Risk is calculated from the monthly charges of customers predicted to churn.

Conceptually:

```text
Revenue at Risk
=
Sum of Monthly Charges
for customers predicted to churn
```

This metric connects the machine learning predictions with a business-oriented financial measure.

---

# 📷 15. Project Screenshots

Recommended screenshot structure:

```text
Screenshots/
│
├── dashboard_overview.png
├── prediction_insights.png
├── retention_strategy.png
├── model_evaluation.png
├── mlflow_experiment.png
└── lime_explanation.png
```

### Model Evaluation

```markdown
![Model Evaluation](./Screenshots/model_evaluation.png)
```

### MLflow

```markdown
![MLflow Experiment](./Screenshots/mlflow_experiment.png)
```

### LIME Explanation

```markdown
![LIME Explanation](./Screenshots/lime_explanation.png)
```

---

# ▶️ 16. How to Run the Project

## Step 1 — SQL Server

1. Install SQL Server.
2. Create the database:

```text
ChurnDB
```

3. Import the Telco Customer Churn dataset.
4. Create:

```text
dbo.CustomerChurn
```

5. Clean and transform the data.
6. Create:

```text
vw_ChurnData
```

---

## Step 2 — Python

Install the required packages:

```bash
pip install -r requirements.txt
```

Or install the main packages directly:

```bash
pip install pandas numpy scikit-learn xgboost imbalanced-learn mlflow lime matplotlib seaborn joblib sqlalchemy pyodbc streamlit
```

Open Jupyter:

```bash
jupyter notebook
```

Run the notebook in order:

```text
SQL Data Loading
      ↓
Data Cleaning
      ↓
EDA
      ↓
Feature Engineering
      ↓
Train/Test Split
      ↓
SMOTE
      ↓
Model Training
      ↓
Model Evaluation
      ↓
MLflow Tracking
      ↓
LIME Explanation
      ↓
Prediction
      ↓
Risk Classification
      ↓
Retention Strategy
      ↓
Final CSV Export
```

---

## Step 3 — Power BI

1. Open Power BI Desktop.
2. Connect to SQL Server.
3. Load the required SQL view.
4. Load `ChurnPredictions_Final.csv`.
5. Create the required DAX measures.
6. Build the Overview page.
7. Build the Prediction Insights page.
8. Build the Retention Strategy page.
9. Refresh the data.
10. Verify all cards, charts, filters, and measures.

---

# 📁 17. Suggested Repository Structure

```text
Customer-Churn-Prediction/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── SQL/
│   ├── 01_Create_Database.sql
│   ├── 02_Create_Table.sql
│   ├── 03_Data_Cleaning.sql
│   ├── 04_Create_View.sql
│   └── 05_EDA_Queries.sql
│
├── Python/
│   ├── Customer_Churn_Final.ipynb
│   ├── churn_prediction.py
│   └── ChurnPredictions_Final.csv
│
├── MLflow/
│   └── README.md
│
├── Explainability/
│   └── LIME_Analysis.ipynb
│
├── PowerBI/
│   └── Customer_Churn_Dashboard.pbix
│
├── Streamlit/
│   ├── app.py
│   └── README.md
│
├── Screenshots/
│   ├── dashboard_overview.png
│   ├── prediction_insights.png
│   ├── retention_strategy.png
│   ├── model_evaluation.png
│   ├── mlflow_experiment.png
│   └── lime_explanation.png
│
└── docs/
    ├── Internship_Report.pdf
    └── Project_Presentation.pptx
```

---

# 🔐 18. GitHub / Security Checklist

Do not commit sensitive information to GitHub.

Avoid uploading:

- Database passwords
- API keys
- Access tokens
- `.env` files
- Personal credentials
- Local machine configuration
- MLflow temporary files
- Python cache files
- Unnecessary large files
- Duplicate or failed notebooks

Example `.gitignore`:

```gitignore
# Python
__pycache__/
*.pyc
.ipynb_checkpoints/

# Virtual environments
venv/
.venv/
env/

# Secrets
.env
*.env

# MLflow
mlruns/

# IDE
.vscode/

# OS
.DS_Store
Thumbs.db
```

---

# 📌 19. Key Findings

The exploratory analysis identified the following patterns in the 7,043-customer dataset:

- Overall observed churn rate was **26.54%**.
- Month-to-month customers had a **42.71%** churn rate.
- Customers with 0–12 months of tenure had a **47.44%** churn rate.
- Fiber optic customers had a **41.89%** churn rate.
- Customers in the high-charge category had a **35.48%** churn rate.
- Churn rates varied across contract, tenure, internet service, and charge categories.

These findings describe associations in the dataset and can be used as areas for further business investigation.

---

# 📈 20. Final Project Results

The completed workflow produced:

```text
Total source customers       : 7,043
Training customers            : 5,634
Test/prediction customers     : 1,409

Test predicted churn          : 458
High-risk customers           : 248

Final prediction columns      : 9
Missing values in final data  : 0
```

### Final Prediction File

```text
ChurnPredictions_Final.csv
```

The final file contains customer-level prediction, risk, and retention-strategy information for the 1,409 test/prediction records.

---

# 🚀 21. Optional Streamlit Application

A Streamlit application can be used to provide an interactive prediction interface.

Example workflow:

```text
Customer Details
      ↓
Streamlit Input Form
      ↓
Saved ML Pipeline / Model
      ↓
Churn Probability
      ↓
Risk Category
```

Example output:

```text
Churn Probability: 78.4%
Predicted Churn: Yes
Risk Category: High Risk
```

The Streamlit component is an optional deployment layer and is separate from the core SQL → ML → Power BI workflow.

---

# 🐳 22. Optional Docker Deployment

The Streamlit application can also be containerized:

```text
Python Model
      ↓
Streamlit App
      ↓
Docker Image
      ↓
Docker Container
      ↓
Web Application
```

Docker can provide a consistent environment for running the application across different machines.

---

# 📚 23. Learning Outcomes

Through this project, I gained practical experience in:

- SQL data preparation
- SQL-based EDA
- Python data processing
- Pandas and NumPy
- Feature engineering
- Machine learning
- Class imbalance handling with SMOTE
- Model evaluation
- MLflow experiment tracking
- Model explainability using LIME
- Power BI dashboard development
- DAX-based business metrics
- Customer risk classification
- Retention strategy design
- End-to-end machine learning workflow
- Technical documentation
- GitHub project organization

---

# 🎤 24. Interview / Presentation Summary

### Business Problem

The goal is to identify customers who may churn and provide useful information that can support retention planning.

### Technical Solution

```text
SQL Server
→ Python
→ Feature Engineering
→ SMOTE
→ ML Models
→ Evaluation
→ MLflow
→ LIME
→ Predictions
→ Retention Strategy
→ Power BI
```

### Model

The downstream prediction workflow uses Logistic Regression with:

```text
Precision : 0.5524
Recall    : 0.6765
F1-score  : 0.6082
```

### Independent Extension

The project was extended with a **Retention Strategy Recommendation** layer that converts predicted risk and customer characteristics into business-oriented retention actions.

### Important Explanation

```text
ML Model
    ↓
Predicts churn probability / churn status
    ↓
Risk Category
    ↓
Business Rules
    ↓
Retention Strategy
```

The retention strategy is therefore a separate business-rule layer; it is not presented as a direct output of the machine learning model.

---

# 👨‍💻 Author

**Madhan**

Bachelor of Engineering / Technology in Computer Science and Engineering

---

# ⭐ Project Summary

This project demonstrates a complete end-to-end customer churn analytics and prediction solution.

```text
Raw Data
   ↓
SQL Cleaning & EDA
   ↓
Python Processing
   ↓
Feature Engineering
   ↓
SMOTE
   ↓
Machine Learning
   ↓
Model Evaluation
   ↓
MLflow Tracking
   ↓
LIME Explainability
   ↓
Customer Predictions
   ↓
Risk Classification
   ↓
Retention Strategy
   ↓
Power BI Dashboard
```

The project combines **data engineering, data analysis, machine learning, explainable AI, business intelligence, and business-oriented retention planning** into a single workflow.
