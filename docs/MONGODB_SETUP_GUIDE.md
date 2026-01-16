### **MongoDB Setup Guide**

1.  **Sign Up**
    *   Go to [**mongodb.com/atlas**](https://www.mongodb.com/atlas) and create a free account.

2.  **Create Project**
    *   Log in → Click **New Project** (top-left menu).[5]
    *   Name it and click **Create Project**.

3.  **Create Cluster**
    *   Click **Build a Database** → Select **M0 Free** (Shared).[1][5]
    *   Choose a provider (AWS/Google) and region → Click **Create**.

4.  **Add User**
    *   Go to **Database Access** (left sidebar) → Click **Add New Database User**.[5]
    *   Set **Username** & **Password** (make sure to copy the password!).
    *   Click **Add User**.

5.  **Get Connection URI**
    *   Go to **Database** (left sidebar) → Click **Connect** on your cluster.[5]
    *   Select **Drivers** (e.g., Node.js, Python).
    *   Copy the connection string provided. It will look like this:
        `mongodb+srv://<username>:<password>@cluster0.4zyhmbo.mongodb.net/?appName=Cluster0`

**To use it:** Replace `<username>` and `<password>` with the credentials you just created. Remove the `< >` brackets.