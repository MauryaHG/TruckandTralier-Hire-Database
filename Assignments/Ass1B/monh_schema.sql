/*
FIT3171 Databases Assignment 1B, 2022 Semester 2
monh_schema.sql

Authors: Danniel You, Josh Newnham, Maurya Gamage
Group: A01-Group14
Date modified: 15/09/2022
*/

SET ECHO ON
SPOOL monh_schema_output.txt

-- Generated by Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   at:        2022-09-15 13:13:23 AEST
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c



DROP TABLE combo CASCADE CONSTRAINTS;

DROP TABLE combo_purpose CASCADE CONSTRAINTS;

DROP TABLE customer CASCADE CONSTRAINTS;

DROP TABLE employee CASCADE CONSTRAINTS;

DROP TABLE job CASCADE CONSTRAINTS;

DROP TABLE make CASCADE CONSTRAINTS;

DROP TABLE manufacturer CASCADE CONSTRAINTS;

DROP TABLE purpose CASCADE CONSTRAINTS;

DROP TABLE quote CASCADE CONSTRAINTS;

DROP TABLE trailer CASCADE CONSTRAINTS;

DROP TABLE trailerclass CASCADE CONSTRAINTS;

DROP TABLE trailermodel CASCADE CONSTRAINTS;

DROP TABLE trailertype CASCADE CONSTRAINTS;

DROP TABLE truck CASCADE CONSTRAINTS;

DROP TABLE truckclass CASCADE CONSTRAINTS;

DROP TABLE truckmodel CASCADE CONSTRAINTS;

DROP TABLE trucktype CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE combo (
    combo_code   CHAR(3) NOT NULL,
    truck_vin    CHAR(17) NOT NULL,
    trailer_code CHAR(5) NOT NULL
);

COMMENT ON COLUMN combo.combo_code IS
    'The unique identification code (prefixed with the letter "C") for the truck and trailer combo.'
    ;

COMMENT ON COLUMN combo.truck_vin IS
    'The unique vehicle identification number (VIN) of the truck.';

COMMENT ON COLUMN combo.trailer_code IS
    'The unique five-character-code identifier for the trailer.';

ALTER TABLE combo ADD CONSTRAINT combo_pk PRIMARY KEY ( combo_code );

CREATE TABLE combo_purpose (
    combpurp_id NUMBER(4) NOT NULL,
    purpose_no  CHAR(3) NOT NULL,
    combo_code  CHAR(3) NOT NULL
);

COMMENT ON COLUMN combo_purpose.combpurp_id IS
    'The unique identifier for the combo purpose (surrogate primary key).';

COMMENT ON COLUMN combo_purpose.purpose_no IS
    'The unique identification number (prefixed with the letter "P") for the truck and trailer usage purpose.'
    ;

COMMENT ON COLUMN combo_purpose.combo_code IS
    'The unique identification code (prefixed with the letter "C") for the truck and trailer combo.'
    ;

ALTER TABLE combo_purpose ADD CONSTRAINT combo_purpose_pk PRIMARY KEY ( combpurp_id )
;

ALTER TABLE combo_purpose ADD CONSTRAINT combo_purpose_nk UNIQUE ( purpose_no,
                                                                   combo_code );

CREATE TABLE customer (
    cust_no         NUMBER(7) NOT NULL,
    cust_famname    VARCHAR2(50) NOT NULL,
    cust_givname    VARCHAR2(50) NOT NULL,
    cust_busname    VARCHAR2(50),
    cust_address    VARCHAR2(100) NOT NULL,
    cust_contact_no CHAR(10) NOT NULL
);

COMMENT ON COLUMN customer.cust_no IS
    'The unique identification number the customer.';

COMMENT ON COLUMN customer.cust_famname IS
    'The family name of the customer.';

COMMENT ON COLUMN customer.cust_givname IS
    'The given name of the customer.';

COMMENT ON COLUMN customer.cust_busname IS
    'The business name of the customer (if applicable).';

COMMENT ON COLUMN customer.cust_address IS
    'The address of the customer.';

COMMENT ON COLUMN customer.cust_contact_no IS
    'The contact number of the customer.';

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( cust_no );

CREATE TABLE employee (
    emp_no                 NUMBER(4) NOT NULL,
    emp_role               CHAR(1) NOT NULL,
    emp_tfn                CHAR(9) NOT NULL,
    emp_famname            VARCHAR2(50) NOT NULL,
    emp_givname            VARCHAR2(50) NOT NULL,
    emp_contact_no         CHAR(10) NOT NULL,
    emp_salary             NUMBER(8, 2) NOT NULL,
    emp_licence_no         VARCHAR2(15),
    manager_emp_no         NUMBER(4),
    highest_trckclass_name VARCHAR2(10)
);

ALTER TABLE employee
    ADD CONSTRAINT chk_emprole CHECK ( emp_role IN ( 'C', 'D', 'G', 'M', 'N' ) );

COMMENT ON COLUMN employee.emp_no IS
    'The unique identification number of the employee.';

COMMENT ON COLUMN employee.emp_role IS
    'The role of the employee (C = Clerk, D = Driver, M = Mechanic, N = Manager, G = General).'
    ;

COMMENT ON COLUMN employee.emp_tfn IS
    'The unique tax file number (TFN) of the employee.';

COMMENT ON COLUMN employee.emp_famname IS
    'The family name of the employee.';

COMMENT ON COLUMN employee.emp_givname IS
    'The given name of the employee.';

COMMENT ON COLUMN employee.emp_contact_no IS
    'The contact number of the employee.';

COMMENT ON COLUMN employee.emp_salary IS
    'The salary of the employee.';

COMMENT ON COLUMN employee.emp_licence_no IS
    'The licence number of the employee (if they are a driver).';

COMMENT ON COLUMN employee.manager_emp_no IS
    'The unique identification number of the employee.';

COMMENT ON COLUMN employee.highest_trckclass_name IS
    'The name that is used to uniquely identify the truck class.';

ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY ( emp_no );

CREATE TABLE job (
    job_no                        NUMBER(4) NOT NULL,
    job_pickup_datetime           DATE NOT NULL,
    job_intended_dropoff_datetime DATE NOT NULL,
    job_actual_dropoff_datetime   DATE NOT NULL,
    job_cost                      NUMBER(6, 2),
    job_date_paid                 DATE NOT NULL,
    quote_no                      NUMBER(4) NOT NULL,
    clerk_no                      NUMBER(4) NOT NULL,
    combo_code                    CHAR(3) NOT NULL,
    driver_emp_no                 NUMBER(4) NOT NULL,
    mechanic_emp_no               NUMBER(4) NOT NULL
);

COMMENT ON COLUMN job.job_no IS
    'The unique identifier number of the job.';

COMMENT ON COLUMN job.job_pickup_datetime IS
    'The actual pickup date and time for the job.';

COMMENT ON COLUMN job.job_intended_dropoff_datetime IS
    'The intended drop off date and time for the job.';

COMMENT ON COLUMN job.job_actual_dropoff_datetime IS
    'The actual drop off date and time for the job.';

COMMENT ON COLUMN job.job_cost IS
    'The cost of the job (if different to quote cost).';

COMMENT ON COLUMN job.job_date_paid IS
    'The date on which the customer paid for the job.';

COMMENT ON COLUMN job.quote_no IS
    'The unique identification number of the quote.';

COMMENT ON COLUMN job.clerk_no IS
    'The unique identification number of the employee.';

COMMENT ON COLUMN job.combo_code IS
    'The unique identification code (prefixed with the letter "C") for the truck and trailer combo.'
    ;

COMMENT ON COLUMN job.driver_emp_no IS
    'The unique identification number of the employee.';

COMMENT ON COLUMN job.mechanic_emp_no IS
    'The unique identification number of the employee.';

CREATE UNIQUE INDEX job__idx ON
    job (
        driver_emp_no
    ASC );

CREATE UNIQUE INDEX job__idxv1 ON
    job (
        mechanic_emp_no
    ASC );

CREATE UNIQUE INDEX job__idxv2 ON
    job (
        quote_no
    ASC );

ALTER TABLE job ADD CONSTRAINT job_pk PRIMARY KEY ( job_no );

CREATE TABLE make (
    make_id   NUMBER(4) NOT NULL,
    make_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN make.make_id IS
    'The unique identifier of the truck make.';

COMMENT ON COLUMN make.make_name IS
    'The name of the truck make.';

ALTER TABLE make ADD CONSTRAINT make_pk PRIMARY KEY ( make_id );

CREATE TABLE manufacturer (
    manufacturer_id   NUMBER(4) NOT NULL,
    manufacturer_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN manufacturer.manufacturer_id IS
    'The unique identifier of the trailer manufacturer.';

COMMENT ON COLUMN manufacturer.manufacturer_name IS
    'The name of the trailer manufacturer.';

ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pk PRIMARY KEY ( manufacturer_id
);

CREATE TABLE purpose (
    purpose_no   CHAR(3) NOT NULL,
    purpose_desc VARCHAR2(100) NOT NULL
);

COMMENT ON COLUMN purpose.purpose_no IS
    'The unique identification number (prefixed with the letter "P") for the truck and trailer usage purpose.'
    ;

COMMENT ON COLUMN purpose.purpose_desc IS
    'The description of the truck and trailer usage purpose.';

ALTER TABLE purpose ADD CONSTRAINT purpose_pk PRIMARY KEY ( purpose_no );

CREATE TABLE quote (
    quote_no            NUMBER(4) NOT NULL,
    quote_start_date    DATE NOT NULL,
    quote_pickup_loc    VARCHAR2(100) NOT NULL,
    quote_dropoff_loc   VARCHAR2(100) NOT NULL,
    quote_prep_date     DATE NOT NULL,
    quote_cost          NUMBER(6, 2) NOT NULL,
    quote_days_required NUMBER(2) NOT NULL,
    quote_status        CHAR(1) NOT NULL,
    emp_no              NUMBER(4) NOT NULL,
    cust_no             NUMBER(7) NOT NULL,
    purpose_no          CHAR(3) NOT NULL
);

ALTER TABLE quote
    ADD CONSTRAINT chk_quotestatus CHECK ( quote_status IN ( 'F', 'U' ) );

COMMENT ON COLUMN quote.quote_no IS
    'The unique identification number of the quote.';

COMMENT ON COLUMN quote.quote_start_date IS
    'The preferred booking start date for the quote.';

COMMENT ON COLUMN quote.quote_pickup_loc IS
    'The pickup location of the quote.';

COMMENT ON COLUMN quote.quote_dropoff_loc IS
    'The drop off location of the quote.';

COMMENT ON COLUMN quote.quote_prep_date IS
    'The date on which the quote was prepared.';

COMMENT ON COLUMN quote.quote_cost IS
    'The cost of the quote. The cost is calculated by: (driver hire rate/day + truck class hire rate/day + trailer class hire rate/day) * days'
    ;

COMMENT ON COLUMN quote.quote_days_required IS
    'The number of days required to fulfil the quote.';

COMMENT ON COLUMN quote.quote_status IS
    'The status of the quote. A quote can either be fulfilled (F) when the clerk assigns the quote to a job, or unfulfilled (U) when a quote is rejected by the customer or they do not call back with a decision.'
    ;

COMMENT ON COLUMN quote.emp_no IS
    'The unique identification number of the employee.';

COMMENT ON COLUMN quote.cust_no IS
    'The unique identification number the customer.';

COMMENT ON COLUMN quote.purpose_no IS
    'The unique identification number (prefixed with the letter "P") for the truck and trailer usage purpose.'
    ;

ALTER TABLE quote ADD CONSTRAINT quote_pk PRIMARY KEY ( quote_no );

CREATE TABLE trailer (
    trailer_code          CHAR(5) NOT NULL,
    trailer_purchase_cost NUMBER(8, 2) NOT NULL,
    trailer_purchase_date DATE NOT NULL,
    trailer_load_cap      NUMBER(5) NOT NULL,
    trailer_dimensions    CHAR(11) NOT NULL,
    trailclass_code       VARCHAR2(3) NOT NULL
);

COMMENT ON COLUMN trailer.trailer_code IS
    'The unique five-character-code identifier for the trailer.';

COMMENT ON COLUMN trailer.trailer_purchase_cost IS
    'The dollar cost of purchase for the trailer.';

COMMENT ON COLUMN trailer.trailer_purchase_date IS
    'The date on which the trailer was purchased.';

COMMENT ON COLUMN trailer.trailer_load_cap IS
    'The load capacitiy (in kilograms) of the trailer.';

COMMENT ON COLUMN trailer.trailer_dimensions IS
    'The dimensions (LxW) (in metres) of the trailer.';

COMMENT ON COLUMN trailer.trailclass_code IS
    'The unique code of the trailer class.';

ALTER TABLE trailer ADD CONSTRAINT trailer_pk PRIMARY KEY ( trailer_code );

CREATE TABLE trailerclass (
    trailclass_code            VARCHAR2(3) NOT NULL,
    trailclass_daily_hire_rate NUMBER(5, 2) NOT NULL
);

COMMENT ON COLUMN trailerclass.trailclass_code IS
    'The unique code of the trailer class.';

COMMENT ON COLUMN trailerclass.trailclass_daily_hire_rate IS
    'The daily hire rate of a trailer that is determined by the trailer class.';

ALTER TABLE trailerclass ADD CONSTRAINT trailerclass_pk PRIMARY KEY ( trailclass_code
);

CREATE TABLE trailermodel (
    trailmodel_id   NUMBER(4) NOT NULL,
    trailmodel_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN trailermodel.trailmodel_id IS
    'The unique identifier of the trailer model.';

COMMENT ON COLUMN trailermodel.trailmodel_name IS
    'The name of the trailer model.';

ALTER TABLE trailermodel ADD CONSTRAINT trailermodel_pk PRIMARY KEY ( trailmodel_id )
;

CREATE TABLE trailertype (
    trailtype_id    NUMBER(4) NOT NULL,
    manufacturer_id NUMBER(4) NOT NULL,
    trailmodel_id   NUMBER(4) NOT NULL,
    trailclass_code VARCHAR2(3) NOT NULL
);

COMMENT ON COLUMN trailertype.trailtype_id IS
    'The unique identifier of the trailer type (surrogate primary key).';

COMMENT ON COLUMN trailertype.manufacturer_id IS
    'The unique identifier of the trailer manufacturer.';

COMMENT ON COLUMN trailertype.trailmodel_id IS
    'The unique identifier of the trailer model.';

COMMENT ON COLUMN trailertype.trailclass_code IS
    'The unique code of the trailer class.';

ALTER TABLE trailertype ADD CONSTRAINT trailertype_pk PRIMARY KEY ( trailtype_id );

ALTER TABLE trailertype ADD CONSTRAINT trailertype_nk UNIQUE ( manufacturer_id,
                                                               trailmodel_id );

CREATE TABLE truck (
    truck_vin              CHAR(17) NOT NULL,
    truck_reg_no           CHAR(9) NOT NULL,
    truck_km_travelled     NUMBER(6) NOT NULL,
    truck_km_last_serviced NUMBER(6) NOT NULL,
    truck_purchase_cost    NUMBER(8, 2) NOT NULL,
    truck_purchase_date    DATE NOT NULL,
    trckclass_name         VARCHAR2(10) NOT NULL
);

COMMENT ON COLUMN truck.truck_vin IS
    'The unique vehicle identification number (VIN) of the truck.';

COMMENT ON COLUMN truck.truck_reg_no IS
    'The registration number of the truck.';

COMMENT ON COLUMN truck.truck_km_travelled IS
    'The number of kilometres travelled by the truck.';

COMMENT ON COLUMN truck.truck_km_last_serviced IS
    'The kilometre reading of the last service for the truck.';

COMMENT ON COLUMN truck.truck_purchase_cost IS
    'The dollar cost of purchase for the truck.';

COMMENT ON COLUMN truck.truck_purchase_date IS
    'The date on which the truck was purchased.';

COMMENT ON COLUMN truck.trckclass_name IS
    'The name that is used to uniquely identify the truck class.';

ALTER TABLE truck ADD CONSTRAINT truck_pk PRIMARY KEY ( truck_vin );

CREATE TABLE truckclass (
    trckclass_name            VARCHAR2(10) NOT NULL,
    trkclass_daily_hire_rate  NUMBER(5, 2) NOT NULL,
    trkclass_driver_hire_rate NUMBER(5, 2) NOT NULL
);

COMMENT ON COLUMN truckclass.trckclass_name IS
    'The name that is used to uniquely identify the truck class.';

COMMENT ON COLUMN truckclass.trkclass_daily_hire_rate IS
    'The daily hire rate of a truck that is determined by the truck class.';

COMMENT ON COLUMN truckclass.trkclass_driver_hire_rate IS
    'The driver hire rate of a truck that is determined by the truck class.';

ALTER TABLE truckclass ADD CONSTRAINT truckclass_pk PRIMARY KEY ( trckclass_name );

CREATE TABLE truckmodel (
    trckmodel_id   NUMBER(4) NOT NULL,
    trckmodel_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN truckmodel.trckmodel_id IS
    'The unique identifier of a truck model.';

COMMENT ON COLUMN truckmodel.trckmodel_name IS
    'The name of the truck model.';

ALTER TABLE truckmodel ADD CONSTRAINT truck_model_pk PRIMARY KEY ( trckmodel_id );

CREATE TABLE trucktype (
    trcktype_id    NUMBER(4) NOT NULL,
    make_id        NUMBER(4) NOT NULL,
    trckmodel_id   NUMBER(4) NOT NULL,
    trckclass_name VARCHAR2(10) NOT NULL
);

COMMENT ON COLUMN trucktype.trcktype_id IS
    'The unique identifier of the truck type (surrogate primary key).';

COMMENT ON COLUMN trucktype.make_id IS
    'The unique identifier of the truck make.';

COMMENT ON COLUMN trucktype.trckmodel_id IS
    'The unique identifier of a truck model.';

COMMENT ON COLUMN trucktype.trckclass_name IS
    'The name that is used to uniquely identify the truck class.';

ALTER TABLE trucktype ADD CONSTRAINT trucktype_pk PRIMARY KEY ( trcktype_id );

ALTER TABLE trucktype ADD CONSTRAINT trucktype_nk UNIQUE ( make_id,
                                                           trckmodel_id );

ALTER TABLE job
    ADD CONSTRAINT clerk_job FOREIGN KEY ( clerk_no )
        REFERENCES employee ( emp_no );

ALTER TABLE combo_purpose
    ADD CONSTRAINT combo_combo_purpose FOREIGN KEY ( combo_code )
        REFERENCES combo ( combo_code );

ALTER TABLE job
    ADD CONSTRAINT combo_job FOREIGN KEY ( combo_code )
        REFERENCES combo ( combo_code );

ALTER TABLE quote
    ADD CONSTRAINT customer_quote FOREIGN KEY ( cust_no )
        REFERENCES customer ( cust_no );

ALTER TABLE job
    ADD CONSTRAINT driver_job FOREIGN KEY ( driver_emp_no )
        REFERENCES employee ( emp_no );

ALTER TABLE employee
    ADD CONSTRAINT employee_employee FOREIGN KEY ( manager_emp_no )
        REFERENCES employee ( emp_no );

ALTER TABLE quote
    ADD CONSTRAINT employee_quote FOREIGN KEY ( emp_no )
        REFERENCES employee ( emp_no );

ALTER TABLE trucktype
    ADD CONSTRAINT make_trucktype FOREIGN KEY ( make_id )
        REFERENCES make ( make_id );

ALTER TABLE trailertype
    ADD CONSTRAINT manufacturer_trailertype FOREIGN KEY ( manufacturer_id )
        REFERENCES manufacturer ( manufacturer_id );

ALTER TABLE job
    ADD CONSTRAINT mechanic_job FOREIGN KEY ( mechanic_emp_no )
        REFERENCES employee ( emp_no );

ALTER TABLE combo_purpose
    ADD CONSTRAINT purpose_combo_purpose FOREIGN KEY ( purpose_no )
        REFERENCES purpose ( purpose_no );

ALTER TABLE quote
    ADD CONSTRAINT purpose_quote FOREIGN KEY ( purpose_no )
        REFERENCES purpose ( purpose_no );

ALTER TABLE job
    ADD CONSTRAINT quote_job FOREIGN KEY ( quote_no )
        REFERENCES quote ( quote_no );

ALTER TABLE combo
    ADD CONSTRAINT trailer_combo FOREIGN KEY ( trailer_code )
        REFERENCES trailer ( trailer_code );

ALTER TABLE trailer
    ADD CONSTRAINT trailerclass_trailer FOREIGN KEY ( trailclass_code )
        REFERENCES trailerclass ( trailclass_code );

ALTER TABLE trailertype
    ADD CONSTRAINT trailerclass_trailertype FOREIGN KEY ( trailclass_code )
        REFERENCES trailerclass ( trailclass_code );

ALTER TABLE trailertype
    ADD CONSTRAINT trailermodel_trailertype FOREIGN KEY ( trailmodel_id )
        REFERENCES trailermodel ( trailmodel_id );

ALTER TABLE combo
    ADD CONSTRAINT truck_combo FOREIGN KEY ( truck_vin )
        REFERENCES truck ( truck_vin );

ALTER TABLE employee
    ADD CONSTRAINT truckclass_employee FOREIGN KEY ( highest_trckclass_name )
        REFERENCES truckclass ( trckclass_name );

ALTER TABLE truck
    ADD CONSTRAINT truckclass_truck FOREIGN KEY ( trckclass_name )
        REFERENCES truckclass ( trckclass_name );

ALTER TABLE trucktype
    ADD CONSTRAINT truckclass_trucktype FOREIGN KEY ( trckclass_name )
        REFERENCES truckclass ( trckclass_name );

ALTER TABLE trucktype
    ADD CONSTRAINT truckmodel_trucktype FOREIGN KEY ( trckmodel_id )
        REFERENCES truckmodel ( trckmodel_id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            17
-- CREATE INDEX                             3
-- ALTER TABLE                             44
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

SPOOL OFF
SET ECHO OFF
