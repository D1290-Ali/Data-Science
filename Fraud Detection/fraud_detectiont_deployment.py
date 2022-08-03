from distutils.log import warn
import streamlit as st
import pickle
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from PIL import Imageimport base64

st.sidebar.title('Transaction Input')

html_temp = """
<div style="background-color:Blue;padding:10px">
<h2 style="color:white;text-align:center;">Credit Card Fraud Detection</h2>
</div><br><br>"""

st.markdown(html_temp,unsafe_allow_html=True)
selection = st.selectbox("Select Your Model", ["Logistic Regression", "Random Forest", "XGBoost"])
st.markdown("<h1 style="text-align: center; color: Black;">Select Your Model</h1>" html_temp,unsafe_allow_html=True)


if selection =="Logistic Regression":
	st.write("You selected", selection, "model")
	model = pickle.load(open('logreg', 'rb'))
elif selection =="Random Forest":
	st.write("You selected", selection, "model")
	model = pickle.load(open('ranfor', 'rb'))
else:
	st.write("You selected", selection, "model")
	model = pickle.load(open('XG', 'rb'))

V2 = st.sidebar.slider(label="V2-PCA", min_value=10.00, max_value=15.0, step=0.01)
V3 = st.sidebar.slider(label="V2-PCA", min_value=-25.00, max_value=5.0, step=0.01)
V4 = st.sidebar.slider(label="V2-PCA", min_value=-5.00, max_value=15.0, step=0.01)
V7 = st.sidebar.slider(label="V2-PCA", min_value=-45.00, max_value=130.0, step=0.01)
V10 = st.sidebar.slider(label="V2-PCA", min_value=-20.00, max_value=5.0, step=0.01)
V11 = st.sidebar.slider(label="V2-PCA", min_value=-5.00, max_value=15.0, step=0.01)
V12 = st.sidebar.slider(label="V2-PCA", min_value=-20.00, max_value=5.0, step=0.01)
V14 = st.sidebar.slider(label="V2-PCA", min_value=-20.00, max_value=5.0, step=0.01)
V16 = st.sidebar.slider(label="V2-PCA", min_value=-15.00, max_value=20.0, step=0.01)
V17 = st.sidebar.slider(label="V2-PCA", min_value=-30.00, max_value=10.0, step=0.01)


coll_dict = {'V2':v2, 'V3':v3, 'V4':v4, 'V7':v7, 'V10':v10, 'V11':v11, 'V12':v12, 'V14':v14, 'V16':v16, 'V17':v17}
columns = ["v2", "v3", "v4", "v7", "v10", "v11", "v12", "v14", "v16", "v17"]

df_coll = pd.DataFrame.from_dict([coll_dict])

user_inputs= df_coll

prediction = model.predict(user_inputs)

html_temp = """
<div style="background-color:Black;padding:10px">
<h2 style="color:white;text-align:center;">Credit Card Fraud Detection Prediction</h2>

</div><br><br>"""

st.markdown("<h1 style="text-align: center; color: Black;">Transaction Information</h1>" html_temp,unsafe_allow_html=True)

st.table(df_coll)

st.subheader("Click PREDICT if configuration is OK")

if st.button("PREDICT"):
    if prediction[0]==0:
        st.success(prediction[0])
        st.success(f"Transaction is SAFE  :)")
    elif prediction[0] == 1:
        st.warning(prediction[0])
        st.warning(f'ALARM! Transaction is FRAUDULENT  :(')