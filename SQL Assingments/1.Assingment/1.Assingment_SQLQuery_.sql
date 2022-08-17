CREATE DATABASE Manifacturer;

Use Manifacturer;

CREATE TABLE product(
    prod_id int primary key IDENTITY(1,1) not null,
    prod_name VARCHAR(50) null,
    quantity int null
)

CREATE TABLE component(
    comp_id int primary key IDENTITY(1,1) not null,
    comp_name VARCHAR(50) null,
    [description] VARCHAR(50) null,
    quantity_comp int null
)

CREATE TABLE supplier(
    supp_id int IDENTITY(1,1) not null,
    supp_name VARCHAR(50) null,
    supp_location VARCHAR(50) null,
    supp_country VARCHAR(50) null,
    is_active bit null,

    primary key(supp_id)
)

CREATE TABLE Prod_Comp(
    prod_id int IDENTITY(1,1) not null,
    comp_id int not null,
    quantity_comp int null,

    primary key (prod_id,comp_id),

    FOREIGN KEY (prod_id) REFERENCES product (prod_id),
    FOREIGN KEY (comp_id) REFERENCES component (comp_id)
)

CREATE TABLE comp_supp(
    supp_id int IDENTITY(1,1) not null,
    comp_id int not null,
    order_date date null,
    quantity int null,

    primary key (supp_id,comp_id),

    FOREIGN KEY (supp_id) REFERENCES supplier (supp_id),
    FOREIGN KEY (comp_id) REFERENCES component (comp_id)
)




DROP TABLE IF EXISTS prod_comp;
DROP TABLE IF EXISTS comp_supp;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS component;







