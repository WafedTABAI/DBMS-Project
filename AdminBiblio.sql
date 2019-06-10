--------------------------------------------------------
--  Fichier créé - lundi-avril-29-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_ADHERENT
--------------------------------------------------------

   CREATE SEQUENCE  "PROJET"."SEQ_ADHERENT"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CATALOGUE
--------------------------------------------------------

   CREATE SEQUENCE  "PROJET"."SEQ_CATALOGUE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_COMMANDE
--------------------------------------------------------

   CREATE SEQUENCE  "PROJET"."SEQ_COMMANDE"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_EXEMPLAIRE
--------------------------------------------------------

   CREATE SEQUENCE  "PROJET"."SEQ_EXEMPLAIRE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table ADHERENT
--------------------------------------------------------

  CREATE TABLE "PROJET"."ADHERENT" 
   (	"NOADH" NUMBER(6,0), 
	"NOM" VARCHAR2(80 BYTE), 
	"PRENOM" VARCHAR2(80 BYTE), 
	"ADRESSE" VARCHAR2(200 BYTE), 
	"NCIN" NUMBER(8,0), 
	"TEL" NUMBER(10,0), 
	"DATEADH" DATE, 
	"EMAIL" VARCHAR2(80 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table CATALOGUE
--------------------------------------------------------

  CREATE TABLE "PROJET"."CATALOGUE" 
   (	"CODEG" NUMBER(10,0), 
	"TITRE" VARCHAR2(200 BYTE), 
	"NOMAUT" VARCHAR2(80 BYTE), 
	"PRENOMAUT" VARCHAR2(80 BYTE), 
	"ANED" NUMBER(4,0), 
	"EDITEUR" VARCHAR2(50 BYTE), 
	"PRIX" NUMBER(8,3)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table EMPRUNT
--------------------------------------------------------

  CREATE TABLE "PROJET"."EMPRUNT" 
   (	"CODEXP" VARCHAR2(10 BYTE), 
	"DATEEMP" DATE, 
	"NOADH" NUMBER(6,0), 
	"DATERPREVUE" DATE, 
	"DATEREFFECTIVE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table EXEMPLAIRE
--------------------------------------------------------

  CREATE TABLE "PROJET"."EXEMPLAIRE" 
   (	"CODEXP" VARCHAR2(10 BYTE), 
	"CODEG" NUMBER(10,0), 
	"ETAT" CHAR(8 BYTE), 
	"DISP" CHAR(3 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table RETARD
--------------------------------------------------------

  CREATE TABLE "PROJET"."RETARD" 
   (	"NOADH" NUMBER(6,0), 
	"CODEG" NUMBER(10,0), 
	"DATEEMP" DATE, 
	"DATEREFFECTIVE" DATE, 
	"PENALITÉ" NUMBER, 
	"ENCOURS" CHAR(3 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for View VEMPRUNT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "PROJET"."VEMPRUNT" ("NOADH", "NOM", "NCIN", "CODEG", "TITRE", "DATEEMP", "DATERPREVUE", "DATEREFFECTIVE") AS 
  Select a.noadh, a.nom, a.ncin, c.codeg, c.titre, e.dateemp, e.dateRprevue, e.dateReffective 
from adherent a, catalogue c, emprunt e, exemplaire ex
where a.noadh=e.noadh and c.codeg=ex.codeg and ex.codexp=e.codexp;
--------------------------------------------------------
--  DDL for View VSTATISTIQUES2018
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "PROJET"."VSTATISTIQUES2018" ("NB_TOTAL", "NB_MEDIOCRE", "NB_EMPRUNT", "POURC_RETARD", "CODEG") AS 
  SELECT count(e.CODEXP) as nb_total ,( select count(al.CODEXP) from exemplaire al where al.etat='mediocre' and al.CODEG = e.CODEG) as nb_mediocre ,
(select count(  vem.codeg) from  vemprunt vem where e.codeg=vem.codeg )   as nb_emprunt,
((select count(codeg) from RETARD where e.codeg=retard.codeg)*100/(select count(  vem.codeg) from  vemprunt vem where e.codeg=vem.codeg having count(vem.codeg)>0  )) as pourc_retard,
e.CODEG  from exemplaire e  group by e.CODEG;
REM INSERTING into PROJET.ADHERENT
SET DEFINE OFF;
Insert into PROJET.ADHERENT (NOADH,NOM,PRENOM,ADRESSE,NCIN,TEL,DATEADH,EMAIL) values (1,'w','w','w',12345678,1,to_date('11-11-18','DD-MM-RR'),'w');
Insert into PROJET.ADHERENT (NOADH,NOM,PRENOM,ADRESSE,NCIN,TEL,DATEADH,EMAIL) values (2,'x','y','z',19951995,2,to_date('12-09-01','DD-MM-RR'),'w');
Insert into PROJET.ADHERENT (NOADH,NOM,PRENOM,ADRESSE,NCIN,TEL,DATEADH,EMAIL) values (3,'w',' ',' ',12345656,0,to_date('22-04-19','DD-MM-RR'),' ');
Insert into PROJET.ADHERENT (NOADH,NOM,PRENOM,ADRESSE,NCIN,TEL,DATEADH,EMAIL) values (4,'gg','g','g',null,5,to_date('10-04-19','DD-MM-RR'),'k');
Insert into PROJET.ADHERENT (NOADH,NOM,PRENOM,ADRESSE,NCIN,TEL,DATEADH,EMAIL) values (5,'g','gg','g',null,4,to_date('10-04-19','DD-MM-RR'),'k');
REM INSERTING into PROJET.CATALOGUE
SET DEFINE OFF;
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (100,'Base de donnees','ADIBA','Michel',1995,'atlas',70);
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (200,'Base des objets','COLLAND','Rollet',1990,'atlas',58);
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (300,'OO DMBS','ADIBA','Michel',1998,'eyrolls',45);
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (400,'ORACLE SQL','LINDEN','Brian',2000,'eyrolls',60);
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (500,'SQL*Plus reference','LINDEN','Brian',2001,'eyrolls',63);
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (600,'Web Database','BUYENS','Jim',2000,'eyrolls',73);
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (700,'Base de donnees','b','b',2222,'hhhhhh',88888);
Insert into PROJET.CATALOGUE (CODEG,TITRE,NOMAUT,PRENOMAUT,ANED,EDITEUR,PRIX) values (800,'aaaa','aaaa','aaaa',2001,'gggg',555);
REM INSERTING into PROJET.EMPRUNT
SET DEFINE OFF;
Insert into PROJET.EMPRUNT (CODEXP,DATEEMP,NOADH,DATERPREVUE,DATEREFFECTIVE) values ('BDD_01',to_date('29-04-19','DD-MM-RR'),1,to_date('30-04-19','DD-MM-RR'),null);
Insert into PROJET.EMPRUNT (CODEXP,DATEEMP,NOADH,DATERPREVUE,DATEREFFECTIVE) values ('BD0_01',to_date('29-04-19','DD-MM-RR'),2,to_date('29-04-19','DD-MM-RR'),null);
Insert into PROJET.EMPRUNT (CODEXP,DATEEMP,NOADH,DATERPREVUE,DATEREFFECTIVE) values ('OOMS_01',to_date('29-04-19','DD-MM-RR'),3,to_date('29-04-19','DD-MM-RR'),null);
REM INSERTING into PROJET.EXEMPLAIRE
SET DEFINE OFF;
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('BDD_01',100,'bon     ','non');
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('BDD_02',100,'bon     ','oui');
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('BD0_01',200,'bon     ','non');
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('OOMS_01',300,'mediocre','non');
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('OOMS_02',300,'bon     ','oui');
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('ORA.SQL_01',400,'bon     ','oui');
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('SQLP_01',500,'bon     ','oui');
Insert into PROJET.EXEMPLAIRE (CODEXP,CODEG,ETAT,DISP) values ('WDB_00',600,'moyen   ','oui');
REM INSERTING into PROJET.RETARD
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index PK_EXEMPLAIRE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PROJET"."PK_EXEMPLAIRE" ON "PROJET"."EXEMPLAIRE" ("CODEXP") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_MEMBRES
--------------------------------------------------------

  CREATE UNIQUE INDEX "PROJET"."PK_MEMBRES" ON "PROJET"."ADHERENT" ("NOADH") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_CATALOGUE
--------------------------------------------------------

  CREATE UNIQUE INDEX "PROJET"."PK_CATALOGUE" ON "PROJET"."CATALOGUE" ("CODEG") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index INDEXAUTTITRE
--------------------------------------------------------

  CREATE INDEX "PROJET"."INDEXAUTTITRE" ON "PROJET"."CATALOGUE" ("NOMAUT", "TITRE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_EMPRUNTS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PROJET"."PK_EMPRUNTS" ON "PROJET"."EMPRUNT" ("CODEXP", "DATEEMP") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index INDEXAUTCATALOGUE
--------------------------------------------------------

  CREATE INDEX "PROJET"."INDEXAUTCATALOGUE" ON "PROJET"."CATALOGUE" ("NOMAUT") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_RETARD
--------------------------------------------------------

  CREATE UNIQUE INDEX "PROJET"."PK_RETARD" ON "PROJET"."RETARD" ("NOADH", "CODEG") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index INDEXTITRECATALOGUE
--------------------------------------------------------

  CREATE INDEX "PROJET"."INDEXTITRECATALOGUE" ON "PROJET"."CATALOGUE" ("TITRE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table CATALOGUE
--------------------------------------------------------

  ALTER TABLE "PROJET"."CATALOGUE" ADD CONSTRAINT "CK_CATALOGUE_ANED" CHECK (aned > 1950) ENABLE;
  ALTER TABLE "PROJET"."CATALOGUE" ADD CONSTRAINT "PK_CATALOGUE" PRIMARY KEY ("CODEG")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "PROJET"."CATALOGUE" MODIFY ("EDITEUR" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."CATALOGUE" MODIFY ("PRENOMAUT" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."CATALOGUE" MODIFY ("NOMAUT" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."CATALOGUE" MODIFY ("TITRE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table EMPRUNT
--------------------------------------------------------

  ALTER TABLE "PROJET"."EMPRUNT" ADD CONSTRAINT "PK_EMPRUNTS" PRIMARY KEY ("CODEXP", "DATEEMP")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "PROJET"."EMPRUNT" MODIFY ("DATERPREVUE" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."EMPRUNT" MODIFY ("NOADH" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."EMPRUNT" MODIFY ("DATEEMP" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."EMPRUNT" MODIFY ("CODEXP" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ADHERENT
--------------------------------------------------------

  ALTER TABLE "PROJET"."ADHERENT" ADD UNIQUE ("NCIN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "PROJET"."ADHERENT" ADD CONSTRAINT "PK_MEMBRES" PRIMARY KEY ("NOADH")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "PROJET"."ADHERENT" MODIFY ("EMAIL" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."ADHERENT" MODIFY ("DATEADH" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."ADHERENT" MODIFY ("ADRESSE" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."ADHERENT" MODIFY ("PRENOM" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."ADHERENT" MODIFY ("NOM" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table EXEMPLAIRE
--------------------------------------------------------

  ALTER TABLE "PROJET"."EXEMPLAIRE" ADD CONSTRAINT "PK_EXEMPLAIRE" PRIMARY KEY ("CODEXP")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "PROJET"."EXEMPLAIRE" ADD CONSTRAINT "CK_EXEMPLAIRE_DISP" CHECK (disp IN ('oui','non')) ENABLE;
  ALTER TABLE "PROJET"."EXEMPLAIRE" ADD CONSTRAINT "CK_EXEMPLAIRE_ETAT" CHECK (etat IN ('bon','moyen','mediocre')) ENABLE;
  ALTER TABLE "PROJET"."EXEMPLAIRE" MODIFY ("DISP" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."EXEMPLAIRE" MODIFY ("ETAT" NOT NULL ENABLE);
  ALTER TABLE "PROJET"."EXEMPLAIRE" MODIFY ("CODEG" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RETARD
--------------------------------------------------------

  ALTER TABLE "PROJET"."RETARD" ADD CONSTRAINT "PK_RETARD" PRIMARY KEY ("NOADH", "CODEG")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "PROJET"."RETARD" ADD CONSTRAINT "CK_CATALOGUE_ENCOURS" CHECK (encours IN ('oui','non')) ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table EMPRUNT
--------------------------------------------------------

  ALTER TABLE "PROJET"."EMPRUNT" ADD CONSTRAINT "FK_EMPRUNTS_ADH" FOREIGN KEY ("NOADH")
	  REFERENCES "PROJET"."ADHERENT" ("NOADH") ENABLE;
  ALTER TABLE "PROJET"."EMPRUNT" ADD CONSTRAINT "FK_EMPRUNTS_CODEXP" FOREIGN KEY ("CODEXP")
	  REFERENCES "PROJET"."EXEMPLAIRE" ("CODEXP") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table EXEMPLAIRE
--------------------------------------------------------

  ALTER TABLE "PROJET"."EXEMPLAIRE" ADD CONSTRAINT "FK_EXEMPLAIRE_CATALOGUE" FOREIGN KEY ("CODEG")
	  REFERENCES "PROJET"."CATALOGUE" ("CODEG") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RETARD
--------------------------------------------------------

  ALTER TABLE "PROJET"."RETARD" ADD CONSTRAINT "FK_RETARD_ADHERENT" FOREIGN KEY ("NOADH")
	  REFERENCES "PROJET"."ADHERENT" ("NOADH") ENABLE;
  ALTER TABLE "PROJET"."RETARD" ADD CONSTRAINT "FK_RETARD_CODEG" FOREIGN KEY ("CODEG")
	  REFERENCES "PROJET"."CATALOGUE" ("CODEG") ENABLE;
--------------------------------------------------------
--  DDL for Trigger INTERDICTION_DACCES_CATALOGUE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."INTERDICTION_DACCES_CATALOGUE" 
before delete or update or insert on catalogue
begin

if ( to_char(sysdate,'dd') = '29' or to_char(sysdate,'dd') = '30') then
raise_application_error(-20555,'Acces à la table "CATALOGUE" interdit ce jour du mois!');
end if;

end;
/
ALTER TRIGGER "PROJET"."INTERDICTION_DACCES_CATALOGUE" DISABLE;
--------------------------------------------------------
--  DDL for Trigger INTERDICTION_DACCES_EMPRUNT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."INTERDICTION_DACCES_EMPRUNT" 
before delete or update or insert on emprunt
begin

if ( to_char(sysdate,'dd') = '29' or to_char(sysdate,'dd') = '30') then
raise_application_error(-20555,'Acces à la table "EMPRUNT" interdit ce jour du mois!');
end if;

end;
/
ALTER TRIGGER "PROJET"."INTERDICTION_DACCES_EMPRUNT" DISABLE;
--------------------------------------------------------
--  DDL for Trigger INTERDICTION_DACCES_EXEMPLAIRE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."INTERDICTION_DACCES_EXEMPLAIRE" 
before delete or update or insert on exemplaire
begin

if ( to_char(sysdate,'dd') = '29' or to_char(sysdate,'dd') = '30') then
raise_application_error(-20555,'Acces à la table "EXEMPLAIRE" interdit ce jour du mois!');
end if;

end;
/
ALTER TRIGGER "PROJET"."INTERDICTION_DACCES_EXEMPLAIRE" DISABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_ADH_ANT_EMP
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_ADH_ANT_EMP" before insert or update on emprunt
for each row
Declare
v_dateAdh date;
begin 
select dateAdh into v_dateAdh from adherent where noAdh = :new.noAdh;
if (to_char(v_dateAdh,'dd') >to_char(:new.dateEmp,'dd')  )
then
raise_application_error(-20001,'La date d’adhésion doit etre antérieure ou égale à celle de l’emprunt');
end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_ADH_ANT_EMP" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_AJOUT_ADHERENT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_AJOUT_ADHERENT" 
before insert or update on adherent
for each row
declare
pragma autonomous_transaction;
begin
if PA_ADHERENT.is_adherent(:new.ncin) then
  raise_application_error(-20004,'Ce numéro de CIN existe déjà dans la base!');
  end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_AJOUT_ADHERENT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_AJOUT_CATALOGUE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_AJOUT_CATALOGUE" 
before insert or update on catalogue
for each row
declare
pragma autonomous_transaction;
begin
if PA_CATALOGUE.is_existant(:new.titre, :new.nomAut, :new.prenomAut, :new.anEd) then
  raise_application_error(-20008,'Ce livre existe déjà dans la base!');
  end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_AJOUT_CATALOGUE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_AJOUT_EMPRUNT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_AJOUT_EMPRUNT" 
before insert on emprunt
for each row
declare
vcodeg exemplaire.codeg%type;
x number;
v_datereffective retard.datereffective%type;
v_penalité retard.penalité%type;
v_encours retard.encours%type;
v_nb_exemp number;
v_nb_exemp_disp number;
begin
select count(:new.noadh) into x from RETARD;
if (x<>null) then
select datereffective,penalité,encours into v_datereffective,v_penalité,v_encours from retard where noadh=:new.noadh;
if ((sysdate - v_datereffective > v_penalité) and( v_penalité > 0)) then
update retard set retard.encours='non' where retard.noadh=:new.noadh;
end if;
if ( (sysdate - v_datereffective < v_penalité) and( v_penalité > 0)) then
raise_application_error(-20018,'Cet adhérent est encore pénalisé!');
end if;
if ( v_penalité=0 and upper(v_encours)='OUI') then
raise_application_error(-20021,'Cet adhérent doit payer le prix du livre dabord!');
end if;
else 

select count(*) into v_nb_exemp from exemplaire ex where upper(:new.codexp)=upper(ex.codexp);
if (v_nb_exemp >0) then
select count(*) into v_nb_exemp_disp from exemplaire ex where upper(:new.codexp)=upper(ex.codexp) and upper(disp)='OUI';
if (v_nb_exemp_disp >0) then 
PA_CATALOGUE.p_codexp(:new.codexp);
else raise_application_error(-20022,'Exemplaire non-disponible pour le moment!');
end if;
else raise_application_error(-20023,'Exemplaire inexistant!');
end if;
end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_AJOUT_EMPRUNT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_ANT_RET1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_EMP_ANT_RET1" before insert on emprunt 
for each row
begin 
if (:new.dateRprevue < :new.dateemp   ) then
raise_application_error(-20000,'Il faut que la date d"emprunt soit antérieure à celle du retour');
end if;
if ( to_char(:new.dateemp,'dd')<>to_char(sysdate,'dd')) then
raise_application_error(-20300,'Il faut que la date d"emprunt soit celle d"aujourd"hui');
end if;

end;
/
ALTER TRIGGER "PROJET"."TRIG_EMP_ANT_RET1" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_ANT_RET2
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_EMP_ANT_RET2" before update of daterprevue,dateemp on emprunt 
for each row
begin 
if (:new.dateRprevue < :new.dateemp  ) then
raise_application_error(-20000,'Il faut que la date d"emprunt soit antérieure à celle du retour');
end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_EMP_ANT_RET2" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_J_MAX
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_EMP_J_MAX" before insert or update on emprunt
for each row
Declare
DateDiff NUMBER;
begin 
select :new.dateRprevue - sysdate   into DateDiff 
from dual;
if DateDiff >31
then
raise_application_error(-20002,'Un emprunt ne doit pas depasser 31 jours');
else
update exemplaire e set disp ='non' where e.codexp = :new.codexp and e.disp='oui';
end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_EMP_J_MAX" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_MAX
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_EMP_MAX" before insert or update of codexp,noadh on emprunt
for each row 
Declare
pragma autonomous_transaction;
nb_emp1 number;
nb_emp2 number;
v_codeg exemplaire.codeg%type;
begin

select codeg into v_codeg from exemplaire where upper(codexp)=upper(:new.codexp);
select count(*) into nb_emp1 from emprunt e, exemplaire ex 
where ex.codeg=v_codeg and upper(ex.codexp)=upper(e.codexp) and e.noadh=:new.noadh and e.DATERPREVUE>=sysdate; 
if (nb_emp1>0) then raise_application_error(-20011,'Vous ne pouvez pas effectuer plus d"un emprunt sur un même livre');
end if;

select count(:new.noadh) into nb_emp2 from emprunt 
where :new.dateEmp =sysdate ;
if(nb_emp2 >= 5) then raise_application_error(-20007,'Vous ne pouvez pas effectuer plus de 5 emprunts');
end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_EMP_MAX" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_MODIF_ADHERENT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_MODIF_ADHERENT" 
BEFORE UPDATE OF noadh,nom,prenom,ncin,dateadh ON adherent
FOR EACH ROW
BEGIN
/*ajouter la fonction is_existant pour respecter la charte */
if (:OLD.noadh != :NEW.noadh) or (:OLD.nom != :NEW.nom) or (:OLD.prenom != :NEW.prenom) or (:OLD.ncin != :NEW.ncin) or (:OLD.dateadh != :NEW.dateadh)
then
RAISE_APPLICATION_ERROR(-20006, 'Ce champ ne peut pas etre modifié!') ;
end if;
END;
/
ALTER TRIGGER "PROJET"."TRIG_MODIF_ADHERENT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_MODIF_CATALOGUE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_MODIF_CATALOGUE" 
BEFORE UPDATE  ON catalogue
FOR EACH ROW
BEGIN
if (PA_CATALOGUE.NBEXEMPLAIRE_CAT(:old.codeg)>=1)
then
RAISE_APPLICATION_ERROR(-20010, 'Livre non-modifiable, car il a des exemplaires') ;
end if;
END;
/
ALTER TRIGGER "PROJET"."TRIG_MODIF_CATALOGUE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_RETARD
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_RETARD" 
after update of DATEREFFECTIVE  on EMPRUNT
for each row
declare

vcodeg exemplaire.codeg%type;
x number;
begin
select codeg into vcodeg from exemplaire e where :new.codexp=e.codexp;
select count(*) into x from retard where noadh=:new.noadh and encours='oui';
if (x=1) then
delete from retard where noadh=:new.noadh and encours='oui';
PA_ADHERENT.p_retard(vcodeg,:new.daterprevue,:new.datereffective,:new.dateemp,:new.noadh);
else
PA_ADHERENT.p_retard(vcodeg,:new.daterprevue,:new.datereffective,:new.dateemp,:new.noadh);
end if;

end;
/
ALTER TRIGGER "PROJET"."TRIG_RETARD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_RETARD_DR_EFFECTIVE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_RETARD_DR_EFFECTIVE" 
BEFORE update of datereffective on emprunt
for each row
declare
begin
if(:new.datereffective > sysdate) then
raise_application_error(-20035,'Date de retour effective non-valide (supérieur à la date actuelle)!');
end if;

end;
/
ALTER TRIGGER "PROJET"."TRIG_RETARD_DR_EFFECTIVE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_SUPPRESSION_CATALAOGUE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_SUPPRESSION_CATALAOGUE" 
BEFORE DELETE OR UPDATE ON CATALOGUE 
FOR EACH ROW 
declare
pragma autonomous_transaction;
begin
  
  if (PA_CATALOGUE.is_Emprunt(:old.Codeg) >0 )then
  /*DESCATIVER CONTRAINT :ALTER TABLE exemplaire enable CONSTRAINT FK_EXEMPLAIRE_CATALOGUE;*/
  update exemplaire e set e.disp ='non' where e.codeg = :new.codeg and e.disp='oui';
  /*REACTIVER CONTRAINTE:ALTER TABLE exemplaire enable CONSTRAINT FK_EXEMPLAIRE_CATALOGUE;*/
   raise_application_error(-20009,'Ce catalogue ne peut pas etre supprimé car il des exemplaires empruntés');
  end if;
 
  
end;
/
ALTER TRIGGER "PROJET"."TRIG_SUPPRESSION_CATALAOGUE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_SUPRESSION_ADHERENT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_SUPRESSION_ADHERENT" before delete on adherent
for each row
declare
pragma autonomous_transaction;
begin
if PA_ADHERENT.fait_emprunt(:old.noadh) then
raise_application_error(-20005,'Ne peut pas être supprimé car il a un emprunt en cours');
end if;
end;
/
ALTER TRIGGER "PROJET"."TRIG_SUPRESSION_ADHERENT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_VUE_EMP
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "PROJET"."TRIG_VUE_EMP" instead of insert on vemprunt
for each row
declare
v_codexp EXEMPLAIRE.CODEXP%type;
v_nb1 number;
v_nb2  number;
begin
select count(*) into v_nb1 from exemplaire  where codeg=:new.codeg;
if (v_nb1>0) then
select count(*) into v_nb2 from exemplaire  where codeg=:new.codeg and disp='oui';
if (v_nb2>0) then
/*v_codexp:=PA_CATALOGUE.f_codexp(:new.codeg);*/
select exemplaire.codexp into v_codexp from exemplaire  where codeg=:new.codeg and disp='oui' and rownum<=1;
/*update exemplaire set exemplaire.disp='non' where upper(exemplaire.codexp) = upper(v_exp);*/
if (not PA_ADHERENT.is_adherent(:new.ncin)) then insert into adherent values (:new.noadh,:new.nom,' ',' ',:new.ncin,0,sysdate,' '); 
end if;
insert into emprunt values(v_codexp,:new.dateemp,:new.noadh,:new.daterprevue,:new.datereffective);
else raise_application_error(-20030,'Pas d"exemplaire disponible pour ce catalogue ');
end if;

else raise_application_error(-20031,'Exemplaires inexistants pour ce catalogue');
end if;

end;
/
ALTER TRIGGER "PROJET"."TRIG_VUE_EMP" ENABLE;
--------------------------------------------------------
--  DDL for Package PA_ADHERENT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PROJET"."PA_ADHERENT" AS
function is_adherent (x ADHERENT.NCIN%type)return boolean;
function fait_emprunt (v_adh adherent.noadh%type)return boolean;
procedure p_retard (vcodeg exemplaire.codeg%type,dp date, df date,de date,vnoadh adherent.noadh%type);
procedure chercher_cin2 (x ADHERENT.NCIN%type);
function is_adherent_noadh (x ADHERENT.noadh%type)return boolean;

end;

/
--------------------------------------------------------
--  DDL for Package PA_CATALOGUE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PROJET"."PA_CATALOGUE" AS
function is_existant (x catalogue.titre%type, y catalogue.nomAut%type, z catalogue.prenomAut%type, w catalogue.anEd%type )return boolean;
procedure p_codexp(v_codexp emprunt.codexp%type);
function nbExemplaire_Cat ( vCodeg catalogue.Codeg%type)return number;
function f_codexp(v catalogue.codeg%type) return exemplaire.CODExp%type;
procedure chercher_cat_codeg (x catalogue.codeg%type);
procedure chercher_cat_nomAut(x catalogue.nomaut%type);
procedure chercher_cat_titre (x catalogue.titre%type) ;
procedure chercher_cat_titre_nomaut (x catalogue.titre%type, v catalogue.nomaut%type);
procedure p_disp_non( v_codeg catalogue.codeg%type);
function is_Emprunt ( vCodeg catalogue.Codeg%type)return number;
function nbEmp_Exemplaire ( vCodeg catalogue.Codeg%type)return number;
function nbExemp_Emprunt ( vCodeg catalogue.Codeg%type)return number;
end;

/
--------------------------------------------------------
--  DDL for Package Body PA_ADHERENT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PROJET"."PA_ADHERENT" AS

function is_adherent (x ADHERENT.NCIN%type)
return boolean
is
v number;
begin 
select count(*) into v 
from adherent
where adherent.ncin=x;
if (v>0) then
return true;
end if;
if (x=null or v<=0)  then
return false;
end if ;
end;

function fait_emprunt (v_adh adherent.noadh%type)
return boolean
is
somme number;
begin 
select count(*) into somme
from emprunt
where noadh=v_adh;
if (somme=0) then
return false;
else return true;
end if ;
end;


procedure p_retard (vcodeg exemplaire.codeg%type,dp date, df date,de date,vnoadh adherent.noadh%type)
is
x number;
begin
x:=(df-dp)*2;
if(df-dp)>0 and (df-dp)<=30 then 
insert into RETARD values (vnoadh,vcodeg,de,df,df-dp,'oui');

end if;

if (df-dp)>30 and (df-dp)<90 then
insert into RETARD values (vnoadh,vcodeg,de,df,x,'oui'); 
end if;

if (df-de)>=90 then
 insert into RETARD values (vnoadh,vcodeg,de,df,0,'oui');
 /* Il doit payer le prix du livre*/
end if;
end;


procedure chercher_cin2 (x ADHERENT.NCIN%type) 
is
errisnotadherent EXCEPTION;
v_record adherent%rowtype;
y NUMBER;
Begin
/*ajouter la fonction is_existant*/
select count(*) into y 
from adherent
where adherent.ncin=x;
if (y=0) then RAISE errisnotadherent;
else 
select * into v_record from adherent where adherent.ncin=x;
DBMS_OUTPUT.PUT_LINE('Nom: ' || v_record.nom || ' Prenom ' || v_record.prenom || ' Adresse ' || v_record.adresse || 
' Tel: '|| v_record.tel || ' Date adhesion: '|| v_record.dateadh || ' Email: '|| v_record.email);
end if;
EXCEPTION
WHEN errisnotadherent THEN DBMS_OUTPUT.PUT_LINE('Adherent inexistant');
end;


function is_adherent_noadh (x ADHERENT.noadh%type)
return boolean
is
v number;
begin 
select count(*) into v 
from adherent
where adherent.noadh=x;
if (v>0) then
return true;
else
return false;
end if ;
end;

end;

/
--------------------------------------------------------
--  DDL for Package Body PA_CATALOGUE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PROJET"."PA_CATALOGUE" AS

function is_existant (x catalogue.titre%type, y catalogue.nomAut%type, z catalogue.prenomAut%type, w catalogue.anEd%type )
return boolean
is
v number;
begin 
select count(*) into v 
from catalogue
where upper(catalogue.titre)=upper(x) and upper(catalogue.nomaut)=upper(y) and upper(catalogue.prenomaut)=upper(z) and catalogue.anEd=w;
if (v>0) then
return true;
else return false;
end if ;
end;

procedure p_codexp(v_codexp emprunt.codexp%type) 
as
begin
update exemplaire set exemplaire.disp='non' where upper(exemplaire.codexp) =upper( v_codexp);
end;


function nbExemplaire_Cat ( vCodeg catalogue.Codeg%type)
return number
is
somme number;
begin 
select count(*) into somme
  from exemplaire 
  where exemplaire.Codeg = vCodeg ;
return somme;

end;

function f_codexp(v catalogue.codeg%type) return
exemplaire.CODExp%type as
v_exp exemplaire.codexp%type;
begin
select exemplaire.codexp into v_exp from exemplaire  where codeg=v and disp='oui' and rownum<=1;
update exemplaire set exemplaire.disp='non' where upper(exemplaire.codexp) = upper(v_exp);
return v_exp;
end;


procedure chercher_cat_codeg (x catalogue.codeg%type) 
is
errisnotcatalogue EXCEPTION;
v_record catalogue%rowtype;
y NUMBER;
Begin
select count(*) into y 
from catalogue
where catalogue.codeg=x;
if (y=0) then RAISE errisnotcatalogue;
else 
select * into v_record from catalogue where catalogue.codeg=x;
DBMS_OUTPUT.PUT_LINE('Titre: ' || v_record.titre || ' Nom auteur: ' || v_record.nomaut || ' Prenom auteur: ' || v_record.prenomaut || 
' Année d"edition: '|| v_record.aned || ' Editeur: '|| v_record.editeur || ' prix: '|| v_record.prix);
end if;
EXCEPTION
WHEN errisnotcatalogue THEN DBMS_OUTPUT.PUT_LINE('Adherent inexistant');
end;


procedure chercher_cat_nomAut(x catalogue.nomaut%type) 
is
errisnotcatalogue EXCEPTION;
v_record catalogue%rowtype;
cursor curnomaut is
select * from catalogue
where catalogue.nomaut=x;

y NUMBER;
Begin
select count(*) into y 
from catalogue
where UPPER(catalogue.nomaut)=UPPER(x);
if (y=0) then RAISE errisnotcatalogue;
else 
open curnomaut;
loop
fetch curnomaut into v_record;
exit when curnomaut%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Codeg: ' || v_record.codeg || ' Titre: ' || v_record.nomaut || ' Prenom auteur: ' || v_record.prenomaut || 
' Année d"edition: '|| v_record.aned || ' Editeur: '|| v_record.editeur || ' prix: '|| v_record.prix);
end loop;
end if;
EXCEPTION
WHEN errisnotcatalogue THEN DBMS_OUTPUT.PUT_LINE('catalogue inexistant');
end;



procedure chercher_cat_titre (x catalogue.titre%type) 
is
errisnotcatalogue EXCEPTION;
v_record catalogue%rowtype;
cursor curtitre is
select * from catalogue
where upper(catalogue.titre)=upper(x);

y NUMBER;
Begin
select count(*) into y 
from catalogue
where upper(catalogue.titre)=upper(x);
if (y=0) then RAISE errisnotcatalogue;
else 
open curtitre;
loop
fetch curtitre into v_record;
exit when curtitre%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Codeg: ' || v_record.codeg || ' Nom auteur: ' || v_record.nomaut || ' Prenom auteur: ' || v_record.prenomaut || 
' Année d"edition: '|| v_record.aned || ' Editeur: '|| v_record.editeur || ' prix: '|| v_record.prix);
end loop;
end if;
EXCEPTION
WHEN errisnotcatalogue THEN DBMS_OUTPUT.PUT_LINE('catalogue inexistant');
end;




procedure chercher_cat_titre_nomaut (x catalogue.titre%type, v catalogue.nomaut%type) 
is
errisnotcatalogue EXCEPTION;
v_record catalogue%rowtype;
cursor curtitre_nomaut is
select * from catalogue
where upper(catalogue.titre)=upper(x) and upper(catalogue.nomaut)=upper(v);

y NUMBER;
Begin
/*select count(*) into y 
from catalogue
where catalogue.titre=x and catalogue.nomaut=v;
if (y=0) then RAISE errisnotcatalogue;*/

open curtitre_nomaut;
loop
fetch curtitre_nomaut into v_record;
if curtitre_nomaut%rowcount=0 then raise errisnotcatalogue; 
end if;
/*exit when curtitre_nomaut%NOTFOUND;*/

DBMS_OUTPUT.PUT_LINE('Codeg: ' || v_record.codeg || ' Prenom auteur: ' || v_record.prenomaut || 
' Année d"edition: '|| v_record.aned || ' Editeur: '|| v_record.editeur || ' prix: '|| v_record.prix);
end loop;

EXCEPTION
WHEN errisnotcatalogue THEN DBMS_OUTPUT.PUT_LINE('catalogue inexistant');
end;


procedure p_disp_non( v_codeg catalogue.codeg%type)
is
cursor cur_disp is
select codexp from exemplaire   where codeg=v_codeg for update of disp;
v_codexp EXEMPLAIRE.CODEXP%type;
begin
open cur_disp; 
loop
fetch cur_disp into v_codexp;
Exit when cur_disp%NOTFOUND;
update exemplaire set exemplaire.disp='non' where current of cur_disp;
end loop;
close cur_disp;
end;



function is_Emprunt ( vCodeg catalogue.Codeg%type)
return number
is
somme number;
begin 
select count(*) into somme
  from emprunt e, exemplaire ex 
  where ex.codeg=vCodeg and upper(ex.codexp)=upper(e.codexp);
return somme;
end;





function nbEmp_Exemplaire ( vCodeg catalogue.Codeg%type)
return number
is
somme number;
begin 
select count(*) into somme
  from emprunt emp, exemplaire exemp 
  where upper(emp.codexp)=upper(exemp.codexp) and exemp.CODEG=vCodeg;
return somme;
end;


function nbExemp_Emprunt ( vCodeg catalogue.Codeg%type)
return number
is
somme number;
begin 
select count(*) into somme
  from exemplaire 
  where exemplaire.codeg=vCodeg;
return somme;
end;

end;

/
