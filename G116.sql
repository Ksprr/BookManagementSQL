    /*
    COURSE CODE: (UCCD2203 OR UCCD2303) 
    PROGRAMME (IA/IB/CS)/DE: IA
    GROUP NUMBER e.g. G001: G116
    GROUP LEADER NAME & EMAIL: WILSON CHUA WAI LUN / wilsonchua0521@1utar.my
    Submission date and time (DD-MON-YY): 5-MAY-24 9:00pm

    GROUP ASSIGNMENT SUBMISSION
    Submit one individual report With SQL statements only (*.docx)
    and one sql script (*.sql for Oracle)

    Template save as "G999.sql"  e.g. G001.sql
    Part 1 script only.
    Refer to the format of Northwoods.sql as an example for group sql script submission

    Your GROUP member information should appear in both files one individual report docx & one individual sql script, 
    then save as G01.zip

    */

    -- Alter session
    ALTER SESSION SET "_oracle_script" = true;

    -- Remove Tables

    drop table publisher cascade constraints;
    drop table genre cascade constraints;
    drop table author cascade constraints;
    drop table contributor cascade constraints;
    drop table book cascade constraints;
    drop table stock cascade constraints;
    drop table language cascade constraints;
    drop table restock cascade constraints;
    drop table price cascade constraints;
    drop table invoice cascade constraints;
    drop table sale cascade constraints;
    drop table customer cascade constraints;
    drop table membership cascade constraints;
    drop table reward cascade constraints;
    drop table redeemed cascade constraints;
    drop table branch cascade constraints;
    drop table employee cascade constraints;
    drop table manager cascade constraints;
    drop table executive cascade constraints;
    drop table job cascade constraints;
    drop table position cascade constraints;
    drop table project cascade constraints;
    drop table assignment cascade constraints;

    --Drop Role
    DROP ROLE Staff;
    DROP ROLE Manager;
    DROP ROLE Admin;



    ------------------------- Create Tables -------------------------

    --customer table
    CREATE TABLE customer
    (CustomerID NUMBER(5),
    FName VARCHAR2(20),
    LName VARCHAR2(20),
    Phone NUMBER(9),
    Street VARCHAR(30),
    Zip NUMBER(5),
    City VARCHAR(20),
    DOB DATE,
    CONSTRAINT customerr_CustomerID_pk PRIMARY KEY (CustomerID));

    --membership table
    CREATE TABLE membership
    (MembershipID NUMBER(4),
    CustomerID NUMBER(5),
    m_date DATE,
    discount NUMBER(2),
    point_in_acc NUMBER(5),
    CONSTRAINT membership_MembershipID_pk PRIMARY KEY (MembershipID),
    CONSTRAINT membership_CustomerID_fk FOREIGN KEY (CustomerID)REFERENCES customer(CustomerID));

    --reward table
    CREATE TABLE reward
    (RewardID NUMBER(3),
    RewardName VARCHAR2(20),
    RewardPoint_needed NUMBER(3),
    CONSTRAINT reward_RewardID_pk PRIMARY KEY (RewardID));

    --redeemed table
    CREATE TABLE redeemed
    (RewardID NUMBER(3),
    MembershipID NUMBER(5),
    r_Date DATE,
    CONSTRAINT redeemed_pk PRIMARY KEY(membershipID,rewardID),
    CONSTRAINT redeemed_MembershipID_fk FOREIGN KEY (MembershipID) REFERENCES membership(MembershipID),
    CONSTRAINT redeemed_RewardID_fk FOREIGN KEY (RewardID) REFERENCES reward(RewardID));

    --Publisher table
    create table PUBLISHER (
    PublisherID number(3) constraint publisher_publisherID_pk primary key,
    pubname varchar2(30),
    pubContact varchar2(50),
    pubEmail varchar2(50),
    pubStreetAddress varchar2(50),
    pubCity varchar2(20),
    pubState varchar2(20)
    );

    --Genre table
    create table genre(
    genreID number(2) constraints genre_genresID_pk primary key,
    genretype varchar2(30)
    );

    --Author table
    create table author(
    authorid number(3) constraints author_authorID_pk primary key,
    auFName varchar2(30),
    auLName varchar2(30)
    );


    --language table
    create table language(
    languageid number(3) constraints language_id_pk primary key,
    languagecode char(3) constraints language_code_length check (length(languagecode) = 3),
    languagename varchar2(30)
    );

    --Book table
    create table book(
    bookID number(4) constraints book_bookID_pk primary key,
    title varchar2(50),
    genreid number(2) constraints book_genreid_fk references genre(genreID),
    publisherID number(3) constraints book_publisherID_fk references publisheR(publisherID),
    version varchar(20),
    ISBN varchar2(13) constraints book_ISBN_ck check (length(ISBN) = 13), constraints ISBN_unique unique(ISBN),
    languageid number(3) constraints book_language_fk references language(languageid)
    );


    --contributor table
    create table contributor(
    bookid number(4),
    authorid number(3),
    constraint contributor_composite_pk primary key(bookid,authorid),
    constraint contributor_bookid_fk foreign key(bookid) references book(bookid),
    constraint contributor_authorid_fk foreign key(authorid) references author(authorid)
    );


    --price table

    create table price(
    priceID number(4) constraints price_priceID_pk primary key,
    bookid number(4) constraints price_bookid_fk references book(bookid),
    Pstart date default sysdate,
    bookprice number(6,2) constraints price_bookprice_neg check(bookprice>0),
    constraints price_bookID_PStart_unique unique(bookid,pstart)
    );

    --branch table
    CREATE TABLE Branch
    (Branch_id NUMBER(1) CONSTRAINT Branch_Branch_id_pk PRIMARY KEY,
    manager_id NUMBER(3),
    city VARCHAR2(20),
    zip NUMBER(5),
    street VARCHAR2(50),
    contact VARCHAR2(50)
    );

    --employee table
    CREATE TABLE Employee
    (Emp_id NUMBER(3) CONSTRAINT Employee_Emp_id_pk PRIMARY KEY,
    EFirst VARCHAR2(20),
    ELast VARCHAR2(20),
    DOB DATE,
    contact VARCHAR2(20),
    shifts VARCHAR2(5),
    manager_id NUMBER(3), CONSTRAINT Employee_manager_id_fk Foreign Key (manager_id) REFERENCES Employee(Emp_id),
    branch_id NUMBER(1), CONSTRAINT Employee_branch_id_fk Foreign Key (branch_id) REFERENCES Branch(branch_id)
    );
    
    ALTER TABLE Branch
    ADD CONSTRAINT Branch_manager_id FOREIGN KEY(manager_id) REFERENCES Employee(Emp_id);
    
    --manager table
    CREATE TABLE Manager
    (
    Emp_id NUMBER(3),
    bonus NUMBER(2),
    PRIMARY KEY (Emp_id),
    FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_id)
    );
    

    --executive table
    CREATE TABLE Executive
    (Emp_id NUMBER(3),
    project_quota_per_year NUMBER(1),
    PRIMARY KEY (Emp_id),
    FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_id)
    );
    
    
    --job table
    CREATE TABLE Job
    (
    job_id NUMBER(3) CONSTRAINT Job_job_id_pk PRIMARY KEY,
    job_title VARCHAR2(25),
    Basic_Salary NUMBER(5)
    );
    
    --position table
    CREATE TABLE Position
    (Emp_id NUMBER(3),
    job_id NUMBER(3),
    start_date DATE,
    end_date DATE,
    CONSTRAINT Employee_start_date_pk PRIMARY KEY (Emp_id, job_id, start_date),
    FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_id),
    FOREIGN KEY (job_id) REFERENCES job(job_id)
    );
    
    
    --project table
    CREATE TABLE Project
    (PID NUMBER(3) CONSTRAINT Projects_PID_pk PRIMARY KEY,
    PName VARCHAR2(50),
    SDate DATE,
    EDate DATE,
    Budget NUMBER(6)
    );
    

    --assignment table
    CREATE TABLE Assignment
    (Emp_id NUMBER(3),
    PID NUMBER(3),
    job_id NUMBER(3),
    job_scope VARCHAR2(100),
    CONSTRAINT Employee_Project_id_pk PRIMARY KEY (PID, Emp_id, job_id),
    FOREIGN KEY (PID) REFERENCES Project(PID),
    FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_id),
    FOREIGN KEY (job_id) REFERENCES job(job_id)
    );

    --stock table
    create table stock(
    bookid number(4),
    branch_id number(1),
    quantity number(5) default 0,
    constraint stock_composite_pk primary key(bookid,branch_id),
    constraint stock_bookid_fk foreign key(bookid) references book(bookid),
    constraint stock_branchid_fk foreign key(branch_id) references branch(branch_id),
    constraint stock_quantity_neg check(quantity>=0)
    ); 

    --restock table
    create table restock(
    restockID number(4) constraint restock_restockid_pk primary key,
    branch_id number(1) constraint restock_branch_id_fk references branch(branch_id),
    bookID number(4) constraint restock_bookid_fk references book(bookID),
    restockDate date default sysdate,
    restockQty number(4) constraint restock_quantity_neg check(restockQty >= 0),
    restockPrice number(8,2) constraint restock_price_neg check(restockPrice > 0)
    );


    --invoice table
    CREATE TABLE invoice
    (invoiceID NUMBER(5) CONSTRAINT invoice_invoice_id_pk PRIMARY KEY,
    staff_id NUMBER(3) CONSTRAINT invoice_staff_id_fk REFERENCES employee(emp_id),
    payment_date DATE);


    --sale table
    CREATE TABLE sale
    (saleID NUMBER(5),
    CustomerID NUMBER(5),
    InvoiceID NUMBER(5),
    bookid NUMBER(4),
    branch_id NUMBER(1),
    order_date DATE,
    quantity_purchased NUMBER(2),
    CONSTRAINT sale_saleID_pk PRIMARY KEY (saleID),
    CONSTRAINT sale_CustomerID_fk FOREIGN KEY(CustomerID) REFERENCES customer(CustomerID),
    CONSTRAINT sale_InvoiceID_fk FOREIGN KEY(InvoiceID) REFERENCES INVOICE(InvoiceID),
    CONSTRAINT sale_book_id_fk FOREIGN KEY(bookid) REFERENCES book(bookid),
    CONSTRAINT sale_branch_id_fk FOREIGN KEY(branch_id) REFERENCES branch(branch_id));

    ------------------------restock trigger-----------------------------------------

    create or replace trigger update_restock
    after insert 
    on restock
    for each row

    declare
    stockQTY number(4);

    begin
    select quantity into stockQTY from stock
    where bookid = :new.bookid and branch_Id= :new.branch_id;

    update stock
    set quantity = :new.restockQTY+stockQTY
    where bookid = :new.bookid and branch_Id= :new.branch_id;
    end;
    /

    --sales trigger
    create or replace trigger update_sales
    before insert
    on sale
    for each row

    declare
    stockQTY number(4);

    begin
    select quantity into stockQTY from stock
    where bookid = :new.bookid and branch_Id= :new.branch_id;

    update stock
    set quantity = stockQTY - :new.quantity_purchased
    where bookid = :new.bookid and branch_Id= :new.branch_id;

    end;
    /

    --edit restock trigger
    create or replace trigger edit_restock
    before update
    on restock
    for each row

    declare
    stockQTY number(4);

    begin
    select quantity into stockQTY from stock
    where bookid = :old.bookid and branch_Id= :old.branch_id;

    update stock
    set quantity = :new.restockQTY+stockQTY-:old.restockQty
    where bookid = :old.bookid and branch_Id= :old.branch_id;
    end;
    /

    --delete restock trigger
    create or replace trigger delete_restock
    before delete
    on restock
    for each row

    declare
    stockQTY number(4);

    begin
    select quantity into stockQTY from stock
    where bookid = :old.bookid and branch_Id= :old.branch_id;

    update stock
    set quantity = stockQTY-:old.restockQty
    where bookid = :old.bookid and branch_Id= :old.branch_id;
    end;
    /

    --edit sales trigger
    create or replace trigger edit_sales 
    before update
    on sale
    for each row

    declare
    stockQTY number(4);

    begin
    select quantity into stockQTY from stock
    where bookid = :old.bookid and branch_Id= :old.branch_id;

    update stock
    set quantity = stockQTY - :new.quantity_purchased + :old.quantity_purchased
    where bookid = :old.bookid and branch_Id= :old.branch_id;

    end;
    /

    --delete sales trigger
    create or replace trigger delete_sales 
    before delete
    on sale
    for each row

    declare
    stockQTY number(4);

    begin
    select quantity into stockQTY from stock
    where bookid = :old.bookid and branch_Id= :old.branch_id;

    update stock
    set quantity = stockQTY + :old.quantity_purchased
    where bookid = :old.bookid and branch_Id= :old.branch_id;

    end;
    /

    -----------------------Create Role--------------------------------------
    CREATE ROLE Staff;
    CREATE ROLE Manager;
    CREATE ROLE Admin;
    
    ----------------------Grant Session-----------------------------
    GRANT CREATE SESSION
    TO Staff;
    GRANT SELECT on Employee
    TO Staff;
    GRANT SELECT on Branch
    TO Staff;
    GRANT SELECT on Position
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on customer
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on membership
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on reward
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on redeemed
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on publisher
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on genre
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on author
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on language
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on book
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on contributor
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on price
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on stock
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on restock
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on invoice
    TO Staff;
    GRANT SELECT, INSERT, UPDATE on sale
    TO Staff;

    
    GRANT CREATE SESSION, CREATE TABLE
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Employee
    TO Manager;
    GRANT SELECT, UPDATE, ALTER on Branch
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Position
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Assignment
    TO Manager;
    GRANT SELECT, UPDATE on Project
    TO Manager;
    GRANT SELECT on Job
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on customer
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on membership
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on reward
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on redeemed
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on publisher
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on genre
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on author
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on language
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on book
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on contributor
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on price
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on stock
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on restock
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on invoice
    TO Manager;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT  on sale
    TO Manager;

    
    GRANT CREATE SESSION, CREATE TABLE, CREATE USER, CREATE ANY TABLE, DROP ANY TABLE, GRANT ANY PRIVILEGE
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Job
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Assignment
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Employee
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Branch
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on Position
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on customer
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on membership
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on reward
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on redeemed
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on publisher
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on genre
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on author
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on language
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on book
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on contributor
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on price
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on stock
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on restock
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on invoice
    TO Admin;
    GRANT SELECT, UPDATE, DELETE, ALTER, INSERT on sale
    TO Admin;
    -------------------------Insert Data----------------------------------
    INSERT INTO customer(customerid, fname, lname, phone, street, zip, city, dob)
    VALUES ('10001', 'John', 'Tan', 0103453645, '34 Jalan Batu', 31900, 'Kampar', to_date('23-4-1990', 'dd-mm-yyyy'));
    INSERT INTO customer(customerid, fname, lname, phone, street, zip, city, dob)
    VALUES ('10002', 'Peter', 'Tan', 0113549874, '86 Jalan Sinar', 31900, 'Kampar', to_date('12-3-1987', 'dd-mm-yyyy'));
    INSERT INTO customer(customerid, fname, lname, phone, street, zip, city, dob)
    VALUES ('10003', 'David', 'Khoo', 0167694387, '145 Jalan Sinar', 31900, 'Kampar', to_date('28-7-1994', 'dd-mm-yyyy'));
    INSERT INTO customer(customerid, fname, lname, phone, street, zip, city, dob)
    VALUES ('10004', 'Anson', 'Liew', 0194896386, '459 Lorong Mahsuri', 31900, 'Kampar', to_date('3-12-1999', 'dd-mm-yyyy'));
    INSERT INTO customer(customerid, fname, lname, phone, street, zip, city, dob)
    VALUES ('10005', 'Clare', 'Chia', 0102497503, '90 Jalan Timah', 31900, 'Kampar', to_date('18-2-1992', 'dd-mm-yyyy'));
    INSERT INTO customer(customerid, fname, lname, phone, street, zip, city, dob)
    VALUES ('10006', 'Matthew', 'Heng', 011863498, '542 Taman Meadow', 31900, 'Kampar', to_date('25-8-1995', 'dd-mm-yyyy'));

    --language record
    insert into language values(101,'ENG','English');
    insert into language values(102,'CHI','Chinese');
    insert into language values(103,'MAY','Malay');
    insert into language values(104,'TAM','Tamil');
    insert into language values(105,'JPN','Japanese');

    --insert publisher record
    insert into publisher values(101,'Penguin Random House','012-3567890','penguin@gmail.com','20,Taman Lari','Ipoh','Perak');
    insert into publisher values(102,'Hachette Livre','018-3560890','hachette@gmail.com','50,Taman Jalan','GeorgeTown','Penang');
    insert into publisher values(103,'HarperCollins','012-7777890','harpercollins@gmail.com','49,Taman Janggus Pena','Kampar','Perak');
    insert into publisher values(104,'Simon, and Schuster','012-3224440','simon@gmail.com','34,Jalan Bandar','Kuala Lumpur','Selangor');
    insert into publisher values(105,'Macmillan Publishers','012-3512390','macmillan@gmail.com','22,Jalan Sri Janggus','Bukit Mertajam','Penang');

    --insert genre type
    insert into genre values (11,'Fantasy');
    insert into genre values (12,'Mystery');
    insert into genre values (13,'Romance');
    insert into genre values (14,'Thriller');
    insert into genre values (15,'Inspirational');


    --insert author record
    insert into author values (101,'Nora','Bowers');
    insert into author values (102,'Cem','Dickinson');
    insert into author values (103,'Heena','Massey');
    insert into author values (104,'Christine','Lin');
    insert into author values (105,'James','Tucker');


    --insert book record
    insert into book values(1001,'Flowers for Algernon',12,102,'1.1.1','1234567899876',102);
    insert into book values(1002,'Classroom of Elite',11,101,'4.1.2','7832121391411',101);
    insert into book values(1003,'Stories of Algernon Blackwood',13,103,'2.1.4','7632152113341',103);
    insert into book values(1004,'Introduction to Java',13,103,'3.1.2','7863115213941',104);
    insert into book values(1005,'PYTHON IS THE BEST',11,101,'4.1.3.2','7861315213941',105);

    INSERT INTO branch
    values(1, null, 'PutraJaya', 62000, '69, Jalan Diplomatik', '010-1111338');
    INSERT INTO branch
    values(2, null, 'George Town', 10050, '201, Lebuh Carnarvon', '010-2222338');
    INSERT INTO branch
    values(3, null, 'Kuantan', 25000, '4042, Jalan Putra Square 3', '010-3333338');
    INSERT INTO branch
    values(4, null, 'Malacca City', 75100, '60-D, Jalan Bendahara', '010-4444338');
    INSERT INTO branch
    values(5, null, 'Johor Bahru', 79100, '153, Jalan Sutera', '010-5555338');
    INSERT INTO branch
    values(6, null, 'Kuching', 93000, '88, Pearl Street', '010-6666338');
    
    INSERT INTO Employee
    values(100, 'James', 'Potter', TO_DATE('31/10/1981', 'DD/MM/YYYY'), '012-2201204', 'Day', NULL, 1);
    INSERT INTO Employee
    values(101, 'Lily', 'Adams', TO_DATE('05/04/1989', 'DD/MM/YYYY'), '010-3889023', 'Night', 100, 2);
    INSERT INTO Employee
    values(102, 'George', 'Hawkins', TO_DATE('13/08/2000', 'DD/MM/YYYY'), '012-8492234', 'Day', 101, 2);
    INSERT INTO Employee
    values(103, 'Ali', 'Muhammad', TO_DATE('17/01/1976', 'DD/MM/YYYY'), '016-1192003', 'Night', 100, 3);
    INSERT INTO Employee
    values(104, 'Wilson', 'Chua', TO_DATE('15/08/1990', 'DD/MM/YYYY'), '011-2554323', 'Day', 103, 3);
    INSERT INTO Employee
    values(105, 'Johnny', 'Depp', TO_DATE('09/07/1963', 'DD/MM/YYYY'), '012-1043800', 'Day', 101, 2);
    INSERT INTO Employee
    values(106, 'Henry', 'Cavil', TO_DATE('05/05/1983', 'DD/MM/YYYY'), '016-9467298', 'Day', 101, 2);
    INSERT INTO Employee
    values(107, 'Chris', 'Evans', TO_DATE('13/06/1981', 'DD/MM/YYYY'), '011-3887687', 'Night', 100, 4);
    INSERT INTO Employee
    values(108, 'Elizibeth', 'Olsen', TO_DATE('16/02/1989', 'DD/MM/YYYY'), '010-4443201', 'Day', 100, 5);
    INSERT INTO Employee
    values(109, 'Matt', 'Damon', TO_DATE('08/10/1970', 'DD/MM/YYYY'), '012-5829530', 'Night', 100, 6);
    INSERT INTO Employee
    values(110, 'Harry', 'Williams', TO_DATE('09/11/1977', 'DD/MM/YYYY'), '011-2645204', 'Day', NULL, 1);
    
    INSERT INTO Manager
    values(100, 15);
    INSERT INTO Manager
    values(101, 5);
    INSERT INTO Manager
    values(103, 5);
    INSERT INTO Manager
    values(107, 10);
    INSERT INTO Manager
    values(108, 10);
    INSERT INTO Manager
    values(109, 5);
    
    INSERT INTO Executive
    values(100, 2);
    INSERT INTO Executive
    values(101, 1);
    
    UPDATE branch
    SET manager_id = 100
    WHERE branch_id = 1;
    UPDATE branch
    SET manager_id = 101
    WHERE branch_id = 2;
    UPDATE branch
    SET manager_id = 103
    WHERE branch_id = 3;
    UPDATE branch
    SET manager_id = 107
    WHERE branch_id = 4;
    UPDATE branch
    SET manager_id = 108
    WHERE branch_id = 5;
    UPDATE branch
    SET manager_id = 109
    WHERE branch_id = 6;
    
    INSERT INTO job
    values(200, 'CEO', '15000' );
    INSERT INTO job
    values(201, 'COO', '10000' );
    INSERT INTO job
    values(202, 'Secretary', '5500' );
    INSERT INTO job
    values(203, 'Operations Supervisor', '5000' );
    INSERT INTO job
    values(204, 'Accountant', '4000' );
    INSERT INTO job
    values(205, 'Clerk', '3500' );
    INSERT INTO job
    values(206, 'Publishing Sales', '3000' );
    INSERT INTO job
    values(207, 'Staff', '2000' );
    INSERT INTO job
    values(208, 'Logistics', NULL );
    INSERT INTO job
    values(209, 'Public Relation', NULL);
    INSERT INTO job
    values(210, 'Sponsorship', NULL);
    INSERT INTO job
    values(211, 'Programme', NULL);
    INSERT INTO job
    values(212, 'Treasurer', NULL);
    
    
    INSERT INTO position
    values(100, 200, TO_DATE('04/02/2012', 'DD/MM/YYYY'), NULL );
    INSERT INTO position
    values(101, 203, TO_DATE('18/04/2017', 'DD/MM/YYYY'), NULL );
    INSERT INTO position
    values(102, 206, TO_DATE('31/10/2020', 'DD/MM/YYYY'), NULL );
    INSERT INTO position
    values(103, 207, TO_DATE('02/02/2014', 'DD/MM/YYYY'), TO_DATE('07/11/2018', 'DD/MM/YYYY'));
    INSERT INTO position
    values(103, 203, TO_DATE('07/11/2018', 'DD/MM/YYYY'), NULL);
    INSERT INTO position
    values(104, 205, TO_DATE('23/08/2020', 'DD/MM/YYYY'), NULL );
    INSERT INTO position
    values(105, 204, TO_DATE('12/04/2013', 'DD/MM/YYYY'), NULL );
    INSERT INTO position
    values(106, 207, TO_DATE('09/10/2021', 'DD/MM/YYYY'), NULL );
    INSERT INTO position
    values(107, 206, TO_DATE('27/12/2012', 'DD/MM/YYYY'), TO_DATE('04/12/2016', 'DD/MM/YYYY'));
    INSERT INTO position
    values(107, 203, TO_DATE('04/12/2016', 'DD/MM/YYYY'), NULL);
    INSERT INTO position
    values(108, 207, TO_DATE('20/03/2017', 'DD/MM/YYYY'), TO_DATE('31/10/2021', 'DD/MM/YYYY'));
    INSERT INTO position
    values(108, 203, TO_DATE('31/10/2021', 'DD/MM/YYYY'), NULL);
    INSERT INTO position
    values(109, 203, TO_DATE('07/03/2017', 'DD/MM/YYYY'), NULL );
    INSERT INTO position
    values(110, 201, TO_DATE('01/06/2014', 'DD/MM/YYYY'), NULL );
    
    
    INSERT INTO project
    values(300, 'Launching Ceremony of Branch 4', TO_DATE('01/02/2018', 'DD/MM/YYYY'),TO_DATE('04/05/2018', 'DD/MM/YYYY'), 15000);
    INSERT INTO project
    values(301, 'Public Book Reading by: JK Rowling', TO_DATE('01/06/2018', 'DD/MM/YYYY'),TO_DATE('25/12/2018', 'DD/MM/YYYY'), 30000);
    INSERT INTO project
    values(302, 'Launching Ceremony of Branch 5', TO_DATE('01/02/2019', 'DD/MM/YYYY'),TO_DATE('01/06/2019', 'DD/MM/YYYY'), 15000);
    INSERT INTO project
    values(303, 'Public Book Reading by: Stephen King', TO_DATE('01/07/2019', 'DD/MM/YYYY'),TO_DATE('23/11/2019', 'DD/MM/YYYY'), 20000);
    INSERT INTO project
    values(304, 'Launching Ceremony of Branch 6', TO_DATE('01/02/2020', 'DD/MM/YYYY'),TO_DATE('05/05/2020', 'DD/MM/YYYY'), 15000);
    INSERT INTO project
    values(305, 'Public Book Reading by: Philip Roth', TO_DATE('01/06/2020', 'DD/MM/YYYY'),TO_DATE('12/10/2020', 'DD/MM/YYYY'), 23000);
    INSERT INTO project
    values(306, 'Short story writing competition for World Book day', TO_DATE('01/01/2021', 'DD/MM/YYYY'),TO_DATE('23/04/2021', 'DD/MM/YYYY'), 7000);
    INSERT INTO project
    values(307, 'Pop up store in Gurney Paragon', TO_DATE('01/06/2021', 'DD/MM/YYYY'),TO_DATE('04/11/2021', 'DD/MM/YYYY'), 10000);
    
    INSERT INTO Assignment
    values(102, 300, 209, 'Help to promote event');
    INSERT INTO assignment
    values(103, 301, 210, 'Find sponsorship');
    INSERT INTO assignment
    values(104, 302, 212, 'Manage cash flow in and out of the event');
    INSERT INTO assignment
    values(105, 303, 211, 'Plan programmes that is suitable for the event');
    INSERT INTO assignment
    values(106, 307, 212, 'Manage cash flow in and out of the event and arrange cash prizes');
    INSERT INTO assignment
    values(107, 304, 208, 'Manage human traffic on event day');
    INSERT INTO assignment
    values(108, 306, 209, 'Help to promote event');
    INSERT INTO assignment
    values(109, 305, 208, 'Manage human traffic and ensure safety of guest');


    INSERT INTO membership VALUES
    ('1001', '10001', to_date('3-6-2024', 'dd-mm-yyyy'), 10, 25);
    INSERT INTO membership VALUES
    ('1002', '10002', to_date('5-6-2024', 'dd-mm-yyyy'), 10, 25);
    INSERT INTO membership VALUES
    ('1003', '10003', to_date('6-6-2024', 'dd-mm-yyyy'), 10, 14);
    INSERT INTO membership VALUES
    ('1004', '10005', to_date('14-6-2024', 'dd-mm-yyyy'), 10, 8);
    INSERT INTO membership VALUES
    ('1005', '10004', to_date('19-6-2024', 'dd-mm-yyyy'), 10, 15);


    INSERT INTO reward VALUES
    ('101', 'Blue Pen', 3);
    INSERT INTO reward VALUES
    ('102', 'Eraser', 2);
    INSERT INTO reward VALUES
    ('103', 'Highlighter', 4);
    INSERT INTO reward VALUES
    ('104', 'Sharpie', 4);
    INSERT INTO reward VALUES
    ('105', 'Story Book', 20);


    INSERT INTO redeemed VALUES
    ('101', '1001', to_date('3-7-2024', 'dd-mm-yyyy'));
    INSERT INTO redeemed VALUES
    ('101', '1002', to_date('5-7-2024', 'dd-mm-yyyy'));
    INSERT INTO redeemed VALUES
    ('102', '1005', to_date('8-7-2024', 'dd-mm-yyyy'));
    INSERT INTO redeemed VALUES
    ('102', '1004', to_date('11-7-2024', 'dd-mm-yyyy'));
    INSERT INTO redeemed VALUES
    ('104', '1003', to_date('14-7-2024', 'dd-mm-yyyy'));
    INSERT INTO redeemed VALUES
    ('103', '1003', to_date('14-7-2024', 'dd-mm-yyyy'));
    INSERT INTO redeemed VALUES
    ('105', '1002', to_date('17-7-2024', 'dd-mm-yyyy'));
    INSERT INTO redeemed VALUES
    ('103', '1005', to_date('21-7-2024', 'dd-mm-yyyy'));


    --contributor record
    insert into contributor values (1001,101);
    insert into contributor values (1001,102);
    insert into contributor values (1001,105);
    insert into contributor values (1002,104);
    insert into contributor values (1002,105);
    insert into contributor values (1003,104);
    insert into contributor values (1004,103);
    insert into contributor values (1005,103);


    --stock record
    insert into stock values (1001,1,0);
    insert into stock values (1002,1,0);
    insert into stock values (1003,1,0);
    insert into stock values (1005,1,0);
    insert into stock values (1001,2,0);
    insert into stock values (1004,2,0);
    insert into stock values (1001,3,0);
    insert into stock values (1001,4,0);
    insert into stock values (1001,5,0);

    --price record
    insert into price values(1001,1001,'20-AUG-2024',10);
    insert into price values(1002,1001,'26-AUG-2024',12);
    insert into price values(1003,1002,'20-AUG-2024',100);
    insert into price values(1004,1003,'18-AUG-2024',130);
    insert into price values(1005,1004,'10-AUG-2024',50);
    insert into price values(1006,1005,'22-AUG-2024',39.90);



    --restock record
    insert into restock values(1001,1,1001,'28-AUG-2024',10,50);
    insert into restock values(1002,1,1002,'29-AUG-2024',100,30);
    insert into restock values(1003,1,1003,'29-AUG-2024',150,100);
    insert into restock values(1004,1,1005,'29-AUG-2024',20,76.5);
    insert into restock values(1005,1,1001,'29-AUG-2024',15,52);
    insert into restock values(1006,2,1004,'29-AUG-2024',60,50);
    insert into restock values(1007,3,1001,'29-AUG-2024',30,30);
    insert into restock values(1008,4,1001,'29-AUG-2024',20,20);
    insert into restock values(1009,5,1001,'29-AUG-2024',50,10);
    insert into restock values(1010,1,1001,'29-AUG-2024',15,52);
    insert into restock values(1011,1,1001,'29-AUG-2024',15,52);


    --invoice record
    INSERT INTO invoice VALUES(30001,101,TO_DATE('24-6-2021', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30002,101,TO_DATE('21-6-2024', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30003,101,TO_DATE('21-6-2024', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30004,101,TO_DATE('21-6-2024', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30005,101,TO_DATE('22-6-2024', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30006,101,TO_DATE('22-6-2024', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30007,101,TO_DATE('22-6-2024', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30008,101,TO_DATE('23-6-2024', 'dd-mm-yyyy'));
    INSERT INTO invoice VALUES(30009,101,TO_DATE('24-6-2024', 'dd-mm-yyyy'));


    INSERT INTO sale VALUES
    (1, '10001', '30001', 1001, 1, to_date('21-6-2024', 'dd-mm-yyyy'), 1);
    INSERT INTO sale VALUES
    (2, '10002', '30002', 1001, 1, to_date('21-6-2024', 'dd-mm-yyyy'), 1);
    INSERT INTO sale VALUES
    (3, '10003', '30003', 1001, 1, to_date('21-6-2024', 'dd-mm-yyyy'), 1);
    INSERT INTO sale VALUES
    (4, '10004', '30004', 1005, 1, to_date('22-6-2024', 'dd-mm-yyyy'), 1);
    INSERT INTO sale VALUES
    (5, '10005', '30005', 1003, 1, to_date('22-6-2024', 'dd-mm-yyyy'), 1);
    INSERT INTO sale VALUES
    (6, '10001', '30006', 1003, 1, to_date('22-6-2024', 'dd-mm-yyyy'), 1);
    INSERT INTO sale VALUES
    (7, '10003', '30007', 1001, 1, to_date('23-6-2024', 'dd-mm-yyyy'), 1);
    INSERT INTO sale VALUES
    (8, '10004', '30008', 1003, 1, to_date('24-6-2024', 'dd-mm-yyyy'), 1);
