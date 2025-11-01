SELECT Customers.CustomerName, Invoices.InvoiceID, SUM(InvoiceDetails.LineTotal) AS LineSum
    FROM InvoiceDetails
    INNER JOIN Invoices ON InvoiceDetails.InvoiceID = Invoices.InvoiceID
    INNER JOIN Customers ON InvoiceDetails.InvoiceID = Customers.CustomerID
    GROUP BY InvoiceID 
    ORDER BY LineSum DESC;