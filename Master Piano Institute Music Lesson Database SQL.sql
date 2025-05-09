-- This database models the music lessons and studio booking system of Master Piano Institute.
-- There are three kinds of Lesson tokens (Private, Online & Group) with different musicial skill and level.
-- Customer can purchase them and use the token to reserve lessons. 
-- For each private and group lessons, a teaching studio is dedicated to the lessons with a speific studio booking number.
-- Customer can also purchase studio credit token to hire studio room for practising.
-- For more information about the Master Piano Institute and its offerings,
-- please visit their official website at https://www.masterpianoinstitute.com/.


DROP VIEW TeacherPrivateLesson CASCADE;

DROP TABLE Customer CASCADE;
DROP TABLE MusicStudioInstrumentHire CASCADE;
DROP TABLE StudioBooking CASCADE;
DROP TABLE Payment CASCADE;
DROP TABLE LessonPackageToken CASCADE;
DROP TABLE StudioCreditToken CASCADE;
DROP TABLE MusicTeacher CASCADE;
DROP TABLE PrivateLesson CASCADE;
DROP TABLE OnlineLesson CASCADE;
DROP TABLE GroupLessonAvailable CASCADE;
DROP TABLE CustomerGroupLesson CASCADE;

CREATE TABLE Customer 
(
  CustomerID    integer,
  customerName  TEXT NOT NULL,
  gender        char(1),
  phoneNo       char(10),
  emailAddress  TEXT NOT NULL,
  address       TEXT NOT NULL,
  customerSkill TEXT[],

  CONSTRAINT CustomerPK PRIMARY KEY (CustomerID),
  CONSTRAINT Customer_gender CHECK (gender IN ('M', 'F')),
  CONSTRAINT Customer_emailAddress CHECK (emailAddress LIke '%@%')
);


CREATE TABLE MusicStudioInstrumentHire 
(
  RoomNo               char(2),
  InstrumentType       TEXT NOT NULL,
  InstrumentQuantity   integer,
  MaximumCapacity      integer,
  halfHourFee          integer,
  hourFee              integer,
  CONSTRAINT MusicStudioInstrumentHirePK PRIMARY KEY (RoomNo,InstrumentType,MaximumCapacity,InstrumentQuantity),
  CONSTRAINT di_table_MusicStudioInstrumentHire_InstrumentType CHECK (InstrumentType IN (
                'Grand Piano',
                'Upright Piano',
                'Digital Piano',
                'Guitar',
                'Cello',
                'Violin',
                'Acoustic Drums Set',
                'Digital Drums Set',
                'Cajon')),

  CONSTRAINT di_table_MusicStudioInstrumentHire_RoomNo CHECK (RoomNo IN (
                '1a', '1b', '1c','1d','1e','1f','1','2','3','4','5','6','7')),
  
  CONSTRAINT di_table_MusicStudioInstrumentHire_halfHourFee CHECK (halfHourFee < hourFee)
);




CREATE TABLE Payment 
(
  TranscationNo   integer,
  DepositAmount   integer,
  CustomerID      integer,
  paymentMethod   TEXT NOT NULL,
  paymentDatetime TIMESTAMP,
  CONSTRAINT PaymentPK PRIMARY KEY (TranscationNo, DepositAmount),
  CONSTRAINT PaymentFK_Customer FOREIGN KEY (CustomerID) REFERENCES Customer 
                 ON DELETE RESTRICT ON UPDATE CASCADE ,
  CONSTRAINT di_table_Payment_paymentMethod CHECK (paymentMethod IN (
                'Card', 
                'Cash',
                'Paypal'))
);


CREATE TABLE LessonPackageToken
(
  LessonTokenNo    integer,
  Skill            TEXT NOT NULL,
  Level            integer ,
  LessonDuration   INTERVAL HOUR TO MINUTE,
  CustomerID       integer,
  TranscationNo    integer,
  lessonFormat     TEXT NOT NULL,
  noOfLessonRemain integer,
  DepositAmount    integer,

  CONSTRAINT LessonPackageTokenPK PRIMARY KEY (LessonTokenNo,Skill, Level, LessonDuration),
  CONSTRAINT LessonPackageTokenFK_Customer FOREIGN KEY (CustomerID) REFERENCES Customer 
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT LessonPackageTokenFK_Payment FOREIGN KEY (TranscationNo, DepositAmount) REFERENCES Payment 
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT di_table_LessonPackageToken_Skill CHECK (Skill IN(
                'Piano',
                'Cello', 
                'Violin', 
                'Drums', 
                'Vocal', 
                'Music Composition')),
  CONSTRAINT di_table_LessonPackageToken_lessonFormat CHECK (lessonFormat IN(
                'Private',
                'Group',
                'Online' ))

);


CREATE TABLE StudioCreditToken 
(
  CreditTokenNo   integer,
  CustomerID      integer,
  TranscationNo   integer,
  DepositAmount   integer,
  remainValue     integer,

  CONSTRAINT StudioCreditTokenPK PRIMARY KEY (CreditTokenNo),
  CONSTRAINT StudioCreditTokenFK_Customer FOREIGN KEY (CustomerID) REFERENCES Customer 
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT StudioCreditTokenFK_Payment FOREIGN KEY (TranscationNo, DepositAmount) REFERENCES Payment
             ON DELETE RESTRICT ON UPDATE CASCADE

);

CREATE TABLE StudioBooking
(
  StudioBookingNo    integer,
  DatetimeStart      TIMESTAMP,
  DatetimeEnd        TIMESTAMP,
  CustomerID         integer,
  CreditTokenNo      integer,
  RoomNo             char(2),
  InstrumentType     TEXT NOT NULL,
  InstrumentQuantity integer,
  MaximumCapacity    integer,  
  noOfPeople         integer,
  studioDuration     INTERVAL HOUR TO MINUTE,
  bookingPrice       integer,
  

  
  CONSTRAINT StudioBookingPK PRIMARY KEY (StudioBookingNo, DatetimeStart, DatetimeEnd),
  CONSTRAINT StudioBookingFK_Customer FOREIGN KEY (CustomerID) REFERENCES Customer ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT StudioBookingFK_StudioCreditToken FOREIGN KEY (CreditTokenNo) 
            REFERENCES StudioCreditToken ON DELETE RESTRICT ON UPDATE CASCADE,   
  CONSTRAINT StudioBookingFK_MusicStudioInstrumentHire FOREIGN KEY (RoomNo,InstrumentType,MaximumCapacity,InstrumentQuantity) 
            REFERENCES MusicStudioInstrumentHire ON DELETE CASCADE ON UPDATE CASCADE
            
);

CREATE TABLE MusicTeacher 
(
  TeacherID      integer,
  teacherName    TEXT NOT NULL,
  teacherSkill   TEXT NOT NULL,
  supervisorID   integer,  

  CONSTRAINT MusicTeacherPK PRIMARY KEY (TeacherID),
  CONSTRAINT MusicTeacherFK FOREIGN KEY (supervisorID) REFERENCES MusicTeacher (TeacherID)
             ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT di_table_MusicTeacher_skill CHECK (teacherSkill IN(
                 'Piano',
                 'Cello',
                 'Violin',
                 'Drums',
                 'Vocal',
                 'Music Composition'))

);

CREATE TABLE OnlineLesson
(
  OnlineLessonNo     integer,
  TeacherID          integer,
  CustomerID         integer,
  LessonTokenNo      integer,
  Skill              TEXT NOT NULL,
  Level              integer,
  LessonDuration     INTERVAL HOUR TO MINUTE,
  datetimeStart      TIMESTAMP,
  datetimeEnd        TIMESTAMP,
  lessonStatus       TEXT NOT NULL,

  CONSTRAINT OnlineLessonPK PRIMARY KEY (OnlineLessonNo),
  CONSTRAINT OnlineLessonFK_MusicTeacher FOREIGN KEY (TeacherID) REFERENCES MusicTeacher 
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT OnlineLessonFK_Customer FOREIGN KEY (CustomerID) REFERENCES Customer
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT OnlineLessonFK_LessonPackageToken FOREIGN KEY (LessonTokenNo, Skill, Level, LessonDuration) 
                             REFERENCES LessonPackageToken ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT di_table_OnlineLesson_skill CHECK (Skill IN(
             'Piano',
             'Cello',
             'Violin',
             'Drums',
             'Vocal',
             'Music Composition')),  

  CONSTRAINT di_table_OnlineLesson_lessonStatus CHECK (lessonStatus IN(
             'Pending',
             'Completed',
             'Cancelled'))                               
);


CREATE TABLE PrivateLesson 
(
  PrivateLessonNo    integer,
  TeacherID          integer,
  CustomerID         integer,
  StudioBookingNo    integer,
  LessonTokenNo      integer,
  Skill              TEXT NOT NULL,
  Level              integer,
  DatetimeStart      TIMESTAMP,
  DatetimeEnd        TIMESTAMP,
  LessonDuration     INTERVAL HOUR TO MINUTE,
  lessonStatus       TEXT NOT NULL,
  CONSTRAINT PrivateLessonPK PRIMARY KEY (PrivateLessonNo),
  CONSTRAINT PrivateLessonFK_Customer FOREIGN KEY (CustomerID) REFERENCES Customer 
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT PrivateLessonFK_MusicTeacher FOREIGN KEY (TeacherID) REFERENCES MusicTeacher
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT PrivateLessonFK_LessonPackageToken FOREIGN KEY (LessonTokenNo, Skill, Level, LessonDuration) 
             REFERENCES LessonPackageToken ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT PrivateLessonFK_StudioBooking FOREIGN KEY (StudioBookingNo, DatetimeStart, DatetimeEnd) 
                             REFERENCES StudioBooking ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT di_table_PrivateLesson_skill CHECK (Skill IN(
             'Piano',
             'Cello',
             'Violin',
             'Drums',
             'Vocal',
             'Music Composition')),

  CONSTRAINT di_table_PrivateLesson_lessonStatus CHECK (lessonStatus IN(
             'Pending',
             'Completed',
             'Cancelled'))               

);


Create TABLE GroupLessonAvailable
(
  GroupLessonNo       integer,
  TeacherID     integer,
  StudioBookingNo    integer,
  DatetimeStart      TIMESTAMP,
  DatetimeEnd        TIMESTAMP,
  lessonStatus       TEXT NOT NULL,

  CONSTRAINT GroupLessonAvailablePK PRIMARY KEY (GroupLessonNo),
  CONSTRAINT GroupLessonAvailableFK_MusicTeacher FOREIGN KEY (TeacherID) REFERENCES MusicTeacher 
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT GroupLessonAvailableFK_StudioBooking FOREIGN KEY (StudioBookingNo, DatetimeStart, DatetimeEnd) 
             REFERENCES StudioBooking ON DELETE RESTRICT ON UPDATE CASCADE,
  
  CONSTRAINT di_table_GroupLessonAvailable_lessonStatus CHECK (lessonStatus IN(
             'Pending',
             'Completed',
             'Cancelled'))   

);

Create TABLE CustomerGroupLesson
(
  GroupLessonNo     integer,
  CustomerID        integer,
  LessonTokenNo    integer,
  Skill            TEXT NOT NULL,
  Level            integer ,
  LessonDuration   INTERVAL HOUR TO MINUTE,

  CONSTRAINT CustomerGroupLessonPK PRIMARY KEY (CustomerID, GroupLessonNo),
  CONSTRAINT CustomerGroupLessonFK_Customer FOREIGN KEY (CustomerID) REFERENCES Customer
             ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT CustomerGroupLessonFK_GroupLessonNo FOREIGN KEY (GroupLessonNo) REFERENCES GroupLessonAvailable
             ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT CustomerGroupLessonFK_LessonPackageToken FOREIGN KEY (LessonTokenNo, Skill, Level, LessonDuration) 
             REFERENCES LessonPackageToken ON DELETE RESTRICT ON UPDATE CASCADE                           
  
);

Create VIEW TeacherPrivateLesson AS
  Select TeacherID, teacherName, PrivateLessonNo, Skill As LessonType, DatetimeStart, DatetimeEnd 
        FROM MusicTeacher natural join PrivateLesson natural join StudioBooking natural join LessonPackageToken
        ORDER BY TeacherID, DatetimeStart;



Insert INTO Customer VALUES(123456, 'Peter CHAN',    'M', '0432123456','peterCHAN@email.com', '123/321 Harris St, Ultimo NSW 2007', '{Piano Level 4}');
Insert INTO Customer VALUES(789012, 'Mary Coker',    'F', '0412345666','maryc@email.com', '234/213 Gottenham St, Glebe NSW 2037', '{Cello Level 8, Piano Level 0}');
Insert INTO Customer VALUES(987654, 'Sarah Ott',     'F', '0455666777','sarahOtt@email.com', '502/25 Harris St, Ultimo NSW 2007', '{Piano Level 2}');
Insert INTO Customer VALUES(345678, 'Gary Cruise',   'M', '0499888999', 'garyC@email.com', '111/43 Park Road, Hurstville NSW 2220', '{Piano Level 0}');
Insert INTO Customer VALUES(442266, 'Taki Ryu',      'M', '0411335577', 'tkryu@email.com', '88 Kitchener Ave, Earlwood NSW 2206',   '{Piano Level 0}');
Insert INTO Customer VALUES(557711, 'Amadeus Mayor', 'M', '0481818181', 'amadeusM@email.com', '69 Reserve St, Neutral Bay NSW 2089','{Piano Level 0}');


Insert INTO Payment VALUES(88880001,550,123456,'Cash','2023-03-29 10:30:00');
Insert INTO Payment VALUES(88880002,730,789012, 'Card','2023-03-30 11:25:00');
Insert INTO Payment VALUES(99990001,800,123456, 'Paypal','2023-03-29 10:35:00');
Insert INTO Payment VALUES(99990011,800,123456, 'Paypal','2023-03-29 10:36:00');
Insert INTO Payment VALUES(99990002,400,789012, 'Paypal','2023-04-01 12:20:00');
Insert INTO Payment VALUES(88880003,425,987654, 'Paypal','2023-03-28 13:47:00');
Insert INTO Payment VALUES(88880004,290,789012, 'Card','2023-03-30 11:26:00');
Insert INTO Payment VALUES(71717171,510,345678, 'Cash','2023-03-22 10:40:00');
Insert INTO Payment VALUES(42424242,510,442266, 'Card','2023-03-21 11:11:00');
Insert INTO Payment VALUES(95959595,510,557711, 'Card','2023-03-10 12:15:00');

Insert INTO MusicStudioInstrumentHire VALUES('1a', 'Digital Piano',   1, 1, 10, 15);
Insert INTO MusicStudioInstrumentHire VALUES('1b', 'Digital Piano',   1, 1, 10, 15);
Insert INTO MusicStudioInstrumentHire VALUES('1c', 'Digital Piano',   1, 1, 10, 15);
Insert INTO MusicStudioInstrumentHire VALUES('1d', 'Digital Piano',   1, 1, 10, 15);
Insert INTO MusicStudioInstrumentHire VALUES('1e', 'Digital Piano',   1, 1, 10, 15);
Insert INTO MusicStudioInstrumentHire VALUES('1f', 'Digital Piano',   1, 1, 10, 15);
Insert INTO MusicStudioInstrumentHire VALUES('1', 'Digital Piano',    6, 6, 60, 90);
Insert INTO MusicStudioInstrumentHire VALUES('2',  'Upright Piano',   1, 4, 15,25);
Insert INTO MusicStudioInstrumentHire VALUES('2', 'Violin',           1, 4, 15,25);
Insert INTO MusicStudioInstrumentHire VALUES('2', 'Guitar',           1, 4, 15,25);
Insert INTO MusicStudioInstrumentHire VALUES('2', 'Cello',            1, 4, 15,25);
Insert INTO MusicStudioInstrumentHire VALUES('2', 'Digital Drums Set',1, 4, 15,25);
Insert INTO MusicStudioInstrumentHire VALUES('2', 'Cajon',            1, 4, 15,25);
Insert INTO MusicStudioInstrumentHire VALUES('3', 'Grand Piano',      1, 2, 25,40);
Insert INTO MusicStudioInstrumentHire VALUES('4', 'Grand Piano',      1, 6, NULL,60);
Insert INTO MusicStudioInstrumentHire VALUES('5', 'Grand Piano',      2, 2, NULL,60);
Insert INTO MusicStudioInstrumentHire VALUES('5', 'Grand Piano',      2, 6, NULL,80);
Insert INTO MusicStudioInstrumentHire VALUES('6', 'Acoustic Drums Set', 1, 2, 15,25);
Insert INTO MusicStudioInstrumentHire VALUES('7', 'Digital Drums Set', 1, 2, 15,25);

Insert INTO LessonPackageToken VALUES(90001, 'Piano', 4,'60', 123456, 88880001,'Private', 5, 550);
Insert INTO LessonPackageToken VALUES(90002, 'Cello', 8,'60', 789012, 88880002,'Private', 4, 730);
Insert INTO LessonPackageToken VALUES(90003, 'Piano', 2, '45', 987654, 88880003, 'Online',3, 425);
Insert INTO LessonPackageToken VALUES(90004, 'Piano', 0, '60', 345678, 71717171, 'Group',6, 510);
Insert INTO LessonPackageToken VALUES(90005, 'Piano', 0, '60', 442266, 42424242, 'Group',3, 510);
Insert INTO LessonPackageToken VALUES(90006, 'Piano', 0, '60', 557711, 95959595, 'Group',8, 510);
Insert INTO LessonPackageToken VALUES(90007, 'Piano', 0,'30', 789012, 88880004,'Private', 4, 290);

Insert INTO StudioCreditToken VALUES(80001, 123456, 99990001, 800, 450);
Insert INTO StudioCreditToken VALUES(80002, 789012, 99990002, 400, 220);
Insert INTO StudioCreditToken VALUES(80011, 123456, 99990011, 800, 800);

Insert INTO StudioBooking VALUES(10001,'2023-04-26 09:30:00','2023-04-26 10:30:00', 123456,80001,'1a','Digital Piano',1,1,1,'60',15);
Insert INTO StudioBooking VALUES(10002,'2023-04-26 12:30:00','2023-04-26 14:30:00', 789012,80002,'5','Grand Piano',   2,6,4,'2:00',160);
Insert INTO StudioBooking VALUES(10003,'2023-04-26 10:30:00','2023-04-26 11:30:00', 123456,NULL,'2', 'Upright Piano',1,4,2,'60', NULL);
Insert INTO StudioBooking VALUES(10011,'2023-05-03 09:30:00','2023-05-03 10:30:00', 123456,80001,'1a','Digital Piano',1,1,1,'60',15);
Insert INTO StudioBooking VALUES(10004,'2023-05-03 10:30:00','2023-05-03 11:30:00', 123456,NULL,'2', 'Upright Piano',1,4,2,'60', NULL);
Insert INTO StudioBooking VALUES(10005,'2023-05-10 10:30:00','2023-05-10 11:30:00', 123456,NULL,'2', 'Upright Piano',1,4,2,'60', NULL);
Insert INTO StudioBooking VALUES(10010,'2023-05-09 10:30:00','2023-05-09 11:30:00', 789012,NULL,'2', 'Cello',        1,4,2,'60', NULL);
Insert INTO StudioBooking VALUES(10012,'2023-05-09 12:30:00','2023-05-09 13:30:00', 789012,80002,'5','Grand Piano',   2,6,4,'60',80);
Insert INTO StudioBooking VALUES(10066,'2023-05-04 10:00:00','2023-05-04 11:00:00', 345678,NULL,'1', 'Digital Piano',6,6,4,'60', NULL);
Insert INTO StudioBooking VALUES(10067,'2023-05-20 10:00:00','2023-05-20 11:00:00', 345678,NULL,'1', 'Digital Piano',6,6,4,'60', NULL);
Insert INTO StudioBooking VALUES(10099,'2023-04-26 10:30:00','2023-05-24 11:00:00', 789012,NULL,'2', 'Upright Piano',1,4,2,'30', NULL);

Insert INTO MusicTeacher VALUES(19923, 'Agim Hushi', 'Vocal', NULL);
Insert INTO MusicTeacher VALUES(21212, 'Angela Kyung', 'Piano', 19923);
Insert INTO MusicTeacher VALUES(31333, 'Aleksandar Zivkovic', 'Cello', NULL);
Insert INTO MusicTeacher VALUES(26666, 'Lia Li', 'Piano', 21212);
Insert INTO MusicTeacher VALUES(27653, 'Mattina Su', 'Violin', 31333);
Insert INTO MusicTeacher VALUES(26543, 'Toby Dunan', 'Drums',NULL);
Insert INTO MusicTeacher VALUES(22345, 'Shane Tartakover', 'Music Composition', 21212);

Insert INTO PrivateLesson VALUES(70001, 21212, 123456, 10003, 90001,'Piano',4,'2023-04-26 10:30:00','2023-04-26 11:30:00','60', 'Completed');
Insert INTO PrivateLesson VALUES(70002, 21212, 123456, 10004, 90001,'Piano',4,'2023-05-03 10:30:00','2023-05-03 11:30:00','60', 'Pending');
Insert INTO PrivateLesson VALUES(70003, 21212, 123456, 10005, 90001,'Piano',4,'2023-05-10 10:30:00','2023-05-10 11:30:00','60', 'Pending');
Insert INTO PrivateLesson VALUES(70004, 31333, 789012, 10010, 90002,'Cello',8,'2023-05-09 10:30:00','2023-05-09 11:30:00','60', 'Pending');
Insert INTO PrivateLesson VALUES(70005, 26666, 789012, 10099, 90007,'Piano',0,'2023-04-26 10:30:00','2023-05-24 11:00:00','30', 'Pending');

Insert INTO OnlineLesson VALUES(44441, 21212, 987654, 90003, 'Piano', 2, '45','2023-05-22 14:30:00','2023-05-22 15:15:00', 'Pending');
Insert INTO OnlineLesson VALUES(44442, 21212, 987654, 90003, 'Piano', 2, '45','2023-05-30 14:30:00','2023-05-30 15:15:00', 'Pending');

Insert INTO GroupLessonAvailable VALUES(66666,26666,10066,'2023-05-04 10:00:00','2023-05-04 11:00:00','Pending');
Insert INTO GroupLessonAvailable VALUES(66677,26666,10067,'2023-05-20 10:00:00','2023-05-20 11:00:00','Pending');

Insert INTO CustomerGroupLesson VALUES(66666,345678,90004,'Piano',0,'60');
Insert INTO CustomerGroupLesson VALUES(66666,557711,90006,'Piano',0,'60');
Insert INTO CustomerGroupLesson VALUES(66677,345678,90004,'Piano',0,'60');
Insert INTO CustomerGroupLesson VALUES(66677,442266,90005,'Piano',0,'60');

