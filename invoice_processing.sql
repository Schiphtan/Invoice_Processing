SET SERVEROUTPUT ON;

DECLARE
    -- 1. DEFINE THE RECORD TYPE [cite: 223]
    -- We define a custom record to hold heterogeneous data (ID, Vendor Name, Amount)
    TYPE InvoiceRec IS RECORD (
        inv_id       NUMBER,
        vendor_name  VARCHAR2(50),
        amount       NUMBER
    );

    -- 2. DEFINE THE COLLECTION TYPE [cite: 149]
    -- We use a Nested Table because the batch size could be dynamic/resizable.
    -- It holds elements of the 'InvoiceRec' type defined above.
    TYPE InvoiceBatch IS TABLE OF InvoiceRec;

    -- 3. INITIALIZE THE VARIABLE
    -- Initialize the collection immediately so we can add data to it.
    v_invoices InvoiceBatch := InvoiceBatch();

    -- Variable to simulate a "Blacklisted Vendor" for our logic check
    v_blacklisted_vendor VARCHAR2(50) := 'Shady Corp';

BEGIN
    -- 4. POPULATE DATA
    -- We use the EXTEND method to allocate space for 4 rows.
    v_invoices.EXTEND(4);

    -- Record 1: Normal Transaction
    v_invoices(1).inv_id := 101; 
    v_invoices(1).vendor_name := 'Alpha Supplies'; 
    v_invoices(1).amount := 5000;

    -- Record 2: Blacklisted Vendor (Will trigger GOTO)
    v_invoices(2).inv_id := 102; 
    v_invoices(2).vendor_name := 'Shady Corp'; 
    v_invoices(2).amount := 12000;

    -- Record 3: Negative Amount (Will trigger GOTO)
    v_invoices(3).inv_id := 103; 
    v_invoices(3).vendor_name := 'Beta Services'; 
    v_invoices(3).amount := -500;

    -- Record 4: Normal Transaction
    v_invoices(4).inv_id := 104; 
    v_invoices(4).vendor_name := 'Gamma Logistics'; 
    v_invoices(4).amount := 3500;

    -- 5. PROCESS THE BATCH
    DBMS_OUTPUT.PUT_LINE('--- Starting Invoice Batch Processing ---');

    -- Loop through the collection using the index [cite: 161]
    FOR i IN 1 .. v_invoices.COUNT LOOP
        
        DBMS_OUTPUT.PUT_LINE('Checking Invoice ID: ' || v_invoices(i).inv_id);

        -- CHECK 1: Is the vendor blacklisted?
        IF v_invoices(i).vendor_name = v_blacklisted_vendor THEN
            DBMS_OUTPUT.PUT_LINE('   -> WARNING: Vendor match found in blacklist.');
            -- Jump to the error handler label
            GOTO handler_security_risk;
        END IF;

        -- CHECK 2: Is the amount valid?
        IF v_invoices(i).amount < 0 THEN
            DBMS_OUTPUT.PUT_LINE('   -> WARNING: Invalid negative amount detected.');
            -- Jump to the error handler label
            GOTO handler_data_error;
        END IF;

        -- NORMAL PROCESSING
        DBMS_OUTPUT.PUT_LINE('   -> Success: Payment approved for ' || v_invoices(i).vendor_name);
        
        -- Jump to the end of the loop to skip the error handlers below
        GOTO next_iteration;

        -----------------------------------------------------
        -- ERROR HANDLERS (Labels for GOTO)
        -----------------------------------------------------
        
        <<handler_security_risk>>
        DBMS_OUTPUT.PUT_LINE('   *** ACTION: Invoice ' || v_invoices(i).inv_id || ' flagged for Security Audit. ***');
        GOTO next_iteration; -- Resume loop
        
        <<handler_data_error>>
        DBMS_OUTPUT.PUT_LINE('   *** ACTION: Invoice ' || v_invoices(i).inv_id || ' rejected. Data correction required. ***');
        GOTO next_iteration; -- Resume loop

        -- Label to skip to the next iteration
        <<next_iteration>>
        NULL; -- Placeholder executable statement required by PL/SQL

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Batch Processing Completed ---');

EXCEPTION
    -- Standard exception handling [cite: 300]
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('System Error: ' || SQLERRM);
END;
/