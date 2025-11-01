SELECT Invoices.InvoiceID, Customers.CustomerName, CURDATE() AS Date, Invoices.TotalDue,
    Customers.City, Customers.State
    FROM Customers
    INNER JOIN Invoices ON Customers.CustomerID = Invoices.CustomerID
    WHERE Invoices.InvoiceID = 3;