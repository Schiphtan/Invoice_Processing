# PL/SQL Project: High-Value Invoice Processing System

**Course:** Database Development with PL/SQL  
**Assignment:** Collections, Records, and Control Structures  
**Student Name:** TUYUMVIRE Schiphtan  
**Student ID:** 25711 

## 📌 Project Overview
This project simulates a batch processing system for a Finance Department. The goal is to process a list of invoices efficiently while automatically flagging security risks (blacklisted vendors) and data errors (negative amounts) using specific PL/SQL control structures.

The solution demonstrates the integration of **User-Defined Records**, **Nested Table Collections**, and **GOTO statements** for exception branching.

## 🛠 Technical Implementation

Based on the course material regarding composite data types[cite: 23], this project utilizes:

### 1. User-Defined Records
* **Definition:** A record is a group of related fields that can store different data types[cite: 185].
* **Usage:** I created a custom record type `InvoiceRec` to group heterogeneous data: Invoice ID (`NUMBER`), Vendor Name (`VARCHAR2`), and Amount (`NUMBER`)[cite: 188].

### 2. PL/SQL Collections (Nested Tables)
* **Definition:** A collection holds multiple elements of the same type[cite: 27].
* **Usage:** I used a **Nested Table** (`InvoiceBatch`) to store the records.
* **Reasoning:** Unlike VARRAYs, which have a fixed upper bound [cite: 76][cite_start], Nested Tables are dynamically resizable[cite: 145]. This allows the batch size to grow or shrink based on the number of invoices received.

### 3. Control Structures (GOTO)
* **Usage:** The `GOTO` statement is used to handle "Blacklisted Vendors" and "Invalid Amounts."
* **Logic:** Instead of deeply nested `IF/ELSE` blocks, the system detects an error and immediately jumps to a specific label (`<<handler_security_risk>>` or `<<handler_data_error>>`) to log the issue, ensuring the main processing loop remains clean.

## 📂 File Structure
* `invoice_processing.sql`: The main PL/SQL script containing the logic.
* `README.md`: Project documentation and execution evidence.
* `screenshots/`: Folder containing proof of execution.

## 🚀 How to Run
1.  Open **Oracle SQL Developer** or **SQL*Plus**.
2.  Ensure `SERVEROUTPUT` is enabled:
    ```sql
    SET SERVEROUTPUT ON;
    ```
3.  Copy and paste the script from `invoice_processing.sql` into the worksheet.
4.  Run the script (F5).

## 📊 Execution Results
*See the `screenshots` folder for full evidence.*

**Scenario Logic:**
1.  **Invoice 101:** Standard transaction -> **Approved**.
2.  **Invoice 102:** "Shady Corp" detected -> **GOTO Security Label** -> Flagged.
3.  **Invoice 103:** Negative Amount detected -> **GOTO Error Label** -> Rejected.
4.  **Invoice 104:** Standard transaction -> **Approved**.

![Execution Output](screenshots/output.png)
