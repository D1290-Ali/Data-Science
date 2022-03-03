CREATE DATABASE Manufacturer;
-- USE Manufacturer;

-- create tables​
CREATE TABLE Product
(
    prod_id int NOT NULL PRIMARY KEY,
    prod_name VARCHAR(50) NOT NULL,
	quantity int NOT NULL,
);


CREATE TABLE Supplier
(
    supp_id int NOT NULL PRIMARY KEY,
    supp_name VARCHAR(50) NOT NULL,
	supp_location VARCHAR(50) NOT NULL,
	supp_country VARCHAR(50) NOT NULL,
	is_active BIT
);


CREATE TABLE Component
(
    comp_id int NOT NULL PRIMARY KEY,
    comp_name VARCHAR(50) NOT NULL,
	description VARCHAR(50) NOT NULL,
	quantity_comp int NOT NULL,
);


CREATE TABLE Prod_Comp
(
    prod_id int NOT NULL,
    comp_id int NOT NULL,
	quantity_comp int NOT NULL,

	CONSTRAINT Prod_Comp_pk 
        PRIMARY KEY(prod_id, comp_id),
    CONSTRAINT Prod_Comp_Product_fk 
        FOREIGN KEY(prod_id) REFERENCES Product(prod_id),
    CONSTRAINT Prod_Comp_Component_fk 
        FOREIGN KEY(comp_id) REFERENCES Component(comp_id)
);


CREATE TABLE Comp_Supp
(
    supp_id int NOT NULL,
    comp_id int NOT NULL,
	order_date DATE NOT NULL,
	quantity int NOT NULL,

	CONSTRAINT Comp_Supp_pk 
        PRIMARY KEY(supp_id, comp_id),
    CONSTRAINT Comp_Supp_Supplier_fk 
        FOREIGN KEY(supp_id) REFERENCES Supplier(supp_id),
    CONSTRAINT Comp_Supp_Component_fk 
        FOREIGN KEY(comp_id) REFERENCES Component(comp_id)
);