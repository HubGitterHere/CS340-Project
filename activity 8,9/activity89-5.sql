SELECT Products.ProductNumber, Products.ProductName, InvoiceDetails.LineTotal, 
    InvoiceDetails.OrderQty, InvoiceDetails.UnitPrice
    FROM InvoiceDetails
    INNER JOIN Products ON InvoiceDetails.ProductNumber = Products.ProductNumber
    WHERE InvoiceDetails.InvoiceID = 3;