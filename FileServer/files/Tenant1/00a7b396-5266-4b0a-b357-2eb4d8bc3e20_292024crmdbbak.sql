PGDMP  "                     |            ERPCubes-Finalized    16.1    16.1 Z   p           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            r           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            s           1262    17934    ERPCubes-Finalized    DATABASE     �   CREATE DATABASE "ERPCubes-Finalized" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
 $   DROP DATABASE "ERPCubes-Finalized";
                postgres    false                        3079    19603    postgres_fdw 	   EXTENSION     @   CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;
    DROP EXTENSION postgres_fdw;
                   false            t           0    0    EXTENSION postgres_fdw    COMMENT     [   COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';
                        false    2            �           1255    20064    calculateleadevent(integer)    FUNCTION     �
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
       public          postgres    false            �           1255    17936 (   calculateleadeventcountsbyowner(integer)    FUNCTION     �	  CREATE FUNCTION public.calculateleadeventcountsbyowner(tenantid_value integer) RETURNS TABLE(leadownerid text, leadidcount bigint, noteidcount bigint, callidcount bigint, emailidcount bigint, taskidcount bigint, meetingidcount bigint)
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
       public          postgres    false            �           1255    17937 )   calculateleadeventcountsbyowner2(integer)    FUNCTION     t	  CREATE FUNCTION public.calculateleadeventcountsbyowner2(tenantid_value integer) RETURNS TABLE("Leadowner" text, "Lead" bigint, "Note" bigint, "Call" bigint, "Email" bigint, "Task" bigint, "Meeting" bigint)
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
       public          postgres    false            �           1255    20453 ?   crmcampaignwiserpt(integer, integer, text, integer, date, date)    FUNCTION     ;  CREATE FUNCTION public.crmcampaignwiserpt(tenantid integer, sourceid integer, campaign text, productid integer, startdate date, enddate date) RETURNS TABLE("CampaignId" integer, "CampaignTitle" text, "Source" text, "TotalLeads" integer, "WinLeads" integer, "WinRate" numeric, "ConversionRate" numeric, "TotalCost" numeric, "CostperLead" numeric, "RevenueGenerated" numeric, "ReturnonInvestment" numeric)
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
       public          postgres    false            �           1255    19977 @   crmleadownerwiserpt(integer, integer, text, integer, date, date)    FUNCTION     @  CREATE FUNCTION public.crmleadownerwiserpt(tenantid integer, sourceid integer, leadowner text, status integer, startdate date, enddate date) RETURNS TABLE("LeadOwner" text, "TotalLeads" integer, "TotalRevenue" numeric, "AverageDealSize" numeric, "WinLeads" integer, "WinRate" numeric, "ConvertedLeads" integer, "ConversionRate" numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        lead."LeadOwner"::text,
        COUNT(lead."LeadId")::integer AS "TotalLeads",
	    0.0::decimal(18,2) AS "TotalRevenue", -- Default value for AverageDealSize
	    0.0::decimal(18,2) AS "AverageDealSize", -- Default value for AverageDealSize,
		COUNT(CASE WHEN lead."Status" = 6 THEN lead."LeadId" END)::integer AS "WinLeads",
		CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 6 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END ::decimal(18,2) AS "WinRate",
        COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END)::integer AS "ConvertedLeads",
	    CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END ::decimal(18,2) AS "ConversionRate"
    FROM public."CrmLead" AS lead
	 WHERE 
	    (SourceId = -1 OR lead."SourceId" = SourceId)
		And (Status = -1 OR lead."Status" = Status)
		And (LeadOwner = '-1' OR lead."LeadOwner" = LeadOwner)
		And lead."TenantId"=TenantId And lead."IsDeleted"=0
        AND DATE(lead."CreatedDate") BETWEEN DATE(Startdate) AND DATE(Enddate)
     GROUP BY lead."LeadOwner"
    ORDER BY lead."LeadOwner";
	RETURN;
END;
$$;
 �   DROP FUNCTION public.crmleadownerwiserpt(tenantid integer, sourceid integer, leadowner text, status integer, startdate date, enddate date);
       public          postgres    false            �           1255    19978 2   crmleadsourcewiserpt(integer, integer, date, date)    FUNCTION     Z  CREATE FUNCTION public.crmleadsourcewiserpt(tenantid integer, sourceid integer, startdate date, enddate date) RETURNS TABLE("SourceId" integer, "Source" text, "TotalLeads" integer, "ConvertedLeads" integer, "ConversionRate" numeric, "AverageDealSize" numeric, "TotalRevenue" numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        lead."SourceId",
        COALESCE(LeadSour."SourceTitle", 'Unknow') AS "SourceTitle",
        COUNT(lead."LeadId")::integer AS "TotalLeads",
        COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END)::integer AS "ConvertedLeads",
        CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END ::decimal(18,2) AS "ConversionRate",
        0.0::decimal(18,2) AS "AverageDealSize", -- Default value for AverageDealSize
        0.0::decimal(18,2) AS "TotalRevenue"     -- Default value for TotalRevenue
    FROM public."CrmLead" AS lead
    LEFT JOIN public."CrmLeadSource" AS LeadSour ON lead."SourceId" = LeadSour."SourceId"
    WHERE 
	    (SourceId = -1 OR lead."SourceId" = SourceId)
		And lead."TenantId"=TenantId And lead."IsDeleted"=0
        AND DATE(lead."CreatedDate") BETWEEN DATE(Startdate) AND DATE(Enddate)
    GROUP BY lead."SourceId", LeadSour."SourceTitle"
    ORDER BY lead."SourceId";
	RETURN;
END;
$$;
 m   DROP FUNCTION public.crmleadsourcewiserpt(tenantid integer, sourceid integer, startdate date, enddate date);
       public          postgres    false            �           1255    20471 C   crmleadstagewiserpt(integer, integer, integer, date, date, integer)    FUNCTION     |  CREATE FUNCTION public.crmleadstagewiserpt(tenantid integer, sourceid integer, status integer, startdate date, enddate date, productid integer) RETURNS TABLE("Status" integer, "StatusTitle" text, "TotalLeads" integer, "TotalLeadValue" numeric, "AverageDealValue" numeric, "WinLeads" integer, "WinRate" numeric, "ConvertedLeads" integer, "ConversionRate" numeric, "ExpectedRevenue" numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        lead."Status",
        COALESCE(LeadSatus."StatusTitle", 'Unknow') AS "StatusTitle",
        COUNT(lead."LeadId")::integer AS "TotalLeads",
	    0.0::decimal(18,2) AS "TotalLeadValue", -- Default value for TotalLeadValue
	    0.0::decimal(18,2) AS "AverageDealValue", -- Default value for AverageDealValue,
		COUNT(CASE WHEN lead."Status" = 6 THEN lead."LeadId" END)::integer AS "WinLeads",
		CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 6 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END ::decimal(18,2) AS "WinRate",
        COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END)::integer AS "ConvertedLeads",
	    CASE WHEN COUNT(lead."LeadId") > 0 THEN (COUNT(CASE WHEN lead."Status" = 3 THEN lead."LeadId" END) * 100.0) / COUNT(lead."LeadId") ELSE 0 END ::decimal(18,2) AS "ConversionRate",
        0.0::decimal(18,2) AS "ExpectedRevenue" -- Default value for AverageDealSize
       
    FROM public."CrmLead" AS lead
    LEFT JOIN public."CrmLeadStatus" AS LeadSatus ON lead."Status" = LeadSatus."StatusId"
	 WHERE 
	    (SourceId = -1 OR lead."SourceId" = SourceId)
		And (Status = -1 OR lead."Status" = Status)
		And (ProductId= -1 OR lead."ProductId" = ProductId)
		And lead."TenantId"=TenantId And lead."IsDeleted"=0
        AND DATE(lead."CreatedDate") BETWEEN DATE(Startdate) AND DATE(Enddate)
    GROUP BY lead."Status", LeadSatus."StatusTitle"
    ORDER BY lead."Status";
	RETURN;
END;
$$;
 �   DROP FUNCTION public.crmleadstagewiserpt(tenantid integer, sourceid integer, status integer, startdate date, enddate date, productid integer);
       public          postgres    false            �           1255    17938    get_all_crmleads() 	   PROCEDURE     g   CREATE PROCEDURE public.get_all_crmleads()
    LANGUAGE sql
    AS $$
    SELECT * FROM "CrmLead";
$$;
 *   DROP PROCEDURE public.get_all_crmleads();
       public          postgres    false            �           1255    17939    get_crmleads(integer)    FUNCTION     �  CREATE FUNCTION public.get_crmleads(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    17940    get_lead_status_counts()    FUNCTION     x  CREATE FUNCTION public.get_lead_status_counts() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    17941    get_lead_status_counts22()    FUNCTION     z  CREATE FUNCTION public.get_lead_status_counts22() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    17942    get_lead_status_counts23()    FUNCTION       CREATE FUNCTION public.get_lead_status_counts23() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, count integer)
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
       public          postgres    false            �           1255    17943 !   get_lead_status_counts23(integer)    FUNCTION     �  CREATE FUNCTION public.get_lead_status_counts23(p_tenantid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, count integer)
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
       public          postgres    false            �           1255    17944    get_leadreport(integer)    FUNCTION     �  CREATE FUNCTION public.get_leadreport(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    17945    getleaddata(integer)    FUNCTION       CREATE FUNCTION public.getleaddata(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    17946    getleadstatuscounts()    FUNCTION     X  CREATE FUNCTION public.getleadstatuscounts() RETURNS TABLE(leadowner text, statustitle text, statusid integer, productname text, productid integer, count integer)
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
       public          postgres    false            �           1255    19695 f   insertcrmuseractivitylog(text, integer, integer, text, text, integer, integer, integer, text, integer) 	   PROCEDURE     j  CREATE PROCEDURE public.insertcrmuseractivitylog(IN p_userid text, IN p_activitytype integer, IN p_activitystatus integer, IN p_detail text, IN p_createdby text, IN p_tenantid integer, IN p_contacttypeid integer, IN p_contactactivityid integer, IN p_action text, IN p_contactid integer)
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
       public          postgres    false            �           1255    19588 E   insertstatuslog(text, integer, text, text, integer, integer, integer) 	   PROCEDURE     w  CREATE PROCEDURE public.insertstatuslog(IN p_details text, IN p_typeid integer, IN p_statustitle text, IN p_createdby text, IN p_actionid integer, IN p_tenantid integer, IN p_statusid integer)
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
       public          postgres    false            �           1255    19885 1   leadownerstatuswise(integer, date, date, integer)    FUNCTION     �  CREATE FUNCTION public.leadownerstatuswise(p_tenantid integer, p_startdate date, p_enddate date, p_productid integer) RETURNS TABLE("leadStatusId" integer, "LeadStatusTitle" text, "LeadOwner" text, "FirstName" text, "ProductId" integer, "ProductName" text, "Count" integer)
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
       public          postgres    false            �           1255    17947    leadstatusfn(integer)    FUNCTION       CREATE FUNCTION public.leadstatusfn(p_tenantid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, "Count" integer)
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
       public          postgres    false            �           1255    17948 *   leadstatusfn(integer, date, date, integer)    FUNCTION     �  CREATE FUNCTION public.leadstatusfn(p_tenantid integer, p_startdate date, p_enddate date, p_productid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, "Count" integer)
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
       public          postgres    false            �           1255    17949    process_lead_counts(integer)    FUNCTION     �	  CREATE FUNCTION public.process_lead_counts(p_tenantid integer) RETURNS TABLE(leadownerid text, leadid integer, noteidcount integer, callidcount integer, emailidcount integer, taskidcount integer, meetingidcount integer)
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
       public          postgres    false            �
           1417    19610 
   db2_server    SERVER     f   CREATE SERVER db2_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'ERPCubesIdentity'
);
    DROP SERVER db2_server;
                postgres    false    2    2    2            u           0    0 '   USER MAPPING postgres SERVER db2_server    USER MAPPING     m   CREATE USER MAPPING FOR postgres SERVER db2_server OPTIONS (
    password 'Abc123',
    "user" 'postgres'
);
 2   DROP USER MAPPING FOR postgres SERVER db2_server;
                postgres    false                        1259    17950    AppMenus    TABLE     v  CREATE TABLE public."AppMenus" (
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
       public         heap    postgres    false                       1259    17957    AppMenus_MenuId_seq    SEQUENCE     �   CREATE SEQUENCE public."AppMenus_MenuId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."AppMenus_MenuId_seq";
       public          postgres    false    256            v           0    0    AppMenus_MenuId_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."AppMenus_MenuId_seq" OWNED BY public."AppMenus"."MenuId";
          public          postgres    false    257                       1259    17958    CrmAdAccount    TABLE     �  CREATE TABLE public."CrmAdAccount" (
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
       public            postgres    false                       1259    17963    CrmAdAccount_AccountId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmAdAccount_AccountId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmAdAccount_AccountId_seq";
       public          postgres    false    258            w           0    0    CrmAdAccount_AccountId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmAdAccount_AccountId_seq" OWNED BY public."CrmAdAccount"."AccountId";
          public          postgres    false    259                       1259    17964    CrmAdAccount1    TABLE       CREATE TABLE public."CrmAdAccount1" (
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
       public         heap    postgres    false    259    258                       1259    17972    CrmAdAccount100    TABLE       CREATE TABLE public."CrmAdAccount100" (
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
       public         heap    postgres    false    259    258                       1259    17980    CrmAdAccount2    TABLE       CREATE TABLE public."CrmAdAccount2" (
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
       public         heap    postgres    false    259    258                       1259    17988    CrmAdAccount3    TABLE       CREATE TABLE public."CrmAdAccount3" (
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
       public         heap    postgres    false    259    258                       1259    17996    CrmCalendarEventsType    TABLE     �   CREATE TABLE public."CrmCalendarEventsType" (
    "TypeId" integer NOT NULL,
    "TypeTitle" text,
    "IsDeleted" integer DEFAULT 0
);
 +   DROP TABLE public."CrmCalendarEventsType";
       public         heap    postgres    false            	           1259    18002     CrmCalendarEventsType_TypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCalendarEventsType_TypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."CrmCalendarEventsType_TypeId_seq";
       public          postgres    false    264            x           0    0     CrmCalendarEventsType_TypeId_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."CrmCalendarEventsType_TypeId_seq" OWNED BY public."CrmCalendarEventsType"."TypeId";
          public          postgres    false    265            
           1259    18003    CrmCalenderEvents    TABLE     >  CREATE TABLE public."CrmCalenderEvents" (
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
       public            postgres    false                       1259    18008    CrmCalenderEvents_EventId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCalenderEvents_EventId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CrmCalenderEvents_EventId_seq";
       public          postgres    false    266            y           0    0    CrmCalenderEvents_EventId_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."CrmCalenderEvents_EventId_seq" OWNED BY public."CrmCalenderEvents"."EventId";
          public          postgres    false    267                       1259    18009    CrmCalenderEventsTenant1    TABLE     i  CREATE TABLE public."CrmCalenderEventsTenant1" (
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
       public         heap    postgres    false    267    266                       1259    18017    CrmCalenderEventsTenant100    TABLE     k  CREATE TABLE public."CrmCalenderEventsTenant100" (
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
       public         heap    postgres    false    267    266                       1259    18025    CrmCalenderEventsTenant2    TABLE     i  CREATE TABLE public."CrmCalenderEventsTenant2" (
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
       public         heap    postgres    false    267    266                       1259    18033    CrmCalenderEventsTenant3    TABLE     i  CREATE TABLE public."CrmCalenderEventsTenant3" (
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
       public         heap    postgres    false    267    266                       1259    18041    CrmCall    TABLE     �  CREATE TABLE public."CrmCall" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmCall";
       public            postgres    false                       1259    18046    CrmCall_CallId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCall_CallId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmCall_CallId_seq";
       public          postgres    false    272            z           0    0    CrmCall_CallId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmCall_CallId_seq" OWNED BY public."CrmCall"."CallId";
          public          postgres    false    273                       1259    18047    CrmCall1    TABLE     �  CREATE TABLE public."CrmCall1" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
    DROP TABLE public."CrmCall1";
       public         heap    postgres    false    273    272                       1259    18055 
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
     DROP TABLE public."CrmCall100";
       public         heap    postgres    false    273    272                       1259    18063    CrmCall2    TABLE     �  CREATE TABLE public."CrmCall2" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
    DROP TABLE public."CrmCall2";
       public         heap    postgres    false    273    272                       1259    18071    CrmCall3    TABLE     �  CREATE TABLE public."CrmCall3" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
    DROP TABLE public."CrmCall3";
       public         heap    postgres    false    273    272            �           1259    20399    CrmCampaign    TABLE     #  CREATE TABLE public."CrmCampaign" (
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
       public            postgres    false            �           1259    20417    CrmCampaign1    TABLE       CREATE TABLE public."CrmCampaign1" (
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
       public         heap    postgres    false    432            �           1259    20427    CrmCampaign100    TABLE       CREATE TABLE public."CrmCampaign100" (
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
       public         heap    postgres    false    432            �           1259    20437    CrmCampaign2    TABLE       CREATE TABLE public."CrmCampaign2" (
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
       public         heap    postgres    false    432            �           1259    20406    CrmCampaign3    TABLE       CREATE TABLE public."CrmCampaign3" (
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
       public         heap    postgres    false    432                       1259    18079 
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
       public            postgres    false                       1259    18084    CrmCompanyActivityLog    TABLE     1  CREATE TABLE public."CrmCompanyActivityLog" (
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
       public            postgres    false                       1259    18089 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq";
       public          postgres    false    279            {           0    0 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq" OWNED BY public."CrmCompanyActivityLog"."ActivityId";
          public          postgres    false    280                       1259    18090    CrmCompanyActivityLogTenant1    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant1" (
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
       public         heap    postgres    false    280    279                       1259    18098    CrmCompanyActivityLogTenant100    TABLE     e  CREATE TABLE public."CrmCompanyActivityLogTenant100" (
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
       public         heap    postgres    false    280    279                       1259    18106    CrmCompanyActivityLogTenant2    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant2" (
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
       public         heap    postgres    false    280    279                       1259    18114    CrmCompanyActivityLogTenant3    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant3" (
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
       public         heap    postgres    false    280    279                       1259    18122    CrmCompanyMember    TABLE     �  CREATE TABLE public."CrmCompanyMember" (
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
       public            postgres    false                       1259    18127    CrmCompanyMember_MemberId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompanyMember_MemberId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CrmCompanyMember_MemberId_seq";
       public          postgres    false    285            |           0    0    CrmCompanyMember_MemberId_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."CrmCompanyMember_MemberId_seq" OWNED BY public."CrmCompanyMember"."MemberId";
          public          postgres    false    286                       1259    18128    CrmCompanyMemberTenant1    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant1" (
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
       public         heap    postgres    false    286    285                        1259    18136    CrmCompanyMemberTenant100    TABLE       CREATE TABLE public."CrmCompanyMemberTenant100" (
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
       public         heap    postgres    false    286    285            !           1259    18144    CrmCompanyMemberTenant2    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant2" (
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
       public         heap    postgres    false    286    285            "           1259    18152    CrmCompanyMemberTenant3    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant3" (
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
       public         heap    postgres    false    286    285            #           1259    18160    CrmCompany_CompanyId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompany_CompanyId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmCompany_CompanyId_seq";
       public          postgres    false    278            }           0    0    CrmCompany_CompanyId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmCompany_CompanyId_seq" OWNED BY public."CrmCompany"."CompanyId";
          public          postgres    false    291            $           1259    18161    CrmCompanyTenant1    TABLE     �  CREATE TABLE public."CrmCompanyTenant1" (
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
       public         heap    postgres    false    291    278            %           1259    18169    CrmCompanyTenant100    TABLE     �  CREATE TABLE public."CrmCompanyTenant100" (
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
       public         heap    postgres    false    291    278            &           1259    18177    CrmCompanyTenant2    TABLE     �  CREATE TABLE public."CrmCompanyTenant2" (
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
       public         heap    postgres    false    291    278            '           1259    18185    CrmCompanyTenant3    TABLE     �  CREATE TABLE public."CrmCompanyTenant3" (
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
       public         heap    postgres    false    291    278            (           1259    18193    CrmCustomLists    TABLE     �  CREATE TABLE public."CrmCustomLists" (
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
       public            postgres    false            )           1259    18199    CrmCustomLists_ListId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCustomLists_ListId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."CrmCustomLists_ListId_seq";
       public          postgres    false    296            ~           0    0    CrmCustomLists_ListId_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CrmCustomLists_ListId_seq" OWNED BY public."CrmCustomLists"."ListId";
          public          postgres    false    297            *           1259    18200    CrmCustomListsTenant1    TABLE     
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
       public         heap    postgres    false    297    296            +           1259    18209    CrmCustomListsTenant100    TABLE       CREATE TABLE public."CrmCustomListsTenant100" (
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
       public         heap    postgres    false    297    296            ,           1259    18218    CrmCustomListsTenant2    TABLE     
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
       public         heap    postgres    false    297    296            -           1259    18227    CrmCustomListsTenant3    TABLE     
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
       public         heap    postgres    false    297    296            .           1259    18236    CrmEmail    TABLE     2  CREATE TABLE public."CrmEmail" (
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
       public            postgres    false            /           1259    18241    CrmEmail_EmailId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmEmail_EmailId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."CrmEmail_EmailId_seq";
       public          postgres    false    302                       0    0    CrmEmail_EmailId_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CrmEmail_EmailId_seq" OWNED BY public."CrmEmail"."EmailId";
          public          postgres    false    303            0           1259    18242 	   CrmEmail1    TABLE     N  CREATE TABLE public."CrmEmail1" (
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
       public         heap    postgres    false    303    302            1           1259    18250    CrmEmail100    TABLE     P  CREATE TABLE public."CrmEmail100" (
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
       public         heap    postgres    false    303    302            2           1259    18258 	   CrmEmail2    TABLE     N  CREATE TABLE public."CrmEmail2" (
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
       public         heap    postgres    false    303    302            3           1259    18266 	   CrmEmail3    TABLE     N  CREATE TABLE public."CrmEmail3" (
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
       public         heap    postgres    false    303    302            �           1259    20913    CrmFormFields    TABLE     �  CREATE TABLE public."CrmFormFields" (
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
       public            postgres    false            �           1259    20912    CrmFormFields_FieldId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmFormFields_FieldId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."CrmFormFields_FieldId_seq";
       public          postgres    false    438            �           0    0    CrmFormFields_FieldId_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CrmFormFields_FieldId_seq" OWNED BY public."CrmFormFields"."FieldId";
          public          postgres    false    437            �           1259    20921    CrmFormFields1    TABLE     �  CREATE TABLE public."CrmFormFields1" (
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
       public         heap    postgres    false    437    438            �           1259    20951    CrmFormFields100    TABLE     �  CREATE TABLE public."CrmFormFields100" (
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
       public         heap    postgres    false    437    438            �           1259    20931    CrmFormFields2    TABLE     �  CREATE TABLE public."CrmFormFields2" (
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
       public         heap    postgres    false    437    438            �           1259    20941    CrmFormFields3    TABLE     �  CREATE TABLE public."CrmFormFields3" (
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
       public         heap    postgres    false    437    438            �           1259    20967    CrmFormResults    TABLE     �  CREATE TABLE public."CrmFormResults" (
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
       public            postgres    false            �           1259    20966    CrmFormResults_ResultId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmFormResults_ResultId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."CrmFormResults_ResultId_seq";
       public          postgres    false    444            �           0    0    CrmFormResults_ResultId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CrmFormResults_ResultId_seq" OWNED BY public."CrmFormResults"."ResultId";
          public          postgres    false    443            �           1259    20975    CrmFormResults1    TABLE       CREATE TABLE public."CrmFormResults1" (
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
       public         heap    postgres    false    443    444            �           1259    21005    CrmFormResults100    TABLE       CREATE TABLE public."CrmFormResults100" (
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
       public         heap    postgres    false    443    444            �           1259    20985    CrmFormResults2    TABLE       CREATE TABLE public."CrmFormResults2" (
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
       public         heap    postgres    false    443    444            �           1259    20995    CrmFormResults3    TABLE       CREATE TABLE public."CrmFormResults3" (
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
       public         heap    postgres    false    443    444            �           1259    19571    CrmICallScenarios    TABLE     �   CREATE TABLE public."CrmICallScenarios" (
    "ReasonId" integer NOT NULL,
    "Title" text,
    "IsTask" integer DEFAULT 0,
    "IsShowResponse" integer,
    "IsDeleted" integer DEFAULT 0
);
 '   DROP TABLE public."CrmICallScenarios";
       public         heap    postgres    false            �           1259    19570    CrmICallScenarios_ReasonId_seq    SEQUENCE     �   ALTER TABLE public."CrmICallScenarios" ALTER COLUMN "ReasonId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."CrmICallScenarios_ReasonId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    426            4           1259    18274    CrmIndustry    TABLE     �  CREATE TABLE public."CrmIndustry" (
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
       public            postgres    false            5           1259    18279    CrmIndustry_IndustryId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmIndustry_IndustryId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmIndustry_IndustryId_seq";
       public          postgres    false    308            �           0    0    CrmIndustry_IndustryId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmIndustry_IndustryId_seq" OWNED BY public."CrmIndustry"."IndustryId";
          public          postgres    false    309            6           1259    18280    CrmIndustryTenant1    TABLE     �  CREATE TABLE public."CrmIndustryTenant1" (
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
       public         heap    postgres    false    309    308            7           1259    18288    CrmIndustryTenant100    TABLE     �  CREATE TABLE public."CrmIndustryTenant100" (
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
       public         heap    postgres    false    309    308            8           1259    18296    CrmIndustryTenant2    TABLE     �  CREATE TABLE public."CrmIndustryTenant2" (
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
       public         heap    postgres    false    309    308            9           1259    18304    CrmIndustryTenant3    TABLE     �  CREATE TABLE public."CrmIndustryTenant3" (
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
       public         heap    postgres    false    309    308            :           1259    18312    CrmLead    TABLE     D  CREATE TABLE public."CrmLead" (
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
    "CampaignId" text DEFAULT '-1'::integer
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmLead";
       public            postgres    false            ;           1259    18317    CrmLeadActivityLog    TABLE     +  CREATE TABLE public."CrmLeadActivityLog" (
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
       public            postgres    false            <           1259    18322 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmLeadActivityLog_ActivityId_seq";
       public          postgres    false    315            �           0    0 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmLeadActivityLog_ActivityId_seq" OWNED BY public."CrmLeadActivityLog"."ActivityId";
          public          postgres    false    316            =           1259    18323    CrmLeadActivityLogTenant1    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant1" (
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
       public         heap    postgres    false    316    315            >           1259    18331    CrmLeadActivityLogTenant100    TABLE     \  CREATE TABLE public."CrmLeadActivityLogTenant100" (
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
       public         heap    postgres    false    316    315            ?           1259    18339    CrmLeadActivityLogTenant2    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant2" (
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
       public         heap    postgres    false    316    315            @           1259    18347    CrmLeadActivityLogTenant3    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant3" (
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
       public         heap    postgres    false    316    315            A           1259    18355    CrmLeadSource    TABLE     �  CREATE TABLE public."CrmLeadSource" (
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
       public            postgres    false            B           1259    18360    CrmLeadSource_SourceId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadSource_SourceId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmLeadSource_SourceId_seq";
       public          postgres    false    321            �           0    0    CrmLeadSource_SourceId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmLeadSource_SourceId_seq" OWNED BY public."CrmLeadSource"."SourceId";
          public          postgres    false    322            C           1259    18361    CrmLeadSourceTenant1    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant1" (
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
       public         heap    postgres    false    322    321            D           1259    18369    CrmLeadSourceTenant100    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant100" (
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
       public         heap    postgres    false    322    321            E           1259    18377    CrmLeadSourceTenant2    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant2" (
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
       public         heap    postgres    false    322    321            F           1259    18385    CrmLeadSourceTenant3    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant3" (
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
       public         heap    postgres    false    322    321            G           1259    18393    CrmLeadStatus    TABLE     �  CREATE TABLE public."CrmLeadStatus" (
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
       public            postgres    false            H           1259    18398    CrmLeadStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmLeadStatus_StatusId_seq";
       public          postgres    false    327            �           0    0    CrmLeadStatus_StatusId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmLeadStatus_StatusId_seq" OWNED BY public."CrmLeadStatus"."StatusId";
          public          postgres    false    328            I           1259    18399    CrmLeadStatusTenant1    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant1" (
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
       public         heap    postgres    false    328    327            J           1259    18407    CrmLeadStatusTenant100    TABLE     '  CREATE TABLE public."CrmLeadStatusTenant100" (
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
       public         heap    postgres    false    328    327            K           1259    18415    CrmLeadStatusTenant2    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant2" (
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
       public         heap    postgres    false    328    327            L           1259    18423    CrmLeadStatusTenant3    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant3" (
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
       public         heap    postgres    false    328    327            M           1259    18431    CrmLead_LeadId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLead_LeadId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmLead_LeadId_seq";
       public          postgres    false    314            �           0    0    CrmLead_LeadId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmLead_LeadId_seq" OWNED BY public."CrmLead"."LeadId";
          public          postgres    false    333            N           1259    18432    CrmLeadTenant1    TABLE     d  CREATE TABLE public."CrmLeadTenant1" (
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
    "CampaignId" text DEFAULT '-1'::integer
);
 $   DROP TABLE public."CrmLeadTenant1";
       public         heap    postgres    false    333    314            O           1259    18440    CrmLeadTenant100    TABLE     f  CREATE TABLE public."CrmLeadTenant100" (
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
    "CampaignId" text DEFAULT '-1'::integer
);
 &   DROP TABLE public."CrmLeadTenant100";
       public         heap    postgres    false    333    314            P           1259    18448    CrmLeadTenant2    TABLE     d  CREATE TABLE public."CrmLeadTenant2" (
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
    "CampaignId" text DEFAULT '-1'::integer
);
 $   DROP TABLE public."CrmLeadTenant2";
       public         heap    postgres    false    333    314            Q           1259    18456    CrmLeadTenant3    TABLE     d  CREATE TABLE public."CrmLeadTenant3" (
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
    "CampaignId" text DEFAULT '-1'::integer
);
 $   DROP TABLE public."CrmLeadTenant3";
       public         heap    postgres    false    333    314            R           1259    18464 
   CrmMeeting    TABLE     Q  CREATE TABLE public."CrmMeeting" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmMeeting";
       public            postgres    false            S           1259    18469    CrmMeeting_MeetingId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmMeeting_MeetingId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmMeeting_MeetingId_seq";
       public          postgres    false    338            �           0    0    CrmMeeting_MeetingId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmMeeting_MeetingId_seq" OWNED BY public."CrmMeeting"."MeetingId";
          public          postgres    false    339            T           1259    18470    CrmMeeting1    TABLE     q  CREATE TABLE public."CrmMeeting1" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 !   DROP TABLE public."CrmMeeting1";
       public         heap    postgres    false    339    338            U           1259    18478    CrmMeeting100    TABLE     s  CREATE TABLE public."CrmMeeting100" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 #   DROP TABLE public."CrmMeeting100";
       public         heap    postgres    false    339    338            V           1259    18486    CrmMeeting2    TABLE     q  CREATE TABLE public."CrmMeeting2" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 !   DROP TABLE public."CrmMeeting2";
       public         heap    postgres    false    339    338            W           1259    18494    CrmMeeting3    TABLE     q  CREATE TABLE public."CrmMeeting3" (
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
    "ContactTypeId" integer DEFAULT '-1'::integer NOT NULL
);
 !   DROP TABLE public."CrmMeeting3";
       public         heap    postgres    false    339    338            X           1259    18502    CrmNote    TABLE       CREATE TABLE public."CrmNote" (
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
       public            postgres    false            Y           1259    18507    CrmNoteTags    TABLE     �  CREATE TABLE public."CrmNoteTags" (
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
       public            postgres    false            Z           1259    18512    CrmNoteTags_NoteTagsId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNoteTags_NoteTagsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmNoteTags_NoteTagsId_seq";
       public          postgres    false    345            �           0    0    CrmNoteTags_NoteTagsId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmNoteTags_NoteTagsId_seq" OWNED BY public."CrmNoteTags"."NoteTagsId";
          public          postgres    false    346            [           1259    18513    CrmNoteTagsTenant1    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant1" (
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
       public         heap    postgres    false    346    345            \           1259    18521    CrmNoteTagsTenant100    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant100" (
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
       public         heap    postgres    false    346    345            ]           1259    18529    CrmNoteTagsTenant2    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant2" (
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
       public         heap    postgres    false    346    345            ^           1259    18537    CrmNoteTagsTenant3    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant3" (
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
       public         heap    postgres    false    346    345            _           1259    18545    CrmNoteTasks    TABLE     �  CREATE TABLE public."CrmNoteTasks" (
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
       public            postgres    false            `           1259    18550    CrmNoteTasks_NoteTaskId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNoteTasks_NoteTaskId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."CrmNoteTasks_NoteTaskId_seq";
       public          postgres    false    351            �           0    0    CrmNoteTasks_NoteTaskId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CrmNoteTasks_NoteTaskId_seq" OWNED BY public."CrmNoteTasks"."NoteTaskId";
          public          postgres    false    352            a           1259    18551    CrmNoteTasksTenant1    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant1" (
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
       public         heap    postgres    false    352    351            b           1259    18559    CrmNoteTasksTenant100    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant100" (
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
       public         heap    postgres    false    352    351            c           1259    18567    CrmNoteTasksTenant2    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant2" (
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
       public         heap    postgres    false    352    351            d           1259    18575    CrmNoteTasksTenant3    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant3" (
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
       public         heap    postgres    false    352    351            e           1259    18583    CrmNote_NoteId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNote_NoteId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmNote_NoteId_seq";
       public          postgres    false    344            �           0    0    CrmNote_NoteId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmNote_NoteId_seq" OWNED BY public."CrmNote"."NoteId";
          public          postgres    false    357            f           1259    18584    CrmNoteTenant1    TABLE     <  CREATE TABLE public."CrmNoteTenant1" (
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
       public         heap    postgres    false    357    344            g           1259    18592    CrmNoteTenant100    TABLE     >  CREATE TABLE public."CrmNoteTenant100" (
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
       public         heap    postgres    false    357    344            h           1259    18600    CrmNoteTenant2    TABLE     <  CREATE TABLE public."CrmNoteTenant2" (
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
       public         heap    postgres    false    357    344            i           1259    18608    CrmNoteTenant3    TABLE     <  CREATE TABLE public."CrmNoteTenant3" (
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
       public         heap    postgres    false    357    344            j           1259    18616    CrmOpportunity    TABLE     .  CREATE TABLE public."CrmOpportunity" (
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
       public            postgres    false            k           1259    18621     CrmOpportunity_OpportunityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmOpportunity_OpportunityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."CrmOpportunity_OpportunityId_seq";
       public          postgres    false    362            �           0    0     CrmOpportunity_OpportunityId_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."CrmOpportunity_OpportunityId_seq" OWNED BY public."CrmOpportunity"."OpportunityId";
          public          postgres    false    363            l           1259    18622    CrmOpportunity1    TABLE     V  CREATE TABLE public."CrmOpportunity1" (
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
       public         heap    postgres    false    363    362            m           1259    18630    CrmOpportunity100    TABLE     X  CREATE TABLE public."CrmOpportunity100" (
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
       public         heap    postgres    false    363    362            n           1259    18638    CrmOpportunity2    TABLE     V  CREATE TABLE public."CrmOpportunity2" (
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
       public         heap    postgres    false    363    362            o           1259    18646    CrmOpportunity3    TABLE     V  CREATE TABLE public."CrmOpportunity3" (
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
       public         heap    postgres    false    363    362            p           1259    18662    CrmOpportunityStatus    TABLE     �  CREATE TABLE public."CrmOpportunityStatus" (
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
       public         heap    postgres    false            q           1259    18669 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmOpportunityStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmOpportunityStatus_StatusId_seq";
       public          postgres    false    368            �           0    0 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmOpportunityStatus_StatusId_seq" OWNED BY public."CrmOpportunityStatus"."StatusId";
          public          postgres    false    369            r           1259    18670 
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
       public            postgres    false            s           1259    18675    CrmProduct_ProductId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmProduct_ProductId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmProduct_ProductId_seq";
       public          postgres    false    370            �           0    0    CrmProduct_ProductId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmProduct_ProductId_seq" OWNED BY public."CrmProduct"."ProductId";
          public          postgres    false    371            t           1259    18676    CrmProductTenant1    TABLE     S  CREATE TABLE public."CrmProductTenant1" (
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
       public         heap    postgres    false    371    370            u           1259    18684    CrmProductTenant100    TABLE     U  CREATE TABLE public."CrmProductTenant100" (
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
       public         heap    postgres    false    371    370            v           1259    18692    CrmProductTenant2    TABLE     S  CREATE TABLE public."CrmProductTenant2" (
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
       public         heap    postgres    false    371    370            w           1259    18700    CrmProductTenant3    TABLE     S  CREATE TABLE public."CrmProductTenant3" (
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
       public         heap    postgres    false    371    370            �           1259    19590 
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
       public            postgres    false            �           1259    19589    CrmProject_ProjectId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmProject_ProjectId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmProject_ProjectId_seq";
       public          postgres    false    430            �           0    0    CrmProject_ProjectId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmProject_ProjectId_seq" OWNED BY public."CrmProject"."ProjectId";
          public          postgres    false    429            �           1259    19581    CrmStatusLog    TABLE       CREATE TABLE public."CrmStatusLog" (
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
       public         heap    postgres    false            �           1259    19580    CrmStatusLog_LogId_seq    SEQUENCE     �   ALTER TABLE public."CrmStatusLog" ALTER COLUMN "LogId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."CrmStatusLog_LogId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    428            x           1259    18708 
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
       public            postgres    false            y           1259    18713    CrmTagUsed_TagUsedId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTagUsed_TagUsedId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmTagUsed_TagUsedId_seq";
       public          postgres    false    376            �           0    0    CrmTagUsed_TagUsedId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmTagUsed_TagUsedId_seq" OWNED BY public."CrmTagUsed"."TagUsedId";
          public          postgres    false    377            z           1259    18714    CrmTagUsedTenant1    TABLE     &  CREATE TABLE public."CrmTagUsedTenant1" (
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
       public         heap    postgres    false    377    376            {           1259    18722    CrmTagUsedTenant100    TABLE     (  CREATE TABLE public."CrmTagUsedTenant100" (
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
       public         heap    postgres    false    377    376            |           1259    18730    CrmTagUsedTenant2    TABLE     &  CREATE TABLE public."CrmTagUsedTenant2" (
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
       public         heap    postgres    false    377    376            }           1259    18738    CrmTagUsedTenant3    TABLE     &  CREATE TABLE public."CrmTagUsedTenant3" (
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
       public         heap    postgres    false    377    376            ~           1259    18746    CrmTags    TABLE     �  CREATE TABLE public."CrmTags" (
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
       public            postgres    false                       1259    18751    CrmTags_TagId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTags_TagId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."CrmTags_TagId_seq";
       public          postgres    false    382            �           0    0    CrmTags_TagId_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."CrmTags_TagId_seq" OWNED BY public."CrmTags"."TagId";
          public          postgres    false    383            �           1259    18752    CrmTagsTenant1    TABLE     �  CREATE TABLE public."CrmTagsTenant1" (
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
       public         heap    postgres    false    383    382            �           1259    18760    CrmTagsTenant100    TABLE     �  CREATE TABLE public."CrmTagsTenant100" (
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
       public         heap    postgres    false    383    382            �           1259    18768    CrmTagsTenant2    TABLE     �  CREATE TABLE public."CrmTagsTenant2" (
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
       public         heap    postgres    false    383    382            �           1259    18776    CrmTagsTenant3    TABLE     �  CREATE TABLE public."CrmTagsTenant3" (
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
       public         heap    postgres    false    383    382            �           1259    18784    CrmTask    TABLE     %  CREATE TABLE public."CrmTask" (
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
       public            postgres    false            �           1259    18793    CrmTaskPriority    TABLE     �  CREATE TABLE public."CrmTaskPriority" (
    "PriorityId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "PriorityTitle" text NOT NULL
);
 %   DROP TABLE public."CrmTaskPriority";
       public         heap    postgres    false            �           1259    18800    CrmTaskPriority_PriorityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskPriority_PriorityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."CrmTaskPriority_PriorityId_seq";
       public          postgres    false    389            �           0    0    CrmTaskPriority_PriorityId_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."CrmTaskPriority_PriorityId_seq" OWNED BY public."CrmTaskPriority"."PriorityId";
          public          postgres    false    390            �           1259    18801    CrmTaskStatus    TABLE     q  CREATE TABLE public."CrmTaskStatus" (
    "StatusId" integer NOT NULL,
    "StatusTitle" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL
);
 #   DROP TABLE public."CrmTaskStatus";
       public         heap    postgres    false            �           1259    18808    CrmTaskStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmTaskStatus_StatusId_seq";
       public          postgres    false    391            �           0    0    CrmTaskStatus_StatusId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmTaskStatus_StatusId_seq" OWNED BY public."CrmTaskStatus"."StatusId";
          public          postgres    false    392            �           1259    18809    CrmTaskTags    TABLE     �  CREATE TABLE public."CrmTaskTags" (
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
       public            postgres    false            �           1259    18814    CrmTaskTags_TaskTagsId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskTags_TaskTagsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmTaskTags_TaskTagsId_seq";
       public          postgres    false    393            �           0    0    CrmTaskTags_TaskTagsId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmTaskTags_TaskTagsId_seq" OWNED BY public."CrmTaskTags"."TaskTagsId";
          public          postgres    false    394            �           1259    18815    CrmTaskTagsTenant1    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant1" (
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
       public         heap    postgres    false    394    393            �           1259    18823    CrmTaskTagsTenant100    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant100" (
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
       public         heap    postgres    false    394    393            �           1259    18831    CrmTaskTagsTenant2    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant2" (
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
       public         heap    postgres    false    394    393            �           1259    18839    CrmTaskTagsTenant3    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant3" (
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
       public         heap    postgres    false    394    393            �           1259    18847    CrmTask_TaskId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTask_TaskId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmTask_TaskId_seq";
       public          postgres    false    388            �           0    0    CrmTask_TaskId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmTask_TaskId_seq" OWNED BY public."CrmTask"."TaskId";
          public          postgres    false    399            �           1259    18848    CrmTaskTenant1    TABLE     E  CREATE TABLE public."CrmTaskTenant1" (
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
       public         heap    postgres    false    399    388            �           1259    18860    CrmTaskTenant100    TABLE     G  CREATE TABLE public."CrmTaskTenant100" (
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
       public         heap    postgres    false    399    388            �           1259    18872    CrmTaskTenant2    TABLE     E  CREATE TABLE public."CrmTaskTenant2" (
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
       public         heap    postgres    false    399    388            �           1259    18884    CrmTaskTenant3    TABLE     E  CREATE TABLE public."CrmTaskTenant3" (
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
       public         heap    postgres    false    399    388            �           1259    18896    CrmTeam    TABLE     �  CREATE TABLE public."CrmTeam" (
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
       public            postgres    false            �           1259    18901    CrmTeamMember    TABLE     �  CREATE TABLE public."CrmTeamMember" (
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
       public            postgres    false            �           1259    18906    CrmTeamMember_TeamMemberId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTeamMember_TeamMemberId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."CrmTeamMember_TeamMemberId_seq";
       public          postgres    false    405            �           0    0    CrmTeamMember_TeamMemberId_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."CrmTeamMember_TeamMemberId_seq" OWNED BY public."CrmTeamMember"."TeamMemberId";
          public          postgres    false    406            �           1259    18907    CrmTeamMemberTenant1    TABLE       CREATE TABLE public."CrmTeamMemberTenant1" (
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
       public         heap    postgres    false    406    405            �           1259    18915    CrmTeamMemberTenant100    TABLE       CREATE TABLE public."CrmTeamMemberTenant100" (
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
       public         heap    postgres    false    406    405            �           1259    18923    CrmTeamMemberTenant2    TABLE       CREATE TABLE public."CrmTeamMemberTenant2" (
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
       public         heap    postgres    false    406    405            �           1259    18931    CrmTeamMemberTenant3    TABLE       CREATE TABLE public."CrmTeamMemberTenant3" (
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
       public         heap    postgres    false    406    405            �           1259    18939    CrmTeam_TeamId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTeam_TeamId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmTeam_TeamId_seq";
       public          postgres    false    404            �           0    0    CrmTeam_TeamId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmTeam_TeamId_seq" OWNED BY public."CrmTeam"."TeamId";
          public          postgres    false    411            �           1259    18940    CrmTeamTenant1    TABLE     �  CREATE TABLE public."CrmTeamTenant1" (
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
       public         heap    postgres    false    411    404            �           1259    18948    CrmTeamTenant100    TABLE        CREATE TABLE public."CrmTeamTenant100" (
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
       public         heap    postgres    false    411    404            �           1259    18956    CrmTeamTenant2    TABLE     �  CREATE TABLE public."CrmTeamTenant2" (
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
       public         heap    postgres    false    411    404            �           1259    18964    CrmTeamTenant3    TABLE     �  CREATE TABLE public."CrmTeamTenant3" (
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
       public         heap    postgres    false    411    404            �           1259    18972    CrmUserActivityLog    TABLE     �  CREATE TABLE public."CrmUserActivityLog" (
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
       public            postgres    false            �           1259    18977 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmUserActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmUserActivityLog_ActivityId_seq";
       public          postgres    false    416            �           0    0 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmUserActivityLog_ActivityId_seq" OWNED BY public."CrmUserActivityLog"."ActivityId";
          public          postgres    false    417            �           1259    18978    CrmUserActivityLogTenant1    TABLE       CREATE TABLE public."CrmUserActivityLogTenant1" (
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
       public         heap    postgres    false    417    416            �           1259    18986    CrmUserActivityLogTenant100    TABLE     	  CREATE TABLE public."CrmUserActivityLogTenant100" (
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
       public         heap    postgres    false    417    416            �           1259    18994    CrmUserActivityLogTenant2    TABLE       CREATE TABLE public."CrmUserActivityLogTenant2" (
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
       public         heap    postgres    false    417    416            �           1259    19002    CrmUserActivityLogTenant3    TABLE       CREATE TABLE public."CrmUserActivityLogTenant3" (
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
       public         heap    postgres    false    417    416            �           1259    19010    CrmUserActivityType    TABLE     �   CREATE TABLE public."CrmUserActivityType" (
    "ActivityTypeId" integer NOT NULL,
    "ActivityTypeTitle" text NOT NULL,
    "Icon" character varying(50) NOT NULL,
    "IsDeleted" integer DEFAULT 0
);
 )   DROP TABLE public."CrmUserActivityType";
       public         heap    postgres    false            �           1259    19016 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq";
       public          postgres    false    422            �           0    0 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq" OWNED BY public."CrmUserActivityType"."ActivityTypeId";
          public          postgres    false    423            �           1259    19017    Tenant    TABLE     g  CREATE TABLE public."Tenant" (
    "TenantId" integer NOT NULL,
    "Name" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL
);
    DROP TABLE public."Tenant";
       public         heap    postgres    false            �           1259    19627    db2_aspnetusers    FOREIGN TABLE     �   CREATE FOREIGN TABLE public.db2_aspnetusers (
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
       public          postgres    false    2763            �           0    0    CrmAdAccount1    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    260    258            �           0    0    CrmAdAccount100    TABLE ATTACH     v   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    261    258            �           0    0    CrmAdAccount2    TABLE ATTACH     m   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    262    258            �           0    0    CrmAdAccount3    TABLE ATTACH     m   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    263    258            �           0    0    CrmCalenderEventsTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    268    266            �           0    0    CrmCalenderEventsTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    269    266            �           0    0    CrmCalenderEventsTenant2    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    270    266            �           0    0    CrmCalenderEventsTenant3    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    271    266            �           0    0    CrmCall1    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    274    272            �           0    0 
   CrmCall100    TABLE ATTACH     l   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    275    272            �           0    0    CrmCall2    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    276    272            �           0    0    CrmCall3    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    277    272            Y           0    0    CrmCampaign1    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    434    432            Z           0    0    CrmCampaign100    TABLE ATTACH     t   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    435    432            [           0    0    CrmCampaign2    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    436    432            X           0    0    CrmCampaign3    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmCampaign" ATTACH PARTITION public."CrmCampaign3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    433    432            �           0    0    CrmCompanyActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    281    279            �           0    0    CrmCompanyActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    282    279            �           0    0    CrmCompanyActivityLogTenant2    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    283    279            �           0    0    CrmCompanyActivityLogTenant3    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    284    279                        0    0    CrmCompanyMemberTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    287    285                       0    0    CrmCompanyMemberTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    288    285                       0    0    CrmCompanyMemberTenant2    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    289    285                       0    0    CrmCompanyMemberTenant3    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    290    285                       0    0    CrmCompanyTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    292    278                       0    0    CrmCompanyTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    293    278                       0    0    CrmCompanyTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    294    278                       0    0    CrmCompanyTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    295    278                       0    0    CrmCustomListsTenant1    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    298    296            	           0    0    CrmCustomListsTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    299    296            
           0    0    CrmCustomListsTenant2    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    300    296                       0    0    CrmCustomListsTenant3    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    301    296                       0    0 	   CrmEmail1    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    304    302                       0    0    CrmEmail100    TABLE ATTACH     n   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    305    302                       0    0 	   CrmEmail2    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    306    302                       0    0 	   CrmEmail3    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    307    302            \           0    0    CrmFormFields1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    439    438            _           0    0    CrmFormFields100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    442    438            ]           0    0    CrmFormFields2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    440    438            ^           0    0    CrmFormFields3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmFormFields" ATTACH PARTITION public."CrmFormFields3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    441    438            `           0    0    CrmFormResults1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    445    444            c           0    0    CrmFormResults100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    448    444            a           0    0    CrmFormResults2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    446    444            b           0    0    CrmFormResults3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmFormResults" ATTACH PARTITION public."CrmFormResults3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    447    444                       0    0    CrmIndustryTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    310    308                       0    0    CrmIndustryTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    311    308                       0    0    CrmIndustryTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    312    308                       0    0    CrmIndustryTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    313    308                       0    0    CrmLeadActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    317    315                       0    0    CrmLeadActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    318    315                       0    0    CrmLeadActivityLogTenant2    TABLE ATTACH        ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    319    315                       0    0    CrmLeadActivityLogTenant3    TABLE ATTACH        ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    320    315                       0    0    CrmLeadSourceTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    323    321                       0    0    CrmLeadSourceTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    324    321                       0    0    CrmLeadSourceTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    325    321                       0    0    CrmLeadSourceTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    326    321                       0    0    CrmLeadStatusTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    329    327                       0    0    CrmLeadStatusTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    330    327                       0    0    CrmLeadStatusTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    331    327                       0    0    CrmLeadStatusTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    332    327                        0    0    CrmLeadTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    334    314            !           0    0    CrmLeadTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    335    314            "           0    0    CrmLeadTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    336    314            #           0    0    CrmLeadTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    337    314            $           0    0    CrmMeeting1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    340    338            %           0    0    CrmMeeting100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    341    338            &           0    0    CrmMeeting2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    342    338            '           0    0    CrmMeeting3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    343    338            (           0    0    CrmNoteTagsTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    347    345            )           0    0    CrmNoteTagsTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    348    345            *           0    0    CrmNoteTagsTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    349    345            +           0    0    CrmNoteTagsTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    350    345            ,           0    0    CrmNoteTasksTenant1    TABLE ATTACH     y   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    353    351            -           0    0    CrmNoteTasksTenant100    TABLE ATTACH     |   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    354    351            .           0    0    CrmNoteTasksTenant2    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    355    351            /           0    0    CrmNoteTasksTenant3    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    356    351            0           0    0    CrmNoteTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    358    344            1           0    0    CrmNoteTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    359    344            2           0    0    CrmNoteTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    360    344            3           0    0    CrmNoteTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    361    344            4           0    0    CrmOpportunity1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    364    362            5           0    0    CrmOpportunity100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    365    362            6           0    0    CrmOpportunity2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    366    362            7           0    0    CrmOpportunity3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    367    362            8           0    0    CrmProductTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    372    370            9           0    0    CrmProductTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    373    370            :           0    0    CrmProductTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    374    370            ;           0    0    CrmProductTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    375    370            <           0    0    CrmTagUsedTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    378    376            =           0    0    CrmTagUsedTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    379    376            >           0    0    CrmTagUsedTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    380    376            ?           0    0    CrmTagUsedTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    381    376            @           0    0    CrmTagsTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    384    382            A           0    0    CrmTagsTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    385    382            B           0    0    CrmTagsTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    386    382            C           0    0    CrmTagsTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    387    382            D           0    0    CrmTaskTagsTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    395    393            E           0    0    CrmTaskTagsTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    396    393            F           0    0    CrmTaskTagsTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    397    393            G           0    0    CrmTaskTagsTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    398    393            H           0    0    CrmTaskTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    400    388            I           0    0    CrmTaskTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    401    388            J           0    0    CrmTaskTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    402    388            K           0    0    CrmTaskTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    403    388            L           0    0    CrmTeamMemberTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    407    405            M           0    0    CrmTeamMemberTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    408    405            N           0    0    CrmTeamMemberTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    409    405            O           0    0    CrmTeamMemberTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    410    405            P           0    0    CrmTeamTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    412    404            Q           0    0    CrmTeamTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    413    404            R           0    0    CrmTeamTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    414    404            S           0    0    CrmTeamTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    415    404            T           0    0    CrmUserActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    418    416            U           0    0    CrmUserActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    419    416            V           0    0    CrmUserActivityLogTenant2    TABLE ATTACH        ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    420    416            W           0    0    CrmUserActivityLogTenant3    TABLE ATTACH        ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    421    416            d           2604    19024    AppMenus MenuId    DEFAULT     x   ALTER TABLE ONLY public."AppMenus" ALTER COLUMN "MenuId" SET DEFAULT nextval('public."AppMenus_MenuId_seq"'::regclass);
 B   ALTER TABLE public."AppMenus" ALTER COLUMN "MenuId" DROP DEFAULT;
       public          postgres    false    257    256            g           2604    19025    CrmAdAccount AccountId    DEFAULT     �   ALTER TABLE ONLY public."CrmAdAccount" ALTER COLUMN "AccountId" SET DEFAULT nextval('public."CrmAdAccount_AccountId_seq"'::regclass);
 I   ALTER TABLE public."CrmAdAccount" ALTER COLUMN "AccountId" DROP DEFAULT;
       public          postgres    false    259    258            v           2604    19026    CrmCalendarEventsType TypeId    DEFAULT     �   ALTER TABLE ONLY public."CrmCalendarEventsType" ALTER COLUMN "TypeId" SET DEFAULT nextval('public."CrmCalendarEventsType_TypeId_seq"'::regclass);
 O   ALTER TABLE public."CrmCalendarEventsType" ALTER COLUMN "TypeId" DROP DEFAULT;
       public          postgres    false    265    264            x           2604    19027    CrmCalenderEvents EventId    DEFAULT     �   ALTER TABLE ONLY public."CrmCalenderEvents" ALTER COLUMN "EventId" SET DEFAULT nextval('public."CrmCalenderEvents_EventId_seq"'::regclass);
 L   ALTER TABLE public."CrmCalenderEvents" ALTER COLUMN "EventId" DROP DEFAULT;
       public          postgres    false    267    266            �           2604    19028    CrmCall CallId    DEFAULT     v   ALTER TABLE ONLY public."CrmCall" ALTER COLUMN "CallId" SET DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass);
 A   ALTER TABLE public."CrmCall" ALTER COLUMN "CallId" DROP DEFAULT;
       public          postgres    false    273    272            �           2604    19029    CrmCompany CompanyId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompany" ALTER COLUMN "CompanyId" SET DEFAULT nextval('public."CrmCompany_CompanyId_seq"'::regclass);
 G   ALTER TABLE public."CrmCompany" ALTER COLUMN "CompanyId" DROP DEFAULT;
       public          postgres    false    291    278            �           2604    19030     CrmCompanyActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmCompanyActivityLog_ActivityId_seq"'::regclass);
 S   ALTER TABLE public."CrmCompanyActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    280    279            �           2604    19031    CrmCompanyMember MemberId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompanyMember" ALTER COLUMN "MemberId" SET DEFAULT nextval('public."CrmCompanyMember_MemberId_seq"'::regclass);
 L   ALTER TABLE public."CrmCompanyMember" ALTER COLUMN "MemberId" DROP DEFAULT;
       public          postgres    false    286    285            �           2604    19032    CrmCustomLists ListId    DEFAULT     �   ALTER TABLE ONLY public."CrmCustomLists" ALTER COLUMN "ListId" SET DEFAULT nextval('public."CrmCustomLists_ListId_seq"'::regclass);
 H   ALTER TABLE public."CrmCustomLists" ALTER COLUMN "ListId" DROP DEFAULT;
       public          postgres    false    297    296            �           2604    19033    CrmEmail EmailId    DEFAULT     z   ALTER TABLE ONLY public."CrmEmail" ALTER COLUMN "EmailId" SET DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass);
 C   ALTER TABLE public."CrmEmail" ALTER COLUMN "EmailId" DROP DEFAULT;
       public          postgres    false    303    302            e           2604    20916    CrmFormFields FieldId    DEFAULT     �   ALTER TABLE ONLY public."CrmFormFields" ALTER COLUMN "FieldId" SET DEFAULT nextval('public."CrmFormFields_FieldId_seq"'::regclass);
 H   ALTER TABLE public."CrmFormFields" ALTER COLUMN "FieldId" DROP DEFAULT;
       public          postgres    false    437    438    438            t           2604    20970    CrmFormResults ResultId    DEFAULT     �   ALTER TABLE ONLY public."CrmFormResults" ALTER COLUMN "ResultId" SET DEFAULT nextval('public."CrmFormResults_ResultId_seq"'::regclass);
 J   ALTER TABLE public."CrmFormResults" ALTER COLUMN "ResultId" DROP DEFAULT;
       public          postgres    false    443    444    444            	           2604    19034    CrmIndustry IndustryId    DEFAULT     �   ALTER TABLE ONLY public."CrmIndustry" ALTER COLUMN "IndustryId" SET DEFAULT nextval('public."CrmIndustry_IndustryId_seq"'::regclass);
 I   ALTER TABLE public."CrmIndustry" ALTER COLUMN "IndustryId" DROP DEFAULT;
       public          postgres    false    309    308                       2604    19035    CrmLead LeadId    DEFAULT     v   ALTER TABLE ONLY public."CrmLead" ALTER COLUMN "LeadId" SET DEFAULT nextval('public."CrmLead_LeadId_seq"'::regclass);
 A   ALTER TABLE public."CrmLead" ALTER COLUMN "LeadId" DROP DEFAULT;
       public          postgres    false    333    314                       2604    19036    CrmLeadActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmLeadActivityLog_ActivityId_seq"'::regclass);
 P   ALTER TABLE public."CrmLeadActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    316    315            +           2604    19037    CrmLeadSource SourceId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadSource" ALTER COLUMN "SourceId" SET DEFAULT nextval('public."CrmLeadSource_SourceId_seq"'::regclass);
 I   ALTER TABLE public."CrmLeadSource" ALTER COLUMN "SourceId" DROP DEFAULT;
       public          postgres    false    322    321            :           2604    19038    CrmLeadStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmLeadStatus_StatusId_seq"'::regclass);
 I   ALTER TABLE public."CrmLeadStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    328    327            Y           2604    19039    CrmMeeting MeetingId    DEFAULT     �   ALTER TABLE ONLY public."CrmMeeting" ALTER COLUMN "MeetingId" SET DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass);
 G   ALTER TABLE public."CrmMeeting" ALTER COLUMN "MeetingId" DROP DEFAULT;
       public          postgres    false    339    338            m           2604    19040    CrmNote NoteId    DEFAULT     v   ALTER TABLE ONLY public."CrmNote" ALTER COLUMN "NoteId" SET DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass);
 A   ALTER TABLE public."CrmNote" ALTER COLUMN "NoteId" DROP DEFAULT;
       public          postgres    false    357    344            q           2604    19041    CrmNoteTags NoteTagsId    DEFAULT     �   ALTER TABLE ONLY public."CrmNoteTags" ALTER COLUMN "NoteTagsId" SET DEFAULT nextval('public."CrmNoteTags_NoteTagsId_seq"'::regclass);
 I   ALTER TABLE public."CrmNoteTags" ALTER COLUMN "NoteTagsId" DROP DEFAULT;
       public          postgres    false    346    345            �           2604    19042    CrmNoteTasks NoteTaskId    DEFAULT     �   ALTER TABLE ONLY public."CrmNoteTasks" ALTER COLUMN "NoteTaskId" SET DEFAULT nextval('public."CrmNoteTasks_NoteTaskId_seq"'::regclass);
 J   ALTER TABLE public."CrmNoteTasks" ALTER COLUMN "NoteTaskId" DROP DEFAULT;
       public          postgres    false    352    351            �           2604    19043    CrmOpportunity OpportunityId    DEFAULT     �   ALTER TABLE ONLY public."CrmOpportunity" ALTER COLUMN "OpportunityId" SET DEFAULT nextval('public."CrmOpportunity_OpportunityId_seq"'::regclass);
 O   ALTER TABLE public."CrmOpportunity" ALTER COLUMN "OpportunityId" DROP DEFAULT;
       public          postgres    false    363    362            �           2604    19045    CrmOpportunityStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmOpportunityStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmOpportunityStatus_StatusId_seq"'::regclass);
 P   ALTER TABLE public."CrmOpportunityStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    369    368            �           2604    19046    CrmProduct ProductId    DEFAULT     �   ALTER TABLE ONLY public."CrmProduct" ALTER COLUMN "ProductId" SET DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass);
 G   ALTER TABLE public."CrmProduct" ALTER COLUMN "ProductId" DROP DEFAULT;
       public          postgres    false    371    370            X           2604    19593    CrmProject ProjectId    DEFAULT     �   ALTER TABLE ONLY public."CrmProject" ALTER COLUMN "ProjectId" SET DEFAULT nextval('public."CrmProject_ProjectId_seq"'::regclass);
 G   ALTER TABLE public."CrmProject" ALTER COLUMN "ProjectId" DROP DEFAULT;
       public          postgres    false    429    430    430            �           2604    19047    CrmTagUsed TagUsedId    DEFAULT     �   ALTER TABLE ONLY public."CrmTagUsed" ALTER COLUMN "TagUsedId" SET DEFAULT nextval('public."CrmTagUsed_TagUsedId_seq"'::regclass);
 G   ALTER TABLE public."CrmTagUsed" ALTER COLUMN "TagUsedId" DROP DEFAULT;
       public          postgres    false    377    376            �           2604    19048    CrmTags TagId    DEFAULT     t   ALTER TABLE ONLY public."CrmTags" ALTER COLUMN "TagId" SET DEFAULT nextval('public."CrmTags_TagId_seq"'::regclass);
 @   ALTER TABLE public."CrmTags" ALTER COLUMN "TagId" DROP DEFAULT;
       public          postgres    false    383    382            �           2604    19049    CrmTask TaskId    DEFAULT     v   ALTER TABLE ONLY public."CrmTask" ALTER COLUMN "TaskId" SET DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass);
 A   ALTER TABLE public."CrmTask" ALTER COLUMN "TaskId" DROP DEFAULT;
       public          postgres    false    399    388            �           2604    19050    CrmTaskPriority PriorityId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskPriority" ALTER COLUMN "PriorityId" SET DEFAULT nextval('public."CrmTaskPriority_PriorityId_seq"'::regclass);
 M   ALTER TABLE public."CrmTaskPriority" ALTER COLUMN "PriorityId" DROP DEFAULT;
       public          postgres    false    390    389            �           2604    19051    CrmTaskStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmTaskStatus_StatusId_seq"'::regclass);
 I   ALTER TABLE public."CrmTaskStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    392    391            �           2604    19052    CrmTaskTags TaskTagsId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskTags" ALTER COLUMN "TaskTagsId" SET DEFAULT nextval('public."CrmTaskTags_TaskTagsId_seq"'::regclass);
 I   ALTER TABLE public."CrmTaskTags" ALTER COLUMN "TaskTagsId" DROP DEFAULT;
       public          postgres    false    394    393                       2604    19053    CrmTeam TeamId    DEFAULT     v   ALTER TABLE ONLY public."CrmTeam" ALTER COLUMN "TeamId" SET DEFAULT nextval('public."CrmTeam_TeamId_seq"'::regclass);
 A   ALTER TABLE public."CrmTeam" ALTER COLUMN "TeamId" DROP DEFAULT;
       public          postgres    false    411    404                       2604    19054    CrmTeamMember TeamMemberId    DEFAULT     �   ALTER TABLE ONLY public."CrmTeamMember" ALTER COLUMN "TeamMemberId" SET DEFAULT nextval('public."CrmTeamMember_TeamMemberId_seq"'::regclass);
 M   ALTER TABLE public."CrmTeamMember" ALTER COLUMN "TeamMemberId" DROP DEFAULT;
       public          postgres    false    406    405            9           2604    19055    CrmUserActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmUserActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmUserActivityLog_ActivityId_seq"'::regclass);
 P   ALTER TABLE public."CrmUserActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    417    416            R           2604    19056 "   CrmUserActivityType ActivityTypeId    DEFAULT     �   ALTER TABLE ONLY public."CrmUserActivityType" ALTER COLUMN "ActivityTypeId" SET DEFAULT nextval('public."CrmUserActivityType_ActivityTypeId_seq"'::regclass);
 U   ALTER TABLE public."CrmUserActivityType" ALTER COLUMN "ActivityTypeId" DROP DEFAULT;
       public          postgres    false    423    422            �          0    17950    AppMenus 
   TABLE DATA           �   COPY public."AppMenus" ("MenuId", "Code", "Title", "Subtitle", "Type", "Icon", "Link", "Level", "CreatedBy", "CreatedOn", "LastModifiedBy", "LastModifiedOn", "IsDeleted", "ParentId", "Order") FROM stdin;
    public          postgres    false    256   �      �          0    17964    CrmAdAccount1 
   TABLE DATA           �   COPY public."CrmAdAccount1" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    260   �      �          0    17972    CrmAdAccount100 
   TABLE DATA           �   COPY public."CrmAdAccount100" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    261   �      �          0    17980    CrmAdAccount2 
   TABLE DATA           �   COPY public."CrmAdAccount2" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    262         �          0    17988    CrmAdAccount3 
   TABLE DATA           �   COPY public."CrmAdAccount3" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    263   !      �          0    17996    CrmCalendarEventsType 
   TABLE DATA           U   COPY public."CrmCalendarEventsType" ("TypeId", "TypeTitle", "IsDeleted") FROM stdin;
    public          postgres    false    264   >      �          0    18009    CrmCalenderEventsTenant1 
   TABLE DATA             COPY public."CrmCalenderEventsTenant1" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    268   �      �          0    18017    CrmCalenderEventsTenant100 
   TABLE DATA             COPY public."CrmCalenderEventsTenant100" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    269   ;      �          0    18025    CrmCalenderEventsTenant2 
   TABLE DATA             COPY public."CrmCalenderEventsTenant2" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    270   X      �          0    18033    CrmCalenderEventsTenant3 
   TABLE DATA             COPY public."CrmCalenderEventsTenant3" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "AllDay", "ActivityId", "ContactTypeId", "ContactActivityId") FROM stdin;
    public          postgres    false    271   u      �          0    18047    CrmCall1 
   TABLE DATA           �   COPY public."CrmCall1" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId") FROM stdin;
    public          postgres    false    274   �      �          0    18055 
   CrmCall100 
   TABLE DATA           �   COPY public."CrmCall100" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId") FROM stdin;
    public          postgres    false    275         �          0    18063    CrmCall2 
   TABLE DATA           �   COPY public."CrmCall2" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId") FROM stdin;
    public          postgres    false    276   !      �          0    18071    CrmCall3 
   TABLE DATA           �   COPY public."CrmCall3" ("CallId", "Subject", "Response", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ReasonId", "TaskId", "ContactTypeId") FROM stdin;
    public          postgres    false    277   >      a          0    20417    CrmCampaign1 
   TABLE DATA           �   COPY public."CrmCampaign1" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    434   [      b          0    20427    CrmCampaign100 
   TABLE DATA           �   COPY public."CrmCampaign100" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    435   �      c          0    20437    CrmCampaign2 
   TABLE DATA           �   COPY public."CrmCampaign2" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    436         `          0    20406    CrmCampaign3 
   TABLE DATA           �   COPY public."CrmCampaign3" ("CampaignId", "AdAccountId", "Title", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "SourceId", "Budget") FROM stdin;
    public          postgres    false    433   "      �          0    18090    CrmCompanyActivityLogTenant1 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant1" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    281   ?      �          0    18098    CrmCompanyActivityLogTenant100 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant100" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    282   \      �          0    18106    CrmCompanyActivityLogTenant2 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant2" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    283   y      �          0    18114    CrmCompanyActivityLogTenant3 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant3" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    284   �      �          0    18128    CrmCompanyMemberTenant1 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant1" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    287   �      �          0    18136    CrmCompanyMemberTenant100 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant100" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    288   �      �          0    18144    CrmCompanyMemberTenant2 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant2" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    289   �      �          0    18152    CrmCompanyMemberTenant3 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant3" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    290   
      �          0    18161    CrmCompanyTenant1 
   TABLE DATA           �  COPY public."CrmCompanyTenant1" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    292   '      �          0    18169    CrmCompanyTenant100 
   TABLE DATA           �  COPY public."CrmCompanyTenant100" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    293   D      �          0    18177    CrmCompanyTenant2 
   TABLE DATA           �  COPY public."CrmCompanyTenant2" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    294   a      �          0    18185    CrmCompanyTenant3 
   TABLE DATA           �  COPY public."CrmCompanyTenant3" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    295   ~      �          0    18200    CrmCustomListsTenant1 
   TABLE DATA           �   COPY public."CrmCustomListsTenant1" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    298   �      �          0    18209    CrmCustomListsTenant100 
   TABLE DATA           �   COPY public."CrmCustomListsTenant100" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    299   �      �          0    18218    CrmCustomListsTenant2 
   TABLE DATA           �   COPY public."CrmCustomListsTenant2" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    300   �      �          0    18227    CrmCustomListsTenant3 
   TABLE DATA           �   COPY public."CrmCustomListsTenant3" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    301   �      �          0    18242 	   CrmEmail1 
   TABLE DATA           �   COPY public."CrmEmail1" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    304   
      �          0    18250    CrmEmail100 
   TABLE DATA           �   COPY public."CrmEmail100" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    305   �      �          0    18258 	   CrmEmail2 
   TABLE DATA           �   COPY public."CrmEmail2" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    306   �      �          0    18266 	   CrmEmail3 
   TABLE DATA           �   COPY public."CrmEmail3" ("EmailId", "Subject", "Description", "Reply", "Id", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "ContactTypeId") FROM stdin;
    public          postgres    false    307   �      e          0    20921    CrmFormFields1 
   TABLE DATA           �   COPY public."CrmFormFields1" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    439   �      h          0    20951    CrmFormFields100 
   TABLE DATA           �   COPY public."CrmFormFields100" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    442   
      f          0    20931    CrmFormFields2 
   TABLE DATA           �   COPY public."CrmFormFields2" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    440   '      g          0    20941    CrmFormFields3 
   TABLE DATA           �   COPY public."CrmFormFields3" ("FieldId", "FormId", "FieldLabel", "FieldType", "Placeholder", "Values", "IsFixed", "Order", "DisplayLabel", "CSS", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    441   D      j          0    20975    CrmFormResults1 
   TABLE DATA           �   COPY public."CrmFormResults1" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    445   a      m          0    21005    CrmFormResults100 
   TABLE DATA           �   COPY public."CrmFormResults100" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    448   ~      k          0    20985    CrmFormResults2 
   TABLE DATA           �   COPY public."CrmFormResults2" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    446   �      l          0    20995    CrmFormResults3 
   TABLE DATA           �   COPY public."CrmFormResults3" ("ResultId", "FormId", "FieldId", "Result", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    447   �      \          0    19571    CrmICallScenarios 
   TABLE DATA           k   COPY public."CrmICallScenarios" ("ReasonId", "Title", "IsTask", "IsShowResponse", "IsDeleted") FROM stdin;
    public          postgres    false    426   �      �          0    18280    CrmIndustryTenant1 
   TABLE DATA           �   COPY public."CrmIndustryTenant1" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    310   �      �          0    18288    CrmIndustryTenant100 
   TABLE DATA           �   COPY public."CrmIndustryTenant100" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    311   �      �          0    18296    CrmIndustryTenant2 
   TABLE DATA           �   COPY public."CrmIndustryTenant2" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    312   �      �          0    18304    CrmIndustryTenant3 
   TABLE DATA           �   COPY public."CrmIndustryTenant3" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    313   �      �          0    18323    CrmLeadActivityLogTenant1 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant1" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    317   �      �          0    18331    CrmLeadActivityLogTenant100 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant100" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    318   �                 0    18339    CrmLeadActivityLogTenant2 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant2" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    319                    0    18347    CrmLeadActivityLogTenant3 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant3" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    320   9                 0    18361    CrmLeadSourceTenant1 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant1" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    323   V                 0    18369    CrmLeadSourceTenant100 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant100" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    324   !                0    18377    CrmLeadSourceTenant2 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant2" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    325   !!                0    18385    CrmLeadSourceTenant3 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant3" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    326   >!                0    18399    CrmLeadStatusTenant1 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant1" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    329   [!      	          0    18407    CrmLeadStatusTenant100 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant100" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    330   �!      
          0    18415    CrmLeadStatusTenant2 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant2" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    331   "                0    18423    CrmLeadStatusTenant3 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant3" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    332   ("                0    18432    CrmLeadTenant1 
   TABLE DATA           G  COPY public."CrmLeadTenant1" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    334   E"                0    18440    CrmLeadTenant100 
   TABLE DATA           I  COPY public."CrmLeadTenant100" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    335   �'                0    18448    CrmLeadTenant2 
   TABLE DATA           G  COPY public."CrmLeadTenant2" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    336   (                0    18456    CrmLeadTenant3 
   TABLE DATA           G  COPY public."CrmLeadTenant3" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId", "CampaignId") FROM stdin;
    public          postgres    false    337   7(                0    18470    CrmMeeting1 
   TABLE DATA           �   COPY public."CrmMeeting1" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId") FROM stdin;
    public          postgres    false    340   T(                0    18478    CrmMeeting100 
   TABLE DATA           �   COPY public."CrmMeeting100" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId") FROM stdin;
    public          postgres    false    341   �(                0    18486    CrmMeeting2 
   TABLE DATA           �   COPY public."CrmMeeting2" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId") FROM stdin;
    public          postgres    false    342   �(                0    18494    CrmMeeting3 
   TABLE DATA           �   COPY public."CrmMeeting3" ("MeetingId", "Subject", "Note", "Id", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ContactTypeId") FROM stdin;
    public          postgres    false    343    )                0    18513    CrmNoteTagsTenant1 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant1" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    347   )                0    18521    CrmNoteTagsTenant100 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant100" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    348   :)                0    18529    CrmNoteTagsTenant2 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant2" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    349   W)                0    18537    CrmNoteTagsTenant3 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant3" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    350   t)                0    18551    CrmNoteTasksTenant1 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant1" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    353   �)                0    18559    CrmNoteTasksTenant100 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant100" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    354   �)                0    18567    CrmNoteTasksTenant2 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant2" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    355   �)                0    18575    CrmNoteTasksTenant3 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant3" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    356   �)      !          0    18584    CrmNoteTenant1 
   TABLE DATA           �   COPY public."CrmNoteTenant1" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    358   *      "          0    18592    CrmNoteTenant100 
   TABLE DATA           �   COPY public."CrmNoteTenant100" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    359   �*      #          0    18600    CrmNoteTenant2 
   TABLE DATA           �   COPY public."CrmNoteTenant2" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    360   �*      $          0    18608    CrmNoteTenant3 
   TABLE DATA           �   COPY public."CrmNoteTenant3" ("NoteId", "Content", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "ContactTypeId") FROM stdin;
    public          postgres    false    361   �*      &          0    18622    CrmOpportunity1 
   TABLE DATA           J  COPY public."CrmOpportunity1" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    364   �*      '          0    18630    CrmOpportunity100 
   TABLE DATA           L  COPY public."CrmOpportunity100" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    365   �*      (          0    18638    CrmOpportunity2 
   TABLE DATA           J  COPY public."CrmOpportunity2" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    366   +      )          0    18646    CrmOpportunity3 
   TABLE DATA           J  COPY public."CrmOpportunity3" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    367   9+      *          0    18662    CrmOpportunityStatus 
   TABLE DATA           �   COPY public."CrmOpportunityStatus" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    368   V+      -          0    18676    CrmProductTenant1 
   TABLE DATA           �   COPY public."CrmProductTenant1" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    372   �+      .          0    18684    CrmProductTenant100 
   TABLE DATA           �   COPY public."CrmProductTenant100" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    373   ,      /          0    18692    CrmProductTenant2 
   TABLE DATA           �   COPY public."CrmProductTenant2" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    374   !,      0          0    18700    CrmProductTenant3 
   TABLE DATA           �   COPY public."CrmProductTenant3" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProjectId") FROM stdin;
    public          postgres    false    375   >,      ^          0    19581    CrmStatusLog 
   TABLE DATA           �   COPY public."CrmStatusLog" ("CreatedOn", "Details", "LogId", "TypeId", "StatusTtile", "CreatedBy", "ActionId", "TenantId", "StatusId") FROM stdin;
    public          postgres    false    428   [,      2          0    18714    CrmTagUsedTenant1 
   TABLE DATA           �   COPY public."CrmTagUsedTenant1" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    378   �-      3          0    18722    CrmTagUsedTenant100 
   TABLE DATA           �   COPY public."CrmTagUsedTenant100" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    379   
.      4          0    18730    CrmTagUsedTenant2 
   TABLE DATA           �   COPY public."CrmTagUsedTenant2" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    380   '.      5          0    18738    CrmTagUsedTenant3 
   TABLE DATA           �   COPY public."CrmTagUsedTenant3" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    381   D.      7          0    18752    CrmTagsTenant1 
   TABLE DATA           �   COPY public."CrmTagsTenant1" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    384   a.      8          0    18760    CrmTagsTenant100 
   TABLE DATA           �   COPY public."CrmTagsTenant100" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    385   �/      9          0    18768    CrmTagsTenant2 
   TABLE DATA           �   COPY public."CrmTagsTenant2" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    386   �/      :          0    18776    CrmTagsTenant3 
   TABLE DATA           �   COPY public."CrmTagsTenant3" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    387   �/      ;          0    18793    CrmTaskPriority 
   TABLE DATA           �   COPY public."CrmTaskPriority" ("PriorityId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "PriorityTitle") FROM stdin;
    public          postgres    false    389   	0      =          0    18801    CrmTaskStatus 
   TABLE DATA           �   COPY public."CrmTaskStatus" ("StatusId", "StatusTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted") FROM stdin;
    public          postgres    false    391   }0      @          0    18815    CrmTaskTagsTenant1 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant1" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    395   "1      A          0    18823    CrmTaskTagsTenant100 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant100" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    396   �5      B          0    18831    CrmTaskTagsTenant2 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant2" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    397   �5      C          0    18839    CrmTaskTagsTenant3 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant3" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    398   �5      E          0    18848    CrmTaskTenant1 
   TABLE DATA             COPY public."CrmTaskTenant1" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    400   6      F          0    18860    CrmTaskTenant100 
   TABLE DATA             COPY public."CrmTaskTenant100" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    401   �6      G          0    18872    CrmTaskTenant2 
   TABLE DATA             COPY public."CrmTaskTenant2" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    402   �6      H          0    18884    CrmTaskTenant3 
   TABLE DATA             COPY public."CrmTaskTenant3" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "ContactTypeId", "TaskTypeId") FROM stdin;
    public          postgres    false    403   �6      J          0    18907    CrmTeamMemberTenant1 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant1" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    407   7      K          0    18915    CrmTeamMemberTenant100 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant100" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    408   /7      L          0    18923    CrmTeamMemberTenant2 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant2" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    409   L7      M          0    18931    CrmTeamMemberTenant3 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant3" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    410   i7      O          0    18940    CrmTeamTenant1 
   TABLE DATA           �   COPY public."CrmTeamTenant1" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    412   �7      P          0    18948    CrmTeamTenant100 
   TABLE DATA           �   COPY public."CrmTeamTenant100" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    413   �7      Q          0    18956    CrmTeamTenant2 
   TABLE DATA           �   COPY public."CrmTeamTenant2" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    414   �7      R          0    18964    CrmTeamTenant3 
   TABLE DATA           �   COPY public."CrmTeamTenant3" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    415   �7      T          0    18978    CrmUserActivityLogTenant1 
   TABLE DATA           
  COPY public."CrmUserActivityLogTenant1" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    418   �7      U          0    18986    CrmUserActivityLogTenant100 
   TABLE DATA             COPY public."CrmUserActivityLogTenant100" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    419   9      V          0    18994    CrmUserActivityLogTenant2 
   TABLE DATA           
  COPY public."CrmUserActivityLogTenant2" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    420   9      W          0    19002    CrmUserActivityLogTenant3 
   TABLE DATA           
  COPY public."CrmUserActivityLogTenant3" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "ContactTypeId", "ContactActivityId", "Action") FROM stdin;
    public          postgres    false    421   ;9      X          0    19010    CrmUserActivityType 
   TABLE DATA           k   COPY public."CrmUserActivityType" ("ActivityTypeId", "ActivityTypeTitle", "Icon", "IsDeleted") FROM stdin;
    public          postgres    false    422   X9      Z          0    19017    Tenant 
   TABLE DATA           �   COPY public."Tenant" ("TenantId", "Name", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted") FROM stdin;
    public          postgres    false    424   �9      �           0    0    AppMenus_MenuId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."AppMenus_MenuId_seq"', 38, true);
          public          postgres    false    257            �           0    0    CrmAdAccount_AccountId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmAdAccount_AccountId_seq"', 1, false);
          public          postgres    false    259            �           0    0     CrmCalendarEventsType_TypeId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmCalendarEventsType_TypeId_seq"', 12, true);
          public          postgres    false    265            �           0    0    CrmCalenderEvents_EventId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmCalenderEvents_EventId_seq"', 126, true);
          public          postgres    false    267            �           0    0    CrmCall_CallId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmCall_CallId_seq"', 55, true);
          public          postgres    false    273            �           0    0 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."CrmCompanyActivityLog_ActivityId_seq"', 1, false);
          public          postgres    false    280            �           0    0    CrmCompanyMember_MemberId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CrmCompanyMember_MemberId_seq"', 1, false);
          public          postgres    false    286            �           0    0    CrmCompany_CompanyId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmCompany_CompanyId_seq"', 19, true);
          public          postgres    false    291            �           0    0    CrmCustomLists_ListId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmCustomLists_ListId_seq"', 35, true);
          public          postgres    false    297            �           0    0    CrmEmail_EmailId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."CrmEmail_EmailId_seq"', 52, true);
          public          postgres    false    303            �           0    0    CrmFormFields_FieldId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmFormFields_FieldId_seq"', 25, true);
          public          postgres    false    437            �           0    0    CrmFormResults_ResultId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CrmFormResults_ResultId_seq"', 1, false);
          public          postgres    false    443            �           0    0    CrmICallScenarios_ReasonId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmICallScenarios_ReasonId_seq"', 1, false);
          public          postgres    false    425            �           0    0    CrmIndustry_IndustryId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmIndustry_IndustryId_seq"', 20, true);
          public          postgres    false    309            �           0    0 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public."CrmLeadActivityLog_ActivityId_seq"', 1, false);
          public          postgres    false    316            �           0    0    CrmLeadSource_SourceId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmLeadSource_SourceId_seq"', 7, true);
          public          postgres    false    322            �           0    0    CrmLeadStatus_StatusId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmLeadStatus_StatusId_seq"', 9, true);
          public          postgres    false    328            �           0    0    CrmLead_LeadId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."CrmLead_LeadId_seq"', 356, true);
          public          postgres    false    333            �           0    0    CrmMeeting_MeetingId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmMeeting_MeetingId_seq"', 24, true);
          public          postgres    false    339            �           0    0    CrmNoteTags_NoteTagsId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmNoteTags_NoteTagsId_seq"', 33, true);
          public          postgres    false    346            �           0    0    CrmNoteTasks_NoteTaskId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CrmNoteTasks_NoteTaskId_seq"', 46, true);
          public          postgres    false    352            �           0    0    CrmNote_NoteId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmNote_NoteId_seq"', 35, true);
          public          postgres    false    357            �           0    0 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmOpportunityStatus_StatusId_seq"', 6, true);
          public          postgres    false    369            �           0    0     CrmOpportunity_OpportunityId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmOpportunity_OpportunityId_seq"', 20, true);
          public          postgres    false    363            �           0    0    CrmProduct_ProductId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmProduct_ProductId_seq"', 22, true);
          public          postgres    false    371            �           0    0    CrmProject_ProjectId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmProject_ProjectId_seq"', 1, false);
          public          postgres    false    429            �           0    0    CrmStatusLog_LogId_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CrmStatusLog_LogId_seq"', 60, true);
          public          postgres    false    427            �           0    0    CrmTagUsed_TagUsedId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmTagUsed_TagUsedId_seq"', 1, false);
          public          postgres    false    377            �           0    0    CrmTags_TagId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."CrmTags_TagId_seq"', 37, true);
          public          postgres    false    383            �           0    0    CrmTaskPriority_PriorityId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmTaskPriority_PriorityId_seq"', 1, false);
          public          postgres    false    390            �           0    0    CrmTaskStatus_StatusId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmTaskStatus_StatusId_seq"', 4, true);
          public          postgres    false    392            �           0    0    CrmTaskTags_TaskTagsId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CrmTaskTags_TaskTagsId_seq"', 240, true);
          public          postgres    false    394            �           0    0    CrmTask_TaskId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmTask_TaskId_seq"', 72, true);
          public          postgres    false    399            �           0    0    CrmTeamMember_TeamMemberId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmTeamMember_TeamMemberId_seq"', 15, true);
          public          postgres    false    406            �           0    0    CrmTeam_TeamId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."CrmTeam_TeamId_seq"', 4, true);
          public          postgres    false    411            �           0    0 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."CrmUserActivityLog_ActivityId_seq"', 249, true);
          public          postgres    false    417            �           0    0 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public."CrmUserActivityType_ActivityTypeId_seq"', 5, true);
          public          postgres    false    423            �           2606    19058    CrmAdAccount CrmAdAccount_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmAdAccount"
    ADD CONSTRAINT "CrmAdAccount_pkey" PRIMARY KEY ("AccountId", "TenantId");
 L   ALTER TABLE ONLY public."CrmAdAccount" DROP CONSTRAINT "CrmAdAccount_pkey";
       public            postgres    false    258    258            �           2606    19060 $   CrmAdAccount100 CrmAdAccount100_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public."CrmAdAccount100"
    ADD CONSTRAINT "CrmAdAccount100_pkey" PRIMARY KEY ("AccountId", "TenantId");
 R   ALTER TABLE ONLY public."CrmAdAccount100" DROP CONSTRAINT "CrmAdAccount100_pkey";
       public            postgres    false    6022    261    261    261            �           2606    19062     CrmAdAccount1 CrmAdAccount1_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount1"
    ADD CONSTRAINT "CrmAdAccount1_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount1" DROP CONSTRAINT "CrmAdAccount1_pkey";
       public            postgres    false    260    6022    260    260            �           2606    19064     CrmAdAccount2 CrmAdAccount2_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount2"
    ADD CONSTRAINT "CrmAdAccount2_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount2" DROP CONSTRAINT "CrmAdAccount2_pkey";
       public            postgres    false    6022    262    262    262            �           2606    19066     CrmAdAccount3 CrmAdAccount3_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount3"
    ADD CONSTRAINT "CrmAdAccount3_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount3" DROP CONSTRAINT "CrmAdAccount3_pkey";
       public            postgres    false    263    6022    263    263            �           2606    19068 0   CrmCalendarEventsType CrmCalendarEventsType_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."CrmCalendarEventsType"
    ADD CONSTRAINT "CrmCalendarEventsType_pkey" PRIMARY KEY ("TypeId");
 ^   ALTER TABLE ONLY public."CrmCalendarEventsType" DROP CONSTRAINT "CrmCalendarEventsType_pkey";
       public            postgres    false    264            �           2606    19070 (   CrmCalenderEvents CrmCalenderEvents_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."CrmCalenderEvents"
    ADD CONSTRAINT "CrmCalenderEvents_pkey" PRIMARY KEY ("EventId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCalenderEvents" DROP CONSTRAINT "CrmCalenderEvents_pkey";
       public            postgres    false    266    266            �           2606    19072 :   CrmCalenderEventsTenant100 CrmCalenderEventsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant100"
    ADD CONSTRAINT "CrmCalenderEventsTenant100_pkey" PRIMARY KEY ("EventId", "TenantId");
 h   ALTER TABLE ONLY public."CrmCalenderEventsTenant100" DROP CONSTRAINT "CrmCalenderEventsTenant100_pkey";
       public            postgres    false    6039    269    269    269            �           2606    19074 6   CrmCalenderEventsTenant1 CrmCalenderEventsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant1"
    ADD CONSTRAINT "CrmCalenderEventsTenant1_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant1" DROP CONSTRAINT "CrmCalenderEventsTenant1_pkey";
       public            postgres    false    6039    268    268    268            �           2606    19076 6   CrmCalenderEventsTenant2 CrmCalenderEventsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant2"
    ADD CONSTRAINT "CrmCalenderEventsTenant2_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant2" DROP CONSTRAINT "CrmCalenderEventsTenant2_pkey";
       public            postgres    false    6039    270    270    270            �           2606    19078 6   CrmCalenderEventsTenant3 CrmCalenderEventsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant3"
    ADD CONSTRAINT "CrmCalenderEventsTenant3_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant3" DROP CONSTRAINT "CrmCalenderEventsTenant3_pkey";
       public            postgres    false    6039    271    271    271            �           2606    19080    CrmCall CrmCall_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmCall"
    ADD CONSTRAINT "CrmCall_pkey" PRIMARY KEY ("CallId", "TenantId");
 B   ALTER TABLE ONLY public."CrmCall" DROP CONSTRAINT "CrmCall_pkey";
       public            postgres    false    272    272            �           2606    19082    CrmCall100 CrmCall100_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CrmCall100"
    ADD CONSTRAINT "CrmCall100_pkey" PRIMARY KEY ("CallId", "TenantId");
 H   ALTER TABLE ONLY public."CrmCall100" DROP CONSTRAINT "CrmCall100_pkey";
       public            postgres    false    275    6054    275    275            �           2606    19084    CrmCall1 CrmCall1_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall1"
    ADD CONSTRAINT "CrmCall1_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall1" DROP CONSTRAINT "CrmCall1_pkey";
       public            postgres    false    274    6054    274    274            �           2606    19086    CrmCall2 CrmCall2_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall2"
    ADD CONSTRAINT "CrmCall2_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall2" DROP CONSTRAINT "CrmCall2_pkey";
       public            postgres    false    276    276    276    6054            �           2606    19088    CrmCall3 CrmCall3_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall3"
    ADD CONSTRAINT "CrmCall3_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall3" DROP CONSTRAINT "CrmCall3_pkey";
       public            postgres    false    277    6054    277    277            %           2606    20405    CrmCampaign CrmCampaign_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmCampaign"
    ADD CONSTRAINT "CrmCampaign_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 J   ALTER TABLE ONLY public."CrmCampaign" DROP CONSTRAINT "CrmCampaign_pkey";
       public            postgres    false    432    432            /           2606    20433 "   CrmCampaign100 CrmCampaign100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmCampaign100"
    ADD CONSTRAINT "CrmCampaign100_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 P   ALTER TABLE ONLY public."CrmCampaign100" DROP CONSTRAINT "CrmCampaign100_pkey";
       public            postgres    false    435    435    435    6437            ,           2606    20423    CrmCampaign1 CrmCampaign1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCampaign1"
    ADD CONSTRAINT "CrmCampaign1_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 L   ALTER TABLE ONLY public."CrmCampaign1" DROP CONSTRAINT "CrmCampaign1_pkey";
       public            postgres    false    6437    434    434    434            2           2606    20443    CrmCampaign2 CrmCampaign2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCampaign2"
    ADD CONSTRAINT "CrmCampaign2_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 L   ALTER TABLE ONLY public."CrmCampaign2" DROP CONSTRAINT "CrmCampaign2_pkey";
       public            postgres    false    436    436    6437    436            )           2606    20412    CrmCampaign3 CrmCampaign3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCampaign3"
    ADD CONSTRAINT "CrmCampaign3_pkey" PRIMARY KEY ("CampaignId", "TenantId");
 L   ALTER TABLE ONLY public."CrmCampaign3" DROP CONSTRAINT "CrmCampaign3_pkey";
       public            postgres    false    433    433    433    6437            �           2606    19090 0   CrmCompanyActivityLog CrmCompanyActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLog"
    ADD CONSTRAINT "CrmCompanyActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCompanyActivityLog" DROP CONSTRAINT "CrmCompanyActivityLog_pkey";
       public            postgres    false    279    279            �           2606    19092 B   CrmCompanyActivityLogTenant100 CrmCompanyActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant100"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 p   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant100" DROP CONSTRAINT "CrmCompanyActivityLogTenant100_pkey";
       public            postgres    false    282    282    282    6072            �           2606    19094 >   CrmCompanyActivityLogTenant1 CrmCompanyActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant1"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant1" DROP CONSTRAINT "CrmCompanyActivityLogTenant1_pkey";
       public            postgres    false    6072    281    281    281            �           2606    19096 >   CrmCompanyActivityLogTenant2 CrmCompanyActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant2"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant2" DROP CONSTRAINT "CrmCompanyActivityLogTenant2_pkey";
       public            postgres    false    283    283    6072    283            �           2606    19098 >   CrmCompanyActivityLogTenant3 CrmCompanyActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant3"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant3" DROP CONSTRAINT "CrmCompanyActivityLogTenant3_pkey";
       public            postgres    false    284    284    6072    284            �           2606    19100 &   CrmCompanyMember CrmCompanyMember_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."CrmCompanyMember"
    ADD CONSTRAINT "CrmCompanyMember_pkey" PRIMARY KEY ("MemberId", "TenantId");
 T   ALTER TABLE ONLY public."CrmCompanyMember" DROP CONSTRAINT "CrmCompanyMember_pkey";
       public            postgres    false    285    285            �           2606    19102 8   CrmCompanyMemberTenant100 CrmCompanyMemberTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant100"
    ADD CONSTRAINT "CrmCompanyMemberTenant100_pkey" PRIMARY KEY ("MemberId", "TenantId");
 f   ALTER TABLE ONLY public."CrmCompanyMemberTenant100" DROP CONSTRAINT "CrmCompanyMemberTenant100_pkey";
       public            postgres    false    6087    288    288    288            �           2606    19104 4   CrmCompanyMemberTenant1 CrmCompanyMemberTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant1"
    ADD CONSTRAINT "CrmCompanyMemberTenant1_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant1" DROP CONSTRAINT "CrmCompanyMemberTenant1_pkey";
       public            postgres    false    6087    287    287    287            �           2606    19106 4   CrmCompanyMemberTenant2 CrmCompanyMemberTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant2"
    ADD CONSTRAINT "CrmCompanyMemberTenant2_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant2" DROP CONSTRAINT "CrmCompanyMemberTenant2_pkey";
       public            postgres    false    6087    289    289    289            �           2606    19108 4   CrmCompanyMemberTenant3 CrmCompanyMemberTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant3"
    ADD CONSTRAINT "CrmCompanyMemberTenant3_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant3" DROP CONSTRAINT "CrmCompanyMemberTenant3_pkey";
       public            postgres    false    290    290    6087    290            �           2606    19110    CrmCompany CrmCompany_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmCompany"
    ADD CONSTRAINT "CrmCompany_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 H   ALTER TABLE ONLY public."CrmCompany" DROP CONSTRAINT "CrmCompany_pkey";
       public            postgres    false    278    278            �           2606    19112 ,   CrmCompanyTenant100 CrmCompanyTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyTenant100"
    ADD CONSTRAINT "CrmCompanyTenant100_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmCompanyTenant100" DROP CONSTRAINT "CrmCompanyTenant100_pkey";
       public            postgres    false    6069    293    293    293            �           2606    19114 (   CrmCompanyTenant1 CrmCompanyTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant1"
    ADD CONSTRAINT "CrmCompanyTenant1_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant1" DROP CONSTRAINT "CrmCompanyTenant1_pkey";
       public            postgres    false    292    292    6069    292            �           2606    19116 (   CrmCompanyTenant2 CrmCompanyTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant2"
    ADD CONSTRAINT "CrmCompanyTenant2_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant2" DROP CONSTRAINT "CrmCompanyTenant2_pkey";
       public            postgres    false    6069    294    294    294            �           2606    19118 (   CrmCompanyTenant3 CrmCompanyTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant3"
    ADD CONSTRAINT "CrmCompanyTenant3_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant3" DROP CONSTRAINT "CrmCompanyTenant3_pkey";
       public            postgres    false    295    295    295    6069            �           2606    19120 "   CrmCustomLists CrmCustomLists_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCustomLists"
    ADD CONSTRAINT "CrmCustomLists_pkey" PRIMARY KEY ("ListId", "TenantId");
 P   ALTER TABLE ONLY public."CrmCustomLists" DROP CONSTRAINT "CrmCustomLists_pkey";
       public            postgres    false    296    296            �           2606    19122 4   CrmCustomListsTenant100 CrmCustomListsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant100"
    ADD CONSTRAINT "CrmCustomListsTenant100_pkey" PRIMARY KEY ("ListId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCustomListsTenant100" DROP CONSTRAINT "CrmCustomListsTenant100_pkey";
       public            postgres    false    6119    299    299    299            �           2606    19124 0   CrmCustomListsTenant1 CrmCustomListsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant1"
    ADD CONSTRAINT "CrmCustomListsTenant1_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant1" DROP CONSTRAINT "CrmCustomListsTenant1_pkey";
       public            postgres    false    298    298    6119    298            �           2606    19126 0   CrmCustomListsTenant2 CrmCustomListsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant2"
    ADD CONSTRAINT "CrmCustomListsTenant2_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant2" DROP CONSTRAINT "CrmCustomListsTenant2_pkey";
       public            postgres    false    300    6119    300    300            �           2606    19128 0   CrmCustomListsTenant3 CrmCustomListsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant3"
    ADD CONSTRAINT "CrmCustomListsTenant3_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant3" DROP CONSTRAINT "CrmCustomListsTenant3_pkey";
       public            postgres    false    301    6119    301    301            �           2606    19130    CrmEmail CrmEmail_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public."CrmEmail"
    ADD CONSTRAINT "CrmEmail_pkey" PRIMARY KEY ("EmailId", "TenantId");
 D   ALTER TABLE ONLY public."CrmEmail" DROP CONSTRAINT "CrmEmail_pkey";
       public            postgres    false    302    302            �           2606    19132    CrmEmail100 CrmEmail100_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmEmail100"
    ADD CONSTRAINT "CrmEmail100_pkey" PRIMARY KEY ("EmailId", "TenantId");
 J   ALTER TABLE ONLY public."CrmEmail100" DROP CONSTRAINT "CrmEmail100_pkey";
       public            postgres    false    305    305    6134    305            �           2606    19134    CrmEmail1 CrmEmail1_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail1"
    ADD CONSTRAINT "CrmEmail1_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail1" DROP CONSTRAINT "CrmEmail1_pkey";
       public            postgres    false    304    304    304    6134                        2606    19136    CrmEmail2 CrmEmail2_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail2"
    ADD CONSTRAINT "CrmEmail2_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail2" DROP CONSTRAINT "CrmEmail2_pkey";
       public            postgres    false    306    306    6134    306                       2606    19138    CrmEmail3 CrmEmail3_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail3"
    ADD CONSTRAINT "CrmEmail3_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail3" DROP CONSTRAINT "CrmEmail3_pkey";
       public            postgres    false    307    6134    307    307            4           2606    20920     CrmFormFields CrmFormFields_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmFormFields"
    ADD CONSTRAINT "CrmFormFields_pkey" PRIMARY KEY ("FieldId", "TenantId");
 N   ALTER TABLE ONLY public."CrmFormFields" DROP CONSTRAINT "CrmFormFields_pkey";
       public            postgres    false    438    438            A           2606    20958 &   CrmFormFields100 CrmFormFields100_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public."CrmFormFields100"
    ADD CONSTRAINT "CrmFormFields100_pkey" PRIMARY KEY ("FieldId", "TenantId");
 T   ALTER TABLE ONLY public."CrmFormFields100" DROP CONSTRAINT "CrmFormFields100_pkey";
       public            postgres    false    6452    442    442    442            8           2606    20928 "   CrmFormFields1 CrmFormFields1_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmFormFields1"
    ADD CONSTRAINT "CrmFormFields1_pkey" PRIMARY KEY ("FieldId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormFields1" DROP CONSTRAINT "CrmFormFields1_pkey";
       public            postgres    false    6452    439    439    439            ;           2606    20938 "   CrmFormFields2 CrmFormFields2_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmFormFields2"
    ADD CONSTRAINT "CrmFormFields2_pkey" PRIMARY KEY ("FieldId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormFields2" DROP CONSTRAINT "CrmFormFields2_pkey";
       public            postgres    false    440    440    440    6452            >           2606    20948 "   CrmFormFields3 CrmFormFields3_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmFormFields3"
    ADD CONSTRAINT "CrmFormFields3_pkey" PRIMARY KEY ("FieldId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormFields3" DROP CONSTRAINT "CrmFormFields3_pkey";
       public            postgres    false    441    441    441    6452            C           2606    20974 "   CrmFormResults CrmFormResults_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."CrmFormResults"
    ADD CONSTRAINT "CrmFormResults_pkey" PRIMARY KEY ("ResultId", "TenantId");
 P   ALTER TABLE ONLY public."CrmFormResults" DROP CONSTRAINT "CrmFormResults_pkey";
       public            postgres    false    444    444            P           2606    21012 (   CrmFormResults100 CrmFormResults100_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public."CrmFormResults100"
    ADD CONSTRAINT "CrmFormResults100_pkey" PRIMARY KEY ("ResultId", "TenantId");
 V   ALTER TABLE ONLY public."CrmFormResults100" DROP CONSTRAINT "CrmFormResults100_pkey";
       public            postgres    false    448    448    6467    448            G           2606    20982 $   CrmFormResults1 CrmFormResults1_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmFormResults1"
    ADD CONSTRAINT "CrmFormResults1_pkey" PRIMARY KEY ("ResultId", "TenantId");
 R   ALTER TABLE ONLY public."CrmFormResults1" DROP CONSTRAINT "CrmFormResults1_pkey";
       public            postgres    false    445    445    6467    445            J           2606    20992 $   CrmFormResults2 CrmFormResults2_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmFormResults2"
    ADD CONSTRAINT "CrmFormResults2_pkey" PRIMARY KEY ("ResultId", "TenantId");
 R   ALTER TABLE ONLY public."CrmFormResults2" DROP CONSTRAINT "CrmFormResults2_pkey";
       public            postgres    false    446    6467    446    446            M           2606    21002 $   CrmFormResults3 CrmFormResults3_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmFormResults3"
    ADD CONSTRAINT "CrmFormResults3_pkey" PRIMARY KEY ("ResultId", "TenantId");
 R   ALTER TABLE ONLY public."CrmFormResults3" DROP CONSTRAINT "CrmFormResults3_pkey";
       public            postgres    false    447    447    6467    447                       2606    19579 &   CrmICallScenarios CrmIcallReason _pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."CrmICallScenarios"
    ADD CONSTRAINT "CrmIcallReason _pkey" PRIMARY KEY ("ReasonId");
 T   ALTER TABLE ONLY public."CrmICallScenarios" DROP CONSTRAINT "CrmIcallReason _pkey";
       public            postgres    false    426                       2606    19140    CrmIndustry CrmIndustry_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmIndustry"
    ADD CONSTRAINT "CrmIndustry_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 J   ALTER TABLE ONLY public."CrmIndustry" DROP CONSTRAINT "CrmIndustry_pkey";
       public            postgres    false    308    308                       2606    19142 .   CrmIndustryTenant100 CrmIndustryTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant100"
    ADD CONSTRAINT "CrmIndustryTenant100_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 \   ALTER TABLE ONLY public."CrmIndustryTenant100" DROP CONSTRAINT "CrmIndustryTenant100_pkey";
       public            postgres    false    311    311    311    6149            	           2606    19144 *   CrmIndustryTenant1 CrmIndustryTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant1"
    ADD CONSTRAINT "CrmIndustryTenant1_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant1" DROP CONSTRAINT "CrmIndustryTenant1_pkey";
       public            postgres    false    310    6149    310    310                       2606    19146 *   CrmIndustryTenant2 CrmIndustryTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant2"
    ADD CONSTRAINT "CrmIndustryTenant2_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant2" DROP CONSTRAINT "CrmIndustryTenant2_pkey";
       public            postgres    false    312    6149    312    312                       2606    19148 *   CrmIndustryTenant3 CrmIndustryTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant3"
    ADD CONSTRAINT "CrmIndustryTenant3_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant3" DROP CONSTRAINT "CrmIndustryTenant3_pkey";
       public            postgres    false    313    313    313    6149                       2606    19150 *   CrmLeadActivityLog CrmLeadActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLog"
    ADD CONSTRAINT "CrmLeadActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 X   ALTER TABLE ONLY public."CrmLeadActivityLog" DROP CONSTRAINT "CrmLeadActivityLog_pkey";
       public            postgres    false    315    315                       2606    19152 <   CrmLeadActivityLogTenant100 CrmLeadActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant100"
    ADD CONSTRAINT "CrmLeadActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 j   ALTER TABLE ONLY public."CrmLeadActivityLogTenant100" DROP CONSTRAINT "CrmLeadActivityLogTenant100_pkey";
       public            postgres    false    318    318    6167    318                       2606    19154 8   CrmLeadActivityLogTenant1 CrmLeadActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant1"
    ADD CONSTRAINT "CrmLeadActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant1" DROP CONSTRAINT "CrmLeadActivityLogTenant1_pkey";
       public            postgres    false    6167    317    317    317            !           2606    19156 8   CrmLeadActivityLogTenant2 CrmLeadActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant2"
    ADD CONSTRAINT "CrmLeadActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant2" DROP CONSTRAINT "CrmLeadActivityLogTenant2_pkey";
       public            postgres    false    6167    319    319    319            $           2606    19158 8   CrmLeadActivityLogTenant3 CrmLeadActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant3"
    ADD CONSTRAINT "CrmLeadActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant3" DROP CONSTRAINT "CrmLeadActivityLogTenant3_pkey";
       public            postgres    false    320    320    320    6167            &           2606    19160     CrmLeadSource CrmLeadSource_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadSource"
    ADD CONSTRAINT "CrmLeadSource_pkey" PRIMARY KEY ("SourceId", "TenantId");
 N   ALTER TABLE ONLY public."CrmLeadSource" DROP CONSTRAINT "CrmLeadSource_pkey";
       public            postgres    false    321    321            -           2606    19162 2   CrmLeadSourceTenant100 CrmLeadSourceTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant100"
    ADD CONSTRAINT "CrmLeadSourceTenant100_pkey" PRIMARY KEY ("SourceId", "TenantId");
 `   ALTER TABLE ONLY public."CrmLeadSourceTenant100" DROP CONSTRAINT "CrmLeadSourceTenant100_pkey";
       public            postgres    false    324    324    324    6182            *           2606    19164 .   CrmLeadSourceTenant1 CrmLeadSourceTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant1"
    ADD CONSTRAINT "CrmLeadSourceTenant1_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant1" DROP CONSTRAINT "CrmLeadSourceTenant1_pkey";
       public            postgres    false    323    323    323    6182            0           2606    19166 .   CrmLeadSourceTenant2 CrmLeadSourceTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant2"
    ADD CONSTRAINT "CrmLeadSourceTenant2_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant2" DROP CONSTRAINT "CrmLeadSourceTenant2_pkey";
       public            postgres    false    325    325    6182    325            3           2606    19168 .   CrmLeadSourceTenant3 CrmLeadSourceTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant3"
    ADD CONSTRAINT "CrmLeadSourceTenant3_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant3" DROP CONSTRAINT "CrmLeadSourceTenant3_pkey";
       public            postgres    false    326    326    326    6182            5           2606    19170     CrmLeadStatus CrmLeadStatus_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadStatus"
    ADD CONSTRAINT "CrmLeadStatus_pkey" PRIMARY KEY ("StatusId", "TenantId");
 N   ALTER TABLE ONLY public."CrmLeadStatus" DROP CONSTRAINT "CrmLeadStatus_pkey";
       public            postgres    false    327    327            <           2606    19172 2   CrmLeadStatusTenant100 CrmLeadStatusTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant100"
    ADD CONSTRAINT "CrmLeadStatusTenant100_pkey" PRIMARY KEY ("StatusId", "TenantId");
 `   ALTER TABLE ONLY public."CrmLeadStatusTenant100" DROP CONSTRAINT "CrmLeadStatusTenant100_pkey";
       public            postgres    false    330    6197    330    330            9           2606    19174 .   CrmLeadStatusTenant1 CrmLeadStatusTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant1"
    ADD CONSTRAINT "CrmLeadStatusTenant1_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant1" DROP CONSTRAINT "CrmLeadStatusTenant1_pkey";
       public            postgres    false    329    329    6197    329            ?           2606    19176 .   CrmLeadStatusTenant2 CrmLeadStatusTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant2"
    ADD CONSTRAINT "CrmLeadStatusTenant2_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant2" DROP CONSTRAINT "CrmLeadStatusTenant2_pkey";
       public            postgres    false    331    331    331    6197            B           2606    19178 .   CrmLeadStatusTenant3 CrmLeadStatusTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant3"
    ADD CONSTRAINT "CrmLeadStatusTenant3_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant3" DROP CONSTRAINT "CrmLeadStatusTenant3_pkey";
       public            postgres    false    6197    332    332    332                       2606    19180    CrmLead CrmLead_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmLead"
    ADD CONSTRAINT "CrmLead_pkey" PRIMARY KEY ("LeadId", "TenantId");
 B   ALTER TABLE ONLY public."CrmLead" DROP CONSTRAINT "CrmLead_pkey";
       public            postgres    false    314    314            H           2606    19182 &   CrmLeadTenant100 CrmLeadTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmLeadTenant100"
    ADD CONSTRAINT "CrmLeadTenant100_pkey" PRIMARY KEY ("LeadId", "TenantId");
 T   ALTER TABLE ONLY public."CrmLeadTenant100" DROP CONSTRAINT "CrmLeadTenant100_pkey";
       public            postgres    false    6164    335    335    335            E           2606    19184 "   CrmLeadTenant1 CrmLeadTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant1"
    ADD CONSTRAINT "CrmLeadTenant1_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant1" DROP CONSTRAINT "CrmLeadTenant1_pkey";
       public            postgres    false    334    334    6164    334            K           2606    19186 "   CrmLeadTenant2 CrmLeadTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant2"
    ADD CONSTRAINT "CrmLeadTenant2_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant2" DROP CONSTRAINT "CrmLeadTenant2_pkey";
       public            postgres    false    336    336    6164    336            N           2606    19188 "   CrmLeadTenant3 CrmLeadTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant3"
    ADD CONSTRAINT "CrmLeadTenant3_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant3" DROP CONSTRAINT "CrmLeadTenant3_pkey";
       public            postgres    false    337    6164    337    337            P           2606    19190    CrmMeeting CrmMeeting_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmMeeting"
    ADD CONSTRAINT "CrmMeeting_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 H   ALTER TABLE ONLY public."CrmMeeting" DROP CONSTRAINT "CrmMeeting_pkey";
       public            postgres    false    338    338            W           2606    19192     CrmMeeting100 CrmMeeting100_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmMeeting100"
    ADD CONSTRAINT "CrmMeeting100_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 N   ALTER TABLE ONLY public."CrmMeeting100" DROP CONSTRAINT "CrmMeeting100_pkey";
       public            postgres    false    341    6224    341    341            T           2606    19194    CrmMeeting1 CrmMeeting1_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting1"
    ADD CONSTRAINT "CrmMeeting1_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting1" DROP CONSTRAINT "CrmMeeting1_pkey";
       public            postgres    false    6224    340    340    340            Z           2606    19196    CrmMeeting2 CrmMeeting2_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting2"
    ADD CONSTRAINT "CrmMeeting2_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting2" DROP CONSTRAINT "CrmMeeting2_pkey";
       public            postgres    false    342    6224    342    342            ]           2606    19198    CrmMeeting3 CrmMeeting3_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting3"
    ADD CONSTRAINT "CrmMeeting3_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting3" DROP CONSTRAINT "CrmMeeting3_pkey";
       public            postgres    false    343    343    343    6224            b           2606    19200    CrmNoteTags CrmNoteTags_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmNoteTags"
    ADD CONSTRAINT "CrmNoteTags_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 J   ALTER TABLE ONLY public."CrmNoteTags" DROP CONSTRAINT "CrmNoteTags_pkey";
       public            postgres    false    345    345            i           2606    19202 .   CrmNoteTagsTenant100 CrmNoteTagsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant100"
    ADD CONSTRAINT "CrmNoteTagsTenant100_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 \   ALTER TABLE ONLY public."CrmNoteTagsTenant100" DROP CONSTRAINT "CrmNoteTagsTenant100_pkey";
       public            postgres    false    348    348    6242    348            f           2606    19204 *   CrmNoteTagsTenant1 CrmNoteTagsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant1"
    ADD CONSTRAINT "CrmNoteTagsTenant1_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant1" DROP CONSTRAINT "CrmNoteTagsTenant1_pkey";
       public            postgres    false    347    347    6242    347            l           2606    19206 *   CrmNoteTagsTenant2 CrmNoteTagsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant2"
    ADD CONSTRAINT "CrmNoteTagsTenant2_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant2" DROP CONSTRAINT "CrmNoteTagsTenant2_pkey";
       public            postgres    false    349    349    349    6242            o           2606    19208 *   CrmNoteTagsTenant3 CrmNoteTagsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant3"
    ADD CONSTRAINT "CrmNoteTagsTenant3_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant3" DROP CONSTRAINT "CrmNoteTagsTenant3_pkey";
       public            postgres    false    350    350    350    6242            q           2606    19210    CrmNoteTasks CrmNoteTasks_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTasks"
    ADD CONSTRAINT "CrmNoteTasks_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 L   ALTER TABLE ONLY public."CrmNoteTasks" DROP CONSTRAINT "CrmNoteTasks_pkey";
       public            postgres    false    351    351            x           2606    19212 0   CrmNoteTasksTenant100 CrmNoteTasksTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant100"
    ADD CONSTRAINT "CrmNoteTasksTenant100_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmNoteTasksTenant100" DROP CONSTRAINT "CrmNoteTasksTenant100_pkey";
       public            postgres    false    6257    354    354    354            u           2606    19214 ,   CrmNoteTasksTenant1 CrmNoteTasksTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant1"
    ADD CONSTRAINT "CrmNoteTasksTenant1_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant1" DROP CONSTRAINT "CrmNoteTasksTenant1_pkey";
       public            postgres    false    353    353    6257    353            {           2606    19216 ,   CrmNoteTasksTenant2 CrmNoteTasksTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant2"
    ADD CONSTRAINT "CrmNoteTasksTenant2_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant2" DROP CONSTRAINT "CrmNoteTasksTenant2_pkey";
       public            postgres    false    355    6257    355    355            ~           2606    19218 ,   CrmNoteTasksTenant3 CrmNoteTasksTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant3"
    ADD CONSTRAINT "CrmNoteTasksTenant3_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant3" DROP CONSTRAINT "CrmNoteTasksTenant3_pkey";
       public            postgres    false    356    356    356    6257            _           2606    19220    CrmNote CrmNote_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmNote"
    ADD CONSTRAINT "CrmNote_pkey" PRIMARY KEY ("NoteId", "TenantId");
 B   ALTER TABLE ONLY public."CrmNote" DROP CONSTRAINT "CrmNote_pkey";
       public            postgres    false    344    344            �           2606    19222 &   CrmNoteTenant100 CrmNoteTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmNoteTenant100"
    ADD CONSTRAINT "CrmNoteTenant100_pkey" PRIMARY KEY ("NoteId", "TenantId");
 T   ALTER TABLE ONLY public."CrmNoteTenant100" DROP CONSTRAINT "CrmNoteTenant100_pkey";
       public            postgres    false    359    359    6239    359            �           2606    19224 "   CrmNoteTenant1 CrmNoteTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant1"
    ADD CONSTRAINT "CrmNoteTenant1_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant1" DROP CONSTRAINT "CrmNoteTenant1_pkey";
       public            postgres    false    358    6239    358    358            �           2606    19226 "   CrmNoteTenant2 CrmNoteTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant2"
    ADD CONSTRAINT "CrmNoteTenant2_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant2" DROP CONSTRAINT "CrmNoteTenant2_pkey";
       public            postgres    false    360    360    360    6239            �           2606    19228 "   CrmNoteTenant3 CrmNoteTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant3"
    ADD CONSTRAINT "CrmNoteTenant3_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant3" DROP CONSTRAINT "CrmNoteTenant3_pkey";
       public            postgres    false    361    361    361    6239            �           2606    19230 "   CrmOpportunity CrmOpportunity_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."CrmOpportunity"
    ADD CONSTRAINT "CrmOpportunity_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 P   ALTER TABLE ONLY public."CrmOpportunity" DROP CONSTRAINT "CrmOpportunity_pkey";
       public            postgres    false    362    362            �           2606    19232 (   CrmOpportunity100 CrmOpportunity100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmOpportunity100"
    ADD CONSTRAINT "CrmOpportunity100_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 V   ALTER TABLE ONLY public."CrmOpportunity100" DROP CONSTRAINT "CrmOpportunity100_pkey";
       public            postgres    false    6284    365    365    365            �           2606    19234 $   CrmOpportunity1 CrmOpportunity1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity1"
    ADD CONSTRAINT "CrmOpportunity1_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity1" DROP CONSTRAINT "CrmOpportunity1_pkey";
       public            postgres    false    364    6284    364    364            �           2606    19236 $   CrmOpportunity2 CrmOpportunity2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity2"
    ADD CONSTRAINT "CrmOpportunity2_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity2" DROP CONSTRAINT "CrmOpportunity2_pkey";
       public            postgres    false    366    366    6284    366            �           2606    19238 $   CrmOpportunity3 CrmOpportunity3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity3"
    ADD CONSTRAINT "CrmOpportunity3_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity3" DROP CONSTRAINT "CrmOpportunity3_pkey";
       public            postgres    false    367    367    367    6284            �           2606    19242 .   CrmOpportunityStatus CrmOpportunityStatus_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmOpportunityStatus"
    ADD CONSTRAINT "CrmOpportunityStatus_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmOpportunityStatus" DROP CONSTRAINT "CrmOpportunityStatus_pkey";
       public            postgres    false    368    368            �           2606    19244    CrmProduct CrmProduct_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmProduct"
    ADD CONSTRAINT "CrmProduct_pkey" PRIMARY KEY ("ProductId", "TenantId");
 H   ALTER TABLE ONLY public."CrmProduct" DROP CONSTRAINT "CrmProduct_pkey";
       public            postgres    false    370    370            �           2606    19246 ,   CrmProductTenant100 CrmProductTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmProductTenant100"
    ADD CONSTRAINT "CrmProductTenant100_pkey" PRIMARY KEY ("ProductId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmProductTenant100" DROP CONSTRAINT "CrmProductTenant100_pkey";
       public            postgres    false    373    373    6301    373            �           2606    19248 (   CrmProductTenant1 CrmProductTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant1"
    ADD CONSTRAINT "CrmProductTenant1_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant1" DROP CONSTRAINT "CrmProductTenant1_pkey";
       public            postgres    false    6301    372    372    372            �           2606    19250 (   CrmProductTenant2 CrmProductTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant2"
    ADD CONSTRAINT "CrmProductTenant2_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant2" DROP CONSTRAINT "CrmProductTenant2_pkey";
       public            postgres    false    374    374    374    6301            �           2606    19252 (   CrmProductTenant3 CrmProductTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant3"
    ADD CONSTRAINT "CrmProductTenant3_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant3" DROP CONSTRAINT "CrmProductTenant3_pkey";
       public            postgres    false    375    6301    375    375            #           2606    19597    CrmProject CrmProject_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmProject"
    ADD CONSTRAINT "CrmProject_pkey" PRIMARY KEY ("ProjectId", "TenantId");
 H   ALTER TABLE ONLY public."CrmProject" DROP CONSTRAINT "CrmProject_pkey";
       public            postgres    false    430    430            !           2606    19587    CrmStatusLog CrmStatusLog_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."CrmStatusLog"
    ADD CONSTRAINT "CrmStatusLog_pkey" PRIMARY KEY ("LogId");
 L   ALTER TABLE ONLY public."CrmStatusLog" DROP CONSTRAINT "CrmStatusLog_pkey";
       public            postgres    false    428            �           2606    19254    CrmTagUsed CrmTagUsed_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmTagUsed"
    ADD CONSTRAINT "CrmTagUsed_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 H   ALTER TABLE ONLY public."CrmTagUsed" DROP CONSTRAINT "CrmTagUsed_pkey";
       public            postgres    false    376    376            �           2606    19256 ,   CrmTagUsedTenant100 CrmTagUsedTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTagUsedTenant100"
    ADD CONSTRAINT "CrmTagUsedTenant100_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmTagUsedTenant100" DROP CONSTRAINT "CrmTagUsedTenant100_pkey";
       public            postgres    false    379    379    6316    379            �           2606    19258 (   CrmTagUsedTenant1 CrmTagUsedTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant1"
    ADD CONSTRAINT "CrmTagUsedTenant1_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant1" DROP CONSTRAINT "CrmTagUsedTenant1_pkey";
       public            postgres    false    378    6316    378    378            �           2606    19260 (   CrmTagUsedTenant2 CrmTagUsedTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant2"
    ADD CONSTRAINT "CrmTagUsedTenant2_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant2" DROP CONSTRAINT "CrmTagUsedTenant2_pkey";
       public            postgres    false    6316    380    380    380            �           2606    19262 (   CrmTagUsedTenant3 CrmTagUsedTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant3"
    ADD CONSTRAINT "CrmTagUsedTenant3_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant3" DROP CONSTRAINT "CrmTagUsedTenant3_pkey";
       public            postgres    false    6316    381    381    381            �           2606    19264    CrmTags CrmTags_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."CrmTags"
    ADD CONSTRAINT "CrmTags_pkey" PRIMARY KEY ("TagId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTags" DROP CONSTRAINT "CrmTags_pkey";
       public            postgres    false    382    382            �           2606    19266 &   CrmTagsTenant100 CrmTagsTenant100_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public."CrmTagsTenant100"
    ADD CONSTRAINT "CrmTagsTenant100_pkey" PRIMARY KEY ("TagId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTagsTenant100" DROP CONSTRAINT "CrmTagsTenant100_pkey";
       public            postgres    false    6331    385    385    385            �           2606    19268 "   CrmTagsTenant1 CrmTagsTenant1_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant1"
    ADD CONSTRAINT "CrmTagsTenant1_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant1" DROP CONSTRAINT "CrmTagsTenant1_pkey";
       public            postgres    false    384    384    384    6331            �           2606    19270 "   CrmTagsTenant2 CrmTagsTenant2_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant2"
    ADD CONSTRAINT "CrmTagsTenant2_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant2" DROP CONSTRAINT "CrmTagsTenant2_pkey";
       public            postgres    false    386    386    6331    386            �           2606    19272 "   CrmTagsTenant3 CrmTagsTenant3_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant3"
    ADD CONSTRAINT "CrmTagsTenant3_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant3" DROP CONSTRAINT "CrmTagsTenant3_pkey";
       public            postgres    false    387    6331    387    387            �           2606    19274 $   CrmTaskPriority CrmTaskPriority_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."CrmTaskPriority"
    ADD CONSTRAINT "CrmTaskPriority_pkey" PRIMARY KEY ("PriorityId");
 R   ALTER TABLE ONLY public."CrmTaskPriority" DROP CONSTRAINT "CrmTaskPriority_pkey";
       public            postgres    false    389            �           2606    19276     CrmTaskStatus CrmTaskStatus_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmTaskStatus"
    ADD CONSTRAINT "CrmTaskStatus_pkey" PRIMARY KEY ("StatusId");
 N   ALTER TABLE ONLY public."CrmTaskStatus" DROP CONSTRAINT "CrmTaskStatus_pkey";
       public            postgres    false    391            �           2606    19278    CrmTaskTags CrmTaskTags_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmTaskTags"
    ADD CONSTRAINT "CrmTaskTags_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 J   ALTER TABLE ONLY public."CrmTaskTags" DROP CONSTRAINT "CrmTaskTags_pkey";
       public            postgres    false    393    393            �           2606    19280 .   CrmTaskTagsTenant100 CrmTaskTagsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant100"
    ADD CONSTRAINT "CrmTaskTagsTenant100_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTaskTagsTenant100" DROP CONSTRAINT "CrmTaskTagsTenant100_pkey";
       public            postgres    false    6354    396    396    396            �           2606    19282 *   CrmTaskTagsTenant1 CrmTaskTagsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant1"
    ADD CONSTRAINT "CrmTaskTagsTenant1_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant1" DROP CONSTRAINT "CrmTaskTagsTenant1_pkey";
       public            postgres    false    395    395    395    6354            �           2606    19284 *   CrmTaskTagsTenant2 CrmTaskTagsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant2"
    ADD CONSTRAINT "CrmTaskTagsTenant2_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant2" DROP CONSTRAINT "CrmTaskTagsTenant2_pkey";
       public            postgres    false    397    397    397    6354            �           2606    19286 *   CrmTaskTagsTenant3 CrmTaskTagsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant3"
    ADD CONSTRAINT "CrmTaskTagsTenant3_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant3" DROP CONSTRAINT "CrmTaskTagsTenant3_pkey";
       public            postgres    false    398    398    6354    398            �           2606    19288    CrmTask CrmTask_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmTask"
    ADD CONSTRAINT "CrmTask_pkey" PRIMARY KEY ("TaskId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTask" DROP CONSTRAINT "CrmTask_pkey";
       public            postgres    false    388    388            �           2606    19290 &   CrmTaskTenant100 CrmTaskTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTaskTenant100"
    ADD CONSTRAINT "CrmTaskTenant100_pkey" PRIMARY KEY ("TaskId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTaskTenant100" DROP CONSTRAINT "CrmTaskTenant100_pkey";
       public            postgres    false    401    6346    401    401            �           2606    19292 "   CrmTaskTenant1 CrmTaskTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant1"
    ADD CONSTRAINT "CrmTaskTenant1_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant1" DROP CONSTRAINT "CrmTaskTenant1_pkey";
       public            postgres    false    6346    400    400    400            �           2606    19294 "   CrmTaskTenant2 CrmTaskTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant2"
    ADD CONSTRAINT "CrmTaskTenant2_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant2" DROP CONSTRAINT "CrmTaskTenant2_pkey";
       public            postgres    false    6346    402    402    402            �           2606    19296 "   CrmTaskTenant3 CrmTaskTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant3"
    ADD CONSTRAINT "CrmTaskTenant3_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant3" DROP CONSTRAINT "CrmTaskTenant3_pkey";
       public            postgres    false    6346    403    403    403            �           2606    19298     CrmTeamMember CrmTeamMember_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTeamMember"
    ADD CONSTRAINT "CrmTeamMember_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 N   ALTER TABLE ONLY public."CrmTeamMember" DROP CONSTRAINT "CrmTeamMember_pkey";
       public            postgres    false    405    405            �           2606    19300 2   CrmTeamMemberTenant100 CrmTeamMemberTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant100"
    ADD CONSTRAINT "CrmTeamMemberTenant100_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 `   ALTER TABLE ONLY public."CrmTeamMemberTenant100" DROP CONSTRAINT "CrmTeamMemberTenant100_pkey";
       public            postgres    false    408    408    408    6384            �           2606    19302 .   CrmTeamMemberTenant1 CrmTeamMemberTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant1"
    ADD CONSTRAINT "CrmTeamMemberTenant1_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant1" DROP CONSTRAINT "CrmTeamMemberTenant1_pkey";
       public            postgres    false    407    6384    407    407            �           2606    19304 .   CrmTeamMemberTenant2 CrmTeamMemberTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant2"
    ADD CONSTRAINT "CrmTeamMemberTenant2_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant2" DROP CONSTRAINT "CrmTeamMemberTenant2_pkey";
       public            postgres    false    6384    409    409    409            �           2606    19306 .   CrmTeamMemberTenant3 CrmTeamMemberTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant3"
    ADD CONSTRAINT "CrmTeamMemberTenant3_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant3" DROP CONSTRAINT "CrmTeamMemberTenant3_pkey";
       public            postgres    false    410    410    6384    410            �           2606    19308    CrmTeam CrmTeam_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmTeam"
    ADD CONSTRAINT "CrmTeam_pkey" PRIMARY KEY ("TeamId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTeam" DROP CONSTRAINT "CrmTeam_pkey";
       public            postgres    false    404    404                       2606    19310 &   CrmTeamTenant100 CrmTeamTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTeamTenant100"
    ADD CONSTRAINT "CrmTeamTenant100_pkey" PRIMARY KEY ("TeamId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTeamTenant100" DROP CONSTRAINT "CrmTeamTenant100_pkey";
       public            postgres    false    413    413    413    6381                        2606    19312 "   CrmTeamTenant1 CrmTeamTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant1"
    ADD CONSTRAINT "CrmTeamTenant1_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant1" DROP CONSTRAINT "CrmTeamTenant1_pkey";
       public            postgres    false    412    412    6381    412                       2606    19314 "   CrmTeamTenant2 CrmTeamTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant2"
    ADD CONSTRAINT "CrmTeamTenant2_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant2" DROP CONSTRAINT "CrmTeamTenant2_pkey";
       public            postgres    false    6381    414    414    414            	           2606    19316 "   CrmTeamTenant3 CrmTeamTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant3"
    ADD CONSTRAINT "CrmTeamTenant3_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant3" DROP CONSTRAINT "CrmTeamTenant3_pkey";
       public            postgres    false    6381    415    415    415                       2606    19318 *   CrmUserActivityLog CrmUserActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLog"
    ADD CONSTRAINT "CrmUserActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 X   ALTER TABLE ONLY public."CrmUserActivityLog" DROP CONSTRAINT "CrmUserActivityLog_pkey";
       public            postgres    false    416    416                       2606    19320 <   CrmUserActivityLogTenant100 CrmUserActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant100"
    ADD CONSTRAINT "CrmUserActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 j   ALTER TABLE ONLY public."CrmUserActivityLogTenant100" DROP CONSTRAINT "CrmUserActivityLogTenant100_pkey";
       public            postgres    false    419    419    6411    419                       2606    19322 8   CrmUserActivityLogTenant1 CrmUserActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant1"
    ADD CONSTRAINT "CrmUserActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant1" DROP CONSTRAINT "CrmUserActivityLogTenant1_pkey";
       public            postgres    false    418    6411    418    418                       2606    19324 8   CrmUserActivityLogTenant2 CrmUserActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant2"
    ADD CONSTRAINT "CrmUserActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant2" DROP CONSTRAINT "CrmUserActivityLogTenant2_pkey";
       public            postgres    false    420    420    6411    420                       2606    19326 8   CrmUserActivityLogTenant3 CrmUserActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant3"
    ADD CONSTRAINT "CrmUserActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant3" DROP CONSTRAINT "CrmUserActivityLogTenant3_pkey";
       public            postgres    false    6411    421    421    421                       2606    19328 ,   CrmUserActivityType CrmUserActivityType_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."CrmUserActivityType"
    ADD CONSTRAINT "CrmUserActivityType_pkey" PRIMARY KEY ("ActivityTypeId");
 Z   ALTER TABLE ONLY public."CrmUserActivityType" DROP CONSTRAINT "CrmUserActivityType_pkey";
       public            postgres    false    422                       2606    19330    Tenant Tenant_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public."Tenant"
    ADD CONSTRAINT "Tenant_pkey" PRIMARY KEY ("TenantId");
 @   ALTER TABLE ONLY public."Tenant" DROP CONSTRAINT "Tenant_pkey";
       public            postgres    false    424            �           2606    19332    AppMenus appmenu_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."AppMenus"
    ADD CONSTRAINT appmenu_pkey PRIMARY KEY ("MenuId");
 A   ALTER TABLE ONLY public."AppMenus" DROP CONSTRAINT appmenu_pkey;
       public            postgres    false    256            �           1259    19333    idx_AccountId    INDEX     V   CREATE INDEX "idx_AccountId" ON ONLY public."CrmAdAccount" USING btree ("AccountId");
 #   DROP INDEX public."idx_AccountId";
       public            postgres    false    258            �           1259    19334    CrmAdAccount100_AccountId_idx    INDEX     d   CREATE INDEX "CrmAdAccount100_AccountId_idx" ON public."CrmAdAccount100" USING btree ("AccountId");
 3   DROP INDEX public."CrmAdAccount100_AccountId_idx";
       public            postgres    false    6023    261    261            �           1259    19335    CrmAdAccount1_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount1_AccountId_idx" ON public."CrmAdAccount1" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount1_AccountId_idx";
       public            postgres    false    260    260    6023            �           1259    19336    CrmAdAccount2_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount2_AccountId_idx" ON public."CrmAdAccount2" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount2_AccountId_idx";
       public            postgres    false    6023    262    262            �           1259    19337    CrmAdAccount3_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount3_AccountId_idx" ON public."CrmAdAccount3" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount3_AccountId_idx";
       public            postgres    false    6023    263    263            �           1259    19338    idx_crmcalenderevents_eventid    INDEX     g   CREATE INDEX idx_crmcalenderevents_eventid ON ONLY public."CrmCalenderEvents" USING btree ("EventId");
 1   DROP INDEX public.idx_crmcalenderevents_eventid;
       public            postgres    false    266            �           1259    19339 &   CrmCalenderEventsTenant100_EventId_idx    INDEX     v   CREATE INDEX "CrmCalenderEventsTenant100_EventId_idx" ON public."CrmCalenderEventsTenant100" USING btree ("EventId");
 <   DROP INDEX public."CrmCalenderEventsTenant100_EventId_idx";
       public            postgres    false    269    6040    269            �           1259    19340 $   CrmCalenderEventsTenant1_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant1_EventId_idx" ON public."CrmCalenderEventsTenant1" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant1_EventId_idx";
       public            postgres    false    268    6040    268            �           1259    19341 $   CrmCalenderEventsTenant2_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant2_EventId_idx" ON public."CrmCalenderEventsTenant2" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant2_EventId_idx";
       public            postgres    false    6040    270    270            �           1259    19342 $   CrmCalenderEventsTenant3_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant3_EventId_idx" ON public."CrmCalenderEventsTenant3" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant3_EventId_idx";
       public            postgres    false    6040    271    271            �           1259    19343 
   idx_CallId    INDEX     K   CREATE INDEX "idx_CallId" ON ONLY public."CrmCall" USING btree ("CallId");
     DROP INDEX public."idx_CallId";
       public            postgres    false    272            �           1259    19344    CrmCall100_CallId_idx    INDEX     T   CREATE INDEX "CrmCall100_CallId_idx" ON public."CrmCall100" USING btree ("CallId");
 +   DROP INDEX public."CrmCall100_CallId_idx";
       public            postgres    false    6055    275    275            �           1259    19345    CrmCall1_CallId_idx    INDEX     P   CREATE INDEX "CrmCall1_CallId_idx" ON public."CrmCall1" USING btree ("CallId");
 )   DROP INDEX public."CrmCall1_CallId_idx";
       public            postgres    false    274    6055    274            �           1259    19346    CrmCall2_CallId_idx    INDEX     P   CREATE INDEX "CrmCall2_CallId_idx" ON public."CrmCall2" USING btree ("CallId");
 )   DROP INDEX public."CrmCall2_CallId_idx";
       public            postgres    false    276    276    6055            �           1259    19347    CrmCall3_CallId_idx    INDEX     P   CREATE INDEX "CrmCall3_CallId_idx" ON public."CrmCall3" USING btree ("CallId");
 )   DROP INDEX public."CrmCall3_CallId_idx";
       public            postgres    false    277    277    6055            &           1259    20415    idx_CampaignId    INDEX     W   CREATE INDEX "idx_CampaignId" ON ONLY public."CrmCampaign" USING btree ("CampaignId");
 $   DROP INDEX public."idx_CampaignId";
       public            postgres    false    432            -           1259    20434    CrmCampaign100_CampaignId_idx    INDEX     d   CREATE INDEX "CrmCampaign100_CampaignId_idx" ON public."CrmCampaign100" USING btree ("CampaignId");
 3   DROP INDEX public."CrmCampaign100_CampaignId_idx";
       public            postgres    false    435    435    6438            *           1259    20424    CrmCampaign1_CampaignId_idx    INDEX     `   CREATE INDEX "CrmCampaign1_CampaignId_idx" ON public."CrmCampaign1" USING btree ("CampaignId");
 1   DROP INDEX public."CrmCampaign1_CampaignId_idx";
       public            postgres    false    434    6438    434            0           1259    20444    CrmCampaign2_CampaignId_idx    INDEX     `   CREATE INDEX "CrmCampaign2_CampaignId_idx" ON public."CrmCampaign2" USING btree ("CampaignId");
 1   DROP INDEX public."CrmCampaign2_CampaignId_idx";
       public            postgres    false    6438    436    436            '           1259    20416    CrmCampaign3_CampaignId_idx    INDEX     `   CREATE INDEX "CrmCampaign3_CampaignId_idx" ON public."CrmCampaign3" USING btree ("CampaignId");
 1   DROP INDEX public."CrmCampaign3_CampaignId_idx";
       public            postgres    false    6438    433    433            �           1259    19348 $   idx_crmcompanyactivitylog_activityid    INDEX     u   CREATE INDEX idx_crmcompanyactivitylog_activityid ON ONLY public."CrmCompanyActivityLog" USING btree ("ActivityId");
 8   DROP INDEX public.idx_crmcompanyactivitylog_activityid;
       public            postgres    false    279            �           1259    19349 -   CrmCompanyActivityLogTenant100_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant100_ActivityId_idx" ON public."CrmCompanyActivityLogTenant100" USING btree ("ActivityId");
 C   DROP INDEX public."CrmCompanyActivityLogTenant100_ActivityId_idx";
       public            postgres    false    282    6073    282            �           1259    19350 +   CrmCompanyActivityLogTenant1_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant1_ActivityId_idx" ON public."CrmCompanyActivityLogTenant1" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant1_ActivityId_idx";
       public            postgres    false    281    281    6073            �           1259    19351 +   CrmCompanyActivityLogTenant2_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant2_ActivityId_idx" ON public."CrmCompanyActivityLogTenant2" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant2_ActivityId_idx";
       public            postgres    false    283    283    6073            �           1259    19352 +   CrmCompanyActivityLogTenant3_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant3_ActivityId_idx" ON public."CrmCompanyActivityLogTenant3" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant3_ActivityId_idx";
       public            postgres    false    284    6073    284            �           1259    19353    idx_crmcompanymember_companyid    INDEX     i   CREATE INDEX idx_crmcompanymember_companyid ON ONLY public."CrmCompanyMember" USING btree ("CompanyId");
 2   DROP INDEX public.idx_crmcompanymember_companyid;
       public            postgres    false    285            �           1259    19354 '   CrmCompanyMemberTenant100_CompanyId_idx    INDEX     x   CREATE INDEX "CrmCompanyMemberTenant100_CompanyId_idx" ON public."CrmCompanyMemberTenant100" USING btree ("CompanyId");
 =   DROP INDEX public."CrmCompanyMemberTenant100_CompanyId_idx";
       public            postgres    false    288    288    6088            �           1259    19355    idx_crmcompanymember_memberid    INDEX     g   CREATE INDEX idx_crmcompanymember_memberid ON ONLY public."CrmCompanyMember" USING btree ("MemberId");
 1   DROP INDEX public.idx_crmcompanymember_memberid;
       public            postgres    false    285            �           1259    19356 &   CrmCompanyMemberTenant100_MemberId_idx    INDEX     v   CREATE INDEX "CrmCompanyMemberTenant100_MemberId_idx" ON public."CrmCompanyMemberTenant100" USING btree ("MemberId");
 <   DROP INDEX public."CrmCompanyMemberTenant100_MemberId_idx";
       public            postgres    false    288    6089    288            �           1259    19357 %   CrmCompanyMemberTenant1_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant1_CompanyId_idx" ON public."CrmCompanyMemberTenant1" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant1_CompanyId_idx";
       public            postgres    false    6088    287    287            �           1259    19358 $   CrmCompanyMemberTenant1_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant1_MemberId_idx" ON public."CrmCompanyMemberTenant1" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant1_MemberId_idx";
       public            postgres    false    287    6089    287            �           1259    19359 %   CrmCompanyMemberTenant2_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant2_CompanyId_idx" ON public."CrmCompanyMemberTenant2" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant2_CompanyId_idx";
       public            postgres    false    289    6088    289            �           1259    19360 $   CrmCompanyMemberTenant2_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant2_MemberId_idx" ON public."CrmCompanyMemberTenant2" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant2_MemberId_idx";
       public            postgres    false    289    6089    289            �           1259    19361 %   CrmCompanyMemberTenant3_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant3_CompanyId_idx" ON public."CrmCompanyMemberTenant3" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant3_CompanyId_idx";
       public            postgres    false    290    290    6088            �           1259    19362 $   CrmCompanyMemberTenant3_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant3_MemberId_idx" ON public."CrmCompanyMemberTenant3" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant3_MemberId_idx";
       public            postgres    false    6089    290    290            �           1259    19363    idx_crmcompany_companyid    INDEX     ]   CREATE INDEX idx_crmcompany_companyid ON ONLY public."CrmCompany" USING btree ("CompanyId");
 ,   DROP INDEX public.idx_crmcompany_companyid;
       public            postgres    false    278            �           1259    19364 !   CrmCompanyTenant100_CompanyId_idx    INDEX     l   CREATE INDEX "CrmCompanyTenant100_CompanyId_idx" ON public."CrmCompanyTenant100" USING btree ("CompanyId");
 7   DROP INDEX public."CrmCompanyTenant100_CompanyId_idx";
       public            postgres    false    6070    293    293            �           1259    19365    CrmCompanyTenant1_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant1_CompanyId_idx" ON public."CrmCompanyTenant1" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant1_CompanyId_idx";
       public            postgres    false    292    292    6070            �           1259    19366    CrmCompanyTenant2_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant2_CompanyId_idx" ON public."CrmCompanyTenant2" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant2_CompanyId_idx";
       public            postgres    false    294    6070    294            �           1259    19367    CrmCompanyTenant3_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant3_CompanyId_idx" ON public."CrmCompanyTenant3" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant3_CompanyId_idx";
       public            postgres    false    295    6070    295            �           1259    19368 
   idx_ListId    INDEX     R   CREATE INDEX "idx_ListId" ON ONLY public."CrmCustomLists" USING btree ("ListId");
     DROP INDEX public."idx_ListId";
       public            postgres    false    296            �           1259    19369 "   CrmCustomListsTenant100_ListId_idx    INDEX     n   CREATE INDEX "CrmCustomListsTenant100_ListId_idx" ON public."CrmCustomListsTenant100" USING btree ("ListId");
 8   DROP INDEX public."CrmCustomListsTenant100_ListId_idx";
       public            postgres    false    299    299    6120            �           1259    19370     CrmCustomListsTenant1_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant1_ListId_idx" ON public."CrmCustomListsTenant1" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant1_ListId_idx";
       public            postgres    false    298    298    6120            �           1259    19371     CrmCustomListsTenant2_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant2_ListId_idx" ON public."CrmCustomListsTenant2" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant2_ListId_idx";
       public            postgres    false    300    6120    300            �           1259    19372     CrmCustomListsTenant3_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant3_ListId_idx" ON public."CrmCustomListsTenant3" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant3_ListId_idx";
       public            postgres    false    301    301    6120            �           1259    19373    idx_EmailId    INDEX     N   CREATE INDEX "idx_EmailId" ON ONLY public."CrmEmail" USING btree ("EmailId");
 !   DROP INDEX public."idx_EmailId";
       public            postgres    false    302            �           1259    19374    CrmEmail100_EmailId_idx    INDEX     X   CREATE INDEX "CrmEmail100_EmailId_idx" ON public."CrmEmail100" USING btree ("EmailId");
 -   DROP INDEX public."CrmEmail100_EmailId_idx";
       public            postgres    false    305    6135    305            �           1259    19375    CrmEmail1_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail1_EmailId_idx" ON public."CrmEmail1" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail1_EmailId_idx";
       public            postgres    false    6135    304    304            �           1259    19376    CrmEmail2_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail2_EmailId_idx" ON public."CrmEmail2" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail2_EmailId_idx";
       public            postgres    false    306    306    6135                       1259    19377    CrmEmail3_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail3_EmailId_idx" ON public."CrmEmail3" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail3_EmailId_idx";
       public            postgres    false    6135    307    307            5           1259    20961    idx_FieldId    INDEX     S   CREATE INDEX "idx_FieldId" ON ONLY public."CrmFormFields" USING btree ("FieldId");
 !   DROP INDEX public."idx_FieldId";
       public            postgres    false    438            ?           1259    20965    CrmFormFields100_FieldId_idx    INDEX     b   CREATE INDEX "CrmFormFields100_FieldId_idx" ON public."CrmFormFields100" USING btree ("FieldId");
 2   DROP INDEX public."CrmFormFields100_FieldId_idx";
       public            postgres    false    442    442    6453            6           1259    20962    CrmFormFields1_FieldId_idx    INDEX     ^   CREATE INDEX "CrmFormFields1_FieldId_idx" ON public."CrmFormFields1" USING btree ("FieldId");
 0   DROP INDEX public."CrmFormFields1_FieldId_idx";
       public            postgres    false    6453    439    439            9           1259    20963    CrmFormFields2_FieldId_idx    INDEX     ^   CREATE INDEX "CrmFormFields2_FieldId_idx" ON public."CrmFormFields2" USING btree ("FieldId");
 0   DROP INDEX public."CrmFormFields2_FieldId_idx";
       public            postgres    false    440    6453    440            <           1259    20964    CrmFormFields3_FieldId_idx    INDEX     ^   CREATE INDEX "CrmFormFields3_FieldId_idx" ON public."CrmFormFields3" USING btree ("FieldId");
 0   DROP INDEX public."CrmFormFields3_FieldId_idx";
       public            postgres    false    441    6453    441            D           1259    21015    idx_ResultId    INDEX     V   CREATE INDEX "idx_ResultId" ON ONLY public."CrmFormResults" USING btree ("ResultId");
 "   DROP INDEX public."idx_ResultId";
       public            postgres    false    444            N           1259    21019    CrmFormResults100_ResultId_idx    INDEX     f   CREATE INDEX "CrmFormResults100_ResultId_idx" ON public."CrmFormResults100" USING btree ("ResultId");
 4   DROP INDEX public."CrmFormResults100_ResultId_idx";
       public            postgres    false    448    6468    448            E           1259    21016    CrmFormResults1_ResultId_idx    INDEX     b   CREATE INDEX "CrmFormResults1_ResultId_idx" ON public."CrmFormResults1" USING btree ("ResultId");
 2   DROP INDEX public."CrmFormResults1_ResultId_idx";
       public            postgres    false    445    445    6468            H           1259    21017    CrmFormResults2_ResultId_idx    INDEX     b   CREATE INDEX "CrmFormResults2_ResultId_idx" ON public."CrmFormResults2" USING btree ("ResultId");
 2   DROP INDEX public."CrmFormResults2_ResultId_idx";
       public            postgres    false    446    446    6468            K           1259    21018    CrmFormResults3_ResultId_idx    INDEX     b   CREATE INDEX "CrmFormResults3_ResultId_idx" ON public."CrmFormResults3" USING btree ("ResultId");
 2   DROP INDEX public."CrmFormResults3_ResultId_idx";
       public            postgres    false    6468    447    447                       1259    19378    idx_crmindustry_industryid    INDEX     a   CREATE INDEX idx_crmindustry_industryid ON ONLY public."CrmIndustry" USING btree ("IndustryId");
 .   DROP INDEX public.idx_crmindustry_industryid;
       public            postgres    false    308            
           1259    19379 #   CrmIndustryTenant100_IndustryId_idx    INDEX     p   CREATE INDEX "CrmIndustryTenant100_IndustryId_idx" ON public."CrmIndustryTenant100" USING btree ("IndustryId");
 9   DROP INDEX public."CrmIndustryTenant100_IndustryId_idx";
       public            postgres    false    6150    311    311                       1259    19380 !   CrmIndustryTenant1_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant1_IndustryId_idx" ON public."CrmIndustryTenant1" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant1_IndustryId_idx";
       public            postgres    false    6150    310    310                       1259    19381 !   CrmIndustryTenant2_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant2_IndustryId_idx" ON public."CrmIndustryTenant2" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant2_IndustryId_idx";
       public            postgres    false    312    6150    312                       1259    19382 !   CrmIndustryTenant3_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant3_IndustryId_idx" ON public."CrmIndustryTenant3" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant3_IndustryId_idx";
       public            postgres    false    313    6150    313                       1259    19383 !   idx_crmleadactivitylog_activityid    INDEX     o   CREATE INDEX idx_crmleadactivitylog_activityid ON ONLY public."CrmLeadActivityLog" USING btree ("ActivityId");
 5   DROP INDEX public.idx_crmleadactivitylog_activityid;
       public            postgres    false    315                       1259    19384 *   CrmLeadActivityLogTenant100_ActivityId_idx    INDEX     ~   CREATE INDEX "CrmLeadActivityLogTenant100_ActivityId_idx" ON public."CrmLeadActivityLogTenant100" USING btree ("ActivityId");
 @   DROP INDEX public."CrmLeadActivityLogTenant100_ActivityId_idx";
       public            postgres    false    318    6168    318                       1259    19385 (   CrmLeadActivityLogTenant1_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant1_ActivityId_idx" ON public."CrmLeadActivityLogTenant1" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant1_ActivityId_idx";
       public            postgres    false    317    6168    317                       1259    19386 (   CrmLeadActivityLogTenant2_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant2_ActivityId_idx" ON public."CrmLeadActivityLogTenant2" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant2_ActivityId_idx";
       public            postgres    false    319    319    6168            "           1259    19387 (   CrmLeadActivityLogTenant3_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant3_ActivityId_idx" ON public."CrmLeadActivityLogTenant3" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant3_ActivityId_idx";
       public            postgres    false    6168    320    320            '           1259    19388    idx_crmleadsource_sourceid    INDEX     a   CREATE INDEX idx_crmleadsource_sourceid ON ONLY public."CrmLeadSource" USING btree ("SourceId");
 .   DROP INDEX public.idx_crmleadsource_sourceid;
       public            postgres    false    321            +           1259    19389 #   CrmLeadSourceTenant100_SourceId_idx    INDEX     p   CREATE INDEX "CrmLeadSourceTenant100_SourceId_idx" ON public."CrmLeadSourceTenant100" USING btree ("SourceId");
 9   DROP INDEX public."CrmLeadSourceTenant100_SourceId_idx";
       public            postgres    false    324    324    6183            (           1259    19390 !   CrmLeadSourceTenant1_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant1_SourceId_idx" ON public."CrmLeadSourceTenant1" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant1_SourceId_idx";
       public            postgres    false    323    6183    323            .           1259    19391 !   CrmLeadSourceTenant2_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant2_SourceId_idx" ON public."CrmLeadSourceTenant2" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant2_SourceId_idx";
       public            postgres    false    325    325    6183            1           1259    19392 !   CrmLeadSourceTenant3_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant3_SourceId_idx" ON public."CrmLeadSourceTenant3" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant3_SourceId_idx";
       public            postgres    false    326    6183    326            6           1259    19393    idx_crmleadstatus_statusid    INDEX     a   CREATE INDEX idx_crmleadstatus_statusid ON ONLY public."CrmLeadStatus" USING btree ("StatusId");
 .   DROP INDEX public.idx_crmleadstatus_statusid;
       public            postgres    false    327            :           1259    19394 #   CrmLeadStatusTenant100_StatusId_idx    INDEX     p   CREATE INDEX "CrmLeadStatusTenant100_StatusId_idx" ON public."CrmLeadStatusTenant100" USING btree ("StatusId");
 9   DROP INDEX public."CrmLeadStatusTenant100_StatusId_idx";
       public            postgres    false    330    330    6198            7           1259    19395 !   CrmLeadStatusTenant1_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant1_StatusId_idx" ON public."CrmLeadStatusTenant1" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant1_StatusId_idx";
       public            postgres    false    6198    329    329            =           1259    19396 !   CrmLeadStatusTenant2_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant2_StatusId_idx" ON public."CrmLeadStatusTenant2" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant2_StatusId_idx";
       public            postgres    false    6198    331    331            @           1259    19397 !   CrmLeadStatusTenant3_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant3_StatusId_idx" ON public."CrmLeadStatusTenant3" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant3_StatusId_idx";
       public            postgres    false    6198    332    332                       1259    19398    idx_crmlead_leadid    INDEX     Q   CREATE INDEX idx_crmlead_leadid ON ONLY public."CrmLead" USING btree ("LeadId");
 &   DROP INDEX public.idx_crmlead_leadid;
       public            postgres    false    314            F           1259    19399    CrmLeadTenant100_LeadId_idx    INDEX     `   CREATE INDEX "CrmLeadTenant100_LeadId_idx" ON public."CrmLeadTenant100" USING btree ("LeadId");
 1   DROP INDEX public."CrmLeadTenant100_LeadId_idx";
       public            postgres    false    6165    335    335            C           1259    19400    CrmLeadTenant1_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant1_LeadId_idx" ON public."CrmLeadTenant1" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant1_LeadId_idx";
       public            postgres    false    334    6165    334            I           1259    19401    CrmLeadTenant2_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant2_LeadId_idx" ON public."CrmLeadTenant2" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant2_LeadId_idx";
       public            postgres    false    336    336    6165            L           1259    19402    CrmLeadTenant3_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant3_LeadId_idx" ON public."CrmLeadTenant3" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant3_LeadId_idx";
       public            postgres    false    6165    337    337            Q           1259    19403    idx_MeetingId    INDEX     T   CREATE INDEX "idx_MeetingId" ON ONLY public."CrmMeeting" USING btree ("MeetingId");
 #   DROP INDEX public."idx_MeetingId";
       public            postgres    false    338            U           1259    19404    CrmMeeting100_MeetingId_idx    INDEX     `   CREATE INDEX "CrmMeeting100_MeetingId_idx" ON public."CrmMeeting100" USING btree ("MeetingId");
 1   DROP INDEX public."CrmMeeting100_MeetingId_idx";
       public            postgres    false    6225    341    341            R           1259    19405    CrmMeeting1_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting1_MeetingId_idx" ON public."CrmMeeting1" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting1_MeetingId_idx";
       public            postgres    false    340    6225    340            X           1259    19406    CrmMeeting2_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting2_MeetingId_idx" ON public."CrmMeeting2" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting2_MeetingId_idx";
       public            postgres    false    342    342    6225            [           1259    19407    CrmMeeting3_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting3_MeetingId_idx" ON public."CrmMeeting3" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting3_MeetingId_idx";
       public            postgres    false    343    6225    343            c           1259    19408    idx_NoteTagsId    INDEX     W   CREATE INDEX "idx_NoteTagsId" ON ONLY public."CrmNoteTags" USING btree ("NoteTagsId");
 $   DROP INDEX public."idx_NoteTagsId";
       public            postgres    false    345            g           1259    19409 #   CrmNoteTagsTenant100_NoteTagsId_idx    INDEX     p   CREATE INDEX "CrmNoteTagsTenant100_NoteTagsId_idx" ON public."CrmNoteTagsTenant100" USING btree ("NoteTagsId");
 9   DROP INDEX public."CrmNoteTagsTenant100_NoteTagsId_idx";
       public            postgres    false    348    348    6243            d           1259    19410 !   CrmNoteTagsTenant1_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant1_NoteTagsId_idx" ON public."CrmNoteTagsTenant1" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant1_NoteTagsId_idx";
       public            postgres    false    6243    347    347            j           1259    19411 !   CrmNoteTagsTenant2_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant2_NoteTagsId_idx" ON public."CrmNoteTagsTenant2" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant2_NoteTagsId_idx";
       public            postgres    false    349    349    6243            m           1259    19412 !   CrmNoteTagsTenant3_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant3_NoteTagsId_idx" ON public."CrmNoteTagsTenant3" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant3_NoteTagsId_idx";
       public            postgres    false    6243    350    350            r           1259    19413    idx_NoteTaskId    INDEX     X   CREATE INDEX "idx_NoteTaskId" ON ONLY public."CrmNoteTasks" USING btree ("NoteTaskId");
 $   DROP INDEX public."idx_NoteTaskId";
       public            postgres    false    351            v           1259    19414 $   CrmNoteTasksTenant100_NoteTaskId_idx    INDEX     r   CREATE INDEX "CrmNoteTasksTenant100_NoteTaskId_idx" ON public."CrmNoteTasksTenant100" USING btree ("NoteTaskId");
 :   DROP INDEX public."CrmNoteTasksTenant100_NoteTaskId_idx";
       public            postgres    false    6258    354    354            s           1259    19415 "   CrmNoteTasksTenant1_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant1_NoteTaskId_idx" ON public."CrmNoteTasksTenant1" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant1_NoteTaskId_idx";
       public            postgres    false    353    6258    353            y           1259    19416 "   CrmNoteTasksTenant2_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant2_NoteTaskId_idx" ON public."CrmNoteTasksTenant2" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant2_NoteTaskId_idx";
       public            postgres    false    355    355    6258            |           1259    19417 "   CrmNoteTasksTenant3_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant3_NoteTaskId_idx" ON public."CrmNoteTasksTenant3" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant3_NoteTaskId_idx";
       public            postgres    false    6258    356    356            `           1259    19418    idx_crmnote_noteid    INDEX     Q   CREATE INDEX idx_crmnote_noteid ON ONLY public."CrmNote" USING btree ("NoteId");
 &   DROP INDEX public.idx_crmnote_noteid;
       public            postgres    false    344            �           1259    19419    CrmNoteTenant100_NoteId_idx    INDEX     `   CREATE INDEX "CrmNoteTenant100_NoteId_idx" ON public."CrmNoteTenant100" USING btree ("NoteId");
 1   DROP INDEX public."CrmNoteTenant100_NoteId_idx";
       public            postgres    false    6240    359    359                       1259    19420    CrmNoteTenant1_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant1_NoteId_idx" ON public."CrmNoteTenant1" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant1_NoteId_idx";
       public            postgres    false    6240    358    358            �           1259    19421    CrmNoteTenant2_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant2_NoteId_idx" ON public."CrmNoteTenant2" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant2_NoteId_idx";
       public            postgres    false    360    6240    360            �           1259    19422    CrmNoteTenant3_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant3_NoteId_idx" ON public."CrmNoteTenant3" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant3_NoteId_idx";
       public            postgres    false    361    361    6240            �           1259    19423    idx_OpportunityId    INDEX     `   CREATE INDEX "idx_OpportunityId" ON ONLY public."CrmOpportunity" USING btree ("OpportunityId");
 '   DROP INDEX public."idx_OpportunityId";
       public            postgres    false    362            �           1259    19424 #   CrmOpportunity100_OpportunityId_idx    INDEX     p   CREATE INDEX "CrmOpportunity100_OpportunityId_idx" ON public."CrmOpportunity100" USING btree ("OpportunityId");
 9   DROP INDEX public."CrmOpportunity100_OpportunityId_idx";
       public            postgres    false    365    365    6285            �           1259    19425 !   CrmOpportunity1_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity1_OpportunityId_idx" ON public."CrmOpportunity1" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity1_OpportunityId_idx";
       public            postgres    false    6285    364    364            �           1259    19426 !   CrmOpportunity2_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity2_OpportunityId_idx" ON public."CrmOpportunity2" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity2_OpportunityId_idx";
       public            postgres    false    6285    366    366            �           1259    19427 !   CrmOpportunity3_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity3_OpportunityId_idx" ON public."CrmOpportunity3" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity3_OpportunityId_idx";
       public            postgres    false    367    6285    367            �           1259    19428    idx_crmproduct_productid    INDEX     ]   CREATE INDEX idx_crmproduct_productid ON ONLY public."CrmProduct" USING btree ("ProductId");
 ,   DROP INDEX public.idx_crmproduct_productid;
       public            postgres    false    370            �           1259    19429 !   CrmProductTenant100_ProductId_idx    INDEX     l   CREATE INDEX "CrmProductTenant100_ProductId_idx" ON public."CrmProductTenant100" USING btree ("ProductId");
 7   DROP INDEX public."CrmProductTenant100_ProductId_idx";
       public            postgres    false    6302    373    373            �           1259    19430    CrmProductTenant1_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant1_ProductId_idx" ON public."CrmProductTenant1" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant1_ProductId_idx";
       public            postgres    false    372    372    6302            �           1259    19431    CrmProductTenant2_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant2_ProductId_idx" ON public."CrmProductTenant2" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant2_ProductId_idx";
       public            postgres    false    374    374    6302            �           1259    19432    CrmProductTenant3_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant3_ProductId_idx" ON public."CrmProductTenant3" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant3_ProductId_idx";
       public            postgres    false    375    375    6302            �           1259    19433    idx_crmtagused_tagusedid    INDEX     ]   CREATE INDEX idx_crmtagused_tagusedid ON ONLY public."CrmTagUsed" USING btree ("TagUsedId");
 ,   DROP INDEX public.idx_crmtagused_tagusedid;
       public            postgres    false    376            �           1259    19434 !   CrmTagUsedTenant100_TagUsedId_idx    INDEX     l   CREATE INDEX "CrmTagUsedTenant100_TagUsedId_idx" ON public."CrmTagUsedTenant100" USING btree ("TagUsedId");
 7   DROP INDEX public."CrmTagUsedTenant100_TagUsedId_idx";
       public            postgres    false    379    6317    379            �           1259    19435    CrmTagUsedTenant1_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant1_TagUsedId_idx" ON public."CrmTagUsedTenant1" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant1_TagUsedId_idx";
       public            postgres    false    378    6317    378            �           1259    19436    CrmTagUsedTenant2_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant2_TagUsedId_idx" ON public."CrmTagUsedTenant2" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant2_TagUsedId_idx";
       public            postgres    false    6317    380    380            �           1259    19437    CrmTagUsedTenant3_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant3_TagUsedId_idx" ON public."CrmTagUsedTenant3" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant3_TagUsedId_idx";
       public            postgres    false    381    6317    381            �           1259    19438    idx_crmtags_tagid    INDEX     O   CREATE INDEX idx_crmtags_tagid ON ONLY public."CrmTags" USING btree ("TagId");
 %   DROP INDEX public.idx_crmtags_tagid;
       public            postgres    false    382            �           1259    19439    CrmTagsTenant100_TagId_idx    INDEX     ^   CREATE INDEX "CrmTagsTenant100_TagId_idx" ON public."CrmTagsTenant100" USING btree ("TagId");
 0   DROP INDEX public."CrmTagsTenant100_TagId_idx";
       public            postgres    false    6332    385    385            �           1259    19440    CrmTagsTenant1_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant1_TagId_idx" ON public."CrmTagsTenant1" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant1_TagId_idx";
       public            postgres    false    384    384    6332            �           1259    19441    CrmTagsTenant2_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant2_TagId_idx" ON public."CrmTagsTenant2" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant2_TagId_idx";
       public            postgres    false    386    6332    386            �           1259    19442    CrmTagsTenant3_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant3_TagId_idx" ON public."CrmTagsTenant3" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant3_TagId_idx";
       public            postgres    false    6332    387    387            �           1259    19443    idx_TaskTagsId    INDEX     W   CREATE INDEX "idx_TaskTagsId" ON ONLY public."CrmTaskTags" USING btree ("TaskTagsId");
 $   DROP INDEX public."idx_TaskTagsId";
       public            postgres    false    393            �           1259    19444 #   CrmTaskTagsTenant100_TaskTagsId_idx    INDEX     p   CREATE INDEX "CrmTaskTagsTenant100_TaskTagsId_idx" ON public."CrmTaskTagsTenant100" USING btree ("TaskTagsId");
 9   DROP INDEX public."CrmTaskTagsTenant100_TaskTagsId_idx";
       public            postgres    false    396    6355    396            �           1259    19445 !   CrmTaskTagsTenant1_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant1_TaskTagsId_idx" ON public."CrmTaskTagsTenant1" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant1_TaskTagsId_idx";
       public            postgres    false    395    6355    395            �           1259    19446 !   CrmTaskTagsTenant2_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant2_TaskTagsId_idx" ON public."CrmTaskTagsTenant2" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant2_TaskTagsId_idx";
       public            postgres    false    397    6355    397            �           1259    19447 !   CrmTaskTagsTenant3_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant3_TaskTagsId_idx" ON public."CrmTaskTagsTenant3" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant3_TaskTagsId_idx";
       public            postgres    false    6355    398    398            �           1259    19448    idx_crmtask_noteid    INDEX     Q   CREATE INDEX idx_crmtask_noteid ON ONLY public."CrmTask" USING btree ("TaskId");
 &   DROP INDEX public.idx_crmtask_noteid;
       public            postgres    false    388            �           1259    19449    CrmTaskTenant100_TaskId_idx    INDEX     `   CREATE INDEX "CrmTaskTenant100_TaskId_idx" ON public."CrmTaskTenant100" USING btree ("TaskId");
 1   DROP INDEX public."CrmTaskTenant100_TaskId_idx";
       public            postgres    false    401    401    6347            �           1259    19450    CrmTaskTenant1_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant1_TaskId_idx" ON public."CrmTaskTenant1" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant1_TaskId_idx";
       public            postgres    false    400    400    6347            �           1259    19451    CrmTaskTenant2_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant2_TaskId_idx" ON public."CrmTaskTenant2" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant2_TaskId_idx";
       public            postgres    false    402    6347    402            �           1259    19452    CrmTaskTenant3_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant3_TaskId_idx" ON public."CrmTaskTenant3" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant3_TaskId_idx";
       public            postgres    false    6347    403    403            �           1259    19453    idx_crmteammember_teammemberid    INDEX     i   CREATE INDEX idx_crmteammember_teammemberid ON ONLY public."CrmTeamMember" USING btree ("TeamMemberId");
 2   DROP INDEX public.idx_crmteammember_teammemberid;
       public            postgres    false    405            �           1259    19454 '   CrmTeamMemberTenant100_TeamMemberId_idx    INDEX     x   CREATE INDEX "CrmTeamMemberTenant100_TeamMemberId_idx" ON public."CrmTeamMemberTenant100" USING btree ("TeamMemberId");
 =   DROP INDEX public."CrmTeamMemberTenant100_TeamMemberId_idx";
       public            postgres    false    408    6385    408            �           1259    19455 %   CrmTeamMemberTenant1_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant1_TeamMemberId_idx" ON public."CrmTeamMemberTenant1" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant1_TeamMemberId_idx";
       public            postgres    false    407    407    6385            �           1259    19456 %   CrmTeamMemberTenant2_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant2_TeamMemberId_idx" ON public."CrmTeamMemberTenant2" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant2_TeamMemberId_idx";
       public            postgres    false    6385    409    409            �           1259    19457 %   CrmTeamMemberTenant3_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant3_TeamMemberId_idx" ON public."CrmTeamMemberTenant3" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant3_TeamMemberId_idx";
       public            postgres    false    410    6385    410            �           1259    19458    idx_crmteam_teamid    INDEX     Q   CREATE INDEX idx_crmteam_teamid ON ONLY public."CrmTeam" USING btree ("TeamId");
 &   DROP INDEX public.idx_crmteam_teamid;
       public            postgres    false    404                       1259    19459    CrmTeamTenant100_TeamId_idx    INDEX     `   CREATE INDEX "CrmTeamTenant100_TeamId_idx" ON public."CrmTeamTenant100" USING btree ("TeamId");
 1   DROP INDEX public."CrmTeamTenant100_TeamId_idx";
       public            postgres    false    6382    413    413            �           1259    19460    CrmTeamTenant1_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant1_TeamId_idx" ON public."CrmTeamTenant1" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant1_TeamId_idx";
       public            postgres    false    412    6382    412                       1259    19461    CrmTeamTenant2_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant2_TeamId_idx" ON public."CrmTeamTenant2" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant2_TeamId_idx";
       public            postgres    false    414    414    6382                       1259    19462    CrmTeamTenant3_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant3_TeamId_idx" ON public."CrmTeamTenant3" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant3_TeamId_idx";
       public            postgres    false    6382    415    415                       1259    19463 !   idx_crmuseractivitylog_activityid    INDEX     o   CREATE INDEX idx_crmuseractivitylog_activityid ON ONLY public."CrmUserActivityLog" USING btree ("ActivityId");
 5   DROP INDEX public.idx_crmuseractivitylog_activityid;
       public            postgres    false    416                       1259    19464 *   CrmUserActivityLogTenant100_ActivityId_idx    INDEX     ~   CREATE INDEX "CrmUserActivityLogTenant100_ActivityId_idx" ON public."CrmUserActivityLogTenant100" USING btree ("ActivityId");
 @   DROP INDEX public."CrmUserActivityLogTenant100_ActivityId_idx";
       public            postgres    false    419    419    6412                       1259    19465 (   CrmUserActivityLogTenant1_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant1_ActivityId_idx" ON public."CrmUserActivityLogTenant1" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant1_ActivityId_idx";
       public            postgres    false    418    418    6412                       1259    19466 (   CrmUserActivityLogTenant2_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant2_ActivityId_idx" ON public."CrmUserActivityLogTenant2" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant2_ActivityId_idx";
       public            postgres    false    6412    420    420                       1259    19467 (   CrmUserActivityLogTenant3_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant3_ActivityId_idx" ON public."CrmUserActivityLogTenant3" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant3_ActivityId_idx";
       public            postgres    false    421    6412    421            �           1259    19468    idx_crmtaskpriority_priorityid    INDEX     d   CREATE INDEX idx_crmtaskpriority_priorityid ON public."CrmTaskPriority" USING btree ("PriorityId");
 2   DROP INDEX public.idx_crmtaskpriority_priorityid;
       public            postgres    false    389                       1259    19469    idxtenant_priorityid    INDEX     O   CREATE INDEX idxtenant_priorityid ON public."Tenant" USING btree ("TenantId");
 (   DROP INDEX public.idxtenant_priorityid;
       public            postgres    false    424            S           0    0    CrmAdAccount100_AccountId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount100_AccountId_idx";
          public          postgres    false    6027    6023    261    258            T           0    0    CrmAdAccount100_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount100_pkey";
          public          postgres    false    6029    6022    261    6022    261    258            Q           0    0    CrmAdAccount1_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount1_AccountId_idx";
          public          postgres    false    6024    6023    260    258            R           0    0    CrmAdAccount1_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount1_pkey";
          public          postgres    false    6026    6022    260    6022    260    258            U           0    0    CrmAdAccount2_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount2_AccountId_idx";
          public          postgres    false    6030    6023    262    258            V           0    0    CrmAdAccount2_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount2_pkey";
          public          postgres    false    6022    6032    262    6022    262    258            W           0    0    CrmAdAccount3_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount3_AccountId_idx";
          public          postgres    false    6033    6023    263    258            X           0    0    CrmAdAccount3_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount3_pkey";
          public          postgres    false    263    6022    6035    6022    263    258            [           0    0 &   CrmCalenderEventsTenant100_EventId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant100_EventId_idx";
          public          postgres    false    6044    6040    269    266            \           0    0    CrmCalenderEventsTenant100_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant100_pkey";
          public          postgres    false    6046    269    6039    6039    269    266            Y           0    0 $   CrmCalenderEventsTenant1_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant1_EventId_idx";
          public          postgres    false    6041    6040    268    266            Z           0    0    CrmCalenderEventsTenant1_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant1_pkey";
          public          postgres    false    268    6043    6039    6039    268    266            ]           0    0 $   CrmCalenderEventsTenant2_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant2_EventId_idx";
          public          postgres    false    6047    6040    270    266            ^           0    0    CrmCalenderEventsTenant2_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant2_pkey";
          public          postgres    false    270    6049    6039    6039    270    266            _           0    0 $   CrmCalenderEventsTenant3_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant3_EventId_idx";
          public          postgres    false    6050    6040    271    266            `           0    0    CrmCalenderEventsTenant3_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant3_pkey";
          public          postgres    false    6052    6039    271    6039    271    266            c           0    0    CrmCall100_CallId_idx    INDEX ATTACH     Q   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall100_CallId_idx";
          public          postgres    false    6059    6055    275    272            d           0    0    CrmCall100_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall100_pkey";
          public          postgres    false    6054    275    6061    6054    275    272            a           0    0    CrmCall1_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall1_CallId_idx";
          public          postgres    false    6056    6055    274    272            b           0    0    CrmCall1_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall1_pkey";
          public          postgres    false    274    6058    6054    6054    274    272            e           0    0    CrmCall2_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall2_CallId_idx";
          public          postgres    false    6062    6055    276    272            f           0    0    CrmCall2_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall2_pkey";
          public          postgres    false    6064    276    6054    6054    276    272            g           0    0    CrmCall3_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall3_CallId_idx";
          public          postgres    false    6065    6055    277    272            h           0    0    CrmCall3_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall3_pkey";
          public          postgres    false    6067    6054    277    6054    277    272            )           0    0    CrmCampaign100_CampaignId_idx    INDEX ATTACH     ]   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign100_CampaignId_idx";
          public          postgres    false    6445    6438    435    432            *           0    0    CrmCampaign100_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign100_pkey";
          public          postgres    false    6447    6437    435    6437    435    432            '           0    0    CrmCampaign1_CampaignId_idx    INDEX ATTACH     [   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign1_CampaignId_idx";
          public          postgres    false    6442    6438    434    432            (           0    0    CrmCampaign1_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign1_pkey";
          public          postgres    false    6437    434    6444    6437    434    432            +           0    0    CrmCampaign2_CampaignId_idx    INDEX ATTACH     [   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign2_CampaignId_idx";
          public          postgres    false    6448    6438    436    432            ,           0    0    CrmCampaign2_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign2_pkey";
          public          postgres    false    6437    436    6450    6437    436    432            %           0    0    CrmCampaign3_CampaignId_idx    INDEX ATTACH     [   ALTER INDEX public."idx_CampaignId" ATTACH PARTITION public."CrmCampaign3_CampaignId_idx";
          public          postgres    false    6439    6438    433    432            &           0    0    CrmCampaign3_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmCampaign_pkey" ATTACH PARTITION public."CrmCampaign3_pkey";
          public          postgres    false    433    6437    6441    6437    433    432            k           0    0 -   CrmCompanyActivityLogTenant100_ActivityId_idx    INDEX ATTACH     �   ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant100_ActivityId_idx";
          public          postgres    false    6077    6073    282    279            l           0    0 #   CrmCompanyActivityLogTenant100_pkey    INDEX ATTACH     o   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant100_pkey";
          public          postgres    false    282    6072    6079    6072    282    279            i           0    0 +   CrmCompanyActivityLogTenant1_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant1_ActivityId_idx";
          public          postgres    false    6074    6073    281    279            j           0    0 !   CrmCompanyActivityLogTenant1_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant1_pkey";
          public          postgres    false    6076    6072    281    6072    281    279            m           0    0 +   CrmCompanyActivityLogTenant2_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant2_ActivityId_idx";
          public          postgres    false    6080    6073    283    279            n           0    0 !   CrmCompanyActivityLogTenant2_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant2_pkey";
          public          postgres    false    283    6082    6072    6072    283    279            o           0    0 +   CrmCompanyActivityLogTenant3_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant3_ActivityId_idx";
          public          postgres    false    6083    6073    284    279            p           0    0 !   CrmCompanyActivityLogTenant3_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant3_pkey";
          public          postgres    false    284    6085    6072    6072    284    279            t           0    0 '   CrmCompanyMemberTenant100_CompanyId_idx    INDEX ATTACH     u   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant100_CompanyId_idx";
          public          postgres    false    6094    6088    288    285            u           0    0 &   CrmCompanyMemberTenant100_MemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant100_MemberId_idx";
          public          postgres    false    6095    6089    288    285            v           0    0    CrmCompanyMemberTenant100_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant100_pkey";
          public          postgres    false    6097    288    6087    6087    288    285            q           0    0 %   CrmCompanyMemberTenant1_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant1_CompanyId_idx";
          public          postgres    false    6090    6088    287    285            r           0    0 $   CrmCompanyMemberTenant1_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant1_MemberId_idx";
          public          postgres    false    6091    6089    287    285            s           0    0    CrmCompanyMemberTenant1_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant1_pkey";
          public          postgres    false    6087    287    6093    6087    287    285            w           0    0 %   CrmCompanyMemberTenant2_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant2_CompanyId_idx";
          public          postgres    false    6098    6088    289    285            x           0    0 $   CrmCompanyMemberTenant2_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant2_MemberId_idx";
          public          postgres    false    6099    6089    289    285            y           0    0    CrmCompanyMemberTenant2_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant2_pkey";
          public          postgres    false    6087    289    6101    6087    289    285            z           0    0 %   CrmCompanyMemberTenant3_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant3_CompanyId_idx";
          public          postgres    false    6102    6088    290    285            {           0    0 $   CrmCompanyMemberTenant3_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant3_MemberId_idx";
          public          postgres    false    6103    6089    290    285            |           0    0    CrmCompanyMemberTenant3_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant3_pkey";
          public          postgres    false    290    6105    6087    6087    290    285                       0    0 !   CrmCompanyTenant100_CompanyId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant100_CompanyId_idx";
          public          postgres    false    6109    6070    293    278            �           0    0    CrmCompanyTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant100_pkey";
          public          postgres    false    6111    6069    293    6069    293    278            }           0    0    CrmCompanyTenant1_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant1_CompanyId_idx";
          public          postgres    false    6106    6070    292    278            ~           0    0    CrmCompanyTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant1_pkey";
          public          postgres    false    6069    292    6108    6069    292    278            �           0    0    CrmCompanyTenant2_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant2_CompanyId_idx";
          public          postgres    false    6112    6070    294    278            �           0    0    CrmCompanyTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant2_pkey";
          public          postgres    false    6114    6069    294    6069    294    278            �           0    0    CrmCompanyTenant3_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant3_CompanyId_idx";
          public          postgres    false    6115    6070    295    278            �           0    0    CrmCompanyTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant3_pkey";
          public          postgres    false    6117    6069    295    6069    295    278            �           0    0 "   CrmCustomListsTenant100_ListId_idx    INDEX ATTACH     ^   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant100_ListId_idx";
          public          postgres    false    6124    6120    299    296            �           0    0    CrmCustomListsTenant100_pkey    INDEX ATTACH     a   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant100_pkey";
          public          postgres    false    6119    299    6126    6119    299    296            �           0    0     CrmCustomListsTenant1_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant1_ListId_idx";
          public          postgres    false    6121    6120    298    296            �           0    0    CrmCustomListsTenant1_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant1_pkey";
          public          postgres    false    6123    6119    298    6119    298    296            �           0    0     CrmCustomListsTenant2_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant2_ListId_idx";
          public          postgres    false    6127    6120    300    296            �           0    0    CrmCustomListsTenant2_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant2_pkey";
          public          postgres    false    300    6119    6129    6119    300    296            �           0    0     CrmCustomListsTenant3_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant3_ListId_idx";
          public          postgres    false    6130    6120    301    296            �           0    0    CrmCustomListsTenant3_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant3_pkey";
          public          postgres    false    6119    6132    301    6119    301    296            �           0    0    CrmEmail100_EmailId_idx    INDEX ATTACH     T   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail100_EmailId_idx";
          public          postgres    false    6139    6135    305    302            �           0    0    CrmEmail100_pkey    INDEX ATTACH     O   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail100_pkey";
          public          postgres    false    6141    305    6134    6134    305    302            �           0    0    CrmEmail1_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail1_EmailId_idx";
          public          postgres    false    6136    6135    304    302            �           0    0    CrmEmail1_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail1_pkey";
          public          postgres    false    6134    304    6138    6134    304    302            �           0    0    CrmEmail2_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail2_EmailId_idx";
          public          postgres    false    6142    6135    306    302            �           0    0    CrmEmail2_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail2_pkey";
          public          postgres    false    306    6144    6134    6134    306    302            �           0    0    CrmEmail3_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail3_EmailId_idx";
          public          postgres    false    6145    6135    307    302            �           0    0    CrmEmail3_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail3_pkey";
          public          postgres    false    6147    6134    307    6134    307    302            3           0    0    CrmFormFields100_FieldId_idx    INDEX ATTACH     Y   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields100_FieldId_idx";
          public          postgres    false    6463    6453    442    438            4           0    0    CrmFormFields100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields100_pkey";
          public          postgres    false    6452    442    6465    6452    442    438            -           0    0    CrmFormFields1_FieldId_idx    INDEX ATTACH     W   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields1_FieldId_idx";
          public          postgres    false    6454    6453    439    438            .           0    0    CrmFormFields1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields1_pkey";
          public          postgres    false    6456    6452    439    6452    439    438            /           0    0    CrmFormFields2_FieldId_idx    INDEX ATTACH     W   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields2_FieldId_idx";
          public          postgres    false    6457    6453    440    438            0           0    0    CrmFormFields2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields2_pkey";
          public          postgres    false    440    6452    6459    6452    440    438            1           0    0    CrmFormFields3_FieldId_idx    INDEX ATTACH     W   ALTER INDEX public."idx_FieldId" ATTACH PARTITION public."CrmFormFields3_FieldId_idx";
          public          postgres    false    6460    6453    441    438            2           0    0    CrmFormFields3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmFormFields_pkey" ATTACH PARTITION public."CrmFormFields3_pkey";
          public          postgres    false    6452    441    6462    6452    441    438            ;           0    0    CrmFormResults100_ResultId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults100_ResultId_idx";
          public          postgres    false    6478    6468    448    444            <           0    0    CrmFormResults100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults100_pkey";
          public          postgres    false    448    6480    6467    6467    448    444            5           0    0    CrmFormResults1_ResultId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults1_ResultId_idx";
          public          postgres    false    6469    6468    445    444            6           0    0    CrmFormResults1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults1_pkey";
          public          postgres    false    6471    6467    445    6467    445    444            7           0    0    CrmFormResults2_ResultId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults2_ResultId_idx";
          public          postgres    false    6472    6468    446    444            8           0    0    CrmFormResults2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults2_pkey";
          public          postgres    false    6474    446    6467    6467    446    444            9           0    0    CrmFormResults3_ResultId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_ResultId" ATTACH PARTITION public."CrmFormResults3_ResultId_idx";
          public          postgres    false    6475    6468    447    444            :           0    0    CrmFormResults3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmFormResults_pkey" ATTACH PARTITION public."CrmFormResults3_pkey";
          public          postgres    false    6467    6477    447    6467    447    444            �           0    0 #   CrmIndustryTenant100_IndustryId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant100_IndustryId_idx";
          public          postgres    false    6154    6150    311    308            �           0    0    CrmIndustryTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant100_pkey";
          public          postgres    false    6149    6156    311    6149    311    308            �           0    0 !   CrmIndustryTenant1_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant1_IndustryId_idx";
          public          postgres    false    6151    6150    310    308            �           0    0    CrmIndustryTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant1_pkey";
          public          postgres    false    6153    6149    310    6149    310    308            �           0    0 !   CrmIndustryTenant2_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant2_IndustryId_idx";
          public          postgres    false    6157    6150    312    308            �           0    0    CrmIndustryTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant2_pkey";
          public          postgres    false    312    6159    6149    6149    312    308            �           0    0 !   CrmIndustryTenant3_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant3_IndustryId_idx";
          public          postgres    false    6160    6150    313    308            �           0    0    CrmIndustryTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant3_pkey";
          public          postgres    false    6149    313    6162    6149    313    308            �           0    0 *   CrmLeadActivityLogTenant100_ActivityId_idx    INDEX ATTACH     {   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant100_ActivityId_idx";
          public          postgres    false    6172    6168    318    315            �           0    0     CrmLeadActivityLogTenant100_pkey    INDEX ATTACH     i   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant100_pkey";
          public          postgres    false    6167    6174    318    6167    318    315            �           0    0 (   CrmLeadActivityLogTenant1_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant1_ActivityId_idx";
          public          postgres    false    6169    6168    317    315            �           0    0    CrmLeadActivityLogTenant1_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant1_pkey";
          public          postgres    false    6171    6167    317    6167    317    315            �           0    0 (   CrmLeadActivityLogTenant2_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant2_ActivityId_idx";
          public          postgres    false    6175    6168    319    315            �           0    0    CrmLeadActivityLogTenant2_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant2_pkey";
          public          postgres    false    6177    319    6167    6167    319    315            �           0    0 (   CrmLeadActivityLogTenant3_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant3_ActivityId_idx";
          public          postgres    false    6178    6168    320    315            �           0    0    CrmLeadActivityLogTenant3_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant3_pkey";
          public          postgres    false    320    6180    6167    6167    320    315            �           0    0 #   CrmLeadSourceTenant100_SourceId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant100_SourceId_idx";
          public          postgres    false    6187    6183    324    321            �           0    0    CrmLeadSourceTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant100_pkey";
          public          postgres    false    6189    6182    324    6182    324    321            �           0    0 !   CrmLeadSourceTenant1_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant1_SourceId_idx";
          public          postgres    false    6184    6183    323    321            �           0    0    CrmLeadSourceTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant1_pkey";
          public          postgres    false    6182    323    6186    6182    323    321            �           0    0 !   CrmLeadSourceTenant2_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant2_SourceId_idx";
          public          postgres    false    6190    6183    325    321            �           0    0    CrmLeadSourceTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant2_pkey";
          public          postgres    false    6182    6192    325    6182    325    321            �           0    0 !   CrmLeadSourceTenant3_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant3_SourceId_idx";
          public          postgres    false    6193    6183    326    321            �           0    0    CrmLeadSourceTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant3_pkey";
          public          postgres    false    326    6182    6195    6182    326    321            �           0    0 #   CrmLeadStatusTenant100_StatusId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant100_StatusId_idx";
          public          postgres    false    6202    6198    330    327            �           0    0    CrmLeadStatusTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant100_pkey";
          public          postgres    false    330    6197    6204    6197    330    327            �           0    0 !   CrmLeadStatusTenant1_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant1_StatusId_idx";
          public          postgres    false    6199    6198    329    327            �           0    0    CrmLeadStatusTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant1_pkey";
          public          postgres    false    6197    6201    329    6197    329    327            �           0    0 !   CrmLeadStatusTenant2_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant2_StatusId_idx";
          public          postgres    false    6205    6198    331    327            �           0    0    CrmLeadStatusTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant2_pkey";
          public          postgres    false    6197    331    6207    6197    331    327            �           0    0 !   CrmLeadStatusTenant3_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant3_StatusId_idx";
          public          postgres    false    6208    6198    332    327            �           0    0    CrmLeadStatusTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant3_pkey";
          public          postgres    false    6197    332    6210    6197    332    327            �           0    0    CrmLeadTenant100_LeadId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant100_LeadId_idx";
          public          postgres    false    6214    6165    335    314            �           0    0    CrmLeadTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant100_pkey";
          public          postgres    false    335    6164    6216    6164    335    314            �           0    0    CrmLeadTenant1_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant1_LeadId_idx";
          public          postgres    false    6211    6165    334    314            �           0    0    CrmLeadTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant1_pkey";
          public          postgres    false    334    6164    6213    6164    334    314            �           0    0    CrmLeadTenant2_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant2_LeadId_idx";
          public          postgres    false    6217    6165    336    314            �           0    0    CrmLeadTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant2_pkey";
          public          postgres    false    336    6164    6219    6164    336    314            �           0    0    CrmLeadTenant3_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant3_LeadId_idx";
          public          postgres    false    6220    6165    337    314            �           0    0    CrmLeadTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant3_pkey";
          public          postgres    false    6222    337    6164    6164    337    314            �           0    0    CrmMeeting100_MeetingId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting100_MeetingId_idx";
          public          postgres    false    6229    6225    341    338            �           0    0    CrmMeeting100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting100_pkey";
          public          postgres    false    6224    341    6231    6224    341    338            �           0    0    CrmMeeting1_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting1_MeetingId_idx";
          public          postgres    false    6226    6225    340    338            �           0    0    CrmMeeting1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting1_pkey";
          public          postgres    false    6224    6228    340    6224    340    338            �           0    0    CrmMeeting2_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting2_MeetingId_idx";
          public          postgres    false    6232    6225    342    338            �           0    0    CrmMeeting2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting2_pkey";
          public          postgres    false    6224    6234    342    6224    342    338            �           0    0    CrmMeeting3_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting3_MeetingId_idx";
          public          postgres    false    6235    6225    343    338            �           0    0    CrmMeeting3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting3_pkey";
          public          postgres    false    343    6224    6237    6224    343    338            �           0    0 #   CrmNoteTagsTenant100_NoteTagsId_idx    INDEX ATTACH     c   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant100_NoteTagsId_idx";
          public          postgres    false    6247    6243    348    345            �           0    0    CrmNoteTagsTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant100_pkey";
          public          postgres    false    6242    348    6249    6242    348    345            �           0    0 !   CrmNoteTagsTenant1_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant1_NoteTagsId_idx";
          public          postgres    false    6244    6243    347    345            �           0    0    CrmNoteTagsTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant1_pkey";
          public          postgres    false    347    6246    6242    6242    347    345            �           0    0 !   CrmNoteTagsTenant2_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant2_NoteTagsId_idx";
          public          postgres    false    6250    6243    349    345            �           0    0    CrmNoteTagsTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant2_pkey";
          public          postgres    false    6252    349    6242    6242    349    345            �           0    0 !   CrmNoteTagsTenant3_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant3_NoteTagsId_idx";
          public          postgres    false    6253    6243    350    345            �           0    0    CrmNoteTagsTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant3_pkey";
          public          postgres    false    6255    6242    350    6242    350    345            �           0    0 $   CrmNoteTasksTenant100_NoteTaskId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant100_NoteTaskId_idx";
          public          postgres    false    6262    6258    354    351            �           0    0    CrmNoteTasksTenant100_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant100_pkey";
          public          postgres    false    6257    354    6264    6257    354    351            �           0    0 "   CrmNoteTasksTenant1_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant1_NoteTaskId_idx";
          public          postgres    false    6259    6258    353    351            �           0    0    CrmNoteTasksTenant1_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant1_pkey";
          public          postgres    false    6261    6257    353    6257    353    351            �           0    0 "   CrmNoteTasksTenant2_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant2_NoteTaskId_idx";
          public          postgres    false    6265    6258    355    351            �           0    0    CrmNoteTasksTenant2_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant2_pkey";
          public          postgres    false    355    6257    6267    6257    355    351            �           0    0 "   CrmNoteTasksTenant3_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant3_NoteTaskId_idx";
          public          postgres    false    6268    6258    356    351            �           0    0    CrmNoteTasksTenant3_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant3_pkey";
          public          postgres    false    356    6270    6257    6257    356    351            �           0    0    CrmNoteTenant100_NoteId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant100_NoteId_idx";
          public          postgres    false    6274    6240    359    344            �           0    0    CrmNoteTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant100_pkey";
          public          postgres    false    6239    6276    359    6239    359    344            �           0    0    CrmNoteTenant1_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant1_NoteId_idx";
          public          postgres    false    6271    6240    358    344            �           0    0    CrmNoteTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant1_pkey";
          public          postgres    false    6239    6273    358    6239    358    344            �           0    0    CrmNoteTenant2_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant2_NoteId_idx";
          public          postgres    false    6277    6240    360    344            �           0    0    CrmNoteTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant2_pkey";
          public          postgres    false    6239    360    6279    6239    360    344            �           0    0    CrmNoteTenant3_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant3_NoteId_idx";
          public          postgres    false    6280    6240    361    344            �           0    0    CrmNoteTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant3_pkey";
          public          postgres    false    6239    6282    361    6239    361    344            �           0    0 #   CrmOpportunity100_OpportunityId_idx    INDEX ATTACH     f   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity100_OpportunityId_idx";
          public          postgres    false    6289    6285    365    362            �           0    0    CrmOpportunity100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity100_pkey";
          public          postgres    false    365    6284    6291    6284    365    362            �           0    0 !   CrmOpportunity1_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity1_OpportunityId_idx";
          public          postgres    false    6286    6285    364    362            �           0    0    CrmOpportunity1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity1_pkey";
          public          postgres    false    6284    6288    364    6284    364    362            �           0    0 !   CrmOpportunity2_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity2_OpportunityId_idx";
          public          postgres    false    6292    6285    366    362            �           0    0    CrmOpportunity2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity2_pkey";
          public          postgres    false    6284    6294    366    6284    366    362            �           0    0 !   CrmOpportunity3_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity3_OpportunityId_idx";
          public          postgres    false    6295    6285    367    362            �           0    0    CrmOpportunity3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity3_pkey";
          public          postgres    false    6297    6284    367    6284    367    362            �           0    0 !   CrmProductTenant100_ProductId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant100_ProductId_idx";
          public          postgres    false    6306    6302    373    370            �           0    0    CrmProductTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant100_pkey";
          public          postgres    false    6301    6308    373    6301    373    370            �           0    0    CrmProductTenant1_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant1_ProductId_idx";
          public          postgres    false    6303    6302    372    370            �           0    0    CrmProductTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant1_pkey";
          public          postgres    false    6305    6301    372    6301    372    370            �           0    0    CrmProductTenant2_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant2_ProductId_idx";
          public          postgres    false    6309    6302    374    370            �           0    0    CrmProductTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant2_pkey";
          public          postgres    false    6301    6311    374    6301    374    370            �           0    0    CrmProductTenant3_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant3_ProductId_idx";
          public          postgres    false    6312    6302    375    370            �           0    0    CrmProductTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant3_pkey";
          public          postgres    false    6314    6301    375    6301    375    370            �           0    0 !   CrmTagUsedTenant100_TagUsedId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant100_TagUsedId_idx";
          public          postgres    false    6321    6317    379    376            �           0    0    CrmTagUsedTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant100_pkey";
          public          postgres    false    6316    379    6323    6316    379    376            �           0    0    CrmTagUsedTenant1_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant1_TagUsedId_idx";
          public          postgres    false    6318    6317    378    376            �           0    0    CrmTagUsedTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant1_pkey";
          public          postgres    false    378    6320    6316    6316    378    376            �           0    0    CrmTagUsedTenant2_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant2_TagUsedId_idx";
          public          postgres    false    6324    6317    380    376            �           0    0    CrmTagUsedTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant2_pkey";
          public          postgres    false    6316    380    6326    6316    380    376            �           0    0    CrmTagUsedTenant3_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant3_TagUsedId_idx";
          public          postgres    false    6327    6317    381    376            �           0    0    CrmTagUsedTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant3_pkey";
          public          postgres    false    6316    6329    381    6316    381    376            �           0    0    CrmTagsTenant100_TagId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant100_TagId_idx";
          public          postgres    false    6336    6332    385    382            �           0    0    CrmTagsTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant100_pkey";
          public          postgres    false    6338    6331    385    6331    385    382            �           0    0    CrmTagsTenant1_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant1_TagId_idx";
          public          postgres    false    6333    6332    384    382            �           0    0    CrmTagsTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant1_pkey";
          public          postgres    false    6335    6331    384    6331    384    382            �           0    0    CrmTagsTenant2_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant2_TagId_idx";
          public          postgres    false    6339    6332    386    382            �           0    0    CrmTagsTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant2_pkey";
          public          postgres    false    386    6331    6341    6331    386    382            �           0    0    CrmTagsTenant3_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant3_TagId_idx";
          public          postgres    false    6342    6332    387    382            �           0    0    CrmTagsTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant3_pkey";
          public          postgres    false    387    6344    6331    6331    387    382            �           0    0 #   CrmTaskTagsTenant100_TaskTagsId_idx    INDEX ATTACH     c   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant100_TaskTagsId_idx";
          public          postgres    false    6359    6355    396    393                        0    0    CrmTaskTagsTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant100_pkey";
          public          postgres    false    396    6361    6354    6354    396    393            �           0    0 !   CrmTaskTagsTenant1_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant1_TaskTagsId_idx";
          public          postgres    false    6356    6355    395    393            �           0    0    CrmTaskTagsTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant1_pkey";
          public          postgres    false    6358    6354    395    6354    395    393                       0    0 !   CrmTaskTagsTenant2_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant2_TaskTagsId_idx";
          public          postgres    false    6362    6355    397    393                       0    0    CrmTaskTagsTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant2_pkey";
          public          postgres    false    6364    6354    397    6354    397    393                       0    0 !   CrmTaskTagsTenant3_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant3_TaskTagsId_idx";
          public          postgres    false    6365    6355    398    393                       0    0    CrmTaskTagsTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant3_pkey";
          public          postgres    false    398    6367    6354    6354    398    393                       0    0    CrmTaskTenant100_TaskId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant100_TaskId_idx";
          public          postgres    false    6371    6347    401    388                       0    0    CrmTaskTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant100_pkey";
          public          postgres    false    6346    401    6373    6346    401    388                       0    0    CrmTaskTenant1_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant1_TaskId_idx";
          public          postgres    false    6368    6347    400    388                       0    0    CrmTaskTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant1_pkey";
          public          postgres    false    400    6370    6346    6346    400    388            	           0    0    CrmTaskTenant2_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant2_TaskId_idx";
          public          postgres    false    6374    6347    402    388            
           0    0    CrmTaskTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant2_pkey";
          public          postgres    false    402    6376    6346    6346    402    388                       0    0    CrmTaskTenant3_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant3_TaskId_idx";
          public          postgres    false    6377    6347    403    388                       0    0    CrmTaskTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant3_pkey";
          public          postgres    false    6346    6379    403    6346    403    388                       0    0 '   CrmTeamMemberTenant100_TeamMemberId_idx    INDEX ATTACH     u   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant100_TeamMemberId_idx";
          public          postgres    false    6389    6385    408    405                       0    0    CrmTeamMemberTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant100_pkey";
          public          postgres    false    6391    408    6384    6384    408    405                       0    0 %   CrmTeamMemberTenant1_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant1_TeamMemberId_idx";
          public          postgres    false    6386    6385    407    405                       0    0    CrmTeamMemberTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant1_pkey";
          public          postgres    false    6384    407    6388    6384    407    405                       0    0 %   CrmTeamMemberTenant2_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant2_TeamMemberId_idx";
          public          postgres    false    6392    6385    409    405                       0    0    CrmTeamMemberTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant2_pkey";
          public          postgres    false    409    6384    6394    6384    409    405                       0    0 %   CrmTeamMemberTenant3_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant3_TeamMemberId_idx";
          public          postgres    false    6395    6385    410    405                       0    0    CrmTeamMemberTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant3_pkey";
          public          postgres    false    410    6384    6397    6384    410    405                       0    0    CrmTeamTenant100_TeamId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant100_TeamId_idx";
          public          postgres    false    6401    6382    413    404                       0    0    CrmTeamTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant100_pkey";
          public          postgres    false    6403    6381    413    6381    413    404                       0    0    CrmTeamTenant1_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant1_TeamId_idx";
          public          postgres    false    6398    6382    412    404                       0    0    CrmTeamTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant1_pkey";
          public          postgres    false    412    6400    6381    6381    412    404                       0    0    CrmTeamTenant2_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant2_TeamId_idx";
          public          postgres    false    6404    6382    414    404                       0    0    CrmTeamTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant2_pkey";
          public          postgres    false    414    6381    6406    6381    414    404                       0    0    CrmTeamTenant3_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant3_TeamId_idx";
          public          postgres    false    6407    6382    415    404                       0    0    CrmTeamTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant3_pkey";
          public          postgres    false    6381    415    6409    6381    415    404                       0    0 *   CrmUserActivityLogTenant100_ActivityId_idx    INDEX ATTACH     {   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant100_ActivityId_idx";
          public          postgres    false    6416    6412    419    416                        0    0     CrmUserActivityLogTenant100_pkey    INDEX ATTACH     i   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant100_pkey";
          public          postgres    false    419    6418    6411    6411    419    416                       0    0 (   CrmUserActivityLogTenant1_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant1_ActivityId_idx";
          public          postgres    false    6413    6412    418    416                       0    0    CrmUserActivityLogTenant1_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant1_pkey";
          public          postgres    false    6411    6415    418    6411    418    416            !           0    0 (   CrmUserActivityLogTenant2_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant2_ActivityId_idx";
          public          postgres    false    6419    6412    420    416            "           0    0    CrmUserActivityLogTenant2_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant2_pkey";
          public          postgres    false    6411    6421    420    6411    420    416            #           0    0 (   CrmUserActivityLogTenant3_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant3_ActivityId_idx";
          public          postgres    false    6422    6412    421    416            $           0    0    CrmUserActivityLogTenant3_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant3_pkey";
          public          postgres    false    6424    6411    421    6411    421    416            �   �  x��Uێ�0}����������]m�o�*�qw	�\Z���LL��A���<sΌgpU�9o�����V]�VR�o~��-d)��:
�^_D��R� �,L3̂Gi��-H�0db'�]��R3@��ܯ���J���UUH�m޼5�_��׼��
?��sY�B�Mk=F`�}{(�"��(��P<���N�
�o��Y0�F���Ǎ�����	 0<Asu���]�y�/P�����d���~N���o�A!��T�h�C�.@��d�\ڝN�S�ЌDY8�8I�:S��T`
ـo�����|+���<�l�N��F�jn˘qxN��ն3��d�J{�k�Q���l�[���$�d^D~����y���U"��]W�jQ�Z���UTt�Q�p�4o�Z��c�~��z
q[�-p�%�w�=e=8\�I��4C8HL��j61=��l���5n�3a�����q��0#��� !4a�E��S�/�o�����:�X��6���P�;��!��d^��$s�2�]ih=:�DI3=S�M(�0͢4� �,���4�����:Сx_��woEzQ�.Z̆�Q C��r&��+��S�֨K���m=\�#�cd2�i���ŧ�H �'��N���h��;�_�/���߫r烯?���'y���y�J~U]��0����0���j'��sI<�)E=p̵��Z� �*Y	z �d�V�����W��ڌ�\N��Qwrg��_"2�=��8-@w      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   =   x�3�tN���4�2�t�M���9}SSK2�ҁlN�܂���ļ ϔ3$�8Ȉ���� �[�      �   �   x���M
�0����������!<A7�M�� �ހ�T�ԅ�0�-^��`�s�W�UtS�pb&Y����"'���AH�ā}�\����v(��l}R'`<��B�v���(��Z�Bj�J�-o�p�{��=5,�➪Էߨ[���US|�ʋ:Zc���qL      �      x������ � �      �      x������ � �      �      x������ � �      �   b   x��ͻ�0 �ڙ���%8C0!a D��&@��5��y��.�f����@���j�X�	���\6�<���䁽H����M�~qZǔ���      �      x������ � �      �      x������ � �      �      x������ � �      a   }  x���[j�@E�[����[��"����c���?S2ĉ�i	�@ �ԩ��]E��&b1V����g��}T1�Y�.�U���zh������r0�������z!��n�c��<D���H �b�!j�����J=�ɒ�U�I�J'�O�RM)Wē���W;�j��'X��MJwR�xfi9Q���6�'뀘Ȍ@y=i�kHo6��2տ`��م0I"M���͠L"�A��|�#�T��/�=�D�ѳ �9�s���#��텓��mʎ�LN�]�fV�`�5�v<`*�a��?�h��5�=�z�$B,���4�(߳�e݀�$ �t���=��Ἥ�}W]��s�:;od�wS���%��Ǿ��������-�sY��/�@�      b      x������ � �      c      x������ � �      `      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �     x��W�n#7<S_1��$Hv7s3�S��!lv|�a��&�����%�V�@�b�5k��&�X�,Z�����r�][��6�������P� ��ߵT~\�����ż,[Z�zŷy�x������7��翍o��N����?����-��UbnYfc�tZ%�Л ��(���u&�:�ƪh�w���θ���� �(��Zq���/!��x�gZ<�~j�G�	xj�b��OB?����ew�K7b^u��e�;�v2���̥V�Z�\L��3����w\�.���I�]�]�RZ�U�M+�w[���;xs���+�^CoQ���<������~���:~��@�?�=�@��w�c*�iX#�A�1�!��0��4��Gu�]��(��rp��OG��m�S62i���S�2;J��\#~���o.0�) �4Z��O7�8���ŉ�t�58��{#+d-��d�C����S" 1Y�&��� )q��Bj6��*Z���R�R���7�|YB-��֘+��j[�V&�Eb '�@F���2Dn���!���4ke��1Epa��eC����e5�K,e0%Ts���R8�E��l�.�&���Z�2F�jI�l�����-:3��%�$� ���F3O�z�J�0ϼEQڡ&r	kv��d���bQ�׼n�-g+#���Q��0X�)kE����a�����b�2�)%���s@�}>�	#��*�6�&yn^E"�n˂�����z�H�o���$������Dq���]�H��vvp�D�q��������1�7�^����"��F3�*�y�҅�8�K*���T�l����@z4�WWW�sjm�)K�ι�V�nb�TĈ��;��J��'V�f5 �;�oAx��*��D'-���k�hC�=s0��፯I�𜖍%��Y�?ΘX��qO����3vf6��6���0�ºQGl��a7�H���o��=�������ƾ������F>�^�Y�9��H��t�J|�f�ٿ�dci      �      x������ � �      �      x������ � �      �      x������ � �      �   i   x��1�0k����vA�'�������iFSL�����X������;m+A�,�H����ɐl�[H�3��86��.��C�V#��t$[B�C	      �      x������ � �      �      x������ � �      �      x������ � �      e      x���Mn�0��9�/��	dU�iWmr�l��-HG�J=~?D�������]@��k;�Y�B����8����,��2��tC�����&�7vo겢]U��<.��`,|,����C�E��؅���Ss��_O�'t�k,?R7�v��r��S�!7�ݏ{<f�-=���[y�ܤ4Fz}��6�3�q[|�5���'�&I:QT4�����FkD",_�,X�L�A���(�i���ix�N���;�PE;���NLذ���wbV�;���<D�N��(�_wi�      h      x������ � �      f      x������ � �      g      x������ � �      j      x������ � �      m      x������ � �      k      x������ � �      l      x������ � �      \      x������ � �      �   �  x����n�0D��б=( %Y�ss	�E��r�Pk���4����}i��l^x�!�ά�g>�8���ف܉�������+��6-Vu^[ryEu��7}�V�+��X��
S��5yQg���v���m��l���z�M]��4Qt��Z£gdGr�}C��<��W�D8��a�9�8a"�h�p�����y9��%�~����Y7�"��~qkf�D[x
���^>Wއ�p̓��.�����5�x^FQ���)񃮪+�}�(~�u)��K\�Z��Qǃg"��y>�(���%~NUR,���1���(!�A1�v���1�d!fi��*԰��w���'bQth`?D�R`������)����J�Is�;x�!��_/�iJ&���cXY�����f�F��      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �             x������ � �            x������ � �         �   x���A�0@���� �NA;5.�Fb¦�14)4)������o�S��sqL�k<G2L����`�:S*S(Q��J�ey@]���+@	��d�O�5��-��)&#%t�北Yg��
n�X���dd}�V��l��c������L�h?�-4���ܐ!~~���            x������ � �            x������ � �            x������ � �         �   x�3��K-�4�4B##c]CC]C###+SK+S=K3cs�?*�2�t��+IL.IM��f��W�Z�Z�gL�>���Ĝ̴L�6b��r��� ����0���S�Wp�(-�[fF��=... ��C	      	      x������ � �      
      x������ � �            x������ � �         �  x�՝�n�F�����ݙ٣�R�:A{ ��J�b5�J
���;k�����V�k�d��ow�;CQyWU�����|1̇�UEU7M�y:k\/]c'�����'�;��������wU`ö1԰�FNF�`BH�����Bzi肼d
�L�)�1�D�L\U/��:���R! 	��CrxH)�!E<$5�~5� !�0� �����c�'��_-n��j�# �#��_/������p��Tj�o��g^տ�d���/��r�� L���|�o�!��`�ɴ��wm��%��/y�eC�@��}]_���3,�'ޣ�.���N
\^��[uDmv�G������n��O��k���v� |����F|[4��ǒZ,�>p=H�-ݧ�& �p�i"d�����m�|a���`~�SV��� �|@}`�[��X9�>\�8��4X��ԕ��x8��� �K˫��Hu�"�2�}�Ŧ�y���;��m4�'�C�B���D�Q��(��(��^/Vk ������|6���q�S��v1�?՗7�������x8�-�w��lgPH�`HIB!�
�b-�bmQ��bX���~m[���h�o���IP�L�@0��d�-L� 0��Z�Z�������_A,�΂-Qi��t�2�D_�/L��0����X�Q��(��(������'��xtΎ�F<��YMGbF�ZgX�����S����Q��"!B1"� BYD(������#z�G���������Do���= z{�P��=":zDt�����#��GDG����-!!j*.3b }J�Ѕ �.(t!D�3��Q�(tAz9��j�Q���$/��UI9(es<���~y�0E{ �3���h����&�,'!��	0s�z���Ѕ �.�(tF:#
]�.�B/G-a�YD��pc-�\�`��	1W4���A��Ѕ �.�(tF:#
��.�B/'�8k�s�G�s��'ZkQ���B@{~����5�ȆR_�u.�h�y&'�<�b�i�L��g@�
]Q�(tF:#
]�^Nr�������9����v��T������冧f��:�4��rA���\��m�nC�<9�1#Gl[��hcO��Ҭ�o�.^��;{O������G�G�۠݊�x�Z^�?W��R�	&�~�P?��%?m&V�o�v���7es�A�~`�m� ��(F{P�v�T�-UL���t���N(X��&�Vp�I�ló.;�m7�ݦj�:?я�G��H.��:Nm���튂-�����C��1��3�w6��#��&|ˎL<��]�����q�7�V�T��3����L+S��:�dO�f�ݷ!C����7������1�#�U*Wm��@��zѾ<;��6ߐq4Z�5n/..���            x������ � �            x������ � �            x������ � �         b   x����� �G6&	A�"������{�gv?�X5��x�@0C;rV=N�=4��+U�9�ޢ�d�����Ib�\��5K>�7^�mC n�ιz�            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �      !   v   x��̻�0E���
X���T8A�)���
`�F78�8��q��1��T�7��&�����>��<�BY�XH�!�wny)QM��	��"$YA�vw�h�V�Ip�}q IkN)}7�)      "      x������ � �      #      x������ � �      $      x������ � �      &      x������ � �      '      x������ � �      (      x������ � �      )      x������ � �      *   �   x�3��K-�4�4B##c]CC]C###+SK+S=K3cs�?*�2�t��+IL.IM��f��W�Z�Z�gL�>���Ĝ̴L�6b��r��� ����0����w�(-�[eF��=... /B�      -      x������ � �      .      x������ � �      /      x������ � �      0      x������ � �      ^   �  x�Ŗ�J�0F��Sd/��v��A\�q�6��)��Ӹh��x�؁�ڐ����$�	U2^��2v����5�>��O#ݿ7����t?��鼳DJ��olg�ݱ�N�R��-[�YY����HU_��@Q<M���x�)H�@P($�C��ٍ��X��#�<�Dr�=�������R�(?!h��fA��F�yͣ�$��O��9r�URL��
���]w7�_V�z5Y�R�<�ɱHJ�.�Z,P($�a=Q�F�7��:�;a�n֝ߕ���ߕX�l�Mza�X��'v�&�Xd�ao��:&�V�&��a��D��D߹L��4�KDF��i�Ұ2��Y&�,հ77�N؜�wgFu����Ҫ�ɟ,6��N�y�BV_o���(��      2      x������ � �      3      x������ � �      4      x������ � �      5      x������ � �      7   A  x����N�0���S�:%i�v�M�4ƴ	��RZ3"���)oO:��\)7�����S��y�ź��$"��i��Rd���*�p�M����P9��B��b�׆���ڰʸ�B�x@C�I���0̃����u�[7xV��w��\[7^"��8v��=;�Ǩ��+`�ؾ��;��p�L���2���^�m<蘀{D���7lGCw&%��켮�v�L%�`�:ĝL��X�<CF�ASFț�}n���P?����R4Z���P�?#���i��6g��v���rX9c�5;f���&c�����B-U�f���Q}Ҟ      8      x������ � �      9      x������ � �      :      x������ � �      ;   d   x�3�����Sp�O�4202�54�54W00�24�20�32�0����!N���.#Nǜ��T���̒"4���d��rs:�')�,+��#B�O~9W� �`%      =   �   x��ͱ�0������-�D�ĕ�����4��3ɿ~�	.a~;^y�[�<6�AfR%D	�0SUN���uY@w�ʄ���6�1�����s��t�*h�֏P��������Ç�1������&�TJ���t�꒨л�R!��Z9s      @   �  x���Yn�(�g��l��&��"z�%�I���.���j����p}�M&G��R�x{����%�R�x�LI��BG@|!]���7ƛ��D)E������Kfǰ�p�x����x�W�t��hD?��cY��t{�D�;�%��/�;$A���!�R�f���囲W N�\^�m�Ӎ�v<EG6��>������'\���~�#��??�I�\<� /�R- 7��Lj�H�ɖo�C�9'��Ǹ�	x�IsS͡xz΋����,hѰ��P�恤�͎o�e��aZ��#��\�qD�FW��J��@�6c̱��k�R-u�D�"��tPU�b��Sg������ZD:X=XC�kd�`�`������Ճ53��o$��,춏`r��&��6��*7bv��Go0���7�Vqa�O��%̟"����7��f��ζ�H�n	#��8�\F�Tq����P��P��X��P��T��P��\�ٖ0�����@䚘�c�H�����ᚙ�F8kf����X33���Ě��F8kf��H���n�#�f�d�[dx�%p�d��
p��{ p�%�D����޶0�$�؜&��4����7�=g��}�$Qĵ1�E�K\YE{[Mw^!�;u�.���������=�4��h��'1�����vE3�@
M�,��">y���;�^=y�(�?����I��ƥ'�,7�'�� p�p�1cRj1�i�w���4N�q}C)l��{lL��|��5�i#)}O�t�HJ�HJ;eClۗ�����������������������������������i0��ip��t@��)=�tRt��nfo[t��;��iPN�[=�n����Sz�VO�[=�� �VO��)}�pR���,������zJ��)=p��������zJĭ���zJ�:}���I��I��I��I��I��I��I��I��I��I��I��I!KJXk�R"H)ss��(pi�`*�ڏ�b���'�GѲ��}��xz����P��U�X��U���k�\>�H�6*$�M)2pv�#P
8=��8[9#���?�W�� ��$ilD����5�'m�� m��*N~���N���YC�Aʔ��	Tqr�����/�3�      A      x������ � �      B      x������ � �      C      x������ � �      E   �   x�ŐM
�@�יS��3i:sOЍmǽ"��w*��ݸ��{�����O���(ޱɅ�W5�-X�E�Z��T'��	��u19'��ء�8ڠI`<�+mX��࿈J�4�*�GD����c)�;_s��O趲���?��n�!�Зn�      F      x������ � �      G      x������ � �      H      x������ � �      J      x������ � �      K      x������ � �      L      x������ � �      M      x������ � �      O      x������ � �      P      x������ � �      Q      x������ � �      R      x������ � �      T   �   x���Kn� �}�\ 4/�t�dS�T�&U]KQo_�nB�!�@�`������bFtyw���d*���E�2z�4`]����& q���!�eN>$
F��u�P˱H=C^��eY?>�#	w6�/��0G؃�!�9�p�����^#0���ᄾ�sP�GN1ɝ�Rh,�)�AC�#�G6�+/ǿf���F��.(n�J�MvHC�P1��9�jiG����׭<i�R�}2SJ�)���ُ���f�      U      x������ � �      V      x������ � �      W      x������ � �      X   q   x�mͻ�0�����R`aEaꈄBti�;ʃ�ݳ���B��ě��Dq��)��Ư����,��Dw���V3R7'�q�gzXA���m��B��kC����]޿灙�\�AF      Z      x������ � �     