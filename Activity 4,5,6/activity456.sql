CREATE TABLE Customers(
    CustomerID int NOT NULL AUTO_INCREMENT,
    CustomerName VARCHAR(50),
    AddressLine1 VARCHAR(50),
    AddressLine2 VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    PostalCode VARCHAR(50),
    YTDPurchases decimal(19, 2),
    PRIMARY KEY(CustomerID)
);
INSERT INTO Customers (CustomerName, AddressLine1, City, State, PostalCode)
Values ('Bike World', '60025 Bollinger Canyon Road', 'San Ramon', 'California', '94583'),
('Metro Sports', '482505 Warm Springs Blvd.', 'Fremont', 'California', '94536'),
('Guy Person', '55533 Nowhere Street', 'Boise', 'Idaho', '97562');

CREATE Table TermsCode(
    TermsCodeID VARCHAR(50) NOT NULL,
    Description VARCHAR(50),
    PRIMARY KEY (TermsCodeID)
);
INSERT INTO TermsCode (TermsCodeID, Description)
Values ('NET30', 'Payment due in 30 days.'),
('NET15', 'Payment due in 15 days.'),
('210NET30', '2% discount in 10 days NET 30');

CREATE Table Invoices (
    InvoiceID int NOT NULL AUTO_INCREMENT,
    CustomerID int,
    InvoiceDate datetime,
    TermsCodeID VARCHAR(50),
    TotalDue decimal(19, 2),
    PRIMARY KEY (InvoiceID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TermsCodeID) REFERENCES TermsCode(TermsCodeID)
);
INSERT INTO Invoices(CustomerID, InvoiceDate, TotalDue, TermsCodeID)
Values (2, '2014-02-07', 2388.98, 'NET30'),
(1, '2014-02-02', 2443.35, '210NET30'),
(1, '2014-02-09', 8752.32, 'NET30');