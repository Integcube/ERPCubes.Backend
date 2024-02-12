Select * from "CrmEmail"
Select * from  "CrmUserActivityLog"
Select * from  "CrmMeeting"
Select * from  "CrmTask"
Select * from "CrmCalenderEvents"
Select * from "CrmCalendarEventsType"


Alter table "CrmCalenderEvents" add "ActivityId" int not null default -1;
Alter table "CrmCalenderEvents" add "ContactTypeId" int not null default -1;

Alter table "CrmCalenderEvents" drop column "IsLead"; 
Alter table "CrmCalenderEvents" drop column  "IsCompany";
Alter table "CrmCalenderEvents" drop column "IsOpportunity" ;

Alter table "CrmUserActivityLog" drop column "IsLead"; 
Alter table "CrmUserActivityLog" drop column  "IsCompany";
Alter table "CrmUserActivityLog" drop column "IsOpportunity" ;
Alter table "CrmUserActivityLog" add "ContactTypeId" int not null default -1;
Alter table "CrmUserActivityLog" add "ContactActivityId" int not null default -1;
Alter table "CrmUserActivityLog" add "Action" text;

Alter table "CrmCall" drop column "IsLead"; 
Alter table "CrmCall" drop column  "IsCompany";
Alter table "CrmCall" drop column "IsOpportunity" ;
Alter table "CrmCall" add "ContactTypeId" int not null default -1;

Alter table "CrmTask" drop column "IsLead"; 
Alter table "CrmTask" drop column  "IsCompany";
Alter table "CrmTask" drop column "IsOpportunity" ;
Alter table "CrmTask" add "ContactTypeId" int not null default -1;
Alter table "CrmTask" add "TaskTypeId" int not null default 5;


Alter table "CrmEmail" drop column "IsLead"; 
Alter table "CrmEmail" drop column  "IsCompany";
Alter table "CrmEmail" drop column "IsOpportunity" ;
Alter table "CrmEmail" add "ContactTypeId" int not null default -1;

Alter table "CrmMeeting" drop column "IsLead"; 
Alter table "CrmMeeting" drop column  "IsCompany";
Alter table "CrmMeeting" drop column "IsOpportunity" ;
Alter table "CrmMeeting" add "ContactTypeId" int not null default -1;


Alter table "CrmNote" drop column "IsLead"; 
Alter table "CrmNote" drop column  "IsCompany";
Alter table "CrmNote" drop column "IsOpportunity" ;
Alter table "CrmNote" add "ContactTypeId" int not null default -1;



