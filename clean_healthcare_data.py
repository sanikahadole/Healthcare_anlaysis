import pandas as pd

# 1. Load (utf-8-sig removes the hidden BOM character at the start of the file)
df = pd.read_csv("Kaggle dataset.csv", encoding="utf-8-sig")
print("Rows before cleaning:", len(df))

# 2. Column names -> lowercase_with_underscores (no spaces, safe for SQL)
df.columns = (
    df.columns.str.strip()
    .str.lower()
    .str.replace(" ", "_")
)

# 3. Fix text: remove extra spaces, fix messy capitalisation in names
df["name"] = df["name"].str.strip().str.title()
df["doctor"] = df["doctor"].str.strip()

# 4. Hospital: remove commas (e.g. "Hernandez Rogers and Vang,")
df["hospital"] = (
    df["hospital"]
    .str.replace(",", "", regex=False)
    .str.strip()
)

# 5. Dates: dd-mm-yyyy -> yyyy-mm-dd (the only format MySQL DATE accepts)
df["date_of_admission"] = pd.to_datetime(df["date_of_admission"], format="%d-%m-%Y")
df["discharge_date"] = pd.to_datetime(df["discharge_date"], format="%d-%m-%Y")
df["date_of_admission"] = df["date_of_admission"].dt.strftime("%Y-%m-%d")
df["discharge_date"] = df["discharge_date"].dt.strftime("%Y-%m-%d")

# 6. Billing: round to 2 decimals, drop negative (invalid) amounts
df["billing_amount"] = df["billing_amount"].round(2)
negative_rows = (df["billing_amount"] < 0).sum()
df = df[df["billing_amount"] >= 0]
print("Negative billing rows removed:", negative_rows)

# 7. Missing values and duplicates (none found, but kept so the script is reusable)
df = df.dropna()
df = df.drop_duplicates()

# 8. Add a primary key column
df = df.reset_index(drop=True)
df.insert(0, "patient_id", df.index + 1)

print("Rows after cleaning:", len(df))

# 9. Save: plain UTF-8 (no BOM), quotes around text fields
df.to_csv("healthcare_cleaned.csv", index=False, encoding="utf-8", lineterminator="\n")
print("Saved healthcare_cleaned.csv")
