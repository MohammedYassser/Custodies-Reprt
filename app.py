from dotenv import load_dotenv
import os
import pyodbc
import streamlit as st
import pandas as pd

@st.cache_resource


env = {
    "server": os.getenv("DB_SERVER"),
    "database": os.getenv("DB_NAME"),
    "username": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "driver": os.getenv("DB_DRIVER"),
}

# Build connection string
conn_str = (
    f"DRIVER={env['driver']};"
    f"SERVER={env['server']};"
    f"DATABASE={env['database']};"
    f"UID={env['username']};"
    f"PWD={env['password']};"
    f"TrustServerCertificate=yes;"
)

st.set_page_config(
    page_title="Custodies Data Report",
    layout="wide",
)

st.title("Custodies Data Report")
st.write("Filter employees by Company ID and/or Employee IDs.")

st.sidebar.header("Filters")

company_id = st.sidebar.text_input("Company ID", value="1")

employee_ids_input = st.sidebar.text_input(
    "Employee IDs (comma separated)", value=""
)

if employee_ids_input.strip():
    employee_ids = employee_ids_input.strip()
else:
    employee_ids = None

def call_Custodies_Data(conn, person_ids, company_id):
    cursor = conn.cursor()
    cursor.execute(
        """
        exec Rpt_Personnel_Custodies_Data
        @Str_ID=?,
        @Org_IDs=?,
        @Company_ID=?,
        @Person_Inst_IDs=?,
        @Org_Type=?,
        @Business_Entity_ID=?,
        @WithChilds=?,
        @Employee_Status=?,
        @Financial_Company_IDs=?,
        @Custody_IDs=?
        """,
        (
            92,
            None,
            company_id,
            person_ids,
            None,
            1,
            0,
            None,
            None,
            None
        )
    )

    rows = cursor.fetchall()
    columns = [col[0] for col in cursor.description]

    df = pd.DataFrame.from_records(rows, columns=columns)
    return df

try:
    conn = pyodbc.connect(conn_str)
    print(employee_ids)
    res = call_Custodies_Data(conn, employee_ids, company_id)
    st.dataframe(res)
    conn.close()
except Exception as e:
    print("Connection failed:", e)

