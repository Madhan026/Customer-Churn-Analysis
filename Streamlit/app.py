import os
import joblib
import numpy as np
import pandas as pd
import streamlit as st

st.set_page_config(
    page_title="Customer Churn Predictor",
    page_icon="📊",
    layout="wide"
)

MODEL_PATH = os.path.join(os.path.dirname(__file__), "churn_pipeline.pkl")

@st.cache_resource
def load_model():
    return joblib.load(MODEL_PATH)

def yes_no(label, default="No"):
    return st.selectbox(label, ["No", "Yes"], index=0 if default == "No" else 1)

def make_raw_input():
    with st.sidebar:
        st.header("Customer Details")

        senior = st.selectbox("Senior Citizen", [0, 1], index=0)
        partner = yes_no("Partner")
        dependents = yes_no("Dependents")

        tenure = st.number_input(
            "Tenure (months)", min_value=0, max_value=100, value=12, step=1
        )

        phone = yes_no("Phone Service", "Yes")
        multiple = st.selectbox(
            "Multiple Lines",
            ["No", "Yes", "No phone service"]
        )

        internet = st.selectbox(
            "Internet Service",
            ["DSL", "Fiber optic", "No"]
        )

        online_security = st.selectbox(
            "Online Security",
            ["No", "Yes", "No internet service"]
        )
        online_backup = st.selectbox(
            "Online Backup",
            ["No", "Yes", "No internet service"]
        )
        device_protection = st.selectbox(
            "Device Protection",
            ["No", "Yes", "No internet service"]
        )
        tech_support = st.selectbox(
            "Tech Support",
            ["No", "Yes", "No internet service"]
        )
        streaming_tv = st.selectbox(
            "Streaming TV",
            ["No", "Yes", "No internet service"]
        )
        streaming_movies = st.selectbox(
            "Streaming Movies",
            ["No", "Yes", "No internet service"]
        )

        contract = st.selectbox(
            "Contract",
            ["Month-to-month", "One year", "Two year"]
        )

        paperless = yes_no("Paperless Billing", "Yes")

        payment = st.selectbox(
            "Payment Method",
            [
                "Electronic check",
                "Mailed check",
                "Bank transfer (automatic)",
                "Credit card (automatic)"
            ]
        )

        monthly = st.number_input(
            "Monthly Charges",
            min_value=0.0,
            max_value=500.0,
            value=70.0,
            step=0.01
        )

        total = st.number_input(
            "Total Charges",
            min_value=0.0,
            max_value=100000.0,
            value=float(monthly * max(tenure, 1)),
            step=0.01
        )

    return pd.DataFrame([{
        "SeniorCitizen": senior,
        "Partner": partner,
        "Dependents": dependents,
        "tenure": tenure,
        "PhoneService": phone,
        "MultipleLines": multiple,
        "InternetService": internet,
        "OnlineSecurity": online_security,
        "OnlineBackup": online_backup,
        "DeviceProtection": device_protection,
        "TechSupport": tech_support,
        "StreamingTV": streaming_tv,
        "StreamingMovies": streaming_movies,
        "Contract": contract,
        "PaperlessBilling": paperless,
        "PaymentMethod": payment,
        "MonthlyCharges": monthly,
        "TotalCharges": total,
    }])

EXPECTED_FEATURES = [
    "SeniorCitizen", "Partner", "Dependents", "tenure", "PhoneService",
    "PaperlessBilling", "MonthlyCharges", "TotalCharges",
    "MultipleLines_No phone service", "MultipleLines_Yes",
    "InternetService_Fiber optic", "InternetService_No",
    "OnlineSecurity_No internet service", "OnlineSecurity_Yes",
    "OnlineBackup_No internet service", "OnlineBackup_Yes",
    "DeviceProtection_No internet service", "DeviceProtection_Yes",
    "TechSupport_No internet service", "TechSupport_Yes",
    "StreamingTV_No internet service", "StreamingTV_Yes",
    "StreamingMovies_No internet service", "StreamingMovies_Yes",
    "Contract_One year", "Contract_Two year",
    "PaymentMethod_Credit card (automatic)",
    "PaymentMethod_Electronic check", "PaymentMethod_Mailed check",
    "TotalServicesUsed", "AvgMonthlySpend"
]

def build_engineered_features(raw):
    df = raw.copy()

    yes_no = [
        "Partner", "Dependents", "PhoneService", "PaperlessBilling"
    ]
    for col in yes_no:
        df[col] = (df[col] == "Yes").astype(int)

    cat_cols = [
        "MultipleLines", "InternetService", "OnlineSecurity",
        "OnlineBackup", "DeviceProtection", "TechSupport",
        "StreamingTV", "StreamingMovies", "Contract", "PaymentMethod"
    ]

    df = pd.get_dummies(df, columns=cat_cols, drop_first=True, dtype=int)

    # Same engineered features used in the project notebook.
    df["TotalServicesUsed"] = (
        df["PhoneService"]
        + df.get("MultipleLines_Yes", 0)
        + (1 - df.get("InternetService_No", 0))
        + df.get("OnlineSecurity_Yes", 0)
        + df.get("OnlineBackup_Yes", 0)
        + df.get("DeviceProtection_Yes", 0)
        + df.get("TechSupport_Yes", 0)
        + df.get("StreamingTV_Yes", 0)
        + df.get("StreamingMovies_Yes", 0)
    )

    df["AvgMonthlySpend"] = np.where(
        df["tenure"] > 0,
        df["TotalCharges"] / df["tenure"],
        df["MonthlyCharges"]
    )

    # Match the feature order used for the model.
    for col in EXPECTED_FEATURES:
        if col not in df.columns:
            df[col] = 0

    return df[EXPECTED_FEATURES].astype(float)

def predict(model, raw):
    # First try the saved object as a complete preprocessing pipeline.
    try:
        proba = float(model.predict_proba(raw)[0, 1])
        pred = int(model.predict(raw)[0])
        return proba, pred, "pipeline"
    except Exception:
        pass

    # Fallback for a saved classifier trained on the 31 engineered features.
    engineered = build_engineered_features(raw)

    if hasattr(model, "feature_names_in_"):
        names = list(model.feature_names_in_)
        for col in names:
            if col not in engineered.columns:
                engineered[col] = 0
        engineered = engineered[names]

    proba = float(model.predict_proba(engineered)[0, 1])
    pred = int(model.predict(engineered)[0])
    return proba, pred, "engineered"

st.title("📊 Customer Churn Prediction")
st.caption("Telco Customer Churn — Streamlit Live Prediction Demo")

st.markdown(
    "Enter customer details in the left panel and click **Predict Churn** "
    "to calculate the model's churn probability."
)

raw = make_raw_input()

col1, col2 = st.columns([1, 1])

with col1:
    st.subheader("Customer Input")
    st.dataframe(raw, use_container_width=True, hide_index=True)

with col2:
    st.subheader("Prediction")

    if st.button("🔮 Predict Churn", type="primary", use_container_width=True):
        try:
            model = load_model()
            probability, prediction, mode = predict(model, raw)

            st.metric("Churn Probability", f"{probability:.2%}")

            if prediction == 1:
                st.error("⚠️ Predicted Churn: YES")
            else:
                st.success("✅ Predicted Churn: NO")

            if probability >= 0.70:
                risk = "High Risk"
            elif probability >= 0.40:
                risk = "Medium Risk"
            else:
                risk = "Low Risk"

            st.info(f"Risk Category: **{risk}**")
            st.caption(f"Prediction mode: {mode}")

        except FileNotFoundError:
            st.error(
                "churn_pipeline.pkl was not found. "
                "Place the Task 17 model file beside app.py."
            )
        except Exception as e:
            st.error(f"Prediction failed: {e}")

st.divider()
st.caption("Customer Churn Analysis & Prediction | SQL → Python → ML → Power BI")
