PGDMP                       |            ERPCubes    16.1    16.1 (   #           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            $           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            %           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            &           1262    16398    ERPCubes    DATABASE     �   CREATE DATABASE "ERPCubes" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "ERPCubes";
                postgres    false                        3079    16399    postgres_fdw 	   EXTENSION     @   CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;
    DROP EXTENSION postgres_fdw;
                   false            '           0    0    EXTENSION postgres_fdw    COMMENT     [   COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';
                        false    2            �           1255    16406    calculateleadevent(integer)    FUNCTION     �
  CREATE FUNCTION public.calculateleadevent(tenantid_value integer) RETURNS TABLE("Leadowner" text, "LeadOwnerName" text, "Lead" bigint, "Note" bigint, "Call" bigint, "Email" bigint, "Task" bigint, "Meeting" bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    CREATE TEMP TABLE temp_table_name (
        LeadOwnerId text,
        Countz INT,
        Type INT
    );

    INSERT INTO temp_table_name
    -- note
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 1 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmNote" AS crmn ON crml."LeadId" = crmn."Id" AND crmn."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    GROUP BY crml."LeadOwner"

    UNION ALL
    -- call
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 2 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmCall" AS crmc ON crml."LeadId" = crmc."Id" AND crmc."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    GROUP BY crml."LeadOwner"

    UNION ALL
    -- email
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 3 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmEmail" AS crme ON crml."LeadId" = crme."Id" AND crme."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    GROUP BY crml."LeadOwner"

    UNION ALL
    -- task
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 4 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmTask" AS crmt ON crml."LeadId" = crmt."Id" AND crmt."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    GROUP BY crml."LeadOwner"

    UNION ALL
    -- lead
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 5 as Type
    FROM "CrmLead" AS crml 
    WHERE crml."TenantId" = tenantId_value
    GROUP BY crml."LeadOwner"

    UNION ALL
    -- meeting
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 6 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmMeeting" AS crmm ON crml."LeadId" = crmm."Id" AND crmm."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    GROUP BY crml."LeadOwner";

RETURN QUERY
SELECT 
    t.LeadOwnerId as "Leadowner",
    CONCAT(users."FirstName", ' ', users."LastName") as "LeadOwnerName",
    SUM(CASE WHEN t.Type = 5 THEN t.Countz END)::bigint as "Lead",
    SUM(CASE WHEN t.Type = 1 THEN t.Countz END)::bigint AS "Note",
    SUM(CASE WHEN t.Type = 2 THEN t.Countz END)::bigint AS "Call",
    SUM(CASE WHEN t.Type = 3 THEN t.Countz END)::bigint AS "Email",
    SUM(CASE WHEN t.Type = 4 THEN t.Countz END)::bigint AS "Task",
    SUM(CASE WHEN t.Type = 6 THEN t.Countz END)::bigint AS "Meeting"
FROM temp_table_name t
INNER JOIN db2_aspnetusers users ON t.leadownerid = users."Id"
GROUP BY "Leadowner",users."FirstName",users."LastName";

    DROP TABLE IF EXISTS temp_table_name;

    RETURN;
END;
$$;
 A   DROP FUNCTION public.calculateleadevent(tenantid_value integer);
       public          postgres    false                       1255    18796 B   calculateleadevent(integer, date, date, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.calculateleadevent(tenantid_value integer, startdate date, enddate date, product integer, projectid integer, status integer) RETURNS TABLE("Leadowner" text, "LeadOwnerName" text, "Lead" bigint, "Note" bigint, "Call" bigint, "Email" bigint, "Task" bigint, "Meeting" bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    CREATE TEMP TABLE temp_table_name (
        LeadOwnerId text,
        Countz INT,
        Type INT
    );

    INSERT INTO temp_table_name
    -- note
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 1 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmNote" AS crmn ON crml."LeadId" = crmn."Id" AND crmn."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    WHERE crmn."CreatedDate" BETWEEN startdate AND enddate
    AND (crml."ProductId" = product OR product = -1) AND (crml."Status" = status OR status = -1)
    GROUP BY crml."LeadOwner";

    INSERT INTO temp_table_name
    -- call
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 2 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmCall" AS crmc ON crml."LeadId" = crmc."Id" AND crmc."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
        AND (crml."ProductId" = product OR product = -1) AND (crml."Status" = status OR status = -1)
        INNER JOIN "CrmProduct" AS pro ON crml."ProductId" = pro."ProductId" AND (pro."ProjectId" = projectId OR projectId = -1)
    WHERE crmc."CreatedDate" BETWEEN startdate AND enddate
    GROUP BY crml."LeadOwner";

    INSERT INTO temp_table_name
    -- email
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 3 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmEmail" AS crme ON crml."LeadId" = crme."Id" AND crme."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    WHERE crme."CreatedDate" BETWEEN startdate AND enddate
    AND (crml."ProductId" = product OR product = -1) AND (crml."Status" = status OR status = -1)
    GROUP BY crml."LeadOwner";

    INSERT INTO temp_table_name
    -- task
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 4 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmTask" AS crmt ON crml."LeadId" = crmt."Id" AND crmt."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    WHERE crmt."CreatedDate" BETWEEN startdate AND enddate
    AND (crml."ProductId" = product OR product = -1) AND (crml."Status" = status OR status = -1)
    GROUP BY crml."LeadOwner";

    INSERT INTO temp_table_name
    -- lead
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 5 as Type
    FROM "CrmLead" AS crml 
    WHERE crml."TenantId" = tenantId_value AND crml."CreatedDate" BETWEEN startdate AND enddate
    AND (crml."ProductId" = product OR product = -1) AND (crml."Status" = status OR status = -1)
    GROUP BY crml."LeadOwner";

    INSERT INTO temp_table_name
    -- meeting
    SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 6 as Type
    FROM "CrmLead" AS crml
    INNER JOIN "CrmMeeting" AS crmm ON crml."LeadId" = crmm."Id" AND crmm."ContactTypeId" = 1 AND crml."TenantId" = tenantId_value
    WHERE crmm."CreatedDate" BETWEEN startdate AND enddate
    AND (crml."ProductId" = product OR product = -1) AND (crml."Status" = status OR status = -1)
    GROUP BY crml."LeadOwner";

    RETURN QUERY
    SELECT 
        t.LeadOwnerId as "Leadowner",
        CONCAT(users."FirstName", ' ', users."LastName") as "LeadOwnerName",
        SUM(CASE WHEN t.Type = 5 THEN t.Countz END)::bigint as "Lead",
        SUM(CASE WHEN t.Type = 1 THEN t.Countz END)::bigint AS "Note",
        SUM(CASE WHEN t.Type = 2 THEN t.Countz END)::bigint AS "Call",
        SUM(CASE WHEN t.Type = 3 THEN t.Countz END)::bigint AS "Email",
        SUM(CASE WHEN t.Type = 4 THEN t.Countz END)::bigint AS "Task",
        SUM(CASE WHEN t.Type = 6 THEN t.Countz END)::bigint AS "Meeting"
    FROM temp_table_name t
    INNER JOIN db2_aspnetusers users ON t.leadownerid = users."Id"
    GROUP BY "Leadowner", users."FirstName", users."LastName";

    DROP TABLE IF EXISTS temp_table_name;

    RETURN;
END;
$$;
 �   DROP FUNCTION public.calculateleadevent(tenantid_value integer, startdate date, enddate date, product integer, projectid integer, status integer);
       public          postgres    false            �           1255    16407 (   calculateleadeventcountsbyowner(integer)    FUNCTION     �	  CREATE FUNCTION public.calculateleadeventcountsbyowner(tenantid_value integer) RETURNS TABLE(leadownerid text, leadidcount bigint, noteidcount bigint, callidcount bigint, emailidcount bigint, taskidcount bigint, meetingidcount bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    CREATE TEMP TABLE temp_table_name (
        LeadOwnerId text,
        Countz INT,
        Type INT
    );

   INSERT INTO temp_table_name
--note
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 1 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmNote" AS crmn ON crml."LeadId" = crmn."Id" AND crmn."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--call
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 2 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmCall" AS crmc ON crml."LeadId" = crmc."Id" AND crmc."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--email
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 3 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmEmail" AS crme ON crml."LeadId" = crme."Id" AND crme."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--task
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 4 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmTask" AS crmt ON crml."LeadId" = crmt."Id" AND crmt."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--lead
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 5 as Type
FROM "CrmLead" AS crml where crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--meeting
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 6 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmMeeting" AS crmm ON crml."LeadId" = crmm."Id" AND crmm."IsLead" = tenantId_value
Group By crml."LeadOwner";

    RETURN QUERY
    SELECT 
        t.LeadOwnerId,
        SUM(CASE WHEN t.Type = 5 THEN t.Countz END)::bigint as LeadIdCount,
        SUM(CASE WHEN t.Type = 1 THEN t.Countz END)::bigint AS NoteIdCount,
        SUM(CASE WHEN t.Type = 2 THEN t.Countz END)::bigint AS CallIdCount,
        SUM(CASE WHEN t.Type = 3 THEN t.Countz END)::bigint AS EmailIdCount,
        SUM(CASE WHEN t.Type = 4 THEN t.Countz END)::bigint AS TaskIdCount,
        SUM(CASE WHEN t.Type = 6 THEN t.Countz END)::bigint AS MeetingIdCount
    FROM temp_table_name t
    GROUP BY t.LeadOwnerId;

    DROP TABLE IF EXISTS temp_table_name;

    RETURN;
END;
$$;
 N   DROP FUNCTION public.calculateleadeventcountsbyowner(tenantid_value integer);
       public          postgres    false            �           1255    16408 )   calculateleadeventcountsbyowner2(integer)    FUNCTION     t	  CREATE FUNCTION public.calculateleadeventcountsbyowner2(tenantid_value integer) RETURNS TABLE("Leadowner" text, "Lead" bigint, "Note" bigint, "Call" bigint, "Email" bigint, "Task" bigint, "Meeting" bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    CREATE TEMP TABLE temp_table_name (
        LeadOwnerId text,
        Countz INT,
        Type INT
    );

   INSERT INTO temp_table_name
--note
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 1 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmNote" AS crmn ON crml."LeadId" = crmn."Id" AND crmn."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--call
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 2 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmCall" AS crmc ON crml."LeadId" = crmc."Id" AND crmc."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--email
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 3 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmEmail" AS crme ON crml."LeadId" = crme."Id" AND crme."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--task
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 4 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmTask" AS crmt ON crml."LeadId" = crmt."Id" AND crmt."IsLead" = 1 AND crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--lead
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 5 as Type
FROM "CrmLead" AS crml where crml."TenantId" = tenantId_value
Group By crml."LeadOwner"

UNION ALL
--meeting
SELECT crml."LeadOwner" AS LeadOwnerId, count(*) as Countz, 6 as Type
FROM "CrmLead" AS crml
INNER JOIN "CrmMeeting" AS crmm ON crml."LeadId" = crmm."Id" AND crmm."IsLead" = tenantId_value
Group By crml."LeadOwner";

    RETURN QUERY
    SELECT 
        t.LeadOwnerId as "Leadowner",
        SUM(CASE WHEN t.Type = 5 THEN t.Countz END)::bigint as "Lead",
        SUM(CASE WHEN t.Type = 1 THEN t.Countz END)::bigint AS "Note",
        SUM(CASE WHEN t.Type = 2 THEN t.Countz END)::bigint AS "Call",
        SUM(CASE WHEN t.Type = 3 THEN t.Countz END)::bigint AS "Email",
        SUM(CASE WHEN t.Type = 4 THEN t.Countz END)::bigint AS "Task",
        SUM(CASE WHEN t.Type = 6 THEN t.Countz END)::bigint AS "Meeting"
    FROM temp_table_name t
    GROUP BY "Leadowner";

    DROP TABLE IF EXISTS temp_table_name;

    RETURN;
END;
$$;
 O   DROP FUNCTION public.calculateleadeventcountsbyowner2(tenantid_value integer);
       public          postgres    false                        1255    16409 ?   crmcampaignwiserpt(integer, integer, text, integer, date, date)    FUNCTION     ;  CREATE FUNCTION public.crmcampaignwiserpt(tenantid integer, sourceid integer, campaign text, productid integer, startdate date, enddate date) RETURNS TABLE("CampaignId" integer, "CampaignTitle" text, "Source" text, "TotalLeads" integer, "WinLeads" integer, "WinRate" numeric, "ConversionRate" numeric, "TotalCost" numeric, "CostperLead" numeric, "RevenueGenerated" numeric, "ReturnonInvestment" numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        comp."CampaignId",
		comp."Title" AS CampaignTitle,
        COALESCE(LeadSour."SourceTitle", 'Unknow') AS "Source",
        COUNT(lead."LeadId")::integer AS "TotalLeads",
        COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END)::integer AS "ConvertedLeads",
        CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END ::decimal(18,2) AS "ConversionRate",
        0.0::decimal(18,2) AS "AverageDealSize", -- Default value for AverageDealSize
        0.0::decimal(18,2) AS "TotalRevenue"     -- Default value for TotalRevenue
    FROM "CrmCampaign" as comp
	INNER JOIN public."CrmLead" AS lead  on comp."CampaignId"= lead."CampaignId"
    LEFT JOIN public."CrmLeadSource" AS LeadSour ON comp."SourceId" = LeadSour."SourceId"
    WHERE 
	    (SourceId = -1 OR lead."SourceId" = SourceId)
		And lead."TenantId"=TenantId And lead."IsDeleted"=0
        AND DATE(lead."CreatedDate") BETWEEN DATE(Startdate) AND DATE(Enddate)
    GROUP BY lead."SourceId", LeadSour."SourceTitle"
    ORDER BY lead."SourceId";
	RETURN;
END;
$$;
 �   DROP FUNCTION public.crmcampaignwiserpt(tenantid integer, sourceid integer, campaign text, productid integer, startdate date, enddate date);
       public          postgres    false                       1255    18794 @   crmleadownerwiserpt(integer, integer, text, integer, date, date)    FUNCTION     �
  CREATE FUNCTION public.crmleadownerwiserpt(tenantid integer, sourceid integer, leadowner text, status integer, startdate date, enddate date) RETURNS TABLE("LeadOwnerName" text, "LeadOwner" text, "TotalLeads" integer, "TotalRevenue" numeric, "AverageDealSize" numeric, "WinLeads" integer, "WinRate" numeric, "ConvertedLeads" integer, "ConversionRate" numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH OwnerData AS (
        SELECT
            u."FirstName" || ' ' || u."LastName"::text AS "LeadOwnerName",
            lead."LeadOwner"::text AS "LeadOwner",
            COUNT(lead."LeadId")::integer AS "TotalLeads",
            0.0::numeric(18,2) AS "TotalRevenue", 
            0.0::numeric(18,2) AS "AverageDealSize",
            COUNT(CASE WHEN lead."Status" = 6 THEN lead."LeadId" END)::integer AS "WinLeads",
            CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 6 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END::numeric(18,2) AS "WinRate",
            COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END)::integer AS "ConvertedLeads",
            CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END::numeric(18,2) AS "ConversionRate"
        FROM public."CrmLead" AS lead
        INNER JOIN public."db2_aspnetusers" AS u ON lead."LeadOwner" = u."Id"
        WHERE 
            (sourceid = -1 OR lead."SourceId" = sourceid)
            AND (status = -1 OR lead."Status" = status)
            AND (leadowner = '-1' OR lead."LeadOwner" = leadowner)
            AND lead."TenantId" = tenantid AND lead."IsDeleted" = 0
            AND DATE(lead."CreatedDate") BETWEEN DATE(startdate) AND DATE(enddate)
        GROUP BY "LeadOwnerName", lead."LeadOwner" -- Specify the table alias for "LeadOwner"
        ORDER BY "LeadOwnerName"
    )
    SELECT * FROM OwnerData
    UNION
    SELECT
        'Total'::text AS "LeadOwnerName",
        'Total'::text AS "LeadOwner",
        SUM(OwnerData."TotalLeads")::integer AS "TotalLeads",
        COALESCE(SUM(OwnerData."TotalRevenue"), 0.0) AS "TotalRevenue",
        0.0::numeric(18,2) AS "AverageDealSize",
        SUM(OwnerData."WinLeads")::integer AS "WinLeads",
        CASE WHEN SUM(OwnerData."TotalLeads") > 0 THEN (SUM(OwnerData."WinLeads") * 100.0) / SUM(OwnerData."TotalLeads") ELSE 0 END::numeric(18,2) AS "WinRate",
        SUM(OwnerData."ConvertedLeads")::integer AS "ConvertedLeads",
        CASE WHEN SUM(OwnerData."TotalLeads") > 0 THEN (SUM(OwnerData."ConvertedLeads") * 100.0) / SUM(OwnerData."TotalLeads") ELSE 0 END::numeric(18,2) AS "ConversionRate"
    FROM OwnerData;

    RETURN;
END;
$$;
 �   DROP FUNCTION public.crmleadownerwiserpt(tenantid integer, sourceid integer, leadowner text, status integer, startdate date, enddate date);
       public          postgres    false                       1255    18795 2   crmleadsourcewiserpt(integer, integer, date, date)    FUNCTION     v  CREATE FUNCTION public.crmleadsourcewiserpt(tenantid integer, sourceid integer, startdate date, enddate date) RETURNS TABLE("SourceId" integer, "Source" text, "TotalLeads" integer, "ConvertedLeads" integer, "ConversionRate" numeric, "AverageDealSize" numeric, "TotalRevenue" numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH SourceData AS (
        SELECT
            lead."SourceId",
            COALESCE(LeadSour."SourceTitle", 'Unknown') AS "SourceTitle",
            COUNT(lead."LeadId")::integer AS "TotalLeads",
            COALESCE(COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END), 0)::integer AS "ConvertedLeads",
            CASE WHEN COALESCE(COUNT(lead."LeadId"), 0) > 0 THEN (COALESCE(COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END), 0) * 100.0) / COALESCE(COUNT(lead."LeadId"), 0) ELSE 0 END::decimal(18,2) AS "ConversionRate",
            0.0::decimal(18,2) AS "AverageDealSize", -- Default value for AverageDealSize
            0.0::decimal(18,2) AS "TotalRevenue"     -- Default value for TotalRevenue
        FROM public."CrmLead" AS lead
        LEFT JOIN public."CrmLeadSource" AS LeadSour ON lead."SourceId" = LeadSour."SourceId"
        WHERE 
            (SourceId = -1 OR lead."SourceId" = SourceId)
            AND lead."TenantId"=TenantId AND lead."IsDeleted"=0
            AND DATE(lead."CreatedDate") BETWEEN DATE(Startdate) AND DATE(Enddate)
        GROUP BY lead."SourceId", LeadSour."SourceTitle"
        ORDER BY lead."SourceId"
    )
    SELECT * FROM SourceData
    UNION
    SELECT
        99999::integer AS "SourceId",
        'Total' AS "SourceTitle",
        COALESCE(SUM(SourceData."TotalLeads"), 0)::integer AS "TotalLeads",
        COALESCE(SUM(SourceData."ConvertedLeads"), 0)::integer AS "ConvertedLeads",
        CASE WHEN COALESCE(SUM(SourceData."TotalLeads"), 0) > 0 THEN (COALESCE(SUM(SourceData."ConvertedLeads"), 0) * 100.0) / COALESCE(SUM(SourceData."TotalLeads"), 0) ELSE 0 END::decimal(18,2) AS "ConversionRate",
        0.0::decimal(18,2) AS "AverageDealSize",
        0.0::decimal(18,2) AS "TotalRevenue"
    FROM SourceData
    ORDER BY "SourceId";

    RETURN;
END;
$$;
 m   DROP FUNCTION public.crmleadsourcewiserpt(tenantid integer, sourceid integer, startdate date, enddate date);
       public          postgres    false                       1255    18793 C   crmleadstagewiserpt(integer, integer, integer, date, date, integer)    FUNCTION     �  CREATE FUNCTION public.crmleadstagewiserpt(tenantid integer, sourceid integer, status integer, startdate date, enddate date, productid integer) RETURNS TABLE("Status" integer, "StatusTitle" text, "TotalLeads" integer, "TotalLeadValue" numeric, "AverageDealValue" numeric, "ExpectedRevenue" numeric, "Percentage" numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH StatusData AS (
        SELECT
            lead."Status",
            COALESCE(LeadSatus."StatusTitle", 'Unknown') AS "StatusTitle",
            COUNT(lead."LeadId")::integer AS "TotalLeads",
            0.0::decimal(18,2) AS "TotalLeadValue", -- Default value for TotalLeadValue
            0.0::decimal(18,2) AS "AverageDealValue", -- Default value for AverageDealValue,
            0.0::decimal(18,2) AS "ExpectedRevenue", -- Default value for ExpectedRevenue
            CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(lead."LeadId") * 100.0) / SUM(COUNT(lead."LeadId")) OVER () ELSE 0 END ::decimal(18,2) AS "Percentage" 
        FROM public."CrmLead" AS lead
        LEFT JOIN public."CrmLeadStatus" AS LeadSatus ON lead."Status" = LeadSatus."StatusId"
        WHERE 
            (SourceId = -1 OR lead."SourceId" = SourceId)
            AND (Status = -1 OR lead."Status" = Status)
            AND (ProductId= -1 OR lead."ProductId" = ProductId)
            AND lead."TenantId"=TenantId AND lead."IsDeleted"=0
            AND DATE(lead."CreatedDate") BETWEEN DATE(Startdate) AND DATE(Enddate)
        GROUP BY lead."Status", LeadSatus."StatusTitle"
        ORDER BY lead."Status"
    )
    SELECT * FROM StatusData
    UNION
    SELECT
        99999::integer AS "Status",
        'Total' AS "StatusTitle",
        SUM(StatusData."TotalLeads")::integer AS "TotalLeads",
        0.0::decimal(18,2) AS "TotalLeadValue",
        0.0::decimal(18,2) AS "AverageDealValue",
        0.0::decimal(18,2) AS "ExpectedRevenue",
        SUM(StatusData."Percentage")::decimal(18,2) AS "Percentage"
    FROM StatusData
    ORDER BY "Status";
    RETURN;
END;
$$;
 �   DROP FUNCTION public.crmleadstagewiserpt(tenantid integer, sourceid integer, status integer, startdate date, enddate date, productid integer);
       public          postgres    false                       1255    16413    get_all_crmleads() 	   PROCEDURE     g   CREATE PROCEDURE public.get_all_crmleads()
    LANGUAGE sql
    AS $$
    SELECT * FROM "CrmLead";
$$;
 *   DROP PROCEDURE public.get_all_crmleads();
       public          postgres    false                       1255    16414    get_crmleads(integer)    FUNCTION     �  CREATE FUNCTION public.get_crmleads(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT owner_lead."LeadOwner"::TEXT, status_prod."StatusTitle"::TEXT, status_prod."StatusId"::INTEGER, products."ProductName"::TEXT, products."ProductId"::INTEGER, COALESCE(COUNT(crml."LeadId"), 0) AS "Count"
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = p_TenantId
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = p_TenantId
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";

END;
$$;
 7   DROP FUNCTION public.get_crmleads(p_tenantid integer);
       public          postgres    false                       1255    16415    get_lead_status_counts()    FUNCTION     x  CREATE FUNCTION public.get_lead_status_counts() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT AS "LeadOwner",
           status_prod."StatusTitle"::TEXT AS "StatusTitle",
           status_prod."StatusId"::INTEGER AS "StatusId",
           products."ProductName"::TEXT AS "ProductName",
           products."ProductId"::INTEGER AS "ProductId",
           COALESCE(SUM(CASE WHEN crml."LeadId" IS NOT NULL THEN 1 ELSE 0 END), 0) AS "Count"
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = 1
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = 1
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";
    
    RETURN;
END;
$$;
 /   DROP FUNCTION public.get_lead_status_counts();
       public          postgres    false                       1255    16416    get_lead_status_counts22()    FUNCTION     z  CREATE FUNCTION public.get_lead_status_counts22() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT AS "LeadOwner",
           status_prod."StatusTitle"::TEXT AS "StatusTitle",
           status_prod."StatusId"::INTEGER AS "StatusId",
           products."ProductName"::TEXT AS "ProductName",
           products."ProductId"::INTEGER AS "ProductId",
           COALESCE(SUM(CASE WHEN crml."LeadId" IS NOT NULL THEN 1 ELSE 0 END), 0) AS "Count"
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = 1
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = 1
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";
    
    RETURN;
END;
$$;
 1   DROP FUNCTION public.get_lead_status_counts22();
       public          postgres    false                       1255    16417    get_lead_status_counts23()    FUNCTION       CREATE FUNCTION public.get_lead_status_counts23() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT AS "LeadOwner",
           status_prod."StatusTitle"::TEXT AS "StatusTitle",
           status_prod."StatusId"::INTEGER AS "StatusId",
           products."ProductName"::TEXT AS "ProductName",
           products."ProductId"::INTEGER AS "ProductId",
           COALESCE(SUM(CASE WHEN crml."LeadId" IS NOT NULL THEN 1 ELSE 0 END)::INTEGER, 0) AS count
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = 1
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = 1
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";
    
    RETURN;
END;
$$;
 1   DROP FUNCTION public.get_lead_status_counts23();
       public          postgres    false                       1255    16418 !   get_lead_status_counts23(integer)    FUNCTION     �  CREATE FUNCTION public.get_lead_status_counts23(p_tenantid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT AS "LeadOwnerId",
           status_prod."StatusTitle"::TEXT AS "Status",
           status_prod."StatusId"::INTEGER AS "SId",
           products."ProductName"::TEXT AS "ProdName",
           products."ProductId"::INTEGER AS "ProdId",
           COALESCE(SUM(CASE WHEN crml."LeadId" IS NOT NULL THEN 1 ELSE 0 END)::INTEGER, 0) AS count
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = p_TenantId
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = p_TenantId
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";
    
    RETURN;
END;
$$;
 C   DROP FUNCTION public.get_lead_status_counts23(p_tenantid integer);
       public          postgres    false                       1255    16419    get_leadreport(integer)    FUNCTION     �  CREATE FUNCTION public.get_leadreport(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT crml."LeadOwner", crms."StatusTitle", crms."StatusId", crmp."ProductName", crmp."ProductId", COUNT(*) AS "Count"
    FROM "CrmLead" AS crml
    INNER JOIN "CrmLeadStatus" AS crms ON crml."Status" = crms."StatusId"
    INNER JOIN "CrmProduct" AS crmp ON crml."ProductId" = crmp."ProductId"
    WHERE crml."TenantId" = 1
    GROUP BY crml."LeadOwner", crms."StatusId", crms."StatusTitle", crmp."ProductName", crmp."ProductId";
END;
$$;
 9   DROP FUNCTION public.get_leadreport(p_tenantid integer);
       public          postgres    false                       1255    16420    getleaddata(integer)    FUNCTION       CREATE FUNCTION public.getleaddata(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT,
           status_prod."StatusTitle"::TEXT,
           status_prod."StatusId"::INTEGER,
           products."ProductName"::TEXT,
           products."ProductId"::INTEGER,
           COALESCE(COUNT(crml."LeadId"), 0) AS "Count"
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = p_TenantId
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = p_TenantId
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";

    RETURN;
END;
$$;
 6   DROP FUNCTION public.getleaddata(p_tenantid integer);
       public          postgres    false            	           1255    16421    getleadstatuscounts()    FUNCTION     X  CREATE FUNCTION public.getleadstatuscounts() RETURNS TABLE(leadowner text, statustitle text, statusid integer, productname text, productid integer, count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT AS "LeadOwner",
           status_prod."StatusTitle"::TEXT AS "StatusTitle",
           status_prod."StatusId"::INTEGER AS "StatusId",
           products."ProductName"::TEXT AS "ProductName",
           products."ProductId"::INTEGER AS "ProductId",
           COALESCE(SUM(CASE WHEN crml."LeadId" IS NOT NULL THEN 1 ELSE 0 END), 0) AS "Count"
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = 1
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = 1
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";

END $$;
 ,   DROP FUNCTION public.getleadstatuscounts();
       public          postgres    false            
           1255    16422 f   insertcrmuseractivitylog(text, integer, integer, text, text, integer, integer, integer, text, integer) 	   PROCEDURE     j  CREATE PROCEDURE public.insertcrmuseractivitylog(IN p_userid text, IN p_activitytype integer, IN p_activitystatus integer, IN p_detail text, IN p_createdby text, IN p_tenantid integer, IN p_contacttypeid integer, IN p_contactactivityid integer, IN p_action text, IN p_contactid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public."CrmUserActivityLog" (
        "UserId",
        "ActivityType",
        "ActivityStatus",
        "Detail",
        "CreatedBy",
		 "IsDeleted",
        "TenantId",
        "ContactTypeId",
        "ContactActivityId",
		"CreatedDate",
		"Action",
		"Id"
    ) VALUES (
        p_UserId,
        p_ActivityType,
        p_ActivityStatus,
        p_Detail,
        p_CreatedBy,
        0,
        p_TenantId,
        p_ContactTypeId,
        p_ContactActivityId,
		CURRENT_TIMESTAMP,
		p_Action,
		p_ContactId
    );

END;
$$;
   DROP PROCEDURE public.insertcrmuseractivitylog(IN p_userid text, IN p_activitytype integer, IN p_activitystatus integer, IN p_detail text, IN p_createdby text, IN p_tenantid integer, IN p_contacttypeid integer, IN p_contactactivityid integer, IN p_action text, IN p_contactid integer);
       public          postgres    false                       1255    16423 E   insertstatuslog(text, integer, text, text, integer, integer, integer) 	   PROCEDURE     w  CREATE PROCEDURE public.insertstatuslog(IN p_details text, IN p_typeid integer, IN p_statustitle text, IN p_createdby text, IN p_actionid integer, IN p_tenantid integer, IN p_statusid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public."CrmStatusLog"(
        "CreatedOn",
        "Details",
        "TypeId",
        "StatusTtile",
        "CreatedBy",
        "ActionId",
        "TenantId",
        "StatusId"
    ) VALUES (
         CURRENT_DATE,
         p_details,
         p_typeid,
         p_statustitle,
         p_createdby,
         p_actionid,
         p_tenantid,
         p_statusid
    );
END;
$$;
 �   DROP PROCEDURE public.insertstatuslog(IN p_details text, IN p_typeid integer, IN p_statustitle text, IN p_createdby text, IN p_actionid integer, IN p_tenantid integer, IN p_statusid integer);
       public          postgres    false                       1255    16424 1   leadownerstatuswise(integer, date, date, integer)    FUNCTION     �  CREATE FUNCTION public.leadownerstatuswise(p_tenantid integer, p_startdate date, p_enddate date, p_productid integer) RETURNS TABLE("leadStatusId" integer, "LeadStatusTitle" text, "LeadOwner" text, "FirstName" text, "ProductId" integer, "ProductName" text, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  
    WITH LeaveStatus AS (
        SELECT "StatusId" as "leadStatusId", "StatusTitle" as "LeadStatusTitle"
        FROM "CrmLeadStatus" sta
        WHERE sta."IsDeleted" = 0 
        ORDER BY sta."StatusId"
    ),
    Leads AS (
        SELECT c."ProductId", C."Status", c."LeadOwner", COUNT(c."Status") AS "CountStatus"
        FROM "CrmLead" AS c
        WHERE c."IsDeleted" = 0
        AND "TenantId" = p_tenantid
        AND c."CreatedDate" BETWEEN p_startdate AND p_enddate
        AND (p_productid = -1 OR c."ProductId" = p_productid)
        GROUP BY c."ProductId", c."LeadOwner", C."Status"
    ),
    UniqueUser AS (
        SELECT DISTINCT led."LeadOwner", u."FirstName"
        FROM Leads AS led
        INNER JOIN "db2_aspnetusers" u ON led."LeadOwner" = u."Id"
    ),
    UniqueProduct AS (
        SELECT DISTINCT led."ProductId", p."ProductName"
        FROM Leads AS led
        INNER JOIN "CrmProduct" AS p ON led."ProductId" = p."ProductId"
    )
  
    SELECT Ss."leadStatusId", Ss."LeadStatusTitle", U."LeadOwner"::text, U."FirstName"::text, P."ProductId", P."ProductName"::text, COALESCE(L."CountStatus", 0)::int AS "Count"
    FROM LeaveStatus AS Ss
    CROSS JOIN UniqueUser U 
    CROSS JOIN UniqueProduct P 
    LEFT OUTER JOIN Leads L ON Ss."leadStatusId" = L."Status" AND U."LeadOwner" = L."LeadOwner" AND P."ProductId" = L."ProductId"
    ORDER BY P."ProductId", Ss."leadStatusId", U."LeadOwner";

END;
$$;
 u   DROP FUNCTION public.leadownerstatuswise(p_tenantid integer, p_startdate date, p_enddate date, p_productid integer);
       public          postgres    false                       1255    16425    leadstatusfn(integer)    FUNCTION       CREATE FUNCTION public.leadstatusfn(p_tenantid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT AS "LeadOwnerId",
           status_prod."StatusTitle"::TEXT AS "Status",
           status_prod."StatusId"::INTEGER AS "SId",
           products."ProductName"::TEXT AS "ProdName",
           products."ProductId"::INTEGER AS "ProdId",
           COALESCE(SUM(CASE WHEN crml."LeadId" IS NOT NULL THEN 1 ELSE 0 END)::INTEGER, 0) AS "Count"
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = p_TenantId
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = p_TenantId
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";
    
    RETURN;
END;
$$;
 7   DROP FUNCTION public.leadstatusfn(p_tenantid integer);
       public          postgres    false                       1255    16426 *   leadstatusfn(integer, date, date, integer)    FUNCTION     �  CREATE FUNCTION public.leadstatusfn(p_tenantid integer, p_startdate date, p_enddate date, p_productid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, "Count" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT owner_lead."LeadOwner"::TEXT AS "LeadOwnerId",
           status_prod."StatusTitle"::TEXT AS "Status",
           status_prod."StatusId"::INTEGER AS "SId",
           products."ProductName"::TEXT AS "ProdName",
           products."ProductId"::INTEGER AS "ProdId",
           COALESCE(SUM(CASE WHEN crml."LeadId" IS NOT NULL THEN 1 ELSE 0 END)::INTEGER, 0) AS "Count"
    FROM (
        SELECT DISTINCT "LeadOwner"
        FROM "CrmLead"
        WHERE "TenantId" = p_TenantId
			AND "CreatedDate" >= p_startDate
		AND "CreatedDate" <= p_endDate
		AND (  p_productId =-1 or "ProductId" = p_productId )
    ) AS owner_lead
    CROSS JOIN (
        SELECT "StatusId", "StatusTitle"
        FROM "CrmLeadStatus"
    ) AS status_prod
    CROSS JOIN (
        SELECT "ProductId", "ProductName"
        FROM "CrmProduct"
    ) AS products
    LEFT JOIN "CrmLead" AS crml ON owner_lead."LeadOwner" = crml."LeadOwner"
        AND status_prod."StatusId" = crml."Status"
        AND products."ProductId" = crml."ProductId"
        AND crml."TenantId" = p_TenantId
		AND crml."CreatedDate" >= p_startDate
		AND crml."CreatedDate" <= p_endDate
		AND (  p_productId =-1 or crml."ProductId" = p_productId )
    GROUP BY owner_lead."LeadOwner", status_prod."StatusId", status_prod."StatusTitle", products."ProductName", products."ProductId"
    ORDER BY owner_lead."LeadOwner", status_prod."StatusId", products."ProductId";
    
    RETURN;
END;
$$;
 n   DROP FUNCTION public.leadstatusfn(p_tenantid integer, p_startdate date, p_enddate date, p_productid integer);
       public          postgres    false                       1255    16427    process_lead_counts(integer)    FUNCTION     �	  CREATE FUNCTION public.process_lead_counts(p_tenantid integer) RETURNS TABLE(leadownerid text, leadid integer, noteidcount integer, callidcount integer, emailidcount integer, taskidcount integer, meetingidcount integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    CREATE TEMP TABLE temp_table_name (
        LeadId INT,
        LeadOwnerId TEXT,
        NoteId INT,
        CallId INT,
        EmailId INT,
        TaskId INT,
        MeetingId INT
    );
    
INSERT INTO temp_table_name
SELECT crml."LeadId" AS LeadId, crml."LeadOwner" AS LeadOwnerId, crmn."NoteId" AS NoteId,
    -1 AS CallId, -1 AS EmailId, -1 AS TaskId, -1 AS MeetingId
FROM "CrmLead" AS crml
INNER JOIN "CrmNote" AS crmn ON crml."LeadId" = crmn."Id" AND crmn."IsLead" = 1
UNION ALL
SELECT crml."LeadId" AS LeadId, crml."LeadOwner" AS LeadOwnerId, -1 AS NoteId,
    crmc."CallId" AS CallId, -1 AS EmailId, -1 AS TaskId, -1 AS MeetingId
FROM "CrmLead" AS crml
INNER JOIN "CrmCall" AS crmc ON crml."LeadId" = crmc."Id" AND crmc."IsLead" = 1
UNION ALL
SELECT crml."LeadId" AS LeadId, crml."LeadOwner" AS LeadOwnerId, -1 AS NoteId,
    -1 AS CallId, crme."EmailId" AS EmailId, -1 AS TaskId, -1 AS MeetingId
FROM "CrmLead" AS crml
INNER JOIN "CrmEmail" AS crme ON crml."LeadId" = crme."Id" AND crme."IsLead" = 1
UNION ALL
SELECT crml."LeadId" AS LeadId, crml."LeadOwner" AS LeadOwnerId, -1 AS NoteId,
    -1 AS CallId, -1 AS EmailId, crmt."TaskId" AS TaskId, -1 AS MeetingId
FROM "CrmLead" AS crml
INNER JOIN "CrmTask" AS crmt ON crml."LeadId" = crmt."Id" AND crmt."IsLead" = 1
UNION ALL
SELECT crml."LeadId" AS LeadId, crml."LeadOwner" AS LeadOwnerId, -1 AS NoteId,
    -1 AS CallId, -1 AS EmailId, -1 AS TaskId, crmm."MeetingId" AS MeetingId
FROM "CrmLead" AS crml
UNION ALL
SELECT crml."LeadId" AS LeadId, crml."LeadOwner" AS LeadOwnerId, -1 AS NoteId,
    -1 AS CallId, -1 AS EmailId, -1 AS TaskId, -1 AS MeetingId
FROM "CrmLead" AS crml;
    
    RETURN QUERY
    SELECT 
        LeadOwnerId,
        LeadId,
        SUM(CASE WHEN NoteId <> -1 THEN 1 ELSE 0 END) AS NoteIdCount,
        SUM(CASE WHEN CallId <> -1 THEN 1 ELSE 0 END) AS CallIdCount,
        SUM(CASE WHEN EmailId <> -1 THEN 1 ELSE 0 END) AS EmailIdCount,
        SUM(CASE WHEN TaskId <> -1 THEN 1 ELSE 0 END) AS TaskIdCount,
        SUM(CASE WHEN MeetingId <> -1 THEN 1 ELSE 0 END) AS MeetingIdCount
    FROM temp_table_name
    WHERE  NoteId <> -1 OR CallId <> -1 OR EmailId <> -1 OR TaskId <> -1 OR MeetingId <> -1
    GROUP BY LeadOwnerId, LeadId;

    DROP TABLE temp_table_name;
END;
$$;
 >   DROP FUNCTION public.process_lead_counts(p_tenantid integer);
       public          postgres    false            U           1417    16428 
   db2_server    SERVER     f   CREATE SERVER db2_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'ERPCubesIdentity'
);
    DROP SERVER db2_server;
                postgres    false    2    2    2            (           0    0 '   USER MAPPING postgres SERVER db2_server    USER MAPPING     m   CREATE USER MAPPING FOR postgres SERVER db2_server OPTIONS (
    password 'Abc123',
    "user" 'postgres'
);
 2   DROP USER MAPPING FOR postgres SERVER db2_server;
                postgres    false                       1259    16430    AppMenus    TABLE     v  CREATE TABLE public."AppMenus" (
    "MenuId" integer NOT NULL,
    "Code" character varying(50),
    "Title" character varying(50),
    "Subtitle" character varying(255),
    "Type" character varying(50),
    "Icon" character varying(50),
    "Link" character varying(50),
    "Level" character varying(50),
    "CreatedBy" character varying(500) NOT NULL,
    "CreatedOn" timestamp without time zone DEFAULT now() NOT NULL,
    "LastModifiedBy" character varying(500),
    "LastModifiedOn" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "ParentId" integer NOT NULL,
    "Order" integer NOT NULL
);
    DROP TABLE public."AppMenus";
       public         heap    postgres    false                       1259    16437    AppMenus_MenuId_seq    SEQUENCE     �   CREATE SEQUENCE public."AppMenus_MenuId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."AppMenus_MenuId_seq";
       public          postgres    false    258            )           0    0    AppMenus_MenuId_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."AppMenus_MenuId_seq" OWNED BY public."AppMenus"."MenuId";
          public          postgres    false    259            �           1259    18540    Conversation    TABLE     �  CREATE TABLE public."Conversation" (
    "ConversationId" integer NOT NULL,
    "TicketId" integer,
    "FromId" character varying(255),
    "ToId" character varying(255),
    "Timestamp" timestamp with time zone,
    "MessageType" character varying(50),
    "MessageBody" text,
    "MediaType" character varying(50),
    "ReadStatus" boolean,
    "Reaction" character varying(50),
    "ForwardedStatus" boolean,
    "Location" character varying(255),
    "MessageStatus" character varying(50),
    "EventType" character varying(255),
    "CustomerFeedback" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsMine" boolean DEFAULT false NOT NULL
)
PARTITION BY RANGE ("TenantId");
 "   DROP TABLE public."Conversation";
       public            postgres    false            �           1259    18539    Conversation_ConversationId_seq    SEQUENCE     �   CREATE SEQUENCE public."Conversation_ConversationId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."Conversation_ConversationId_seq";
       public          postgres    false    458            *           0    0    Conversation_ConversationId_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."Conversation_ConversationId_seq" OWNED BY public."Conversation"."ConversationId";
          public          postgres    false    457            �           1259    18550    Conversation1    TABLE     �  CREATE TABLE public."Conversation1" (
    "ConversationId" integer DEFAULT nextval('public."Conversation_ConversationId_seq"'::regclass) NOT NULL,
    "TicketId" integer,
    "FromId" character varying(255),
    "ToId" character varying(255),
    "Timestamp" timestamp with time zone,
    "MessageType" character varying(50),
    "MessageBody" text,
    "MediaType" character varying(50),
    "ReadStatus" boolean,
    "Reaction" character varying(50),
    "ForwardedStatus" boolean,
    "Location" character varying(255),
    "MessageStatus" character varying(50),
    "EventType" character varying(255),
    "CustomerFeedback" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsMine" boolean DEFAULT false NOT NULL
);
 #   DROP TABLE public."Conversation1";
       public         heap    postgres    false    457    458            �           1259    18562    Conversation100    TABLE     �  CREATE TABLE public."Conversation100" (
    "ConversationId" integer DEFAULT nextval('public."Conversation_ConversationId_seq"'::regclass) NOT NULL,
    "TicketId" integer,
    "FromId" character varying(255),
    "ToId" character varying(255),
    "Timestamp" timestamp with time zone,
    "MessageType" character varying(50),
    "MessageBody" text,
    "MediaType" character varying(50),
    "ReadStatus" boolean,
    "Reaction" character varying(50),
    "ForwardedStatus" boolean,
    "Location" character varying(255),
    "MessageStatus" character varying(50),
    "EventType" character varying(255),
    "CustomerFeedback" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsMine" boolean DEFAULT false NOT NULL
);
 %   DROP TABLE public."Conversation100";
       public         heap    postgres    false    457    458            �           1259    18574    Conversation2    TABLE     �  CREATE TABLE public."Conversation2" (
    "ConversationId" integer DEFAULT nextval('public."Conversation_ConversationId_seq"'::regclass) NOT NULL,
    "TicketId" integer,
    "FromId" character varying(255),
    "ToId" character varying(255),
    "Timestamp" timestamp with time zone,
    "MessageType" character varying(50),
    "MessageBody" text,
    "MediaType" character varying(50),
    "ReadStatus" boolean,
    "Reaction" character varying(50),
    "ForwardedStatus" boolean,
    "Location" character varying(255),
    "MessageStatus" character varying(50),
    "EventType" character varying(255),
    "CustomerFeedback" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsMine" boolean DEFAULT false NOT NULL
);
 #   DROP TABLE public."Conversation2";
       public         heap    postgres    false    457    458            �           1259    18586    Conversation3    TABLE     �  CREATE TABLE public."Conversation3" (
    "ConversationId" integer DEFAULT nextval('public."Conversation_ConversationId_seq"'::regclass) NOT NULL,
    "TicketId" integer,
    "FromId" character varying(255),
    "ToId" character varying(255),
    "Timestamp" timestamp with time zone,
    "MessageType" character varying(50),
    "MessageBody" text,
    "MediaType" character varying(50),
    "ReadStatus" boolean,
    "Reaction" character varying(50),
    "ForwardedStatus" boolean,
    "Location" character varying(255),
    "MessageStatus" character varying(50),
    "EventType" character varying(255),
    "CustomerFeedback" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsMine" boolean DEFAULT false NOT NULL
);
 #   DROP TABLE public."Conversation3";
       public         heap    postgres    false    457    458                       1259    16438    CrmAdAccount    TABLE     �  CREATE TABLE public."CrmAdAccount" (
    "AccountId" integer NOT NULL,
    "Title" text NOT NULL,
    "IsSelected" integer NOT NULL,
    "SocialId" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 "   DROP TABLE public."CrmAdAccount";
       public            postgres    false                       1259    16443    CrmAdAccount_AccountId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmAdAccount_AccountId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmAdAccount_AccountId_seq";
       public          postgres    false    260            +           0    0    CrmAdAccount_AccountId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmAdAccount_AccountId_seq" OWNED BY public."CrmAdAccount"."AccountId";
          public          postgres    false    261                       1259    16444    CrmAdAccount1    TABLE       CREATE TABLE public."CrmAdAccount1" (
    "AccountId" integer DEFAULT nextval('public."CrmAdAccount_AccountId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "IsSelected" integer NOT NULL,
    "SocialId" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 #   DROP TABLE public."CrmAdAccount1";
       public         heap    postgres    false    261    260                       1259    16452    CrmAdAccount100    TABLE       CREATE TABLE public."CrmAdAccount100" (
    "AccountId" integer DEFAULT nextval('public."CrmAdAccount_AccountId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "IsSelected" integer NOT NULL,
    "SocialId" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."CrmAdAccount100";
       public         heap    postgres    false    261    260                       1259    16460    CrmAdAccount2    TABLE       CREATE TABLE public."CrmAdAccount2" (
    "AccountId" integer DEFAULT nextval('public."CrmAdAccount_AccountId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "IsSelected" integer NOT NULL,
    "SocialId" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 #   DROP TABLE public."CrmAdAccount2";
       public         heap    postgres    false    261    260            	           1259    16468    CrmAdAccount3    TABLE       CREATE TABLE public."CrmAdAccount3" (
    "AccountId" integer DEFAULT nextval('public."CrmAdAccount_AccountId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "IsSelected" integer NOT NULL,
    "SocialId" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 #   DROP TABLE public."CrmAdAccount3";
       public         heap    postgres    false    261    260            
           1259    16476    CrmCalendarEventsType    TABLE     �   CREATE TABLE public."CrmCalendarEventsType" (
    "TypeId" integer NOT NULL,
    "TypeTitle" text,
    "IsDeleted" integer DEFAULT 0
);
 +   DROP TABLE public."CrmCalendarEventsType";
       public         heap    postgres    false                       1259    16482     CrmCalendarEventsType_TypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCalendarEventsType_TypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."CrmCalendarEventsType_TypeId_seq";
       public          postgres    false    266            ,           0    0     CrmCalendarEventsType_TypeId_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."CrmCalendarEventsType_TypeId_seq" OWNED BY public."CrmCalendarEventsType"."TypeId";
          public          postgres    false    267                       1259    16483    CrmCalenderEvents    TABLE     >  CREATE TABLE public."CrmCalenderEvents" (
    "EventId" integer NOT NULL,
    "UserId" character varying(255) NOT NULL,
    "Description" text,
    "Type" integer,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "ActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 '   DROP TABLE public."CrmCalenderEvents";
       public            postgres    false                       1259    16491    CrmCalenderEvents_EventId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCalenderEvents_EventId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CrmCalenderEvents_EventId_seq";
       public          postgres    false    268            -           0    0    CrmCalenderEvents_EventId_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."CrmCalenderEvents_EventId_seq" OWNED BY public."CrmCalenderEvents"."EventId";
          public          postgres    false    269                       1259    16492    CrmCalenderEventsTenant1    TABLE     i  CREATE TABLE public."CrmCalenderEventsTenant1" (
    "EventId" integer DEFAULT nextval('public."CrmCalenderEvents_EventId_seq"'::regclass) NOT NULL,
    "UserId" character varying(255) NOT NULL,
    "Description" text,
    "Type" integer,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "ActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL
);
 .   DROP TABLE public."CrmCalenderEventsTenant1";
       public         heap    postgres    false    269    268                       1259    16503    CrmCalenderEventsTenant100    TABLE     k  CREATE TABLE public."CrmCalenderEventsTenant100" (
    "EventId" integer DEFAULT nextval('public."CrmCalenderEvents_EventId_seq"'::regclass) NOT NULL,
    "UserId" character varying(255) NOT NULL,
    "Description" text,
    "Type" integer,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "ActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL
);
 0   DROP TABLE public."CrmCalenderEventsTenant100";
       public         heap    postgres    false    269    268                       1259    16514    CrmCalenderEventsTenant2    TABLE     i  CREATE TABLE public."CrmCalenderEventsTenant2" (
    "EventId" integer DEFAULT nextval('public."CrmCalenderEvents_EventId_seq"'::regclass) NOT NULL,
    "UserId" character varying(255) NOT NULL,
    "Description" text,
    "Type" integer,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "ActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL
);
 .   DROP TABLE public."CrmCalenderEventsTenant2";
       public         heap    postgres    false    269    268                       1259    16525    CrmCalenderEventsTenant3    TABLE     i  CREATE TABLE public."CrmCalenderEventsTenant3" (
    "EventId" integer DEFAULT nextval('public."CrmCalenderEvents_EventId_seq"'::regclass) NOT NULL,
    "UserId" character varying(255) NOT NULL,
    "Description" text,
    "Type" integer,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "ActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL
);
 .   DROP TABLE public."CrmCalenderEventsTenant3";
       public         heap    postgres    false    269    268                       1259    16536    CrmCall    TABLE     �  CREATE TABLE public."CrmCall" (
    "CallId" integer NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ReasonId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "CallDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmCall";
       public            postgres    false                       1259    16544    CrmCall_CallId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCall_CallId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmCall_CallId_seq";
       public          postgres    false    274            .           0    0    CrmCall_CallId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmCall_CallId_seq" OWNED BY public."CrmCall"."CallId";
          public          postgres    false    275                       1259    16545    CrmCall1    TABLE     �  CREATE TABLE public."CrmCall1" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ReasonId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "CallDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public."CrmCall1";
       public         heap    postgres    false    275    274                       1259    16556 
   CrmCall100    TABLE     �  CREATE TABLE public."CrmCall100" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ReasonId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "CallDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
     DROP TABLE public."CrmCall100";
       public         heap    postgres    false    275    274                       1259    16567    CrmCall2    TABLE     �  CREATE TABLE public."CrmCall2" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ReasonId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "CallDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public."CrmCall2";
       public         heap    postgres    false    275    274                       1259    16578    CrmCall3    TABLE     �  CREATE TABLE public."CrmCall3" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ReasonId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "CallDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public."CrmCall3";
       public         heap    postgres    false    275    274                       1259    16589    CrmCampaign    TABLE     #  CREATE TABLE public."CrmCampaign" (
    "CampaignId" text NOT NULL,
    "AdAccountId" text NOT NULL,
    "Title" text NOT NULL,
    "ProductId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "SourceId" integer,
    "Budget" numeric
)
PARTITION BY RANGE ("TenantId");
 !   DROP TABLE public."CrmCampaign";
       public            postgres    false                       1259    16594    CrmCampaign1    TABLE       CREATE TABLE public."CrmCampaign1" (
    "CampaignId" text NOT NULL,
    "AdAccountId" text NOT NULL,
    "Title" text NOT NULL,
    "ProductId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "SourceId" integer,
    "Budget" numeric
);
 "   DROP TABLE public."CrmCampaign1";
       public         heap    postgres    false    280                       1259    16601    CrmCampaign100    TABLE       CREATE TABLE public."CrmCampaign100" (
    "CampaignId" text NOT NULL,
    "AdAccountId" text NOT NULL,
    "Title" text NOT NULL,
    "ProductId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "SourceId" integer,
    "Budget" numeric
);
 $   DROP TABLE public."CrmCampaign100";
       public         heap    postgres    false    280                       1259    16608    CrmCampaign2    TABLE       CREATE TABLE public."CrmCampaign2" (
    "CampaignId" text NOT NULL,
    "AdAccountId" text NOT NULL,
    "Title" text NOT NULL,
    "ProductId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "SourceId" integer,
    "Budget" numeric
);
 "   DROP TABLE public."CrmCampaign2";
       public         heap    postgres    false    280                       1259    16615    CrmCampaign3    TABLE       CREATE TABLE public."CrmCampaign3" (
    "CampaignId" text NOT NULL,
    "AdAccountId" text NOT NULL,
    "Title" text NOT NULL,
    "ProductId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "SourceId" integer,
    "Budget" numeric
);
 "   DROP TABLE public."CrmCampaign3";
       public         heap    postgres    false    280                       1259    16622 
   CrmCompany    TABLE     z  CREATE TABLE public."CrmCompany" (
    "CompanyId" integer NOT NULL,
    "Name" text NOT NULL,
    "Website" text,
    "CompanyOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "BillingAddress" text,
    "BillingStreet" text,
    "BillingCity" text,
    "BillingZip" text,
    "BillingState" text,
    "BillingCountry" text,
    "DeliveryAddress" text,
    "DeliveryStreet" text,
    "DeliveryCity" text,
    "DeliveryZip" text,
    "DeliveryState" text,
    "DeliveryCountry" text,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Email" text
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmCompany";
       public            postgres    false                       1259    16627    CrmCompanyActivityLog    TABLE     1  CREATE TABLE public."CrmCompanyActivityLog" (
    "ActivityId" integer NOT NULL,
    "CompanyId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 +   DROP TABLE public."CrmCompanyActivityLog";
       public            postgres    false                       1259    16632 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq";
       public          postgres    false    286            /           0    0 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq" OWNED BY public."CrmCompanyActivityLog"."ActivityId";
          public          postgres    false    287                        1259    16633    CrmCompanyActivityLogTenant1    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant1" (
    "ActivityId" integer DEFAULT nextval('public."CrmCompanyActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 2   DROP TABLE public."CrmCompanyActivityLogTenant1";
       public         heap    postgres    false    287    286            !           1259    16641    CrmCompanyActivityLogTenant100    TABLE     e  CREATE TABLE public."CrmCompanyActivityLogTenant100" (
    "ActivityId" integer DEFAULT nextval('public."CrmCompanyActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 4   DROP TABLE public."CrmCompanyActivityLogTenant100";
       public         heap    postgres    false    287    286            "           1259    16649    CrmCompanyActivityLogTenant2    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant2" (
    "ActivityId" integer DEFAULT nextval('public."CrmCompanyActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 2   DROP TABLE public."CrmCompanyActivityLogTenant2";
       public         heap    postgres    false    287    286            #           1259    16657    CrmCompanyActivityLogTenant3    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant3" (
    "ActivityId" integer DEFAULT nextval('public."CrmCompanyActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 2   DROP TABLE public."CrmCompanyActivityLogTenant3";
       public         heap    postgres    false    287    286            $           1259    16665    CrmCompanyMember    TABLE     �  CREATE TABLE public."CrmCompanyMember" (
    "MemberId" integer NOT NULL,
    "CompanyId" integer NOT NULL,
    "LeadId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 &   DROP TABLE public."CrmCompanyMember";
       public            postgres    false            %           1259    16670    CrmCompanyMember_MemberId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompanyMember_MemberId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CrmCompanyMember_MemberId_seq";
       public          postgres    false    292            0           0    0    CrmCompanyMember_MemberId_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."CrmCompanyMember_MemberId_seq" OWNED BY public."CrmCompanyMember"."MemberId";
          public          postgres    false    293            &           1259    16671    CrmCompanyMemberTenant1    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant1" (
    "MemberId" integer DEFAULT nextval('public."CrmCompanyMember_MemberId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "LeadId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 -   DROP TABLE public."CrmCompanyMemberTenant1";
       public         heap    postgres    false    293    292            '           1259    16679    CrmCompanyMemberTenant100    TABLE       CREATE TABLE public."CrmCompanyMemberTenant100" (
    "MemberId" integer DEFAULT nextval('public."CrmCompanyMember_MemberId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "LeadId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 /   DROP TABLE public."CrmCompanyMemberTenant100";
       public         heap    postgres    false    293    292            (           1259    16687    CrmCompanyMemberTenant2    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant2" (
    "MemberId" integer DEFAULT nextval('public."CrmCompanyMember_MemberId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "LeadId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 -   DROP TABLE public."CrmCompanyMemberTenant2";
       public         heap    postgres    false    293    292            )           1259    16695    CrmCompanyMemberTenant3    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant3" (
    "MemberId" integer DEFAULT nextval('public."CrmCompanyMember_MemberId_seq"'::regclass) NOT NULL,
    "CompanyId" integer NOT NULL,
    "LeadId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 -   DROP TABLE public."CrmCompanyMemberTenant3";
       public         heap    postgres    false    293    292            *           1259    16703    CrmCompany_CompanyId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompany_CompanyId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmCompany_CompanyId_seq";
       public          postgres    false    285            1           0    0    CrmCompany_CompanyId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmCompany_CompanyId_seq" OWNED BY public."CrmCompany"."CompanyId";
          public          postgres    false    298            +           1259    16704    CrmCompanyTenant1    TABLE     �  CREATE TABLE public."CrmCompanyTenant1" (
    "CompanyId" integer DEFAULT nextval('public."CrmCompany_CompanyId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Website" text,
    "CompanyOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "BillingAddress" text,
    "BillingStreet" text,
    "BillingCity" text,
    "BillingZip" text,
    "BillingState" text,
    "BillingCountry" text,
    "DeliveryAddress" text,
    "DeliveryStreet" text,
    "DeliveryCity" text,
    "DeliveryZip" text,
    "DeliveryState" text,
    "DeliveryCountry" text,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Email" text
);
 '   DROP TABLE public."CrmCompanyTenant1";
       public         heap    postgres    false    298    285            ,           1259    16712    CrmCompanyTenant100    TABLE     �  CREATE TABLE public."CrmCompanyTenant100" (
    "CompanyId" integer DEFAULT nextval('public."CrmCompany_CompanyId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Website" text,
    "CompanyOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "BillingAddress" text,
    "BillingStreet" text,
    "BillingCity" text,
    "BillingZip" text,
    "BillingState" text,
    "BillingCountry" text,
    "DeliveryAddress" text,
    "DeliveryStreet" text,
    "DeliveryCity" text,
    "DeliveryZip" text,
    "DeliveryState" text,
    "DeliveryCountry" text,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Email" text
);
 )   DROP TABLE public."CrmCompanyTenant100";
       public         heap    postgres    false    298    285            -           1259    16720    CrmCompanyTenant2    TABLE     �  CREATE TABLE public."CrmCompanyTenant2" (
    "CompanyId" integer DEFAULT nextval('public."CrmCompany_CompanyId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Website" text,
    "CompanyOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "BillingAddress" text,
    "BillingStreet" text,
    "BillingCity" text,
    "BillingZip" text,
    "BillingState" text,
    "BillingCountry" text,
    "DeliveryAddress" text,
    "DeliveryStreet" text,
    "DeliveryCity" text,
    "DeliveryZip" text,
    "DeliveryState" text,
    "DeliveryCountry" text,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Email" text
);
 '   DROP TABLE public."CrmCompanyTenant2";
       public         heap    postgres    false    298    285            .           1259    16728    CrmCompanyTenant3    TABLE     �  CREATE TABLE public."CrmCompanyTenant3" (
    "CompanyId" integer DEFAULT nextval('public."CrmCompany_CompanyId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Website" text,
    "CompanyOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "BillingAddress" text,
    "BillingStreet" text,
    "BillingCity" text,
    "BillingZip" text,
    "BillingState" text,
    "BillingCountry" text,
    "DeliveryAddress" text,
    "DeliveryStreet" text,
    "DeliveryCity" text,
    "DeliveryZip" text,
    "DeliveryState" text,
    "DeliveryCountry" text,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Email" text
);
 '   DROP TABLE public."CrmCompanyTenant3";
       public         heap    postgres    false    298    285            /           1259    16736    CrmCustomLists    TABLE     �  CREATE TABLE public."CrmCustomLists" (
    "ListId" integer NOT NULL,
    "ListTitle" text NOT NULL,
    "Filter" text,
    "Type" text NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsPublic" integer DEFAULT 0 NOT NULL
)
PARTITION BY RANGE ("TenantId");
 $   DROP TABLE public."CrmCustomLists";
       public            postgres    false            0           1259    16742    CrmCustomLists_ListId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCustomLists_ListId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."CrmCustomLists_ListId_seq";
       public          postgres    false    303            2           0    0    CrmCustomLists_ListId_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CrmCustomLists_ListId_seq" OWNED BY public."CrmCustomLists"."ListId";
          public          postgres    false    304            1           1259    16743    CrmCustomListsTenant1    TABLE     
  CREATE TABLE public."CrmCustomListsTenant1" (
    "ListId" integer DEFAULT nextval('public."CrmCustomLists_ListId_seq"'::regclass) NOT NULL,
    "ListTitle" text NOT NULL,
    "Filter" text,
    "Type" text NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsPublic" integer DEFAULT 0 NOT NULL
);
 +   DROP TABLE public."CrmCustomListsTenant1";
       public         heap    postgres    false    304    303            2           1259    16752    CrmCustomListsTenant100    TABLE       CREATE TABLE public."CrmCustomListsTenant100" (
    "ListId" integer DEFAULT nextval('public."CrmCustomLists_ListId_seq"'::regclass) NOT NULL,
    "ListTitle" text NOT NULL,
    "Filter" text,
    "Type" text NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsPublic" integer DEFAULT 0 NOT NULL
);
 -   DROP TABLE public."CrmCustomListsTenant100";
       public         heap    postgres    false    304    303            3           1259    16761    CrmCustomListsTenant2    TABLE     
  CREATE TABLE public."CrmCustomListsTenant2" (
    "ListId" integer DEFAULT nextval('public."CrmCustomLists_ListId_seq"'::regclass) NOT NULL,
    "ListTitle" text NOT NULL,
    "Filter" text,
    "Type" text NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsPublic" integer DEFAULT 0 NOT NULL
);
 +   DROP TABLE public."CrmCustomListsTenant2";
       public         heap    postgres    false    304    303            4           1259    16770    CrmCustomListsTenant3    TABLE     
  CREATE TABLE public."CrmCustomListsTenant3" (
    "ListId" integer DEFAULT nextval('public."CrmCustomLists_ListId_seq"'::regclass) NOT NULL,
    "ListTitle" text NOT NULL,
    "Filter" text,
    "Type" text NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsPublic" integer DEFAULT 0 NOT NULL
);
 +   DROP TABLE public."CrmCustomListsTenant3";
       public         heap    postgres    false    304    303            5           1259    16779    CrmEmail    TABLE     2  CREATE TABLE public."CrmEmail" (
    "EmailId" integer NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmEmail";
       public            postgres    false            6           1259    16785    CrmEmail_EmailId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmEmail_EmailId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."CrmEmail_EmailId_seq";
       public          postgres    false    309            3           0    0    CrmEmail_EmailId_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CrmEmail_EmailId_seq" OWNED BY public."CrmEmail"."EmailId";
          public          postgres    false    310            7           1259    16786 	   CrmEmail1    TABLE     N  CREATE TABLE public."CrmEmail1" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
    DROP TABLE public."CrmEmail1";
       public         heap    postgres    false    310    309            8           1259    16795    CrmEmail100    TABLE     P  CREATE TABLE public."CrmEmail100" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 !   DROP TABLE public."CrmEmail100";
       public         heap    postgres    false    310    309            9           1259    16804 	   CrmEmail2    TABLE     N  CREATE TABLE public."CrmEmail2" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
    DROP TABLE public."CrmEmail2";
       public         heap    postgres    false    310    309            :           1259    16813 	   CrmEmail3    TABLE     N  CREATE TABLE public."CrmEmail3" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
    DROP TABLE public."CrmEmail3";
       public         heap    postgres    false    310    309            �           1259    18905    CrmForm    TABLE     �  CREATE TABLE public."CrmForm" (
    "FormId" integer NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmForm";
       public            postgres    false            �           1259    18904    CrmForm_FormId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmForm_FormId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmForm_FormId_seq";
       public          postgres    false    486            4           0    0    CrmForm_FormId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmForm_FormId_seq" OWNED BY public."CrmForm"."FormId";
          public          postgres    false    485            �           1259    18993    CrmForm1    TABLE       CREATE TABLE public."CrmForm1" (
    "FormId" integer DEFAULT nextval('public."CrmForm_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
    DROP TABLE public."CrmForm1";
       public         heap    postgres    false    485    486            �           1259    19023 
   CrmForm100    TABLE       CREATE TABLE public."CrmForm100" (
    "FormId" integer DEFAULT nextval('public."CrmForm_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
     DROP TABLE public."CrmForm100";
       public         heap    postgres    false    485    486            �           1259    19003    CrmForm2    TABLE       CREATE TABLE public."CrmForm2" (
    "FormId" integer DEFAULT nextval('public."CrmForm_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
    DROP TABLE public."CrmForm2";
       public         heap    postgres    false    485    486            �           1259    19013    CrmForm3    TABLE       CREATE TABLE public."CrmForm3" (
    "FormId" integer DEFAULT nextval('public."CrmForm_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
    DROP TABLE public."CrmForm3";
       public         heap    postgres    false    485    486            �           1259    19052    CrmFormFieldTypes    TABLE     �  CREATE TABLE public."CrmFormFieldTypes" (
    "TypeId" integer NOT NULL,
    "TypeName" text NOT NULL,
    "TypeLabel" text NOT NULL,
    "Icon" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL
);
 '   DROP TABLE public."CrmFormFieldTypes";
       public         heap    postgres    false            ;           1259    16822    CrmFormFields    TABLE     �  CREATE TABLE public."CrmFormFields" (
    "FieldId" integer NOT NULL,
    "FormId" integer NOT NULL,
    "FieldLabel" text NOT NULL,
    "FieldType" integer NOT NULL,
    "Placeholder" text,
    "Values" text,
    "IsFixed" boolean NOT NULL,
    "Order" integer NOT NULL,
    "DisplayLabel" boolean NOT NULL,
    "CSS" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 #   DROP TABLE public."CrmFormFields";
       public            postgres    false            <           1259    16827    CrmFormFields_FieldId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmFormFields_FieldId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."CrmFormFields_FieldId_seq";
       public          postgres    false    315            5           0    0    CrmFormFields_FieldId_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CrmFormFields_FieldId_seq" OWNED BY public."CrmFormFields"."FieldId";
          public          postgres    false    316            =           1259    16828    CrmFormFields1    TABLE     �  CREATE TABLE public."CrmFormFields1" (
    "FieldId" integer DEFAULT nextval('public."CrmFormFields_FieldId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldLabel" text NOT NULL,
    "FieldType" integer NOT NULL,
    "Placeholder" text,
    "Values" text,
    "IsFixed" boolean NOT NULL,
    "Order" integer NOT NULL,
    "DisplayLabel" boolean NOT NULL,
    "CSS" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmFormFields1";
       public         heap    postgres    false    316    315            >           1259    16836    CrmFormFields100    TABLE     �  CREATE TABLE public."CrmFormFields100" (
    "FieldId" integer DEFAULT nextval('public."CrmFormFields_FieldId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldLabel" text NOT NULL,
    "FieldType" integer NOT NULL,
    "Placeholder" text,
    "Values" text,
    "IsFixed" boolean NOT NULL,
    "Order" integer NOT NULL,
    "DisplayLabel" boolean NOT NULL,
    "CSS" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 &   DROP TABLE public."CrmFormFields100";
       public         heap    postgres    false    316    315            ?           1259    16844    CrmFormFields2    TABLE     �  CREATE TABLE public."CrmFormFields2" (
    "FieldId" integer DEFAULT nextval('public."CrmFormFields_FieldId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldLabel" text NOT NULL,
    "FieldType" integer NOT NULL,
    "Placeholder" text,
    "Values" text,
    "IsFixed" boolean NOT NULL,
    "Order" integer NOT NULL,
    "DisplayLabel" boolean NOT NULL,
    "CSS" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmFormFields2";
       public         heap    postgres    false    316    315            @           1259    16852    CrmFormFields3    TABLE     �  CREATE TABLE public."CrmFormFields3" (
    "FieldId" integer DEFAULT nextval('public."CrmFormFields_FieldId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldLabel" text NOT NULL,
    "FieldType" integer NOT NULL,
    "Placeholder" text,
    "Values" text,
    "IsFixed" boolean NOT NULL,
    "Order" integer NOT NULL,
    "DisplayLabel" boolean NOT NULL,
    "CSS" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmFormFields3";
       public         heap    postgres    false    316    315            A           1259    16860    CrmFormResults    TABLE     �  CREATE TABLE public."CrmFormResults" (
    "ResultId" integer NOT NULL,
    "FormId" integer NOT NULL,
    "FieldId" integer NOT NULL,
    "Result" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 $   DROP TABLE public."CrmFormResults";
       public            postgres    false            B           1259    16865    CrmFormResults_ResultId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmFormResults_ResultId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."CrmFormResults_ResultId_seq";
       public          postgres    false    321            6           0    0    CrmFormResults_ResultId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CrmFormResults_ResultId_seq" OWNED BY public."CrmFormResults"."ResultId";
          public          postgres    false    322            C           1259    16866    CrmFormResults1    TABLE       CREATE TABLE public."CrmFormResults1" (
    "ResultId" integer DEFAULT nextval('public."CrmFormResults_ResultId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldId" integer NOT NULL,
    "Result" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."CrmFormResults1";
       public         heap    postgres    false    322    321            D           1259    16874    CrmFormResults100    TABLE       CREATE TABLE public."CrmFormResults100" (
    "ResultId" integer DEFAULT nextval('public."CrmFormResults_ResultId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldId" integer NOT NULL,
    "Result" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmFormResults100";
       public         heap    postgres    false    322    321            E           1259    16882    CrmFormResults2    TABLE       CREATE TABLE public."CrmFormResults2" (
    "ResultId" integer DEFAULT nextval('public."CrmFormResults_ResultId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldId" integer NOT NULL,
    "Result" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."CrmFormResults2";
       public         heap    postgres    false    322    321            F           1259    16890    CrmFormResults3    TABLE       CREATE TABLE public."CrmFormResults3" (
    "ResultId" integer DEFAULT nextval('public."CrmFormResults_ResultId_seq"'::regclass) NOT NULL,
    "FormId" integer NOT NULL,
    "FieldId" integer NOT NULL,
    "Result" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."CrmFormResults3";
       public         heap    postgres    false    322    321            �           1259    18684    CrmForms    TABLE     �  CREATE TABLE public."CrmForms" (
    "FormId" integer NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmForms";
       public            postgres    false            �           1259    18683    CrmForms_FormId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmForms_FormId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."CrmForms_FormId_seq";
       public          postgres    false    476            7           0    0    CrmForms_FormId_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."CrmForms_FormId_seq" OWNED BY public."CrmForms"."FormId";
          public          postgres    false    475            �           1259    18693 	   CrmForms1    TABLE     �  CREATE TABLE public."CrmForms1" (
    "FormId" integer DEFAULT nextval('public."CrmForms_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
    DROP TABLE public."CrmForms1";
       public         heap    postgres    false    475    476            �           1259    18704    CrmForms100    TABLE     �  CREATE TABLE public."CrmForms100" (
    "FormId" integer DEFAULT nextval('public."CrmForms_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 !   DROP TABLE public."CrmForms100";
       public         heap    postgres    false    475    476            �           1259    18715 	   CrmForms2    TABLE     �  CREATE TABLE public."CrmForms2" (
    "FormId" integer DEFAULT nextval('public."CrmForms_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
    DROP TABLE public."CrmForms2";
       public         heap    postgres    false    475    476            �           1259    18726 	   CrmForms3    TABLE     �  CREATE TABLE public."CrmForms3" (
    "FormId" integer DEFAULT nextval('public."CrmForms_FormId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "Description" text NOT NULL,
    "Code" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
    DROP TABLE public."CrmForms3";
       public         heap    postgres    false    475    476            G           1259    16898    CrmICallScenarios    TABLE     �   CREATE TABLE public."CrmICallScenarios" (
    "ReasonId" integer NOT NULL,
    "Title" text,
    "IsTask" integer DEFAULT 0,
    "IsShowResponse" integer,
    "IsDeleted" integer DEFAULT 0
);
 '   DROP TABLE public."CrmICallScenarios";
       public         heap    postgres    false            H           1259    16905    CrmICallScenarios_ReasonId_seq    SEQUENCE     �   ALTER TABLE public."CrmICallScenarios" ALTER COLUMN "ReasonId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."CrmICallScenarios_ReasonId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    327            �           1259    18803    CrmIScoringQuestion    TABLE     �  CREATE TABLE public."CrmIScoringQuestion" (
    "QuestionId" integer NOT NULL,
    "Code" text,
    "Title" text,
    "Order" integer NOT NULL,
    "TenantId" integer NOT NULL,
    "CreatedBy" text NOT NULL,
    "CreatedDate" timestamp with time zone NOT NULL,
    "LastModifiedDate" timestamp with time zone,
    "LastModifiedBy" text,
    "IsDeleted" integer,
    "ProductId" integer DEFAULT '-1'::integer NOT NULL,
    "Weightage" numeric DEFAULT 0 NOT NULL
);
 )   DROP TABLE public."CrmIScoringQuestion";
       public         heap    postgres    false            �           1259    18802 "   CrmIScoringQuestion_QuestionId_seq    SEQUENCE     �   ALTER TABLE public."CrmIScoringQuestion" ALTER COLUMN "QuestionId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."CrmIScoringQuestion_QuestionId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    482            I           1259    16906    CrmIndustry    TABLE     �  CREATE TABLE public."CrmIndustry" (
    "IndustryId" integer NOT NULL,
    "IndustryTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 !   DROP TABLE public."CrmIndustry";
       public            postgres    false            J           1259    16911    CrmIndustry_IndustryId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmIndustry_IndustryId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmIndustry_IndustryId_seq";
       public          postgres    false    329            8           0    0    CrmIndustry_IndustryId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmIndustry_IndustryId_seq" OWNED BY public."CrmIndustry"."IndustryId";
          public          postgres    false    330            K           1259    16912    CrmIndustryTenant1    TABLE     �  CREATE TABLE public."CrmIndustryTenant1" (
    "IndustryId" integer DEFAULT nextval('public."CrmIndustry_IndustryId_seq"'::regclass) NOT NULL,
    "IndustryTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmIndustryTenant1";
       public         heap    postgres    false    330    329            L           1259    16920    CrmIndustryTenant100    TABLE     �  CREATE TABLE public."CrmIndustryTenant100" (
    "IndustryId" integer DEFAULT nextval('public."CrmIndustry_IndustryId_seq"'::regclass) NOT NULL,
    "IndustryTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmIndustryTenant100";
       public         heap    postgres    false    330    329            M           1259    16928    CrmIndustryTenant2    TABLE     �  CREATE TABLE public."CrmIndustryTenant2" (
    "IndustryId" integer DEFAULT nextval('public."CrmIndustry_IndustryId_seq"'::regclass) NOT NULL,
    "IndustryTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmIndustryTenant2";
       public         heap    postgres    false    330    329            N           1259    16936    CrmIndustryTenant3    TABLE     �  CREATE TABLE public."CrmIndustryTenant3" (
    "IndustryId" integer DEFAULT nextval('public."CrmIndustry_IndustryId_seq"'::regclass) NOT NULL,
    "IndustryTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmIndustryTenant3";
       public         heap    postgres    false    330    329            O           1259    16944    CrmLead    TABLE     J  CREATE TABLE public."CrmLead" (
    "LeadId" integer NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Status" integer NOT NULL,
    "LeadOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProductId" integer,
    "CampaignId" text DEFAULT '-1'::text NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmLead";
       public            postgres    false            P           1259    16950    CrmLeadActivityLog    TABLE     +  CREATE TABLE public."CrmLeadActivityLog" (
    "ActivityId" integer NOT NULL,
    "LeadId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 (   DROP TABLE public."CrmLeadActivityLog";
       public            postgres    false            Q           1259    16955 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmLeadActivityLog_ActivityId_seq";
       public          postgres    false    336            9           0    0 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmLeadActivityLog_ActivityId_seq" OWNED BY public."CrmLeadActivityLog"."ActivityId";
          public          postgres    false    337            R           1259    16956    CrmLeadActivityLogTenant1    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant1" (
    "ActivityId" integer DEFAULT nextval('public."CrmLeadActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "LeadId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 /   DROP TABLE public."CrmLeadActivityLogTenant1";
       public         heap    postgres    false    337    336            S           1259    16964    CrmLeadActivityLogTenant100    TABLE     \  CREATE TABLE public."CrmLeadActivityLogTenant100" (
    "ActivityId" integer DEFAULT nextval('public."CrmLeadActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "LeadId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 1   DROP TABLE public."CrmLeadActivityLogTenant100";
       public         heap    postgres    false    337    336            T           1259    16972    CrmLeadActivityLogTenant2    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant2" (
    "ActivityId" integer DEFAULT nextval('public."CrmLeadActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "LeadId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 /   DROP TABLE public."CrmLeadActivityLogTenant2";
       public         heap    postgres    false    337    336            U           1259    16980    CrmLeadActivityLogTenant3    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant3" (
    "ActivityId" integer DEFAULT nextval('public."CrmLeadActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "LeadId" integer NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 /   DROP TABLE public."CrmLeadActivityLogTenant3";
       public         heap    postgres    false    337    336            �           1259    18813    CrmLeadScore    TABLE     �   CREATE TABLE public."CrmLeadScore" (
    "ScoreId" integer NOT NULL,
    "LeadId" integer,
    "QuestionId" integer,
    "Rating" numeric,
    "CreatedBy" text,
    "CreatedDate" timestamp with time zone
);
 "   DROP TABLE public."CrmLeadScore";
       public         heap    postgres    false            �           1259    18812    CrmLeadScore_ScoreId_seq    SEQUENCE     �   ALTER TABLE public."CrmLeadScore" ALTER COLUMN "ScoreId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."CrmLeadScore_ScoreId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    484            V           1259    16988    CrmLeadSource    TABLE     �  CREATE TABLE public."CrmLeadSource" (
    "SourceId" integer NOT NULL,
    "SourceTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 #   DROP TABLE public."CrmLeadSource";
       public            postgres    false            W           1259    16993    CrmLeadSource_SourceId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadSource_SourceId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmLeadSource_SourceId_seq";
       public          postgres    false    342            :           0    0    CrmLeadSource_SourceId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmLeadSource_SourceId_seq" OWNED BY public."CrmLeadSource"."SourceId";
          public          postgres    false    343            X           1259    16994    CrmLeadSourceTenant1    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant1" (
    "SourceId" integer DEFAULT nextval('public."CrmLeadSource_SourceId_seq"'::regclass) NOT NULL,
    "SourceTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmLeadSourceTenant1";
       public         heap    postgres    false    343    342            Y           1259    17002    CrmLeadSourceTenant100    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant100" (
    "SourceId" integer DEFAULT nextval('public."CrmLeadSource_SourceId_seq"'::regclass) NOT NULL,
    "SourceTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 ,   DROP TABLE public."CrmLeadSourceTenant100";
       public         heap    postgres    false    343    342            Z           1259    17010    CrmLeadSourceTenant2    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant2" (
    "SourceId" integer DEFAULT nextval('public."CrmLeadSource_SourceId_seq"'::regclass) NOT NULL,
    "SourceTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmLeadSourceTenant2";
       public         heap    postgres    false    343    342            [           1259    17018    CrmLeadSourceTenant3    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant3" (
    "SourceId" integer DEFAULT nextval('public."CrmLeadSource_SourceId_seq"'::regclass) NOT NULL,
    "SourceTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmLeadSourceTenant3";
       public         heap    postgres    false    343    342            \           1259    17026    CrmLeadStatus    TABLE     �  CREATE TABLE public."CrmLeadStatus" (
    "StatusId" integer NOT NULL,
    "StatusTitle" text NOT NULL,
    "IsDeletable" integer NOT NULL,
    "Order" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 #   DROP TABLE public."CrmLeadStatus";
       public            postgres    false            ]           1259    17031    CrmLeadStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmLeadStatus_StatusId_seq";
       public          postgres    false    348            ;           0    0    CrmLeadStatus_StatusId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmLeadStatus_StatusId_seq" OWNED BY public."CrmLeadStatus"."StatusId";
          public          postgres    false    349            ^           1259    17032    CrmLeadStatusTenant1    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant1" (
    "StatusId" integer DEFAULT nextval('public."CrmLeadStatus_StatusId_seq"'::regclass) NOT NULL,
    "StatusTitle" text NOT NULL,
    "IsDeletable" integer NOT NULL,
    "Order" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmLeadStatusTenant1";
       public         heap    postgres    false    349    348            _           1259    17040    CrmLeadStatusTenant100    TABLE     '  CREATE TABLE public."CrmLeadStatusTenant100" (
    "StatusId" integer DEFAULT nextval('public."CrmLeadStatus_StatusId_seq"'::regclass) NOT NULL,
    "StatusTitle" text NOT NULL,
    "IsDeletable" integer NOT NULL,
    "Order" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 ,   DROP TABLE public."CrmLeadStatusTenant100";
       public         heap    postgres    false    349    348            `           1259    17048    CrmLeadStatusTenant2    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant2" (
    "StatusId" integer DEFAULT nextval('public."CrmLeadStatus_StatusId_seq"'::regclass) NOT NULL,
    "StatusTitle" text NOT NULL,
    "IsDeletable" integer NOT NULL,
    "Order" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmLeadStatusTenant2";
       public         heap    postgres    false    349    348            a           1259    17056    CrmLeadStatusTenant3    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant3" (
    "StatusId" integer DEFAULT nextval('public."CrmLeadStatus_StatusId_seq"'::regclass) NOT NULL,
    "StatusTitle" text NOT NULL,
    "IsDeletable" integer NOT NULL,
    "Order" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmLeadStatusTenant3";
       public         heap    postgres    false    349    348            b           1259    17064    CrmLead_LeadId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLead_LeadId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmLead_LeadId_seq";
       public          postgres    false    335            <           0    0    CrmLead_LeadId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmLead_LeadId_seq" OWNED BY public."CrmLead"."LeadId";
          public          postgres    false    354            c           1259    17065    CrmLeadTenant1    TABLE     j  CREATE TABLE public."CrmLeadTenant1" (
    "LeadId" integer DEFAULT nextval('public."CrmLead_LeadId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Status" integer NOT NULL,
    "LeadOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProductId" integer,
    "CampaignId" text DEFAULT '-1'::text NOT NULL
);
 $   DROP TABLE public."CrmLeadTenant1";
       public         heap    postgres    false    354    335            d           1259    17074    CrmLeadTenant100    TABLE     l  CREATE TABLE public."CrmLeadTenant100" (
    "LeadId" integer DEFAULT nextval('public."CrmLead_LeadId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Status" integer NOT NULL,
    "LeadOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProductId" integer,
    "CampaignId" text DEFAULT '-1'::text NOT NULL
);
 &   DROP TABLE public."CrmLeadTenant100";
       public         heap    postgres    false    354    335            e           1259    17083    CrmLeadTenant2    TABLE     j  CREATE TABLE public."CrmLeadTenant2" (
    "LeadId" integer DEFAULT nextval('public."CrmLead_LeadId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Status" integer NOT NULL,
    "LeadOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProductId" integer,
    "CampaignId" text DEFAULT '-1'::text NOT NULL
);
 $   DROP TABLE public."CrmLeadTenant2";
       public         heap    postgres    false    354    335            f           1259    17092    CrmLeadTenant3    TABLE     j  CREATE TABLE public."CrmLeadTenant3" (
    "LeadId" integer DEFAULT nextval('public."CrmLead_LeadId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Status" integer NOT NULL,
    "LeadOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProductId" integer,
    "CampaignId" text DEFAULT '-1'::text NOT NULL
);
 $   DROP TABLE public."CrmLeadTenant3";
       public         heap    postgres    false    354    335            g           1259    17101 
   CrmMeeting    TABLE     �  CREATE TABLE public."CrmMeeting" (
    "MeetingId" integer NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "MeetingDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmMeeting";
       public            postgres    false            h           1259    17107    CrmMeeting_MeetingId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmMeeting_MeetingId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmMeeting_MeetingId_seq";
       public          postgres    false    359            =           0    0    CrmMeeting_MeetingId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmMeeting_MeetingId_seq" OWNED BY public."CrmMeeting"."MeetingId";
          public          postgres    false    360            i           1259    17108    CrmMeeting1    TABLE     �  CREATE TABLE public."CrmMeeting1" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "MeetingDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 !   DROP TABLE public."CrmMeeting1";
       public         heap    postgres    false    360    359            j           1259    17117    CrmMeeting100    TABLE     �  CREATE TABLE public."CrmMeeting100" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "MeetingDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 #   DROP TABLE public."CrmMeeting100";
       public         heap    postgres    false    360    359            k           1259    17126    CrmMeeting2    TABLE     �  CREATE TABLE public."CrmMeeting2" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "MeetingDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 !   DROP TABLE public."CrmMeeting2";
       public         heap    postgres    false    360    359            l           1259    17135    CrmMeeting3    TABLE     �  CREATE TABLE public."CrmMeeting3" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "MeetingDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 !   DROP TABLE public."CrmMeeting3";
       public         heap    postgres    false    360    359            m           1259    17144    CrmNote    TABLE       CREATE TABLE public."CrmNote" (
    "NoteId" integer NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmNote";
       public            postgres    false            n           1259    17150    CrmNoteTags    TABLE     �  CREATE TABLE public."CrmNoteTags" (
    "NoteTagsId" integer NOT NULL,
    "NoteId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 !   DROP TABLE public."CrmNoteTags";
       public            postgres    false            o           1259    17155    CrmNoteTags_NoteTagsId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNoteTags_NoteTagsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmNoteTags_NoteTagsId_seq";
       public          postgres    false    366            >           0    0    CrmNoteTags_NoteTagsId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmNoteTags_NoteTagsId_seq" OWNED BY public."CrmNoteTags"."NoteTagsId";
          public          postgres    false    367            p           1259    17156    CrmNoteTagsTenant1    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant1" (
    "NoteTagsId" integer DEFAULT nextval('public."CrmNoteTags_NoteTagsId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmNoteTagsTenant1";
       public         heap    postgres    false    367    366            q           1259    17164    CrmNoteTagsTenant100    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant100" (
    "NoteTagsId" integer DEFAULT nextval('public."CrmNoteTags_NoteTagsId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmNoteTagsTenant100";
       public         heap    postgres    false    367    366            r           1259    17172    CrmNoteTagsTenant2    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant2" (
    "NoteTagsId" integer DEFAULT nextval('public."CrmNoteTags_NoteTagsId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmNoteTagsTenant2";
       public         heap    postgres    false    367    366            s           1259    17180    CrmNoteTagsTenant3    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant3" (
    "NoteTagsId" integer DEFAULT nextval('public."CrmNoteTags_NoteTagsId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmNoteTagsTenant3";
       public         heap    postgres    false    367    366            t           1259    17188    CrmNoteTasks    TABLE     �  CREATE TABLE public."CrmNoteTasks" (
    "NoteTaskId" integer NOT NULL,
    "NoteId" integer NOT NULL,
    "Task" text NOT NULL,
    "IsCompleted" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 "   DROP TABLE public."CrmNoteTasks";
       public            postgres    false            u           1259    17193    CrmNoteTasks_NoteTaskId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNoteTasks_NoteTaskId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."CrmNoteTasks_NoteTaskId_seq";
       public          postgres    false    372            ?           0    0    CrmNoteTasks_NoteTaskId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CrmNoteTasks_NoteTaskId_seq" OWNED BY public."CrmNoteTasks"."NoteTaskId";
          public          postgres    false    373            v           1259    17194    CrmNoteTasksTenant1    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant1" (
    "NoteTaskId" integer DEFAULT nextval('public."CrmNoteTasks_NoteTaskId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "Task" text NOT NULL,
    "IsCompleted" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 )   DROP TABLE public."CrmNoteTasksTenant1";
       public         heap    postgres    false    373    372            w           1259    17202    CrmNoteTasksTenant100    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant100" (
    "NoteTaskId" integer DEFAULT nextval('public."CrmNoteTasks_NoteTaskId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "Task" text NOT NULL,
    "IsCompleted" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 +   DROP TABLE public."CrmNoteTasksTenant100";
       public         heap    postgres    false    373    372            x           1259    17210    CrmNoteTasksTenant2    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant2" (
    "NoteTaskId" integer DEFAULT nextval('public."CrmNoteTasks_NoteTaskId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "Task" text NOT NULL,
    "IsCompleted" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 )   DROP TABLE public."CrmNoteTasksTenant2";
       public         heap    postgres    false    373    372            y           1259    17218    CrmNoteTasksTenant3    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant3" (
    "NoteTaskId" integer DEFAULT nextval('public."CrmNoteTasks_NoteTaskId_seq"'::regclass) NOT NULL,
    "NoteId" integer NOT NULL,
    "Task" text NOT NULL,
    "IsCompleted" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 )   DROP TABLE public."CrmNoteTasksTenant3";
       public         heap    postgres    false    373    372            z           1259    17226    CrmNote_NoteId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNote_NoteId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmNote_NoteId_seq";
       public          postgres    false    365            @           0    0    CrmNote_NoteId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmNote_NoteId_seq" OWNED BY public."CrmNote"."NoteId";
          public          postgres    false    378            {           1259    17227    CrmNoteTenant1    TABLE     <  CREATE TABLE public."CrmNoteTenant1" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 $   DROP TABLE public."CrmNoteTenant1";
       public         heap    postgres    false    378    365            |           1259    17236    CrmNoteTenant100    TABLE     >  CREATE TABLE public."CrmNoteTenant100" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 &   DROP TABLE public."CrmNoteTenant100";
       public         heap    postgres    false    378    365            }           1259    17245    CrmNoteTenant2    TABLE     <  CREATE TABLE public."CrmNoteTenant2" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 $   DROP TABLE public."CrmNoteTenant2";
       public         heap    postgres    false    378    365            ~           1259    17254    CrmNoteTenant3    TABLE     <  CREATE TABLE public."CrmNoteTenant3" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 $   DROP TABLE public."CrmNoteTenant3";
       public         heap    postgres    false    378    365                       1259    17263    CrmOpportunity    TABLE     .  CREATE TABLE public."CrmOpportunity" (
    "OpportunityId" integer NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "StatusId" integer NOT NULL,
    "OpportunityOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "ProductId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 $   DROP TABLE public."CrmOpportunity";
       public            postgres    false            �           1259    17268     CrmOpportunity_OpportunityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmOpportunity_OpportunityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."CrmOpportunity_OpportunityId_seq";
       public          postgres    false    383            A           0    0     CrmOpportunity_OpportunityId_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."CrmOpportunity_OpportunityId_seq" OWNED BY public."CrmOpportunity"."OpportunityId";
          public          postgres    false    384            �           1259    17269    CrmOpportunity1    TABLE     V  CREATE TABLE public."CrmOpportunity1" (
    "OpportunityId" integer DEFAULT nextval('public."CrmOpportunity_OpportunityId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "StatusId" integer NOT NULL,
    "OpportunityOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "ProductId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."CrmOpportunity1";
       public         heap    postgres    false    384    383            �           1259    17277    CrmOpportunity100    TABLE     X  CREATE TABLE public."CrmOpportunity100" (
    "OpportunityId" integer DEFAULT nextval('public."CrmOpportunity_OpportunityId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "StatusId" integer NOT NULL,
    "OpportunityOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "ProductId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmOpportunity100";
       public         heap    postgres    false    384    383            �           1259    17285    CrmOpportunity2    TABLE     V  CREATE TABLE public."CrmOpportunity2" (
    "OpportunityId" integer DEFAULT nextval('public."CrmOpportunity_OpportunityId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "StatusId" integer NOT NULL,
    "OpportunityOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "ProductId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."CrmOpportunity2";
       public         heap    postgres    false    384    383            �           1259    17293    CrmOpportunity3    TABLE     V  CREATE TABLE public."CrmOpportunity3" (
    "OpportunityId" integer DEFAULT nextval('public."CrmOpportunity_OpportunityId_seq"'::regclass) NOT NULL,
    "Email" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "StatusId" integer NOT NULL,
    "OpportunityOwner" character varying(450) NOT NULL,
    "Mobile" text,
    "Work" text,
    "Address" text,
    "Street" text,
    "City" text,
    "Zip" text,
    "State" text,
    "Country" text,
    "SourceId" integer,
    "IndustryId" integer,
    "ProductId" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."CrmOpportunity3";
       public         heap    postgres    false    384    383            �           1259    17301    CrmOpportunityStatus    TABLE     �  CREATE TABLE public."CrmOpportunityStatus" (
    "StatusId" integer NOT NULL,
    "StatusTitle" text NOT NULL,
    "IsDeletable" integer NOT NULL,
    "Order" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmOpportunityStatus";
       public         heap    postgres    false            �           1259    17308 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmOpportunityStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmOpportunityStatus_StatusId_seq";
       public          postgres    false    389            B           0    0 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmOpportunityStatus_StatusId_seq" OWNED BY public."CrmOpportunityStatus"."StatusId";
          public          postgres    false    390            �           1259    17309 
   CrmProduct    TABLE     -  CREATE TABLE public."CrmProduct" (
    "ProductId" integer NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProjectId" integer DEFAULT '-1'::integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmProduct";
       public            postgres    false            �           1259    17315    CrmProduct_ProductId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmProduct_ProductId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmProduct_ProductId_seq";
       public          postgres    false    391            C           0    0    CrmProduct_ProductId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmProduct_ProductId_seq" OWNED BY public."CrmProduct"."ProductId";
          public          postgres    false    392            �           1259    17316    CrmProductTenant1    TABLE     S  CREATE TABLE public."CrmProductTenant1" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProjectId" integer DEFAULT '-1'::integer NOT NULL
);
 '   DROP TABLE public."CrmProductTenant1";
       public         heap    postgres    false    392    391            �           1259    17325    CrmProductTenant100    TABLE     U  CREATE TABLE public."CrmProductTenant100" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProjectId" integer DEFAULT '-1'::integer NOT NULL
);
 )   DROP TABLE public."CrmProductTenant100";
       public         heap    postgres    false    392    391            �           1259    17334    CrmProductTenant2    TABLE     S  CREATE TABLE public."CrmProductTenant2" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProjectId" integer DEFAULT '-1'::integer NOT NULL
);
 '   DROP TABLE public."CrmProductTenant2";
       public         heap    postgres    false    392    391            �           1259    17343    CrmProductTenant3    TABLE     S  CREATE TABLE public."CrmProductTenant3" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "ProjectId" integer DEFAULT '-1'::integer NOT NULL
);
 '   DROP TABLE public."CrmProductTenant3";
       public         heap    postgres    false    392    391            �           1259    17352 
   CrmProject    TABLE       CREATE TABLE public."CrmProject" (
    "ProjectId" integer NOT NULL,
    "Title" text,
    "CompanyId" integer NOT NULL,
    "Code" text,
    "Budget" numeric,
    "Description" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmProject";
       public            postgres    false            �           1259    17357    CrmProject_ProjectId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmProject_ProjectId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmProject_ProjectId_seq";
       public          postgres    false    397            D           0    0    CrmProject_ProjectId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmProject_ProjectId_seq" OWNED BY public."CrmProject"."ProjectId";
          public          postgres    false    398            �           1259    17358    CrmStatusLog    TABLE       CREATE TABLE public."CrmStatusLog" (
    "CreatedOn" timestamp with time zone,
    "Details" text,
    "LogId" integer NOT NULL,
    "TypeId" integer,
    "StatusTtile" text,
    "CreatedBy" text,
    "ActionId" integer,
    "TenantId" integer,
    "StatusId" integer
);
 "   DROP TABLE public."CrmStatusLog";
       public         heap    postgres    false            �           1259    17363    CrmStatusLog_LogId_seq    SEQUENCE     �   ALTER TABLE public."CrmStatusLog" ALTER COLUMN "LogId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."CrmStatusLog_LogId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    399            �           1259    17364 
   CrmTagUsed    TABLE        CREATE TABLE public."CrmTagUsed" (
    "TagUsedId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmTagUsed";
       public            postgres    false            �           1259    17369    CrmTagUsed_TagUsedId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTagUsed_TagUsedId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmTagUsed_TagUsedId_seq";
       public          postgres    false    401            E           0    0    CrmTagUsed_TagUsedId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmTagUsed_TagUsedId_seq" OWNED BY public."CrmTagUsed"."TagUsedId";
          public          postgres    false    402            �           1259    17370    CrmTagUsedTenant1    TABLE     &  CREATE TABLE public."CrmTagUsedTenant1" (
    "TagUsedId" integer DEFAULT nextval('public."CrmTagUsed_TagUsedId_seq"'::regclass) NOT NULL,
    "TagId" integer NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmTagUsedTenant1";
       public         heap    postgres    false    402    401            �           1259    17378    CrmTagUsedTenant100    TABLE     (  CREATE TABLE public."CrmTagUsedTenant100" (
    "TagUsedId" integer DEFAULT nextval('public."CrmTagUsed_TagUsedId_seq"'::regclass) NOT NULL,
    "TagId" integer NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 )   DROP TABLE public."CrmTagUsedTenant100";
       public         heap    postgres    false    402    401            �           1259    17386    CrmTagUsedTenant2    TABLE     &  CREATE TABLE public."CrmTagUsedTenant2" (
    "TagUsedId" integer DEFAULT nextval('public."CrmTagUsed_TagUsedId_seq"'::regclass) NOT NULL,
    "TagId" integer NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmTagUsedTenant2";
       public         heap    postgres    false    402    401            �           1259    17394    CrmTagUsedTenant3    TABLE     &  CREATE TABLE public."CrmTagUsedTenant3" (
    "TagUsedId" integer DEFAULT nextval('public."CrmTagUsed_TagUsedId_seq"'::regclass) NOT NULL,
    "TagId" integer NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmTagUsedTenant3";
       public         heap    postgres    false    402    401            �           1259    17402    CrmTags    TABLE     �  CREATE TABLE public."CrmTags" (
    "TagId" integer NOT NULL,
    "TagTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmTags";
       public            postgres    false            �           1259    17407    CrmTags_TagId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTags_TagId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."CrmTags_TagId_seq";
       public          postgres    false    407            F           0    0    CrmTags_TagId_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."CrmTags_TagId_seq" OWNED BY public."CrmTags"."TagId";
          public          postgres    false    408            �           1259    17408    CrmTagsTenant1    TABLE     �  CREATE TABLE public."CrmTagsTenant1" (
    "TagId" integer DEFAULT nextval('public."CrmTags_TagId_seq"'::regclass) NOT NULL,
    "TagTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmTagsTenant1";
       public         heap    postgres    false    408    407            �           1259    17416    CrmTagsTenant100    TABLE     �  CREATE TABLE public."CrmTagsTenant100" (
    "TagId" integer DEFAULT nextval('public."CrmTags_TagId_seq"'::regclass) NOT NULL,
    "TagTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 &   DROP TABLE public."CrmTagsTenant100";
       public         heap    postgres    false    408    407            �           1259    17424    CrmTagsTenant2    TABLE     �  CREATE TABLE public."CrmTagsTenant2" (
    "TagId" integer DEFAULT nextval('public."CrmTags_TagId_seq"'::regclass) NOT NULL,
    "TagTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmTagsTenant2";
       public         heap    postgres    false    408    407            �           1259    17432    CrmTagsTenant3    TABLE     �  CREATE TABLE public."CrmTagsTenant3" (
    "TagId" integer DEFAULT nextval('public."CrmTags_TagId_seq"'::regclass) NOT NULL,
    "TagTitle" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmTagsTenant3";
       public         heap    postgres    false    408    407            �           1259    17440    CrmTask    TABLE     %  CREATE TABLE public."CrmTask" (
    "TaskId" integer NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskTypeId" integer DEFAULT 5 NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmTask";
       public            postgres    false            �           1259    17449    CrmTaskPriority    TABLE     �  CREATE TABLE public."CrmTaskPriority" (
    "PriorityId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "PriorityTitle" text NOT NULL
);
 %   DROP TABLE public."CrmTaskPriority";
       public         heap    postgres    false            �           1259    17456    CrmTaskPriority_PriorityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskPriority_PriorityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."CrmTaskPriority_PriorityId_seq";
       public          postgres    false    414            G           0    0    CrmTaskPriority_PriorityId_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."CrmTaskPriority_PriorityId_seq" OWNED BY public."CrmTaskPriority"."PriorityId";
          public          postgres    false    415            �           1259    17457    CrmTaskStatus    TABLE     q  CREATE TABLE public."CrmTaskStatus" (
    "StatusId" integer NOT NULL,
    "StatusTitle" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL
);
 #   DROP TABLE public."CrmTaskStatus";
       public         heap    postgres    false            �           1259    17464    CrmTaskStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmTaskStatus_StatusId_seq";
       public          postgres    false    416            H           0    0    CrmTaskStatus_StatusId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmTaskStatus_StatusId_seq" OWNED BY public."CrmTaskStatus"."StatusId";
          public          postgres    false    417            �           1259    17465    CrmTaskTags    TABLE     �  CREATE TABLE public."CrmTaskTags" (
    "TaskTagsId" integer NOT NULL,
    "TaskId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 !   DROP TABLE public."CrmTaskTags";
       public            postgres    false            �           1259    17470    CrmTaskTags_TaskTagsId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskTags_TaskTagsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmTaskTags_TaskTagsId_seq";
       public          postgres    false    418            I           0    0    CrmTaskTags_TaskTagsId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmTaskTags_TaskTagsId_seq" OWNED BY public."CrmTaskTags"."TaskTagsId";
          public          postgres    false    419            �           1259    17471    CrmTaskTagsTenant1    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant1" (
    "TaskTagsId" integer DEFAULT nextval('public."CrmTaskTags_TaskTagsId_seq"'::regclass) NOT NULL,
    "TaskId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmTaskTagsTenant1";
       public         heap    postgres    false    419    418            �           1259    17479    CrmTaskTagsTenant100    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant100" (
    "TaskTagsId" integer DEFAULT nextval('public."CrmTaskTags_TaskTagsId_seq"'::regclass) NOT NULL,
    "TaskId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmTaskTagsTenant100";
       public         heap    postgres    false    419    418            �           1259    17487    CrmTaskTagsTenant2    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant2" (
    "TaskTagsId" integer DEFAULT nextval('public."CrmTaskTags_TaskTagsId_seq"'::regclass) NOT NULL,
    "TaskId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmTaskTagsTenant2";
       public         heap    postgres    false    419    418            �           1259    17495    CrmTaskTagsTenant3    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant3" (
    "TaskTagsId" integer DEFAULT nextval('public."CrmTaskTags_TaskTagsId_seq"'::regclass) NOT NULL,
    "TaskId" integer NOT NULL,
    "TagId" integer NOT NULL,
    "CreatedBy" text,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 (   DROP TABLE public."CrmTaskTagsTenant3";
       public         heap    postgres    false    419    418            �           1259    17503    CrmTask_TaskId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTask_TaskId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmTask_TaskId_seq";
       public          postgres    false    413            J           0    0    CrmTask_TaskId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmTask_TaskId_seq" OWNED BY public."CrmTask"."TaskId";
          public          postgres    false    424            �           1259    17504    CrmTaskTenant1    TABLE     E  CREATE TABLE public."CrmTaskTenant1" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskTypeId" integer DEFAULT 5 NOT NULL
);
 $   DROP TABLE public."CrmTaskTenant1";
       public         heap    postgres    false    424    413            �           1259    17516    CrmTaskTenant100    TABLE     G  CREATE TABLE public."CrmTaskTenant100" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskTypeId" integer DEFAULT 5 NOT NULL
);
 &   DROP TABLE public."CrmTaskTenant100";
       public         heap    postgres    false    424    413            �           1259    17528    CrmTaskTenant2    TABLE     E  CREATE TABLE public."CrmTaskTenant2" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskTypeId" integer DEFAULT 5 NOT NULL
);
 $   DROP TABLE public."CrmTaskTenant2";
       public         heap    postgres    false    424    413            �           1259    17540    CrmTaskTenant3    TABLE     E  CREATE TABLE public."CrmTaskTenant3" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "TaskTypeId" integer DEFAULT 5 NOT NULL
);
 $   DROP TABLE public."CrmTaskTenant3";
       public         heap    postgres    false    424    413            �           1259    17552    CrmTeam    TABLE     �  CREATE TABLE public."CrmTeam" (
    "TeamId" integer NOT NULL,
    "Name" text NOT NULL,
    "TeamLeader" character varying(450) NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmTeam";
       public            postgres    false            �           1259    17557    CrmTeamMember    TABLE     �  CREATE TABLE public."CrmTeamMember" (
    "TeamMemberId" integer NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "TeamId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 #   DROP TABLE public."CrmTeamMember";
       public            postgres    false            �           1259    17562    CrmTeamMember_TeamMemberId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTeamMember_TeamMemberId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."CrmTeamMember_TeamMemberId_seq";
       public          postgres    false    430            K           0    0    CrmTeamMember_TeamMemberId_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."CrmTeamMember_TeamMemberId_seq" OWNED BY public."CrmTeamMember"."TeamMemberId";
          public          postgres    false    431            �           1259    17563    CrmTeamMemberTenant1    TABLE       CREATE TABLE public."CrmTeamMemberTenant1" (
    "TeamMemberId" integer DEFAULT nextval('public."CrmTeamMember_TeamMemberId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "TeamId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmTeamMemberTenant1";
       public         heap    postgres    false    431    430            �           1259    17571    CrmTeamMemberTenant100    TABLE       CREATE TABLE public."CrmTeamMemberTenant100" (
    "TeamMemberId" integer DEFAULT nextval('public."CrmTeamMember_TeamMemberId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "TeamId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 ,   DROP TABLE public."CrmTeamMemberTenant100";
       public         heap    postgres    false    431    430            �           1259    17579    CrmTeamMemberTenant2    TABLE       CREATE TABLE public."CrmTeamMemberTenant2" (
    "TeamMemberId" integer DEFAULT nextval('public."CrmTeamMember_TeamMemberId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "TeamId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmTeamMemberTenant2";
       public         heap    postgres    false    431    430            �           1259    17587    CrmTeamMemberTenant3    TABLE       CREATE TABLE public."CrmTeamMemberTenant3" (
    "TeamMemberId" integer DEFAULT nextval('public."CrmTeamMember_TeamMemberId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "TeamId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmTeamMemberTenant3";
       public         heap    postgres    false    431    430            �           1259    17595    CrmTeam_TeamId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTeam_TeamId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmTeam_TeamId_seq";
       public          postgres    false    429            L           0    0    CrmTeam_TeamId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmTeam_TeamId_seq" OWNED BY public."CrmTeam"."TeamId";
          public          postgres    false    436            �           1259    17596    CrmTeamTenant1    TABLE     �  CREATE TABLE public."CrmTeamTenant1" (
    "TeamId" integer DEFAULT nextval('public."CrmTeam_TeamId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "TeamLeader" character varying(450) NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmTeamTenant1";
       public         heap    postgres    false    436    429            �           1259    17604    CrmTeamTenant100    TABLE        CREATE TABLE public."CrmTeamTenant100" (
    "TeamId" integer DEFAULT nextval('public."CrmTeam_TeamId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "TeamLeader" character varying(450) NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 &   DROP TABLE public."CrmTeamTenant100";
       public         heap    postgres    false    436    429            �           1259    17612    CrmTeamTenant2    TABLE     �  CREATE TABLE public."CrmTeamTenant2" (
    "TeamId" integer DEFAULT nextval('public."CrmTeam_TeamId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "TeamLeader" character varying(450) NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmTeamTenant2";
       public         heap    postgres    false    436    429            �           1259    17620    CrmTeamTenant3    TABLE     �  CREATE TABLE public."CrmTeamTenant3" (
    "TeamId" integer DEFAULT nextval('public."CrmTeam_TeamId_seq"'::regclass) NOT NULL,
    "Name" text NOT NULL,
    "TeamLeader" character varying(450) NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 $   DROP TABLE public."CrmTeamTenant3";
       public         heap    postgres    false    436    429            �           1259    17628    CrmUserActivityLog    TABLE     �  CREATE TABLE public."CrmUserActivityLog" (
    "ActivityId" integer NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "Action" text
)
PARTITION BY RANGE ("TenantId");
 (   DROP TABLE public."CrmUserActivityLog";
       public            postgres    false            �           1259    17635 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmUserActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmUserActivityLog_ActivityId_seq";
       public          postgres    false    441            M           0    0 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmUserActivityLog_ActivityId_seq" OWNED BY public."CrmUserActivityLog"."ActivityId";
          public          postgres    false    442            �           1259    17636    CrmUserActivityLogTenant1    TABLE       CREATE TABLE public."CrmUserActivityLogTenant1" (
    "ActivityId" integer DEFAULT nextval('public."CrmUserActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "Action" text
);
 /   DROP TABLE public."CrmUserActivityLogTenant1";
       public         heap    postgres    false    442    441            �           1259    17646    CrmUserActivityLogTenant100    TABLE     	  CREATE TABLE public."CrmUserActivityLogTenant100" (
    "ActivityId" integer DEFAULT nextval('public."CrmUserActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "Action" text
);
 1   DROP TABLE public."CrmUserActivityLogTenant100";
       public         heap    postgres    false    442    441            �           1259    17656    CrmUserActivityLogTenant2    TABLE       CREATE TABLE public."CrmUserActivityLogTenant2" (
    "ActivityId" integer DEFAULT nextval('public."CrmUserActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "Action" text
);
 /   DROP TABLE public."CrmUserActivityLogTenant2";
       public         heap    postgres    false    442    441            �           1259    17666    CrmUserActivityLogTenant3    TABLE       CREATE TABLE public."CrmUserActivityLogTenant3" (
    "ActivityId" integer DEFAULT nextval('public."CrmUserActivityLog_ActivityId_seq"'::regclass) NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "ActivityType" integer NOT NULL,
    "ActivityStatus" integer NOT NULL,
    "Detail" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Id" integer,
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL,
    "ContactActivityId" integer DEFAULT '-1'::integer NOT NULL,
    "Action" text
);
 /   DROP TABLE public."CrmUserActivityLogTenant3";
       public         heap    postgres    false    442    441            �           1259    17676    CrmUserActivityType    TABLE     �   CREATE TABLE public."CrmUserActivityType" (
    "ActivityTypeId" integer NOT NULL,
    "ActivityTypeTitle" text NOT NULL,
    "Icon" character varying(50) NOT NULL,
    "IsDeleted" integer DEFAULT 0
);
 )   DROP TABLE public."CrmUserActivityType";
       public         heap    postgres    false            �           1259    17682 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq";
       public          postgres    false    447            N           0    0 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq" OWNED BY public."CrmUserActivityType"."ActivityTypeId";
          public          postgres    false    448            �           1259    19051    NewCrmFormFieldTypes_TypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."NewCrmFormFieldTypes_TypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."NewCrmFormFieldTypes_TypeId_seq";
       public          postgres    false    492            O           0    0    NewCrmFormFieldTypes_TypeId_seq    SEQUENCE OWNED BY     f   ALTER SEQUENCE public."NewCrmFormFieldTypes_TypeId_seq" OWNED BY public."CrmFormFieldTypes"."TypeId";
          public          postgres    false    491            �           1259    18625    Notification    TABLE     =  CREATE TABLE public."Notification" (
    "NotificationId" integer NOT NULL,
    "Icon" text,
    "Image" text,
    "Title" text NOT NULL,
    "Description" text,
    "Link" text,
    "UseRouter" text,
    "Read" integer DEFAULT 0 NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
 "   DROP TABLE public."Notification";
       public            postgres    false            �           1259    18624    Notification_NotificationId_seq    SEQUENCE     �   CREATE SEQUENCE public."Notification_NotificationId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."Notification_NotificationId_seq";
       public          postgres    false    470            P           0    0    Notification_NotificationId_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."Notification_NotificationId_seq" OWNED BY public."Notification"."NotificationId";
          public          postgres    false    469            �           1259    18635    Notification1    TABLE     d  CREATE TABLE public."Notification1" (
    "NotificationId" integer DEFAULT nextval('public."Notification_NotificationId_seq"'::regclass) NOT NULL,
    "Icon" text,
    "Image" text,
    "Title" text NOT NULL,
    "Description" text,
    "Link" text,
    "UseRouter" text,
    "Read" integer DEFAULT 0 NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 #   DROP TABLE public."Notification1";
       public         heap    postgres    false    469    470            �           1259    18647    Notification100    TABLE     f  CREATE TABLE public."Notification100" (
    "NotificationId" integer DEFAULT nextval('public."Notification_NotificationId_seq"'::regclass) NOT NULL,
    "Icon" text,
    "Image" text,
    "Title" text NOT NULL,
    "Description" text,
    "Link" text,
    "UseRouter" text,
    "Read" integer DEFAULT 0 NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 %   DROP TABLE public."Notification100";
       public         heap    postgres    false    469    470            �           1259    18659    Notification2    TABLE     d  CREATE TABLE public."Notification2" (
    "NotificationId" integer DEFAULT nextval('public."Notification_NotificationId_seq"'::regclass) NOT NULL,
    "Icon" text,
    "Image" text,
    "Title" text NOT NULL,
    "Description" text,
    "Link" text,
    "UseRouter" text,
    "Read" integer DEFAULT 0 NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 #   DROP TABLE public."Notification2";
       public         heap    postgres    false    469    470            �           1259    18671    Notification3    TABLE     d  CREATE TABLE public."Notification3" (
    "NotificationId" integer DEFAULT nextval('public."Notification_NotificationId_seq"'::regclass) NOT NULL,
    "Icon" text,
    "Image" text,
    "Title" text NOT NULL,
    "Description" text,
    "Link" text,
    "UseRouter" text,
    "Read" integer DEFAULT 0 NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 #   DROP TABLE public."Notification3";
       public         heap    postgres    false    469    470            �           1259    17683    Tenant    TABLE     g  CREATE TABLE public."Tenant" (
    "TenantId" integer NOT NULL,
    "Name" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL
);
    DROP TABLE public."Tenant";
       public         heap    postgres    false            �           1259    18450    Ticket    TABLE     }  CREATE TABLE public."Ticket" (
    "TicketId" integer NOT NULL,
    "SocialMediaPlatform" character varying(255),
    "CustomerId" character varying(255),
    "Timestamp" timestamp with time zone,
    "AssigneeId" character varying(255),
    "Category" character varying(255),
    "ResolutionStatus" character varying(50),
    "DueDate" timestamp with time zone,
    "Notes" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "RecentlyActive" timestamp with time zone,
    "Priority" integer DEFAULT '-1'::integer,
    "Status" integer DEFAULT '-1'::integer,
    "Type" integer DEFAULT '-1'::integer
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."Ticket";
       public            postgres    false            �           1259    18449    Ticket_TicketId_seq    SEQUENCE     �   CREATE SEQUENCE public."Ticket_TicketId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."Ticket_TicketId_seq";
       public          postgres    false    452            Q           0    0    Ticket_TicketId_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."Ticket_TicketId_seq" OWNED BY public."Ticket"."TicketId";
          public          postgres    false    451            �           1259    18462    Ticket1    TABLE     �  CREATE TABLE public."Ticket1" (
    "TicketId" integer DEFAULT nextval('public."Ticket_TicketId_seq"'::regclass) NOT NULL,
    "SocialMediaPlatform" character varying(255),
    "CustomerId" character varying(255),
    "Timestamp" timestamp with time zone,
    "AssigneeId" character varying(255),
    "Category" character varying(255),
    "ResolutionStatus" character varying(50),
    "DueDate" timestamp with time zone,
    "Notes" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "RecentlyActive" timestamp with time zone,
    "Priority" integer DEFAULT '-1'::integer,
    "Status" integer DEFAULT '-1'::integer,
    "Type" integer DEFAULT '-1'::integer
);
    DROP TABLE public."Ticket1";
       public         heap    postgres    false    451    452            �           1259    18476 	   Ticket100    TABLE     �  CREATE TABLE public."Ticket100" (
    "TicketId" integer DEFAULT nextval('public."Ticket_TicketId_seq"'::regclass) NOT NULL,
    "SocialMediaPlatform" character varying(255),
    "CustomerId" character varying(255),
    "Timestamp" timestamp with time zone,
    "AssigneeId" character varying(255),
    "Category" character varying(255),
    "ResolutionStatus" character varying(50),
    "DueDate" timestamp with time zone,
    "Notes" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "RecentlyActive" timestamp with time zone,
    "Priority" integer DEFAULT '-1'::integer,
    "Status" integer DEFAULT '-1'::integer,
    "Type" integer DEFAULT '-1'::integer
);
    DROP TABLE public."Ticket100";
       public         heap    postgres    false    451    452            �           1259    18490    Ticket2    TABLE     �  CREATE TABLE public."Ticket2" (
    "TicketId" integer DEFAULT nextval('public."Ticket_TicketId_seq"'::regclass) NOT NULL,
    "SocialMediaPlatform" character varying(255),
    "CustomerId" character varying(255),
    "Timestamp" timestamp with time zone,
    "AssigneeId" character varying(255),
    "Category" character varying(255),
    "ResolutionStatus" character varying(50),
    "DueDate" timestamp with time zone,
    "Notes" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "RecentlyActive" timestamp with time zone,
    "Priority" integer DEFAULT '-1'::integer,
    "Status" integer DEFAULT '-1'::integer,
    "Type" integer DEFAULT '-1'::integer
);
    DROP TABLE public."Ticket2";
       public         heap    postgres    false    451    452            �           1259    18504    Ticket3    TABLE     �  CREATE TABLE public."Ticket3" (
    "TicketId" integer DEFAULT nextval('public."Ticket_TicketId_seq"'::regclass) NOT NULL,
    "SocialMediaPlatform" character varying(255),
    "CustomerId" character varying(255),
    "Timestamp" timestamp with time zone,
    "AssigneeId" character varying(255),
    "Category" character varying(255),
    "ResolutionStatus" character varying(50),
    "DueDate" timestamp with time zone,
    "Notes" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp with time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "RecentlyActive" timestamp with time zone,
    "Priority" integer DEFAULT '-1'::integer,
    "Status" integer DEFAULT '-1'::integer,
    "Type" integer DEFAULT '-1'::integer
);
    DROP TABLE public."Ticket3";
       public         heap    postgres    false    451    452            �           1259    18617    TicketPriority    TABLE     �   CREATE TABLE public."TicketPriority" (
    "TicketPriorityId" integer NOT NULL,
    "PriorityName" character varying(255) NOT NULL,
    "IsDeleted" integer DEFAULT 0
);
 $   DROP TABLE public."TicketPriority";
       public         heap    postgres    false            �           1259    18616 #   TicketPriority_TicketPriorityId_seq    SEQUENCE     �   CREATE SEQUENCE public."TicketPriority_TicketPriorityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."TicketPriority_TicketPriorityId_seq";
       public          postgres    false    468            R           0    0 #   TicketPriority_TicketPriorityId_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."TicketPriority_TicketPriorityId_seq" OWNED BY public."TicketPriority"."TicketPriorityId";
          public          postgres    false    467            �           1259    18607    TicketStatus    TABLE     �   CREATE TABLE public."TicketStatus" (
    "TicketStatusId" integer NOT NULL,
    "StatusName" character varying(255) NOT NULL,
    "IsDeleted" integer DEFAULT 0,
    "Class" text
);
 "   DROP TABLE public."TicketStatus";
       public         heap    postgres    false            �           1259    18606    TicketStatus_TicketStatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."TicketStatus_TicketStatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."TicketStatus_TicketStatusId_seq";
       public          postgres    false    466            S           0    0    TicketStatus_TicketStatusId_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."TicketStatus_TicketStatusId_seq" OWNED BY public."TicketStatus"."TicketStatusId";
          public          postgres    false    465            �           1259    18599 
   TicketType    TABLE     �   CREATE TABLE public."TicketType" (
    "TicketTypeId" integer NOT NULL,
    "TypeName" character varying(255) NOT NULL,
    "IsDeleted" integer DEFAULT 0
);
     DROP TABLE public."TicketType";
       public         heap    postgres    false            �           1259    18598    TicketType_TicketTypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."TicketType_TicketTypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."TicketType_TicketTypeId_seq";
       public          postgres    false    464            T           0    0    TicketType_TicketTypeId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."TicketType_TicketTypeId_seq" OWNED BY public."TicketType"."TicketTypeId";
          public          postgres    false    463            �           1259    17690    db2_aspnetusers    FOREIGN TABLE     �   CREATE FOREIGN TABLE public.db2_aspnetusers (
    "Id" character varying(450) NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL
)
SERVER db2_server
OPTIONS (
    schema_name 'public',
    table_name 'AspNetUsers'
);
 +   DROP FOREIGN TABLE public.db2_aspnetusers;
       public          postgres    false    2901            �           0    0    Conversation1    TABLE ATTACH     s   ALTER TABLE ONLY public."Conversation" ATTACH PARTITION public."Conversation1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    459    458            �           0    0    Conversation100    TABLE ATTACH     v   ALTER TABLE ONLY public."Conversation" ATTACH PARTITION public."Conversation100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    460    458            �           0    0    Conversation2    TABLE ATTACH     m   ALTER TABLE ONLY public."Conversation" ATTACH PARTITION public."Conversation2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    461    458            �           0    0    Conversation3    TABLE ATTACH     m   ALTER TABLE ONLY public."Conversation" ATTACH PARTITION public."Conversation3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    462    458            z           0    0    CrmAdAccount1    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    262    260            {           0    0    CrmAdAccount100    TABLE ATTACH     v   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    263    260            |           0    0    CrmAdAccount2    TABLE ATTACH     m   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    264    260            }           0    0    CrmAdAccount3    TABLE ATTACH     m   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    265    260            ~           0    0    CrmCalenderEventsTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    270    268                       0    0    CrmCalenderEventsTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    271    268            �           0    0    CrmCalenderEventsTenant2    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    272    268            �           0    0    CrmCalenderEventsTenant3    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    273    268            �           0    0    CrmCall1    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    276    274            �           0    0 
   CrmCall100    TABLE ATTACH     l   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    277    274            �           0    0    CrmCall2    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    278    274            �           0    0    CrmCall3    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    279    274            �           0    0    CrmCampaign1    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    281    280            �           0    0    CrmCampaign100    TABLE ATTACH     t   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    282    280            �           0    0    CrmCampaign2    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    283    280            �           0    0    CrmCampaign3    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    284    280            �           0    0    CrmCompanyActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    288    286            �           0    0    CrmCompanyActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    289    286            �           0    0    CrmCompanyActivityLogTenant2    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    290    286            �           0    0    CrmCompanyActivityLogTenant3    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    291    286            �           0    0    CrmCompanyMemberTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    294    292            �           0    0    CrmCompanyMemberTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    295    292            �           0    0    CrmCompanyMemberTenant2    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    296    292            �           0    0    CrmCompanyMemberTenant3    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    297    292            �           0    0    CrmCompanyTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    299    285            �           0    0    CrmCompanyTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    300    285            �           0    0    CrmCompanyTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    301    285            �           0    0    CrmCompanyTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    302    285            �           0    0    CrmCustomListsTenant1    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    305    303            �           0    0    CrmCustomListsTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    306    303            �           0    0    CrmCustomListsTenant2    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    307    303            �           0    0    CrmCustomListsTenant3    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    308    303            �           0    0 	   CrmEmail1    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    311    309            �           0    0    CrmEmail100    TABLE ATTACH     n   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    312    309            �           0    0 	   CrmEmail2    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    313    309            �           0    0 	   CrmEmail3    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    314    309            �           0    0    CrmForm1    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmForm" ATTACH PARTITION public."CrmForm1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    487    486                       0    0 
   CrmForm100    TABLE ATTACH     l   ALTER TABLE ONLY public."CrmForm" ATTACH PARTITION public."CrmForm100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    490    486            �           0    0    CrmForm2    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmForm" ATTACH PARTITION public."CrmForm2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    488    486                        0    0    CrmForm3    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmForm" ATTACH PARTITION public."CrmForm3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    489    486            �           0    0    CrmFormFields1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    317    315            �           0    0    CrmFormFields100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    318    315            �           0    0    CrmFormFields2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    319    315            �           0    0    CrmFormFields3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    320    315            �           0    0    CrmFormResults1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    323    321            �           0    0    CrmFormResults100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    324    321            �           0    0    CrmFormResults2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    325    321            �           0    0    CrmFormResults3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    326    321            �           0    0 	   CrmForms1    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmForms" ATTACH PARTITION public."CrmForms1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    477    476            �           0    0    CrmForms100    TABLE ATTACH     n   ALTER TABLE ONLY public."CrmForms" ATTACH PARTITION public."CrmForms100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    478    476            �           0    0 	   CrmForms2    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmForms" ATTACH PARTITION public."CrmForms2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    479    476            �           0    0 	   CrmForms3    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmForms" ATTACH PARTITION public."CrmForms3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    480    476            �           0    0    CrmIndustryTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    331    329            �           0    0    CrmIndustryTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    332    329            �           0    0    CrmIndustryTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    333    329            �           0    0    CrmIndustryTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    334    329            �           0    0    CrmLeadActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    338    336            �           0    0    CrmLeadActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    339    336            �           0    0    CrmLeadActivityLogTenant2    TABLE ATTACH        ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    340    336            �           0    0    CrmLeadActivityLogTenant3    TABLE ATTACH        ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    341    336            �           0    0    CrmLeadSourceTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    344    342            �           0    0    CrmLeadSourceTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    345    342            �           0    0    CrmLeadSourceTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    346    342            �           0    0    CrmLeadSourceTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    347    342            �           0    0    CrmLeadStatusTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    350    348            �           0    0    CrmLeadStatusTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    351    348            �           0    0    CrmLeadStatusTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    352    348            �           0    0    CrmLeadStatusTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    353    348            �           0    0    CrmLeadTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    355    335            �           0    0    CrmLeadTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    356    335            �           0    0    CrmLeadTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    357    335            �           0    0    CrmLeadTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    358    335            �           0    0    CrmMeeting1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    361    359            �           0    0    CrmMeeting100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    362    359            �           0    0    CrmMeeting2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    363    359            �           0    0    CrmMeeting3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    364    359            �           0    0    CrmNoteTagsTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    368    366            �           0    0    CrmNoteTagsTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    369    366            �           0    0    CrmNoteTagsTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    370    366            �           0    0    CrmNoteTagsTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    371    366            �           0    0    CrmNoteTasksTenant1    TABLE ATTACH     y   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    374    372            �           0    0    CrmNoteTasksTenant100    TABLE ATTACH     |   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    375    372            �           0    0    CrmNoteTasksTenant2    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    376    372            �           0    0    CrmNoteTasksTenant3    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    377    372            �           0    0    CrmNoteTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    379    365            �           0    0    CrmNoteTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    380    365            �           0    0    CrmNoteTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    381    365            �           0    0    CrmNoteTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    382    365            �           0    0    CrmOpportunity1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    385    383            �           0    0    CrmOpportunity100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    386    383            �           0    0    CrmOpportunity2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    387    383            �           0    0    CrmOpportunity3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    388    383            �           0    0    CrmProductTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    393    391            �           0    0    CrmProductTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    394    391            �           0    0    CrmProductTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    395    391            �           0    0    CrmProductTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    396    391            �           0    0    CrmTagUsedTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    403    401            �           0    0    CrmTagUsedTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    404    401            �           0    0    CrmTagUsedTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    405    401            �           0    0    CrmTagUsedTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    406    401            �           0    0    CrmTagsTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    409    407            �           0    0    CrmTagsTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    410    407            �           0    0    CrmTagsTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    411    407            �           0    0    CrmTagsTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    412    407            �           0    0    CrmTaskTagsTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    420    418            �           0    0    CrmTaskTagsTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    421    418            �           0    0    CrmTaskTagsTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    422    418            �           0    0    CrmTaskTagsTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    423    418            �           0    0    CrmTaskTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    425    413            �           0    0    CrmTaskTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    426    413            �           0    0    CrmTaskTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    427    413            �           0    0    CrmTaskTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    428    413            �           0    0    CrmTeamMemberTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    432    430            �           0    0    CrmTeamMemberTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    433    430            �           0    0    CrmTeamMemberTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    434    430            �           0    0    CrmTeamMemberTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    435    430            �           0    0    CrmTeamTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    437    429            �           0    0    CrmTeamTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    438    429            �           0    0    CrmTeamTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    439    429            �           0    0    CrmTeamTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    440    429            �           0    0    CrmUserActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    443    441            �           0    0    CrmUserActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    444    441            �           0    0    CrmUserActivityLogTenant2    TABLE ATTACH        ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    445    441            �           0    0    CrmUserActivityLogTenant3    TABLE ATTACH        ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    446    441            �           0    0    Notification1    TABLE ATTACH     s   ALTER TABLE ONLY public."Notification" ATTACH PARTITION public."Notification1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    471    470            �           0    0    Notification100    TABLE ATTACH     v   ALTER TABLE ONLY public."Notification" ATTACH PARTITION public."Notification100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    472    470            �           0    0    Notification2    TABLE ATTACH     m   ALTER TABLE ONLY public."Notification" ATTACH PARTITION public."Notification2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    473    470            �           0    0    Notification3    TABLE ATTACH     m   ALTER TABLE ONLY public."Notification" ATTACH PARTITION public."Notification3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    474    470            �           0    0    Ticket1    TABLE ATTACH     g   ALTER TABLE ONLY public."Ticket" ATTACH PARTITION public."Ticket1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    453    452            �           0    0 	   Ticket100    TABLE ATTACH     j   ALTER TABLE ONLY public."Ticket" ATTACH PARTITION public."Ticket100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    454    452            �           0    0    Ticket2    TABLE ATTACH     a   ALTER TABLE ONLY public."Ticket" ATTACH PARTITION public."Ticket2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    455    452            �           0    0    Ticket3    TABLE ATTACH     a   ALTER TABLE ONLY public."Ticket" ATTACH PARTITION public."Ticket3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    456    452                       2604    17693    AppMenus MenuId    DEFAULT     x   ALTER TABLE ONLY public."AppMenus" ALTER COLUMN "MenuId" SET DEFAULT nextval('public."AppMenus_MenuId_seq"'::regclass);
 B   ALTER TABLE public."AppMenus" ALTER COLUMN "MenuId" DROP DEFAULT;
       public          postgres    false    259    258            I           2604    18543    Conversation ConversationId    DEFAULT     �   ALTER TABLE ONLY public."Conversation" ALTER COLUMN "ConversationId" SET DEFAULT nextval('public."Conversation_ConversationId_seq"'::regclass);
 N   ALTER TABLE public."Conversation" ALTER COLUMN "ConversationId" DROP DEFAULT;
       public          postgres    false    458    457    458                       2604    17694    CrmAdAccount AccountId    DEFAULT     �   ALTER TABLE ONLY public."CrmAdAccount" ALTER COLUMN "AccountId" SET DEFAULT nextval('public."CrmAdAccount_AccountId_seq"'::regclass);
 I   ALTER TABLE public."CrmAdAccount" ALTER COLUMN "AccountId" DROP DEFAULT;
       public          postgres    false    261    260                       2604    17695    CrmCalendarEventsType TypeId    DEFAULT     �   ALTER TABLE ONLY public."CrmCalendarEventsType" ALTER COLUMN "TypeId" SET DEFAULT nextval('public."CrmCalendarEventsType_TypeId_seq"'::regclass);
 O   ALTER TABLE public."CrmCalendarEventsType" ALTER COLUMN "TypeId" DROP DEFAULT;
       public          postgres    false    267    266                       2604    17696    CrmCalenderEvents EventId    DEFAULT     �   ALTER TABLE ONLY public."CrmCalenderEvents" ALTER COLUMN "EventId" SET DEFAULT nextval('public."CrmCalenderEvents_EventId_seq"'::regclass);
 L   ALTER TABLE public."CrmCalenderEvents" ALTER COLUMN "EventId" DROP DEFAULT;
       public          postgres    false    269    268            4           2604    17697    CrmCall CallId    DEFAULT     v   ALTER TABLE ONLY public."CrmCall" ALTER COLUMN "CallId" SET DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass);
 A   ALTER TABLE public."CrmCall" ALTER COLUMN "CallId" DROP DEFAULT;
       public          postgres    false    275    274            a           2604    17698    CrmCompany CompanyId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompany" ALTER COLUMN "CompanyId" SET DEFAULT nextval('public."CrmCompany_CompanyId_seq"'::regclass);
 G   ALTER TABLE public."CrmCompany" ALTER COLUMN "CompanyId" DROP DEFAULT;
       public          postgres    false    298    285            d           2604    17699     CrmCompanyActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmCompanyActivityLog_ActivityId_seq"'::regclass);
 S   ALTER TABLE public."CrmCompanyActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    287    286            s           2604    17700    CrmCompanyMember MemberId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompanyMember" ALTER COLUMN "MemberId" SET DEFAULT nextval('public."CrmCompanyMember_MemberId_seq"'::regclass);
 L   ALTER TABLE public."CrmCompanyMember" ALTER COLUMN "MemberId" DROP DEFAULT;
       public          postgres    false    293    292            �           2604    17701    CrmCustomLists ListId    DEFAULT     �   ALTER TABLE ONLY public."CrmCustomLists" ALTER COLUMN "ListId" SET DEFAULT nextval('public."CrmCustomLists_ListId_seq"'::regclass);
 H   ALTER TABLE public."CrmCustomLists" ALTER COLUMN "ListId" DROP DEFAULT;
       public          postgres    false    304    303            �           2604    17702    CrmEmail EmailId    DEFAULT     z   ALTER TABLE ONLY public."CrmEmail" ALTER COLUMN "EmailId" SET DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass);
 C   ALTER TABLE public."CrmEmail" ALTER COLUMN "EmailId" DROP DEFAULT;
       public          postgres    false    310    309            �           2604    18908    CrmForm FormId    DEFAULT     v   ALTER TABLE ONLY public."CrmForm" ALTER COLUMN "FormId" SET DEFAULT nextval('public."CrmForm_FormId_seq"'::regclass);
 A   ALTER TABLE public."CrmForm" ALTER COLUMN "FormId" DROP DEFAULT;
       public          postgres    false    486    485    486            �           2604    19055    CrmFormFieldTypes TypeId    DEFAULT     �   ALTER TABLE ONLY public."CrmFormFieldTypes" ALTER COLUMN "TypeId" SET DEFAULT nextval('public."NewCrmFormFieldTypes_TypeId_seq"'::regclass);
 K   ALTER TABLE public."CrmFormFieldTypes" ALTER COLUMN "TypeId" DROP DEFAULT;
       public          postgres    false    492    491    492            �           2604    17703    CrmFormFields FieldId    DEFAULT     �   ALTER TABLE ONLY public."CrmFormFields" ALTER COLUMN "FieldId" SET DEFAULT nextval('public."CrmFormFields_FieldId_seq"'::regclass);
 H   ALTER TABLE public."CrmFormFields" ALTER COLUMN "FieldId" DROP DEFAULT;
       public          postgres    false    316    315            �           2604    17704    CrmFormResults ResultId    DEFAULT     �   ALTER TABLE ONLY public."CrmFormResults" ALTER COLUMN "ResultId" SET DEFAULT nextval('public."CrmFormResults_ResultId_seq"'::regclass);
 J   ALTER TABLE public."CrmFormResults" ALTER COLUMN "ResultId" DROP DEFAULT;
       public          postgres    false    322    321            w           2604    18687    CrmForms FormId    DEFAULT     x   ALTER TABLE ONLY public."CrmForms" ALTER COLUMN "FormId" SET DEFAULT nextval('public."CrmForms_FormId_seq"'::regclass);
 B   ALTER TABLE public."CrmForms" ALTER COLUMN "FormId" DROP DEFAULT;
       public          postgres    false    476    475    476            �           2604    17705    CrmIndustry IndustryId    DEFAULT     �   ALTER TABLE ONLY public."CrmIndustry" ALTER COLUMN "IndustryId" SET DEFAULT nextval('public."CrmIndustry_IndustryId_seq"'::regclass);
 I   ALTER TABLE public."CrmIndustry" ALTER COLUMN "IndustryId" DROP DEFAULT;
       public          postgres    false    330    329            �           2604    17706    CrmLead LeadId    DEFAULT     v   ALTER TABLE ONLY public."CrmLead" ALTER COLUMN "LeadId" SET DEFAULT nextval('public."CrmLead_LeadId_seq"'::regclass);
 A   ALTER TABLE public."CrmLead" ALTER COLUMN "LeadId" DROP DEFAULT;
       public          postgres    false    354    335            �           2604    17707    CrmLeadActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmLeadActivityLog_ActivityId_seq"'::regclass);
 P   ALTER TABLE public."CrmLeadActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    337    336            �           2604    17708    CrmLeadSource SourceId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadSource" ALTER COLUMN "SourceId" SET DEFAULT nextval('public."CrmLeadSource_SourceId_seq"'::regclass);
 I   ALTER TABLE public."CrmLeadSource" ALTER COLUMN "SourceId" DROP DEFAULT;
       public          postgres    false    343    342                       2604    17709    CrmLeadStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmLeadStatus_StatusId_seq"'::regclass);
 I   ALTER TABLE public."CrmLeadStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    349    348            &           2604    17710    CrmMeeting MeetingId    DEFAULT     �   ALTER TABLE ONLY public."CrmMeeting" ALTER COLUMN "MeetingId" SET DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass);
 G   ALTER TABLE public."CrmMeeting" ALTER COLUMN "MeetingId" DROP DEFAULT;
       public          postgres    false    360    359            ?           2604    17711    CrmNote NoteId    DEFAULT     v   ALTER TABLE ONLY public."CrmNote" ALTER COLUMN "NoteId" SET DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass);
 A   ALTER TABLE public."CrmNote" ALTER COLUMN "NoteId" DROP DEFAULT;
       public          postgres    false    378    365            C           2604    17712    CrmNoteTags NoteTagsId    DEFAULT     �   ALTER TABLE ONLY public."CrmNoteTags" ALTER COLUMN "NoteTagsId" SET DEFAULT nextval('public."CrmNoteTags_NoteTagsId_seq"'::regclass);
 I   ALTER TABLE public."CrmNoteTags" ALTER COLUMN "NoteTagsId" DROP DEFAULT;
       public          postgres    false    367    366            R           2604    17713    CrmNoteTasks NoteTaskId    DEFAULT     �   ALTER TABLE ONLY public."CrmNoteTasks" ALTER COLUMN "NoteTaskId" SET DEFAULT nextval('public."CrmNoteTasks_NoteTaskId_seq"'::regclass);
 J   ALTER TABLE public."CrmNoteTasks" ALTER COLUMN "NoteTaskId" DROP DEFAULT;
       public          postgres    false    373    372            q           2604    17714    CrmOpportunity OpportunityId    DEFAULT     �   ALTER TABLE ONLY public."CrmOpportunity" ALTER COLUMN "OpportunityId" SET DEFAULT nextval('public."CrmOpportunity_OpportunityId_seq"'::regclass);
 O   ALTER TABLE public."CrmOpportunity" ALTER COLUMN "OpportunityId" DROP DEFAULT;
       public          postgres    false    384    383            �           2604    17715    CrmOpportunityStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmOpportunityStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmOpportunityStatus_StatusId_seq"'::regclass);
 P   ALTER TABLE public."CrmOpportunityStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    390    389            �           2604    17716    CrmProduct ProductId    DEFAULT     �   ALTER TABLE ONLY public."CrmProduct" ALTER COLUMN "ProductId" SET DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass);
 G   ALTER TABLE public."CrmProduct" ALTER COLUMN "ProductId" DROP DEFAULT;
       public          postgres    false    392    391            �           2604    17717    CrmProject ProjectId    DEFAULT     �   ALTER TABLE ONLY public."CrmProject" ALTER COLUMN "ProjectId" SET DEFAULT nextval('public."CrmProject_ProjectId_seq"'::regclass);
 G   ALTER TABLE public."CrmProject" ALTER COLUMN "ProjectId" DROP DEFAULT;
       public          postgres    false    398    397            �           2604    17718    CrmTagUsed TagUsedId    DEFAULT     �   ALTER TABLE ONLY public."CrmTagUsed" ALTER COLUMN "TagUsedId" SET DEFAULT nextval('public."CrmTagUsed_TagUsedId_seq"'::regclass);
 G   ALTER TABLE public."CrmTagUsed" ALTER COLUMN "TagUsedId" DROP DEFAULT;
       public          postgres    false    402    401            �           2604    17719    CrmTags TagId    DEFAULT     t   ALTER TABLE ONLY public."CrmTags" ALTER COLUMN "TagId" SET DEFAULT nextval('public."CrmTags_TagId_seq"'::regclass);
 @   ALTER TABLE public."CrmTags" ALTER COLUMN "TagId" DROP DEFAULT;
       public          postgres    false    408    407            �           2604    17720    CrmTask TaskId    DEFAULT     v   ALTER TABLE ONLY public."CrmTask" ALTER COLUMN "TaskId" SET DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass);
 A   ALTER TABLE public."CrmTask" ALTER COLUMN "TaskId" DROP DEFAULT;
       public          postgres    false    424    413            �           2604    17721    CrmTaskPriority PriorityId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskPriority" ALTER COLUMN "PriorityId" SET DEFAULT nextval('public."CrmTaskPriority_PriorityId_seq"'::regclass);
 M   ALTER TABLE public."CrmTaskPriority" ALTER COLUMN "PriorityId" DROP DEFAULT;
       public          postgres    false    415    414            �           2604    17722    CrmTaskStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmTaskStatus_StatusId_seq"'::regclass);
 I   ALTER TABLE public."CrmTaskStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    417    416            �           2604    17723    CrmTaskTags TaskTagsId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskTags" ALTER COLUMN "TaskTagsId" SET DEFAULT nextval('public."CrmTaskTags_TaskTagsId_seq"'::regclass);
 I   ALTER TABLE public."CrmTaskTags" ALTER COLUMN "TaskTagsId" DROP DEFAULT;
       public          postgres    false    419    418            �           2604    17724    CrmTeam TeamId    DEFAULT     v   ALTER TABLE ONLY public."CrmTeam" ALTER COLUMN "TeamId" SET DEFAULT nextval('public."CrmTeam_TeamId_seq"'::regclass);
 A   ALTER TABLE public."CrmTeam" ALTER COLUMN "TeamId" DROP DEFAULT;
       public          postgres    false    436    429            �           2604    17725    CrmTeamMember TeamMemberId    DEFAULT     �   ALTER TABLE ONLY public."CrmTeamMember" ALTER COLUMN "TeamMemberId" SET DEFAULT nextval('public."CrmTeamMember_TeamMemberId_seq"'::regclass);
 M   ALTER TABLE public."CrmTeamMember" ALTER COLUMN "TeamMemberId" DROP DEFAULT;
       public          postgres    false    431    430                       2604    17726    CrmUserActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmUserActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmUserActivityLog_ActivityId_seq"'::regclass);
 P   ALTER TABLE public."CrmUserActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    442    441            '           2604    17727 "   CrmUserActivityType ActivityTypeId    DEFAULT     �   ALTER TABLE ONLY public."CrmUserActivityType" ALTER COLUMN "ActivityTypeId" SET DEFAULT nextval('public."CrmUserActivityType_ActivityTypeId_seq"'::regclass);
 U   ALTER TABLE public."CrmUserActivityType" ALTER COLUMN "ActivityTypeId" DROP DEFAULT;
       public          postgres    false    448    447            c           2604    18628    Notification NotificationId    DEFAULT     �   ALTER TABLE ONLY public."Notification" ALTER COLUMN "NotificationId" SET DEFAULT nextval('public."Notification_NotificationId_seq"'::regclass);
 N   ALTER TABLE public."Notification" ALTER COLUMN "NotificationId" DROP DEFAULT;
       public          postgres    false    469    470    470            +           2604    18453    Ticket TicketId    DEFAULT     x   ALTER TABLE ONLY public."Ticket" ALTER COLUMN "TicketId" SET DEFAULT nextval('public."Ticket_TicketId_seq"'::regclass);
 B   ALTER TABLE public."Ticket" ALTER COLUMN "TicketId" DROP DEFAULT;
       public          postgres    false    451    452    452            a           2604    18620    TicketPriority TicketPriorityId    DEFAULT     �   ALTER TABLE ONLY public."TicketPriority" ALTER COLUMN "TicketPriorityId" SET DEFAULT nextval('public."TicketPriority_TicketPriorityId_seq"'::regclass);
 R   ALTER TABLE public."TicketPriority" ALTER COLUMN "TicketPriorityId" DROP DEFAULT;
       public          postgres    false    468    467    468            _           2604    18610    TicketStatus TicketStatusId    DEFAULT     �   ALTER TABLE ONLY public."TicketStatus" ALTER COLUMN "TicketStatusId" SET DEFAULT nextval('public."TicketStatus_TicketStatusId_seq"'::regclass);
 N   ALTER TABLE public."TicketStatus" ALTER COLUMN "TicketStatusId" DROP DEFAULT;
       public          postgres    false    465    466    466            ]           2604    18602    TicketType TicketTypeId    DEFAULT     �   ALTER TABLE ONLY public."TicketType" ALTER COLUMN "TicketTypeId" SET DEFAULT nextval('public."TicketType_TicketTypeId_seq"'::regclass);
 J   ALTER TABLE public."TicketType" ALTER COLUMN "TicketTypeId" DROP DEFAULT;
       public          postgres    false    464    463    464            Z          0    16430    AppMenus 
   TABLE DATA           �   COPY public."AppMenus" ("MenuId", "Code", "Title", "Subtitle", "Type", "Icon", "Link", "Level", "CreatedBy", "CreatedOn", "LastModifiedBy", "LastModifiedOn", "IsDeleted", "ParentId", "Order") FROM stdin;
    public          postgres    false    258   �^                0    18550    Conversation1 
   TABLE DATA           a  COPY public."Conversation1" ("ConversationId", "TicketId", "FromId", "ToId", "Timestamp", "MessageType", "MessageBody", "MediaType", "ReadStatus", "Reaction", "ForwardedStatus", "Location", "MessageStatus", "EventType", "CustomerFeedback", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsMine") FROM stdin;
    public          postgres    false    459   �a                0    18562    Conversation100 
   TABLE DATA           c  COPY public."Conversation100" ("ConversationId", "TicketId", "FromId", "ToId", "Timestamp", "MessageType", "MessageBody", "MediaType", "ReadStatus", "Reaction", "ForwardedStatus", "Location", "MessageStatus", "EventType", "CustomerFeedback", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsMine") FROM stdin;
    public          postgres    false    460   �a                0    18574    Conversation2 
   TABLE DATA           a  COPY public."Conversation2" ("ConversationId", "TicketId", "FromId", "ToId", "Timestamp", "MessageType", "MessageBody", "MediaType", "ReadStatus", "Reaction", "ForwardedStatus", "Location", "MessageStatus", "EventType", "CustomerFeedback", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsMine") FROM stdin;
    public          postgres    false    461   b                0    18586    Conversation3 
   TABLE DATA           a  COPY public."Conversation3" ("ConversationId", "TicketId", "FromId", "ToId", "Timestamp", "MessageType", "MessageBody", "MediaType", "ReadStatus", "Reaction", "ForwardedStatus", "Location", "MessageStatus", "EventType", "CustomerFeedback", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsMine") FROM stdin;
    public          postgres    false    462   -b      ]          0    16444    CrmAdAccount1 
   TABLE DATA           �   COPY public."CrmAdAccount1" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    262   Jb      ^          0    16452    CrmAdAccount100 
   TABLE DATA           �   COPY public."CrmAdAccount100" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    263   gb      _          0    16460    CrmAdAccount2 
   TABLE DATA           �   COPY public."CrmAdAccount2" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    264   �b      `          0    16468    CrmAdAccount3 
   TABLE DATA           �   COPY public."CrmAdAccount3" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    265   �b      a          0    16476    CrmCalendarEventsType 
   TABLE DATA           U   COPY public."CrmCalendarEventsType" ("TypeId", "TypeTitle", "IsDeleted") FROM stdin;
    public          postgres    false    266   �b      d          0    16492    CrmCalenderEventsTenant1 
   TABLE DATA             COPY public."CrmCalenderEventsTenant1" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    270   c      e          0    16503    CrmCalenderEventsTenant100 
   TABLE DATA             COPY public."CrmCalenderEventsTenant100" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    271   e      f          0    16514    CrmCalenderEventsTenant2 
   TABLE DATA             COPY public."CrmCalenderEventsTenant2" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    272   !e      g          0    16525    CrmCalenderEventsTenant3 
   TABLE DATA             COPY public."CrmCalenderEventsTenant3" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    273   >e      i          0    16545    CrmCall1 
   TABLE DATA           �   COPY public."CrmCall1" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId", "CallDate") FROM stdin;
    public          postgres    false    276   [e      j          0    16556 
   CrmCall100 
   TABLE DATA           �   COPY public."CrmCall100" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId", "CallDate") FROM stdin;
    public          postgres    false    277   uf      k          0    16567    CrmCall2 
   TABLE DATA           �   COPY public."CrmCall2" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId", "CallDate") FROM stdin;
    public          postgres    false    278   �f      l          0    16578    CrmCall3 
   TABLE DATA           �   COPY public."CrmCall3" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId", "CallDate") FROM stdin;
    public          postgres    false    279   �f      m          0    16594    CrmCampaign1 
   TABLE DATA           �   COPY public."CrmCampaign1" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    281   �f      n          0    16601    CrmCampaign100 
   TABLE DATA           �   COPY public."CrmCampaign100" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    282   Ng      o          0    16608    CrmCampaign2 
   TABLE DATA           �   COPY public."CrmCampaign2" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    283   kg      p          0    16615    CrmCampaign3 
   TABLE DATA           �   COPY public."CrmCampaign3" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    284   �g      r          0    16633    CrmCompanyActivityLogTenant1 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant1" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    288   �g      s          0    16641    CrmCompanyActivityLogTenant100 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant100" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    289   �g      t          0    16649    CrmCompanyActivityLogTenant2 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant2" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    290   �g      u          0    16657    CrmCompanyActivityLogTenant3 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant3" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    291   �g      w          0    16671    CrmCompanyMemberTenant1 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant1" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    294   h      x          0    16679    CrmCompanyMemberTenant100 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant100" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    295   6h      y          0    16687    CrmCompanyMemberTenant2 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant2" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    296   Sh      z          0    16695    CrmCompanyMemberTenant3 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant3" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    297   ph      |          0    16704    CrmCompanyTenant1 
   TABLE DATA           �  COPY public."CrmCompanyTenant1" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    299   �h      }          0    16712    CrmCompanyTenant100 
   TABLE DATA           �  COPY public."CrmCompanyTenant100" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    300   �h      ~          0    16720    CrmCompanyTenant2 
   TABLE DATA           �  COPY public."CrmCompanyTenant2" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    301   �h                0    16728    CrmCompanyTenant3 
   TABLE DATA           �  COPY public."CrmCompanyTenant3" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    302   �h      �          0    16743    CrmCustomListsTenant1 
   TABLE DATA           �   COPY public."CrmCustomListsTenant1" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    305   i      �          0    16752    CrmCustomListsTenant100 
   TABLE DATA           �   COPY public."CrmCustomListsTenant100" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    306   Wj      �          0    16761    CrmCustomListsTenant2 
   TABLE DATA           �   COPY public."CrmCustomListsTenant2" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    307   tj      �          0    16770    CrmCustomListsTenant3 
   TABLE DATA           �   COPY public."CrmCustomListsTenant3" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    308   �j      �          0    16786 	   CrmEmail1 
   TABLE DATA           �   COPY public."CrmEmail1" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    311   �j      �          0    16795    CrmEmail100 
   TABLE DATA           �   COPY public."CrmEmail100" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    312   �k      �          0    16804 	   CrmEmail2 
   TABLE DATA           �   COPY public."CrmEmail2" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    313   �k      �          0    16813 	   CrmEmail3 
   TABLE DATA           �   COPY public."CrmEmail3" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    314   �k                0    18993    CrmForm1 
   TABLE DATA           �   COPY public."CrmForm1" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    487   �k                0    19023 
   CrmForm100 
   TABLE DATA           �   COPY public."CrmForm100" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    490   �l                0    19003    CrmForm2 
   TABLE DATA           �   COPY public."CrmForm2" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    488   �l                0    19013    CrmForm3 
   TABLE DATA           �   COPY public."CrmForm3" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    489   �l                 0    19052    CrmFormFieldTypes 
   TABLE DATA           �   COPY public."CrmFormFieldTypes" ("TypeId", "TypeName", "TypeLabel", "Icon", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted") FROM stdin;
    public          postgres    false    492   m      �          0    16828    CrmFormFields1 
   TABLE DATA           �   COPY public."CrmFormFields1" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    317   n      �          0    16836    CrmFormFields100 
   TABLE DATA           �   COPY public."CrmFormFields100" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    318   �o      �          0    16844    CrmFormFields2 
   TABLE DATA           �   COPY public."CrmFormFields2" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    319   �o      �          0    16852    CrmFormFields3 
   TABLE DATA           �   COPY public."CrmFormFields3" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    320   �o      �          0    16866    CrmFormResults1 
   TABLE DATA           �   COPY public."CrmFormResults1" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    323   �o      �          0    16874    CrmFormResults100 
   TABLE DATA           �   COPY public."CrmFormResults100" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    324   p      �          0    16882    CrmFormResults2 
   TABLE DATA           �   COPY public."CrmFormResults2" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    325   p      �          0    16890    CrmFormResults3 
   TABLE DATA           �   COPY public."CrmFormResults3" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    326   <p                0    18693 	   CrmForms1 
   TABLE DATA           �   COPY public."CrmForms1" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    477   Yp                0    18704    CrmForms100 
   TABLE DATA           �   COPY public."CrmForms100" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    478   vp                0    18715 	   CrmForms2 
   TABLE DATA           �   COPY public."CrmForms2" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    479   �p                0    18726 	   CrmForms3 
   TABLE DATA           �   COPY public."CrmForms3" ("FormId", "Name", "Description", "Code", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    480   �p      �          0    16898    CrmICallScenarios 
   TABLE DATA           k   COPY public."CrmICallScenarios" ("ReasonId", "Title", "IsTask", "IsShowResponse", "IsDeleted") FROM stdin;
    public          postgres    false    327   �p                0    18803    CrmIScoringQuestion 
   TABLE DATA           �   COPY public."CrmIScoringQuestion" ("QuestionId", "Code", "Title", "Order", "TenantId", "CreatedBy", "CreatedDate", "LastModifiedDate", "LastModifiedBy", "IsDeleted", "ProductId", "Weightage") FROM stdin;
    public          postgres    false    482   �q      �          0    16912    CrmIndustryTenant1 
   TABLE DATA           �   COPY public."CrmIndustryTenant1" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    331   Tr      �          0    16920    CrmIndustryTenant100 
   TABLE DATA           �   COPY public."CrmIndustryTenant100" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    332   �s      �          0    16928    CrmIndustryTenant2 
   TABLE DATA           �   COPY public."CrmIndustryTenant2" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    333   t      �          0    16936    CrmIndustryTenant3 
   TABLE DATA           �   COPY public."CrmIndustryTenant3" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    334   (t      �          0    16956    CrmLeadActivityLogTenant1 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant1" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    338   Et      �          0    16964    CrmLeadActivityLogTenant100 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant100" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    339   bt      �          0    16972    CrmLeadActivityLogTenant2 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant2" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    340   t      �          0    16980    CrmLeadActivityLogTenant3 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant3" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    341   �t                0    18813    CrmLeadScore 
   TABLE DATA           q   COPY public."CrmLeadScore" ("ScoreId", "LeadId", "QuestionId", "Rating", "CreatedBy", "CreatedDate") FROM stdin;
    public          postgres    false    484   �t      �          0    16994    CrmLeadSourceTenant1 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant1" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    344   =u      �          0    17002    CrmLeadSourceTenant100 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant100" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    345   �u      �          0    17010    CrmLeadSourceTenant2 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant2" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    346   v      �          0    17018    CrmLeadSourceTenant3 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant3" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    347   %v      �          0    17032    CrmLeadStatusTenant1 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant1" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    350   Bv      �          0    17040    CrmLeadStatusTenant100 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant100" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    351   �v      �          0    17048    CrmLeadStatusTenant2 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant2" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    352   �v      �          0    17056    CrmLeadStatusTenant3 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant3" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    353   	w      �          0    17065    CrmLeadTenant1 
   TABLE DATA           G  COPY public."CrmLeadTenant1" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    355   &w      �          0    17074    CrmLeadTenant100 
   TABLE DATA           I  COPY public."CrmLeadTenant100" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    356   &x      �          0    17083    CrmLeadTenant2 
   TABLE DATA           G  COPY public."CrmLeadTenant2" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    357   Cx      �          0    17092    CrmLeadTenant3 
   TABLE DATA           G  COPY public."CrmLeadTenant3" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    358   `x      �          0    17108    CrmMeeting1 
   TABLE DATA           �   COPY public."CrmMeeting1" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId", "MeetingDate") FROM stdin;
    public          postgres    false    361   }x      �          0    17117    CrmMeeting100 
   TABLE DATA           �   COPY public."CrmMeeting100" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId", "MeetingDate") FROM stdin;
    public          postgres    false    362   �y      �          0    17126    CrmMeeting2 
   TABLE DATA           �   COPY public."CrmMeeting2" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId", "MeetingDate") FROM stdin;
    public          postgres    false    363   �y      �          0    17135    CrmMeeting3 
   TABLE DATA           �   COPY public."CrmMeeting3" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId", "MeetingDate") FROM stdin;
    public          postgres    false    364   �y      �          0    17156    CrmNoteTagsTenant1 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant1" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    368   z      �          0    17164    CrmNoteTagsTenant100 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant100" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    369   nz      �          0    17172    CrmNoteTagsTenant2 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant2" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    370   �z      �          0    17180    CrmNoteTagsTenant3 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant3" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    371   �z      �          0    17194    CrmNoteTasksTenant1 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant1" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    374   �z      �          0    17202    CrmNoteTasksTenant100 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant100" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    375   9{      �          0    17210    CrmNoteTasksTenant2 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant2" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    376   V{      �          0    17218    CrmNoteTasksTenant3 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant3" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    377   s{      �          0    17227    CrmNoteTenant1 
   TABLE DATA           �   COPY public."CrmNoteTenant1" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    379   �{      �          0    17236    CrmNoteTenant100 
   TABLE DATA           �   COPY public."CrmNoteTenant100" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    380   |      �          0    17245    CrmNoteTenant2 
   TABLE DATA           �   COPY public."CrmNoteTenant2" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    381   "|      �          0    17254    CrmNoteTenant3 
   TABLE DATA           �   COPY public."CrmNoteTenant3" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    382   ?|      �          0    17269    CrmOpportunity1 
   TABLE DATA           J  COPY public."CrmOpportunity1" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    385   \|      �          0    17277    CrmOpportunity100 
   TABLE DATA           L  COPY public."CrmOpportunity100" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    386   y|      �          0    17285    CrmOpportunity2 
   TABLE DATA           J  COPY public."CrmOpportunity2" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    387   �|      �          0    17293    CrmOpportunity3 
   TABLE DATA           J  COPY public."CrmOpportunity3" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    388   �|      �          0    17301    CrmOpportunityStatus 
   TABLE DATA           �   COPY public."CrmOpportunityStatus" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    389   �|      �          0    17316    CrmProductTenant1 
   TABLE DATA           �   COPY public."CrmProductTenant1" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    393   a}      �          0    17325    CrmProductTenant100 
   TABLE DATA           �   COPY public."CrmProductTenant100" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    394   �~      �          0    17334    CrmProductTenant2 
   TABLE DATA           �   COPY public."CrmProductTenant2" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    395   �~      �          0    17343    CrmProductTenant3 
   TABLE DATA           �   COPY public."CrmProductTenant3" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    396   �~      �          0    17358    CrmStatusLog 
   TABLE DATA           �   COPY public."CrmStatusLog" ("CreatedOn", "Details", "LogId", "TypeId", "StatusTtile", "CreatedBy", "ActionId", "TenantId", "StatusId") FROM stdin;
    public          postgres    false    399   �~      �          0    17370    CrmTagUsedTenant1 
   TABLE DATA           �   COPY public."CrmTagUsedTenant1" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    403   �      �          0    17378    CrmTagUsedTenant100 
   TABLE DATA           �   COPY public."CrmTagUsedTenant100" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    404   �      �          0    17386    CrmTagUsedTenant2 
   TABLE DATA           �   COPY public."CrmTagUsedTenant2" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    405   �      �          0    17394    CrmTagUsedTenant3 
   TABLE DATA           �   COPY public."CrmTagUsedTenant3" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    406   ;�      �          0    17408    CrmTagsTenant1 
   TABLE DATA           �   COPY public."CrmTagsTenant1" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    409   X�      �          0    17416    CrmTagsTenant100 
   TABLE DATA           �   COPY public."CrmTagsTenant100" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    410   ��      �          0    17424    CrmTagsTenant2 
   TABLE DATA           �   COPY public."CrmTagsTenant2" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    411   ƃ      �          0    17432    CrmTagsTenant3 
   TABLE DATA           �   COPY public."CrmTagsTenant3" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    412   �      �          0    17449    CrmTaskPriority 
   TABLE DATA           �   COPY public."CrmTaskPriority" ("PriorityId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "PriorityTitle") FROM stdin;
    public          postgres    false    414    �      �          0    17457    CrmTaskStatus 
   TABLE DATA           �   COPY public."CrmTaskStatus" ("StatusId", "StatusTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted") FROM stdin;
    public          postgres    false    416   t�      �          0    17471    CrmTaskTagsTenant1 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant1" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    420   �      �          0    17479    CrmTaskTagsTenant100 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant100" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    421   |�      �          0    17487    CrmTaskTagsTenant2 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant2" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    422   ��      �          0    17495    CrmTaskTagsTenant3 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant3" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    423   ��      �          0    17504    CrmTaskTenant1 
   TABLE DATA             COPY public."CrmTaskTenant1" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    425   ӊ      �          0    17516    CrmTaskTenant100 
   TABLE DATA             COPY public."CrmTaskTenant100" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    426   ڌ      �          0    17528    CrmTaskTenant2 
   TABLE DATA             COPY public."CrmTaskTenant2" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    427   ��      �          0    17540    CrmTaskTenant3 
   TABLE DATA             COPY public."CrmTaskTenant3" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    428   �      �          0    17563    CrmTeamMemberTenant1 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant1" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    432   1�      �          0    17571    CrmTeamMemberTenant100 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant100" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    433   2�      �          0    17579    CrmTeamMemberTenant2 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant2" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    434   O�      �          0    17587    CrmTeamMemberTenant3 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant3" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    435   l�      �          0    17596    CrmTeamTenant1 
   TABLE DATA           �   COPY public."CrmTeamTenant1" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    437   ��      �          0    17604    CrmTeamTenant100 
   TABLE DATA           �   COPY public."CrmTeamTenant100" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    438   >�      �          0    17612    CrmTeamTenant2 
   TABLE DATA           �   COPY public."CrmTeamTenant2" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    439   [�      �          0    17620    CrmTeamTenant3 
   TABLE DATA           �   COPY public."CrmTeamTenant3" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    440   x�      �          0    17636    CrmUserActivityLogTenant1 
   TABLE DATA           
  COPY public."CrmUserActivityLogTenant1" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    443   ��      �          0    17646    CrmUserActivityLogTenant100 
   TABLE DATA             COPY public."CrmUserActivityLogTenant100" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    444   ��      �          0    17656    CrmUserActivityLogTenant2 
   TABLE DATA           
  COPY public."CrmUserActivityLogTenant2" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    445   ��      �          0    17666    CrmUserActivityLogTenant3 
   TABLE DATA           
  COPY public."CrmUserActivityLogTenant3" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    446   ʒ      �          0    17676    CrmUserActivityType 
   TABLE DATA           k   COPY public."CrmUserActivityType" ("ActivityTypeId", "ActivityTypeTitle", "Icon", "IsDeleted") FROM stdin;
    public          postgres    false    447   �                0    18635    Notification1 
   TABLE DATA           �   COPY public."Notification1" ("NotificationId", "Icon", "Image", "Title", "Description", "Link", "UseRouter", "Read", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    471   h�                0    18647    Notification100 
   TABLE DATA           �   COPY public."Notification100" ("NotificationId", "Icon", "Image", "Title", "Description", "Link", "UseRouter", "Read", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    472   ��                0    18659    Notification2 
   TABLE DATA           �   COPY public."Notification2" ("NotificationId", "Icon", "Image", "Title", "Description", "Link", "UseRouter", "Read", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    473   ��                0    18671    Notification3 
   TABLE DATA           �   COPY public."Notification3" ("NotificationId", "Icon", "Image", "Title", "Description", "Link", "UseRouter", "Read", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    474   ��      �          0    17683    Tenant 
   TABLE DATA           �   COPY public."Tenant" ("TenantId", "Name", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted") FROM stdin;
    public          postgres    false    449   ܓ      �          0    18462    Ticket1 
   TABLE DATA           .  COPY public."Ticket1" ("TicketId", "SocialMediaPlatform", "CustomerId", "Timestamp", "AssigneeId", "Category", "ResolutionStatus", "DueDate", "Notes", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "RecentlyActive", "Priority", "Status", "Type") FROM stdin;
    public          postgres    false    453   ��      �          0    18476 	   Ticket100 
   TABLE DATA           0  COPY public."Ticket100" ("TicketId", "SocialMediaPlatform", "CustomerId", "Timestamp", "AssigneeId", "Category", "ResolutionStatus", "DueDate", "Notes", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "RecentlyActive", "Priority", "Status", "Type") FROM stdin;
    public          postgres    false    454   �      �          0    18490    Ticket2 
   TABLE DATA           .  COPY public."Ticket2" ("TicketId", "SocialMediaPlatform", "CustomerId", "Timestamp", "AssigneeId", "Category", "ResolutionStatus", "DueDate", "Notes", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "RecentlyActive", "Priority", "Status", "Type") FROM stdin;
    public          postgres    false    455   3�                 0    18504    Ticket3 
   TABLE DATA           .  COPY public."Ticket3" ("TicketId", "SocialMediaPlatform", "CustomerId", "Timestamp", "AssigneeId", "Category", "ResolutionStatus", "DueDate", "Notes", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "RecentlyActive", "Priority", "Status", "Type") FROM stdin;
    public          postgres    false    456   P�                0    18617    TicketPriority 
   TABLE DATA           [   COPY public."TicketPriority" ("TicketPriorityId", "PriorityName", "IsDeleted") FROM stdin;
    public          postgres    false    468   m�      	          0    18607    TicketStatus 
   TABLE DATA           ^   COPY public."TicketStatus" ("TicketStatusId", "StatusName", "IsDeleted", "Class") FROM stdin;
    public          postgres    false    466   ��                0    18599 
   TicketType 
   TABLE DATA           O   COPY public."TicketType" ("TicketTypeId", "TypeName", "IsDeleted") FROM stdin;
    public          postgres    false    464   ��      U           0    0    AppMenus_MenuId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."AppMenus_MenuId_seq"', 42, true);
          public          postgres    false    259            V           0    0    Conversation_ConversationId_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."Conversation_ConversationId_seq"', 1, false);
          public          postgres    false    457            W           0    0    CrmAdAccount_AccountId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmAdAccount_AccountId_seq"', 1, false);
          public          postgres    false    261            X           0    0     CrmCalendarEventsType_TypeId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmCalendarEventsType_TypeId_seq"', 12, true);
          public          postgres    false    267            Y           0    0    CrmCalenderEvents_EventId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmCalenderEvents_EventId_seq"', 132, true);
          public          postgres    false    269            Z           0    0    CrmCall_CallId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmCall_CallId_seq"', 57, true);
          public          postgres    false    275            [           0    0 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."CrmCompanyActivityLog_ActivityId_seq"', 1, false);
          public          postgres    false    287            \           0    0    CrmCompanyMember_MemberId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CrmCompanyMember_MemberId_seq"', 1, false);
          public          postgres    false    293            ]           0    0    CrmCompany_CompanyId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmCompany_CompanyId_seq"', 19, true);
          public          postgres    false    298            ^           0    0    CrmCustomLists_ListId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmCustomLists_ListId_seq"', 20, true);
          public          postgres    false    304            _           0    0    CrmEmail_EmailId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."CrmEmail_EmailId_seq"', 54, true);
          public          postgres    false    310            `           0    0    CrmFormFields_FieldId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmFormFields_FieldId_seq"', 51, true);
          public          postgres    false    316            a           0    0    CrmFormResults_ResultId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CrmFormResults_ResultId_seq"', 1, false);
          public          postgres    false    322            b           0    0    CrmForm_FormId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."CrmForm_FormId_seq"', 4, true);
          public          postgres    false    485            c           0    0    CrmForms_FormId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."CrmForms_FormId_seq"', 1, false);
          public          postgres    false    475            d           0    0    CrmICallScenarios_ReasonId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmICallScenarios_ReasonId_seq"', 13, true);
          public          postgres    false    328            e           0    0 "   CrmIScoringQuestion_QuestionId_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public."CrmIScoringQuestion_QuestionId_seq"', 2, true);
          public          postgres    false    481            f           0    0    CrmIndustry_IndustryId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmIndustry_IndustryId_seq"', 20, true);
          public          postgres    false    330            g           0    0 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public."CrmLeadActivityLog_ActivityId_seq"', 1, false);
          public          postgres    false    337            h           0    0    CrmLeadScore_ScoreId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmLeadScore_ScoreId_seq"', 29, true);
          public          postgres    false    483            i           0    0    CrmLeadSource_SourceId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmLeadSource_SourceId_seq"', 7, true);
          public          postgres    false    343            j           0    0    CrmLeadStatus_StatusId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmLeadStatus_StatusId_seq"', 9, true);
          public          postgres    false    349            k           0    0    CrmLead_LeadId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."CrmLead_LeadId_seq"', 381, true);
          public          postgres    false    354            l           0    0    CrmMeeting_MeetingId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmMeeting_MeetingId_seq"', 26, true);
          public          postgres    false    360            m           0    0    CrmNoteTags_NoteTagsId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmNoteTags_NoteTagsId_seq"', 35, true);
          public          postgres    false    367            n           0    0    CrmNoteTasks_NoteTaskId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CrmNoteTasks_NoteTaskId_seq"', 47, true);
          public          postgres    false    373            o           0    0    CrmNote_NoteId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmNote_NoteId_seq"', 34, true);
          public          postgres    false    378            p           0    0 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmOpportunityStatus_StatusId_seq"', 6, true);
          public          postgres    false    390            q           0    0     CrmOpportunity_OpportunityId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmOpportunity_OpportunityId_seq"', 20, true);
          public          postgres    false    384            r           0    0    CrmProduct_ProductId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmProduct_ProductId_seq"', 27, true);
          public          postgres    false    392            s           0    0    CrmProject_ProjectId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."CrmProject_ProjectId_seq"', 4, true);
          public          postgres    false    398            t           0    0    CrmStatusLog_LogId_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CrmStatusLog_LogId_seq"', 91, true);
          public          postgres    false    400            u           0    0    CrmTagUsed_TagUsedId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmTagUsed_TagUsedId_seq"', 1, false);
          public          postgres    false    402            v           0    0    CrmTags_TagId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."CrmTags_TagId_seq"', 37, true);
          public          postgres    false    408            w           0    0    CrmTaskPriority_PriorityId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmTaskPriority_PriorityId_seq"', 1, false);
          public          postgres    false    415            x           0    0    CrmTaskStatus_StatusId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmTaskStatus_StatusId_seq"', 4, true);
          public          postgres    false    417            y           0    0    CrmTaskTags_TaskTagsId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CrmTaskTags_TaskTagsId_seq"', 258, true);
          public          postgres    false    419            z           0    0    CrmTask_TaskId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmTask_TaskId_seq"', 79, true);
          public          postgres    false    424            {           0    0    CrmTeamMember_TeamMemberId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmTeamMember_TeamMemberId_seq"', 21, true);
          public          postgres    false    431            |           0    0    CrmTeam_TeamId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."CrmTeam_TeamId_seq"', 6, true);
          public          postgres    false    436            }           0    0 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."CrmUserActivityLog_ActivityId_seq"', 263, true);
          public          postgres    false    442            ~           0    0 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public."CrmUserActivityType_ActivityTypeId_seq"', 5, true);
          public          postgres    false    448                       0    0    NewCrmFormFieldTypes_TypeId_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."NewCrmFormFieldTypes_TypeId_seq"', 1, false);
          public          postgres    false    491            �           0    0    Notification_NotificationId_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."Notification_NotificationId_seq"', 1, false);
          public          postgres    false    469            �           0    0 #   TicketPriority_TicketPriorityId_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."TicketPriority_TicketPriorityId_seq"', 1, false);
          public          postgres    false    467            �           0    0    TicketStatus_TicketStatusId_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."TicketStatus_TicketStatusId_seq"', 1, false);
          public          postgres    false    465            �           0    0    TicketType_TicketTypeId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."TicketType_TicketTypeId_seq"', 1, false);
          public          postgres    false    463            �           0    0    Ticket_TicketId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."Ticket_TicketId_seq"', 1, false);
          public          postgres    false    451            x           2606    18548    Conversation Conversation_PK 
   CONSTRAINT     x   ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_PK" PRIMARY KEY ("ConversationId", "TenantId");
 J   ALTER TABLE ONLY public."Conversation" DROP CONSTRAINT "Conversation_PK";
       public            postgres    false    458    458                       2606    18570 $   Conversation100 Conversation100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."Conversation100"
    ADD CONSTRAINT "Conversation100_pkey" PRIMARY KEY ("ConversationId", "TenantId");
 R   ALTER TABLE ONLY public."Conversation100" DROP CONSTRAINT "Conversation100_pkey";
       public            postgres    false    460    460    6776    460            |           2606    18558     Conversation1 Conversation1_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."Conversation1"
    ADD CONSTRAINT "Conversation1_pkey" PRIMARY KEY ("ConversationId", "TenantId");
 N   ALTER TABLE ONLY public."Conversation1" DROP CONSTRAINT "Conversation1_pkey";
       public            postgres    false    459    459    459    6776            �           2606    18582     Conversation2 Conversation2_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."Conversation2"
    ADD CONSTRAINT "Conversation2_pkey" PRIMARY KEY ("ConversationId", "TenantId");
 N   ALTER TABLE ONLY public."Conversation2" DROP CONSTRAINT "Conversation2_pkey";
       public            postgres    false    461    461    461    6776            �           2606    18594     Conversation3 Conversation3_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."Conversation3"
    ADD CONSTRAINT "Conversation3_pkey" PRIMARY KEY ("ConversationId", "TenantId");
 N   ALTER TABLE ONLY public."Conversation3" DROP CONSTRAINT "Conversation3_pkey";
       public            postgres    false    462    462    462    6776            �           2606    17729    CrmAdAccount CrmAdAccount_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmAdAccount"
    ADD CONSTRAINT "CrmAdAccount_pkey" PRIMARY KEY ("AccountId", "TenantId");
 L   ALTER TABLE ONLY public."CrmAdAccount" DROP CONSTRAINT "CrmAdAccount_pkey";
       public            postgres    false    260    260            �           2606    17731 $   CrmAdAccount100 CrmAdAccount100_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public."CrmAdAccount100"
    ADD CONSTRAINT "CrmAdAccount100_pkey" PRIMARY KEY ("AccountId", "TenantId");
 R   ALTER TABLE ONLY public."CrmAdAccount100" DROP CONSTRAINT "CrmAdAccount100_pkey";
       public            postgres    false    263    6301    263    263            �           2606    17733     CrmAdAccount1 CrmAdAccount1_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount1"
    ADD CONSTRAINT "CrmAdAccount1_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount1" DROP CONSTRAINT "CrmAdAccount1_pkey";
       public            postgres    false    262    6301    262    262            �           2606    17735     CrmAdAccount2 CrmAdAccount2_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount2"
    ADD CONSTRAINT "CrmAdAccount2_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount2" DROP CONSTRAINT "CrmAdAccount2_pkey";
       public            postgres    false    6301    264    264    264            �           2606    17737     CrmAdAccount3 CrmAdAccount3_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount3"
    ADD CONSTRAINT "CrmAdAccount3_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount3" DROP CONSTRAINT "CrmAdAccount3_pkey";
       public            postgres    false    265    265    265    6301            �           2606    17739 0   CrmCalendarEventsType CrmCalendarEventsType_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."CrmCalendarEventsType"
    ADD CONSTRAINT "CrmCalendarEventsType_pkey" PRIMARY KEY ("TypeId");
 ^   ALTER TABLE ONLY public."CrmCalendarEventsType" DROP CONSTRAINT "CrmCalendarEventsType_pkey";
       public            postgres    false    266            �           2606    17741 (   CrmCalenderEvents CrmCalenderEvents_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."CrmCalenderEvents"
    ADD CONSTRAINT "CrmCalenderEvents_pkey" PRIMARY KEY ("EventId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCalenderEvents" DROP CONSTRAINT "CrmCalenderEvents_pkey";
       public            postgres    false    268    268            �           2606    17743 :   CrmCalenderEventsTenant100 CrmCalenderEventsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant100"
    ADD CONSTRAINT "CrmCalenderEventsTenant100_pkey" PRIMARY KEY ("EventId", "TenantId");
 h   ALTER TABLE ONLY public."CrmCalenderEventsTenant100" DROP CONSTRAINT "CrmCalenderEventsTenant100_pkey";
       public            postgres    false    271    271    271    6318            �           2606    17745 6   CrmCalenderEventsTenant1 CrmCalenderEventsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant1"
    ADD CONSTRAINT "CrmCalenderEventsTenant1_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant1" DROP CONSTRAINT "CrmCalenderEventsTenant1_pkey";
       public            postgres    false    6318    270    270    270            �           2606    17747 6   CrmCalenderEventsTenant2 CrmCalenderEventsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant2"
    ADD CONSTRAINT "CrmCalenderEventsTenant2_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant2" DROP CONSTRAINT "CrmCalenderEventsTenant2_pkey";
       public            postgres    false    272    272    272    6318            �           2606    17749 6   CrmCalenderEventsTenant3 CrmCalenderEventsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant3"
    ADD CONSTRAINT "CrmCalenderEventsTenant3_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant3" DROP CONSTRAINT "CrmCalenderEventsTenant3_pkey";
       public            postgres    false    273    273    6318    273            �           2606    17751    CrmCall CrmCall_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmCall"
    ADD CONSTRAINT "CrmCall_pkey" PRIMARY KEY ("CallId", "TenantId");
 B   ALTER TABLE ONLY public."CrmCall" DROP CONSTRAINT "CrmCall_pkey";
       public            postgres    false    274    274            �           2606    17753    CrmCall100 CrmCall100_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CrmCall100"
    ADD CONSTRAINT "CrmCall100_pkey" PRIMARY KEY ("CallId", "TenantId");
 H   ALTER TABLE ONLY public."CrmCall100" DROP CONSTRAINT "CrmCall100_pkey";
       public            postgres    false    277    6333    277    277            �           2606    17755    CrmCall1 CrmCall1_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall1"
    ADD CONSTRAINT "CrmCall1_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall1" DROP CONSTRAINT "CrmCall1_pkey";
       public            postgres    false    276    276    276    6333            �           2606    17757    CrmCall2 CrmCall2_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall2"
    ADD CONSTRAINT "CrmCall2_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall2" DROP CONSTRAINT "CrmCall2_pkey";
       public            postgres    false    6333    278    278    278            �           2606    17759    CrmCall3 CrmCall3_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall3"
    ADD CONSTRAINT "CrmCall3_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall3" DROP CONSTRAINT "CrmCall3_pkey";
       public            postgres    false    279    279    279    6333            �           2606    17761    CrmCampaign CrmCampaign_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmCampaign"
    ADD CONSTRAINT "CrmCampaign_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 J   ALTER TABLE ONLY public."CrmCampaign" DROP CONSTRAINT "CrmCampaign_pkey";
       public            postgres    false    280    280            �           2606    17763 "   CrmCampaign100 CrmCampaign100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmCampaign100"
    ADD CONSTRAINT "CrmCampaign100_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 P   ALTER TABLE ONLY public."CrmCampaign100" DROP CONSTRAINT "CrmCampaign100_pkey";
       public            postgres    false    282    6348    282    282            �           2606    17765    CrmCampaign1 CrmCampaign1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCampaign1"
    ADD CONSTRAINT "CrmCampaign1_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 L   ALTER TABLE ONLY public."CrmCampaign1" DROP CONSTRAINT "CrmCampaign1_pkey";
       public            postgres    false    281    281    281    6348            �           2606    17767    CrmCampaign2 CrmCampaign2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCampaign2"
    ADD CONSTRAINT "CrmCampaign2_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 L   ALTER TABLE ONLY public."CrmCampaign2" DROP CONSTRAINT "CrmCampaign2_pkey";
       public            postgres    false    283    283    283    6348            �           2606    17769    CrmCampaign3 CrmCampaign3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCampaign3"
    ADD CONSTRAINT "CrmCampaign3_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 L   ALTER TABLE ONLY public."CrmCampaign3" DROP CONSTRAINT "CrmCampaign3_pkey";
       public            postgres    false    284    284    6348    284            �           2606    17771 0   CrmCompanyActivityLog CrmCompanyActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLog"
    ADD CONSTRAINT "CrmCompanyActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCompanyActivityLog" DROP CONSTRAINT "CrmCompanyActivityLog_pkey";
       public            postgres    false    286    286            �           2606    17773 B   CrmCompanyActivityLogTenant100 CrmCompanyActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant100"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 p   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant100" DROP CONSTRAINT "CrmCompanyActivityLogTenant100_pkey";
       public            postgres    false    6366    289    289    289            �           2606    17775 >   CrmCompanyActivityLogTenant1 CrmCompanyActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant1"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant1" DROP CONSTRAINT "CrmCompanyActivityLogTenant1_pkey";
       public            postgres    false    288    288    288    6366            �           2606    17777 >   CrmCompanyActivityLogTenant2 CrmCompanyActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant2"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant2" DROP CONSTRAINT "CrmCompanyActivityLogTenant2_pkey";
       public            postgres    false    290    6366    290    290            �           2606    17779 >   CrmCompanyActivityLogTenant3 CrmCompanyActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant3"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant3" DROP CONSTRAINT "CrmCompanyActivityLogTenant3_pkey";
       public            postgres    false    291    6366    291    291            �           2606    17781 &   CrmCompanyMember CrmCompanyMember_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."CrmCompanyMember"
    ADD CONSTRAINT "CrmCompanyMember_pkey" PRIMARY KEY ("MemberId", "TenantId");
 T   ALTER TABLE ONLY public."CrmCompanyMember" DROP CONSTRAINT "CrmCompanyMember_pkey";
       public            postgres    false    292    292            �           2606    17783 8   CrmCompanyMemberTenant100 CrmCompanyMemberTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant100"
    ADD CONSTRAINT "CrmCompanyMemberTenant100_pkey" PRIMARY KEY ("MemberId", "TenantId");
 f   ALTER TABLE ONLY public."CrmCompanyMemberTenant100" DROP CONSTRAINT "CrmCompanyMemberTenant100_pkey";
       public            postgres    false    6381    295    295    295            �           2606    17785 4   CrmCompanyMemberTenant1 CrmCompanyMemberTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant1"
    ADD CONSTRAINT "CrmCompanyMemberTenant1_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant1" DROP CONSTRAINT "CrmCompanyMemberTenant1_pkey";
       public            postgres    false    294    294    294    6381            �           2606    17787 4   CrmCompanyMemberTenant2 CrmCompanyMemberTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant2"
    ADD CONSTRAINT "CrmCompanyMemberTenant2_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant2" DROP CONSTRAINT "CrmCompanyMemberTenant2_pkey";
       public            postgres    false    296    296    6381    296            �           2606    17789 4   CrmCompanyMemberTenant3 CrmCompanyMemberTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant3"
    ADD CONSTRAINT "CrmCompanyMemberTenant3_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant3" DROP CONSTRAINT "CrmCompanyMemberTenant3_pkey";
       public            postgres    false    6381    297    297    297            �           2606    17791    CrmCompany CrmCompany_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmCompany"
    ADD CONSTRAINT "CrmCompany_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 H   ALTER TABLE ONLY public."CrmCompany" DROP CONSTRAINT "CrmCompany_pkey";
       public            postgres    false    285    285                       2606    17793 ,   CrmCompanyTenant100 CrmCompanyTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyTenant100"
    ADD CONSTRAINT "CrmCompanyTenant100_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmCompanyTenant100" DROP CONSTRAINT "CrmCompanyTenant100_pkey";
       public            postgres    false    300    300    6363    300                       2606    17795 (   CrmCompanyTenant1 CrmCompanyTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant1"
    ADD CONSTRAINT "CrmCompanyTenant1_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant1" DROP CONSTRAINT "CrmCompanyTenant1_pkey";
       public            postgres    false    299    299    6363    299                       2606    17797 (   CrmCompanyTenant2 CrmCompanyTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant2"
    ADD CONSTRAINT "CrmCompanyTenant2_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant2" DROP CONSTRAINT "CrmCompanyTenant2_pkey";
       public            postgres    false    6363    301    301    301                       2606    17799 (   CrmCompanyTenant3 CrmCompanyTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant3"
    ADD CONSTRAINT "CrmCompanyTenant3_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant3" DROP CONSTRAINT "CrmCompanyTenant3_pkey";
       public            postgres    false    302    302    6363    302                       2606    17801 "   CrmCustomLists CrmCustomLists_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCustomLists"
    ADD CONSTRAINT "CrmCustomLists_pkey" PRIMARY KEY ("ListId", "TenantId");
 P   ALTER TABLE ONLY public."CrmCustomLists" DROP CONSTRAINT "CrmCustomLists_pkey";
       public            postgres    false    303    303                       2606    17803 4   CrmCustomListsTenant100 CrmCustomListsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant100"
    ADD CONSTRAINT "CrmCustomListsTenant100_pkey" PRIMARY KEY ("ListId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCustomListsTenant100" DROP CONSTRAINT "CrmCustomListsTenant100_pkey";
       public            postgres    false    6413    306    306    306                       2606    17805 0   CrmCustomListsTenant1 CrmCustomListsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant1"
    ADD CONSTRAINT "CrmCustomListsTenant1_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant1" DROP CONSTRAINT "CrmCustomListsTenant1_pkey";
       public            postgres    false    6413    305    305    305                       2606    17807 0   CrmCustomListsTenant2 CrmCustomListsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant2"
    ADD CONSTRAINT "CrmCustomListsTenant2_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant2" DROP CONSTRAINT "CrmCustomListsTenant2_pkey";
       public            postgres    false    307    307    6413    307                       2606    17809 0   CrmCustomListsTenant3 CrmCustomListsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant3"
    ADD CONSTRAINT "CrmCustomListsTenant3_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant3" DROP CONSTRAINT "CrmCustomListsTenant3_pkey";
       public            postgres    false    6413    308    308    308                       2606    17811    CrmEmail CrmEmail_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public."CrmEmail"
    ADD CONSTRAINT "CrmEmail_pkey" PRIMARY KEY ("EmailId", "TenantId");
 D   ALTER TABLE ONLY public."CrmEmail" DROP CONSTRAINT "CrmEmail_pkey";
       public            postgres    false    309    309            #           2606    17813    CrmEmail100 CrmEmail100_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmEmail100"
    ADD CONSTRAINT "CrmEmail100_pkey" PRIMARY KEY ("EmailId", "TenantId");
 J   ALTER TABLE ONLY public."CrmEmail100" DROP CONSTRAINT "CrmEmail100_pkey";
       public            postgres    false    312    312    6428    312                        2606    17815    CrmEmail1 CrmEmail1_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail1"
    ADD CONSTRAINT "CrmEmail1_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail1" DROP CONSTRAINT "CrmEmail1_pkey";
       public            postgres    false    6428    311    311    311            &           2606    17817    CrmEmail2 CrmEmail2_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail2"
    ADD CONSTRAINT "CrmEmail2_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail2" DROP CONSTRAINT "CrmEmail2_pkey";
       public            postgres    false    313    313    313    6428            )           2606    17819    CrmEmail3 CrmEmail3_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail3"
    ADD CONSTRAINT "CrmEmail3_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail3" DROP CONSTRAINT "CrmEmail3_pkey";
       public            postgres    false    314    314    6428    314            �           2606    18912    CrmForm CrmForm_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmForm"
    ADD CONSTRAINT "CrmForm_pkey" PRIMARY KEY ("FormId", "TenantId");
 B   ALTER TABLE ONLY public."CrmForm" DROP CONSTRAINT "CrmForm_pkey";
       public            postgres    false    486    486            �           2606    19030    CrmForm100 CrmForm100_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CrmForm100"
    ADD CONSTRAINT "CrmForm100_pkey" PRIMARY KEY ("FormId", "TenantId");
 H   ALTER TABLE ONLY public."CrmForm100" DROP CONSTRAINT "CrmForm100_pkey";
       public            postgres    false    6831    490    490    490            �           2606    19000    CrmForm1 CrmForm1_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmForm1"
    ADD CONSTRAINT "CrmForm1_pkey" PRIMARY KEY ("FormId", "TenantId");
 D   ALTER TABLE ONLY public."CrmForm1" DROP CONSTRAINT "CrmForm1_pkey";
       public            postgres    false    6831    487    487    487            �           2606    19010    CrmForm2 CrmForm2_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmForm2"
    ADD CONSTRAINT "CrmForm2_pkey" PRIMARY KEY ("FormId", "TenantId");
 D   ALTER TABLE ONLY public."CrmForm2" DROP CONSTRAINT "CrmForm2_pkey";
       public            postgres    false    488    488    488    6831            �           2606    19020    CrmForm3 CrmForm3_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmForm3"
    ADD CONSTRAINT "CrmForm3_pkey" PRIMARY KEY ("FormId", "TenantId");
 D   ALTER TABLE ONLY public."CrmForm3" DROP CONSTRAINT "CrmForm3_pkey";
       public            postgres    false    489    489    489    6831            +           2606    17821     CrmFormFields CrmFormFields_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmFormFields"
    ADD CONSTRAINT "CrmFormFields_pkey" PRIMARY KEY ("FieldId", "TenantId");
 N   ALTER TABLE ONLY public."CrmFormFields" DROP CONSTRAINT "CrmFormFields_pkey";
       public            postgres    false    315    315            2           2606    17823 &   CrmFormFields100 CrmFormFields100_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public."CrmFormFields100"
    ADD CONSTRAINT "CrmFormFields100_pkey" PRIMARY KEY ("FieldId", "TenantId");
 T   ALTER TABLE ONLY public."CrmFormFields100" DROP CONSTRAINT "CrmFormFields100_pkey";
       public            postgres    false    6443    318    318    318            /           2606    17825 "   CrmFormFields1 CrmFormFields1_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmFormFields1"
    ADD CONSTRAINT "CrmFormFields1_pkey" PRIMARY KEY ("FieldId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormFields1" DROP CONSTRAINT "CrmFormFields1_pkey";
       public            postgres    false    6443    317    317    317            5           2606    17827 "   CrmFormFields2 CrmFormFields2_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmFormFields2"
    ADD CONSTRAINT "CrmFormFields2_pkey" PRIMARY KEY ("FieldId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormFields2" DROP CONSTRAINT "CrmFormFields2_pkey";
       public            postgres    false    319    319    6443    319            8           2606    17829 "   CrmFormFields3 CrmFormFields3_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmFormFields3"
    ADD CONSTRAINT "CrmFormFields3_pkey" PRIMARY KEY ("FieldId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormFields3" DROP CONSTRAINT "CrmFormFields3_pkey";
       public            postgres    false    320    6443    320    320            :           2606    17831 "   CrmFormResults CrmFormResults_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."CrmFormResults"
    ADD CONSTRAINT "CrmFormResults_pkey" PRIMARY KEY ("ResultId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormResults" DROP CONSTRAINT "CrmFormResults_pkey";
       public            postgres    false    321    321            A           2606    17833 (   CrmFormResults100 CrmFormResults100_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public."CrmFormResults100"
    ADD CONSTRAINT "CrmFormResults100_pkey" PRIMARY KEY ("ResultId", "TenantId");
 V   ALTER TABLE ONLY public."CrmFormResults100" DROP CONSTRAINT "CrmFormResults100_pkey";
       public            postgres    false    6458    324    324    324            >           2606    17835 $   CrmFormResults1 CrmFormResults1_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmFormResults1"
    ADD CONSTRAINT "CrmFormResults1_pkey" PRIMARY KEY ("ResultId", "TenantId");
 R   ALTER TABLE ONLY public."CrmFormResults1" DROP CONSTRAINT "CrmFormResults1_pkey";
       public            postgres    false    323    323    6458    323            D           2606    17837 $   CrmFormResults2 CrmFormResults2_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmFormResults2"
    ADD CONSTRAINT "CrmFormResults2_pkey" PRIMARY KEY ("ResultId", "TenantId");
 R   ALTER TABLE ONLY public."CrmFormResults2" DROP CONSTRAINT "CrmFormResults2_pkey";
       public            postgres    false    6458    325    325    325            G           2606    17839 $   CrmFormResults3 CrmFormResults3_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmFormResults3"
    ADD CONSTRAINT "CrmFormResults3_pkey" PRIMARY KEY ("ResultId", "TenantId");
 R   ALTER TABLE ONLY public."CrmFormResults3" DROP CONSTRAINT "CrmFormResults3_pkey";
       public            postgres    false    6458    326    326    326            �           2606    18691    CrmForms CrmForms_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmForms"
    ADD CONSTRAINT "CrmForms_pkey" PRIMARY KEY ("FormId", "TenantId");
 D   ALTER TABLE ONLY public."CrmForms" DROP CONSTRAINT "CrmForms_pkey";
       public            postgres    false    476    476            �           2606    18711    CrmForms100 CrmForms100_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."CrmForms100"
    ADD CONSTRAINT "CrmForms100_pkey" PRIMARY KEY ("FormId", "TenantId");
 J   ALTER TABLE ONLY public."CrmForms100" DROP CONSTRAINT "CrmForms100_pkey";
       public            postgres    false    478    478    478    6812            �           2606    18700    CrmForms1 CrmForms1_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."CrmForms1"
    ADD CONSTRAINT "CrmForms1_pkey" PRIMARY KEY ("FormId", "TenantId");
 F   ALTER TABLE ONLY public."CrmForms1" DROP CONSTRAINT "CrmForms1_pkey";
       public            postgres    false    477    477    477    6812            �           2606    18722    CrmForms2 CrmForms2_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."CrmForms2"
    ADD CONSTRAINT "CrmForms2_pkey" PRIMARY KEY ("FormId", "TenantId");
 F   ALTER TABLE ONLY public."CrmForms2" DROP CONSTRAINT "CrmForms2_pkey";
       public            postgres    false    479    479    6812    479            �           2606    18733    CrmForms3 CrmForms3_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."CrmForms3"
    ADD CONSTRAINT "CrmForms3_pkey" PRIMARY KEY ("FormId", "TenantId");
 F   ALTER TABLE ONLY public."CrmForms3" DROP CONSTRAINT "CrmForms3_pkey";
       public            postgres    false    480    480    480    6812            �           2606    18811 ,   CrmIScoringQuestion CrmIScoringQuestion_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."CrmIScoringQuestion"
    ADD CONSTRAINT "CrmIScoringQuestion_pkey" PRIMARY KEY ("QuestionId");
 Z   ALTER TABLE ONLY public."CrmIScoringQuestion" DROP CONSTRAINT "CrmIScoringQuestion_pkey";
       public            postgres    false    482            I           2606    17841 &   CrmICallScenarios CrmIcallReason _pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."CrmICallScenarios"
    ADD CONSTRAINT "CrmIcallReason _pkey" PRIMARY KEY ("ReasonId");
 T   ALTER TABLE ONLY public."CrmICallScenarios" DROP CONSTRAINT "CrmIcallReason _pkey";
       public            postgres    false    327            K           2606    17843    CrmIndustry CrmIndustry_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmIndustry"
    ADD CONSTRAINT "CrmIndustry_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 J   ALTER TABLE ONLY public."CrmIndustry" DROP CONSTRAINT "CrmIndustry_pkey";
       public            postgres    false    329    329            R           2606    17845 .   CrmIndustryTenant100 CrmIndustryTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant100"
    ADD CONSTRAINT "CrmIndustryTenant100_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 \   ALTER TABLE ONLY public."CrmIndustryTenant100" DROP CONSTRAINT "CrmIndustryTenant100_pkey";
       public            postgres    false    332    332    6475    332            O           2606    17847 *   CrmIndustryTenant1 CrmIndustryTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant1"
    ADD CONSTRAINT "CrmIndustryTenant1_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant1" DROP CONSTRAINT "CrmIndustryTenant1_pkey";
       public            postgres    false    331    331    6475    331            U           2606    17849 *   CrmIndustryTenant2 CrmIndustryTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant2"
    ADD CONSTRAINT "CrmIndustryTenant2_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant2" DROP CONSTRAINT "CrmIndustryTenant2_pkey";
       public            postgres    false    6475    333    333    333            X           2606    17851 *   CrmIndustryTenant3 CrmIndustryTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant3"
    ADD CONSTRAINT "CrmIndustryTenant3_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant3" DROP CONSTRAINT "CrmIndustryTenant3_pkey";
       public            postgres    false    6475    334    334    334            ]           2606    17853 *   CrmLeadActivityLog CrmLeadActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLog"
    ADD CONSTRAINT "CrmLeadActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 X   ALTER TABLE ONLY public."CrmLeadActivityLog" DROP CONSTRAINT "CrmLeadActivityLog_pkey";
       public            postgres    false    336    336            d           2606    17855 <   CrmLeadActivityLogTenant100 CrmLeadActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant100"
    ADD CONSTRAINT "CrmLeadActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 j   ALTER TABLE ONLY public."CrmLeadActivityLogTenant100" DROP CONSTRAINT "CrmLeadActivityLogTenant100_pkey";
       public            postgres    false    339    339    6493    339            a           2606    17857 8   CrmLeadActivityLogTenant1 CrmLeadActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant1"
    ADD CONSTRAINT "CrmLeadActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant1" DROP CONSTRAINT "CrmLeadActivityLogTenant1_pkey";
       public            postgres    false    338    338    338    6493            g           2606    17859 8   CrmLeadActivityLogTenant2 CrmLeadActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant2"
    ADD CONSTRAINT "CrmLeadActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant2" DROP CONSTRAINT "CrmLeadActivityLogTenant2_pkey";
       public            postgres    false    340    6493    340    340            j           2606    17861 8   CrmLeadActivityLogTenant3 CrmLeadActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant3"
    ADD CONSTRAINT "CrmLeadActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant3" DROP CONSTRAINT "CrmLeadActivityLogTenant3_pkey";
       public            postgres    false    341    341    341    6493            �           2606    18819    CrmLeadScore CrmLeadScore_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."CrmLeadScore"
    ADD CONSTRAINT "CrmLeadScore_pkey" PRIMARY KEY ("ScoreId");
 L   ALTER TABLE ONLY public."CrmLeadScore" DROP CONSTRAINT "CrmLeadScore_pkey";
       public            postgres    false    484            l           2606    17863     CrmLeadSource CrmLeadSource_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadSource"
    ADD CONSTRAINT "CrmLeadSource_pkey" PRIMARY KEY ("SourceId", "TenantId");
 N   ALTER TABLE ONLY public."CrmLeadSource" DROP CONSTRAINT "CrmLeadSource_pkey";
       public            postgres    false    342    342            s           2606    17865 2   CrmLeadSourceTenant100 CrmLeadSourceTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant100"
    ADD CONSTRAINT "CrmLeadSourceTenant100_pkey" PRIMARY KEY ("SourceId", "TenantId");
 `   ALTER TABLE ONLY public."CrmLeadSourceTenant100" DROP CONSTRAINT "CrmLeadSourceTenant100_pkey";
       public            postgres    false    345    6508    345    345            p           2606    17867 .   CrmLeadSourceTenant1 CrmLeadSourceTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant1"
    ADD CONSTRAINT "CrmLeadSourceTenant1_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant1" DROP CONSTRAINT "CrmLeadSourceTenant1_pkey";
       public            postgres    false    344    344    344    6508            v           2606    17869 .   CrmLeadSourceTenant2 CrmLeadSourceTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant2"
    ADD CONSTRAINT "CrmLeadSourceTenant2_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant2" DROP CONSTRAINT "CrmLeadSourceTenant2_pkey";
       public            postgres    false    346    346    6508    346            y           2606    17871 .   CrmLeadSourceTenant3 CrmLeadSourceTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant3"
    ADD CONSTRAINT "CrmLeadSourceTenant3_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant3" DROP CONSTRAINT "CrmLeadSourceTenant3_pkey";
       public            postgres    false    347    347    6508    347            {           2606    17873     CrmLeadStatus CrmLeadStatus_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadStatus"
    ADD CONSTRAINT "CrmLeadStatus_pkey" PRIMARY KEY ("StatusId", "TenantId");
 N   ALTER TABLE ONLY public."CrmLeadStatus" DROP CONSTRAINT "CrmLeadStatus_pkey";
       public            postgres    false    348    348            �           2606    17875 2   CrmLeadStatusTenant100 CrmLeadStatusTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant100"
    ADD CONSTRAINT "CrmLeadStatusTenant100_pkey" PRIMARY KEY ("StatusId", "TenantId");
 `   ALTER TABLE ONLY public."CrmLeadStatusTenant100" DROP CONSTRAINT "CrmLeadStatusTenant100_pkey";
       public            postgres    false    6523    351    351    351                       2606    17877 .   CrmLeadStatusTenant1 CrmLeadStatusTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant1"
    ADD CONSTRAINT "CrmLeadStatusTenant1_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant1" DROP CONSTRAINT "CrmLeadStatusTenant1_pkey";
       public            postgres    false    6523    350    350    350            �           2606    17879 .   CrmLeadStatusTenant2 CrmLeadStatusTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant2"
    ADD CONSTRAINT "CrmLeadStatusTenant2_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant2" DROP CONSTRAINT "CrmLeadStatusTenant2_pkey";
       public            postgres    false    352    6523    352    352            �           2606    17881 .   CrmLeadStatusTenant3 CrmLeadStatusTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant3"
    ADD CONSTRAINT "CrmLeadStatusTenant3_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant3" DROP CONSTRAINT "CrmLeadStatusTenant3_pkey";
       public            postgres    false    6523    353    353    353            Z           2606    17883    CrmLead CrmLead_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmLead"
    ADD CONSTRAINT "CrmLead_pkey" PRIMARY KEY ("LeadId", "TenantId");
 B   ALTER TABLE ONLY public."CrmLead" DROP CONSTRAINT "CrmLead_pkey";
       public            postgres    false    335    335            �           2606    17885 &   CrmLeadTenant100 CrmLeadTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmLeadTenant100"
    ADD CONSTRAINT "CrmLeadTenant100_pkey" PRIMARY KEY ("LeadId", "TenantId");
 T   ALTER TABLE ONLY public."CrmLeadTenant100" DROP CONSTRAINT "CrmLeadTenant100_pkey";
       public            postgres    false    356    356    6490    356            �           2606    17887 "   CrmLeadTenant1 CrmLeadTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant1"
    ADD CONSTRAINT "CrmLeadTenant1_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant1" DROP CONSTRAINT "CrmLeadTenant1_pkey";
       public            postgres    false    355    355    6490    355            �           2606    17889 "   CrmLeadTenant2 CrmLeadTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant2"
    ADD CONSTRAINT "CrmLeadTenant2_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant2" DROP CONSTRAINT "CrmLeadTenant2_pkey";
       public            postgres    false    357    357    6490    357            �           2606    17891 "   CrmLeadTenant3 CrmLeadTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant3"
    ADD CONSTRAINT "CrmLeadTenant3_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant3" DROP CONSTRAINT "CrmLeadTenant3_pkey";
       public            postgres    false    358    358    358    6490            �           2606    17893    CrmMeeting CrmMeeting_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmMeeting"
    ADD CONSTRAINT "CrmMeeting_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 H   ALTER TABLE ONLY public."CrmMeeting" DROP CONSTRAINT "CrmMeeting_pkey";
       public            postgres    false    359    359            �           2606    17895     CrmMeeting100 CrmMeeting100_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmMeeting100"
    ADD CONSTRAINT "CrmMeeting100_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 N   ALTER TABLE ONLY public."CrmMeeting100" DROP CONSTRAINT "CrmMeeting100_pkey";
       public            postgres    false    362    6550    362    362            �           2606    17897    CrmMeeting1 CrmMeeting1_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting1"
    ADD CONSTRAINT "CrmMeeting1_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting1" DROP CONSTRAINT "CrmMeeting1_pkey";
       public            postgres    false    361    6550    361    361            �           2606    17899    CrmMeeting2 CrmMeeting2_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting2"
    ADD CONSTRAINT "CrmMeeting2_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting2" DROP CONSTRAINT "CrmMeeting2_pkey";
       public            postgres    false    6550    363    363    363            �           2606    17901    CrmMeeting3 CrmMeeting3_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting3"
    ADD CONSTRAINT "CrmMeeting3_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting3" DROP CONSTRAINT "CrmMeeting3_pkey";
       public            postgres    false    364    364    6550    364            �           2606    17903    CrmNoteTags CrmNoteTags_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmNoteTags"
    ADD CONSTRAINT "CrmNoteTags_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 J   ALTER TABLE ONLY public."CrmNoteTags" DROP CONSTRAINT "CrmNoteTags_pkey";
       public            postgres    false    366    366            �           2606    17905 .   CrmNoteTagsTenant100 CrmNoteTagsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant100"
    ADD CONSTRAINT "CrmNoteTagsTenant100_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 \   ALTER TABLE ONLY public."CrmNoteTagsTenant100" DROP CONSTRAINT "CrmNoteTagsTenant100_pkey";
       public            postgres    false    369    369    6568    369            �           2606    17907 *   CrmNoteTagsTenant1 CrmNoteTagsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant1"
    ADD CONSTRAINT "CrmNoteTagsTenant1_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant1" DROP CONSTRAINT "CrmNoteTagsTenant1_pkey";
       public            postgres    false    368    368    6568    368            �           2606    17909 *   CrmNoteTagsTenant2 CrmNoteTagsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant2"
    ADD CONSTRAINT "CrmNoteTagsTenant2_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant2" DROP CONSTRAINT "CrmNoteTagsTenant2_pkey";
       public            postgres    false    370    6568    370    370            �           2606    17911 *   CrmNoteTagsTenant3 CrmNoteTagsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant3"
    ADD CONSTRAINT "CrmNoteTagsTenant3_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant3" DROP CONSTRAINT "CrmNoteTagsTenant3_pkey";
       public            postgres    false    371    371    6568    371            �           2606    17913    CrmNoteTasks CrmNoteTasks_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTasks"
    ADD CONSTRAINT "CrmNoteTasks_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 L   ALTER TABLE ONLY public."CrmNoteTasks" DROP CONSTRAINT "CrmNoteTasks_pkey";
       public            postgres    false    372    372            �           2606    17915 0   CrmNoteTasksTenant100 CrmNoteTasksTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant100"
    ADD CONSTRAINT "CrmNoteTasksTenant100_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmNoteTasksTenant100" DROP CONSTRAINT "CrmNoteTasksTenant100_pkey";
       public            postgres    false    375    375    6583    375            �           2606    17917 ,   CrmNoteTasksTenant1 CrmNoteTasksTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant1"
    ADD CONSTRAINT "CrmNoteTasksTenant1_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant1" DROP CONSTRAINT "CrmNoteTasksTenant1_pkey";
       public            postgres    false    374    6583    374    374            �           2606    17919 ,   CrmNoteTasksTenant2 CrmNoteTasksTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant2"
    ADD CONSTRAINT "CrmNoteTasksTenant2_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant2" DROP CONSTRAINT "CrmNoteTasksTenant2_pkey";
       public            postgres    false    6583    376    376    376            �           2606    17921 ,   CrmNoteTasksTenant3 CrmNoteTasksTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant3"
    ADD CONSTRAINT "CrmNoteTasksTenant3_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant3" DROP CONSTRAINT "CrmNoteTasksTenant3_pkey";
       public            postgres    false    377    377    377    6583            �           2606    17923    CrmNote CrmNote_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmNote"
    ADD CONSTRAINT "CrmNote_pkey" PRIMARY KEY ("NoteId", "TenantId");
 B   ALTER TABLE ONLY public."CrmNote" DROP CONSTRAINT "CrmNote_pkey";
       public            postgres    false    365    365            �           2606    17925 &   CrmNoteTenant100 CrmNoteTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmNoteTenant100"
    ADD CONSTRAINT "CrmNoteTenant100_pkey" PRIMARY KEY ("NoteId", "TenantId");
 T   ALTER TABLE ONLY public."CrmNoteTenant100" DROP CONSTRAINT "CrmNoteTenant100_pkey";
       public            postgres    false    6565    380    380    380            �           2606    17927 "   CrmNoteTenant1 CrmNoteTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant1"
    ADD CONSTRAINT "CrmNoteTenant1_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant1" DROP CONSTRAINT "CrmNoteTenant1_pkey";
       public            postgres    false    379    379    379    6565            �           2606    17929 "   CrmNoteTenant2 CrmNoteTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant2"
    ADD CONSTRAINT "CrmNoteTenant2_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant2" DROP CONSTRAINT "CrmNoteTenant2_pkey";
       public            postgres    false    381    381    381    6565            �           2606    17931 "   CrmNoteTenant3 CrmNoteTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant3"
    ADD CONSTRAINT "CrmNoteTenant3_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant3" DROP CONSTRAINT "CrmNoteTenant3_pkey";
       public            postgres    false    382    382    6565    382            �           2606    17933 "   CrmOpportunity CrmOpportunity_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."CrmOpportunity"
    ADD CONSTRAINT "CrmOpportunity_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 P   ALTER TABLE ONLY public."CrmOpportunity" DROP CONSTRAINT "CrmOpportunity_pkey";
       public            postgres    false    383    383            �           2606    17935 (   CrmOpportunity100 CrmOpportunity100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmOpportunity100"
    ADD CONSTRAINT "CrmOpportunity100_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 V   ALTER TABLE ONLY public."CrmOpportunity100" DROP CONSTRAINT "CrmOpportunity100_pkey";
       public            postgres    false    386    6610    386    386            �           2606    17937 $   CrmOpportunity1 CrmOpportunity1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity1"
    ADD CONSTRAINT "CrmOpportunity1_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity1" DROP CONSTRAINT "CrmOpportunity1_pkey";
       public            postgres    false    385    385    385    6610            �           2606    17939 $   CrmOpportunity2 CrmOpportunity2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity2"
    ADD CONSTRAINT "CrmOpportunity2_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity2" DROP CONSTRAINT "CrmOpportunity2_pkey";
       public            postgres    false    387    387    6610    387            �           2606    17941 $   CrmOpportunity3 CrmOpportunity3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity3"
    ADD CONSTRAINT "CrmOpportunity3_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity3" DROP CONSTRAINT "CrmOpportunity3_pkey";
       public            postgres    false    388    388    6610    388            �           2606    17943 .   CrmOpportunityStatus CrmOpportunityStatus_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmOpportunityStatus"
    ADD CONSTRAINT "CrmOpportunityStatus_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmOpportunityStatus" DROP CONSTRAINT "CrmOpportunityStatus_pkey";
       public            postgres    false    389    389            �           2606    17945    CrmProduct CrmProduct_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmProduct"
    ADD CONSTRAINT "CrmProduct_pkey" PRIMARY KEY ("ProductId", "TenantId");
 H   ALTER TABLE ONLY public."CrmProduct" DROP CONSTRAINT "CrmProduct_pkey";
       public            postgres    false    391    391            �           2606    17947 ,   CrmProductTenant100 CrmProductTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmProductTenant100"
    ADD CONSTRAINT "CrmProductTenant100_pkey" PRIMARY KEY ("ProductId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmProductTenant100" DROP CONSTRAINT "CrmProductTenant100_pkey";
       public            postgres    false    394    394    394    6627            �           2606    17949 (   CrmProductTenant1 CrmProductTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant1"
    ADD CONSTRAINT "CrmProductTenant1_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant1" DROP CONSTRAINT "CrmProductTenant1_pkey";
       public            postgres    false    6627    393    393    393            �           2606    17951 (   CrmProductTenant2 CrmProductTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant2"
    ADD CONSTRAINT "CrmProductTenant2_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant2" DROP CONSTRAINT "CrmProductTenant2_pkey";
       public            postgres    false    395    6627    395    395            �           2606    17953 (   CrmProductTenant3 CrmProductTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant3"
    ADD CONSTRAINT "CrmProductTenant3_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant3" DROP CONSTRAINT "CrmProductTenant3_pkey";
       public            postgres    false    396    396    6627    396            �           2606    17955    CrmProject CrmProject_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmProject"
    ADD CONSTRAINT "CrmProject_pkey" PRIMARY KEY ("ProjectId", "TenantId");
 H   ALTER TABLE ONLY public."CrmProject" DROP CONSTRAINT "CrmProject_pkey";
       public            postgres    false    397    397            �           2606    17957    CrmStatusLog CrmStatusLog_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."CrmStatusLog"
    ADD CONSTRAINT "CrmStatusLog_pkey" PRIMARY KEY ("LogId");
 L   ALTER TABLE ONLY public."CrmStatusLog" DROP CONSTRAINT "CrmStatusLog_pkey";
       public            postgres    false    399            �           2606    17959    CrmTagUsed CrmTagUsed_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmTagUsed"
    ADD CONSTRAINT "CrmTagUsed_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 H   ALTER TABLE ONLY public."CrmTagUsed" DROP CONSTRAINT "CrmTagUsed_pkey";
       public            postgres    false    401    401            �           2606    17961 ,   CrmTagUsedTenant100 CrmTagUsedTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTagUsedTenant100"
    ADD CONSTRAINT "CrmTagUsedTenant100_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmTagUsedTenant100" DROP CONSTRAINT "CrmTagUsedTenant100_pkey";
       public            postgres    false    404    404    404    6646            �           2606    17963 (   CrmTagUsedTenant1 CrmTagUsedTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant1"
    ADD CONSTRAINT "CrmTagUsedTenant1_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant1" DROP CONSTRAINT "CrmTagUsedTenant1_pkey";
       public            postgres    false    403    403    403    6646                        2606    17965 (   CrmTagUsedTenant2 CrmTagUsedTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant2"
    ADD CONSTRAINT "CrmTagUsedTenant2_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant2" DROP CONSTRAINT "CrmTagUsedTenant2_pkey";
       public            postgres    false    405    405    6646    405                       2606    17967 (   CrmTagUsedTenant3 CrmTagUsedTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant3"
    ADD CONSTRAINT "CrmTagUsedTenant3_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant3" DROP CONSTRAINT "CrmTagUsedTenant3_pkey";
       public            postgres    false    406    406    406    6646                       2606    17969    CrmTags CrmTags_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."CrmTags"
    ADD CONSTRAINT "CrmTags_pkey" PRIMARY KEY ("TagId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTags" DROP CONSTRAINT "CrmTags_pkey";
       public            postgres    false    407    407                       2606    17971 &   CrmTagsTenant100 CrmTagsTenant100_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public."CrmTagsTenant100"
    ADD CONSTRAINT "CrmTagsTenant100_pkey" PRIMARY KEY ("TagId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTagsTenant100" DROP CONSTRAINT "CrmTagsTenant100_pkey";
       public            postgres    false    410    410    6661    410            	           2606    17973 "   CrmTagsTenant1 CrmTagsTenant1_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant1"
    ADD CONSTRAINT "CrmTagsTenant1_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant1" DROP CONSTRAINT "CrmTagsTenant1_pkey";
       public            postgres    false    6661    409    409    409                       2606    17975 "   CrmTagsTenant2 CrmTagsTenant2_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant2"
    ADD CONSTRAINT "CrmTagsTenant2_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant2" DROP CONSTRAINT "CrmTagsTenant2_pkey";
       public            postgres    false    411    411    411    6661                       2606    17977 "   CrmTagsTenant3 CrmTagsTenant3_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant3"
    ADD CONSTRAINT "CrmTagsTenant3_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant3" DROP CONSTRAINT "CrmTagsTenant3_pkey";
       public            postgres    false    412    6661    412    412                       2606    17979 $   CrmTaskPriority CrmTaskPriority_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."CrmTaskPriority"
    ADD CONSTRAINT "CrmTaskPriority_pkey" PRIMARY KEY ("PriorityId");
 R   ALTER TABLE ONLY public."CrmTaskPriority" DROP CONSTRAINT "CrmTaskPriority_pkey";
       public            postgres    false    414                       2606    17981     CrmTaskStatus CrmTaskStatus_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmTaskStatus"
    ADD CONSTRAINT "CrmTaskStatus_pkey" PRIMARY KEY ("StatusId");
 N   ALTER TABLE ONLY public."CrmTaskStatus" DROP CONSTRAINT "CrmTaskStatus_pkey";
       public            postgres    false    416                       2606    17983    CrmTaskTags CrmTaskTags_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmTaskTags"
    ADD CONSTRAINT "CrmTaskTags_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 J   ALTER TABLE ONLY public."CrmTaskTags" DROP CONSTRAINT "CrmTaskTags_pkey";
       public            postgres    false    418    418            #           2606    17985 .   CrmTaskTagsTenant100 CrmTaskTagsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant100"
    ADD CONSTRAINT "CrmTaskTagsTenant100_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTaskTagsTenant100" DROP CONSTRAINT "CrmTaskTagsTenant100_pkey";
       public            postgres    false    421    421    421    6684                        2606    17987 *   CrmTaskTagsTenant1 CrmTaskTagsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant1"
    ADD CONSTRAINT "CrmTaskTagsTenant1_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant1" DROP CONSTRAINT "CrmTaskTagsTenant1_pkey";
       public            postgres    false    420    420    6684    420            &           2606    17989 *   CrmTaskTagsTenant2 CrmTaskTagsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant2"
    ADD CONSTRAINT "CrmTaskTagsTenant2_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant2" DROP CONSTRAINT "CrmTaskTagsTenant2_pkey";
       public            postgres    false    422    422    422    6684            )           2606    17991 *   CrmTaskTagsTenant3 CrmTaskTagsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant3"
    ADD CONSTRAINT "CrmTaskTagsTenant3_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant3" DROP CONSTRAINT "CrmTaskTagsTenant3_pkey";
       public            postgres    false    423    6684    423    423                       2606    17993    CrmTask CrmTask_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmTask"
    ADD CONSTRAINT "CrmTask_pkey" PRIMARY KEY ("TaskId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTask" DROP CONSTRAINT "CrmTask_pkey";
       public            postgres    false    413    413            /           2606    17995 &   CrmTaskTenant100 CrmTaskTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTaskTenant100"
    ADD CONSTRAINT "CrmTaskTenant100_pkey" PRIMARY KEY ("TaskId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTaskTenant100" DROP CONSTRAINT "CrmTaskTenant100_pkey";
       public            postgres    false    426    426    426    6676            ,           2606    17997 "   CrmTaskTenant1 CrmTaskTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant1"
    ADD CONSTRAINT "CrmTaskTenant1_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant1" DROP CONSTRAINT "CrmTaskTenant1_pkey";
       public            postgres    false    6676    425    425    425            2           2606    17999 "   CrmTaskTenant2 CrmTaskTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant2"
    ADD CONSTRAINT "CrmTaskTenant2_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant2" DROP CONSTRAINT "CrmTaskTenant2_pkey";
       public            postgres    false    427    6676    427    427            5           2606    18001 "   CrmTaskTenant3 CrmTaskTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant3"
    ADD CONSTRAINT "CrmTaskTenant3_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant3" DROP CONSTRAINT "CrmTaskTenant3_pkey";
       public            postgres    false    428    428    6676    428            :           2606    18003     CrmTeamMember CrmTeamMember_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTeamMember"
    ADD CONSTRAINT "CrmTeamMember_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 N   ALTER TABLE ONLY public."CrmTeamMember" DROP CONSTRAINT "CrmTeamMember_pkey";
       public            postgres    false    430    430            A           2606    18005 2   CrmTeamMemberTenant100 CrmTeamMemberTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant100"
    ADD CONSTRAINT "CrmTeamMemberTenant100_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 `   ALTER TABLE ONLY public."CrmTeamMemberTenant100" DROP CONSTRAINT "CrmTeamMemberTenant100_pkey";
       public            postgres    false    433    6714    433    433            >           2606    18007 .   CrmTeamMemberTenant1 CrmTeamMemberTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant1"
    ADD CONSTRAINT "CrmTeamMemberTenant1_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant1" DROP CONSTRAINT "CrmTeamMemberTenant1_pkey";
       public            postgres    false    432    432    6714    432            D           2606    18009 .   CrmTeamMemberTenant2 CrmTeamMemberTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant2"
    ADD CONSTRAINT "CrmTeamMemberTenant2_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant2" DROP CONSTRAINT "CrmTeamMemberTenant2_pkey";
       public            postgres    false    434    434    6714    434            G           2606    18011 .   CrmTeamMemberTenant3 CrmTeamMemberTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant3"
    ADD CONSTRAINT "CrmTeamMemberTenant3_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant3" DROP CONSTRAINT "CrmTeamMemberTenant3_pkey";
       public            postgres    false    435    435    435    6714            7           2606    18013    CrmTeam CrmTeam_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmTeam"
    ADD CONSTRAINT "CrmTeam_pkey" PRIMARY KEY ("TeamId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTeam" DROP CONSTRAINT "CrmTeam_pkey";
       public            postgres    false    429    429            M           2606    18015 &   CrmTeamTenant100 CrmTeamTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTeamTenant100"
    ADD CONSTRAINT "CrmTeamTenant100_pkey" PRIMARY KEY ("TeamId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTeamTenant100" DROP CONSTRAINT "CrmTeamTenant100_pkey";
       public            postgres    false    438    438    6711    438            J           2606    18017 "   CrmTeamTenant1 CrmTeamTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant1"
    ADD CONSTRAINT "CrmTeamTenant1_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant1" DROP CONSTRAINT "CrmTeamTenant1_pkey";
       public            postgres    false    437    437    6711    437            P           2606    18019 "   CrmTeamTenant2 CrmTeamTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant2"
    ADD CONSTRAINT "CrmTeamTenant2_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant2" DROP CONSTRAINT "CrmTeamTenant2_pkey";
       public            postgres    false    6711    439    439    439            S           2606    18021 "   CrmTeamTenant3 CrmTeamTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant3"
    ADD CONSTRAINT "CrmTeamTenant3_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant3" DROP CONSTRAINT "CrmTeamTenant3_pkey";
       public            postgres    false    440    440    6711    440            U           2606    18023 *   CrmUserActivityLog CrmUserActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLog"
    ADD CONSTRAINT "CrmUserActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 X   ALTER TABLE ONLY public."CrmUserActivityLog" DROP CONSTRAINT "CrmUserActivityLog_pkey";
       public            postgres    false    441    441            \           2606    18025 <   CrmUserActivityLogTenant100 CrmUserActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant100"
    ADD CONSTRAINT "CrmUserActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 j   ALTER TABLE ONLY public."CrmUserActivityLogTenant100" DROP CONSTRAINT "CrmUserActivityLogTenant100_pkey";
       public            postgres    false    444    444    6741    444            Y           2606    18027 8   CrmUserActivityLogTenant1 CrmUserActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant1"
    ADD CONSTRAINT "CrmUserActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant1" DROP CONSTRAINT "CrmUserActivityLogTenant1_pkey";
       public            postgres    false    443    443    6741    443            _           2606    18029 8   CrmUserActivityLogTenant2 CrmUserActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant2"
    ADD CONSTRAINT "CrmUserActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant2" DROP CONSTRAINT "CrmUserActivityLogTenant2_pkey";
       public            postgres    false    445    445    6741    445            b           2606    18031 8   CrmUserActivityLogTenant3 CrmUserActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant3"
    ADD CONSTRAINT "CrmUserActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant3" DROP CONSTRAINT "CrmUserActivityLogTenant3_pkey";
       public            postgres    false    6741    446    446    446            d           2606    18033 ,   CrmUserActivityType CrmUserActivityType_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."CrmUserActivityType"
    ADD CONSTRAINT "CrmUserActivityType_pkey" PRIMARY KEY ("ActivityTypeId");
 Z   ALTER TABLE ONLY public."CrmUserActivityType" DROP CONSTRAINT "CrmUserActivityType_pkey";
       public            postgres    false    447            �           2606    19061 +   CrmFormFieldTypes NewCrmFormFieldTypes_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmFormFieldTypes"
    ADD CONSTRAINT "NewCrmFormFieldTypes_pkey" PRIMARY KEY ("TypeId");
 Y   ALTER TABLE ONLY public."CrmFormFieldTypes" DROP CONSTRAINT "NewCrmFormFieldTypes_pkey";
       public            postgres    false    492            �           2606    18633    Notification Notification_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY ("NotificationId", "TenantId");
 L   ALTER TABLE ONLY public."Notification" DROP CONSTRAINT "Notification_pkey";
       public            postgres    false    470    470            �           2606    18655 $   Notification100 Notification100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."Notification100"
    ADD CONSTRAINT "Notification100_pkey" PRIMARY KEY ("NotificationId", "TenantId");
 R   ALTER TABLE ONLY public."Notification100" DROP CONSTRAINT "Notification100_pkey";
       public            postgres    false    472    472    6797    472            �           2606    18643     Notification1 Notification1_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."Notification1"
    ADD CONSTRAINT "Notification1_pkey" PRIMARY KEY ("NotificationId", "TenantId");
 N   ALTER TABLE ONLY public."Notification1" DROP CONSTRAINT "Notification1_pkey";
       public            postgres    false    471    6797    471    471            �           2606    18667     Notification2 Notification2_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."Notification2"
    ADD CONSTRAINT "Notification2_pkey" PRIMARY KEY ("NotificationId", "TenantId");
 N   ALTER TABLE ONLY public."Notification2" DROP CONSTRAINT "Notification2_pkey";
       public            postgres    false    473    473    6797    473            �           2606    18679     Notification3 Notification3_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."Notification3"
    ADD CONSTRAINT "Notification3_pkey" PRIMARY KEY ("NotificationId", "TenantId");
 N   ALTER TABLE ONLY public."Notification3" DROP CONSTRAINT "Notification3_pkey";
       public            postgres    false    6797    474    474    474            f           2606    18035    Tenant Tenant_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public."Tenant"
    ADD CONSTRAINT "Tenant_pkey" PRIMARY KEY ("TenantId");
 @   ALTER TABLE ONLY public."Tenant" DROP CONSTRAINT "Tenant_pkey";
       public            postgres    false    449            i           2606    18460    Ticket Ticket_PK 
   CONSTRAINT     f   ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "Ticket_PK" PRIMARY KEY ("TicketId", "TenantId");
 >   ALTER TABLE ONLY public."Ticket" DROP CONSTRAINT "Ticket_PK";
       public            postgres    false    452    452            p           2606    18486    Ticket100 Ticket100_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."Ticket100"
    ADD CONSTRAINT "Ticket100_pkey" PRIMARY KEY ("TicketId", "TenantId");
 F   ALTER TABLE ONLY public."Ticket100" DROP CONSTRAINT "Ticket100_pkey";
       public            postgres    false    6761    454    454    454            m           2606    18472    Ticket1 Ticket1_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."Ticket1"
    ADD CONSTRAINT "Ticket1_pkey" PRIMARY KEY ("TicketId", "TenantId");
 B   ALTER TABLE ONLY public."Ticket1" DROP CONSTRAINT "Ticket1_pkey";
       public            postgres    false    6761    453    453    453            s           2606    18500    Ticket2 Ticket2_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."Ticket2"
    ADD CONSTRAINT "Ticket2_pkey" PRIMARY KEY ("TicketId", "TenantId");
 B   ALTER TABLE ONLY public."Ticket2" DROP CONSTRAINT "Ticket2_pkey";
       public            postgres    false    455    455    6761    455            v           2606    18514    Ticket3 Ticket3_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."Ticket3"
    ADD CONSTRAINT "Ticket3_pkey" PRIMARY KEY ("TicketId", "TenantId");
 B   ALTER TABLE ONLY public."Ticket3" DROP CONSTRAINT "Ticket3_pkey";
       public            postgres    false    456    456    6761    456            �           2606    18623 "   TicketPriority TicketPriority_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."TicketPriority"
    ADD CONSTRAINT "TicketPriority_pkey" PRIMARY KEY ("TicketPriorityId");
 P   ALTER TABLE ONLY public."TicketPriority" DROP CONSTRAINT "TicketPriority_pkey";
       public            postgres    false    468            �           2606    18615    TicketStatus TicketStatus_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."TicketStatus"
    ADD CONSTRAINT "TicketStatus_pkey" PRIMARY KEY ("TicketStatusId");
 L   ALTER TABLE ONLY public."TicketStatus" DROP CONSTRAINT "TicketStatus_pkey";
       public            postgres    false    466            �           2606    18605    TicketType TicketType_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."TicketType"
    ADD CONSTRAINT "TicketType_pkey" PRIMARY KEY ("TicketTypeId");
 H   ALTER TABLE ONLY public."TicketType" DROP CONSTRAINT "TicketType_pkey";
       public            postgres    false    464            �           2606    18037    AppMenus appmenu_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."AppMenus"
    ADD CONSTRAINT appmenu_pkey PRIMARY KEY ("MenuId");
 A   ALTER TABLE ONLY public."AppMenus" DROP CONSTRAINT appmenu_pkey;
       public            postgres    false    258            y           1259    18549    idx_ConversationId    INDEX     `   CREATE INDEX "idx_ConversationId" ON ONLY public."Conversation" USING btree ("ConversationId");
 (   DROP INDEX public."idx_ConversationId";
       public            postgres    false    458            }           1259    18571 "   Conversation100_ConversationId_idx    INDEX     n   CREATE INDEX "Conversation100_ConversationId_idx" ON public."Conversation100" USING btree ("ConversationId");
 8   DROP INDEX public."Conversation100_ConversationId_idx";
       public            postgres    false    460    460    6777            z           1259    18559     Conversation1_ConversationId_idx    INDEX     j   CREATE INDEX "Conversation1_ConversationId_idx" ON public."Conversation1" USING btree ("ConversationId");
 6   DROP INDEX public."Conversation1_ConversationId_idx";
       public            postgres    false    6777    459    459            �           1259    18583     Conversation2_ConversationId_idx    INDEX     j   CREATE INDEX "Conversation2_ConversationId_idx" ON public."Conversation2" USING btree ("ConversationId");
 6   DROP INDEX public."Conversation2_ConversationId_idx";
       public            postgres    false    461    461    6777            �           1259    18595     Conversation3_ConversationId_idx    INDEX     j   CREATE INDEX "Conversation3_ConversationId_idx" ON public."Conversation3" USING btree ("ConversationId");
 6   DROP INDEX public."Conversation3_ConversationId_idx";
       public            postgres    false    462    462    6777            �           1259    18038    idx_AccountId    INDEX     V   CREATE INDEX "idx_AccountId" ON ONLY public."CrmAdAccount" USING btree ("AccountId");
 #   DROP INDEX public."idx_AccountId";
       public            postgres    false    260            �           1259    18039    CrmAdAccount100_AccountId_idx    INDEX     d   CREATE INDEX "CrmAdAccount100_AccountId_idx" ON public."CrmAdAccount100" USING btree ("AccountId");
 3   DROP INDEX public."CrmAdAccount100_AccountId_idx";
       public            postgres    false    6302    263    263            �           1259    18040    CrmAdAccount1_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount1_AccountId_idx" ON public."CrmAdAccount1" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount1_AccountId_idx";
       public            postgres    false    262    6302    262            �           1259    18041    CrmAdAccount2_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount2_AccountId_idx" ON public."CrmAdAccount2" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount2_AccountId_idx";
       public            postgres    false    264    6302    264            �           1259    18042    CrmAdAccount3_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount3_AccountId_idx" ON public."CrmAdAccount3" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount3_AccountId_idx";
       public            postgres    false    265    265    6302            �           1259    18043    idx_crmcalenderevents_eventid    INDEX     g   CREATE INDEX idx_crmcalenderevents_eventid ON ONLY public."CrmCalenderEvents" USING btree ("EventId");
 1   DROP INDEX public.idx_crmcalenderevents_eventid;
       public            postgres    false    268            �           1259    18044 &   CrmCalenderEventsTenant100_EventId_idx    INDEX     v   CREATE INDEX "CrmCalenderEventsTenant100_EventId_idx" ON public."CrmCalenderEventsTenant100" USING btree ("EventId");
 <   DROP INDEX public."CrmCalenderEventsTenant100_EventId_idx";
       public            postgres    false    6319    271    271            �           1259    18045 $   CrmCalenderEventsTenant1_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant1_EventId_idx" ON public."CrmCalenderEventsTenant1" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant1_EventId_idx";
       public            postgres    false    270    270    6319            �           1259    18046 $   CrmCalenderEventsTenant2_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant2_EventId_idx" ON public."CrmCalenderEventsTenant2" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant2_EventId_idx";
       public            postgres    false    6319    272    272            �           1259    18047 $   CrmCalenderEventsTenant3_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant3_EventId_idx" ON public."CrmCalenderEventsTenant3" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant3_EventId_idx";
       public            postgres    false    6319    273    273            �           1259    18048 
   idx_CallId    INDEX     K   CREATE INDEX "idx_CallId" ON ONLY public."CrmCall" USING btree ("CallId");
     DROP INDEX public."idx_CallId";
       public            postgres    false    274            �           1259    18049    CrmCall100_CallId_idx    INDEX     T   CREATE INDEX "CrmCall100_CallId_idx" ON public."CrmCall100" USING btree ("CallId");
 +   DROP INDEX public."CrmCall100_CallId_idx";
       public            postgres    false    6334    277    277            �           1259    18050    CrmCall1_CallId_idx    INDEX     P   CREATE INDEX "CrmCall1_CallId_idx" ON public."CrmCall1" USING btree ("CallId");
 )   DROP INDEX public."CrmCall1_CallId_idx";
       public            postgres    false    6334    276    276            �           1259    18051    CrmCall2_CallId_idx    INDEX     P   CREATE INDEX "CrmCall2_CallId_idx" ON public."CrmCall2" USING btree ("CallId");
 )   DROP INDEX public."CrmCall2_CallId_idx";
       public            postgres    false    6334    278    278            �           1259    18052    CrmCall3_CallId_idx    INDEX     P   CREATE INDEX "CrmCall3_CallId_idx" ON public."CrmCall3" USING btree ("CallId");
 )   DROP INDEX public."CrmCall3_CallId_idx";
       public            postgres    false    279    279    6334            �           1259    18053    idx_CampaignId    INDEX     W   CREATE INDEX "idx_CampaignId" ON ONLY public."CrmCampaign" USING btree ("CampaignId");
 $   DROP INDEX public."idx_CampaignId";
       public            postgres    false    280            �           1259    18054    CrmCampaign100_CampaignId_idx    INDEX     d   CREATE INDEX "CrmCampaign100_CampaignId_idx" ON public."CrmCampaign100" USING btree ("CampaignId");
 3   DROP INDEX public."CrmCampaign100_CampaignId_idx";
       public            postgres    false    282    6349    282            �           1259    18055    CrmCampaign1_CampaignId_idx    INDEX     `   CREATE INDEX "CrmCampaign1_CampaignId_idx" ON public."CrmCampaign1" USING btree ("CampaignId");
 1   DROP INDEX public."CrmCampaign1_CampaignId_idx";
       public            postgres    false    281    281    6349            �           1259    18056    CrmCampaign2_CampaignId_idx    INDEX     `   CREATE INDEX "CrmCampaign2_CampaignId_idx" ON public."CrmCampaign2" USING btree ("CampaignId");
 1   DROP INDEX public."CrmCampaign2_CampaignId_idx";
       public            postgres    false    283    283    6349            �           1259    18057    CrmCampaign3_CampaignId_idx    INDEX     `   CREATE INDEX "CrmCampaign3_CampaignId_idx" ON public."CrmCampaign3" USING btree ("CampaignId");
 1   DROP INDEX public."CrmCampaign3_CampaignId_idx";
       public            postgres    false    6349    284    284            �           1259    18058 $   idx_crmcompanyactivitylog_activityid    INDEX     u   CREATE INDEX idx_crmcompanyactivitylog_activityid ON ONLY public."CrmCompanyActivityLog" USING btree ("ActivityId");
 8   DROP INDEX public.idx_crmcompanyactivitylog_activityid;
       public            postgres    false    286            �           1259    18059 -   CrmCompanyActivityLogTenant100_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant100_ActivityId_idx" ON public."CrmCompanyActivityLogTenant100" USING btree ("ActivityId");
 C   DROP INDEX public."CrmCompanyActivityLogTenant100_ActivityId_idx";
       public            postgres    false    289    289    6367            �           1259    18060 +   CrmCompanyActivityLogTenant1_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant1_ActivityId_idx" ON public."CrmCompanyActivityLogTenant1" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant1_ActivityId_idx";
       public            postgres    false    288    288    6367            �           1259    18061 +   CrmCompanyActivityLogTenant2_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant2_ActivityId_idx" ON public."CrmCompanyActivityLogTenant2" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant2_ActivityId_idx";
       public            postgres    false    6367    290    290            �           1259    18062 +   CrmCompanyActivityLogTenant3_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant3_ActivityId_idx" ON public."CrmCompanyActivityLogTenant3" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant3_ActivityId_idx";
       public            postgres    false    6367    291    291            �           1259    18063    idx_crmcompanymember_companyid    INDEX     i   CREATE INDEX idx_crmcompanymember_companyid ON ONLY public."CrmCompanyMember" USING btree ("CompanyId");
 2   DROP INDEX public.idx_crmcompanymember_companyid;
       public            postgres    false    292            �           1259    18064 '   CrmCompanyMemberTenant100_CompanyId_idx    INDEX     x   CREATE INDEX "CrmCompanyMemberTenant100_CompanyId_idx" ON public."CrmCompanyMemberTenant100" USING btree ("CompanyId");
 =   DROP INDEX public."CrmCompanyMemberTenant100_CompanyId_idx";
       public            postgres    false    295    6382    295            �           1259    18065    idx_crmcompanymember_memberid    INDEX     g   CREATE INDEX idx_crmcompanymember_memberid ON ONLY public."CrmCompanyMember" USING btree ("MemberId");
 1   DROP INDEX public.idx_crmcompanymember_memberid;
       public            postgres    false    292            �           1259    18066 &   CrmCompanyMemberTenant100_MemberId_idx    INDEX     v   CREATE INDEX "CrmCompanyMemberTenant100_MemberId_idx" ON public."CrmCompanyMemberTenant100" USING btree ("MemberId");
 <   DROP INDEX public."CrmCompanyMemberTenant100_MemberId_idx";
       public            postgres    false    295    295    6383            �           1259    18067 %   CrmCompanyMemberTenant1_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant1_CompanyId_idx" ON public."CrmCompanyMemberTenant1" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant1_CompanyId_idx";
       public            postgres    false    294    6382    294            �           1259    18068 $   CrmCompanyMemberTenant1_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant1_MemberId_idx" ON public."CrmCompanyMemberTenant1" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant1_MemberId_idx";
       public            postgres    false    294    6383    294            �           1259    18069 %   CrmCompanyMemberTenant2_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant2_CompanyId_idx" ON public."CrmCompanyMemberTenant2" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant2_CompanyId_idx";
       public            postgres    false    296    296    6382            �           1259    18070 $   CrmCompanyMemberTenant2_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant2_MemberId_idx" ON public."CrmCompanyMemberTenant2" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant2_MemberId_idx";
       public            postgres    false    296    296    6383            �           1259    18071 %   CrmCompanyMemberTenant3_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant3_CompanyId_idx" ON public."CrmCompanyMemberTenant3" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant3_CompanyId_idx";
       public            postgres    false    297    297    6382            �           1259    18072 $   CrmCompanyMemberTenant3_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant3_MemberId_idx" ON public."CrmCompanyMemberTenant3" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant3_MemberId_idx";
       public            postgres    false    6383    297    297            �           1259    18073    idx_crmcompany_companyid    INDEX     ]   CREATE INDEX idx_crmcompany_companyid ON ONLY public."CrmCompany" USING btree ("CompanyId");
 ,   DROP INDEX public.idx_crmcompany_companyid;
       public            postgres    false    285                       1259    18074 !   CrmCompanyTenant100_CompanyId_idx    INDEX     l   CREATE INDEX "CrmCompanyTenant100_CompanyId_idx" ON public."CrmCompanyTenant100" USING btree ("CompanyId");
 7   DROP INDEX public."CrmCompanyTenant100_CompanyId_idx";
       public            postgres    false    300    6364    300                        1259    18075    CrmCompanyTenant1_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant1_CompanyId_idx" ON public."CrmCompanyTenant1" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant1_CompanyId_idx";
       public            postgres    false    299    299    6364                       1259    18076    CrmCompanyTenant2_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant2_CompanyId_idx" ON public."CrmCompanyTenant2" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant2_CompanyId_idx";
       public            postgres    false    301    6364    301            	           1259    18077    CrmCompanyTenant3_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant3_CompanyId_idx" ON public."CrmCompanyTenant3" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant3_CompanyId_idx";
       public            postgres    false    302    6364    302                       1259    18078 
   idx_ListId    INDEX     R   CREATE INDEX "idx_ListId" ON ONLY public."CrmCustomLists" USING btree ("ListId");
     DROP INDEX public."idx_ListId";
       public            postgres    false    303                       1259    18079 "   CrmCustomListsTenant100_ListId_idx    INDEX     n   CREATE INDEX "CrmCustomListsTenant100_ListId_idx" ON public."CrmCustomListsTenant100" USING btree ("ListId");
 8   DROP INDEX public."CrmCustomListsTenant100_ListId_idx";
       public            postgres    false    6414    306    306                       1259    18080     CrmCustomListsTenant1_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant1_ListId_idx" ON public."CrmCustomListsTenant1" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant1_ListId_idx";
       public            postgres    false    6414    305    305                       1259    18081     CrmCustomListsTenant2_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant2_ListId_idx" ON public."CrmCustomListsTenant2" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant2_ListId_idx";
       public            postgres    false    307    6414    307                       1259    18082     CrmCustomListsTenant3_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant3_ListId_idx" ON public."CrmCustomListsTenant3" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant3_ListId_idx";
       public            postgres    false    308    6414    308                       1259    18083    idx_EmailId    INDEX     N   CREATE INDEX "idx_EmailId" ON ONLY public."CrmEmail" USING btree ("EmailId");
 !   DROP INDEX public."idx_EmailId";
       public            postgres    false    309            !           1259    18084    CrmEmail100_EmailId_idx    INDEX     X   CREATE INDEX "CrmEmail100_EmailId_idx" ON public."CrmEmail100" USING btree ("EmailId");
 -   DROP INDEX public."CrmEmail100_EmailId_idx";
       public            postgres    false    6429    312    312                       1259    18085    CrmEmail1_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail1_EmailId_idx" ON public."CrmEmail1" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail1_EmailId_idx";
       public            postgres    false    311    6429    311            $           1259    18086    CrmEmail2_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail2_EmailId_idx" ON public."CrmEmail2" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail2_EmailId_idx";
       public            postgres    false    313    6429    313            '           1259    18087    CrmEmail3_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail3_EmailId_idx" ON public."CrmEmail3" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail3_EmailId_idx";
       public            postgres    false    6429    314    314            ,           1259    18088    idx_FieldId    INDEX     S   CREATE INDEX "idx_FieldId" ON ONLY public."CrmFormFields" USING btree ("FieldId");
 !   DROP INDEX public."idx_FieldId";
       public            postgres    false    315            0           1259    18089    CrmFormFields100_FieldId_idx    INDEX     b   CREATE INDEX "CrmFormFields100_FieldId_idx" ON public."CrmFormFields100" USING btree ("FieldId");
 2   DROP INDEX public."CrmFormFields100_FieldId_idx";
       public            postgres    false    318    6444    318            -           1259    18090    CrmFormFields1_FieldId_idx    INDEX     ^   CREATE INDEX "CrmFormFields1_FieldId_idx" ON public."CrmFormFields1" USING btree ("FieldId");
 0   DROP INDEX public."CrmFormFields1_FieldId_idx";
       public            postgres    false    317    6444    317            3           1259    18091    CrmFormFields2_FieldId_idx    INDEX     ^   CREATE INDEX "CrmFormFields2_FieldId_idx" ON public."CrmFormFields2" USING btree ("FieldId");
 0   DROP INDEX public."CrmFormFields2_FieldId_idx";
       public            postgres    false    319    6444    319            6           1259    18092    CrmFormFields3_FieldId_idx    INDEX     ^   CREATE INDEX "CrmFormFields3_FieldId_idx" ON public."CrmFormFields3" USING btree ("FieldId");
 0   DROP INDEX public."CrmFormFields3_FieldId_idx";
       public            postgres    false    6444    320    320            ;           1259    18093    idx_ResultId    INDEX     V   CREATE INDEX "idx_ResultId" ON ONLY public."CrmFormResults" USING btree ("ResultId");
 "   DROP INDEX public."idx_ResultId";
       public            postgres    false    321            ?           1259    18094    CrmFormResults100_ResultId_idx    INDEX     f   CREATE INDEX "CrmFormResults100_ResultId_idx" ON public."CrmFormResults100" USING btree ("ResultId");
 4   DROP INDEX public."CrmFormResults100_ResultId_idx";
       public            postgres    false    6459    324    324            <           1259    18095    CrmFormResults1_ResultId_idx    INDEX     b   CREATE INDEX "CrmFormResults1_ResultId_idx" ON public."CrmFormResults1" USING btree ("ResultId");
 2   DROP INDEX public."CrmFormResults1_ResultId_idx";
       public            postgres    false    323    323    6459            B           1259    18096    CrmFormResults2_ResultId_idx    INDEX     b   CREATE INDEX "CrmFormResults2_ResultId_idx" ON public."CrmFormResults2" USING btree ("ResultId");
 2   DROP INDEX public."CrmFormResults2_ResultId_idx";
       public            postgres    false    6459    325    325            E           1259    18097    CrmFormResults3_ResultId_idx    INDEX     b   CREATE INDEX "CrmFormResults3_ResultId_idx" ON public."CrmFormResults3" USING btree ("ResultId");
 2   DROP INDEX public."CrmFormResults3_ResultId_idx";
       public            postgres    false    326    326    6459            �           1259    18692 
   idx_FormId    INDEX     L   CREATE INDEX "idx_FormId" ON ONLY public."CrmForms" USING btree ("FormId");
     DROP INDEX public."idx_FormId";
       public            postgres    false    476            �           1259    18712    CrmForms100_FormId_idx    INDEX     V   CREATE INDEX "CrmForms100_FormId_idx" ON public."CrmForms100" USING btree ("FormId");
 ,   DROP INDEX public."CrmForms100_FormId_idx";
       public            postgres    false    478    478    6813            �           1259    18701    CrmForms1_FormId_idx    INDEX     R   CREATE INDEX "CrmForms1_FormId_idx" ON public."CrmForms1" USING btree ("FormId");
 *   DROP INDEX public."CrmForms1_FormId_idx";
       public            postgres    false    6813    477    477            �           1259    18723    CrmForms2_FormId_idx    INDEX     R   CREATE INDEX "CrmForms2_FormId_idx" ON public."CrmForms2" USING btree ("FormId");
 *   DROP INDEX public."CrmForms2_FormId_idx";
       public            postgres    false    479    6813    479            �           1259    18734    CrmForms3_FormId_idx    INDEX     R   CREATE INDEX "CrmForms3_FormId_idx" ON public."CrmForms3" USING btree ("FormId");
 *   DROP INDEX public."CrmForms3_FormId_idx";
       public            postgres    false    6813    480    480            L           1259    18098    idx_crmindustry_industryid    INDEX     a   CREATE INDEX idx_crmindustry_industryid ON ONLY public."CrmIndustry" USING btree ("IndustryId");
 .   DROP INDEX public.idx_crmindustry_industryid;
       public            postgres    false    329            P           1259    18099 #   CrmIndustryTenant100_IndustryId_idx    INDEX     p   CREATE INDEX "CrmIndustryTenant100_IndustryId_idx" ON public."CrmIndustryTenant100" USING btree ("IndustryId");
 9   DROP INDEX public."CrmIndustryTenant100_IndustryId_idx";
       public            postgres    false    332    332    6476            M           1259    18100 !   CrmIndustryTenant1_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant1_IndustryId_idx" ON public."CrmIndustryTenant1" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant1_IndustryId_idx";
       public            postgres    false    331    331    6476            S           1259    18101 !   CrmIndustryTenant2_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant2_IndustryId_idx" ON public."CrmIndustryTenant2" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant2_IndustryId_idx";
       public            postgres    false    333    6476    333            V           1259    18102 !   CrmIndustryTenant3_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant3_IndustryId_idx" ON public."CrmIndustryTenant3" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant3_IndustryId_idx";
       public            postgres    false    334    334    6476            ^           1259    18103 !   idx_crmleadactivitylog_activityid    INDEX     o   CREATE INDEX idx_crmleadactivitylog_activityid ON ONLY public."CrmLeadActivityLog" USING btree ("ActivityId");
 5   DROP INDEX public.idx_crmleadactivitylog_activityid;
       public            postgres    false    336            b           1259    18104 *   CrmLeadActivityLogTenant100_ActivityId_idx    INDEX     ~   CREATE INDEX "CrmLeadActivityLogTenant100_ActivityId_idx" ON public."CrmLeadActivityLogTenant100" USING btree ("ActivityId");
 @   DROP INDEX public."CrmLeadActivityLogTenant100_ActivityId_idx";
       public            postgres    false    339    339    6494            _           1259    18105 (   CrmLeadActivityLogTenant1_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant1_ActivityId_idx" ON public."CrmLeadActivityLogTenant1" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant1_ActivityId_idx";
       public            postgres    false    338    338    6494            e           1259    18106 (   CrmLeadActivityLogTenant2_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant2_ActivityId_idx" ON public."CrmLeadActivityLogTenant2" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant2_ActivityId_idx";
       public            postgres    false    340    6494    340            h           1259    18107 (   CrmLeadActivityLogTenant3_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant3_ActivityId_idx" ON public."CrmLeadActivityLogTenant3" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant3_ActivityId_idx";
       public            postgres    false    6494    341    341            m           1259    18108    idx_crmleadsource_sourceid    INDEX     a   CREATE INDEX idx_crmleadsource_sourceid ON ONLY public."CrmLeadSource" USING btree ("SourceId");
 .   DROP INDEX public.idx_crmleadsource_sourceid;
       public            postgres    false    342            q           1259    18109 #   CrmLeadSourceTenant100_SourceId_idx    INDEX     p   CREATE INDEX "CrmLeadSourceTenant100_SourceId_idx" ON public."CrmLeadSourceTenant100" USING btree ("SourceId");
 9   DROP INDEX public."CrmLeadSourceTenant100_SourceId_idx";
       public            postgres    false    345    6509    345            n           1259    18110 !   CrmLeadSourceTenant1_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant1_SourceId_idx" ON public."CrmLeadSourceTenant1" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant1_SourceId_idx";
       public            postgres    false    6509    344    344            t           1259    18111 !   CrmLeadSourceTenant2_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant2_SourceId_idx" ON public."CrmLeadSourceTenant2" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant2_SourceId_idx";
       public            postgres    false    6509    346    346            w           1259    18112 !   CrmLeadSourceTenant3_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant3_SourceId_idx" ON public."CrmLeadSourceTenant3" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant3_SourceId_idx";
       public            postgres    false    347    347    6509            |           1259    18113    idx_crmleadstatus_statusid    INDEX     a   CREATE INDEX idx_crmleadstatus_statusid ON ONLY public."CrmLeadStatus" USING btree ("StatusId");
 .   DROP INDEX public.idx_crmleadstatus_statusid;
       public            postgres    false    348            �           1259    18114 #   CrmLeadStatusTenant100_StatusId_idx    INDEX     p   CREATE INDEX "CrmLeadStatusTenant100_StatusId_idx" ON public."CrmLeadStatusTenant100" USING btree ("StatusId");
 9   DROP INDEX public."CrmLeadStatusTenant100_StatusId_idx";
       public            postgres    false    351    6524    351            }           1259    18115 !   CrmLeadStatusTenant1_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant1_StatusId_idx" ON public."CrmLeadStatusTenant1" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant1_StatusId_idx";
       public            postgres    false    350    6524    350            �           1259    18116 !   CrmLeadStatusTenant2_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant2_StatusId_idx" ON public."CrmLeadStatusTenant2" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant2_StatusId_idx";
       public            postgres    false    352    6524    352            �           1259    18117 !   CrmLeadStatusTenant3_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant3_StatusId_idx" ON public."CrmLeadStatusTenant3" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant3_StatusId_idx";
       public            postgres    false    6524    353    353            [           1259    18118    idx_crmlead_leadid    INDEX     Q   CREATE INDEX idx_crmlead_leadid ON ONLY public."CrmLead" USING btree ("LeadId");
 &   DROP INDEX public.idx_crmlead_leadid;
       public            postgres    false    335            �           1259    18119    CrmLeadTenant100_LeadId_idx    INDEX     `   CREATE INDEX "CrmLeadTenant100_LeadId_idx" ON public."CrmLeadTenant100" USING btree ("LeadId");
 1   DROP INDEX public."CrmLeadTenant100_LeadId_idx";
       public            postgres    false    356    6491    356            �           1259    18120    CrmLeadTenant1_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant1_LeadId_idx" ON public."CrmLeadTenant1" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant1_LeadId_idx";
       public            postgres    false    355    6491    355            �           1259    18121    CrmLeadTenant2_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant2_LeadId_idx" ON public."CrmLeadTenant2" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant2_LeadId_idx";
       public            postgres    false    357    6491    357            �           1259    18122    CrmLeadTenant3_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant3_LeadId_idx" ON public."CrmLeadTenant3" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant3_LeadId_idx";
       public            postgres    false    358    358    6491            �           1259    18123    idx_MeetingId    INDEX     T   CREATE INDEX "idx_MeetingId" ON ONLY public."CrmMeeting" USING btree ("MeetingId");
 #   DROP INDEX public."idx_MeetingId";
       public            postgres    false    359            �           1259    18124    CrmMeeting100_MeetingId_idx    INDEX     `   CREATE INDEX "CrmMeeting100_MeetingId_idx" ON public."CrmMeeting100" USING btree ("MeetingId");
 1   DROP INDEX public."CrmMeeting100_MeetingId_idx";
       public            postgres    false    6551    362    362            �           1259    18125    CrmMeeting1_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting1_MeetingId_idx" ON public."CrmMeeting1" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting1_MeetingId_idx";
       public            postgres    false    361    6551    361            �           1259    18126    CrmMeeting2_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting2_MeetingId_idx" ON public."CrmMeeting2" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting2_MeetingId_idx";
       public            postgres    false    6551    363    363            �           1259    18127    CrmMeeting3_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting3_MeetingId_idx" ON public."CrmMeeting3" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting3_MeetingId_idx";
       public            postgres    false    364    6551    364            �           1259    18128    idx_NoteTagsId    INDEX     W   CREATE INDEX "idx_NoteTagsId" ON ONLY public."CrmNoteTags" USING btree ("NoteTagsId");
 $   DROP INDEX public."idx_NoteTagsId";
       public            postgres    false    366            �           1259    18129 #   CrmNoteTagsTenant100_NoteTagsId_idx    INDEX     p   CREATE INDEX "CrmNoteTagsTenant100_NoteTagsId_idx" ON public."CrmNoteTagsTenant100" USING btree ("NoteTagsId");
 9   DROP INDEX public."CrmNoteTagsTenant100_NoteTagsId_idx";
       public            postgres    false    369    369    6569            �           1259    18130 !   CrmNoteTagsTenant1_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant1_NoteTagsId_idx" ON public."CrmNoteTagsTenant1" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant1_NoteTagsId_idx";
       public            postgres    false    6569    368    368            �           1259    18131 !   CrmNoteTagsTenant2_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant2_NoteTagsId_idx" ON public."CrmNoteTagsTenant2" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant2_NoteTagsId_idx";
       public            postgres    false    370    6569    370            �           1259    18132 !   CrmNoteTagsTenant3_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant3_NoteTagsId_idx" ON public."CrmNoteTagsTenant3" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant3_NoteTagsId_idx";
       public            postgres    false    6569    371    371            �           1259    18133    idx_NoteTaskId    INDEX     X   CREATE INDEX "idx_NoteTaskId" ON ONLY public."CrmNoteTasks" USING btree ("NoteTaskId");
 $   DROP INDEX public."idx_NoteTaskId";
       public            postgres    false    372            �           1259    18134 $   CrmNoteTasksTenant100_NoteTaskId_idx    INDEX     r   CREATE INDEX "CrmNoteTasksTenant100_NoteTaskId_idx" ON public."CrmNoteTasksTenant100" USING btree ("NoteTaskId");
 :   DROP INDEX public."CrmNoteTasksTenant100_NoteTaskId_idx";
       public            postgres    false    375    6584    375            �           1259    18135 "   CrmNoteTasksTenant1_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant1_NoteTaskId_idx" ON public."CrmNoteTasksTenant1" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant1_NoteTaskId_idx";
       public            postgres    false    374    374    6584            �           1259    18136 "   CrmNoteTasksTenant2_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant2_NoteTaskId_idx" ON public."CrmNoteTasksTenant2" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant2_NoteTaskId_idx";
       public            postgres    false    6584    376    376            �           1259    18137 "   CrmNoteTasksTenant3_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant3_NoteTaskId_idx" ON public."CrmNoteTasksTenant3" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant3_NoteTaskId_idx";
       public            postgres    false    6584    377    377            �           1259    18138    idx_crmnote_noteid    INDEX     Q   CREATE INDEX idx_crmnote_noteid ON ONLY public."CrmNote" USING btree ("NoteId");
 &   DROP INDEX public.idx_crmnote_noteid;
       public            postgres    false    365            �           1259    18139    CrmNoteTenant100_NoteId_idx    INDEX     `   CREATE INDEX "CrmNoteTenant100_NoteId_idx" ON public."CrmNoteTenant100" USING btree ("NoteId");
 1   DROP INDEX public."CrmNoteTenant100_NoteId_idx";
       public            postgres    false    380    380    6566            �           1259    18140    CrmNoteTenant1_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant1_NoteId_idx" ON public."CrmNoteTenant1" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant1_NoteId_idx";
       public            postgres    false    6566    379    379            �           1259    18141    CrmNoteTenant2_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant2_NoteId_idx" ON public."CrmNoteTenant2" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant2_NoteId_idx";
       public            postgres    false    381    381    6566            �           1259    18142    CrmNoteTenant3_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant3_NoteId_idx" ON public."CrmNoteTenant3" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant3_NoteId_idx";
       public            postgres    false    382    382    6566            �           1259    18143    idx_OpportunityId    INDEX     `   CREATE INDEX "idx_OpportunityId" ON ONLY public."CrmOpportunity" USING btree ("OpportunityId");
 '   DROP INDEX public."idx_OpportunityId";
       public            postgres    false    383            �           1259    18144 #   CrmOpportunity100_OpportunityId_idx    INDEX     p   CREATE INDEX "CrmOpportunity100_OpportunityId_idx" ON public."CrmOpportunity100" USING btree ("OpportunityId");
 9   DROP INDEX public."CrmOpportunity100_OpportunityId_idx";
       public            postgres    false    386    6611    386            �           1259    18145 !   CrmOpportunity1_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity1_OpportunityId_idx" ON public."CrmOpportunity1" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity1_OpportunityId_idx";
       public            postgres    false    385    385    6611            �           1259    18146 !   CrmOpportunity2_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity2_OpportunityId_idx" ON public."CrmOpportunity2" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity2_OpportunityId_idx";
       public            postgres    false    6611    387    387            �           1259    18147 !   CrmOpportunity3_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity3_OpportunityId_idx" ON public."CrmOpportunity3" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity3_OpportunityId_idx";
       public            postgres    false    6611    388    388            �           1259    18148    idx_crmproduct_productid    INDEX     ]   CREATE INDEX idx_crmproduct_productid ON ONLY public."CrmProduct" USING btree ("ProductId");
 ,   DROP INDEX public.idx_crmproduct_productid;
       public            postgres    false    391            �           1259    18149 !   CrmProductTenant100_ProductId_idx    INDEX     l   CREATE INDEX "CrmProductTenant100_ProductId_idx" ON public."CrmProductTenant100" USING btree ("ProductId");
 7   DROP INDEX public."CrmProductTenant100_ProductId_idx";
       public            postgres    false    394    6628    394            �           1259    18150    CrmProductTenant1_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant1_ProductId_idx" ON public."CrmProductTenant1" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant1_ProductId_idx";
       public            postgres    false    6628    393    393            �           1259    18151    CrmProductTenant2_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant2_ProductId_idx" ON public."CrmProductTenant2" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant2_ProductId_idx";
       public            postgres    false    395    6628    395            �           1259    18152    CrmProductTenant3_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant3_ProductId_idx" ON public."CrmProductTenant3" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant3_ProductId_idx";
       public            postgres    false    6628    396    396            �           1259    18153    idx_crmtagused_tagusedid    INDEX     ]   CREATE INDEX idx_crmtagused_tagusedid ON ONLY public."CrmTagUsed" USING btree ("TagUsedId");
 ,   DROP INDEX public.idx_crmtagused_tagusedid;
       public            postgres    false    401            �           1259    18154 !   CrmTagUsedTenant100_TagUsedId_idx    INDEX     l   CREATE INDEX "CrmTagUsedTenant100_TagUsedId_idx" ON public."CrmTagUsedTenant100" USING btree ("TagUsedId");
 7   DROP INDEX public."CrmTagUsedTenant100_TagUsedId_idx";
       public            postgres    false    404    404    6647            �           1259    18155    CrmTagUsedTenant1_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant1_TagUsedId_idx" ON public."CrmTagUsedTenant1" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant1_TagUsedId_idx";
       public            postgres    false    6647    403    403            �           1259    18156    CrmTagUsedTenant2_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant2_TagUsedId_idx" ON public."CrmTagUsedTenant2" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant2_TagUsedId_idx";
       public            postgres    false    6647    405    405                       1259    18157    CrmTagUsedTenant3_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant3_TagUsedId_idx" ON public."CrmTagUsedTenant3" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant3_TagUsedId_idx";
       public            postgres    false    406    406    6647                       1259    18158    idx_crmtags_tagid    INDEX     O   CREATE INDEX idx_crmtags_tagid ON ONLY public."CrmTags" USING btree ("TagId");
 %   DROP INDEX public.idx_crmtags_tagid;
       public            postgres    false    407            
           1259    18159    CrmTagsTenant100_TagId_idx    INDEX     ^   CREATE INDEX "CrmTagsTenant100_TagId_idx" ON public."CrmTagsTenant100" USING btree ("TagId");
 0   DROP INDEX public."CrmTagsTenant100_TagId_idx";
       public            postgres    false    410    6662    410                       1259    18160    CrmTagsTenant1_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant1_TagId_idx" ON public."CrmTagsTenant1" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant1_TagId_idx";
       public            postgres    false    409    6662    409                       1259    18161    CrmTagsTenant2_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant2_TagId_idx" ON public."CrmTagsTenant2" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant2_TagId_idx";
       public            postgres    false    411    411    6662                       1259    18162    CrmTagsTenant3_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant3_TagId_idx" ON public."CrmTagsTenant3" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant3_TagId_idx";
       public            postgres    false    412    412    6662                       1259    18163    idx_TaskTagsId    INDEX     W   CREATE INDEX "idx_TaskTagsId" ON ONLY public."CrmTaskTags" USING btree ("TaskTagsId");
 $   DROP INDEX public."idx_TaskTagsId";
       public            postgres    false    418            !           1259    18164 #   CrmTaskTagsTenant100_TaskTagsId_idx    INDEX     p   CREATE INDEX "CrmTaskTagsTenant100_TaskTagsId_idx" ON public."CrmTaskTagsTenant100" USING btree ("TaskTagsId");
 9   DROP INDEX public."CrmTaskTagsTenant100_TaskTagsId_idx";
       public            postgres    false    421    6685    421                       1259    18165 !   CrmTaskTagsTenant1_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant1_TaskTagsId_idx" ON public."CrmTaskTagsTenant1" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant1_TaskTagsId_idx";
       public            postgres    false    6685    420    420            $           1259    18166 !   CrmTaskTagsTenant2_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant2_TaskTagsId_idx" ON public."CrmTaskTagsTenant2" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant2_TaskTagsId_idx";
       public            postgres    false    6685    422    422            '           1259    18167 !   CrmTaskTagsTenant3_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant3_TaskTagsId_idx" ON public."CrmTaskTagsTenant3" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant3_TaskTagsId_idx";
       public            postgres    false    423    6685    423                       1259    18168    idx_crmtask_noteid    INDEX     Q   CREATE INDEX idx_crmtask_noteid ON ONLY public."CrmTask" USING btree ("TaskId");
 &   DROP INDEX public.idx_crmtask_noteid;
       public            postgres    false    413            -           1259    18169    CrmTaskTenant100_TaskId_idx    INDEX     `   CREATE INDEX "CrmTaskTenant100_TaskId_idx" ON public."CrmTaskTenant100" USING btree ("TaskId");
 1   DROP INDEX public."CrmTaskTenant100_TaskId_idx";
       public            postgres    false    426    426    6677            *           1259    18170    CrmTaskTenant1_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant1_TaskId_idx" ON public."CrmTaskTenant1" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant1_TaskId_idx";
       public            postgres    false    425    425    6677            0           1259    18171    CrmTaskTenant2_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant2_TaskId_idx" ON public."CrmTaskTenant2" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant2_TaskId_idx";
       public            postgres    false    427    6677    427            3           1259    18172    CrmTaskTenant3_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant3_TaskId_idx" ON public."CrmTaskTenant3" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant3_TaskId_idx";
       public            postgres    false    428    428    6677            ;           1259    18173    idx_crmteammember_teammemberid    INDEX     i   CREATE INDEX idx_crmteammember_teammemberid ON ONLY public."CrmTeamMember" USING btree ("TeamMemberId");
 2   DROP INDEX public.idx_crmteammember_teammemberid;
       public            postgres    false    430            ?           1259    18174 '   CrmTeamMemberTenant100_TeamMemberId_idx    INDEX     x   CREATE INDEX "CrmTeamMemberTenant100_TeamMemberId_idx" ON public."CrmTeamMemberTenant100" USING btree ("TeamMemberId");
 =   DROP INDEX public."CrmTeamMemberTenant100_TeamMemberId_idx";
       public            postgres    false    433    433    6715            <           1259    18175 %   CrmTeamMemberTenant1_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant1_TeamMemberId_idx" ON public."CrmTeamMemberTenant1" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant1_TeamMemberId_idx";
       public            postgres    false    432    432    6715            B           1259    18176 %   CrmTeamMemberTenant2_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant2_TeamMemberId_idx" ON public."CrmTeamMemberTenant2" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant2_TeamMemberId_idx";
       public            postgres    false    434    6715    434            E           1259    18177 %   CrmTeamMemberTenant3_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant3_TeamMemberId_idx" ON public."CrmTeamMemberTenant3" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant3_TeamMemberId_idx";
       public            postgres    false    6715    435    435            8           1259    18178    idx_crmteam_teamid    INDEX     Q   CREATE INDEX idx_crmteam_teamid ON ONLY public."CrmTeam" USING btree ("TeamId");
 &   DROP INDEX public.idx_crmteam_teamid;
       public            postgres    false    429            K           1259    18179    CrmTeamTenant100_TeamId_idx    INDEX     `   CREATE INDEX "CrmTeamTenant100_TeamId_idx" ON public."CrmTeamTenant100" USING btree ("TeamId");
 1   DROP INDEX public."CrmTeamTenant100_TeamId_idx";
       public            postgres    false    438    6712    438            H           1259    18180    CrmTeamTenant1_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant1_TeamId_idx" ON public."CrmTeamTenant1" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant1_TeamId_idx";
       public            postgres    false    437    437    6712            N           1259    18181    CrmTeamTenant2_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant2_TeamId_idx" ON public."CrmTeamTenant2" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant2_TeamId_idx";
       public            postgres    false    6712    439    439            Q           1259    18182    CrmTeamTenant3_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant3_TeamId_idx" ON public."CrmTeamTenant3" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant3_TeamId_idx";
       public            postgres    false    440    6712    440            V           1259    18183 !   idx_crmuseractivitylog_activityid    INDEX     o   CREATE INDEX idx_crmuseractivitylog_activityid ON ONLY public."CrmUserActivityLog" USING btree ("ActivityId");
 5   DROP INDEX public.idx_crmuseractivitylog_activityid;
       public            postgres    false    441            Z           1259    18184 *   CrmUserActivityLogTenant100_ActivityId_idx    INDEX     ~   CREATE INDEX "CrmUserActivityLogTenant100_ActivityId_idx" ON public."CrmUserActivityLogTenant100" USING btree ("ActivityId");
 @   DROP INDEX public."CrmUserActivityLogTenant100_ActivityId_idx";
       public            postgres    false    6742    444    444            W           1259    18185 (   CrmUserActivityLogTenant1_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant1_ActivityId_idx" ON public."CrmUserActivityLogTenant1" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant1_ActivityId_idx";
       public            postgres    false    6742    443    443            ]           1259    18186 (   CrmUserActivityLogTenant2_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant2_ActivityId_idx" ON public."CrmUserActivityLogTenant2" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant2_ActivityId_idx";
       public            postgres    false    6742    445    445            `           1259    18187 (   CrmUserActivityLogTenant3_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant3_ActivityId_idx" ON public."CrmUserActivityLogTenant3" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant3_ActivityId_idx";
       public            postgres    false    446    6742    446            �           1259    18634    idx_NotificationId    INDEX     `   CREATE INDEX "idx_NotificationId" ON ONLY public."Notification" USING btree ("NotificationId");
 (   DROP INDEX public."idx_NotificationId";
       public            postgres    false    470            �           1259    18656 "   Notification100_NotificationId_idx    INDEX     n   CREATE INDEX "Notification100_NotificationId_idx" ON public."Notification100" USING btree ("NotificationId");
 8   DROP INDEX public."Notification100_NotificationId_idx";
       public            postgres    false    472    472    6798            �           1259    18644     Notification1_NotificationId_idx    INDEX     j   CREATE INDEX "Notification1_NotificationId_idx" ON public."Notification1" USING btree ("NotificationId");
 6   DROP INDEX public."Notification1_NotificationId_idx";
       public            postgres    false    471    6798    471            �           1259    18668     Notification2_NotificationId_idx    INDEX     j   CREATE INDEX "Notification2_NotificationId_idx" ON public."Notification2" USING btree ("NotificationId");
 6   DROP INDEX public."Notification2_NotificationId_idx";
       public            postgres    false    473    6798    473            �           1259    18680     Notification3_NotificationId_idx    INDEX     j   CREATE INDEX "Notification3_NotificationId_idx" ON public."Notification3" USING btree ("NotificationId");
 6   DROP INDEX public."Notification3_NotificationId_idx";
       public            postgres    false    474    6798    474            j           1259    18461    idx_TicketId    INDEX     N   CREATE INDEX "idx_TicketId" ON ONLY public."Ticket" USING btree ("TicketId");
 "   DROP INDEX public."idx_TicketId";
       public            postgres    false    452            n           1259    18487    Ticket100_TicketId_idx    INDEX     V   CREATE INDEX "Ticket100_TicketId_idx" ON public."Ticket100" USING btree ("TicketId");
 ,   DROP INDEX public."Ticket100_TicketId_idx";
       public            postgres    false    454    454    6762            k           1259    18473    Ticket1_TicketId_idx    INDEX     R   CREATE INDEX "Ticket1_TicketId_idx" ON public."Ticket1" USING btree ("TicketId");
 *   DROP INDEX public."Ticket1_TicketId_idx";
       public            postgres    false    6762    453    453            q           1259    18501    Ticket2_TicketId_idx    INDEX     R   CREATE INDEX "Ticket2_TicketId_idx" ON public."Ticket2" USING btree ("TicketId");
 *   DROP INDEX public."Ticket2_TicketId_idx";
       public            postgres    false    455    6762    455            t           1259    18515    Ticket3_TicketId_idx    INDEX     R   CREATE INDEX "Ticket3_TicketId_idx" ON public."Ticket3" USING btree ("TicketId");
 *   DROP INDEX public."Ticket3_TicketId_idx";
       public            postgres    false    456    456    6762            �           1259    19062 
   idx_TypeId    INDEX     P   CREATE INDEX "idx_TypeId" ON public."CrmFormFieldTypes" USING btree ("TypeId");
     DROP INDEX public."idx_TypeId";
       public            postgres    false    492                       1259    18188    idx_crmtaskpriority_priorityid    INDEX     d   CREATE INDEX idx_crmtaskpriority_priorityid ON public."CrmTaskPriority" USING btree ("PriorityId");
 2   DROP INDEX public.idx_crmtaskpriority_priorityid;
       public            postgres    false    414            g           1259    18189    idxtenant_priorityid    INDEX     O   CREATE INDEX idxtenant_priorityid ON public."Tenant" USING btree ("TenantId");
 (   DROP INDEX public.idxtenant_priorityid;
       public            postgres    false    449            �           0    0 "   Conversation100_ConversationId_idx    INDEX ATTACH     f   ALTER INDEX public."idx_ConversationId" ATTACH PARTITION public."Conversation100_ConversationId_idx";
          public          postgres    false    6781    6777    460    458            �           0    0    Conversation100_pkey    INDEX ATTACH     U   ALTER INDEX public."Conversation_PK" ATTACH PARTITION public."Conversation100_pkey";
          public          postgres    false    6776    6783    460    6776    460    458            �           0    0     Conversation1_ConversationId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_ConversationId" ATTACH PARTITION public."Conversation1_ConversationId_idx";
          public          postgres    false    6778    6777    459    458            �           0    0    Conversation1_pkey    INDEX ATTACH     S   ALTER INDEX public."Conversation_PK" ATTACH PARTITION public."Conversation1_pkey";
          public          postgres    false    6780    6776    459    6776    459    458            �           0    0     Conversation2_ConversationId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_ConversationId" ATTACH PARTITION public."Conversation2_ConversationId_idx";
          public          postgres    false    6784    6777    461    458            �           0    0    Conversation2_pkey    INDEX ATTACH     S   ALTER INDEX public."Conversation_PK" ATTACH PARTITION public."Conversation2_pkey";
          public          postgres    false    6776    6786    461    6776    461    458            �           0    0     Conversation3_ConversationId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_ConversationId" ATTACH PARTITION public."Conversation3_ConversationId_idx";
          public          postgres    false    6787    6777    462    458            �           0    0    Conversation3_pkey    INDEX ATTACH     S   ALTER INDEX public."Conversation_PK" ATTACH PARTITION public."Conversation3_pkey";
          public          postgres    false    6776    6789    462    6776    462    458            �           0    0    CrmAdAccount100_AccountId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount100_AccountId_idx";
          public          postgres    false    6306    6302    263    260            �           0    0    CrmAdAccount100_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount100_pkey";
          public          postgres    false    6308    6301    263    6301    263    260            �           0    0    CrmAdAccount1_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount1_AccountId_idx";
          public          postgres    false    6303    6302    262    260            �           0    0    CrmAdAccount1_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount1_pkey";
          public          postgres    false    262    6305    6301    6301    262    260            �           0    0    CrmAdAccount2_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount2_AccountId_idx";
          public          postgres    false    6309    6302    264    260            �           0    0    CrmAdAccount2_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount2_pkey";
          public          postgres    false    264    6301    6311    6301    264    260            �           0    0    CrmAdAccount3_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount3_AccountId_idx";
          public          postgres    false    6312    6302    265    260            �           0    0    CrmAdAccount3_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount3_pkey";
          public          postgres    false    6314    265    6301    6301    265    260            �           0    0 &   CrmCalenderEventsTenant100_EventId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant100_EventId_idx";
          public          postgres    false    6323    6319    271    268            �           0    0    CrmCalenderEventsTenant100_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant100_pkey";
          public          postgres    false    271    6325    6318    6318    271    268            �           0    0 $   CrmCalenderEventsTenant1_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant1_EventId_idx";
          public          postgres    false    6320    6319    270    268            �           0    0    CrmCalenderEventsTenant1_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant1_pkey";
          public          postgres    false    270    6318    6322    6318    270    268            �           0    0 $   CrmCalenderEventsTenant2_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant2_EventId_idx";
          public          postgres    false    6326    6319    272    268            �           0    0    CrmCalenderEventsTenant2_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant2_pkey";
          public          postgres    false    272    6328    6318    6318    272    268            �           0    0 $   CrmCalenderEventsTenant3_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant3_EventId_idx";
          public          postgres    false    6329    6319    273    268            �           0    0    CrmCalenderEventsTenant3_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant3_pkey";
          public          postgres    false    6318    6331    273    6318    273    268            �           0    0    CrmCall100_CallId_idx    INDEX ATTACH     Q   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall100_CallId_idx";
          public          postgres    false    6338    6334    277    274            �           0    0    CrmCall100_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall100_pkey";
          public          postgres    false    6340    6333    277    6333    277    274            �           0    0    CrmCall1_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall1_CallId_idx";
          public          postgres    false    6335    6334    276    274            �           0    0    CrmCall1_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall1_pkey";
          public          postgres    false    6337    6333    276    6333    276    274            �           0    0    CrmCall2_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall2_CallId_idx";
          public          postgres    false    6341    6334    278    274            �           0    0    CrmCall2_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall2_pkey";
          public          postgres    false    278    6343    6333    6333    278    274            �           0    0    CrmCall3_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall3_CallId_idx";
          public          postgres    false    6344    6334    279    274            �           0    0    CrmCall3_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall3_pkey";
          public          postgres    false    6333    279    6346    6333    279    274            �           0    0    CrmCampaign100_CampaignId_idx    INDEX ATTACH     ]   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign100_CampaignId_idx";
          public          postgres    false    6353    6349    282    280            �           0    0    CrmCampaign100_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign100_pkey";
          public          postgres    false    6348    282    6355    6348    282    280            �           0    0    CrmCampaign1_CampaignId_idx    INDEX ATTACH     [   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign1_CampaignId_idx";
          public          postgres    false    6350    6349    281    280            �           0    0    CrmCampaign1_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign1_pkey";
          public          postgres    false    6352    6348    281    6348    281    280            �           0    0    CrmCampaign2_CampaignId_idx    INDEX ATTACH     [   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign2_CampaignId_idx";
          public          postgres    false    6356    6349    283    280            �           0    0    CrmCampaign2_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign2_pkey";
          public          postgres    false    283    6348    6358    6348    283    280            �           0    0    CrmCampaign3_CampaignId_idx    INDEX ATTACH     [   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign3_CampaignId_idx";
          public          postgres    false    6359    6349    284    280            �           0    0    CrmCampaign3_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign3_pkey";
          public          postgres    false    6361    284    6348    6348    284    280            �           0    0 -   CrmCompanyActivityLogTenant100_ActivityId_idx    INDEX ATTACH     �   ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant100_ActivityId_idx";
          public          postgres    false    6371    6367    289    286            �           0    0 #   CrmCompanyActivityLogTenant100_pkey    INDEX ATTACH     o   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant100_pkey";
          public          postgres    false    289    6373    6366    6366    289    286            �           0    0 +   CrmCompanyActivityLogTenant1_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant1_ActivityId_idx";
          public          postgres    false    6368    6367    288    286            �           0    0 !   CrmCompanyActivityLogTenant1_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant1_pkey";
          public          postgres    false    288    6370    6366    6366    288    286            �           0    0 +   CrmCompanyActivityLogTenant2_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant2_ActivityId_idx";
          public          postgres    false    6374    6367    290    286            �           0    0 !   CrmCompanyActivityLogTenant2_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant2_pkey";
          public          postgres    false    290    6366    6376    6366    290    286            �           0    0 +   CrmCompanyActivityLogTenant3_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant3_ActivityId_idx";
          public          postgres    false    6377    6367    291    286            �           0    0 !   CrmCompanyActivityLogTenant3_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant3_pkey";
          public          postgres    false    6379    291    6366    6366    291    286            �           0    0 '   CrmCompanyMemberTenant100_CompanyId_idx    INDEX ATTACH     u   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant100_CompanyId_idx";
          public          postgres    false    6388    6382    295    292            �           0    0 &   CrmCompanyMemberTenant100_MemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant100_MemberId_idx";
          public          postgres    false    6389    6383    295    292            �           0    0    CrmCompanyMemberTenant100_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant100_pkey";
          public          postgres    false    6391    6381    295    6381    295    292            �           0    0 %   CrmCompanyMemberTenant1_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant1_CompanyId_idx";
          public          postgres    false    6384    6382    294    292            �           0    0 $   CrmCompanyMemberTenant1_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant1_MemberId_idx";
          public          postgres    false    6385    6383    294    292            �           0    0    CrmCompanyMemberTenant1_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant1_pkey";
          public          postgres    false    294    6387    6381    6381    294    292            �           0    0 %   CrmCompanyMemberTenant2_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant2_CompanyId_idx";
          public          postgres    false    6392    6382    296    292            �           0    0 $   CrmCompanyMemberTenant2_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant2_MemberId_idx";
          public          postgres    false    6393    6383    296    292            �           0    0    CrmCompanyMemberTenant2_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant2_pkey";
          public          postgres    false    6395    6381    296    6381    296    292            �           0    0 %   CrmCompanyMemberTenant3_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant3_CompanyId_idx";
          public          postgres    false    6396    6382    297    292            �           0    0 $   CrmCompanyMemberTenant3_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant3_MemberId_idx";
          public          postgres    false    6397    6383    297    292            �           0    0    CrmCompanyMemberTenant3_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant3_pkey";
          public          postgres    false    6381    6399    297    6381    297    292            �           0    0 !   CrmCompanyTenant100_CompanyId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant100_CompanyId_idx";
          public          postgres    false    6403    6364    300    285            �           0    0    CrmCompanyTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant100_pkey";
          public          postgres    false    6405    6363    300    6363    300    285            �           0    0    CrmCompanyTenant1_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant1_CompanyId_idx";
          public          postgres    false    6400    6364    299    285            �           0    0    CrmCompanyTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant1_pkey";
          public          postgres    false    299    6402    6363    6363    299    285            �           0    0    CrmCompanyTenant2_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant2_CompanyId_idx";
          public          postgres    false    6406    6364    301    285            �           0    0    CrmCompanyTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant2_pkey";
          public          postgres    false    301    6408    6363    6363    301    285            �           0    0    CrmCompanyTenant3_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant3_CompanyId_idx";
          public          postgres    false    6409    6364    302    285            �           0    0    CrmCompanyTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant3_pkey";
          public          postgres    false    6411    6363    302    6363    302    285            �           0    0 "   CrmCustomListsTenant100_ListId_idx    INDEX ATTACH     ^   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant100_ListId_idx";
          public          postgres    false    6418    6414    306    303            �           0    0    CrmCustomListsTenant100_pkey    INDEX ATTACH     a   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant100_pkey";
          public          postgres    false    6420    306    6413    6413    306    303            �           0    0     CrmCustomListsTenant1_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant1_ListId_idx";
          public          postgres    false    6415    6414    305    303            �           0    0    CrmCustomListsTenant1_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant1_pkey";
          public          postgres    false    6417    305    6413    6413    305    303            �           0    0     CrmCustomListsTenant2_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant2_ListId_idx";
          public          postgres    false    6421    6414    307    303            �           0    0    CrmCustomListsTenant2_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant2_pkey";
          public          postgres    false    6413    6423    307    6413    307    303            �           0    0     CrmCustomListsTenant3_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant3_ListId_idx";
          public          postgres    false    6424    6414    308    303            �           0    0    CrmCustomListsTenant3_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant3_pkey";
          public          postgres    false    6426    308    6413    6413    308    303                       0    0    CrmEmail100_EmailId_idx    INDEX ATTACH     T   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail100_EmailId_idx";
          public          postgres    false    6433    6429    312    309                       0    0    CrmEmail100_pkey    INDEX ATTACH     O   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail100_pkey";
          public          postgres    false    312    6428    6435    6428    312    309            �           0    0    CrmEmail1_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail1_EmailId_idx";
          public          postgres    false    6430    6429    311    309                        0    0    CrmEmail1_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail1_pkey";
          public          postgres    false    311    6428    6432    6428    311    309                       0    0    CrmEmail2_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail2_EmailId_idx";
          public          postgres    false    6436    6429    313    309                       0    0    CrmEmail2_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail2_pkey";
          public          postgres    false    6438    6428    313    6428    313    309                       0    0    CrmEmail3_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail3_EmailId_idx";
          public          postgres    false    6439    6429    314    309                       0    0    CrmEmail3_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail3_pkey";
          public          postgres    false    314    6428    6441    6428    314    309            �           0    0    CrmForm100_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmForm_pkey" ATTACH PARTITION public."CrmForm100_pkey";
          public          postgres    false    6839    490    6831    6831    490    486            �           0    0    CrmForm1_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmForm_pkey" ATTACH PARTITION public."CrmForm1_pkey";
          public          postgres    false    6833    487    6831    6831    487    486            �           0    0    CrmForm2_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmForm_pkey" ATTACH PARTITION public."CrmForm2_pkey";
          public          postgres    false    6831    6835    488    6831    488    486            �           0    0    CrmForm3_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmForm_pkey" ATTACH PARTITION public."CrmForm3_pkey";
          public          postgres    false    6831    489    6837    6831    489    486            	           0    0    CrmFormFields100_FieldId_idx    INDEX ATTACH     Y   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields100_FieldId_idx";
          public          postgres    false    6448    6444    318    315            
           0    0    CrmFormFields100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields100_pkey";
          public          postgres    false    6443    6450    318    6443    318    315                       0    0    CrmFormFields1_FieldId_idx    INDEX ATTACH     W   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields1_FieldId_idx";
          public          postgres    false    6445    6444    317    315                       0    0    CrmFormFields1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields1_pkey";
          public          postgres    false    6447    6443    317    6443    317    315                       0    0    CrmFormFields2_FieldId_idx    INDEX ATTACH     W   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields2_FieldId_idx";
          public          postgres    false    6451    6444    319    315                       0    0    CrmFormFields2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields2_pkey";
          public          postgres    false    6453    6443    319    6443    319    315                       0    0    CrmFormFields3_FieldId_idx    INDEX ATTACH     W   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields3_FieldId_idx";
          public          postgres    false    6454    6444    320    315                       0    0    CrmFormFields3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields3_pkey";
          public          postgres    false    6443    320    6456    6443    320    315                       0    0    CrmFormResults100_ResultId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults100_ResultId_idx";
          public          postgres    false    6463    6459    324    321                       0    0    CrmFormResults100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults100_pkey";
          public          postgres    false    6465    6458    324    6458    324    321                       0    0    CrmFormResults1_ResultId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults1_ResultId_idx";
          public          postgres    false    6460    6459    323    321                       0    0    CrmFormResults1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults1_pkey";
          public          postgres    false    6462    6458    323    6458    323    321                       0    0    CrmFormResults2_ResultId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults2_ResultId_idx";
          public          postgres    false    6466    6459    325    321                       0    0    CrmFormResults2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults2_pkey";
          public          postgres    false    6468    6458    325    6458    325    321                       0    0    CrmFormResults3_ResultId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults3_ResultId_idx";
          public          postgres    false    6469    6459    326    321                       0    0    CrmFormResults3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults3_pkey";
          public          postgres    false    6471    6458    326    6458    326    321            �           0    0    CrmForms100_FormId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_FormId" ATTACH PARTITION public."CrmForms100_FormId_idx";
          public          postgres    false    6817    6813    478    476            �           0    0    CrmForms100_pkey    INDEX ATTACH     O   ALTER INDEX public."CrmForms_pkey" ATTACH PARTITION public."CrmForms100_pkey";
          public          postgres    false    6812    6819    478    6812    478    476            �           0    0    CrmForms1_FormId_idx    INDEX ATTACH     P   ALTER INDEX public."idx_FormId" ATTACH PARTITION public."CrmForms1_FormId_idx";
          public          postgres    false    6814    6813    477    476            �           0    0    CrmForms1_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmForms_pkey" ATTACH PARTITION public."CrmForms1_pkey";
          public          postgres    false    477    6816    6812    6812    477    476            �           0    0    CrmForms2_FormId_idx    INDEX ATTACH     P   ALTER INDEX public."idx_FormId" ATTACH PARTITION public."CrmForms2_FormId_idx";
          public          postgres    false    6820    6813    479    476            �           0    0    CrmForms2_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmForms_pkey" ATTACH PARTITION public."CrmForms2_pkey";
          public          postgres    false    6822    479    6812    6812    479    476            �           0    0    CrmForms3_FormId_idx    INDEX ATTACH     P   ALTER INDEX public."idx_FormId" ATTACH PARTITION public."CrmForms3_FormId_idx";
          public          postgres    false    6823    6813    480    476            �           0    0    CrmForms3_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmForms_pkey" ATTACH PARTITION public."CrmForms3_pkey";
          public          postgres    false    6825    6812    480    6812    480    476                       0    0 #   CrmIndustryTenant100_IndustryId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant100_IndustryId_idx";
          public          postgres    false    6480    6476    332    329                       0    0    CrmIndustryTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant100_pkey";
          public          postgres    false    332    6482    6475    6475    332    329                       0    0 !   CrmIndustryTenant1_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant1_IndustryId_idx";
          public          postgres    false    6477    6476    331    329                       0    0    CrmIndustryTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant1_pkey";
          public          postgres    false    6475    6479    331    6475    331    329                       0    0 !   CrmIndustryTenant2_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant2_IndustryId_idx";
          public          postgres    false    6483    6476    333    329                       0    0    CrmIndustryTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant2_pkey";
          public          postgres    false    333    6485    6475    6475    333    329                       0    0 !   CrmIndustryTenant3_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant3_IndustryId_idx";
          public          postgres    false    6486    6476    334    329                       0    0    CrmIndustryTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant3_pkey";
          public          postgres    false    334    6475    6488    6475    334    329            !           0    0 *   CrmLeadActivityLogTenant100_ActivityId_idx    INDEX ATTACH     {   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant100_ActivityId_idx";
          public          postgres    false    6498    6494    339    336            "           0    0     CrmLeadActivityLogTenant100_pkey    INDEX ATTACH     i   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant100_pkey";
          public          postgres    false    6493    339    6500    6493    339    336                       0    0 (   CrmLeadActivityLogTenant1_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant1_ActivityId_idx";
          public          postgres    false    6495    6494    338    336                        0    0    CrmLeadActivityLogTenant1_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant1_pkey";
          public          postgres    false    6497    338    6493    6493    338    336            #           0    0 (   CrmLeadActivityLogTenant2_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant2_ActivityId_idx";
          public          postgres    false    6501    6494    340    336            $           0    0    CrmLeadActivityLogTenant2_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant2_pkey";
          public          postgres    false    340    6503    6493    6493    340    336            %           0    0 (   CrmLeadActivityLogTenant3_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant3_ActivityId_idx";
          public          postgres    false    6504    6494    341    336            &           0    0    CrmLeadActivityLogTenant3_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant3_pkey";
          public          postgres    false    341    6493    6506    6493    341    336            )           0    0 #   CrmLeadSourceTenant100_SourceId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant100_SourceId_idx";
          public          postgres    false    6513    6509    345    342            *           0    0    CrmLeadSourceTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant100_pkey";
          public          postgres    false    345    6515    6508    6508    345    342            '           0    0 !   CrmLeadSourceTenant1_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant1_SourceId_idx";
          public          postgres    false    6510    6509    344    342            (           0    0    CrmLeadSourceTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant1_pkey";
          public          postgres    false    344    6512    6508    6508    344    342            +           0    0 !   CrmLeadSourceTenant2_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant2_SourceId_idx";
          public          postgres    false    6516    6509    346    342            ,           0    0    CrmLeadSourceTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant2_pkey";
          public          postgres    false    6518    6508    346    6508    346    342            -           0    0 !   CrmLeadSourceTenant3_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant3_SourceId_idx";
          public          postgres    false    6519    6509    347    342            .           0    0    CrmLeadSourceTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant3_pkey";
          public          postgres    false    6508    347    6521    6508    347    342            1           0    0 #   CrmLeadStatusTenant100_StatusId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant100_StatusId_idx";
          public          postgres    false    6528    6524    351    348            2           0    0    CrmLeadStatusTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant100_pkey";
          public          postgres    false    6530    6523    351    6523    351    348            /           0    0 !   CrmLeadStatusTenant1_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant1_StatusId_idx";
          public          postgres    false    6525    6524    350    348            0           0    0    CrmLeadStatusTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant1_pkey";
          public          postgres    false    350    6523    6527    6523    350    348            3           0    0 !   CrmLeadStatusTenant2_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant2_StatusId_idx";
          public          postgres    false    6531    6524    352    348            4           0    0    CrmLeadStatusTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant2_pkey";
          public          postgres    false    6533    6523    352    6523    352    348            5           0    0 !   CrmLeadStatusTenant3_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant3_StatusId_idx";
          public          postgres    false    6534    6524    353    348            6           0    0    CrmLeadStatusTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant3_pkey";
          public          postgres    false    353    6536    6523    6523    353    348            9           0    0    CrmLeadTenant100_LeadId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant100_LeadId_idx";
          public          postgres    false    6540    6491    356    335            :           0    0    CrmLeadTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant100_pkey";
          public          postgres    false    6542    356    6490    6490    356    335            7           0    0    CrmLeadTenant1_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant1_LeadId_idx";
          public          postgres    false    6537    6491    355    335            8           0    0    CrmLeadTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant1_pkey";
          public          postgres    false    6539    6490    355    6490    355    335            ;           0    0    CrmLeadTenant2_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant2_LeadId_idx";
          public          postgres    false    6543    6491    357    335            <           0    0    CrmLeadTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant2_pkey";
          public          postgres    false    357    6545    6490    6490    357    335            =           0    0    CrmLeadTenant3_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant3_LeadId_idx";
          public          postgres    false    6546    6491    358    335            >           0    0    CrmLeadTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant3_pkey";
          public          postgres    false    6548    358    6490    6490    358    335            A           0    0    CrmMeeting100_MeetingId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting100_MeetingId_idx";
          public          postgres    false    6555    6551    362    359            B           0    0    CrmMeeting100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting100_pkey";
          public          postgres    false    362    6550    6557    6550    362    359            ?           0    0    CrmMeeting1_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting1_MeetingId_idx";
          public          postgres    false    6552    6551    361    359            @           0    0    CrmMeeting1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting1_pkey";
          public          postgres    false    6550    6554    361    6550    361    359            C           0    0    CrmMeeting2_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting2_MeetingId_idx";
          public          postgres    false    6558    6551    363    359            D           0    0    CrmMeeting2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting2_pkey";
          public          postgres    false    363    6550    6560    6550    363    359            E           0    0    CrmMeeting3_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting3_MeetingId_idx";
          public          postgres    false    6561    6551    364    359            F           0    0    CrmMeeting3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting3_pkey";
          public          postgres    false    6550    364    6563    6550    364    359            I           0    0 #   CrmNoteTagsTenant100_NoteTagsId_idx    INDEX ATTACH     c   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant100_NoteTagsId_idx";
          public          postgres    false    6573    6569    369    366            J           0    0    CrmNoteTagsTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant100_pkey";
          public          postgres    false    369    6575    6568    6568    369    366            G           0    0 !   CrmNoteTagsTenant1_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant1_NoteTagsId_idx";
          public          postgres    false    6570    6569    368    366            H           0    0    CrmNoteTagsTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant1_pkey";
          public          postgres    false    368    6572    6568    6568    368    366            K           0    0 !   CrmNoteTagsTenant2_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant2_NoteTagsId_idx";
          public          postgres    false    6576    6569    370    366            L           0    0    CrmNoteTagsTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant2_pkey";
          public          postgres    false    370    6578    6568    6568    370    366            M           0    0 !   CrmNoteTagsTenant3_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant3_NoteTagsId_idx";
          public          postgres    false    6579    6569    371    366            N           0    0    CrmNoteTagsTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant3_pkey";
          public          postgres    false    6568    371    6581    6568    371    366            Q           0    0 $   CrmNoteTasksTenant100_NoteTaskId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant100_NoteTaskId_idx";
          public          postgres    false    6588    6584    375    372            R           0    0    CrmNoteTasksTenant100_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant100_pkey";
          public          postgres    false    375    6583    6590    6583    375    372            O           0    0 "   CrmNoteTasksTenant1_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant1_NoteTaskId_idx";
          public          postgres    false    6585    6584    374    372            P           0    0    CrmNoteTasksTenant1_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant1_pkey";
          public          postgres    false    374    6583    6587    6583    374    372            S           0    0 "   CrmNoteTasksTenant2_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant2_NoteTaskId_idx";
          public          postgres    false    6591    6584    376    372            T           0    0    CrmNoteTasksTenant2_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant2_pkey";
          public          postgres    false    376    6583    6593    6583    376    372            U           0    0 "   CrmNoteTasksTenant3_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant3_NoteTaskId_idx";
          public          postgres    false    6594    6584    377    372            V           0    0    CrmNoteTasksTenant3_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant3_pkey";
          public          postgres    false    6583    6596    377    6583    377    372            Y           0    0    CrmNoteTenant100_NoteId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant100_NoteId_idx";
          public          postgres    false    6600    6566    380    365            Z           0    0    CrmNoteTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant100_pkey";
          public          postgres    false    380    6565    6602    6565    380    365            W           0    0    CrmNoteTenant1_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant1_NoteId_idx";
          public          postgres    false    6597    6566    379    365            X           0    0    CrmNoteTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant1_pkey";
          public          postgres    false    379    6565    6599    6565    379    365            [           0    0    CrmNoteTenant2_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant2_NoteId_idx";
          public          postgres    false    6603    6566    381    365            \           0    0    CrmNoteTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant2_pkey";
          public          postgres    false    6565    6605    381    6565    381    365            ]           0    0    CrmNoteTenant3_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant3_NoteId_idx";
          public          postgres    false    6606    6566    382    365            ^           0    0    CrmNoteTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant3_pkey";
          public          postgres    false    382    6565    6608    6565    382    365            a           0    0 #   CrmOpportunity100_OpportunityId_idx    INDEX ATTACH     f   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity100_OpportunityId_idx";
          public          postgres    false    6615    6611    386    383            b           0    0    CrmOpportunity100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity100_pkey";
          public          postgres    false    386    6610    6617    6610    386    383            _           0    0 !   CrmOpportunity1_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity1_OpportunityId_idx";
          public          postgres    false    6612    6611    385    383            `           0    0    CrmOpportunity1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity1_pkey";
          public          postgres    false    6610    385    6614    6610    385    383            c           0    0 !   CrmOpportunity2_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity2_OpportunityId_idx";
          public          postgres    false    6618    6611    387    383            d           0    0    CrmOpportunity2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity2_pkey";
          public          postgres    false    6620    6610    387    6610    387    383            e           0    0 !   CrmOpportunity3_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity3_OpportunityId_idx";
          public          postgres    false    6621    6611    388    383            f           0    0    CrmOpportunity3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity3_pkey";
          public          postgres    false    388    6623    6610    6610    388    383            i           0    0 !   CrmProductTenant100_ProductId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant100_ProductId_idx";
          public          postgres    false    6632    6628    394    391            j           0    0    CrmProductTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant100_pkey";
          public          postgres    false    6634    394    6627    6627    394    391            g           0    0    CrmProductTenant1_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant1_ProductId_idx";
          public          postgres    false    6629    6628    393    391            h           0    0    CrmProductTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant1_pkey";
          public          postgres    false    393    6631    6627    6627    393    391            k           0    0    CrmProductTenant2_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant2_ProductId_idx";
          public          postgres    false    6635    6628    395    391            l           0    0    CrmProductTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant2_pkey";
          public          postgres    false    6627    395    6637    6627    395    391            m           0    0    CrmProductTenant3_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant3_ProductId_idx";
          public          postgres    false    6638    6628    396    391            n           0    0    CrmProductTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant3_pkey";
          public          postgres    false    6627    6640    396    6627    396    391            q           0    0 !   CrmTagUsedTenant100_TagUsedId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant100_TagUsedId_idx";
          public          postgres    false    6651    6647    404    401            r           0    0    CrmTagUsedTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant100_pkey";
          public          postgres    false    6653    6646    404    6646    404    401            o           0    0    CrmTagUsedTenant1_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant1_TagUsedId_idx";
          public          postgres    false    6648    6647    403    401            p           0    0    CrmTagUsedTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant1_pkey";
          public          postgres    false    6646    403    6650    6646    403    401            s           0    0    CrmTagUsedTenant2_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant2_TagUsedId_idx";
          public          postgres    false    6654    6647    405    401            t           0    0    CrmTagUsedTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant2_pkey";
          public          postgres    false    405    6656    6646    6646    405    401            u           0    0    CrmTagUsedTenant3_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant3_TagUsedId_idx";
          public          postgres    false    6657    6647    406    401            v           0    0    CrmTagUsedTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant3_pkey";
          public          postgres    false    406    6659    6646    6646    406    401            y           0    0    CrmTagsTenant100_TagId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant100_TagId_idx";
          public          postgres    false    6666    6662    410    407            z           0    0    CrmTagsTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant100_pkey";
          public          postgres    false    410    6661    6668    6661    410    407            w           0    0    CrmTagsTenant1_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant1_TagId_idx";
          public          postgres    false    6663    6662    409    407            x           0    0    CrmTagsTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant1_pkey";
          public          postgres    false    6665    409    6661    6661    409    407            {           0    0    CrmTagsTenant2_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant2_TagId_idx";
          public          postgres    false    6669    6662    411    407            |           0    0    CrmTagsTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant2_pkey";
          public          postgres    false    411    6661    6671    6661    411    407            }           0    0    CrmTagsTenant3_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant3_TagId_idx";
          public          postgres    false    6672    6662    412    407            ~           0    0    CrmTagsTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant3_pkey";
          public          postgres    false    6661    6674    412    6661    412    407            �           0    0 #   CrmTaskTagsTenant100_TaskTagsId_idx    INDEX ATTACH     c   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant100_TaskTagsId_idx";
          public          postgres    false    6689    6685    421    418            �           0    0    CrmTaskTagsTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant100_pkey";
          public          postgres    false    6691    421    6684    6684    421    418                       0    0 !   CrmTaskTagsTenant1_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant1_TaskTagsId_idx";
          public          postgres    false    6686    6685    420    418            �           0    0    CrmTaskTagsTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant1_pkey";
          public          postgres    false    420    6688    6684    6684    420    418            �           0    0 !   CrmTaskTagsTenant2_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant2_TaskTagsId_idx";
          public          postgres    false    6692    6685    422    418            �           0    0    CrmTaskTagsTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant2_pkey";
          public          postgres    false    6694    422    6684    6684    422    418            �           0    0 !   CrmTaskTagsTenant3_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant3_TaskTagsId_idx";
          public          postgres    false    6695    6685    423    418            �           0    0    CrmTaskTagsTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant3_pkey";
          public          postgres    false    423    6684    6697    6684    423    418            �           0    0    CrmTaskTenant100_TaskId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant100_TaskId_idx";
          public          postgres    false    6701    6677    426    413            �           0    0    CrmTaskTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant100_pkey";
          public          postgres    false    6676    6703    426    6676    426    413            �           0    0    CrmTaskTenant1_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant1_TaskId_idx";
          public          postgres    false    6698    6677    425    413            �           0    0    CrmTaskTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant1_pkey";
          public          postgres    false    6676    6700    425    6676    425    413            �           0    0    CrmTaskTenant2_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant2_TaskId_idx";
          public          postgres    false    6704    6677    427    413            �           0    0    CrmTaskTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant2_pkey";
          public          postgres    false    427    6706    6676    6676    427    413            �           0    0    CrmTaskTenant3_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant3_TaskId_idx";
          public          postgres    false    6707    6677    428    413            �           0    0    CrmTaskTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant3_pkey";
          public          postgres    false    6676    428    6709    6676    428    413            �           0    0 '   CrmTeamMemberTenant100_TeamMemberId_idx    INDEX ATTACH     u   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant100_TeamMemberId_idx";
          public          postgres    false    6719    6715    433    430            �           0    0    CrmTeamMemberTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant100_pkey";
          public          postgres    false    6721    433    6714    6714    433    430            �           0    0 %   CrmTeamMemberTenant1_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant1_TeamMemberId_idx";
          public          postgres    false    6716    6715    432    430            �           0    0    CrmTeamMemberTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant1_pkey";
          public          postgres    false    432    6718    6714    6714    432    430            �           0    0 %   CrmTeamMemberTenant2_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant2_TeamMemberId_idx";
          public          postgres    false    6722    6715    434    430            �           0    0    CrmTeamMemberTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant2_pkey";
          public          postgres    false    6724    434    6714    6714    434    430            �           0    0 %   CrmTeamMemberTenant3_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant3_TeamMemberId_idx";
          public          postgres    false    6725    6715    435    430            �           0    0    CrmTeamMemberTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant3_pkey";
          public          postgres    false    6714    435    6727    6714    435    430            �           0    0    CrmTeamTenant100_TeamId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant100_TeamId_idx";
          public          postgres    false    6731    6712    438    429            �           0    0    CrmTeamTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant100_pkey";
          public          postgres    false    6733    6711    438    6711    438    429            �           0    0    CrmTeamTenant1_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant1_TeamId_idx";
          public          postgres    false    6728    6712    437    429            �           0    0    CrmTeamTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant1_pkey";
          public          postgres    false    437    6730    6711    6711    437    429            �           0    0    CrmTeamTenant2_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant2_TeamId_idx";
          public          postgres    false    6734    6712    439    429            �           0    0    CrmTeamTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant2_pkey";
          public          postgres    false    439    6736    6711    6711    439    429            �           0    0    CrmTeamTenant3_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant3_TeamId_idx";
          public          postgres    false    6737    6712    440    429            �           0    0    CrmTeamTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant3_pkey";
          public          postgres    false    440    6739    6711    6711    440    429            �           0    0 *   CrmUserActivityLogTenant100_ActivityId_idx    INDEX ATTACH     {   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant100_ActivityId_idx";
          public          postgres    false    6746    6742    444    441            �           0    0     CrmUserActivityLogTenant100_pkey    INDEX ATTACH     i   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant100_pkey";
          public          postgres    false    6748    6741    444    6741    444    441            �           0    0 (   CrmUserActivityLogTenant1_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant1_ActivityId_idx";
          public          postgres    false    6743    6742    443    441            �           0    0    CrmUserActivityLogTenant1_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant1_pkey";
          public          postgres    false    443    6745    6741    6741    443    441            �           0    0 (   CrmUserActivityLogTenant2_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant2_ActivityId_idx";
          public          postgres    false    6749    6742    445    441            �           0    0    CrmUserActivityLogTenant2_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant2_pkey";
          public          postgres    false    445    6741    6751    6741    445    441            �           0    0 (   CrmUserActivityLogTenant3_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant3_ActivityId_idx";
          public          postgres    false    6752    6742    446    441            �           0    0    CrmUserActivityLogTenant3_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant3_pkey";
          public          postgres    false    6741    446    6754    6741    446    441            �           0    0 "   Notification100_NotificationId_idx    INDEX ATTACH     f   ALTER INDEX public."idx_NotificationId" ATTACH PARTITION public."Notification100_NotificationId_idx";
          public          postgres    false    6802    6798    472    470            �           0    0    Notification100_pkey    INDEX ATTACH     W   ALTER INDEX public."Notification_pkey" ATTACH PARTITION public."Notification100_pkey";
          public          postgres    false    6804    6797    472    6797    472    470            �           0    0     Notification1_NotificationId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_NotificationId" ATTACH PARTITION public."Notification1_NotificationId_idx";
          public          postgres    false    6799    6798    471    470            �           0    0    Notification1_pkey    INDEX ATTACH     U   ALTER INDEX public."Notification_pkey" ATTACH PARTITION public."Notification1_pkey";
          public          postgres    false    6801    471    6797    6797    471    470            �           0    0     Notification2_NotificationId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_NotificationId" ATTACH PARTITION public."Notification2_NotificationId_idx";
          public          postgres    false    6805    6798    473    470            �           0    0    Notification2_pkey    INDEX ATTACH     U   ALTER INDEX public."Notification_pkey" ATTACH PARTITION public."Notification2_pkey";
          public          postgres    false    6797    6807    473    6797    473    470            �           0    0     Notification3_NotificationId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_NotificationId" ATTACH PARTITION public."Notification3_NotificationId_idx";
          public          postgres    false    6808    6798    474    470            �           0    0    Notification3_pkey    INDEX ATTACH     U   ALTER INDEX public."Notification_pkey" ATTACH PARTITION public."Notification3_pkey";
          public          postgres    false    6810    474    6797    6797    474    470            �           0    0    Ticket100_TicketId_idx    INDEX ATTACH     T   ALTER INDEX public."idx_TicketId" ATTACH PARTITION public."Ticket100_TicketId_idx";
          public          postgres    false    6766    6762    454    452            �           0    0    Ticket100_pkey    INDEX ATTACH     I   ALTER INDEX public."Ticket_PK" ATTACH PARTITION public."Ticket100_pkey";
          public          postgres    false    6761    6768    454    6761    454    452            �           0    0    Ticket1_TicketId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_TicketId" ATTACH PARTITION public."Ticket1_TicketId_idx";
          public          postgres    false    6763    6762    453    452            �           0    0    Ticket1_pkey    INDEX ATTACH     G   ALTER INDEX public."Ticket_PK" ATTACH PARTITION public."Ticket1_pkey";
          public          postgres    false    6761    453    6765    6761    453    452            �           0    0    Ticket2_TicketId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_TicketId" ATTACH PARTITION public."Ticket2_TicketId_idx";
          public          postgres    false    6769    6762    455    452            �           0    0    Ticket2_pkey    INDEX ATTACH     G   ALTER INDEX public."Ticket_PK" ATTACH PARTITION public."Ticket2_pkey";
          public          postgres    false    455    6761    6771    6761    455    452            �           0    0    Ticket3_TicketId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_TicketId" ATTACH PARTITION public."Ticket3_TicketId_idx";
          public          postgres    false    6772    6762    456    452            �           0    0    Ticket3_pkey    INDEX ATTACH     G   ALTER INDEX public."Ticket_PK" ATTACH PARTITION public."Ticket3_pkey";
          public          postgres    false    6761    6774    456    6761    456    452            Z     x��V�r�0}��� ���-M�OI�Iӷ�dY�UDn�_	�%��cF�ힳ��pU6�75�u��Xk���Fh%���U훝,E�Q���ͅA��(�	�0��,�q��(K�~2?c���f�4�,����O���J�����I���5xnW��Ւ�����>����_4Σ��G���<�9��(�%0�@�P�`'���es_� �.�{a�닓&�@�A�Q��v�m��&X���3�МDy�8�8M�	R��e`3���v��d�-E!��Y�2�Yta����cC���Z�m?:c��Z��sT� c6�g�ʤ�d�+@��6k|�;K�1���$�� -*�����_��BB�{�{�\�j��\�o{�[�r����i���C��Z�e!�d����_�9�g\8zvzg9�����aNR3AJh�"�$�qAY�����:-���=�rӌ�1�8K�e�ؒ�Q��� w�DeVNNƅ�p {��	���T���C���8?n[���t�q�G$�Y�<j�Ҩ?��'������޾6�u;[��dn��I|�]
�q��k)(�u%��1�d%l����w��;O��*'b�YQ1�.��3>�>�7BLNchF�8,E��ﳽ��m;y�G9�r��4ŦyƟ+��bz++S����2:���g�t����d��v9��2��0.�!z�4��ps�<U�)��}q>�4��0$ɶ�?pk�z�V��GSh�%y�a�M?�^���>            x������ � �            x������ � �            x������ � �            x������ � �      ]      x������ � �      ^      x������ � �      _      x������ � �      `      x������ � �      a   =   x�3�tN���4�2�t�M���9}SSK2�ҁlN�܂���ļ ϔ3$�8Ȉ���� �[�      d   �  x���O��0��Χ�7���xls��=�R��Y����,l����DZ���R6���'���c�XA@�,׆KaS����S�*)�]�4�_��4(C�^��I��z.${.Y�>F|g}�D����H�V(T�IU�w�H2�u�z�IE�m��Eߥ�>������m�ޗ�Y��5Ȩ�?�
�g!�aV+����\�;]�]�>�i�_�GE��j�q� ͉�f�$8?7�d�,x��9�W�Y(�@kx-b
**��u�U�0:P��k���/��){ڂ�]4b���ѠM�6� w�!2�R?N�j;h{�0�xy�˲����N��-�Q���s��7��x�6�1s���q"��X����LMzz.��[~���緜��3�����*m����7��c�!G̢X?�?Ns�]����y�1�4w�-t����#^�w����.���嵹J���Z�N�8h���,�sv� �<d���.��      e      x������ � �      f      x������ � �      g      x������ � �      i   
  x����J�0�s��K��d�Lr��G/{I���n���cւ���������W�2M�.�~�iQ�'��F)L�q0<6}<�/��T��+bh�i����WF��d$+�Q]�B���l�Ԇ5r��]�.qH|���i/Kþˬ�{���i��崜��z׭��O��$f�O��Y����	A��XB�'K��D�2N�2���D��C��*��^ :�C����R�5UL����Vz�qf�1Z��@Q�t#m��	�ҽ���
�s�      j      x������ � �      k      x������ � �      l      x������ � �      m   r   x��A!�u9����3&.=�l��B�x���=SO^�Y�b��*���|}����/c���I��;�������H������Tw`��͔�H�@8��[�|      n      x������ � �      o      x������ � �      p      x������ � �      r      x������ � �      s      x������ � �      t      x������ � �      u      x������ � �      w      x������ � �      x      x������ � �      y      x������ � �      z      x������ � �      |      x������ � �      }      x������ � �      ~      x������ � �            x������ � �      �   F  x���=k�0�g�W͑��N�s�RhK���l�`p��f(��UB�4S�!���{��9�e�y��!�'sL�M����5�V�K9	rΉ(�D�3x�(Z���кHF̝�l��JJ�+�z	��o��r�s�+��8.��6���������Tzx�b˒�K�`$	@!]�>��ｴ�'�r_�
R��ZM`�:��?
����0��n�:'dR;}��N$@���#�
=[n�G��5��K؆�+$�֫��}�X��!N�|�V�u ����ʶ���}�^�?Z�bj��(h��Z���: �1O|�Z7UU}{j��      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x����J�0���)� �:�L&(=��'A��%�6P�ݥ�|{P=y�7C�}V���?���N�uۍ7穦1o��x���KK �4�A�f����5F�#�����Tzr>�(�eV���5r
F|�(����N�t]O���5�/�ί՗n�u]�đ\�<X�X䇞Z�^!�Q<���sQ��ޕP(Xl:��R�K�Y��D������]�} ��T�      �      x������ � �      �      x������ � �      �      x������ � �         �   x�����0Dg�+��b�n��HLЉ�KK#� H��D�D��۝t�|���byx��'C�O�`�
�j�{˪j[B�]�>r�m ��֓��x�PWN�W��(��Z?/]��c,&"���`�ܟ��.f��~0�ys!�2T&�D�I�&(�7��	�#��2�&Q7z�k�B�$'$����+���v{>            x������ � �            x������ � �            x������ � �          �   x���Ɋ1�s�S�"���зY�z���t��8Y@�ޤ���B�T}i!�-®��~��+B��2N�@�n��i��Y�my���6�B�������	i�My�N\�M��ɠW�����ӠN�N�`�J^����OP
�v�N�A�Q^���%���2�t6\�ZY���:q �6���׏�j{�tT4�FaS��!�H�B�#���i�f��      �   |  x��Խn�0��</`�_`���Ԡ]*e1�I� W@�>~�AU���,`����w<A=�mׇ��-<<6�m�e�����U?,"�r���Xj���L��Z��DIi�KL9�*�4e:�1�1U��!�"��g3�|��;w�{v�p�ڔ�s���esy��~�,9�zd�g��+��v�0>T�t6O��nm8���3�����{���3�xt�[��v�#����x-��GD�$�4�ɂD�,�4ܫ�95s��/)�y,�-���0@�j��`�)�z�������¬��S��e�P��C3ή���5}�_�L�O���M�j �������I�X�pu�p��>�k�A�~��bC��}9��6A�$��f��      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �            x������ � �            x������ � �            x������ � �            x������ � �      �   �   x�E��R�0���S�	H��{$�f����U�Gn��o�3��贻�VZ�����;\�m���M�h�f�T����r���ZcFE;�'�)�X�3X+�x�+�^il9��'��P�+���R�����H�DcC!�Kr�x<d�;�&�c�
~_�$Z��vȬ�JEC����897����;bi3x!�o��$�qRU�/�R�         �   x����
�0Dϛ����l�"B�~A/%��`0%i���i�^��0��7���R��c�Vt������5��1!�kP��a¬�2�+Y�l	a��'0_v|����$G�ڲ��'tK�yԒyR���b�)�7>q	=���_¶6�|�X=e      �   �  x����n�0���S��\H�c;�e���a�n��2���@����8Þ�t���ɏ?iᙏ!N(>pv w�0��3��|�
��M�U�ז\^Q]��M���ʺ=�~��enM^ԙ)�ݽ1wۢ,x{�>����.LEG��%<zFv�!��7�σ�~O���ƛŏ&X���Y�jߑ�#:Y�n5�LMd�,(����ŭ�QTm�)�g/8z�\�B"2O��DDЏ����C�yEwx֦\��ʮ4�����Y٦X˗���\�:<)�іp���9D�^/a�s�)͍�<���N%j8h��n�5�9���,��!��YM��Q��B����D,���]��U��1��¿ŧu��:��А�/��T�����V�����n�����҈      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �         t   x��α�0њ�"}@ᓦ(ҳ��a��B����tH�Q�~���x��|��c -���I��P�$O��6s�/��,L��1?L^-�&smO��Z&K˥�������_-���A�      �   �   x���A�0 ���� �nA75�Fb¥�54)4)�����dΣ������x�d���{7~%�u�T�P������򀺂��+ S�2��-m�'f��K	]x9�eC֙���[4�d7�-}�A���-�����:{7�<�EvM4s�7�B��ل      �      x������ � �      �      x������ � �      �      x������ � �      �   }   x�3��K-�4�4B##c]CC]C###+SK+S=K3cs�?2��5�2�t��+IL.IM
�Ϙ�3�$�(��јh�&����9�i�`}&D�3���/.�M��b���d��#F��� H_@�      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x����n�0Dg�+�4H��$O��C�,����N��~� �X��B�;�s�a�sY�>���y�׭�+��˜�zH�P�pP	hc*��{L��8eoY�b|�d��XH�:��1+�Z)i
�9��(� َ��h �9P8���������S���c�"���K��yͧ�r�֏�V��I�ڤ�m���
9Ĭ��uD��@��N��Y<
Y�����K������/2<"b�'��K�C�u��f1      �      x������ � �      �      x������ � �      �      x������ � �      �   *  x����j�0D��W�^dv��J�s�-��B/�H�\IqB�rZ(i�H4�2oXK����P����x|WۍB�T�>[�b®��L�H&�B≒W,@cE�� ���܍�@�� �I�$�c���z�L��4R����X�	Bc;�Z�P���S�Em�G���ЇDlKo�pe����Ts�`��H�.���i��j��G��s�y��C"��V�ժ��~��]of5��e���S�.g�r�v��|��:� 9 t�zf�mL��P:�Iň�O��E�+>�`�p_u��e�߶M�|V��/      �      x������ � �      �      x������ � �      �      x������ � �      �   P   x����  �3L�� �!�����?B�ۯ� �SZN
�7��՞�6��*�e5b!�C�{t��8]`\� 8
"~	�      �      x������ � �      �      x������ � �      �      x������ � �      �   d   x�̻�0�X����ĳ죈��Ā�!�p���M�F�}�-����5���HH��R���VFs�N���e7�L,ʆh6%��,%��߾h�����      �      x������ � �      �      x������ � �      �      x������ � �      �   e   x��ι�0ј��P��Eʮc�M|�x��.��<}���L���k���cg� oy܉u��Ildb`Q6LfK�^�9��jJo��@��o-��'["v      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�3��K-�4�4B##c]CC]C###+SK+S=K3cs�?*�2�t��+IL.IM��f��W�Z�Z�gL�>���Ĝ̴L�6b��r��� ����0����w�(-�[eF��=... /B�      �   %  x����n1����>َc'Yo��
!:Tb�Aҥ�p��
c;��=��~��ݰ�<L��u��	"��NL��h`��U��M����cd$`ߑf���^/�ۼ8t�-X�r�8��r�w�K�/(e枕��Pp�t���[�r// �d���R݂Tm7�R���u�1�`��v�Ѕ��iz���y��1�f�T,��js��u��Z��0��bn����q��Hd�
#�J�Fk�Q
�C�֑d���������]݁��0�qk�$�D�������>#��'�������M�      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�ŘMo�0@�ί�}�&�ԇw�i@1`ء�]�X�
�8��_�`���)��Kk�|��'�ZjR	m�R~�?勞C�����x>�~4��������0��pCWT���
��ZaU8E�˯��`}��m+�����N���K8���$	�3Fl���%��q�����2L[`I�׋4�I����|�'G��ȤHk�߱&�l���F�@�w��$Ϩ��alC���fR|�*�%9=bDV��O+r��O�����}��/7�KZ�۞HKr�S#�Z�[[�кܤK��ږ�օ�]�Y]\3AsE&�L�ּY�\�����B'�{/�.H!�k�ظ�3��f��Ź�X�(�.4�8�}
��tGҧ�>�}Ju���J�m·m��<H�>]D1ن6'�4��4ח��}(��t�r�Egi_�V��)<X+Z������u��I����f[Z�lkcR�&������	3j2y�B���k&�I6dP�]��o�E������MR�@r�$�����+38-J>���6��R��]�BL
ڗL
p>�"�Z��ʀ�p������h���̄	38�����y3�p)h��)LE�)�D��Z�t����C|�E
+��b���(dP\gP_Ƞ�g+�W}����۫񫈧͹���5�aƞF[O�r���wn�x�z�rs�t*Orz�0��#[f�e�K��'`r�_�ώ���AT��}{���~GT�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   A  x����N�0���S�:%i�v�M�4ƴ	��RZ3"���)oO:��\)7�����S��y�ź��$"��i��Rd���*�p�M����P9��B��b�׆���ڰʸ�B�x@C�I���0̃����u�[7xV��w��\[7^"��8v��=;�Ǩ��+`�ؾ��;��p�L���2���^�m<蘀{D���7lGCw&%��켮�v�L%�`�:ĝL��X�<CF�ASFț�}n���P?����R4Z���P�?#���i��6g��v���rX9c�5;f���&c�����B-U�f���Q}Ҟ      �      x������ � �      �      x������ � �      �      x������ � �      �   d   x�3�����Sp�O�4202�54�54W00�24�20�32�0����!N���.#Nǜ��T���̒"4���d��rs:�')�,+��#B�O~9W� �`%      �   �   x��ͱ�0������-�D�ĕ�����4��3ɿ~�	.a~;^y�[�<6�AfR%D	�0SUN���uY@w�ʄ���6�1�����s��t�*h�֏P��������Ç�1������&�TJ���t�꒨л�R!��Z9s      �   S  x���Yn$)�g|
_ Ql����K�]u�#L@�ڴ�L��Ѳ���'�L��Qvɽ3H�~<�$�u:�$<R"��GH�������x2���������Ü���s�l�/;�Oπ���1�?^�2��$��J��>���A���%h�X8�m�o����tR����K��qy��/�#kap�_9}�����C����D�#f~}z�b*��BY- 'd��)@rL6|s�OI�O�'�)jN�j�����X��g�@��m��4��mߍ�'�:��GT����qD�&��-i��[�1��N��%H������Q�*�F1T�7����Q�*��_wb�b�(�"��Ճ51�q�`�m\=X3CW����Ճ53���N����m/Au���e�Md�J�����œO0�|�7b��D�DK?EЧ8!�Vc�8Z�@*�pI�����r'JG��NU���8�;Q�8�;1Uq�$܉����č�51�ǲ;�F7f�kf��X33��݉53�{ٝX33\�Ě��Bx'���;�ff����tI���~�(����X���-02�g{���U�9Mp����%Ln;N �g��y�$QĹ6�E�K�E{Z�3�!�3uj'Zx	ZXt���z�b��;@�\ŉ-�J�"̌�B�L/��Y9�71�W�8�b�WO�!J���\��8_���8����rR�dy��N�	חY5S3��v����(�����c�¶�Q��F���`��.�I郸���BR��BR�`XY6Ķ}�r.%�.%�.%���`���RRz�RRz�RRz�RRz�BM�q7����\�)0/Ք�;)y��Nfo[t��3s�ݠ��jJ\�)=p��������j��A�����S��椔 Y�K5�.Ք�TSz�RM�K5�.Ք�K5�.Ք�t�ꁻ�������������������B��B��B��B��B��B��0WF��"PM��&$��j���{	{!�*N|2�-+S��'��$�� K��>��žha����#��k�B��,E�������NU]9w��%���O�� ���96��e���L[�� 7�G�S��ފ�)8u�P�C���u�+���o�Q�cz�	���'a�O��c����#px� ����'=����������	��dfi!A�~�(vN��xy�Gų��d�2�@=A�t;�R����PE�(�"ZQ�'je���6��0?3,$��,�3�3����Q����6���H��9P�����P&&��7{
R��^���s3}!�*N�ⅨU������{-�������/����/.�e      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x���M��0���Щ7�i�aߖf-��f�^�";�Ƭ���eɿ�l�I�`cc��y�Ϋ����O�o��OL c��:OF��`Hv�gʸ�Sĥ��I�$ �T\b����Ӗ�����m�+2H�d�㋵/|��ݖ�|S�|Ϳ����QYsP9@|�؝�u<B����;߾���?������z����Oۏf�$G���L2�2 � ��ƈB+�W���l���2iݡ
 G꫐M�$��9/���X`��i���t�S��nbl�-~�2.u�f^��L'V������t���!���o�w>���o��,�ifaԿ�U	��)"���V���s���&ԧ�Y���T�b2�b�-��ڔ���(:��y]ռ��J3����T��"*m�R�#�d$�)�l�ɟ�n����t��v�T=���ԊR �ͅ��G6��_���VR'����8,��r�43�=G�{dˆ�u�w�����<�b��XGWYP#�K�$�?���      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x���;jCA�z�*��F�xY���|���4�}^H �.��Y����b�	Йr-l�\�{��<����L�<G�M,6�e��c�����⌬��o�W�k��
z�ByY���6Z�z�Ш)�Zי6��\��� �`�W1�@$f����mj���軎ȕ�R�C�Ol%���݁�b���� T]df��"�s�y�HE"�b0$UU��c/���U��B�v9�����      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x���1�0��9=E/��v�����c��4b(*�`��� b|����{��>���<n��eQP�F�IJ<oSr�j�Q�o# �ǖ�g�9t�b����R"���QwX���=�yjOS���"D� �*.r-�T)�-�Ҽ�o���}b41�Ç��i^�ZJ(      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����n�8 ��<�&b���V4)���n���ʦ����(���IV9��� �0��4C�H����le1�+J���m�'Š��*��
��.v��{q��n(�S����
j�kT�ke������N�ݘՇ���c;��t��y݊�v��CAr��nR��&0y��}Z ��/����� �r��ߟ�]��E$�%9�,G��Ȗ�n㣸}�M<<�q��oc'ވ��;~/�K�������ʆ'��K��L	�jckҒ����L���pj ��+���n☘V]���ߤME��**�R�@�S�Js�ԭ�]��ƶ�/|Vi�j��*Va���U�$e�=E~��bw^�؃tl	J"8Tf��z��=S�8Cb�v�fh�.-҅Aj��}%[�g͹m�7�u:<ĝx����o��.N�)��o�kf������Q���,�z�� �� PW���jT���v��6l1p������}����i���8�S&	�2a��G�p�_��)mW��v�dnڧƛ��<m:���	���A|o���j/a�qi�Th�܌�r�-g�<>W�H�jp��	���:^.o�Չ$��ヸ�}�ߥ~\�$��4s`�O�B�m����\�w2�����o�P��=�㢒��; ���|�� g���kjwo��������h���}F�r��q:��%,2�<$y�>�t½d��	��f�����:�m�h����J<���^6������{!�      �      x������ � �      �      x������ � �      �      x������ � �      �   q   x�mͻ�0�����R`aEaꈄBti�;ʃ�ݳ���B��ě��Dq��)��Ư����,��Dw���V3R7'�q�gzXA���m��B��kC����]޿灙�\�AF            x������ � �            x������ � �            x������ � �            x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �             x������ � �            x������ � �      	      x������ � �            x������ � �     