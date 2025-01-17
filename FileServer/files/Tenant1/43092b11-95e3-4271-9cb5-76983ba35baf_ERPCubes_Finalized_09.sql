PGDMP                      {            ERPCubes-Finalized    16.0    16.0 �   ,           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            -           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            .           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            /           1262    20343    ERPCubes-Finalized    DATABASE     �   CREATE DATABASE "ERPCubes-Finalized" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
 $   DROP DATABASE "ERPCubes-Finalized";
                postgres    false            �           1255    20344    calculateleadevent(integer)    FUNCTION     f	  CREATE FUNCTION public.calculateleadevent(tenantid_value integer) RETURNS TABLE("Leadowner" text, "Lead" bigint, "Note" bigint, "Call" bigint, "Email" bigint, "Task" bigint, "Meeting" bigint)
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
 A   DROP FUNCTION public.calculateleadevent(tenantid_value integer);
       public          postgres    false            �           1255    20345 (   calculateleadeventcountsbyowner(integer)    FUNCTION     �	  CREATE FUNCTION public.calculateleadeventcountsbyowner(tenantid_value integer) RETURNS TABLE(leadownerid text, leadidcount bigint, noteidcount bigint, callidcount bigint, emailidcount bigint, taskidcount bigint, meetingidcount bigint)
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
       public          postgres    false            �           1255    20346 )   calculateleadeventcountsbyowner2(integer)    FUNCTION     t	  CREATE FUNCTION public.calculateleadeventcountsbyowner2(tenantid_value integer) RETURNS TABLE("Leadowner" text, "Lead" bigint, "Note" bigint, "Call" bigint, "Email" bigint, "Task" bigint, "Meeting" bigint)
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
       public          postgres    false            �           1255    20347    get_all_crmleads() 	   PROCEDURE     g   CREATE PROCEDURE public.get_all_crmleads()
    LANGUAGE sql
    AS $$
    SELECT * FROM "CrmLead";
$$;
 *   DROP PROCEDURE public.get_all_crmleads();
       public          postgres    false            �           1255    20348    get_crmleads(integer)    FUNCTION     �  CREATE FUNCTION public.get_crmleads(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    20349    get_lead_status_counts()    FUNCTION     x  CREATE FUNCTION public.get_lead_status_counts() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    20350    get_lead_status_counts22()    FUNCTION     z  CREATE FUNCTION public.get_lead_status_counts22() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    20351    get_lead_status_counts23()    FUNCTION       CREATE FUNCTION public.get_lead_status_counts23() RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, count integer)
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
       public          postgres    false            �           1255    20352 !   get_lead_status_counts23(integer)    FUNCTION     �  CREATE FUNCTION public.get_lead_status_counts23(p_tenantid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, count integer)
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
       public          postgres    false            �           1255    20353    get_leadreport(integer)    FUNCTION     �  CREATE FUNCTION public.get_leadreport(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    20354    getleaddata(integer)    FUNCTION       CREATE FUNCTION public.getleaddata(p_tenantid integer) RETURNS TABLE("LeadOwner" text, "StatusTitle" text, "StatusId" integer, "ProductName" text, "ProductId" integer, "Count" integer)
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
       public          postgres    false            �           1255    20355    getleadstatuscounts()    FUNCTION     X  CREATE FUNCTION public.getleadstatuscounts() RETURNS TABLE(leadowner text, statustitle text, statusid integer, productname text, productid integer, count integer)
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
       public          postgres    false            �           1255    20356    leadstatusfn(integer)    FUNCTION       CREATE FUNCTION public.leadstatusfn(p_tenantid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, "Count" integer)
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
       public          postgres    false            �           1255    20357 *   leadstatusfn(integer, date, date, integer)    FUNCTION     �  CREATE FUNCTION public.leadstatusfn(p_tenantid integer, p_startdate date, p_enddate date, p_productid integer) RETURNS TABLE("LeadOwnerId" text, "Status" text, "SId" integer, "ProdName" text, "ProdId" integer, "Count" integer)
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
       public          postgres    false            �           1255    20358    process_lead_counts(integer)    FUNCTION     �	  CREATE FUNCTION public.process_lead_counts(p_tenantid integer) RETURNS TABLE(leadownerid text, leadid integer, noteidcount integer, callidcount integer, emailidcount integer, taskidcount integer, meetingidcount integer)
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
       public          postgres    false            �            1259    20359    AppMenus    TABLE     v  CREATE TABLE public."AppMenus" (
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
       public         heap    postgres    false            �            1259    20366    AppMenus_MenuId_seq    SEQUENCE     �   CREATE SEQUENCE public."AppMenus_MenuId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."AppMenus_MenuId_seq";
       public          postgres    false    231            0           0    0    AppMenus_MenuId_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."AppMenus_MenuId_seq" OWNED BY public."AppMenus"."MenuId";
          public          postgres    false    232            �           1259    22350    CrmAdAccount    TABLE     �  CREATE TABLE public."CrmAdAccount" (
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
       public            postgres    false            �           1259    22349    CrmAdAccount_AccountId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmAdAccount_AccountId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmAdAccount_AccountId_seq";
       public          postgres    false    397            1           0    0    CrmAdAccount_AccountId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmAdAccount_AccountId_seq" OWNED BY public."CrmAdAccount"."AccountId";
          public          postgres    false    396            �           1259    22359    CrmAdAccount1    TABLE       CREATE TABLE public."CrmAdAccount1" (
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
       public         heap    postgres    false    396    397            �           1259    22370    CrmAdAccount100    TABLE       CREATE TABLE public."CrmAdAccount100" (
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
       public         heap    postgres    false    396    397            �           1259    22381    CrmAdAccount2    TABLE       CREATE TABLE public."CrmAdAccount2" (
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
       public         heap    postgres    false    396    397            �           1259    22392    CrmAdAccount3    TABLE       CREATE TABLE public."CrmAdAccount3" (
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
       public         heap    postgres    false    396    397            �            1259    20367    CrmCalendarEventsType    TABLE     �   CREATE TABLE public."CrmCalendarEventsType" (
    "TypeId" integer NOT NULL,
    "TypeTitle" text,
    "IsDeleted" integer DEFAULT 0
);
 +   DROP TABLE public."CrmCalendarEventsType";
       public         heap    postgres    false            �            1259    20373     CrmCalendarEventsType_TypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCalendarEventsType_TypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."CrmCalendarEventsType_TypeId_seq";
       public          postgres    false    233            2           0    0     CrmCalendarEventsType_TypeId_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."CrmCalendarEventsType_TypeId_seq" OWNED BY public."CrmCalendarEventsType"."TypeId";
          public          postgres    false    234            �            1259    20374    CrmCalenderEvents    TABLE     �  CREATE TABLE public."CrmCalenderEvents" (
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
    "IsCompany" integer NOT NULL,
    "IsLead" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "IsOpportunity" integer
)
PARTITION BY RANGE ("TenantId");
 '   DROP TABLE public."CrmCalenderEvents";
       public            postgres    false            �            1259    20379    CrmCalenderEvents_EventId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCalenderEvents_EventId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CrmCalenderEvents_EventId_seq";
       public          postgres    false    235            3           0    0    CrmCalenderEvents_EventId_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."CrmCalenderEvents_EventId_seq" OWNED BY public."CrmCalenderEvents"."EventId";
          public          postgres    false    236            �            1259    20380    CrmCalenderEventsTenant1    TABLE       CREATE TABLE public."CrmCalenderEventsTenant1" (
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
    "IsCompany" integer NOT NULL,
    "IsLead" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "IsOpportunity" integer
);
 .   DROP TABLE public."CrmCalenderEventsTenant1";
       public         heap    postgres    false    236    235            �            1259    20388    CrmCalenderEventsTenant100    TABLE       CREATE TABLE public."CrmCalenderEventsTenant100" (
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
    "IsCompany" integer NOT NULL,
    "IsLead" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "IsOpportunity" integer
);
 0   DROP TABLE public."CrmCalenderEventsTenant100";
       public         heap    postgres    false    236    235            �            1259    20396    CrmCalenderEventsTenant2    TABLE       CREATE TABLE public."CrmCalenderEventsTenant2" (
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
    "IsCompany" integer NOT NULL,
    "IsLead" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "IsOpportunity" integer
);
 .   DROP TABLE public."CrmCalenderEventsTenant2";
       public         heap    postgres    false    236    235            �            1259    20404    CrmCalenderEventsTenant3    TABLE       CREATE TABLE public."CrmCalenderEventsTenant3" (
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
    "IsCompany" integer NOT NULL,
    "IsLead" integer NOT NULL,
    "AllDay" boolean NOT NULL,
    "IsOpportunity" integer
);
 .   DROP TABLE public."CrmCalenderEventsTenant3";
       public         heap    postgres    false    236    235            �            1259    20412    CrmCall    TABLE     ;  CREATE TABLE public."CrmCall" (
    "CallId" integer NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmCall";
       public            postgres    false            �            1259    20417    CrmCall_CallId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCall_CallId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmCall_CallId_seq";
       public          postgres    false    241            4           0    0    CrmCall_CallId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmCall_CallId_seq" OWNED BY public."CrmCall"."CallId";
          public          postgres    false    242            �            1259    20418    CrmCall1    TABLE     U  CREATE TABLE public."CrmCall1" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
    DROP TABLE public."CrmCall1";
       public         heap    postgres    false    242    241            �            1259    20426 
   CrmCall100    TABLE     W  CREATE TABLE public."CrmCall100" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
     DROP TABLE public."CrmCall100";
       public         heap    postgres    false    242    241            �            1259    20434    CrmCall2    TABLE     U  CREATE TABLE public."CrmCall2" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
    DROP TABLE public."CrmCall2";
       public         heap    postgres    false    242    241            �            1259    20442    CrmCall3    TABLE     U  CREATE TABLE public."CrmCall3" (
    "CallId" integer DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Response" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" text,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
    DROP TABLE public."CrmCall3";
       public         heap    postgres    false    242    241            �            1259    20450 
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
       public            postgres    false            �            1259    20455    CrmCompanyActivityLog    TABLE     1  CREATE TABLE public."CrmCompanyActivityLog" (
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
       public            postgres    false            �            1259    20460 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq";
       public          postgres    false    248            5           0    0 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."CrmCompanyActivityLog_ActivityId_seq" OWNED BY public."CrmCompanyActivityLog"."ActivityId";
          public          postgres    false    249            �            1259    20461    CrmCompanyActivityLogTenant1    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant1" (
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
       public         heap    postgres    false    249    248            �            1259    20469    CrmCompanyActivityLogTenant100    TABLE     e  CREATE TABLE public."CrmCompanyActivityLogTenant100" (
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
       public         heap    postgres    false    249    248            �            1259    20477    CrmCompanyActivityLogTenant2    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant2" (
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
       public         heap    postgres    false    249    248            �            1259    20485    CrmCompanyActivityLogTenant3    TABLE     c  CREATE TABLE public."CrmCompanyActivityLogTenant3" (
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
       public         heap    postgres    false    249    248            �            1259    20493    CrmCompanyMember    TABLE     �  CREATE TABLE public."CrmCompanyMember" (
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
       public            postgres    false            �            1259    20498    CrmCompanyMember_MemberId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompanyMember_MemberId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CrmCompanyMember_MemberId_seq";
       public          postgres    false    254            6           0    0    CrmCompanyMember_MemberId_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."CrmCompanyMember_MemberId_seq" OWNED BY public."CrmCompanyMember"."MemberId";
          public          postgres    false    255                        1259    20499    CrmCompanyMemberTenant1    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant1" (
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
       public         heap    postgres    false    255    254                       1259    20507    CrmCompanyMemberTenant100    TABLE       CREATE TABLE public."CrmCompanyMemberTenant100" (
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
       public         heap    postgres    false    255    254                       1259    20515    CrmCompanyMemberTenant2    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant2" (
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
       public         heap    postgres    false    255    254                       1259    20523    CrmCompanyMemberTenant3    TABLE     	  CREATE TABLE public."CrmCompanyMemberTenant3" (
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
       public         heap    postgres    false    255    254                       1259    20531    CrmCompany_CompanyId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCompany_CompanyId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmCompany_CompanyId_seq";
       public          postgres    false    247            7           0    0    CrmCompany_CompanyId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmCompany_CompanyId_seq" OWNED BY public."CrmCompany"."CompanyId";
          public          postgres    false    260                       1259    20532    CrmCompanyTenant1    TABLE     �  CREATE TABLE public."CrmCompanyTenant1" (
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
       public         heap    postgres    false    260    247                       1259    20540    CrmCompanyTenant100    TABLE     �  CREATE TABLE public."CrmCompanyTenant100" (
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
       public         heap    postgres    false    260    247                       1259    20548    CrmCompanyTenant2    TABLE     �  CREATE TABLE public."CrmCompanyTenant2" (
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
       public         heap    postgres    false    260    247                       1259    20556    CrmCompanyTenant3    TABLE     �  CREATE TABLE public."CrmCompanyTenant3" (
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
       public         heap    postgres    false    260    247            	           1259    20564    CrmCustomLists    TABLE     �  CREATE TABLE public."CrmCustomLists" (
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
       public            postgres    false            
           1259    20570    CrmCustomLists_ListId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmCustomLists_ListId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."CrmCustomLists_ListId_seq";
       public          postgres    false    265            8           0    0    CrmCustomLists_ListId_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CrmCustomLists_ListId_seq" OWNED BY public."CrmCustomLists"."ListId";
          public          postgres    false    266                       1259    20571    CrmCustomListsTenant1    TABLE     
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
       public         heap    postgres    false    266    265                       1259    20580    CrmCustomListsTenant100    TABLE       CREATE TABLE public."CrmCustomListsTenant100" (
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
       public         heap    postgres    false    266    265                       1259    20589    CrmCustomListsTenant2    TABLE     
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
       public         heap    postgres    false    266    265                       1259    20598    CrmCustomListsTenant3    TABLE     
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
       public         heap    postgres    false    266    265                       1259    20607    CrmEmail    TABLE     B  CREATE TABLE public."CrmEmail" (
    "EmailId" integer NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "IsOpportunity" integer
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmEmail";
       public            postgres    false                       1259    20612    CrmEmail_EmailId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmEmail_EmailId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."CrmEmail_EmailId_seq";
       public          postgres    false    271            9           0    0    CrmEmail_EmailId_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CrmEmail_EmailId_seq" OWNED BY public."CrmEmail"."EmailId";
          public          postgres    false    272                       1259    20613 	   CrmEmail1    TABLE     ^  CREATE TABLE public."CrmEmail1" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "IsOpportunity" integer
);
    DROP TABLE public."CrmEmail1";
       public         heap    postgres    false    272    271                       1259    20621    CrmEmail100    TABLE     `  CREATE TABLE public."CrmEmail100" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "IsOpportunity" integer
);
 !   DROP TABLE public."CrmEmail100";
       public         heap    postgres    false    272    271                       1259    20629 	   CrmEmail2    TABLE     ^  CREATE TABLE public."CrmEmail2" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "IsOpportunity" integer
);
    DROP TABLE public."CrmEmail2";
       public         heap    postgres    false    272    271                       1259    20637 	   CrmEmail3    TABLE     ^  CREATE TABLE public."CrmEmail3" (
    "EmailId" integer DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Description" text,
    "Reply" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "SendDate" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" text,
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsSuccessful" integer,
    "CreatedBy" text,
    "IsOpportunity" integer
);
    DROP TABLE public."CrmEmail3";
       public         heap    postgres    false    272    271                       1259    20645    CrmIndustry    TABLE     �  CREATE TABLE public."CrmIndustry" (
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
       public            postgres    false                       1259    20650    CrmIndustry_IndustryId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmIndustry_IndustryId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmIndustry_IndustryId_seq";
       public          postgres    false    277            :           0    0    CrmIndustry_IndustryId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmIndustry_IndustryId_seq" OWNED BY public."CrmIndustry"."IndustryId";
          public          postgres    false    278                       1259    20651    CrmIndustryTenant1    TABLE     �  CREATE TABLE public."CrmIndustryTenant1" (
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
       public         heap    postgres    false    278    277                       1259    20659    CrmIndustryTenant100    TABLE     �  CREATE TABLE public."CrmIndustryTenant100" (
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
       public         heap    postgres    false    278    277                       1259    20667    CrmIndustryTenant2    TABLE     �  CREATE TABLE public."CrmIndustryTenant2" (
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
       public         heap    postgres    false    278    277                       1259    20675    CrmIndustryTenant3    TABLE     �  CREATE TABLE public."CrmIndustryTenant3" (
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
       public         heap    postgres    false    278    277                       1259    20683    CrmLead    TABLE       CREATE TABLE public."CrmLead" (
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
    "ProductId" integer
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmLead";
       public            postgres    false                       1259    20688    CrmLeadActivityLog    TABLE     +  CREATE TABLE public."CrmLeadActivityLog" (
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
       public            postgres    false                       1259    20693 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmLeadActivityLog_ActivityId_seq";
       public          postgres    false    284            ;           0    0 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmLeadActivityLog_ActivityId_seq" OWNED BY public."CrmLeadActivityLog"."ActivityId";
          public          postgres    false    285                       1259    20694    CrmLeadActivityLogTenant1    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant1" (
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
       public         heap    postgres    false    285    284                       1259    20702    CrmLeadActivityLogTenant100    TABLE     \  CREATE TABLE public."CrmLeadActivityLogTenant100" (
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
       public         heap    postgres    false    285    284                        1259    20710    CrmLeadActivityLogTenant2    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant2" (
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
       public         heap    postgres    false    285    284            !           1259    20718    CrmLeadActivityLogTenant3    TABLE     Z  CREATE TABLE public."CrmLeadActivityLogTenant3" (
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
       public         heap    postgres    false    285    284            "           1259    20726    CrmLeadSource    TABLE     �  CREATE TABLE public."CrmLeadSource" (
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
       public            postgres    false            #           1259    20731    CrmLeadSource_SourceId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadSource_SourceId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmLeadSource_SourceId_seq";
       public          postgres    false    290            <           0    0    CrmLeadSource_SourceId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmLeadSource_SourceId_seq" OWNED BY public."CrmLeadSource"."SourceId";
          public          postgres    false    291            $           1259    20732    CrmLeadSourceTenant1    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant1" (
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
       public         heap    postgres    false    291    290            %           1259    20740    CrmLeadSourceTenant100    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant100" (
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
       public         heap    postgres    false    291    290            &           1259    20748    CrmLeadSourceTenant2    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant2" (
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
       public         heap    postgres    false    291    290            '           1259    20756    CrmLeadSourceTenant3    TABLE     �  CREATE TABLE public."CrmLeadSourceTenant3" (
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
       public         heap    postgres    false    291    290            (           1259    20764    CrmLeadStatus    TABLE     �  CREATE TABLE public."CrmLeadStatus" (
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
       public            postgres    false            )           1259    20769    CrmLeadStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLeadStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmLeadStatus_StatusId_seq";
       public          postgres    false    296            =           0    0    CrmLeadStatus_StatusId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmLeadStatus_StatusId_seq" OWNED BY public."CrmLeadStatus"."StatusId";
          public          postgres    false    297            *           1259    20770    CrmLeadStatusTenant1    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant1" (
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
       public         heap    postgres    false    297    296            +           1259    20778    CrmLeadStatusTenant100    TABLE     '  CREATE TABLE public."CrmLeadStatusTenant100" (
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
       public         heap    postgres    false    297    296            ,           1259    20786    CrmLeadStatusTenant2    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant2" (
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
       public         heap    postgres    false    297    296            -           1259    20794    CrmLeadStatusTenant3    TABLE     %  CREATE TABLE public."CrmLeadStatusTenant3" (
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
       public         heap    postgres    false    297    296            .           1259    20802    CrmLead_LeadId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmLead_LeadId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmLead_LeadId_seq";
       public          postgres    false    283            >           0    0    CrmLead_LeadId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmLead_LeadId_seq" OWNED BY public."CrmLead"."LeadId";
          public          postgres    false    302            /           1259    20803    CrmLeadTenant1    TABLE     7  CREATE TABLE public."CrmLeadTenant1" (
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
    "ProductId" integer
);
 $   DROP TABLE public."CrmLeadTenant1";
       public         heap    postgres    false    302    283            0           1259    20811    CrmLeadTenant100    TABLE     9  CREATE TABLE public."CrmLeadTenant100" (
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
    "ProductId" integer
);
 &   DROP TABLE public."CrmLeadTenant100";
       public         heap    postgres    false    302    283            1           1259    20819    CrmLeadTenant2    TABLE     7  CREATE TABLE public."CrmLeadTenant2" (
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
    "ProductId" integer
);
 $   DROP TABLE public."CrmLeadTenant2";
       public         heap    postgres    false    302    283            2           1259    20827    CrmLeadTenant3    TABLE     7  CREATE TABLE public."CrmLeadTenant3" (
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
    "ProductId" integer
);
 $   DROP TABLE public."CrmLeadTenant3";
       public         heap    postgres    false    302    283            3           1259    20835 
   CrmMeeting    TABLE     a  CREATE TABLE public."CrmMeeting" (
    "MeetingId" integer NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmMeeting";
       public            postgres    false            4           1259    20840    CrmMeeting_MeetingId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmMeeting_MeetingId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmMeeting_MeetingId_seq";
       public          postgres    false    307            ?           0    0    CrmMeeting_MeetingId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmMeeting_MeetingId_seq" OWNED BY public."CrmMeeting"."MeetingId";
          public          postgres    false    308            5           1259    20841    CrmMeeting1    TABLE     �  CREATE TABLE public."CrmMeeting1" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
 !   DROP TABLE public."CrmMeeting1";
       public         heap    postgres    false    308    307            6           1259    20849    CrmMeeting100    TABLE     �  CREATE TABLE public."CrmMeeting100" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
 #   DROP TABLE public."CrmMeeting100";
       public         heap    postgres    false    308    307            7           1259    20857    CrmMeeting2    TABLE     �  CREATE TABLE public."CrmMeeting2" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
 !   DROP TABLE public."CrmMeeting2";
       public         heap    postgres    false    308    307            8           1259    20865    CrmMeeting3    TABLE     �  CREATE TABLE public."CrmMeeting3" (
    "MeetingId" integer DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass) NOT NULL,
    "Subject" text,
    "Note" text,
    "Id" integer,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450),
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "IsOpportunity" integer
);
 !   DROP TABLE public."CrmMeeting3";
       public         heap    postgres    false    308    307            9           1259    20873    CrmNote    TABLE     ,  CREATE TABLE public."CrmNote" (
    "NoteId" integer NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "IsOpportunity" integer
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmNote";
       public            postgres    false            :           1259    20878    CrmNoteTags    TABLE     �  CREATE TABLE public."CrmNoteTags" (
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
       public            postgres    false            ;           1259    20883    CrmNoteTags_NoteTagsId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNoteTags_NoteTagsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmNoteTags_NoteTagsId_seq";
       public          postgres    false    314            @           0    0    CrmNoteTags_NoteTagsId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmNoteTags_NoteTagsId_seq" OWNED BY public."CrmNoteTags"."NoteTagsId";
          public          postgres    false    315            <           1259    20884    CrmNoteTagsTenant1    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant1" (
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
       public         heap    postgres    false    315    314            =           1259    20892    CrmNoteTagsTenant100    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant100" (
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
       public         heap    postgres    false    315    314            >           1259    20900    CrmNoteTagsTenant2    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant2" (
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
       public         heap    postgres    false    315    314            ?           1259    20908    CrmNoteTagsTenant3    TABLE     �  CREATE TABLE public."CrmNoteTagsTenant3" (
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
       public         heap    postgres    false    315    314            @           1259    20916    CrmNoteTasks    TABLE     �  CREATE TABLE public."CrmNoteTasks" (
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
       public            postgres    false            A           1259    20921    CrmNoteTasks_NoteTaskId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNoteTasks_NoteTaskId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."CrmNoteTasks_NoteTaskId_seq";
       public          postgres    false    320            A           0    0    CrmNoteTasks_NoteTaskId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CrmNoteTasks_NoteTaskId_seq" OWNED BY public."CrmNoteTasks"."NoteTaskId";
          public          postgres    false    321            B           1259    20922    CrmNoteTasksTenant1    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant1" (
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
       public         heap    postgres    false    321    320            C           1259    20930    CrmNoteTasksTenant100    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant100" (
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
       public         heap    postgres    false    321    320            D           1259    20938    CrmNoteTasksTenant2    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant2" (
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
       public         heap    postgres    false    321    320            E           1259    20946    CrmNoteTasksTenant3    TABLE     �  CREATE TABLE public."CrmNoteTasksTenant3" (
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
       public         heap    postgres    false    321    320            F           1259    20954    CrmNote_NoteId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmNote_NoteId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmNote_NoteId_seq";
       public          postgres    false    313            B           0    0    CrmNote_NoteId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmNote_NoteId_seq" OWNED BY public."CrmNote"."NoteId";
          public          postgres    false    326            G           1259    20955    CrmNoteTenant1    TABLE     L  CREATE TABLE public."CrmNoteTenant1" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "IsOpportunity" integer
);
 $   DROP TABLE public."CrmNoteTenant1";
       public         heap    postgres    false    326    313            H           1259    20963    CrmNoteTenant100    TABLE     N  CREATE TABLE public."CrmNoteTenant100" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "IsOpportunity" integer
);
 &   DROP TABLE public."CrmNoteTenant100";
       public         heap    postgres    false    326    313            I           1259    20971    CrmNoteTenant2    TABLE     L  CREATE TABLE public."CrmNoteTenant2" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "IsOpportunity" integer
);
 $   DROP TABLE public."CrmNoteTenant2";
       public         heap    postgres    false    326    313            J           1259    20979    CrmNoteTenant3    TABLE     L  CREATE TABLE public."CrmNoteTenant3" (
    "NoteId" integer DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass) NOT NULL,
    "Content" text NOT NULL,
    "Id" integer NOT NULL,
    "IsCompany" integer,
    "IsLead" integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "NoteTitle" text,
    "IsOpportunity" integer
);
 $   DROP TABLE public."CrmNoteTenant3";
       public         heap    postgres    false    326    313            �           1259    22254    CrmOpportunity    TABLE     .  CREATE TABLE public."CrmOpportunity" (
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
       public            postgres    false            �           1259    22253     CrmOpportunity_OpportunityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmOpportunity_OpportunityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."CrmOpportunity_OpportunityId_seq";
       public          postgres    false    387            C           0    0     CrmOpportunity_OpportunityId_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public."CrmOpportunity_OpportunityId_seq" OWNED BY public."CrmOpportunity"."OpportunityId";
          public          postgres    false    386            �           1259    22262    CrmOpportunity1    TABLE     V  CREATE TABLE public."CrmOpportunity1" (
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
       public         heap    postgres    false    386    387            �           1259    22292    CrmOpportunity100    TABLE     X  CREATE TABLE public."CrmOpportunity100" (
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
       public         heap    postgres    false    386    387            �           1259    22272    CrmOpportunity2    TABLE     V  CREATE TABLE public."CrmOpportunity2" (
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
       public         heap    postgres    false    386    387            �           1259    22282    CrmOpportunity3    TABLE     V  CREATE TABLE public."CrmOpportunity3" (
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
       public         heap    postgres    false    386    387            �           1259    22331    CrmOpportunitySource    TABLE     �  CREATE TABLE public."CrmOpportunitySource" (
    "SourceId" integer NOT NULL,
    "SourceTitle" text NOT NULL,
    "CreatedBy" character varying(450),
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 *   DROP TABLE public."CrmOpportunitySource";
       public         heap    postgres    false            �           1259    22330 !   CrmOpportunitySource_SourceId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmOpportunitySource_SourceId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmOpportunitySource_SourceId_seq";
       public          postgres    false    395            D           0    0 !   CrmOpportunitySource_SourceId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmOpportunitySource_SourceId_seq" OWNED BY public."CrmOpportunitySource"."SourceId";
          public          postgres    false    394            �           1259    22308    CrmOpportunityStatus    TABLE     �  CREATE TABLE public."CrmOpportunityStatus" (
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
       public         heap    postgres    false            �           1259    22307 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmOpportunityStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmOpportunityStatus_StatusId_seq";
       public          postgres    false    393            E           0    0 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmOpportunityStatus_StatusId_seq" OWNED BY public."CrmOpportunityStatus"."StatusId";
          public          postgres    false    392            K           1259    20987 
   CrmProduct    TABLE     �  CREATE TABLE public."CrmProduct" (
    "ProductId" integer NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
)
PARTITION BY RANGE ("TenantId");
     DROP TABLE public."CrmProduct";
       public            postgres    false            L           1259    20992    CrmProduct_ProductId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmProduct_ProductId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmProduct_ProductId_seq";
       public          postgres    false    331            F           0    0    CrmProduct_ProductId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmProduct_ProductId_seq" OWNED BY public."CrmProduct"."ProductId";
          public          postgres    false    332            M           1259    20993    CrmProductTenant1    TABLE       CREATE TABLE public."CrmProductTenant1" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmProductTenant1";
       public         heap    postgres    false    332    331            N           1259    21001    CrmProductTenant100    TABLE       CREATE TABLE public."CrmProductTenant100" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 )   DROP TABLE public."CrmProductTenant100";
       public         heap    postgres    false    332    331            O           1259    21009    CrmProductTenant2    TABLE       CREATE TABLE public."CrmProductTenant2" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmProductTenant2";
       public         heap    postgres    false    332    331            P           1259    21017    CrmProductTenant3    TABLE       CREATE TABLE public."CrmProductTenant3" (
    "ProductId" integer DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass) NOT NULL,
    "ProductName" character varying(255),
    "Description" text,
    "Price" numeric(10,2),
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL
);
 '   DROP TABLE public."CrmProductTenant3";
       public         heap    postgres    false    332    331            Q           1259    21025 
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
       public            postgres    false            R           1259    21030    CrmTagUsed_TagUsedId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTagUsed_TagUsedId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."CrmTagUsed_TagUsedId_seq";
       public          postgres    false    337            G           0    0    CrmTagUsed_TagUsedId_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."CrmTagUsed_TagUsedId_seq" OWNED BY public."CrmTagUsed"."TagUsedId";
          public          postgres    false    338            S           1259    21031    CrmTagUsedTenant1    TABLE     &  CREATE TABLE public."CrmTagUsedTenant1" (
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
       public         heap    postgres    false    338    337            T           1259    21039    CrmTagUsedTenant100    TABLE     (  CREATE TABLE public."CrmTagUsedTenant100" (
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
       public         heap    postgres    false    338    337            U           1259    21047    CrmTagUsedTenant2    TABLE     &  CREATE TABLE public."CrmTagUsedTenant2" (
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
       public         heap    postgres    false    338    337            V           1259    21055    CrmTagUsedTenant3    TABLE     &  CREATE TABLE public."CrmTagUsedTenant3" (
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
       public         heap    postgres    false    338    337            W           1259    21063    CrmTags    TABLE     �  CREATE TABLE public."CrmTags" (
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
       public            postgres    false            X           1259    21068    CrmTags_TagId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTags_TagId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."CrmTags_TagId_seq";
       public          postgres    false    343            H           0    0    CrmTags_TagId_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."CrmTags_TagId_seq" OWNED BY public."CrmTags"."TagId";
          public          postgres    false    344            Y           1259    21069    CrmTagsTenant1    TABLE     �  CREATE TABLE public."CrmTagsTenant1" (
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
       public         heap    postgres    false    344    343            Z           1259    21077    CrmTagsTenant100    TABLE     �  CREATE TABLE public."CrmTagsTenant100" (
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
       public         heap    postgres    false    344    343            [           1259    21085    CrmTagsTenant2    TABLE     �  CREATE TABLE public."CrmTagsTenant2" (
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
       public         heap    postgres    false    344    343            \           1259    21093    CrmTagsTenant3    TABLE     �  CREATE TABLE public."CrmTagsTenant3" (
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
       public         heap    postgres    false    344    343            ]           1259    21101    CrmTask    TABLE     4  CREATE TABLE public."CrmTask" (
    "TaskId" integer NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "IsCompany" integer DEFAULT '-1'::integer,
    "IsLead" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "IsOpportunity" integer
)
PARTITION BY RANGE ("TenantId");
    DROP TABLE public."CrmTask";
       public            postgres    false            ^           1259    21110    CrmTaskPriority    TABLE     �  CREATE TABLE public."CrmTaskPriority" (
    "PriorityId" integer NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "PriorityTitle" text NOT NULL
);
 %   DROP TABLE public."CrmTaskPriority";
       public         heap    postgres    false            _           1259    21117    CrmTaskPriority_PriorityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskPriority_PriorityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."CrmTaskPriority_PriorityId_seq";
       public          postgres    false    350            I           0    0    CrmTaskPriority_PriorityId_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."CrmTaskPriority_PriorityId_seq" OWNED BY public."CrmTaskPriority"."PriorityId";
          public          postgres    false    351            `           1259    21118    CrmTaskStatus    TABLE     q  CREATE TABLE public."CrmTaskStatus" (
    "StatusId" integer NOT NULL,
    "StatusTitle" text,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL
);
 #   DROP TABLE public."CrmTaskStatus";
       public         heap    postgres    false            a           1259    21125    CrmTaskStatus_StatusId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskStatus_StatusId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmTaskStatus_StatusId_seq";
       public          postgres    false    352            J           0    0    CrmTaskStatus_StatusId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmTaskStatus_StatusId_seq" OWNED BY public."CrmTaskStatus"."StatusId";
          public          postgres    false    353            b           1259    21126    CrmTaskTags    TABLE     �  CREATE TABLE public."CrmTaskTags" (
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
       public            postgres    false            c           1259    21131    CrmTaskTags_TaskTagsId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTaskTags_TaskTagsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CrmTaskTags_TaskTagsId_seq";
       public          postgres    false    354            K           0    0    CrmTaskTags_TaskTagsId_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."CrmTaskTags_TaskTagsId_seq" OWNED BY public."CrmTaskTags"."TaskTagsId";
          public          postgres    false    355            d           1259    21132    CrmTaskTagsTenant1    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant1" (
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
       public         heap    postgres    false    355    354            e           1259    21140    CrmTaskTagsTenant100    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant100" (
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
       public         heap    postgres    false    355    354            f           1259    21148    CrmTaskTagsTenant2    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant2" (
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
       public         heap    postgres    false    355    354            g           1259    21156    CrmTaskTagsTenant3    TABLE     �  CREATE TABLE public."CrmTaskTagsTenant3" (
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
       public         heap    postgres    false    355    354            h           1259    21164    CrmTask_TaskId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTask_TaskId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmTask_TaskId_seq";
       public          postgres    false    349            L           0    0    CrmTask_TaskId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmTask_TaskId_seq" OWNED BY public."CrmTask"."TaskId";
          public          postgres    false    360            i           1259    21165    CrmTaskTenant1    TABLE     T  CREATE TABLE public."CrmTaskTenant1" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "IsCompany" integer DEFAULT '-1'::integer,
    "IsLead" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "IsOpportunity" integer
);
 $   DROP TABLE public."CrmTaskTenant1";
       public         heap    postgres    false    360    349            j           1259    21177    CrmTaskTenant100    TABLE     V  CREATE TABLE public."CrmTaskTenant100" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "IsCompany" integer DEFAULT '-1'::integer,
    "IsLead" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "IsOpportunity" integer
);
 &   DROP TABLE public."CrmTaskTenant100";
       public         heap    postgres    false    360    349            k           1259    21189    CrmTaskTenant2    TABLE     T  CREATE TABLE public."CrmTaskTenant2" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "IsCompany" integer DEFAULT '-1'::integer,
    "IsLead" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "IsOpportunity" integer
);
 $   DROP TABLE public."CrmTaskTenant2";
       public         heap    postgres    false    360    349            l           1259    21201    CrmTaskTenant3    TABLE     T  CREATE TABLE public."CrmTaskTenant3" (
    "TaskId" integer DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass) NOT NULL,
    "Title" text NOT NULL,
    "DueDate" timestamp without time zone,
    "Priority" integer,
    "Status" integer,
    "Description" text,
    "TaskOwner" character varying(450) NOT NULL,
    "Id" integer DEFAULT '-1'::integer,
    "IsCompany" integer DEFAULT '-1'::integer,
    "IsLead" integer DEFAULT '-1'::integer,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL,
    "TenantId" integer NOT NULL,
    "Type" text,
    "Order" integer DEFAULT '-1'::integer NOT NULL,
    "IsOpportunity" integer
);
 $   DROP TABLE public."CrmTaskTenant3";
       public         heap    postgres    false    360    349            m           1259    21213    CrmTeam    TABLE     �  CREATE TABLE public."CrmTeam" (
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
       public            postgres    false            n           1259    21218    CrmTeamMember    TABLE     �  CREATE TABLE public."CrmTeamMember" (
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
       public            postgres    false            o           1259    21223    CrmTeamMember_TeamMemberId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTeamMember_TeamMemberId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."CrmTeamMember_TeamMemberId_seq";
       public          postgres    false    366            M           0    0    CrmTeamMember_TeamMemberId_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."CrmTeamMember_TeamMemberId_seq" OWNED BY public."CrmTeamMember"."TeamMemberId";
          public          postgres    false    367            p           1259    21224    CrmTeamMemberTenant1    TABLE       CREATE TABLE public."CrmTeamMemberTenant1" (
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
       public         heap    postgres    false    367    366            q           1259    21232    CrmTeamMemberTenant100    TABLE       CREATE TABLE public."CrmTeamMemberTenant100" (
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
       public         heap    postgres    false    367    366            r           1259    21240    CrmTeamMemberTenant2    TABLE       CREATE TABLE public."CrmTeamMemberTenant2" (
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
       public         heap    postgres    false    367    366            s           1259    21248    CrmTeamMemberTenant3    TABLE       CREATE TABLE public."CrmTeamMemberTenant3" (
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
       public         heap    postgres    false    367    366            t           1259    21256    CrmTeam_TeamId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmTeam_TeamId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."CrmTeam_TeamId_seq";
       public          postgres    false    365            N           0    0    CrmTeam_TeamId_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."CrmTeam_TeamId_seq" OWNED BY public."CrmTeam"."TeamId";
          public          postgres    false    372            u           1259    21257    CrmTeamTenant1    TABLE     �  CREATE TABLE public."CrmTeamTenant1" (
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
       public         heap    postgres    false    372    365            v           1259    21265    CrmTeamTenant100    TABLE        CREATE TABLE public."CrmTeamTenant100" (
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
       public         heap    postgres    false    372    365            w           1259    21273    CrmTeamTenant2    TABLE     �  CREATE TABLE public."CrmTeamTenant2" (
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
       public         heap    postgres    false    372    365            x           1259    21281    CrmTeamTenant3    TABLE     �  CREATE TABLE public."CrmTeamTenant3" (
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
       public         heap    postgres    false    372    365            y           1259    21289    CrmUserActivityLog    TABLE     �  CREATE TABLE public."CrmUserActivityLog" (
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
    "IsLead" integer,
    "IsCompany" integer,
    "IsOpportunity" integer
)
PARTITION BY RANGE ("TenantId");
 (   DROP TABLE public."CrmUserActivityLog";
       public            postgres    false            z           1259    21294 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmUserActivityLog_ActivityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."CrmUserActivityLog_ActivityId_seq";
       public          postgres    false    377            O           0    0 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."CrmUserActivityLog_ActivityId_seq" OWNED BY public."CrmUserActivityLog"."ActivityId";
          public          postgres    false    378            {           1259    21295    CrmUserActivityLogTenant1    TABLE     �  CREATE TABLE public."CrmUserActivityLogTenant1" (
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
    "IsLead" integer,
    "IsCompany" integer,
    "IsOpportunity" integer
);
 /   DROP TABLE public."CrmUserActivityLogTenant1";
       public         heap    postgres    false    378    377            |           1259    21303    CrmUserActivityLogTenant100    TABLE     �  CREATE TABLE public."CrmUserActivityLogTenant100" (
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
    "IsLead" integer,
    "IsCompany" integer,
    "IsOpportunity" integer
);
 1   DROP TABLE public."CrmUserActivityLogTenant100";
       public         heap    postgres    false    378    377            }           1259    21311    CrmUserActivityLogTenant2    TABLE     �  CREATE TABLE public."CrmUserActivityLogTenant2" (
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
    "IsLead" integer,
    "IsCompany" integer,
    "IsOpportunity" integer
);
 /   DROP TABLE public."CrmUserActivityLogTenant2";
       public         heap    postgres    false    378    377            ~           1259    21319    CrmUserActivityLogTenant3    TABLE     �  CREATE TABLE public."CrmUserActivityLogTenant3" (
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
    "IsLead" integer,
    "IsCompany" integer,
    "IsOpportunity" integer
);
 /   DROP TABLE public."CrmUserActivityLogTenant3";
       public         heap    postgres    false    378    377                       1259    21327    CrmUserActivityType    TABLE     �   CREATE TABLE public."CrmUserActivityType" (
    "ActivityTypeId" integer NOT NULL,
    "ActivityTypeTitle" text NOT NULL,
    "Icon" character varying(50) NOT NULL,
    "IsDeleted" integer DEFAULT 0
);
 )   DROP TABLE public."CrmUserActivityType";
       public         heap    postgres    false            �           1259    21333 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE     �   CREATE SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq";
       public          postgres    false    383            P           0    0 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public."CrmUserActivityType_ActivityTypeId_seq" OWNED BY public."CrmUserActivityType"."ActivityTypeId";
          public          postgres    false    384            �           1259    21334    Tenant    TABLE     g  CREATE TABLE public."Tenant" (
    "TenantId" integer NOT NULL,
    "Name" text NOT NULL,
    "CreatedBy" character varying(450) NOT NULL,
    "CreatedDate" timestamp without time zone DEFAULT CURRENT_DATE NOT NULL,
    "LastModifiedBy" character varying(450),
    "LastModifiedDate" timestamp without time zone,
    "IsDeleted" integer DEFAULT 0 NOT NULL
);
    DROP TABLE public."Tenant";
       public         heap    postgres    false            �           0    0    CrmAdAccount1    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    398    397            �           0    0    CrmAdAccount100    TABLE ATTACH     v   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    399    397            �           0    0    CrmAdAccount2    TABLE ATTACH     m   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    400    397            �           0    0    CrmAdAccount3    TABLE ATTACH     m   ALTER TABLE ONLY public."CrmAdAccount" ATTACH PARTITION public."CrmAdAccount3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    401    397            }           0    0    CrmCalenderEventsTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    237    235            ~           0    0    CrmCalenderEventsTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    238    235                       0    0    CrmCalenderEventsTenant2    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    239    235            �           0    0    CrmCalenderEventsTenant3    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCalenderEvents" ATTACH PARTITION public."CrmCalenderEventsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    240    235            �           0    0    CrmCall1    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    243    241            �           0    0 
   CrmCall100    TABLE ATTACH     l   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    244    241            �           0    0    CrmCall2    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    245    241            �           0    0    CrmCall3    TABLE ATTACH     c   ALTER TABLE ONLY public."CrmCall" ATTACH PARTITION public."CrmCall3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    246    241            �           0    0    CrmCompanyActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    250    248            �           0    0    CrmCompanyActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    251    248            �           0    0    CrmCompanyActivityLogTenant2    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    252    248            �           0    0    CrmCompanyActivityLogTenant3    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ATTACH PARTITION public."CrmCompanyActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    253    248            �           0    0    CrmCompanyMemberTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    256    254            �           0    0    CrmCompanyMemberTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    257    254            �           0    0    CrmCompanyMemberTenant2    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    258    254            �           0    0    CrmCompanyMemberTenant3    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmCompanyMember" ATTACH PARTITION public."CrmCompanyMemberTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    259    254            �           0    0    CrmCompanyTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    261    247            �           0    0    CrmCompanyTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    262    247            �           0    0    CrmCompanyTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    263    247            �           0    0    CrmCompanyTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmCompany" ATTACH PARTITION public."CrmCompanyTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    264    247            �           0    0    CrmCustomListsTenant1    TABLE ATTACH     }   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    267    265            �           0    0    CrmCustomListsTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    268    265            �           0    0    CrmCustomListsTenant2    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    269    265            �           0    0    CrmCustomListsTenant3    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmCustomLists" ATTACH PARTITION public."CrmCustomListsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    270    265            �           0    0 	   CrmEmail1    TABLE ATTACH     k   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    273    271            �           0    0    CrmEmail100    TABLE ATTACH     n   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    274    271            �           0    0 	   CrmEmail2    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    275    271            �           0    0 	   CrmEmail3    TABLE ATTACH     e   ALTER TABLE ONLY public."CrmEmail" ATTACH PARTITION public."CrmEmail3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    276    271            �           0    0    CrmIndustryTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    279    277            �           0    0    CrmIndustryTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    280    277            �           0    0    CrmIndustryTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    281    277            �           0    0    CrmIndustryTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmIndustry" ATTACH PARTITION public."CrmIndustryTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    282    277            �           0    0    CrmLeadActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    286    284            �           0    0    CrmLeadActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    287    284            �           0    0    CrmLeadActivityLogTenant2    TABLE ATTACH        ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    288    284            �           0    0    CrmLeadActivityLogTenant3    TABLE ATTACH        ALTER TABLE ONLY public."CrmLeadActivityLog" ATTACH PARTITION public."CrmLeadActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    289    284            �           0    0    CrmLeadSourceTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    292    290            �           0    0    CrmLeadSourceTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    293    290            �           0    0    CrmLeadSourceTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    294    290            �           0    0    CrmLeadSourceTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadSource" ATTACH PARTITION public."CrmLeadSourceTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    295    290            �           0    0    CrmLeadStatusTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    298    296            �           0    0    CrmLeadStatusTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    299    296            �           0    0    CrmLeadStatusTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    300    296            �           0    0    CrmLeadStatusTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmLeadStatus" ATTACH PARTITION public."CrmLeadStatusTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    301    296            �           0    0    CrmLeadTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    303    283            �           0    0    CrmLeadTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    304    283            �           0    0    CrmLeadTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    305    283            �           0    0    CrmLeadTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmLead" ATTACH PARTITION public."CrmLeadTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    306    283            �           0    0    CrmMeeting1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    309    307            �           0    0    CrmMeeting100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    310    307            �           0    0    CrmMeeting2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    311    307            �           0    0    CrmMeeting3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmMeeting" ATTACH PARTITION public."CrmMeeting3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    312    307            �           0    0    CrmNoteTagsTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    316    314            �           0    0    CrmNoteTagsTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    317    314            �           0    0    CrmNoteTagsTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    318    314            �           0    0    CrmNoteTagsTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmNoteTags" ATTACH PARTITION public."CrmNoteTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    319    314            �           0    0    CrmNoteTasksTenant1    TABLE ATTACH     y   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    322    320            �           0    0    CrmNoteTasksTenant100    TABLE ATTACH     |   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    323    320            �           0    0    CrmNoteTasksTenant2    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    324    320            �           0    0    CrmNoteTasksTenant3    TABLE ATTACH     s   ALTER TABLE ONLY public."CrmNoteTasks" ATTACH PARTITION public."CrmNoteTasksTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    325    320            �           0    0    CrmNoteTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    327    313            �           0    0    CrmNoteTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    328    313            �           0    0    CrmNoteTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    329    313            �           0    0    CrmNoteTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmNote" ATTACH PARTITION public."CrmNoteTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    330    313            �           0    0    CrmOpportunity1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    388    387            �           0    0    CrmOpportunity100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    391    387            �           0    0    CrmOpportunity2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    389    387            �           0    0    CrmOpportunity3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmOpportunity" ATTACH PARTITION public."CrmOpportunity3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    390    387            �           0    0    CrmProductTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    333    331            �           0    0    CrmProductTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    334    331            �           0    0    CrmProductTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    335    331            �           0    0    CrmProductTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmProduct" ATTACH PARTITION public."CrmProductTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    336    331            �           0    0    CrmTagUsedTenant1    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    339    337            �           0    0    CrmTagUsedTenant100    TABLE ATTACH     x   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    340    337            �           0    0    CrmTagUsedTenant2    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    341    337            �           0    0    CrmTagUsedTenant3    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTagUsed" ATTACH PARTITION public."CrmTagUsedTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    342    337            �           0    0    CrmTagsTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    345    343            �           0    0    CrmTagsTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    346    343            �           0    0    CrmTagsTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    347    343            �           0    0    CrmTagsTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTags" ATTACH PARTITION public."CrmTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    348    343            �           0    0    CrmTaskTagsTenant1    TABLE ATTACH     w   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    356    354            �           0    0    CrmTaskTagsTenant100    TABLE ATTACH     z   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    357    354            �           0    0    CrmTaskTagsTenant2    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    358    354            �           0    0    CrmTaskTagsTenant3    TABLE ATTACH     q   ALTER TABLE ONLY public."CrmTaskTags" ATTACH PARTITION public."CrmTaskTagsTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    359    354            �           0    0    CrmTaskTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    361    349            �           0    0    CrmTaskTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    362    349            �           0    0    CrmTaskTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    363    349            �           0    0    CrmTaskTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTask" ATTACH PARTITION public."CrmTaskTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    364    349            �           0    0    CrmTeamMemberTenant1    TABLE ATTACH     {   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    368    366            �           0    0    CrmTeamMemberTenant100    TABLE ATTACH     ~   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    369    366            �           0    0    CrmTeamMemberTenant2    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    370    366            �           0    0    CrmTeamMemberTenant3    TABLE ATTACH     u   ALTER TABLE ONLY public."CrmTeamMember" ATTACH PARTITION public."CrmTeamMemberTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    371    366            �           0    0    CrmTeamTenant1    TABLE ATTACH     o   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    373    365            �           0    0    CrmTeamTenant100    TABLE ATTACH     r   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    374    365            �           0    0    CrmTeamTenant2    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    375    365            �           0    0    CrmTeamTenant3    TABLE ATTACH     i   ALTER TABLE ONLY public."CrmTeam" ATTACH PARTITION public."CrmTeamTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    376    365            �           0    0    CrmUserActivityLogTenant1    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant1" FOR VALUES FROM (MINVALUE) TO (11);
          public          postgres    false    379    377            �           0    0    CrmUserActivityLogTenant100    TABLE ATTACH     �   ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant100" FOR VALUES FROM (100) TO (MAXVALUE);
          public          postgres    false    380    377            �           0    0    CrmUserActivityLogTenant2    TABLE ATTACH        ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant2" FOR VALUES FROM (11) TO (21);
          public          postgres    false    381    377            �           0    0    CrmUserActivityLogTenant3    TABLE ATTACH        ALTER TABLE ONLY public."CrmUserActivityLog" ATTACH PARTITION public."CrmUserActivityLogTenant3" FOR VALUES FROM (21) TO (31);
          public          postgres    false    382    377            �           2604    21341    AppMenus MenuId    DEFAULT     x   ALTER TABLE ONLY public."AppMenus" ALTER COLUMN "MenuId" SET DEFAULT nextval('public."AppMenus_MenuId_seq"'::regclass);
 B   ALTER TABLE public."AppMenus" ALTER COLUMN "MenuId" DROP DEFAULT;
       public          postgres    false    232    231            �           2604    22353    CrmAdAccount AccountId    DEFAULT     �   ALTER TABLE ONLY public."CrmAdAccount" ALTER COLUMN "AccountId" SET DEFAULT nextval('public."CrmAdAccount_AccountId_seq"'::regclass);
 I   ALTER TABLE public."CrmAdAccount" ALTER COLUMN "AccountId" DROP DEFAULT;
       public          postgres    false    397    396    397            �           2604    21342    CrmCalendarEventsType TypeId    DEFAULT     �   ALTER TABLE ONLY public."CrmCalendarEventsType" ALTER COLUMN "TypeId" SET DEFAULT nextval('public."CrmCalendarEventsType_TypeId_seq"'::regclass);
 O   ALTER TABLE public."CrmCalendarEventsType" ALTER COLUMN "TypeId" DROP DEFAULT;
       public          postgres    false    234    233            �           2604    21343    CrmCalenderEvents EventId    DEFAULT     �   ALTER TABLE ONLY public."CrmCalenderEvents" ALTER COLUMN "EventId" SET DEFAULT nextval('public."CrmCalenderEvents_EventId_seq"'::regclass);
 L   ALTER TABLE public."CrmCalenderEvents" ALTER COLUMN "EventId" DROP DEFAULT;
       public          postgres    false    236    235            �           2604    21344    CrmCall CallId    DEFAULT     v   ALTER TABLE ONLY public."CrmCall" ALTER COLUMN "CallId" SET DEFAULT nextval('public."CrmCall_CallId_seq"'::regclass);
 A   ALTER TABLE public."CrmCall" ALTER COLUMN "CallId" DROP DEFAULT;
       public          postgres    false    242    241                       2604    21345    CrmCompany CompanyId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompany" ALTER COLUMN "CompanyId" SET DEFAULT nextval('public."CrmCompany_CompanyId_seq"'::regclass);
 G   ALTER TABLE public."CrmCompany" ALTER COLUMN "CompanyId" DROP DEFAULT;
       public          postgres    false    260    247                       2604    21346     CrmCompanyActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompanyActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmCompanyActivityLog_ActivityId_seq"'::regclass);
 S   ALTER TABLE public."CrmCompanyActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    249    248                       2604    21347    CrmCompanyMember MemberId    DEFAULT     �   ALTER TABLE ONLY public."CrmCompanyMember" ALTER COLUMN "MemberId" SET DEFAULT nextval('public."CrmCompanyMember_MemberId_seq"'::regclass);
 L   ALTER TABLE public."CrmCompanyMember" ALTER COLUMN "MemberId" DROP DEFAULT;
       public          postgres    false    255    254            5           2604    21348    CrmCustomLists ListId    DEFAULT     �   ALTER TABLE ONLY public."CrmCustomLists" ALTER COLUMN "ListId" SET DEFAULT nextval('public."CrmCustomLists_ListId_seq"'::regclass);
 H   ALTER TABLE public."CrmCustomLists" ALTER COLUMN "ListId" DROP DEFAULT;
       public          postgres    false    266    265            I           2604    21349    CrmEmail EmailId    DEFAULT     z   ALTER TABLE ONLY public."CrmEmail" ALTER COLUMN "EmailId" SET DEFAULT nextval('public."CrmEmail_EmailId_seq"'::regclass);
 C   ALTER TABLE public."CrmEmail" ALTER COLUMN "EmailId" DROP DEFAULT;
       public          postgres    false    272    271            X           2604    21350    CrmIndustry IndustryId    DEFAULT     �   ALTER TABLE ONLY public."CrmIndustry" ALTER COLUMN "IndustryId" SET DEFAULT nextval('public."CrmIndustry_IndustryId_seq"'::regclass);
 I   ALTER TABLE public."CrmIndustry" ALTER COLUMN "IndustryId" DROP DEFAULT;
       public          postgres    false    278    277            g           2604    21351    CrmLead LeadId    DEFAULT     v   ALTER TABLE ONLY public."CrmLead" ALTER COLUMN "LeadId" SET DEFAULT nextval('public."CrmLead_LeadId_seq"'::regclass);
 A   ALTER TABLE public."CrmLead" ALTER COLUMN "LeadId" DROP DEFAULT;
       public          postgres    false    302    283            j           2604    21352    CrmLeadActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmLeadActivityLog_ActivityId_seq"'::regclass);
 P   ALTER TABLE public."CrmLeadActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    285    284            y           2604    21353    CrmLeadSource SourceId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadSource" ALTER COLUMN "SourceId" SET DEFAULT nextval('public."CrmLeadSource_SourceId_seq"'::regclass);
 I   ALTER TABLE public."CrmLeadSource" ALTER COLUMN "SourceId" DROP DEFAULT;
       public          postgres    false    291    290            �           2604    21354    CrmLeadStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmLeadStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmLeadStatus_StatusId_seq"'::regclass);
 I   ALTER TABLE public."CrmLeadStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    297    296            �           2604    21355    CrmMeeting MeetingId    DEFAULT     �   ALTER TABLE ONLY public."CrmMeeting" ALTER COLUMN "MeetingId" SET DEFAULT nextval('public."CrmMeeting_MeetingId_seq"'::regclass);
 G   ALTER TABLE public."CrmMeeting" ALTER COLUMN "MeetingId" DROP DEFAULT;
       public          postgres    false    308    307            �           2604    21356    CrmNote NoteId    DEFAULT     v   ALTER TABLE ONLY public."CrmNote" ALTER COLUMN "NoteId" SET DEFAULT nextval('public."CrmNote_NoteId_seq"'::regclass);
 A   ALTER TABLE public."CrmNote" ALTER COLUMN "NoteId" DROP DEFAULT;
       public          postgres    false    326    313            �           2604    21357    CrmNoteTags NoteTagsId    DEFAULT     �   ALTER TABLE ONLY public."CrmNoteTags" ALTER COLUMN "NoteTagsId" SET DEFAULT nextval('public."CrmNoteTags_NoteTagsId_seq"'::regclass);
 I   ALTER TABLE public."CrmNoteTags" ALTER COLUMN "NoteTagsId" DROP DEFAULT;
       public          postgres    false    315    314            �           2604    21358    CrmNoteTasks NoteTaskId    DEFAULT     �   ALTER TABLE ONLY public."CrmNoteTasks" ALTER COLUMN "NoteTaskId" SET DEFAULT nextval('public."CrmNoteTasks_NoteTaskId_seq"'::regclass);
 J   ALTER TABLE public."CrmNoteTasks" ALTER COLUMN "NoteTaskId" DROP DEFAULT;
       public          postgres    false    321    320            u           2604    22257    CrmOpportunity OpportunityId    DEFAULT     �   ALTER TABLE ONLY public."CrmOpportunity" ALTER COLUMN "OpportunityId" SET DEFAULT nextval('public."CrmOpportunity_OpportunityId_seq"'::regclass);
 O   ALTER TABLE public."CrmOpportunity" ALTER COLUMN "OpportunityId" DROP DEFAULT;
       public          postgres    false    386    387    387            �           2604    22334    CrmOpportunitySource SourceId    DEFAULT     �   ALTER TABLE ONLY public."CrmOpportunitySource" ALTER COLUMN "SourceId" SET DEFAULT nextval('public."CrmOpportunitySource_SourceId_seq"'::regclass);
 P   ALTER TABLE public."CrmOpportunitySource" ALTER COLUMN "SourceId" DROP DEFAULT;
       public          postgres    false    394    395    395            �           2604    22311    CrmOpportunityStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmOpportunityStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmOpportunityStatus_StatusId_seq"'::regclass);
 P   ALTER TABLE public."CrmOpportunityStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    393    392    393            �           2604    21359    CrmProduct ProductId    DEFAULT     �   ALTER TABLE ONLY public."CrmProduct" ALTER COLUMN "ProductId" SET DEFAULT nextval('public."CrmProduct_ProductId_seq"'::regclass);
 G   ALTER TABLE public."CrmProduct" ALTER COLUMN "ProductId" DROP DEFAULT;
       public          postgres    false    332    331            �           2604    21360    CrmTagUsed TagUsedId    DEFAULT     �   ALTER TABLE ONLY public."CrmTagUsed" ALTER COLUMN "TagUsedId" SET DEFAULT nextval('public."CrmTagUsed_TagUsedId_seq"'::regclass);
 G   ALTER TABLE public."CrmTagUsed" ALTER COLUMN "TagUsedId" DROP DEFAULT;
       public          postgres    false    338    337            �           2604    21361    CrmTags TagId    DEFAULT     t   ALTER TABLE ONLY public."CrmTags" ALTER COLUMN "TagId" SET DEFAULT nextval('public."CrmTags_TagId_seq"'::regclass);
 @   ALTER TABLE public."CrmTags" ALTER COLUMN "TagId" DROP DEFAULT;
       public          postgres    false    344    343                       2604    21362    CrmTask TaskId    DEFAULT     v   ALTER TABLE ONLY public."CrmTask" ALTER COLUMN "TaskId" SET DEFAULT nextval('public."CrmTask_TaskId_seq"'::regclass);
 A   ALTER TABLE public."CrmTask" ALTER COLUMN "TaskId" DROP DEFAULT;
       public          postgres    false    360    349                       2604    21363    CrmTaskPriority PriorityId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskPriority" ALTER COLUMN "PriorityId" SET DEFAULT nextval('public."CrmTaskPriority_PriorityId_seq"'::regclass);
 M   ALTER TABLE public."CrmTaskPriority" ALTER COLUMN "PriorityId" DROP DEFAULT;
       public          postgres    false    351    350                       2604    21364    CrmTaskStatus StatusId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskStatus" ALTER COLUMN "StatusId" SET DEFAULT nextval('public."CrmTaskStatus_StatusId_seq"'::regclass);
 I   ALTER TABLE public."CrmTaskStatus" ALTER COLUMN "StatusId" DROP DEFAULT;
       public          postgres    false    353    352                       2604    21365    CrmTaskTags TaskTagsId    DEFAULT     �   ALTER TABLE ONLY public."CrmTaskTags" ALTER COLUMN "TaskTagsId" SET DEFAULT nextval('public."CrmTaskTags_TaskTagsId_seq"'::regclass);
 I   ALTER TABLE public."CrmTaskTags" ALTER COLUMN "TaskTagsId" DROP DEFAULT;
       public          postgres    false    355    354            D           2604    21366    CrmTeam TeamId    DEFAULT     v   ALTER TABLE ONLY public."CrmTeam" ALTER COLUMN "TeamId" SET DEFAULT nextval('public."CrmTeam_TeamId_seq"'::regclass);
 A   ALTER TABLE public."CrmTeam" ALTER COLUMN "TeamId" DROP DEFAULT;
       public          postgres    false    372    365            G           2604    21367    CrmTeamMember TeamMemberId    DEFAULT     �   ALTER TABLE ONLY public."CrmTeamMember" ALTER COLUMN "TeamMemberId" SET DEFAULT nextval('public."CrmTeamMember_TeamMemberId_seq"'::regclass);
 M   ALTER TABLE public."CrmTeamMember" ALTER COLUMN "TeamMemberId" DROP DEFAULT;
       public          postgres    false    367    366            b           2604    21368    CrmUserActivityLog ActivityId    DEFAULT     �   ALTER TABLE ONLY public."CrmUserActivityLog" ALTER COLUMN "ActivityId" SET DEFAULT nextval('public."CrmUserActivityLog_ActivityId_seq"'::regclass);
 P   ALTER TABLE public."CrmUserActivityLog" ALTER COLUMN "ActivityId" DROP DEFAULT;
       public          postgres    false    378    377            q           2604    21369 "   CrmUserActivityType ActivityTypeId    DEFAULT     �   ALTER TABLE ONLY public."CrmUserActivityType" ALTER COLUMN "ActivityTypeId" SET DEFAULT nextval('public."CrmUserActivityType_ActivityTypeId_seq"'::regclass);
 U   ALTER TABLE public."CrmUserActivityType" ALTER COLUMN "ActivityTypeId" DROP DEFAULT;
       public          postgres    false    384    383            �          0    20359    AppMenus 
   TABLE DATA           �   COPY public."AppMenus" ("MenuId", "Code", "Title", "Subtitle", "Type", "Icon", "Link", "Level", "CreatedBy", "CreatedOn", "LastModifiedBy", "LastModifiedOn", "IsDeleted", "ParentId", "Order") FROM stdin;
    public          postgres    false    231   #0      &          0    22359    CrmAdAccount1 
   TABLE DATA           �   COPY public."CrmAdAccount1" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    398   �2      '          0    22370    CrmAdAccount100 
   TABLE DATA           �   COPY public."CrmAdAccount100" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    399   �2      (          0    22381    CrmAdAccount2 
   TABLE DATA           �   COPY public."CrmAdAccount2" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    400   �2      )          0    22392    CrmAdAccount3 
   TABLE DATA           �   COPY public."CrmAdAccount3" ("AccountId", "Title", "IsSelected", "SocialId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    401   �2      �          0    20367    CrmCalendarEventsType 
   TABLE DATA           U   COPY public."CrmCalendarEventsType" ("TypeId", "TypeTitle", "IsDeleted") FROM stdin;
    public          postgres    false    233   �2      �          0    20380    CrmCalenderEventsTenant1 
   TABLE DATA             COPY public."CrmCalenderEventsTenant1" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsCompany", "IsLead", "AllDay", "IsOpportunity") FROM stdin;
    public          postgres    false    237   C3      �          0    20388    CrmCalenderEventsTenant100 
   TABLE DATA             COPY public."CrmCalenderEventsTenant100" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsCompany", "IsLead", "AllDay", "IsOpportunity") FROM stdin;
    public          postgres    false    238   �5      �          0    20396    CrmCalenderEventsTenant2 
   TABLE DATA             COPY public."CrmCalenderEventsTenant2" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsCompany", "IsLead", "AllDay", "IsOpportunity") FROM stdin;
    public          postgres    false    239   �5      �          0    20404    CrmCalenderEventsTenant3 
   TABLE DATA             COPY public."CrmCalenderEventsTenant3" ("EventId", "UserId", "Description", "Type", "StartTime", "EndTime", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsCompany", "IsLead", "AllDay", "IsOpportunity") FROM stdin;
    public          postgres    false    240   �5      �          0    20418    CrmCall1 
   TABLE DATA           �   COPY public."CrmCall1" ("CallId", "Subject", "Response", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    243   6      �          0    20426 
   CrmCall100 
   TABLE DATA           �   COPY public."CrmCall100" ("CallId", "Subject", "Response", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    244   8      �          0    20434    CrmCall2 
   TABLE DATA           �   COPY public."CrmCall2" ("CallId", "Subject", "Response", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    245   /8      �          0    20442    CrmCall3 
   TABLE DATA           �   COPY public."CrmCall3" ("CallId", "Subject", "Response", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    246   L8      �          0    20461    CrmCompanyActivityLogTenant1 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant1" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    250   i8      �          0    20469    CrmCompanyActivityLogTenant100 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant100" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    251   �8      �          0    20477    CrmCompanyActivityLogTenant2 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant2" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    252   �8      �          0    20485    CrmCompanyActivityLogTenant3 
   TABLE DATA           �   COPY public."CrmCompanyActivityLogTenant3" ("ActivityId", "CompanyId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    253   �8      �          0    20499    CrmCompanyMemberTenant1 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant1" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    256   �8      �          0    20507    CrmCompanyMemberTenant100 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant100" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    257   �8      �          0    20515    CrmCompanyMemberTenant2 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant2" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    258   9      �          0    20523    CrmCompanyMemberTenant3 
   TABLE DATA           �   COPY public."CrmCompanyMemberTenant3" ("MemberId", "CompanyId", "LeadId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    259   49      �          0    20532    CrmCompanyTenant1 
   TABLE DATA           �  COPY public."CrmCompanyTenant1" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    261   Q9      �          0    20540    CrmCompanyTenant100 
   TABLE DATA           �  COPY public."CrmCompanyTenant100" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    262   d<      �          0    20548    CrmCompanyTenant2 
   TABLE DATA           �  COPY public."CrmCompanyTenant2" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    263   �<      �          0    20556    CrmCompanyTenant3 
   TABLE DATA           �  COPY public."CrmCompanyTenant3" ("CompanyId", "Name", "Website", "CompanyOwner", "Mobile", "Work", "BillingAddress", "BillingStreet", "BillingCity", "BillingZip", "BillingState", "BillingCountry", "DeliveryAddress", "DeliveryStreet", "DeliveryCity", "DeliveryZip", "DeliveryState", "DeliveryCountry", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Email") FROM stdin;
    public          postgres    false    264   �<      �          0    20571    CrmCustomListsTenant1 
   TABLE DATA           �   COPY public."CrmCustomListsTenant1" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    267   �<      �          0    20580    CrmCustomListsTenant100 
   TABLE DATA           �   COPY public."CrmCustomListsTenant100" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    268   >?      �          0    20589    CrmCustomListsTenant2 
   TABLE DATA           �   COPY public."CrmCustomListsTenant2" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    269   [?      �          0    20598    CrmCustomListsTenant3 
   TABLE DATA           �   COPY public."CrmCustomListsTenant3" ("ListId", "ListTitle", "Filter", "Type", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsPublic") FROM stdin;
    public          postgres    false    270   x?      �          0    20613 	   CrmEmail1 
   TABLE DATA           �   COPY public."CrmEmail1" ("EmailId", "Subject", "Description", "Reply", "Id", "IsCompany", "IsLead", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "IsOpportunity") FROM stdin;
    public          postgres    false    273   �?      �          0    20621    CrmEmail100 
   TABLE DATA           �   COPY public."CrmEmail100" ("EmailId", "Subject", "Description", "Reply", "Id", "IsCompany", "IsLead", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "IsOpportunity") FROM stdin;
    public          postgres    false    274   bA      �          0    20629 	   CrmEmail2 
   TABLE DATA           �   COPY public."CrmEmail2" ("EmailId", "Subject", "Description", "Reply", "Id", "IsCompany", "IsLead", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "IsOpportunity") FROM stdin;
    public          postgres    false    275   A      �          0    20637 	   CrmEmail3 
   TABLE DATA           �   COPY public."CrmEmail3" ("EmailId", "Subject", "Description", "Reply", "Id", "IsCompany", "IsLead", "SendDate", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsSuccessful", "CreatedBy", "IsOpportunity") FROM stdin;
    public          postgres    false    276   �A      �          0    20651    CrmIndustryTenant1 
   TABLE DATA           �   COPY public."CrmIndustryTenant1" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    279   �A      �          0    20659    CrmIndustryTenant100 
   TABLE DATA           �   COPY public."CrmIndustryTenant100" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    280   RC      �          0    20667    CrmIndustryTenant2 
   TABLE DATA           �   COPY public."CrmIndustryTenant2" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    281   oC      �          0    20675    CrmIndustryTenant3 
   TABLE DATA           �   COPY public."CrmIndustryTenant3" ("IndustryId", "IndustryTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    282   �C      �          0    20694    CrmLeadActivityLogTenant1 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant1" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    286   �C      �          0    20702    CrmLeadActivityLogTenant100 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant100" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    287   �C      �          0    20710    CrmLeadActivityLogTenant2 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant2" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    288   �C      �          0    20718    CrmLeadActivityLogTenant3 
   TABLE DATA           �   COPY public."CrmLeadActivityLogTenant3" ("ActivityId", "LeadId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    289    D      �          0    20732    CrmLeadSourceTenant1 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant1" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    292   D      �          0    20740    CrmLeadSourceTenant100 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant100" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    293   �D      �          0    20748    CrmLeadSourceTenant2 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant2" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    294   �D      �          0    20756    CrmLeadSourceTenant3 
   TABLE DATA           �   COPY public."CrmLeadSourceTenant3" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    295   E      �          0    20770    CrmLeadStatusTenant1 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant1" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    298   "E      �          0    20778    CrmLeadStatusTenant100 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant100" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    299   �E      �          0    20786    CrmLeadStatusTenant2 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant2" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    300   �E      �          0    20794    CrmLeadStatusTenant3 
   TABLE DATA           �   COPY public."CrmLeadStatusTenant3" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    301   �E      �          0    20803    CrmLeadTenant1 
   TABLE DATA           9  COPY public."CrmLeadTenant1" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId") FROM stdin;
    public          postgres    false    303   F      �          0    20811    CrmLeadTenant100 
   TABLE DATA           ;  COPY public."CrmLeadTenant100" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId") FROM stdin;
    public          postgres    false    304   CK      �          0    20819    CrmLeadTenant2 
   TABLE DATA           9  COPY public."CrmLeadTenant2" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId") FROM stdin;
    public          postgres    false    305   `K      �          0    20827    CrmLeadTenant3 
   TABLE DATA           9  COPY public."CrmLeadTenant3" ("LeadId", "Email", "FirstName", "LastName", "Status", "LeadOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "ProductId") FROM stdin;
    public          postgres    false    306   }K      �          0    20841    CrmMeeting1 
   TABLE DATA           �   COPY public."CrmMeeting1" ("MeetingId", "Subject", "Note", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    309   �K      �          0    20849    CrmMeeting100 
   TABLE DATA           �   COPY public."CrmMeeting100" ("MeetingId", "Subject", "Note", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    310   }M      �          0    20857    CrmMeeting2 
   TABLE DATA           �   COPY public."CrmMeeting2" ("MeetingId", "Subject", "Note", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    311   �M      �          0    20865    CrmMeeting3 
   TABLE DATA           �   COPY public."CrmMeeting3" ("MeetingId", "Subject", "Note", "Id", "IsCompany", "IsLead", "CreatedBy", "StartTime", "EndTime", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "IsOpportunity") FROM stdin;
    public          postgres    false    312   �M      �          0    20884    CrmNoteTagsTenant1 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant1" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    316   �M      �          0    20892    CrmNoteTagsTenant100 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant100" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    317   uN      �          0    20900    CrmNoteTagsTenant2 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant2" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    318   �N      �          0    20908    CrmNoteTagsTenant3 
   TABLE DATA           �   COPY public."CrmNoteTagsTenant3" ("NoteTagsId", "NoteId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    319   �N      �          0    20922    CrmNoteTasksTenant1 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant1" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    322   �N      �          0    20930    CrmNoteTasksTenant100 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant100" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    323   �O      �          0    20938    CrmNoteTasksTenant2 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant2" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    324   �O      �          0    20946    CrmNoteTasksTenant3 
   TABLE DATA           �   COPY public."CrmNoteTasksTenant3" ("NoteTaskId", "NoteId", "Task", "IsCompleted", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    325   �O      �          0    20955    CrmNoteTenant1 
   TABLE DATA           �   COPY public."CrmNoteTenant1" ("NoteId", "Content", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "IsOpportunity") FROM stdin;
    public          postgres    false    327   �O      �          0    20963    CrmNoteTenant100 
   TABLE DATA           �   COPY public."CrmNoteTenant100" ("NoteId", "Content", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "IsOpportunity") FROM stdin;
    public          postgres    false    328   �Q      �          0    20971    CrmNoteTenant2 
   TABLE DATA           �   COPY public."CrmNoteTenant2" ("NoteId", "Content", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "IsOpportunity") FROM stdin;
    public          postgres    false    329   �Q      �          0    20979    CrmNoteTenant3 
   TABLE DATA           �   COPY public."CrmNoteTenant3" ("NoteId", "Content", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "NoteTitle", "IsOpportunity") FROM stdin;
    public          postgres    false    330   �Q                0    22262    CrmOpportunity1 
   TABLE DATA           J  COPY public."CrmOpportunity1" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    388   R                 0    22292    CrmOpportunity100 
   TABLE DATA           L  COPY public."CrmOpportunity100" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    391   <W                0    22272    CrmOpportunity2 
   TABLE DATA           J  COPY public."CrmOpportunity2" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    389   YW                0    22282    CrmOpportunity3 
   TABLE DATA           J  COPY public."CrmOpportunity3" ("OpportunityId", "Email", "FirstName", "LastName", "StatusId", "OpportunityOwner", "Mobile", "Work", "Address", "Street", "City", "Zip", "State", "Country", "SourceId", "IndustryId", "ProductId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    390   vW      $          0    22331    CrmOpportunitySource 
   TABLE DATA           �   COPY public."CrmOpportunitySource" ("SourceId", "SourceTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    395   �W      "          0    22308    CrmOpportunityStatus 
   TABLE DATA           �   COPY public."CrmOpportunityStatus" ("StatusId", "StatusTitle", "IsDeletable", "Order", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    393   �X      �          0    20993    CrmProductTenant1 
   TABLE DATA           �   COPY public."CrmProductTenant1" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    333   �Y      �          0    21001    CrmProductTenant100 
   TABLE DATA           �   COPY public."CrmProductTenant100" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    334   '[      �          0    21009    CrmProductTenant2 
   TABLE DATA           �   COPY public."CrmProductTenant2" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    335   D[      �          0    21017    CrmProductTenant3 
   TABLE DATA           �   COPY public."CrmProductTenant3" ("ProductId", "ProductName", "Description", "Price", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    336   a[      �          0    21031    CrmTagUsedTenant1 
   TABLE DATA           �   COPY public."CrmTagUsedTenant1" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    339   ~[      �          0    21039    CrmTagUsedTenant100 
   TABLE DATA           �   COPY public."CrmTagUsedTenant100" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    340   �[      �          0    21047    CrmTagUsedTenant2 
   TABLE DATA           �   COPY public."CrmTagUsedTenant2" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    341   �[      �          0    21055    CrmTagUsedTenant3 
   TABLE DATA           �   COPY public."CrmTagUsedTenant3" ("TagUsedId", "TagId", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    342   �[      �          0    21069    CrmTagsTenant1 
   TABLE DATA           �   COPY public."CrmTagsTenant1" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    345   �[      �          0    21077    CrmTagsTenant100 
   TABLE DATA           �   COPY public."CrmTagsTenant100" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    346   C]      �          0    21085    CrmTagsTenant2 
   TABLE DATA           �   COPY public."CrmTagsTenant2" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    347   `]      �          0    21093    CrmTagsTenant3 
   TABLE DATA           �   COPY public."CrmTagsTenant3" ("TagId", "TagTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    348   }]      �          0    21110    CrmTaskPriority 
   TABLE DATA           �   COPY public."CrmTaskPriority" ("PriorityId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "PriorityTitle") FROM stdin;
    public          postgres    false    350   �]      �          0    21118    CrmTaskStatus 
   TABLE DATA           �   COPY public."CrmTaskStatus" ("StatusId", "StatusTitle", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted") FROM stdin;
    public          postgres    false    352   ^                0    21132    CrmTaskTagsTenant1 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant1" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    356   �^                0    21140    CrmTaskTagsTenant100 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant100" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    357   �_                0    21148    CrmTaskTagsTenant2 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant2" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    358   �_                0    21156    CrmTaskTagsTenant3 
   TABLE DATA           �   COPY public."CrmTaskTagsTenant3" ("TaskTagsId", "TaskId", "TagId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    359   �_                0    21165    CrmTaskTenant1 
   TABLE DATA             COPY public."CrmTaskTenant1" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "IsOpportunity") FROM stdin;
    public          postgres    false    361   �_                0    21177    CrmTaskTenant100 
   TABLE DATA             COPY public."CrmTaskTenant100" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "IsOpportunity") FROM stdin;
    public          postgres    false    362   �a                0    21189    CrmTaskTenant2 
   TABLE DATA             COPY public."CrmTaskTenant2" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "IsOpportunity") FROM stdin;
    public          postgres    false    363   
b      	          0    21201    CrmTaskTenant3 
   TABLE DATA             COPY public."CrmTaskTenant3" ("TaskId", "Title", "DueDate", "Priority", "Status", "Description", "TaskOwner", "Id", "IsCompany", "IsLead", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Type", "Order", "IsOpportunity") FROM stdin;
    public          postgres    false    364   'b                0    21224    CrmTeamMemberTenant1 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant1" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    368   Db                0    21232    CrmTeamMemberTenant100 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant100" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    369   �c                0    21240    CrmTeamMemberTenant2 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant2" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    370   �c                0    21248    CrmTeamMemberTenant3 
   TABLE DATA           �   COPY public."CrmTeamMemberTenant3" ("TeamMemberId", "UserId", "TeamId", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    371   �c                0    21257    CrmTeamTenant1 
   TABLE DATA           �   COPY public."CrmTeamTenant1" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    373   �c                0    21265    CrmTeamTenant100 
   TABLE DATA           �   COPY public."CrmTeamTenant100" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    374   e                0    21273    CrmTeamTenant2 
   TABLE DATA           �   COPY public."CrmTeamTenant2" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    375   2e                0    21281    CrmTeamTenant3 
   TABLE DATA           �   COPY public."CrmTeamTenant3" ("TeamId", "Name", "TeamLeader", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId") FROM stdin;
    public          postgres    false    376   Oe                0    21295    CrmUserActivityLogTenant1 
   TABLE DATA             COPY public."CrmUserActivityLogTenant1" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsLead", "IsCompany", "IsOpportunity") FROM stdin;
    public          postgres    false    379   le                0    21303    CrmUserActivityLogTenant100 
   TABLE DATA             COPY public."CrmUserActivityLogTenant100" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsLead", "IsCompany", "IsOpportunity") FROM stdin;
    public          postgres    false    380   @i                0    21311    CrmUserActivityLogTenant2 
   TABLE DATA             COPY public."CrmUserActivityLogTenant2" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsLead", "IsCompany", "IsOpportunity") FROM stdin;
    public          postgres    false    381   ]i                0    21319    CrmUserActivityLogTenant3 
   TABLE DATA             COPY public."CrmUserActivityLogTenant3" ("ActivityId", "UserId", "ActivityType", "ActivityStatus", "Detail", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted", "TenantId", "Id", "IsLead", "IsCompany", "IsOpportunity") FROM stdin;
    public          postgres    false    382   zi                0    21327    CrmUserActivityType 
   TABLE DATA           k   COPY public."CrmUserActivityType" ("ActivityTypeId", "ActivityTypeTitle", "Icon", "IsDeleted") FROM stdin;
    public          postgres    false    383   �i                0    21334    Tenant 
   TABLE DATA           �   COPY public."Tenant" ("TenantId", "Name", "CreatedBy", "CreatedDate", "LastModifiedBy", "LastModifiedDate", "IsDeleted") FROM stdin;
    public          postgres    false    385   j      Q           0    0    AppMenus_MenuId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."AppMenus_MenuId_seq"', 32, true);
          public          postgres    false    232            R           0    0    CrmAdAccount_AccountId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmAdAccount_AccountId_seq"', 1, false);
          public          postgres    false    396            S           0    0     CrmCalendarEventsType_TypeId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmCalendarEventsType_TypeId_seq"', 12, true);
          public          postgres    false    234            T           0    0    CrmCalenderEvents_EventId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CrmCalenderEvents_EventId_seq"', 48, true);
          public          postgres    false    236            U           0    0    CrmCall_CallId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmCall_CallId_seq"', 18, true);
          public          postgres    false    242            V           0    0 $   CrmCompanyActivityLog_ActivityId_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."CrmCompanyActivityLog_ActivityId_seq"', 1, false);
          public          postgres    false    249            W           0    0    CrmCompanyMember_MemberId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CrmCompanyMember_MemberId_seq"', 1, false);
          public          postgres    false    255            X           0    0    CrmCompany_CompanyId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmCompany_CompanyId_seq"', 19, true);
          public          postgres    false    260            Y           0    0    CrmCustomLists_ListId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmCustomLists_ListId_seq"', 15, true);
          public          postgres    false    266            Z           0    0    CrmEmail_EmailId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."CrmEmail_EmailId_seq"', 37, true);
          public          postgres    false    272            [           0    0    CrmIndustry_IndustryId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmIndustry_IndustryId_seq"', 20, true);
          public          postgres    false    278            \           0    0 !   CrmLeadActivityLog_ActivityId_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public."CrmLeadActivityLog_ActivityId_seq"', 1, false);
          public          postgres    false    285            ]           0    0    CrmLeadSource_SourceId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmLeadSource_SourceId_seq"', 7, true);
          public          postgres    false    291            ^           0    0    CrmLeadStatus_StatusId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmLeadStatus_StatusId_seq"', 9, true);
          public          postgres    false    297            _           0    0    CrmLead_LeadId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmLead_LeadId_seq"', 24, true);
          public          postgres    false    302            `           0    0    CrmMeeting_MeetingId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."CrmMeeting_MeetingId_seq"', 8, true);
          public          postgres    false    308            a           0    0    CrmNoteTags_NoteTagsId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmNoteTags_NoteTagsId_seq"', 33, true);
          public          postgres    false    315            b           0    0    CrmNoteTasks_NoteTaskId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CrmNoteTasks_NoteTaskId_seq"', 27, true);
          public          postgres    false    321            c           0    0    CrmNote_NoteId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmNote_NoteId_seq"', 23, true);
          public          postgres    false    326            d           0    0 !   CrmOpportunitySource_SourceId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmOpportunitySource_SourceId_seq"', 7, true);
          public          postgres    false    394            e           0    0 !   CrmOpportunityStatus_StatusId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmOpportunityStatus_StatusId_seq"', 6, true);
          public          postgres    false    392            f           0    0     CrmOpportunity_OpportunityId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."CrmOpportunity_OpportunityId_seq"', 20, true);
          public          postgres    false    386            g           0    0    CrmProduct_ProductId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmProduct_ProductId_seq"', 22, true);
          public          postgres    false    332            h           0    0    CrmTagUsed_TagUsedId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."CrmTagUsed_TagUsedId_seq"', 1, false);
          public          postgres    false    338            i           0    0    CrmTags_TagId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."CrmTags_TagId_seq"', 37, true);
          public          postgres    false    344            j           0    0    CrmTaskPriority_PriorityId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmTaskPriority_PriorityId_seq"', 1, false);
          public          postgres    false    351            k           0    0    CrmTaskStatus_StatusId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CrmTaskStatus_StatusId_seq"', 4, true);
          public          postgres    false    353            l           0    0    CrmTaskTags_TaskTagsId_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CrmTaskTags_TaskTagsId_seq"', 90, true);
          public          postgres    false    355            m           0    0    CrmTask_TaskId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."CrmTask_TaskId_seq"', 34, true);
          public          postgres    false    360            n           0    0    CrmTeamMember_TeamMemberId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CrmTeamMember_TeamMemberId_seq"', 14, true);
          public          postgres    false    367            o           0    0    CrmTeam_TeamId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."CrmTeam_TeamId_seq"', 4, true);
          public          postgres    false    372            p           0    0 !   CrmUserActivityLog_ActivityId_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."CrmUserActivityLog_ActivityId_seq"', 122, true);
          public          postgres    false    378            q           0    0 &   CrmUserActivityType_ActivityTypeId_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public."CrmUserActivityType_ActivityTypeId_seq"', 5, true);
          public          postgres    false    384            (           2606    22357    CrmAdAccount CrmAdAccount_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmAdAccount"
    ADD CONSTRAINT "CrmAdAccount_pkey" PRIMARY KEY ("AccountId", "TenantId");
 L   ALTER TABLE ONLY public."CrmAdAccount" DROP CONSTRAINT "CrmAdAccount_pkey";
       public            postgres    false    397    397            /           2606    22377 $   CrmAdAccount100 CrmAdAccount100_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public."CrmAdAccount100"
    ADD CONSTRAINT "CrmAdAccount100_pkey" PRIMARY KEY ("AccountId", "TenantId");
 R   ALTER TABLE ONLY public."CrmAdAccount100" DROP CONSTRAINT "CrmAdAccount100_pkey";
       public            postgres    false    399    399    399    6184            ,           2606    22366     CrmAdAccount1 CrmAdAccount1_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount1"
    ADD CONSTRAINT "CrmAdAccount1_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount1" DROP CONSTRAINT "CrmAdAccount1_pkey";
       public            postgres    false    398    398    6184    398            2           2606    22388     CrmAdAccount2 CrmAdAccount2_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount2"
    ADD CONSTRAINT "CrmAdAccount2_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount2" DROP CONSTRAINT "CrmAdAccount2_pkey";
       public            postgres    false    6184    400    400    400            5           2606    22399     CrmAdAccount3 CrmAdAccount3_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmAdAccount3"
    ADD CONSTRAINT "CrmAdAccount3_pkey" PRIMARY KEY ("AccountId", "TenantId");
 N   ALTER TABLE ONLY public."CrmAdAccount3" DROP CONSTRAINT "CrmAdAccount3_pkey";
       public            postgres    false    6184    401    401    401            �           2606    21371 0   CrmCalendarEventsType CrmCalendarEventsType_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."CrmCalendarEventsType"
    ADD CONSTRAINT "CrmCalendarEventsType_pkey" PRIMARY KEY ("TypeId");
 ^   ALTER TABLE ONLY public."CrmCalendarEventsType" DROP CONSTRAINT "CrmCalendarEventsType_pkey";
       public            postgres    false    233            �           2606    21373 (   CrmCalenderEvents CrmCalenderEvents_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."CrmCalenderEvents"
    ADD CONSTRAINT "CrmCalenderEvents_pkey" PRIMARY KEY ("EventId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCalenderEvents" DROP CONSTRAINT "CrmCalenderEvents_pkey";
       public            postgres    false    235    235            �           2606    21375 :   CrmCalenderEventsTenant100 CrmCalenderEventsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant100"
    ADD CONSTRAINT "CrmCalenderEventsTenant100_pkey" PRIMARY KEY ("EventId", "TenantId");
 h   ALTER TABLE ONLY public."CrmCalenderEventsTenant100" DROP CONSTRAINT "CrmCalenderEventsTenant100_pkey";
       public            postgres    false    238    238    5790    238            �           2606    21377 6   CrmCalenderEventsTenant1 CrmCalenderEventsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant1"
    ADD CONSTRAINT "CrmCalenderEventsTenant1_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant1" DROP CONSTRAINT "CrmCalenderEventsTenant1_pkey";
       public            postgres    false    237    237    5790    237            �           2606    21379 6   CrmCalenderEventsTenant2 CrmCalenderEventsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant2"
    ADD CONSTRAINT "CrmCalenderEventsTenant2_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant2" DROP CONSTRAINT "CrmCalenderEventsTenant2_pkey";
       public            postgres    false    239    239    239    5790            �           2606    21381 6   CrmCalenderEventsTenant3 CrmCalenderEventsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCalenderEventsTenant3"
    ADD CONSTRAINT "CrmCalenderEventsTenant3_pkey" PRIMARY KEY ("EventId", "TenantId");
 d   ALTER TABLE ONLY public."CrmCalenderEventsTenant3" DROP CONSTRAINT "CrmCalenderEventsTenant3_pkey";
       public            postgres    false    240    240    5790    240            �           2606    21383    CrmCall CrmCall_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmCall"
    ADD CONSTRAINT "CrmCall_pkey" PRIMARY KEY ("CallId", "TenantId");
 B   ALTER TABLE ONLY public."CrmCall" DROP CONSTRAINT "CrmCall_pkey";
       public            postgres    false    241    241            �           2606    21385    CrmCall100 CrmCall100_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CrmCall100"
    ADD CONSTRAINT "CrmCall100_pkey" PRIMARY KEY ("CallId", "TenantId");
 H   ALTER TABLE ONLY public."CrmCall100" DROP CONSTRAINT "CrmCall100_pkey";
       public            postgres    false    244    5805    244    244            �           2606    21387    CrmCall1 CrmCall1_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall1"
    ADD CONSTRAINT "CrmCall1_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall1" DROP CONSTRAINT "CrmCall1_pkey";
       public            postgres    false    243    5805    243    243            �           2606    21389    CrmCall2 CrmCall2_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall2"
    ADD CONSTRAINT "CrmCall2_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall2" DROP CONSTRAINT "CrmCall2_pkey";
       public            postgres    false    245    245    245    5805            �           2606    21391    CrmCall3 CrmCall3_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmCall3"
    ADD CONSTRAINT "CrmCall3_pkey" PRIMARY KEY ("CallId", "TenantId");
 D   ALTER TABLE ONLY public."CrmCall3" DROP CONSTRAINT "CrmCall3_pkey";
       public            postgres    false    246    246    5805    246            �           2606    21393 0   CrmCompanyActivityLog CrmCompanyActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLog"
    ADD CONSTRAINT "CrmCompanyActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCompanyActivityLog" DROP CONSTRAINT "CrmCompanyActivityLog_pkey";
       public            postgres    false    248    248            �           2606    21395 B   CrmCompanyActivityLogTenant100 CrmCompanyActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant100"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 p   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant100" DROP CONSTRAINT "CrmCompanyActivityLogTenant100_pkey";
       public            postgres    false    251    251    251    5823            �           2606    21397 >   CrmCompanyActivityLogTenant1 CrmCompanyActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant1"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant1" DROP CONSTRAINT "CrmCompanyActivityLogTenant1_pkey";
       public            postgres    false    250    250    250    5823            �           2606    21399 >   CrmCompanyActivityLogTenant2 CrmCompanyActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant2"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant2" DROP CONSTRAINT "CrmCompanyActivityLogTenant2_pkey";
       public            postgres    false    5823    252    252    252            �           2606    21401 >   CrmCompanyActivityLogTenant3 CrmCompanyActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant3"
    ADD CONSTRAINT "CrmCompanyActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 l   ALTER TABLE ONLY public."CrmCompanyActivityLogTenant3" DROP CONSTRAINT "CrmCompanyActivityLogTenant3_pkey";
       public            postgres    false    253    5823    253    253            �           2606    21403 &   CrmCompanyMember CrmCompanyMember_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."CrmCompanyMember"
    ADD CONSTRAINT "CrmCompanyMember_pkey" PRIMARY KEY ("MemberId", "TenantId");
 T   ALTER TABLE ONLY public."CrmCompanyMember" DROP CONSTRAINT "CrmCompanyMember_pkey";
       public            postgres    false    254    254            �           2606    21405 8   CrmCompanyMemberTenant100 CrmCompanyMemberTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant100"
    ADD CONSTRAINT "CrmCompanyMemberTenant100_pkey" PRIMARY KEY ("MemberId", "TenantId");
 f   ALTER TABLE ONLY public."CrmCompanyMemberTenant100" DROP CONSTRAINT "CrmCompanyMemberTenant100_pkey";
       public            postgres    false    257    257    5838    257            �           2606    21407 4   CrmCompanyMemberTenant1 CrmCompanyMemberTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant1"
    ADD CONSTRAINT "CrmCompanyMemberTenant1_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant1" DROP CONSTRAINT "CrmCompanyMemberTenant1_pkey";
       public            postgres    false    256    256    256    5838            �           2606    21409 4   CrmCompanyMemberTenant2 CrmCompanyMemberTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant2"
    ADD CONSTRAINT "CrmCompanyMemberTenant2_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant2" DROP CONSTRAINT "CrmCompanyMemberTenant2_pkey";
       public            postgres    false    5838    258    258    258            �           2606    21411 4   CrmCompanyMemberTenant3 CrmCompanyMemberTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyMemberTenant3"
    ADD CONSTRAINT "CrmCompanyMemberTenant3_pkey" PRIMARY KEY ("MemberId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCompanyMemberTenant3" DROP CONSTRAINT "CrmCompanyMemberTenant3_pkey";
       public            postgres    false    5838    259    259    259            �           2606    21413    CrmCompany CrmCompany_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmCompany"
    ADD CONSTRAINT "CrmCompany_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 H   ALTER TABLE ONLY public."CrmCompany" DROP CONSTRAINT "CrmCompany_pkey";
       public            postgres    false    247    247            �           2606    21415 ,   CrmCompanyTenant100 CrmCompanyTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCompanyTenant100"
    ADD CONSTRAINT "CrmCompanyTenant100_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmCompanyTenant100" DROP CONSTRAINT "CrmCompanyTenant100_pkey";
       public            postgres    false    262    5820    262    262            �           2606    21417 (   CrmCompanyTenant1 CrmCompanyTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant1"
    ADD CONSTRAINT "CrmCompanyTenant1_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant1" DROP CONSTRAINT "CrmCompanyTenant1_pkey";
       public            postgres    false    261    5820    261    261            �           2606    21419 (   CrmCompanyTenant2 CrmCompanyTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant2"
    ADD CONSTRAINT "CrmCompanyTenant2_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant2" DROP CONSTRAINT "CrmCompanyTenant2_pkey";
       public            postgres    false    263    263    5820    263            �           2606    21421 (   CrmCompanyTenant3 CrmCompanyTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmCompanyTenant3"
    ADD CONSTRAINT "CrmCompanyTenant3_pkey" PRIMARY KEY ("CompanyId", "TenantId");
 V   ALTER TABLE ONLY public."CrmCompanyTenant3" DROP CONSTRAINT "CrmCompanyTenant3_pkey";
       public            postgres    false    264    264    264    5820            �           2606    21423 "   CrmCustomLists CrmCustomLists_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmCustomLists"
    ADD CONSTRAINT "CrmCustomLists_pkey" PRIMARY KEY ("ListId", "TenantId");
 P   ALTER TABLE ONLY public."CrmCustomLists" DROP CONSTRAINT "CrmCustomLists_pkey";
       public            postgres    false    265    265            �           2606    21425 4   CrmCustomListsTenant100 CrmCustomListsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant100"
    ADD CONSTRAINT "CrmCustomListsTenant100_pkey" PRIMARY KEY ("ListId", "TenantId");
 b   ALTER TABLE ONLY public."CrmCustomListsTenant100" DROP CONSTRAINT "CrmCustomListsTenant100_pkey";
       public            postgres    false    268    5870    268    268            �           2606    21427 0   CrmCustomListsTenant1 CrmCustomListsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant1"
    ADD CONSTRAINT "CrmCustomListsTenant1_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant1" DROP CONSTRAINT "CrmCustomListsTenant1_pkey";
       public            postgres    false    267    267    267    5870            �           2606    21429 0   CrmCustomListsTenant2 CrmCustomListsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant2"
    ADD CONSTRAINT "CrmCustomListsTenant2_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant2" DROP CONSTRAINT "CrmCustomListsTenant2_pkey";
       public            postgres    false    269    5870    269    269            �           2606    21431 0   CrmCustomListsTenant3 CrmCustomListsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmCustomListsTenant3"
    ADD CONSTRAINT "CrmCustomListsTenant3_pkey" PRIMARY KEY ("ListId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmCustomListsTenant3" DROP CONSTRAINT "CrmCustomListsTenant3_pkey";
       public            postgres    false    270    270    5870    270            �           2606    21433    CrmEmail CrmEmail_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public."CrmEmail"
    ADD CONSTRAINT "CrmEmail_pkey" PRIMARY KEY ("EmailId", "TenantId");
 D   ALTER TABLE ONLY public."CrmEmail" DROP CONSTRAINT "CrmEmail_pkey";
       public            postgres    false    271    271                       2606    21435    CrmEmail100 CrmEmail100_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmEmail100"
    ADD CONSTRAINT "CrmEmail100_pkey" PRIMARY KEY ("EmailId", "TenantId");
 J   ALTER TABLE ONLY public."CrmEmail100" DROP CONSTRAINT "CrmEmail100_pkey";
       public            postgres    false    5885    274    274    274                       2606    21437    CrmEmail1 CrmEmail1_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail1"
    ADD CONSTRAINT "CrmEmail1_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail1" DROP CONSTRAINT "CrmEmail1_pkey";
       public            postgres    false    273    273    5885    273                       2606    21439    CrmEmail2 CrmEmail2_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail2"
    ADD CONSTRAINT "CrmEmail2_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail2" DROP CONSTRAINT "CrmEmail2_pkey";
       public            postgres    false    5885    275    275    275            
           2606    21441    CrmEmail3 CrmEmail3_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."CrmEmail3"
    ADD CONSTRAINT "CrmEmail3_pkey" PRIMARY KEY ("EmailId", "TenantId");
 F   ALTER TABLE ONLY public."CrmEmail3" DROP CONSTRAINT "CrmEmail3_pkey";
       public            postgres    false    276    5885    276    276                       2606    21443    CrmIndustry CrmIndustry_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmIndustry"
    ADD CONSTRAINT "CrmIndustry_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 J   ALTER TABLE ONLY public."CrmIndustry" DROP CONSTRAINT "CrmIndustry_pkey";
       public            postgres    false    277    277                       2606    21445 .   CrmIndustryTenant100 CrmIndustryTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant100"
    ADD CONSTRAINT "CrmIndustryTenant100_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 \   ALTER TABLE ONLY public."CrmIndustryTenant100" DROP CONSTRAINT "CrmIndustryTenant100_pkey";
       public            postgres    false    280    280    280    5900                       2606    21447 *   CrmIndustryTenant1 CrmIndustryTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant1"
    ADD CONSTRAINT "CrmIndustryTenant1_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant1" DROP CONSTRAINT "CrmIndustryTenant1_pkey";
       public            postgres    false    279    279    5900    279                       2606    21449 *   CrmIndustryTenant2 CrmIndustryTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant2"
    ADD CONSTRAINT "CrmIndustryTenant2_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant2" DROP CONSTRAINT "CrmIndustryTenant2_pkey";
       public            postgres    false    5900    281    281    281                       2606    21451 *   CrmIndustryTenant3 CrmIndustryTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmIndustryTenant3"
    ADD CONSTRAINT "CrmIndustryTenant3_pkey" PRIMARY KEY ("IndustryId", "TenantId");
 X   ALTER TABLE ONLY public."CrmIndustryTenant3" DROP CONSTRAINT "CrmIndustryTenant3_pkey";
       public            postgres    false    5900    282    282    282                       2606    21453 *   CrmLeadActivityLog CrmLeadActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLog"
    ADD CONSTRAINT "CrmLeadActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 X   ALTER TABLE ONLY public."CrmLeadActivityLog" DROP CONSTRAINT "CrmLeadActivityLog_pkey";
       public            postgres    false    284    284            %           2606    21455 <   CrmLeadActivityLogTenant100 CrmLeadActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant100"
    ADD CONSTRAINT "CrmLeadActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 j   ALTER TABLE ONLY public."CrmLeadActivityLogTenant100" DROP CONSTRAINT "CrmLeadActivityLogTenant100_pkey";
       public            postgres    false    287    287    5918    287            "           2606    21457 8   CrmLeadActivityLogTenant1 CrmLeadActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant1"
    ADD CONSTRAINT "CrmLeadActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant1" DROP CONSTRAINT "CrmLeadActivityLogTenant1_pkey";
       public            postgres    false    286    5918    286    286            (           2606    21459 8   CrmLeadActivityLogTenant2 CrmLeadActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant2"
    ADD CONSTRAINT "CrmLeadActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant2" DROP CONSTRAINT "CrmLeadActivityLogTenant2_pkey";
       public            postgres    false    288    288    5918    288            +           2606    21461 8   CrmLeadActivityLogTenant3 CrmLeadActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadActivityLogTenant3"
    ADD CONSTRAINT "CrmLeadActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmLeadActivityLogTenant3" DROP CONSTRAINT "CrmLeadActivityLogTenant3_pkey";
       public            postgres    false    289    289    289    5918            -           2606    21463     CrmLeadSource CrmLeadSource_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadSource"
    ADD CONSTRAINT "CrmLeadSource_pkey" PRIMARY KEY ("SourceId", "TenantId");
 N   ALTER TABLE ONLY public."CrmLeadSource" DROP CONSTRAINT "CrmLeadSource_pkey";
       public            postgres    false    290    290            4           2606    21465 2   CrmLeadSourceTenant100 CrmLeadSourceTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant100"
    ADD CONSTRAINT "CrmLeadSourceTenant100_pkey" PRIMARY KEY ("SourceId", "TenantId");
 `   ALTER TABLE ONLY public."CrmLeadSourceTenant100" DROP CONSTRAINT "CrmLeadSourceTenant100_pkey";
       public            postgres    false    293    5933    293    293            1           2606    21467 .   CrmLeadSourceTenant1 CrmLeadSourceTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant1"
    ADD CONSTRAINT "CrmLeadSourceTenant1_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant1" DROP CONSTRAINT "CrmLeadSourceTenant1_pkey";
       public            postgres    false    292    5933    292    292            7           2606    21469 .   CrmLeadSourceTenant2 CrmLeadSourceTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant2"
    ADD CONSTRAINT "CrmLeadSourceTenant2_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant2" DROP CONSTRAINT "CrmLeadSourceTenant2_pkey";
       public            postgres    false    5933    294    294    294            :           2606    21471 .   CrmLeadSourceTenant3 CrmLeadSourceTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadSourceTenant3"
    ADD CONSTRAINT "CrmLeadSourceTenant3_pkey" PRIMARY KEY ("SourceId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadSourceTenant3" DROP CONSTRAINT "CrmLeadSourceTenant3_pkey";
       public            postgres    false    295    295    5933    295            <           2606    21473     CrmLeadStatus CrmLeadStatus_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadStatus"
    ADD CONSTRAINT "CrmLeadStatus_pkey" PRIMARY KEY ("StatusId", "TenantId");
 N   ALTER TABLE ONLY public."CrmLeadStatus" DROP CONSTRAINT "CrmLeadStatus_pkey";
       public            postgres    false    296    296            C           2606    21475 2   CrmLeadStatusTenant100 CrmLeadStatusTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant100"
    ADD CONSTRAINT "CrmLeadStatusTenant100_pkey" PRIMARY KEY ("StatusId", "TenantId");
 `   ALTER TABLE ONLY public."CrmLeadStatusTenant100" DROP CONSTRAINT "CrmLeadStatusTenant100_pkey";
       public            postgres    false    299    299    5948    299            @           2606    21477 .   CrmLeadStatusTenant1 CrmLeadStatusTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant1"
    ADD CONSTRAINT "CrmLeadStatusTenant1_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant1" DROP CONSTRAINT "CrmLeadStatusTenant1_pkey";
       public            postgres    false    298    5948    298    298            F           2606    21479 .   CrmLeadStatusTenant2 CrmLeadStatusTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant2"
    ADD CONSTRAINT "CrmLeadStatusTenant2_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant2" DROP CONSTRAINT "CrmLeadStatusTenant2_pkey";
       public            postgres    false    300    300    300    5948            I           2606    21481 .   CrmLeadStatusTenant3 CrmLeadStatusTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmLeadStatusTenant3"
    ADD CONSTRAINT "CrmLeadStatusTenant3_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmLeadStatusTenant3" DROP CONSTRAINT "CrmLeadStatusTenant3_pkey";
       public            postgres    false    301    301    301    5948                       2606    21483    CrmLead CrmLead_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmLead"
    ADD CONSTRAINT "CrmLead_pkey" PRIMARY KEY ("LeadId", "TenantId");
 B   ALTER TABLE ONLY public."CrmLead" DROP CONSTRAINT "CrmLead_pkey";
       public            postgres    false    283    283            O           2606    21485 &   CrmLeadTenant100 CrmLeadTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmLeadTenant100"
    ADD CONSTRAINT "CrmLeadTenant100_pkey" PRIMARY KEY ("LeadId", "TenantId");
 T   ALTER TABLE ONLY public."CrmLeadTenant100" DROP CONSTRAINT "CrmLeadTenant100_pkey";
       public            postgres    false    304    5915    304    304            L           2606    21487 "   CrmLeadTenant1 CrmLeadTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant1"
    ADD CONSTRAINT "CrmLeadTenant1_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant1" DROP CONSTRAINT "CrmLeadTenant1_pkey";
       public            postgres    false    303    303    5915    303            R           2606    21489 "   CrmLeadTenant2 CrmLeadTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant2"
    ADD CONSTRAINT "CrmLeadTenant2_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant2" DROP CONSTRAINT "CrmLeadTenant2_pkey";
       public            postgres    false    305    305    305    5915            U           2606    21491 "   CrmLeadTenant3 CrmLeadTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmLeadTenant3"
    ADD CONSTRAINT "CrmLeadTenant3_pkey" PRIMARY KEY ("LeadId", "TenantId");
 P   ALTER TABLE ONLY public."CrmLeadTenant3" DROP CONSTRAINT "CrmLeadTenant3_pkey";
       public            postgres    false    306    306    306    5915            W           2606    21493    CrmMeeting CrmMeeting_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmMeeting"
    ADD CONSTRAINT "CrmMeeting_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 H   ALTER TABLE ONLY public."CrmMeeting" DROP CONSTRAINT "CrmMeeting_pkey";
       public            postgres    false    307    307            ^           2606    21495     CrmMeeting100 CrmMeeting100_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."CrmMeeting100"
    ADD CONSTRAINT "CrmMeeting100_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 N   ALTER TABLE ONLY public."CrmMeeting100" DROP CONSTRAINT "CrmMeeting100_pkey";
       public            postgres    false    310    310    310    5975            [           2606    21497    CrmMeeting1 CrmMeeting1_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting1"
    ADD CONSTRAINT "CrmMeeting1_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting1" DROP CONSTRAINT "CrmMeeting1_pkey";
       public            postgres    false    309    5975    309    309            a           2606    21499    CrmMeeting2 CrmMeeting2_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting2"
    ADD CONSTRAINT "CrmMeeting2_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting2" DROP CONSTRAINT "CrmMeeting2_pkey";
       public            postgres    false    311    311    5975    311            d           2606    21501    CrmMeeting3 CrmMeeting3_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public."CrmMeeting3"
    ADD CONSTRAINT "CrmMeeting3_pkey" PRIMARY KEY ("MeetingId", "TenantId");
 J   ALTER TABLE ONLY public."CrmMeeting3" DROP CONSTRAINT "CrmMeeting3_pkey";
       public            postgres    false    5975    312    312    312            i           2606    21503    CrmNoteTags CrmNoteTags_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmNoteTags"
    ADD CONSTRAINT "CrmNoteTags_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 J   ALTER TABLE ONLY public."CrmNoteTags" DROP CONSTRAINT "CrmNoteTags_pkey";
       public            postgres    false    314    314            p           2606    21505 .   CrmNoteTagsTenant100 CrmNoteTagsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant100"
    ADD CONSTRAINT "CrmNoteTagsTenant100_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 \   ALTER TABLE ONLY public."CrmNoteTagsTenant100" DROP CONSTRAINT "CrmNoteTagsTenant100_pkey";
       public            postgres    false    5993    317    317    317            m           2606    21507 *   CrmNoteTagsTenant1 CrmNoteTagsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant1"
    ADD CONSTRAINT "CrmNoteTagsTenant1_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant1" DROP CONSTRAINT "CrmNoteTagsTenant1_pkey";
       public            postgres    false    316    316    5993    316            s           2606    21509 *   CrmNoteTagsTenant2 CrmNoteTagsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant2"
    ADD CONSTRAINT "CrmNoteTagsTenant2_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant2" DROP CONSTRAINT "CrmNoteTagsTenant2_pkey";
       public            postgres    false    5993    318    318    318            v           2606    21511 *   CrmNoteTagsTenant3 CrmNoteTagsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTagsTenant3"
    ADD CONSTRAINT "CrmNoteTagsTenant3_pkey" PRIMARY KEY ("NoteTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmNoteTagsTenant3" DROP CONSTRAINT "CrmNoteTagsTenant3_pkey";
       public            postgres    false    319    319    5993    319            x           2606    21513    CrmNoteTasks CrmNoteTasks_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTasks"
    ADD CONSTRAINT "CrmNoteTasks_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 L   ALTER TABLE ONLY public."CrmNoteTasks" DROP CONSTRAINT "CrmNoteTasks_pkey";
       public            postgres    false    320    320                       2606    21515 0   CrmNoteTasksTenant100 CrmNoteTasksTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant100"
    ADD CONSTRAINT "CrmNoteTasksTenant100_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 ^   ALTER TABLE ONLY public."CrmNoteTasksTenant100" DROP CONSTRAINT "CrmNoteTasksTenant100_pkey";
       public            postgres    false    323    323    6008    323            |           2606    21517 ,   CrmNoteTasksTenant1 CrmNoteTasksTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant1"
    ADD CONSTRAINT "CrmNoteTasksTenant1_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant1" DROP CONSTRAINT "CrmNoteTasksTenant1_pkey";
       public            postgres    false    6008    322    322    322            �           2606    21519 ,   CrmNoteTasksTenant2 CrmNoteTasksTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant2"
    ADD CONSTRAINT "CrmNoteTasksTenant2_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant2" DROP CONSTRAINT "CrmNoteTasksTenant2_pkey";
       public            postgres    false    324    6008    324    324            �           2606    21521 ,   CrmNoteTasksTenant3 CrmNoteTasksTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmNoteTasksTenant3"
    ADD CONSTRAINT "CrmNoteTasksTenant3_pkey" PRIMARY KEY ("NoteTaskId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmNoteTasksTenant3" DROP CONSTRAINT "CrmNoteTasksTenant3_pkey";
       public            postgres    false    325    325    325    6008            f           2606    21523    CrmNote CrmNote_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmNote"
    ADD CONSTRAINT "CrmNote_pkey" PRIMARY KEY ("NoteId", "TenantId");
 B   ALTER TABLE ONLY public."CrmNote" DROP CONSTRAINT "CrmNote_pkey";
       public            postgres    false    313    313            �           2606    21525 &   CrmNoteTenant100 CrmNoteTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmNoteTenant100"
    ADD CONSTRAINT "CrmNoteTenant100_pkey" PRIMARY KEY ("NoteId", "TenantId");
 T   ALTER TABLE ONLY public."CrmNoteTenant100" DROP CONSTRAINT "CrmNoteTenant100_pkey";
       public            postgres    false    5990    328    328    328            �           2606    21527 "   CrmNoteTenant1 CrmNoteTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant1"
    ADD CONSTRAINT "CrmNoteTenant1_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant1" DROP CONSTRAINT "CrmNoteTenant1_pkey";
       public            postgres    false    327    5990    327    327            �           2606    21529 "   CrmNoteTenant2 CrmNoteTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant2"
    ADD CONSTRAINT "CrmNoteTenant2_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant2" DROP CONSTRAINT "CrmNoteTenant2_pkey";
       public            postgres    false    5990    329    329    329            �           2606    21531 "   CrmNoteTenant3 CrmNoteTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmNoteTenant3"
    ADD CONSTRAINT "CrmNoteTenant3_pkey" PRIMARY KEY ("NoteId", "TenantId");
 P   ALTER TABLE ONLY public."CrmNoteTenant3" DROP CONSTRAINT "CrmNoteTenant3_pkey";
       public            postgres    false    330    330    330    5990                       2606    22261 "   CrmOpportunity CrmOpportunity_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."CrmOpportunity"
    ADD CONSTRAINT "CrmOpportunity_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 P   ALTER TABLE ONLY public."CrmOpportunity" DROP CONSTRAINT "CrmOpportunity_pkey";
       public            postgres    false    387    387            "           2606    22299 (   CrmOpportunity100 CrmOpportunity100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmOpportunity100"
    ADD CONSTRAINT "CrmOpportunity100_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 V   ALTER TABLE ONLY public."CrmOpportunity100" DROP CONSTRAINT "CrmOpportunity100_pkey";
       public            postgres    false    6165    391    391    391                       2606    22269 $   CrmOpportunity1 CrmOpportunity1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity1"
    ADD CONSTRAINT "CrmOpportunity1_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity1" DROP CONSTRAINT "CrmOpportunity1_pkey";
       public            postgres    false    6165    388    388    388                       2606    22279 $   CrmOpportunity2 CrmOpportunity2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity2"
    ADD CONSTRAINT "CrmOpportunity2_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity2" DROP CONSTRAINT "CrmOpportunity2_pkey";
       public            postgres    false    389    389    389    6165                       2606    22289 $   CrmOpportunity3 CrmOpportunity3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmOpportunity3"
    ADD CONSTRAINT "CrmOpportunity3_pkey" PRIMARY KEY ("OpportunityId", "TenantId");
 R   ALTER TABLE ONLY public."CrmOpportunity3" DROP CONSTRAINT "CrmOpportunity3_pkey";
       public            postgres    false    390    390    390    6165            &           2606    22340 .   CrmOpportunitySource CrmOpportunitySource_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."CrmOpportunitySource"
    ADD CONSTRAINT "CrmOpportunitySource_pkey" PRIMARY KEY ("SourceId");
 \   ALTER TABLE ONLY public."CrmOpportunitySource" DROP CONSTRAINT "CrmOpportunitySource_pkey";
       public            postgres    false    395            $           2606    22317 .   CrmOpportunityStatus CrmOpportunityStatus_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmOpportunityStatus"
    ADD CONSTRAINT "CrmOpportunityStatus_pkey" PRIMARY KEY ("StatusId", "TenantId");
 \   ALTER TABLE ONLY public."CrmOpportunityStatus" DROP CONSTRAINT "CrmOpportunityStatus_pkey";
       public            postgres    false    393    393            �           2606    21533    CrmProduct CrmProduct_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmProduct"
    ADD CONSTRAINT "CrmProduct_pkey" PRIMARY KEY ("ProductId", "TenantId");
 H   ALTER TABLE ONLY public."CrmProduct" DROP CONSTRAINT "CrmProduct_pkey";
       public            postgres    false    331    331            �           2606    21535 ,   CrmProductTenant100 CrmProductTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmProductTenant100"
    ADD CONSTRAINT "CrmProductTenant100_pkey" PRIMARY KEY ("ProductId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmProductTenant100" DROP CONSTRAINT "CrmProductTenant100_pkey";
       public            postgres    false    6035    334    334    334            �           2606    21537 (   CrmProductTenant1 CrmProductTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant1"
    ADD CONSTRAINT "CrmProductTenant1_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant1" DROP CONSTRAINT "CrmProductTenant1_pkey";
       public            postgres    false    333    6035    333    333            �           2606    21539 (   CrmProductTenant2 CrmProductTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant2"
    ADD CONSTRAINT "CrmProductTenant2_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant2" DROP CONSTRAINT "CrmProductTenant2_pkey";
       public            postgres    false    335    335    335    6035            �           2606    21541 (   CrmProductTenant3 CrmProductTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmProductTenant3"
    ADD CONSTRAINT "CrmProductTenant3_pkey" PRIMARY KEY ("ProductId", "TenantId");
 V   ALTER TABLE ONLY public."CrmProductTenant3" DROP CONSTRAINT "CrmProductTenant3_pkey";
       public            postgres    false    336    6035    336    336            �           2606    21543    CrmTagUsed CrmTagUsed_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."CrmTagUsed"
    ADD CONSTRAINT "CrmTagUsed_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 H   ALTER TABLE ONLY public."CrmTagUsed" DROP CONSTRAINT "CrmTagUsed_pkey";
       public            postgres    false    337    337            �           2606    21545 ,   CrmTagUsedTenant100 CrmTagUsedTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTagUsedTenant100"
    ADD CONSTRAINT "CrmTagUsedTenant100_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 Z   ALTER TABLE ONLY public."CrmTagUsedTenant100" DROP CONSTRAINT "CrmTagUsedTenant100_pkey";
       public            postgres    false    340    340    6050    340            �           2606    21547 (   CrmTagUsedTenant1 CrmTagUsedTenant1_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant1"
    ADD CONSTRAINT "CrmTagUsedTenant1_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant1" DROP CONSTRAINT "CrmTagUsedTenant1_pkey";
       public            postgres    false    339    6050    339    339            �           2606    21549 (   CrmTagUsedTenant2 CrmTagUsedTenant2_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant2"
    ADD CONSTRAINT "CrmTagUsedTenant2_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant2" DROP CONSTRAINT "CrmTagUsedTenant2_pkey";
       public            postgres    false    6050    341    341    341            �           2606    21551 (   CrmTagUsedTenant3 CrmTagUsedTenant3_pkey 
   CONSTRAINT        ALTER TABLE ONLY public."CrmTagUsedTenant3"
    ADD CONSTRAINT "CrmTagUsedTenant3_pkey" PRIMARY KEY ("TagUsedId", "TenantId");
 V   ALTER TABLE ONLY public."CrmTagUsedTenant3" DROP CONSTRAINT "CrmTagUsedTenant3_pkey";
       public            postgres    false    342    342    6050    342            �           2606    21553    CrmTags CrmTags_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."CrmTags"
    ADD CONSTRAINT "CrmTags_pkey" PRIMARY KEY ("TagId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTags" DROP CONSTRAINT "CrmTags_pkey";
       public            postgres    false    343    343            �           2606    21555 &   CrmTagsTenant100 CrmTagsTenant100_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public."CrmTagsTenant100"
    ADD CONSTRAINT "CrmTagsTenant100_pkey" PRIMARY KEY ("TagId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTagsTenant100" DROP CONSTRAINT "CrmTagsTenant100_pkey";
       public            postgres    false    6065    346    346    346            �           2606    21557 "   CrmTagsTenant1 CrmTagsTenant1_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant1"
    ADD CONSTRAINT "CrmTagsTenant1_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant1" DROP CONSTRAINT "CrmTagsTenant1_pkey";
       public            postgres    false    345    345    6065    345            �           2606    21559 "   CrmTagsTenant2 CrmTagsTenant2_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant2"
    ADD CONSTRAINT "CrmTagsTenant2_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant2" DROP CONSTRAINT "CrmTagsTenant2_pkey";
       public            postgres    false    347    347    347    6065            �           2606    21561 "   CrmTagsTenant3 CrmTagsTenant3_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CrmTagsTenant3"
    ADD CONSTRAINT "CrmTagsTenant3_pkey" PRIMARY KEY ("TagId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTagsTenant3" DROP CONSTRAINT "CrmTagsTenant3_pkey";
       public            postgres    false    6065    348    348    348            �           2606    21563 $   CrmTaskPriority CrmTaskPriority_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."CrmTaskPriority"
    ADD CONSTRAINT "CrmTaskPriority_pkey" PRIMARY KEY ("PriorityId");
 R   ALTER TABLE ONLY public."CrmTaskPriority" DROP CONSTRAINT "CrmTaskPriority_pkey";
       public            postgres    false    350            �           2606    21565     CrmTaskStatus CrmTaskStatus_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."CrmTaskStatus"
    ADD CONSTRAINT "CrmTaskStatus_pkey" PRIMARY KEY ("StatusId");
 N   ALTER TABLE ONLY public."CrmTaskStatus" DROP CONSTRAINT "CrmTaskStatus_pkey";
       public            postgres    false    352            �           2606    21567    CrmTaskTags CrmTaskTags_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CrmTaskTags"
    ADD CONSTRAINT "CrmTaskTags_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 J   ALTER TABLE ONLY public."CrmTaskTags" DROP CONSTRAINT "CrmTaskTags_pkey";
       public            postgres    false    354    354            �           2606    21569 .   CrmTaskTagsTenant100 CrmTaskTagsTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant100"
    ADD CONSTRAINT "CrmTaskTagsTenant100_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTaskTagsTenant100" DROP CONSTRAINT "CrmTaskTagsTenant100_pkey";
       public            postgres    false    357    357    6088    357            �           2606    21571 *   CrmTaskTagsTenant1 CrmTaskTagsTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant1"
    ADD CONSTRAINT "CrmTaskTagsTenant1_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant1" DROP CONSTRAINT "CrmTaskTagsTenant1_pkey";
       public            postgres    false    356    356    6088    356            �           2606    21573 *   CrmTaskTagsTenant2 CrmTaskTagsTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant2"
    ADD CONSTRAINT "CrmTaskTagsTenant2_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant2" DROP CONSTRAINT "CrmTaskTagsTenant2_pkey";
       public            postgres    false    358    6088    358    358            �           2606    21575 *   CrmTaskTagsTenant3 CrmTaskTagsTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTaskTagsTenant3"
    ADD CONSTRAINT "CrmTaskTagsTenant3_pkey" PRIMARY KEY ("TaskTagsId", "TenantId");
 X   ALTER TABLE ONLY public."CrmTaskTagsTenant3" DROP CONSTRAINT "CrmTaskTagsTenant3_pkey";
       public            postgres    false    6088    359    359    359            �           2606    21577    CrmTask CrmTask_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmTask"
    ADD CONSTRAINT "CrmTask_pkey" PRIMARY KEY ("TaskId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTask" DROP CONSTRAINT "CrmTask_pkey";
       public            postgres    false    349    349            �           2606    21579 &   CrmTaskTenant100 CrmTaskTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTaskTenant100"
    ADD CONSTRAINT "CrmTaskTenant100_pkey" PRIMARY KEY ("TaskId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTaskTenant100" DROP CONSTRAINT "CrmTaskTenant100_pkey";
       public            postgres    false    362    362    362    6080            �           2606    21581 "   CrmTaskTenant1 CrmTaskTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant1"
    ADD CONSTRAINT "CrmTaskTenant1_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant1" DROP CONSTRAINT "CrmTaskTenant1_pkey";
       public            postgres    false    361    361    6080    361            �           2606    21583 "   CrmTaskTenant2 CrmTaskTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant2"
    ADD CONSTRAINT "CrmTaskTenant2_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant2" DROP CONSTRAINT "CrmTaskTenant2_pkey";
       public            postgres    false    6080    363    363    363            �           2606    21585 "   CrmTaskTenant3 CrmTaskTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTaskTenant3"
    ADD CONSTRAINT "CrmTaskTenant3_pkey" PRIMARY KEY ("TaskId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTaskTenant3" DROP CONSTRAINT "CrmTaskTenant3_pkey";
       public            postgres    false    364    364    6080    364            �           2606    21587     CrmTeamMember CrmTeamMember_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTeamMember"
    ADD CONSTRAINT "CrmTeamMember_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 N   ALTER TABLE ONLY public."CrmTeamMember" DROP CONSTRAINT "CrmTeamMember_pkey";
       public            postgres    false    366    366            �           2606    21589 2   CrmTeamMemberTenant100 CrmTeamMemberTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant100"
    ADD CONSTRAINT "CrmTeamMemberTenant100_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 `   ALTER TABLE ONLY public."CrmTeamMemberTenant100" DROP CONSTRAINT "CrmTeamMemberTenant100_pkey";
       public            postgres    false    6118    369    369    369            �           2606    21591 .   CrmTeamMemberTenant1 CrmTeamMemberTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant1"
    ADD CONSTRAINT "CrmTeamMemberTenant1_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant1" DROP CONSTRAINT "CrmTeamMemberTenant1_pkey";
       public            postgres    false    368    6118    368    368            �           2606    21593 .   CrmTeamMemberTenant2 CrmTeamMemberTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant2"
    ADD CONSTRAINT "CrmTeamMemberTenant2_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant2" DROP CONSTRAINT "CrmTeamMemberTenant2_pkey";
       public            postgres    false    370    6118    370    370            �           2606    21595 .   CrmTeamMemberTenant3 CrmTeamMemberTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmTeamMemberTenant3"
    ADD CONSTRAINT "CrmTeamMemberTenant3_pkey" PRIMARY KEY ("TeamMemberId", "TenantId");
 \   ALTER TABLE ONLY public."CrmTeamMemberTenant3" DROP CONSTRAINT "CrmTeamMemberTenant3_pkey";
       public            postgres    false    371    371    371    6118            �           2606    21597    CrmTeam CrmTeam_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CrmTeam"
    ADD CONSTRAINT "CrmTeam_pkey" PRIMARY KEY ("TeamId", "TenantId");
 B   ALTER TABLE ONLY public."CrmTeam" DROP CONSTRAINT "CrmTeam_pkey";
       public            postgres    false    365    365            �           2606    21599 &   CrmTeamTenant100 CrmTeamTenant100_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."CrmTeamTenant100"
    ADD CONSTRAINT "CrmTeamTenant100_pkey" PRIMARY KEY ("TeamId", "TenantId");
 T   ALTER TABLE ONLY public."CrmTeamTenant100" DROP CONSTRAINT "CrmTeamTenant100_pkey";
       public            postgres    false    374    374    374    6115            �           2606    21601 "   CrmTeamTenant1 CrmTeamTenant1_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant1"
    ADD CONSTRAINT "CrmTeamTenant1_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant1" DROP CONSTRAINT "CrmTeamTenant1_pkey";
       public            postgres    false    373    6115    373    373            �           2606    21603 "   CrmTeamTenant2 CrmTeamTenant2_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant2"
    ADD CONSTRAINT "CrmTeamTenant2_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant2" DROP CONSTRAINT "CrmTeamTenant2_pkey";
       public            postgres    false    375    375    375    6115            �           2606    21605 "   CrmTeamTenant3 CrmTeamTenant3_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."CrmTeamTenant3"
    ADD CONSTRAINT "CrmTeamTenant3_pkey" PRIMARY KEY ("TeamId", "TenantId");
 P   ALTER TABLE ONLY public."CrmTeamTenant3" DROP CONSTRAINT "CrmTeamTenant3_pkey";
       public            postgres    false    376    376    376    6115                       2606    21607 *   CrmUserActivityLog CrmUserActivityLog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLog"
    ADD CONSTRAINT "CrmUserActivityLog_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 X   ALTER TABLE ONLY public."CrmUserActivityLog" DROP CONSTRAINT "CrmUserActivityLog_pkey";
       public            postgres    false    377    377                       2606    21609 <   CrmUserActivityLogTenant100 CrmUserActivityLogTenant100_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant100"
    ADD CONSTRAINT "CrmUserActivityLogTenant100_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 j   ALTER TABLE ONLY public."CrmUserActivityLogTenant100" DROP CONSTRAINT "CrmUserActivityLogTenant100_pkey";
       public            postgres    false    380    380    380    6145                       2606    21611 8   CrmUserActivityLogTenant1 CrmUserActivityLogTenant1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant1"
    ADD CONSTRAINT "CrmUserActivityLogTenant1_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant1" DROP CONSTRAINT "CrmUserActivityLogTenant1_pkey";
       public            postgres    false    379    6145    379    379                       2606    21613 8   CrmUserActivityLogTenant2 CrmUserActivityLogTenant2_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant2"
    ADD CONSTRAINT "CrmUserActivityLogTenant2_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant2" DROP CONSTRAINT "CrmUserActivityLogTenant2_pkey";
       public            postgres    false    381    6145    381    381                       2606    21615 8   CrmUserActivityLogTenant3 CrmUserActivityLogTenant3_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CrmUserActivityLogTenant3"
    ADD CONSTRAINT "CrmUserActivityLogTenant3_pkey" PRIMARY KEY ("ActivityId", "TenantId");
 f   ALTER TABLE ONLY public."CrmUserActivityLogTenant3" DROP CONSTRAINT "CrmUserActivityLogTenant3_pkey";
       public            postgres    false    382    382    6145    382                       2606    21617 ,   CrmUserActivityType CrmUserActivityType_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."CrmUserActivityType"
    ADD CONSTRAINT "CrmUserActivityType_pkey" PRIMARY KEY ("ActivityTypeId");
 Z   ALTER TABLE ONLY public."CrmUserActivityType" DROP CONSTRAINT "CrmUserActivityType_pkey";
       public            postgres    false    383                       2606    21619    Tenant Tenant_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public."Tenant"
    ADD CONSTRAINT "Tenant_pkey" PRIMARY KEY ("TenantId");
 @   ALTER TABLE ONLY public."Tenant" DROP CONSTRAINT "Tenant_pkey";
       public            postgres    false    385            �           2606    21621    AppMenus appmenu_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."AppMenus"
    ADD CONSTRAINT appmenu_pkey PRIMARY KEY ("MenuId");
 A   ALTER TABLE ONLY public."AppMenus" DROP CONSTRAINT appmenu_pkey;
       public            postgres    false    231            )           1259    22358    idx_AccountId    INDEX     V   CREATE INDEX "idx_AccountId" ON ONLY public."CrmAdAccount" USING btree ("AccountId");
 #   DROP INDEX public."idx_AccountId";
       public            postgres    false    397            -           1259    22378    CrmAdAccount100_AccountId_idx    INDEX     d   CREATE INDEX "CrmAdAccount100_AccountId_idx" ON public."CrmAdAccount100" USING btree ("AccountId");
 3   DROP INDEX public."CrmAdAccount100_AccountId_idx";
       public            postgres    false    399    399    6185            *           1259    22367    CrmAdAccount1_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount1_AccountId_idx" ON public."CrmAdAccount1" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount1_AccountId_idx";
       public            postgres    false    6185    398    398            0           1259    22389    CrmAdAccount2_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount2_AccountId_idx" ON public."CrmAdAccount2" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount2_AccountId_idx";
       public            postgres    false    400    400    6185            3           1259    22400    CrmAdAccount3_AccountId_idx    INDEX     `   CREATE INDEX "CrmAdAccount3_AccountId_idx" ON public."CrmAdAccount3" USING btree ("AccountId");
 1   DROP INDEX public."CrmAdAccount3_AccountId_idx";
       public            postgres    false    401    6185    401            �           1259    21622    idx_crmcalenderevents_eventid    INDEX     g   CREATE INDEX idx_crmcalenderevents_eventid ON ONLY public."CrmCalenderEvents" USING btree ("EventId");
 1   DROP INDEX public.idx_crmcalenderevents_eventid;
       public            postgres    false    235            �           1259    21623 &   CrmCalenderEventsTenant100_EventId_idx    INDEX     v   CREATE INDEX "CrmCalenderEventsTenant100_EventId_idx" ON public."CrmCalenderEventsTenant100" USING btree ("EventId");
 <   DROP INDEX public."CrmCalenderEventsTenant100_EventId_idx";
       public            postgres    false    238    238    5791            �           1259    21624 $   CrmCalenderEventsTenant1_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant1_EventId_idx" ON public."CrmCalenderEventsTenant1" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant1_EventId_idx";
       public            postgres    false    237    5791    237            �           1259    21625 $   CrmCalenderEventsTenant2_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant2_EventId_idx" ON public."CrmCalenderEventsTenant2" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant2_EventId_idx";
       public            postgres    false    239    5791    239            �           1259    21626 $   CrmCalenderEventsTenant3_EventId_idx    INDEX     r   CREATE INDEX "CrmCalenderEventsTenant3_EventId_idx" ON public."CrmCalenderEventsTenant3" USING btree ("EventId");
 :   DROP INDEX public."CrmCalenderEventsTenant3_EventId_idx";
       public            postgres    false    5791    240    240            �           1259    21627 
   idx_CallId    INDEX     K   CREATE INDEX "idx_CallId" ON ONLY public."CrmCall" USING btree ("CallId");
     DROP INDEX public."idx_CallId";
       public            postgres    false    241            �           1259    21628    CrmCall100_CallId_idx    INDEX     T   CREATE INDEX "CrmCall100_CallId_idx" ON public."CrmCall100" USING btree ("CallId");
 +   DROP INDEX public."CrmCall100_CallId_idx";
       public            postgres    false    244    244    5806            �           1259    21629    CrmCall1_CallId_idx    INDEX     P   CREATE INDEX "CrmCall1_CallId_idx" ON public."CrmCall1" USING btree ("CallId");
 )   DROP INDEX public."CrmCall1_CallId_idx";
       public            postgres    false    243    243    5806            �           1259    21630    CrmCall2_CallId_idx    INDEX     P   CREATE INDEX "CrmCall2_CallId_idx" ON public."CrmCall2" USING btree ("CallId");
 )   DROP INDEX public."CrmCall2_CallId_idx";
       public            postgres    false    245    245    5806            �           1259    21631    CrmCall3_CallId_idx    INDEX     P   CREATE INDEX "CrmCall3_CallId_idx" ON public."CrmCall3" USING btree ("CallId");
 )   DROP INDEX public."CrmCall3_CallId_idx";
       public            postgres    false    5806    246    246            �           1259    21632 $   idx_crmcompanyactivitylog_activityid    INDEX     u   CREATE INDEX idx_crmcompanyactivitylog_activityid ON ONLY public."CrmCompanyActivityLog" USING btree ("ActivityId");
 8   DROP INDEX public.idx_crmcompanyactivitylog_activityid;
       public            postgres    false    248            �           1259    21633 -   CrmCompanyActivityLogTenant100_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant100_ActivityId_idx" ON public."CrmCompanyActivityLogTenant100" USING btree ("ActivityId");
 C   DROP INDEX public."CrmCompanyActivityLogTenant100_ActivityId_idx";
       public            postgres    false    251    5824    251            �           1259    21634 +   CrmCompanyActivityLogTenant1_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant1_ActivityId_idx" ON public."CrmCompanyActivityLogTenant1" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant1_ActivityId_idx";
       public            postgres    false    5824    250    250            �           1259    21635 +   CrmCompanyActivityLogTenant2_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant2_ActivityId_idx" ON public."CrmCompanyActivityLogTenant2" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant2_ActivityId_idx";
       public            postgres    false    252    5824    252            �           1259    21636 +   CrmCompanyActivityLogTenant3_ActivityId_idx    INDEX     �   CREATE INDEX "CrmCompanyActivityLogTenant3_ActivityId_idx" ON public."CrmCompanyActivityLogTenant3" USING btree ("ActivityId");
 A   DROP INDEX public."CrmCompanyActivityLogTenant3_ActivityId_idx";
       public            postgres    false    253    5824    253            �           1259    21637    idx_crmcompanymember_companyid    INDEX     i   CREATE INDEX idx_crmcompanymember_companyid ON ONLY public."CrmCompanyMember" USING btree ("CompanyId");
 2   DROP INDEX public.idx_crmcompanymember_companyid;
       public            postgres    false    254            �           1259    21638 '   CrmCompanyMemberTenant100_CompanyId_idx    INDEX     x   CREATE INDEX "CrmCompanyMemberTenant100_CompanyId_idx" ON public."CrmCompanyMemberTenant100" USING btree ("CompanyId");
 =   DROP INDEX public."CrmCompanyMemberTenant100_CompanyId_idx";
       public            postgres    false    5839    257    257            �           1259    21639    idx_crmcompanymember_memberid    INDEX     g   CREATE INDEX idx_crmcompanymember_memberid ON ONLY public."CrmCompanyMember" USING btree ("MemberId");
 1   DROP INDEX public.idx_crmcompanymember_memberid;
       public            postgres    false    254            �           1259    21640 &   CrmCompanyMemberTenant100_MemberId_idx    INDEX     v   CREATE INDEX "CrmCompanyMemberTenant100_MemberId_idx" ON public."CrmCompanyMemberTenant100" USING btree ("MemberId");
 <   DROP INDEX public."CrmCompanyMemberTenant100_MemberId_idx";
       public            postgres    false    257    5840    257            �           1259    21641 %   CrmCompanyMemberTenant1_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant1_CompanyId_idx" ON public."CrmCompanyMemberTenant1" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant1_CompanyId_idx";
       public            postgres    false    5839    256    256            �           1259    21642 $   CrmCompanyMemberTenant1_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant1_MemberId_idx" ON public."CrmCompanyMemberTenant1" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant1_MemberId_idx";
       public            postgres    false    256    5840    256            �           1259    21643 %   CrmCompanyMemberTenant2_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant2_CompanyId_idx" ON public."CrmCompanyMemberTenant2" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant2_CompanyId_idx";
       public            postgres    false    258    258    5839            �           1259    21644 $   CrmCompanyMemberTenant2_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant2_MemberId_idx" ON public."CrmCompanyMemberTenant2" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant2_MemberId_idx";
       public            postgres    false    258    258    5840            �           1259    21645 %   CrmCompanyMemberTenant3_CompanyId_idx    INDEX     t   CREATE INDEX "CrmCompanyMemberTenant3_CompanyId_idx" ON public."CrmCompanyMemberTenant3" USING btree ("CompanyId");
 ;   DROP INDEX public."CrmCompanyMemberTenant3_CompanyId_idx";
       public            postgres    false    259    259    5839            �           1259    21646 $   CrmCompanyMemberTenant3_MemberId_idx    INDEX     r   CREATE INDEX "CrmCompanyMemberTenant3_MemberId_idx" ON public."CrmCompanyMemberTenant3" USING btree ("MemberId");
 :   DROP INDEX public."CrmCompanyMemberTenant3_MemberId_idx";
       public            postgres    false    259    5840    259            �           1259    21647    idx_crmcompany_companyid    INDEX     ]   CREATE INDEX idx_crmcompany_companyid ON ONLY public."CrmCompany" USING btree ("CompanyId");
 ,   DROP INDEX public.idx_crmcompany_companyid;
       public            postgres    false    247            �           1259    21648 !   CrmCompanyTenant100_CompanyId_idx    INDEX     l   CREATE INDEX "CrmCompanyTenant100_CompanyId_idx" ON public."CrmCompanyTenant100" USING btree ("CompanyId");
 7   DROP INDEX public."CrmCompanyTenant100_CompanyId_idx";
       public            postgres    false    262    262    5821            �           1259    21649    CrmCompanyTenant1_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant1_CompanyId_idx" ON public."CrmCompanyTenant1" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant1_CompanyId_idx";
       public            postgres    false    261    5821    261            �           1259    21650    CrmCompanyTenant2_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant2_CompanyId_idx" ON public."CrmCompanyTenant2" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant2_CompanyId_idx";
       public            postgres    false    263    5821    263            �           1259    21651    CrmCompanyTenant3_CompanyId_idx    INDEX     h   CREATE INDEX "CrmCompanyTenant3_CompanyId_idx" ON public."CrmCompanyTenant3" USING btree ("CompanyId");
 5   DROP INDEX public."CrmCompanyTenant3_CompanyId_idx";
       public            postgres    false    264    264    5821            �           1259    21652 
   idx_ListId    INDEX     R   CREATE INDEX "idx_ListId" ON ONLY public."CrmCustomLists" USING btree ("ListId");
     DROP INDEX public."idx_ListId";
       public            postgres    false    265            �           1259    21653 "   CrmCustomListsTenant100_ListId_idx    INDEX     n   CREATE INDEX "CrmCustomListsTenant100_ListId_idx" ON public."CrmCustomListsTenant100" USING btree ("ListId");
 8   DROP INDEX public."CrmCustomListsTenant100_ListId_idx";
       public            postgres    false    5871    268    268            �           1259    21654     CrmCustomListsTenant1_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant1_ListId_idx" ON public."CrmCustomListsTenant1" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant1_ListId_idx";
       public            postgres    false    5871    267    267            �           1259    21655     CrmCustomListsTenant2_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant2_ListId_idx" ON public."CrmCustomListsTenant2" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant2_ListId_idx";
       public            postgres    false    269    269    5871            �           1259    21656     CrmCustomListsTenant3_ListId_idx    INDEX     j   CREATE INDEX "CrmCustomListsTenant3_ListId_idx" ON public."CrmCustomListsTenant3" USING btree ("ListId");
 6   DROP INDEX public."CrmCustomListsTenant3_ListId_idx";
       public            postgres    false    270    270    5871            �           1259    21657    idx_EmailId    INDEX     N   CREATE INDEX "idx_EmailId" ON ONLY public."CrmEmail" USING btree ("EmailId");
 !   DROP INDEX public."idx_EmailId";
       public            postgres    false    271                       1259    21658    CrmEmail100_EmailId_idx    INDEX     X   CREATE INDEX "CrmEmail100_EmailId_idx" ON public."CrmEmail100" USING btree ("EmailId");
 -   DROP INDEX public."CrmEmail100_EmailId_idx";
       public            postgres    false    5886    274    274            �           1259    21659    CrmEmail1_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail1_EmailId_idx" ON public."CrmEmail1" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail1_EmailId_idx";
       public            postgres    false    273    273    5886                       1259    21660    CrmEmail2_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail2_EmailId_idx" ON public."CrmEmail2" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail2_EmailId_idx";
       public            postgres    false    275    275    5886                       1259    21661    CrmEmail3_EmailId_idx    INDEX     T   CREATE INDEX "CrmEmail3_EmailId_idx" ON public."CrmEmail3" USING btree ("EmailId");
 +   DROP INDEX public."CrmEmail3_EmailId_idx";
       public            postgres    false    276    5886    276                       1259    21662    idx_crmindustry_industryid    INDEX     a   CREATE INDEX idx_crmindustry_industryid ON ONLY public."CrmIndustry" USING btree ("IndustryId");
 .   DROP INDEX public.idx_crmindustry_industryid;
       public            postgres    false    277                       1259    21663 #   CrmIndustryTenant100_IndustryId_idx    INDEX     p   CREATE INDEX "CrmIndustryTenant100_IndustryId_idx" ON public."CrmIndustryTenant100" USING btree ("IndustryId");
 9   DROP INDEX public."CrmIndustryTenant100_IndustryId_idx";
       public            postgres    false    280    5901    280                       1259    21664 !   CrmIndustryTenant1_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant1_IndustryId_idx" ON public."CrmIndustryTenant1" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant1_IndustryId_idx";
       public            postgres    false    279    279    5901                       1259    21665 !   CrmIndustryTenant2_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant2_IndustryId_idx" ON public."CrmIndustryTenant2" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant2_IndustryId_idx";
       public            postgres    false    281    281    5901                       1259    21666 !   CrmIndustryTenant3_IndustryId_idx    INDEX     l   CREATE INDEX "CrmIndustryTenant3_IndustryId_idx" ON public."CrmIndustryTenant3" USING btree ("IndustryId");
 7   DROP INDEX public."CrmIndustryTenant3_IndustryId_idx";
       public            postgres    false    282    5901    282                       1259    21667 !   idx_crmleadactivitylog_activityid    INDEX     o   CREATE INDEX idx_crmleadactivitylog_activityid ON ONLY public."CrmLeadActivityLog" USING btree ("ActivityId");
 5   DROP INDEX public.idx_crmleadactivitylog_activityid;
       public            postgres    false    284            #           1259    21668 *   CrmLeadActivityLogTenant100_ActivityId_idx    INDEX     ~   CREATE INDEX "CrmLeadActivityLogTenant100_ActivityId_idx" ON public."CrmLeadActivityLogTenant100" USING btree ("ActivityId");
 @   DROP INDEX public."CrmLeadActivityLogTenant100_ActivityId_idx";
       public            postgres    false    5919    287    287                        1259    21669 (   CrmLeadActivityLogTenant1_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant1_ActivityId_idx" ON public."CrmLeadActivityLogTenant1" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant1_ActivityId_idx";
       public            postgres    false    286    5919    286            &           1259    21670 (   CrmLeadActivityLogTenant2_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant2_ActivityId_idx" ON public."CrmLeadActivityLogTenant2" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant2_ActivityId_idx";
       public            postgres    false    288    288    5919            )           1259    21671 (   CrmLeadActivityLogTenant3_ActivityId_idx    INDEX     z   CREATE INDEX "CrmLeadActivityLogTenant3_ActivityId_idx" ON public."CrmLeadActivityLogTenant3" USING btree ("ActivityId");
 >   DROP INDEX public."CrmLeadActivityLogTenant3_ActivityId_idx";
       public            postgres    false    289    289    5919            .           1259    21672    idx_crmleadsource_sourceid    INDEX     a   CREATE INDEX idx_crmleadsource_sourceid ON ONLY public."CrmLeadSource" USING btree ("SourceId");
 .   DROP INDEX public.idx_crmleadsource_sourceid;
       public            postgres    false    290            2           1259    21673 #   CrmLeadSourceTenant100_SourceId_idx    INDEX     p   CREATE INDEX "CrmLeadSourceTenant100_SourceId_idx" ON public."CrmLeadSourceTenant100" USING btree ("SourceId");
 9   DROP INDEX public."CrmLeadSourceTenant100_SourceId_idx";
       public            postgres    false    5934    293    293            /           1259    21674 !   CrmLeadSourceTenant1_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant1_SourceId_idx" ON public."CrmLeadSourceTenant1" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant1_SourceId_idx";
       public            postgres    false    292    292    5934            5           1259    21675 !   CrmLeadSourceTenant2_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant2_SourceId_idx" ON public."CrmLeadSourceTenant2" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant2_SourceId_idx";
       public            postgres    false    294    294    5934            8           1259    21676 !   CrmLeadSourceTenant3_SourceId_idx    INDEX     l   CREATE INDEX "CrmLeadSourceTenant3_SourceId_idx" ON public."CrmLeadSourceTenant3" USING btree ("SourceId");
 7   DROP INDEX public."CrmLeadSourceTenant3_SourceId_idx";
       public            postgres    false    5934    295    295            =           1259    21677    idx_crmleadstatus_statusid    INDEX     a   CREATE INDEX idx_crmleadstatus_statusid ON ONLY public."CrmLeadStatus" USING btree ("StatusId");
 .   DROP INDEX public.idx_crmleadstatus_statusid;
       public            postgres    false    296            A           1259    21678 #   CrmLeadStatusTenant100_StatusId_idx    INDEX     p   CREATE INDEX "CrmLeadStatusTenant100_StatusId_idx" ON public."CrmLeadStatusTenant100" USING btree ("StatusId");
 9   DROP INDEX public."CrmLeadStatusTenant100_StatusId_idx";
       public            postgres    false    299    5949    299            >           1259    21679 !   CrmLeadStatusTenant1_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant1_StatusId_idx" ON public."CrmLeadStatusTenant1" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant1_StatusId_idx";
       public            postgres    false    5949    298    298            D           1259    21680 !   CrmLeadStatusTenant2_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant2_StatusId_idx" ON public."CrmLeadStatusTenant2" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant2_StatusId_idx";
       public            postgres    false    300    300    5949            G           1259    21681 !   CrmLeadStatusTenant3_StatusId_idx    INDEX     l   CREATE INDEX "CrmLeadStatusTenant3_StatusId_idx" ON public."CrmLeadStatusTenant3" USING btree ("StatusId");
 7   DROP INDEX public."CrmLeadStatusTenant3_StatusId_idx";
       public            postgres    false    301    5949    301                       1259    21682    idx_crmlead_leadid    INDEX     Q   CREATE INDEX idx_crmlead_leadid ON ONLY public."CrmLead" USING btree ("LeadId");
 &   DROP INDEX public.idx_crmlead_leadid;
       public            postgres    false    283            M           1259    21683    CrmLeadTenant100_LeadId_idx    INDEX     `   CREATE INDEX "CrmLeadTenant100_LeadId_idx" ON public."CrmLeadTenant100" USING btree ("LeadId");
 1   DROP INDEX public."CrmLeadTenant100_LeadId_idx";
       public            postgres    false    5916    304    304            J           1259    21684    CrmLeadTenant1_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant1_LeadId_idx" ON public."CrmLeadTenant1" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant1_LeadId_idx";
       public            postgres    false    5916    303    303            P           1259    21685    CrmLeadTenant2_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant2_LeadId_idx" ON public."CrmLeadTenant2" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant2_LeadId_idx";
       public            postgres    false    5916    305    305            S           1259    21686    CrmLeadTenant3_LeadId_idx    INDEX     \   CREATE INDEX "CrmLeadTenant3_LeadId_idx" ON public."CrmLeadTenant3" USING btree ("LeadId");
 /   DROP INDEX public."CrmLeadTenant3_LeadId_idx";
       public            postgres    false    306    5916    306            X           1259    21687    idx_MeetingId    INDEX     T   CREATE INDEX "idx_MeetingId" ON ONLY public."CrmMeeting" USING btree ("MeetingId");
 #   DROP INDEX public."idx_MeetingId";
       public            postgres    false    307            \           1259    21688    CrmMeeting100_MeetingId_idx    INDEX     `   CREATE INDEX "CrmMeeting100_MeetingId_idx" ON public."CrmMeeting100" USING btree ("MeetingId");
 1   DROP INDEX public."CrmMeeting100_MeetingId_idx";
       public            postgres    false    310    5976    310            Y           1259    21689    CrmMeeting1_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting1_MeetingId_idx" ON public."CrmMeeting1" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting1_MeetingId_idx";
       public            postgres    false    309    309    5976            _           1259    21690    CrmMeeting2_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting2_MeetingId_idx" ON public."CrmMeeting2" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting2_MeetingId_idx";
       public            postgres    false    311    5976    311            b           1259    21691    CrmMeeting3_MeetingId_idx    INDEX     \   CREATE INDEX "CrmMeeting3_MeetingId_idx" ON public."CrmMeeting3" USING btree ("MeetingId");
 /   DROP INDEX public."CrmMeeting3_MeetingId_idx";
       public            postgres    false    312    5976    312            j           1259    21692    idx_NoteTagsId    INDEX     W   CREATE INDEX "idx_NoteTagsId" ON ONLY public."CrmNoteTags" USING btree ("NoteTagsId");
 $   DROP INDEX public."idx_NoteTagsId";
       public            postgres    false    314            n           1259    21693 #   CrmNoteTagsTenant100_NoteTagsId_idx    INDEX     p   CREATE INDEX "CrmNoteTagsTenant100_NoteTagsId_idx" ON public."CrmNoteTagsTenant100" USING btree ("NoteTagsId");
 9   DROP INDEX public."CrmNoteTagsTenant100_NoteTagsId_idx";
       public            postgres    false    317    5994    317            k           1259    21694 !   CrmNoteTagsTenant1_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant1_NoteTagsId_idx" ON public."CrmNoteTagsTenant1" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant1_NoteTagsId_idx";
       public            postgres    false    316    316    5994            q           1259    21695 !   CrmNoteTagsTenant2_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant2_NoteTagsId_idx" ON public."CrmNoteTagsTenant2" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant2_NoteTagsId_idx";
       public            postgres    false    318    5994    318            t           1259    21696 !   CrmNoteTagsTenant3_NoteTagsId_idx    INDEX     l   CREATE INDEX "CrmNoteTagsTenant3_NoteTagsId_idx" ON public."CrmNoteTagsTenant3" USING btree ("NoteTagsId");
 7   DROP INDEX public."CrmNoteTagsTenant3_NoteTagsId_idx";
       public            postgres    false    5994    319    319            y           1259    21697    idx_NoteTaskId    INDEX     X   CREATE INDEX "idx_NoteTaskId" ON ONLY public."CrmNoteTasks" USING btree ("NoteTaskId");
 $   DROP INDEX public."idx_NoteTaskId";
       public            postgres    false    320            }           1259    21698 $   CrmNoteTasksTenant100_NoteTaskId_idx    INDEX     r   CREATE INDEX "CrmNoteTasksTenant100_NoteTaskId_idx" ON public."CrmNoteTasksTenant100" USING btree ("NoteTaskId");
 :   DROP INDEX public."CrmNoteTasksTenant100_NoteTaskId_idx";
       public            postgres    false    323    323    6009            z           1259    21699 "   CrmNoteTasksTenant1_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant1_NoteTaskId_idx" ON public."CrmNoteTasksTenant1" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant1_NoteTaskId_idx";
       public            postgres    false    322    322    6009            �           1259    21700 "   CrmNoteTasksTenant2_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant2_NoteTaskId_idx" ON public."CrmNoteTasksTenant2" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant2_NoteTaskId_idx";
       public            postgres    false    6009    324    324            �           1259    21701 "   CrmNoteTasksTenant3_NoteTaskId_idx    INDEX     n   CREATE INDEX "CrmNoteTasksTenant3_NoteTaskId_idx" ON public."CrmNoteTasksTenant3" USING btree ("NoteTaskId");
 8   DROP INDEX public."CrmNoteTasksTenant3_NoteTaskId_idx";
       public            postgres    false    6009    325    325            g           1259    21702    idx_crmnote_noteid    INDEX     Q   CREATE INDEX idx_crmnote_noteid ON ONLY public."CrmNote" USING btree ("NoteId");
 &   DROP INDEX public.idx_crmnote_noteid;
       public            postgres    false    313            �           1259    21703    CrmNoteTenant100_NoteId_idx    INDEX     `   CREATE INDEX "CrmNoteTenant100_NoteId_idx" ON public."CrmNoteTenant100" USING btree ("NoteId");
 1   DROP INDEX public."CrmNoteTenant100_NoteId_idx";
       public            postgres    false    5991    328    328            �           1259    21704    CrmNoteTenant1_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant1_NoteId_idx" ON public."CrmNoteTenant1" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant1_NoteId_idx";
       public            postgres    false    5991    327    327            �           1259    21705    CrmNoteTenant2_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant2_NoteId_idx" ON public."CrmNoteTenant2" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant2_NoteId_idx";
       public            postgres    false    329    329    5991            �           1259    21706    CrmNoteTenant3_NoteId_idx    INDEX     \   CREATE INDEX "CrmNoteTenant3_NoteId_idx" ON public."CrmNoteTenant3" USING btree ("NoteId");
 /   DROP INDEX public."CrmNoteTenant3_NoteId_idx";
       public            postgres    false    330    330    5991                       1259    22302    idx_OpportunityId    INDEX     `   CREATE INDEX "idx_OpportunityId" ON ONLY public."CrmOpportunity" USING btree ("OpportunityId");
 '   DROP INDEX public."idx_OpportunityId";
       public            postgres    false    387                        1259    22306 #   CrmOpportunity100_OpportunityId_idx    INDEX     p   CREATE INDEX "CrmOpportunity100_OpportunityId_idx" ON public."CrmOpportunity100" USING btree ("OpportunityId");
 9   DROP INDEX public."CrmOpportunity100_OpportunityId_idx";
       public            postgres    false    391    391    6166                       1259    22303 !   CrmOpportunity1_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity1_OpportunityId_idx" ON public."CrmOpportunity1" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity1_OpportunityId_idx";
       public            postgres    false    6166    388    388                       1259    22304 !   CrmOpportunity2_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity2_OpportunityId_idx" ON public."CrmOpportunity2" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity2_OpportunityId_idx";
       public            postgres    false    6166    389    389                       1259    22305 !   CrmOpportunity3_OpportunityId_idx    INDEX     l   CREATE INDEX "CrmOpportunity3_OpportunityId_idx" ON public."CrmOpportunity3" USING btree ("OpportunityId");
 7   DROP INDEX public."CrmOpportunity3_OpportunityId_idx";
       public            postgres    false    6166    390    390            �           1259    21707    idx_crmproduct_productid    INDEX     ]   CREATE INDEX idx_crmproduct_productid ON ONLY public."CrmProduct" USING btree ("ProductId");
 ,   DROP INDEX public.idx_crmproduct_productid;
       public            postgres    false    331            �           1259    21708 !   CrmProductTenant100_ProductId_idx    INDEX     l   CREATE INDEX "CrmProductTenant100_ProductId_idx" ON public."CrmProductTenant100" USING btree ("ProductId");
 7   DROP INDEX public."CrmProductTenant100_ProductId_idx";
       public            postgres    false    334    334    6036            �           1259    21709    CrmProductTenant1_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant1_ProductId_idx" ON public."CrmProductTenant1" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant1_ProductId_idx";
       public            postgres    false    333    333    6036            �           1259    21710    CrmProductTenant2_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant2_ProductId_idx" ON public."CrmProductTenant2" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant2_ProductId_idx";
       public            postgres    false    6036    335    335            �           1259    21711    CrmProductTenant3_ProductId_idx    INDEX     h   CREATE INDEX "CrmProductTenant3_ProductId_idx" ON public."CrmProductTenant3" USING btree ("ProductId");
 5   DROP INDEX public."CrmProductTenant3_ProductId_idx";
       public            postgres    false    336    336    6036            �           1259    21712    idx_crmtagused_tagusedid    INDEX     ]   CREATE INDEX idx_crmtagused_tagusedid ON ONLY public."CrmTagUsed" USING btree ("TagUsedId");
 ,   DROP INDEX public.idx_crmtagused_tagusedid;
       public            postgres    false    337            �           1259    21713 !   CrmTagUsedTenant100_TagUsedId_idx    INDEX     l   CREATE INDEX "CrmTagUsedTenant100_TagUsedId_idx" ON public."CrmTagUsedTenant100" USING btree ("TagUsedId");
 7   DROP INDEX public."CrmTagUsedTenant100_TagUsedId_idx";
       public            postgres    false    6051    340    340            �           1259    21714    CrmTagUsedTenant1_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant1_TagUsedId_idx" ON public."CrmTagUsedTenant1" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant1_TagUsedId_idx";
       public            postgres    false    339    6051    339            �           1259    21715    CrmTagUsedTenant2_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant2_TagUsedId_idx" ON public."CrmTagUsedTenant2" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant2_TagUsedId_idx";
       public            postgres    false    6051    341    341            �           1259    21716    CrmTagUsedTenant3_TagUsedId_idx    INDEX     h   CREATE INDEX "CrmTagUsedTenant3_TagUsedId_idx" ON public."CrmTagUsedTenant3" USING btree ("TagUsedId");
 5   DROP INDEX public."CrmTagUsedTenant3_TagUsedId_idx";
       public            postgres    false    342    6051    342            �           1259    21717    idx_crmtags_tagid    INDEX     O   CREATE INDEX idx_crmtags_tagid ON ONLY public."CrmTags" USING btree ("TagId");
 %   DROP INDEX public.idx_crmtags_tagid;
       public            postgres    false    343            �           1259    21718    CrmTagsTenant100_TagId_idx    INDEX     ^   CREATE INDEX "CrmTagsTenant100_TagId_idx" ON public."CrmTagsTenant100" USING btree ("TagId");
 0   DROP INDEX public."CrmTagsTenant100_TagId_idx";
       public            postgres    false    6066    346    346            �           1259    21719    CrmTagsTenant1_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant1_TagId_idx" ON public."CrmTagsTenant1" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant1_TagId_idx";
       public            postgres    false    6066    345    345            �           1259    21720    CrmTagsTenant2_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant2_TagId_idx" ON public."CrmTagsTenant2" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant2_TagId_idx";
       public            postgres    false    6066    347    347            �           1259    21721    CrmTagsTenant3_TagId_idx    INDEX     Z   CREATE INDEX "CrmTagsTenant3_TagId_idx" ON public."CrmTagsTenant3" USING btree ("TagId");
 .   DROP INDEX public."CrmTagsTenant3_TagId_idx";
       public            postgres    false    348    348    6066            �           1259    21722    idx_TaskTagsId    INDEX     W   CREATE INDEX "idx_TaskTagsId" ON ONLY public."CrmTaskTags" USING btree ("TaskTagsId");
 $   DROP INDEX public."idx_TaskTagsId";
       public            postgres    false    354            �           1259    21723 #   CrmTaskTagsTenant100_TaskTagsId_idx    INDEX     p   CREATE INDEX "CrmTaskTagsTenant100_TaskTagsId_idx" ON public."CrmTaskTagsTenant100" USING btree ("TaskTagsId");
 9   DROP INDEX public."CrmTaskTagsTenant100_TaskTagsId_idx";
       public            postgres    false    357    357    6089            �           1259    21724 !   CrmTaskTagsTenant1_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant1_TaskTagsId_idx" ON public."CrmTaskTagsTenant1" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant1_TaskTagsId_idx";
       public            postgres    false    356    6089    356            �           1259    21725 !   CrmTaskTagsTenant2_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant2_TaskTagsId_idx" ON public."CrmTaskTagsTenant2" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant2_TaskTagsId_idx";
       public            postgres    false    6089    358    358            �           1259    21726 !   CrmTaskTagsTenant3_TaskTagsId_idx    INDEX     l   CREATE INDEX "CrmTaskTagsTenant3_TaskTagsId_idx" ON public."CrmTaskTagsTenant3" USING btree ("TaskTagsId");
 7   DROP INDEX public."CrmTaskTagsTenant3_TaskTagsId_idx";
       public            postgres    false    359    6089    359            �           1259    21727    idx_crmtask_noteid    INDEX     Q   CREATE INDEX idx_crmtask_noteid ON ONLY public."CrmTask" USING btree ("TaskId");
 &   DROP INDEX public.idx_crmtask_noteid;
       public            postgres    false    349            �           1259    21728    CrmTaskTenant100_TaskId_idx    INDEX     `   CREATE INDEX "CrmTaskTenant100_TaskId_idx" ON public."CrmTaskTenant100" USING btree ("TaskId");
 1   DROP INDEX public."CrmTaskTenant100_TaskId_idx";
       public            postgres    false    6081    362    362            �           1259    21729    CrmTaskTenant1_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant1_TaskId_idx" ON public."CrmTaskTenant1" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant1_TaskId_idx";
       public            postgres    false    6081    361    361            �           1259    21730    CrmTaskTenant2_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant2_TaskId_idx" ON public."CrmTaskTenant2" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant2_TaskId_idx";
       public            postgres    false    363    6081    363            �           1259    21731    CrmTaskTenant3_TaskId_idx    INDEX     \   CREATE INDEX "CrmTaskTenant3_TaskId_idx" ON public."CrmTaskTenant3" USING btree ("TaskId");
 /   DROP INDEX public."CrmTaskTenant3_TaskId_idx";
       public            postgres    false    6081    364    364            �           1259    21732    idx_crmteammember_teammemberid    INDEX     i   CREATE INDEX idx_crmteammember_teammemberid ON ONLY public."CrmTeamMember" USING btree ("TeamMemberId");
 2   DROP INDEX public.idx_crmteammember_teammemberid;
       public            postgres    false    366            �           1259    21733 '   CrmTeamMemberTenant100_TeamMemberId_idx    INDEX     x   CREATE INDEX "CrmTeamMemberTenant100_TeamMemberId_idx" ON public."CrmTeamMemberTenant100" USING btree ("TeamMemberId");
 =   DROP INDEX public."CrmTeamMemberTenant100_TeamMemberId_idx";
       public            postgres    false    6119    369    369            �           1259    21734 %   CrmTeamMemberTenant1_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant1_TeamMemberId_idx" ON public."CrmTeamMemberTenant1" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant1_TeamMemberId_idx";
       public            postgres    false    368    6119    368            �           1259    21735 %   CrmTeamMemberTenant2_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant2_TeamMemberId_idx" ON public."CrmTeamMemberTenant2" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant2_TeamMemberId_idx";
       public            postgres    false    370    6119    370            �           1259    21736 %   CrmTeamMemberTenant3_TeamMemberId_idx    INDEX     t   CREATE INDEX "CrmTeamMemberTenant3_TeamMemberId_idx" ON public."CrmTeamMemberTenant3" USING btree ("TeamMemberId");
 ;   DROP INDEX public."CrmTeamMemberTenant3_TeamMemberId_idx";
       public            postgres    false    371    6119    371            �           1259    21737    idx_crmteam_teamid    INDEX     Q   CREATE INDEX idx_crmteam_teamid ON ONLY public."CrmTeam" USING btree ("TeamId");
 &   DROP INDEX public.idx_crmteam_teamid;
       public            postgres    false    365            �           1259    21738    CrmTeamTenant100_TeamId_idx    INDEX     `   CREATE INDEX "CrmTeamTenant100_TeamId_idx" ON public."CrmTeamTenant100" USING btree ("TeamId");
 1   DROP INDEX public."CrmTeamTenant100_TeamId_idx";
       public            postgres    false    374    374    6116            �           1259    21739    CrmTeamTenant1_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant1_TeamId_idx" ON public."CrmTeamTenant1" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant1_TeamId_idx";
       public            postgres    false    373    373    6116            �           1259    21740    CrmTeamTenant2_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant2_TeamId_idx" ON public."CrmTeamTenant2" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant2_TeamId_idx";
       public            postgres    false    375    6116    375            �           1259    21741    CrmTeamTenant3_TeamId_idx    INDEX     \   CREATE INDEX "CrmTeamTenant3_TeamId_idx" ON public."CrmTeamTenant3" USING btree ("TeamId");
 /   DROP INDEX public."CrmTeamTenant3_TeamId_idx";
       public            postgres    false    6116    376    376                       1259    21742 !   idx_crmuseractivitylog_activityid    INDEX     o   CREATE INDEX idx_crmuseractivitylog_activityid ON ONLY public."CrmUserActivityLog" USING btree ("ActivityId");
 5   DROP INDEX public.idx_crmuseractivitylog_activityid;
       public            postgres    false    377                       1259    21743 *   CrmUserActivityLogTenant100_ActivityId_idx    INDEX     ~   CREATE INDEX "CrmUserActivityLogTenant100_ActivityId_idx" ON public."CrmUserActivityLogTenant100" USING btree ("ActivityId");
 @   DROP INDEX public."CrmUserActivityLogTenant100_ActivityId_idx";
       public            postgres    false    6146    380    380                       1259    21744 (   CrmUserActivityLogTenant1_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant1_ActivityId_idx" ON public."CrmUserActivityLogTenant1" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant1_ActivityId_idx";
       public            postgres    false    6146    379    379            	           1259    21745 (   CrmUserActivityLogTenant2_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant2_ActivityId_idx" ON public."CrmUserActivityLogTenant2" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant2_ActivityId_idx";
       public            postgres    false    381    6146    381                       1259    21746 (   CrmUserActivityLogTenant3_ActivityId_idx    INDEX     z   CREATE INDEX "CrmUserActivityLogTenant3_ActivityId_idx" ON public."CrmUserActivityLogTenant3" USING btree ("ActivityId");
 >   DROP INDEX public."CrmUserActivityLogTenant3_ActivityId_idx";
       public            postgres    false    382    6146    382            �           1259    21747    idx_crmtaskpriority_priorityid    INDEX     d   CREATE INDEX idx_crmtaskpriority_priorityid ON public."CrmTaskPriority" USING btree ("PriorityId");
 2   DROP INDEX public.idx_crmtaskpriority_priorityid;
       public            postgres    false    350                       1259    21748    idxtenant_priorityid    INDEX     O   CREATE INDEX idxtenant_priorityid ON public."Tenant" USING btree ("TenantId");
 (   DROP INDEX public.idxtenant_priorityid;
       public            postgres    false    385                       0    0    CrmAdAccount100_AccountId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount100_AccountId_idx";
          public          postgres    false    6189    6185    399    397                       0    0    CrmAdAccount100_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount100_pkey";
          public          postgres    false    6191    6184    399    6184    399    397                       0    0    CrmAdAccount1_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount1_AccountId_idx";
          public          postgres    false    6186    6185    398    397                       0    0    CrmAdAccount1_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount1_pkey";
          public          postgres    false    6184    6188    398    6184    398    397                       0    0    CrmAdAccount2_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount2_AccountId_idx";
          public          postgres    false    6192    6185    400    397                       0    0    CrmAdAccount2_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount2_pkey";
          public          postgres    false    400    6194    6184    6184    400    397                       0    0    CrmAdAccount3_AccountId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_AccountId" ATTACH PARTITION public."CrmAdAccount3_AccountId_idx";
          public          postgres    false    6195    6185    401    397            	           0    0    CrmAdAccount3_pkey    INDEX ATTACH     U   ALTER INDEX public."CrmAdAccount_pkey" ATTACH PARTITION public."CrmAdAccount3_pkey";
          public          postgres    false    6184    401    6197    6184    401    397            8           0    0 &   CrmCalenderEventsTenant100_EventId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant100_EventId_idx";
          public          postgres    false    5795    5791    238    235            9           0    0    CrmCalenderEventsTenant100_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant100_pkey";
          public          postgres    false    238    5790    5797    5790    238    235            6           0    0 $   CrmCalenderEventsTenant1_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant1_EventId_idx";
          public          postgres    false    5792    5791    237    235            7           0    0    CrmCalenderEventsTenant1_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant1_pkey";
          public          postgres    false    5794    5790    237    5790    237    235            :           0    0 $   CrmCalenderEventsTenant2_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant2_EventId_idx";
          public          postgres    false    5798    5791    239    235            ;           0    0    CrmCalenderEventsTenant2_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant2_pkey";
          public          postgres    false    5800    239    5790    5790    239    235            <           0    0 $   CrmCalenderEventsTenant3_EventId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcalenderevents_eventid ATTACH PARTITION public."CrmCalenderEventsTenant3_EventId_idx";
          public          postgres    false    5801    5791    240    235            =           0    0    CrmCalenderEventsTenant3_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCalenderEvents_pkey" ATTACH PARTITION public."CrmCalenderEventsTenant3_pkey";
          public          postgres    false    240    5803    5790    5790    240    235            @           0    0    CrmCall100_CallId_idx    INDEX ATTACH     Q   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall100_CallId_idx";
          public          postgres    false    5810    5806    244    241            A           0    0    CrmCall100_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall100_pkey";
          public          postgres    false    5805    244    5812    5805    244    241            >           0    0    CrmCall1_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall1_CallId_idx";
          public          postgres    false    5807    5806    243    241            ?           0    0    CrmCall1_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall1_pkey";
          public          postgres    false    243    5805    5809    5805    243    241            B           0    0    CrmCall2_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall2_CallId_idx";
          public          postgres    false    5813    5806    245    241            C           0    0    CrmCall2_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall2_pkey";
          public          postgres    false    245    5815    5805    5805    245    241            D           0    0    CrmCall3_CallId_idx    INDEX ATTACH     O   ALTER INDEX public."idx_CallId" ATTACH PARTITION public."CrmCall3_CallId_idx";
          public          postgres    false    5816    5806    246    241            E           0    0    CrmCall3_pkey    INDEX ATTACH     K   ALTER INDEX public."CrmCall_pkey" ATTACH PARTITION public."CrmCall3_pkey";
          public          postgres    false    5818    5805    246    5805    246    241            H           0    0 -   CrmCompanyActivityLogTenant100_ActivityId_idx    INDEX ATTACH     �   ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant100_ActivityId_idx";
          public          postgres    false    5828    5824    251    248            I           0    0 #   CrmCompanyActivityLogTenant100_pkey    INDEX ATTACH     o   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant100_pkey";
          public          postgres    false    5830    5823    251    5823    251    248            F           0    0 +   CrmCompanyActivityLogTenant1_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant1_ActivityId_idx";
          public          postgres    false    5825    5824    250    248            G           0    0 !   CrmCompanyActivityLogTenant1_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant1_pkey";
          public          postgres    false    5827    5823    250    5823    250    248            J           0    0 +   CrmCompanyActivityLogTenant2_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant2_ActivityId_idx";
          public          postgres    false    5831    5824    252    248            K           0    0 !   CrmCompanyActivityLogTenant2_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant2_pkey";
          public          postgres    false    252    5823    5833    5823    252    248            L           0    0 +   CrmCompanyActivityLogTenant3_ActivityId_idx    INDEX ATTACH        ALTER INDEX public.idx_crmcompanyactivitylog_activityid ATTACH PARTITION public."CrmCompanyActivityLogTenant3_ActivityId_idx";
          public          postgres    false    5834    5824    253    248            M           0    0 !   CrmCompanyActivityLogTenant3_pkey    INDEX ATTACH     m   ALTER INDEX public."CrmCompanyActivityLog_pkey" ATTACH PARTITION public."CrmCompanyActivityLogTenant3_pkey";
          public          postgres    false    5823    5836    253    5823    253    248            Q           0    0 '   CrmCompanyMemberTenant100_CompanyId_idx    INDEX ATTACH     u   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant100_CompanyId_idx";
          public          postgres    false    5845    5839    257    254            R           0    0 &   CrmCompanyMemberTenant100_MemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant100_MemberId_idx";
          public          postgres    false    5846    5840    257    254            S           0    0    CrmCompanyMemberTenant100_pkey    INDEX ATTACH     e   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant100_pkey";
          public          postgres    false    5848    5838    257    5838    257    254            N           0    0 %   CrmCompanyMemberTenant1_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant1_CompanyId_idx";
          public          postgres    false    5841    5839    256    254            O           0    0 $   CrmCompanyMemberTenant1_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant1_MemberId_idx";
          public          postgres    false    5842    5840    256    254            P           0    0    CrmCompanyMemberTenant1_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant1_pkey";
          public          postgres    false    5844    256    5838    5838    256    254            T           0    0 %   CrmCompanyMemberTenant2_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant2_CompanyId_idx";
          public          postgres    false    5849    5839    258    254            U           0    0 $   CrmCompanyMemberTenant2_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant2_MemberId_idx";
          public          postgres    false    5850    5840    258    254            V           0    0    CrmCompanyMemberTenant2_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant2_pkey";
          public          postgres    false    258    5852    5838    5838    258    254            W           0    0 %   CrmCompanyMemberTenant3_CompanyId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmcompanymember_companyid ATTACH PARTITION public."CrmCompanyMemberTenant3_CompanyId_idx";
          public          postgres    false    5853    5839    259    254            X           0    0 $   CrmCompanyMemberTenant3_MemberId_idx    INDEX ATTACH     q   ALTER INDEX public.idx_crmcompanymember_memberid ATTACH PARTITION public."CrmCompanyMemberTenant3_MemberId_idx";
          public          postgres    false    5854    5840    259    254            Y           0    0    CrmCompanyMemberTenant3_pkey    INDEX ATTACH     c   ALTER INDEX public."CrmCompanyMember_pkey" ATTACH PARTITION public."CrmCompanyMemberTenant3_pkey";
          public          postgres    false    259    5838    5856    5838    259    254            \           0    0 !   CrmCompanyTenant100_CompanyId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant100_CompanyId_idx";
          public          postgres    false    5860    5821    262    247            ]           0    0    CrmCompanyTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant100_pkey";
          public          postgres    false    5820    5862    262    5820    262    247            Z           0    0    CrmCompanyTenant1_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant1_CompanyId_idx";
          public          postgres    false    5857    5821    261    247            [           0    0    CrmCompanyTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant1_pkey";
          public          postgres    false    5859    5820    261    5820    261    247            ^           0    0    CrmCompanyTenant2_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant2_CompanyId_idx";
          public          postgres    false    5863    5821    263    247            _           0    0    CrmCompanyTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant2_pkey";
          public          postgres    false    263    5865    5820    5820    263    247            `           0    0    CrmCompanyTenant3_CompanyId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmcompany_companyid ATTACH PARTITION public."CrmCompanyTenant3_CompanyId_idx";
          public          postgres    false    5866    5821    264    247            a           0    0    CrmCompanyTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmCompany_pkey" ATTACH PARTITION public."CrmCompanyTenant3_pkey";
          public          postgres    false    5868    5820    264    5820    264    247            d           0    0 "   CrmCustomListsTenant100_ListId_idx    INDEX ATTACH     ^   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant100_ListId_idx";
          public          postgres    false    5875    5871    268    265            e           0    0    CrmCustomListsTenant100_pkey    INDEX ATTACH     a   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant100_pkey";
          public          postgres    false    5870    268    5877    5870    268    265            b           0    0     CrmCustomListsTenant1_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant1_ListId_idx";
          public          postgres    false    5872    5871    267    265            c           0    0    CrmCustomListsTenant1_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant1_pkey";
          public          postgres    false    5870    267    5874    5870    267    265            f           0    0     CrmCustomListsTenant2_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant2_ListId_idx";
          public          postgres    false    5878    5871    269    265            g           0    0    CrmCustomListsTenant2_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant2_pkey";
          public          postgres    false    5870    269    5880    5870    269    265            h           0    0     CrmCustomListsTenant3_ListId_idx    INDEX ATTACH     \   ALTER INDEX public."idx_ListId" ATTACH PARTITION public."CrmCustomListsTenant3_ListId_idx";
          public          postgres    false    5881    5871    270    265            i           0    0    CrmCustomListsTenant3_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmCustomLists_pkey" ATTACH PARTITION public."CrmCustomListsTenant3_pkey";
          public          postgres    false    270    5883    5870    5870    270    265            l           0    0    CrmEmail100_EmailId_idx    INDEX ATTACH     T   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail100_EmailId_idx";
          public          postgres    false    5890    5886    274    271            m           0    0    CrmEmail100_pkey    INDEX ATTACH     O   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail100_pkey";
          public          postgres    false    5892    274    5885    5885    274    271            j           0    0    CrmEmail1_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail1_EmailId_idx";
          public          postgres    false    5887    5886    273    271            k           0    0    CrmEmail1_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail1_pkey";
          public          postgres    false    5889    5885    273    5885    273    271            n           0    0    CrmEmail2_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail2_EmailId_idx";
          public          postgres    false    5893    5886    275    271            o           0    0    CrmEmail2_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail2_pkey";
          public          postgres    false    5895    275    5885    5885    275    271            p           0    0    CrmEmail3_EmailId_idx    INDEX ATTACH     R   ALTER INDEX public."idx_EmailId" ATTACH PARTITION public."CrmEmail3_EmailId_idx";
          public          postgres    false    5896    5886    276    271            q           0    0    CrmEmail3_pkey    INDEX ATTACH     M   ALTER INDEX public."CrmEmail_pkey" ATTACH PARTITION public."CrmEmail3_pkey";
          public          postgres    false    5898    5885    276    5885    276    271            t           0    0 #   CrmIndustryTenant100_IndustryId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant100_IndustryId_idx";
          public          postgres    false    5905    5901    280    277            u           0    0    CrmIndustryTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant100_pkey";
          public          postgres    false    5900    5907    280    5900    280    277            r           0    0 !   CrmIndustryTenant1_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant1_IndustryId_idx";
          public          postgres    false    5902    5901    279    277            s           0    0    CrmIndustryTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant1_pkey";
          public          postgres    false    5900    279    5904    5900    279    277            v           0    0 !   CrmIndustryTenant2_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant2_IndustryId_idx";
          public          postgres    false    5908    5901    281    277            w           0    0    CrmIndustryTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant2_pkey";
          public          postgres    false    5900    281    5910    5900    281    277            x           0    0 !   CrmIndustryTenant3_IndustryId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmindustry_industryid ATTACH PARTITION public."CrmIndustryTenant3_IndustryId_idx";
          public          postgres    false    5911    5901    282    277            y           0    0    CrmIndustryTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmIndustry_pkey" ATTACH PARTITION public."CrmIndustryTenant3_pkey";
          public          postgres    false    282    5913    5900    5900    282    277            |           0    0 *   CrmLeadActivityLogTenant100_ActivityId_idx    INDEX ATTACH     {   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant100_ActivityId_idx";
          public          postgres    false    5923    5919    287    284            }           0    0     CrmLeadActivityLogTenant100_pkey    INDEX ATTACH     i   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant100_pkey";
          public          postgres    false    5925    5918    287    5918    287    284            z           0    0 (   CrmLeadActivityLogTenant1_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant1_ActivityId_idx";
          public          postgres    false    5920    5919    286    284            {           0    0    CrmLeadActivityLogTenant1_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant1_pkey";
          public          postgres    false    5922    286    5918    5918    286    284            ~           0    0 (   CrmLeadActivityLogTenant2_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant2_ActivityId_idx";
          public          postgres    false    5926    5919    288    284                       0    0    CrmLeadActivityLogTenant2_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant2_pkey";
          public          postgres    false    5928    5918    288    5918    288    284            �           0    0 (   CrmLeadActivityLogTenant3_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmleadactivitylog_activityid ATTACH PARTITION public."CrmLeadActivityLogTenant3_ActivityId_idx";
          public          postgres    false    5929    5919    289    284            �           0    0    CrmLeadActivityLogTenant3_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmLeadActivityLog_pkey" ATTACH PARTITION public."CrmLeadActivityLogTenant3_pkey";
          public          postgres    false    289    5931    5918    5918    289    284            �           0    0 #   CrmLeadSourceTenant100_SourceId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant100_SourceId_idx";
          public          postgres    false    5938    5934    293    290            �           0    0    CrmLeadSourceTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant100_pkey";
          public          postgres    false    293    5940    5933    5933    293    290            �           0    0 !   CrmLeadSourceTenant1_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant1_SourceId_idx";
          public          postgres    false    5935    5934    292    290            �           0    0    CrmLeadSourceTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant1_pkey";
          public          postgres    false    5937    5933    292    5933    292    290            �           0    0 !   CrmLeadSourceTenant2_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant2_SourceId_idx";
          public          postgres    false    5941    5934    294    290            �           0    0    CrmLeadSourceTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant2_pkey";
          public          postgres    false    5933    294    5943    5933    294    290            �           0    0 !   CrmLeadSourceTenant3_SourceId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadsource_sourceid ATTACH PARTITION public."CrmLeadSourceTenant3_SourceId_idx";
          public          postgres    false    5944    5934    295    290            �           0    0    CrmLeadSourceTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadSource_pkey" ATTACH PARTITION public."CrmLeadSourceTenant3_pkey";
          public          postgres    false    5933    295    5946    5933    295    290            �           0    0 #   CrmLeadStatusTenant100_StatusId_idx    INDEX ATTACH     m   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant100_StatusId_idx";
          public          postgres    false    5953    5949    299    296            �           0    0    CrmLeadStatusTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant100_pkey";
          public          postgres    false    299    5948    5955    5948    299    296            �           0    0 !   CrmLeadStatusTenant1_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant1_StatusId_idx";
          public          postgres    false    5950    5949    298    296            �           0    0    CrmLeadStatusTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant1_pkey";
          public          postgres    false    5952    298    5948    5948    298    296            �           0    0 !   CrmLeadStatusTenant2_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant2_StatusId_idx";
          public          postgres    false    5956    5949    300    296            �           0    0    CrmLeadStatusTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant2_pkey";
          public          postgres    false    300    5948    5958    5948    300    296            �           0    0 !   CrmLeadStatusTenant3_StatusId_idx    INDEX ATTACH     k   ALTER INDEX public.idx_crmleadstatus_statusid ATTACH PARTITION public."CrmLeadStatusTenant3_StatusId_idx";
          public          postgres    false    5959    5949    301    296            �           0    0    CrmLeadStatusTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmLeadStatus_pkey" ATTACH PARTITION public."CrmLeadStatusTenant3_pkey";
          public          postgres    false    301    5961    5948    5948    301    296            �           0    0    CrmLeadTenant100_LeadId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant100_LeadId_idx";
          public          postgres    false    5965    5916    304    283            �           0    0    CrmLeadTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant100_pkey";
          public          postgres    false    5915    304    5967    5915    304    283            �           0    0    CrmLeadTenant1_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant1_LeadId_idx";
          public          postgres    false    5962    5916    303    283            �           0    0    CrmLeadTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant1_pkey";
          public          postgres    false    303    5964    5915    5915    303    283            �           0    0    CrmLeadTenant2_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant2_LeadId_idx";
          public          postgres    false    5968    5916    305    283            �           0    0    CrmLeadTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant2_pkey";
          public          postgres    false    305    5915    5970    5915    305    283            �           0    0    CrmLeadTenant3_LeadId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmlead_leadid ATTACH PARTITION public."CrmLeadTenant3_LeadId_idx";
          public          postgres    false    5971    5916    306    283            �           0    0    CrmLeadTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmLead_pkey" ATTACH PARTITION public."CrmLeadTenant3_pkey";
          public          postgres    false    5973    5915    306    5915    306    283            �           0    0    CrmMeeting100_MeetingId_idx    INDEX ATTACH     Z   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting100_MeetingId_idx";
          public          postgres    false    5980    5976    310    307            �           0    0    CrmMeeting100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting100_pkey";
          public          postgres    false    5975    310    5982    5975    310    307            �           0    0    CrmMeeting1_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting1_MeetingId_idx";
          public          postgres    false    5977    5976    309    307            �           0    0    CrmMeeting1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting1_pkey";
          public          postgres    false    5979    309    5975    5975    309    307            �           0    0    CrmMeeting2_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting2_MeetingId_idx";
          public          postgres    false    5983    5976    311    307            �           0    0    CrmMeeting2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting2_pkey";
          public          postgres    false    311    5975    5985    5975    311    307            �           0    0    CrmMeeting3_MeetingId_idx    INDEX ATTACH     X   ALTER INDEX public."idx_MeetingId" ATTACH PARTITION public."CrmMeeting3_MeetingId_idx";
          public          postgres    false    5986    5976    312    307            �           0    0    CrmMeeting3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmMeeting_pkey" ATTACH PARTITION public."CrmMeeting3_pkey";
          public          postgres    false    312    5975    5988    5975    312    307            �           0    0 #   CrmNoteTagsTenant100_NoteTagsId_idx    INDEX ATTACH     c   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant100_NoteTagsId_idx";
          public          postgres    false    5998    5994    317    314            �           0    0    CrmNoteTagsTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant100_pkey";
          public          postgres    false    6000    317    5993    5993    317    314            �           0    0 !   CrmNoteTagsTenant1_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant1_NoteTagsId_idx";
          public          postgres    false    5995    5994    316    314            �           0    0    CrmNoteTagsTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant1_pkey";
          public          postgres    false    316    5997    5993    5993    316    314            �           0    0 !   CrmNoteTagsTenant2_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant2_NoteTagsId_idx";
          public          postgres    false    6001    5994    318    314            �           0    0    CrmNoteTagsTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant2_pkey";
          public          postgres    false    318    6003    5993    5993    318    314            �           0    0 !   CrmNoteTagsTenant3_NoteTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_NoteTagsId" ATTACH PARTITION public."CrmNoteTagsTenant3_NoteTagsId_idx";
          public          postgres    false    6004    5994    319    314            �           0    0    CrmNoteTagsTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmNoteTags_pkey" ATTACH PARTITION public."CrmNoteTagsTenant3_pkey";
          public          postgres    false    6006    319    5993    5993    319    314            �           0    0 $   CrmNoteTasksTenant100_NoteTaskId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant100_NoteTaskId_idx";
          public          postgres    false    6013    6009    323    320            �           0    0    CrmNoteTasksTenant100_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant100_pkey";
          public          postgres    false    323    6015    6008    6008    323    320            �           0    0 "   CrmNoteTasksTenant1_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant1_NoteTaskId_idx";
          public          postgres    false    6010    6009    322    320            �           0    0    CrmNoteTasksTenant1_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant1_pkey";
          public          postgres    false    6012    6008    322    6008    322    320            �           0    0 "   CrmNoteTasksTenant2_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant2_NoteTaskId_idx";
          public          postgres    false    6016    6009    324    320            �           0    0    CrmNoteTasksTenant2_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant2_pkey";
          public          postgres    false    6008    324    6018    6008    324    320            �           0    0 "   CrmNoteTasksTenant3_NoteTaskId_idx    INDEX ATTACH     b   ALTER INDEX public."idx_NoteTaskId" ATTACH PARTITION public."CrmNoteTasksTenant3_NoteTaskId_idx";
          public          postgres    false    6019    6009    325    320            �           0    0    CrmNoteTasksTenant3_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmNoteTasks_pkey" ATTACH PARTITION public."CrmNoteTasksTenant3_pkey";
          public          postgres    false    6008    325    6021    6008    325    320            �           0    0    CrmNoteTenant100_NoteId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant100_NoteId_idx";
          public          postgres    false    6025    5991    328    313            �           0    0    CrmNoteTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant100_pkey";
          public          postgres    false    6027    5990    328    5990    328    313            �           0    0    CrmNoteTenant1_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant1_NoteId_idx";
          public          postgres    false    6022    5991    327    313            �           0    0    CrmNoteTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant1_pkey";
          public          postgres    false    6024    327    5990    5990    327    313            �           0    0    CrmNoteTenant2_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant2_NoteId_idx";
          public          postgres    false    6028    5991    329    313            �           0    0    CrmNoteTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant2_pkey";
          public          postgres    false    5990    329    6030    5990    329    313            �           0    0    CrmNoteTenant3_NoteId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmnote_noteid ATTACH PARTITION public."CrmNoteTenant3_NoteId_idx";
          public          postgres    false    6031    5991    330    313            �           0    0    CrmNoteTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmNote_pkey" ATTACH PARTITION public."CrmNoteTenant3_pkey";
          public          postgres    false    5990    330    6033    5990    330    313                        0    0 #   CrmOpportunity100_OpportunityId_idx    INDEX ATTACH     f   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity100_OpportunityId_idx";
          public          postgres    false    6176    6166    391    387                       0    0    CrmOpportunity100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity100_pkey";
          public          postgres    false    6165    6178    391    6165    391    387            �           0    0 !   CrmOpportunity1_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity1_OpportunityId_idx";
          public          postgres    false    6167    6166    388    387            �           0    0    CrmOpportunity1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity1_pkey";
          public          postgres    false    6169    6165    388    6165    388    387            �           0    0 !   CrmOpportunity2_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity2_OpportunityId_idx";
          public          postgres    false    6170    6166    389    387            �           0    0    CrmOpportunity2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity2_pkey";
          public          postgres    false    6172    6165    389    6165    389    387            �           0    0 !   CrmOpportunity3_OpportunityId_idx    INDEX ATTACH     d   ALTER INDEX public."idx_OpportunityId" ATTACH PARTITION public."CrmOpportunity3_OpportunityId_idx";
          public          postgres    false    6173    6166    390    387            �           0    0    CrmOpportunity3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmOpportunity_pkey" ATTACH PARTITION public."CrmOpportunity3_pkey";
          public          postgres    false    390    6175    6165    6165    390    387            �           0    0 !   CrmProductTenant100_ProductId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant100_ProductId_idx";
          public          postgres    false    6040    6036    334    331            �           0    0    CrmProductTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant100_pkey";
          public          postgres    false    6035    334    6042    6035    334    331            �           0    0    CrmProductTenant1_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant1_ProductId_idx";
          public          postgres    false    6037    6036    333    331            �           0    0    CrmProductTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant1_pkey";
          public          postgres    false    6039    333    6035    6035    333    331            �           0    0    CrmProductTenant2_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant2_ProductId_idx";
          public          postgres    false    6043    6036    335    331            �           0    0    CrmProductTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant2_pkey";
          public          postgres    false    6035    6045    335    6035    335    331            �           0    0    CrmProductTenant3_ProductId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmproduct_productid ATTACH PARTITION public."CrmProductTenant3_ProductId_idx";
          public          postgres    false    6046    6036    336    331            �           0    0    CrmProductTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmProduct_pkey" ATTACH PARTITION public."CrmProductTenant3_pkey";
          public          postgres    false    336    6048    6035    6035    336    331            �           0    0 !   CrmTagUsedTenant100_TagUsedId_idx    INDEX ATTACH     i   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant100_TagUsedId_idx";
          public          postgres    false    6055    6051    340    337            �           0    0    CrmTagUsedTenant100_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant100_pkey";
          public          postgres    false    340    6057    6050    6050    340    337            �           0    0    CrmTagUsedTenant1_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant1_TagUsedId_idx";
          public          postgres    false    6052    6051    339    337            �           0    0    CrmTagUsedTenant1_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant1_pkey";
          public          postgres    false    6050    339    6054    6050    339    337            �           0    0    CrmTagUsedTenant2_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant2_TagUsedId_idx";
          public          postgres    false    6058    6051    341    337            �           0    0    CrmTagUsedTenant2_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant2_pkey";
          public          postgres    false    6060    6050    341    6050    341    337            �           0    0    CrmTagUsedTenant3_TagUsedId_idx    INDEX ATTACH     g   ALTER INDEX public.idx_crmtagused_tagusedid ATTACH PARTITION public."CrmTagUsedTenant3_TagUsedId_idx";
          public          postgres    false    6061    6051    342    337            �           0    0    CrmTagUsedTenant3_pkey    INDEX ATTACH     W   ALTER INDEX public."CrmTagUsed_pkey" ATTACH PARTITION public."CrmTagUsedTenant3_pkey";
          public          postgres    false    6063    342    6050    6050    342    337            �           0    0    CrmTagsTenant100_TagId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant100_TagId_idx";
          public          postgres    false    6070    6066    346    343            �           0    0    CrmTagsTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant100_pkey";
          public          postgres    false    6065    6072    346    6065    346    343            �           0    0    CrmTagsTenant1_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant1_TagId_idx";
          public          postgres    false    6067    6066    345    343            �           0    0    CrmTagsTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant1_pkey";
          public          postgres    false    345    6065    6069    6065    345    343            �           0    0    CrmTagsTenant2_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant2_TagId_idx";
          public          postgres    false    6073    6066    347    343            �           0    0    CrmTagsTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant2_pkey";
          public          postgres    false    6075    6065    347    6065    347    343            �           0    0    CrmTagsTenant3_TagId_idx    INDEX ATTACH     Y   ALTER INDEX public.idx_crmtags_tagid ATTACH PARTITION public."CrmTagsTenant3_TagId_idx";
          public          postgres    false    6076    6066    348    343            �           0    0    CrmTagsTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTags_pkey" ATTACH PARTITION public."CrmTagsTenant3_pkey";
          public          postgres    false    6065    6078    348    6065    348    343            �           0    0 #   CrmTaskTagsTenant100_TaskTagsId_idx    INDEX ATTACH     c   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant100_TaskTagsId_idx";
          public          postgres    false    6093    6089    357    354            �           0    0    CrmTaskTagsTenant100_pkey    INDEX ATTACH     [   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant100_pkey";
          public          postgres    false    6095    357    6088    6088    357    354            �           0    0 !   CrmTaskTagsTenant1_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant1_TaskTagsId_idx";
          public          postgres    false    6090    6089    356    354            �           0    0    CrmTaskTagsTenant1_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant1_pkey";
          public          postgres    false    6092    356    6088    6088    356    354            �           0    0 !   CrmTaskTagsTenant2_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant2_TaskTagsId_idx";
          public          postgres    false    6096    6089    358    354            �           0    0    CrmTaskTagsTenant2_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant2_pkey";
          public          postgres    false    6098    6088    358    6088    358    354            �           0    0 !   CrmTaskTagsTenant3_TaskTagsId_idx    INDEX ATTACH     a   ALTER INDEX public."idx_TaskTagsId" ATTACH PARTITION public."CrmTaskTagsTenant3_TaskTagsId_idx";
          public          postgres    false    6099    6089    359    354            �           0    0    CrmTaskTagsTenant3_pkey    INDEX ATTACH     Y   ALTER INDEX public."CrmTaskTags_pkey" ATTACH PARTITION public."CrmTaskTagsTenant3_pkey";
          public          postgres    false    6101    6088    359    6088    359    354            �           0    0    CrmTaskTenant100_TaskId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant100_TaskId_idx";
          public          postgres    false    6105    6081    362    349            �           0    0    CrmTaskTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant100_pkey";
          public          postgres    false    6107    6080    362    6080    362    349            �           0    0    CrmTaskTenant1_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant1_TaskId_idx";
          public          postgres    false    6102    6081    361    349            �           0    0    CrmTaskTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant1_pkey";
          public          postgres    false    361    6104    6080    6080    361    349            �           0    0    CrmTaskTenant2_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant2_TaskId_idx";
          public          postgres    false    6108    6081    363    349            �           0    0    CrmTaskTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant2_pkey";
          public          postgres    false    6080    6110    363    6080    363    349            �           0    0    CrmTaskTenant3_TaskId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmtask_noteid ATTACH PARTITION public."CrmTaskTenant3_TaskId_idx";
          public          postgres    false    6111    6081    364    349            �           0    0    CrmTaskTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTask_pkey" ATTACH PARTITION public."CrmTaskTenant3_pkey";
          public          postgres    false    6080    364    6113    6080    364    349            �           0    0 '   CrmTeamMemberTenant100_TeamMemberId_idx    INDEX ATTACH     u   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant100_TeamMemberId_idx";
          public          postgres    false    6123    6119    369    366            �           0    0    CrmTeamMemberTenant100_pkey    INDEX ATTACH     _   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant100_pkey";
          public          postgres    false    369    6125    6118    6118    369    366            �           0    0 %   CrmTeamMemberTenant1_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant1_TeamMemberId_idx";
          public          postgres    false    6120    6119    368    366            �           0    0    CrmTeamMemberTenant1_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant1_pkey";
          public          postgres    false    6118    368    6122    6118    368    366            �           0    0 %   CrmTeamMemberTenant2_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant2_TeamMemberId_idx";
          public          postgres    false    6126    6119    370    366            �           0    0    CrmTeamMemberTenant2_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant2_pkey";
          public          postgres    false    6118    370    6128    6118    370    366            �           0    0 %   CrmTeamMemberTenant3_TeamMemberId_idx    INDEX ATTACH     s   ALTER INDEX public.idx_crmteammember_teammemberid ATTACH PARTITION public."CrmTeamMemberTenant3_TeamMemberId_idx";
          public          postgres    false    6129    6119    371    366            �           0    0    CrmTeamMemberTenant3_pkey    INDEX ATTACH     ]   ALTER INDEX public."CrmTeamMember_pkey" ATTACH PARTITION public."CrmTeamMemberTenant3_pkey";
          public          postgres    false    371    6118    6131    6118    371    366            �           0    0    CrmTeamTenant100_TeamId_idx    INDEX ATTACH     ]   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant100_TeamId_idx";
          public          postgres    false    6135    6116    374    365            �           0    0    CrmTeamTenant100_pkey    INDEX ATTACH     S   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant100_pkey";
          public          postgres    false    374    6137    6115    6115    374    365            �           0    0    CrmTeamTenant1_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant1_TeamId_idx";
          public          postgres    false    6132    6116    373    365            �           0    0    CrmTeamTenant1_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant1_pkey";
          public          postgres    false    6134    373    6115    6115    373    365            �           0    0    CrmTeamTenant2_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant2_TeamId_idx";
          public          postgres    false    6138    6116    375    365            �           0    0    CrmTeamTenant2_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant2_pkey";
          public          postgres    false    6115    375    6140    6115    375    365            �           0    0    CrmTeamTenant3_TeamId_idx    INDEX ATTACH     [   ALTER INDEX public.idx_crmteam_teamid ATTACH PARTITION public."CrmTeamTenant3_TeamId_idx";
          public          postgres    false    6141    6116    376    365            �           0    0    CrmTeamTenant3_pkey    INDEX ATTACH     Q   ALTER INDEX public."CrmTeam_pkey" ATTACH PARTITION public."CrmTeamTenant3_pkey";
          public          postgres    false    376    6143    6115    6115    376    365            �           0    0 *   CrmUserActivityLogTenant100_ActivityId_idx    INDEX ATTACH     {   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant100_ActivityId_idx";
          public          postgres    false    6150    6146    380    377            �           0    0     CrmUserActivityLogTenant100_pkey    INDEX ATTACH     i   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant100_pkey";
          public          postgres    false    6152    6145    380    6145    380    377            �           0    0 (   CrmUserActivityLogTenant1_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant1_ActivityId_idx";
          public          postgres    false    6147    6146    379    377            �           0    0    CrmUserActivityLogTenant1_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant1_pkey";
          public          postgres    false    379    6149    6145    6145    379    377            �           0    0 (   CrmUserActivityLogTenant2_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant2_ActivityId_idx";
          public          postgres    false    6153    6146    381    377            �           0    0    CrmUserActivityLogTenant2_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant2_pkey";
          public          postgres    false    6155    381    6145    6145    381    377            �           0    0 (   CrmUserActivityLogTenant3_ActivityId_idx    INDEX ATTACH     y   ALTER INDEX public.idx_crmuseractivitylog_activityid ATTACH PARTITION public."CrmUserActivityLogTenant3_ActivityId_idx";
          public          postgres    false    6156    6146    382    377            �           0    0    CrmUserActivityLogTenant3_pkey    INDEX ATTACH     g   ALTER INDEX public."CrmUserActivityLog_pkey" ATTACH PARTITION public."CrmUserActivityLogTenant3_pkey";
          public          postgres    false    6158    382    6145    6145    382    377            �   O  x��Tێ�0}����x���m������o+U^�$��\*��׆�@!"���Dx�9�9I]uBv-�悷tlt_�S�he��t����I���n@���'�O��G�$H!���|����BԱoD�L14�����z� `��!Qׅ�@Љ��E��iV�;X��_�F���u.����#���q3 $��!C'5�"{�l�̾�)�r�w6���4EGh��ZT�F��B@J��{�����K򒿑F�)�Jwy�^�sz%�s�n�t�<r�( `l�s�ӫ�
��-�=�+�B�}^*�KQ�^gevcC���q��5�����.�O�P:�Cw��Td�f}��&������]"��}L�S���֍�����RS1s:�˦y#֣�~�3��L%��<5gFr�7�iO]�	7fs�qc�פ����B���DO.�h+v���j�f��A�)3�0�d�e1�Ѥ��������j�jm)�G7Nh���-��/6�k��W�֏Y<Q2������4� �q�#D��!�<͸:Ev6��:�������I�Z�͈�2
t��>�)~0���M�      &      x������ � �      '      x������ � �      (      x������ � �      )      x������ � �      �   =   x�3�tN���4�2�t�M���9}SSK2�ҁlN�܂���ļ ϔ3$�8Ȉ���� �[�      �   b  x����n�0 ��~�����`@�a��2��uVc^l�Ά��'�kk��鐜H0�I���ao�/��e!P��
��1�@ۍ����>������_K����Wu~��:�,��bW=���|��u�>T~W�3�
���	� &1}젗*�	b��̲�o�����d�"�,�h�f���Uw�
Xm�_��m�nʏu����FQ�%�]gͯ�o�Om[�����#Q�q��Em��P�Dې����#m�z7�c6}��yo�שM�	��3����z�l��%�$fUH��&�:�3f�������qR9��M�2��i���b�n2\����t|꞉�37���O�#�$7f)��}]?���"p�?sCKP��)͵VK�d�>���qg}��#���̝R:�����RG8'�/���w�O/�e���t�;��!m�R��Y}t]�g����3��7�B�UK�d۬>jK�k�禮�?žd��<7t|� �P� _J%�f��$96��5��n��쯻fw?\����/�R ���q0H�[	ri��\�"}vy ��/�b��0y9"&�	w]�>�����S�2#�\�R�и�	�atw_��j��X1�      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�0���S��h$ْ|+ͥ�l{XXz�Ө8���B��+;i7N�Ҥ��`�xf<��!��ʔ0���5\����Ul���nZ��yoj�n��֐��D3va�!g�<�C�r[�-O�#I0>��
]�(��D`�-&J1N�^�LQ�(�	��Q@VP���١//h^��<BB:�t��ܷ��olx=	|�V�]u�{��\@��8�8E�q��T9'�`��`�>��B���U�K�<$�ߡ����@��T籌ާ��%Q�Dz�
~t VӜ����;�Jr���~�qɃ�l�/��k]�U��nw��~�l�<_����n f)��gb������O-8��2��d�8�v��4����m�
n��g���NlwL�n�� ��j��O'���	�;f�6�7r�1���Kq��*Q�<�J�Of��.���iJ�]'3UZ�j�*�bUo��i��;�b1ء��P�I��B�L��;�1��f �^�Z      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �     x��WMs�8=+��wVB�j}���b+U�@U`�p�m�x��S�YB�����BHf�L\.Hv����S��m�쇾YO��_�U�w�t�Z�����s1�<!�~Τ�"n U��!^�:�R�ʸ�)ٻ��]@��8H�� �e�c<�z���+��@Z�S�2DF��I�狳4R=R��.&ur��Jr�6V�f����ƛ⸫�q��wm��eW���./�;�*�tAZ!ɐ��!�lv�8�eZݔ��ħ��<�p!Þ�*�}����u�Lb�^��,��� !Ǟ�C�.���/���>s0ۮNJi�ⶔ�k�*ަ�8Iˏm���,�|�ǤW*�R�M #�#B��&���?�ώg�R���ۇ�� ���L�望�r���������G�$.�[j��!������Bg�I�8���Q*'�r�b�D��%B�(���ݝ(�Qj-r�筿�fC��x��j2�l"�J��ʪ�]�h�T]Ƙj�~�ۍ�]�rʚ��Ұ�Y��}׮�.@ ����ˌ�x�/TJ�W�u�ƒ���a����� �I��
	c AA�I��WL���V��ş�f;�E�<��fD27|��Nv�QA��f����{���}�(������	n�����[�	?P�y�����a���U��ݫ�� �c�Ce�dV�ߕ�P�y�w�ϐ��,g�!F*���f�|}��f�~�'ʆ7'��U74^��c�|��'�9T��&j'�!�#�B�#;N6;��������/�      �      x������ � �      �      x������ � �      �      x������ � �      �   s  x��VKk�0>k���2�ь$��C!-��&ٖ[��M�GCR��+{w'��qC[(���i�{��}�����8��92�FY�$ҍ��Rl�H�C�
���eJE%A�NR�/%@����}���ovױ(���/�[?���z��/o��,�*-?��*��V���$YfY@A�Ƴ��T�I����B-!TN�ZV�zٚ�Z��C��5dZ�c�"ZUWҡk��Z7���GS��d��!)��m�#�Bע2U��*ӫ,�W�oBsoi����Y��n��{��[6��fu����_}�vT�c��s�R�D�M�.G�q`f�׋�ډի�+��QH=�G.�ɑu$x/4���K�P�V�A�|������.6~�]���{���J�9v�F���~q��w���4�nv�YԘ�C�0��*��f�N�5���(�	=�X.l�F���=c@�b[m?o���OY��&�#��23͞�SͶ���&�g�S��A�~���Q��y{j�c�KU�5f4�ܡ��<�$g�z#&��}��8�hL$�aZ��-ޭ�����;�	��+M��8Yw����SX�����QE���ԡ~L0�
?��J�c������td*�����cV.��l�tk��      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x���_k�0ş�Oq7�=��%S
e�`�l{�/QG2���o?)mF�&4\,��E��s�(�1�>L���#�ͤ� �w��1q�������7�b���6B���.>��T���;����Ђb �ᩪ��Jb��o���
s�i]H�L�����RR�k�k!�p���w�v��DA�`\��`�k3���-�W�kD��������f�RUŖ�.�k���������EF��&P�\2AE��eZqr����ߞ��'��T������B_�0��b��ψk�\�9���jw�~�އ��n2!3Zy?���D������]?���䡟ô5:�9F�],�M���ԍ`!%Su���$R�tu�Ӯ;��`n� ф{ۚ�~l����5������:��7a�1=���t�۠�xƲ!�uI!B.���\�V��b�      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����n�0D��б=( %Y�ss	�E��r�Pk���4����}i��l^x�!�ά�g>�8���ف܉�������+��6-Vu^[ryEu��7}�V�+��X��
S��5yQg���v���m��l���z�M]��4Qt��Z£gdGr�}C��<��W�D8��a�9�8a"�h�p�����y9��%�~����Y7�"��~qkf�D[x
���^>Wއ�p̓��.�����5�x^FQ���)񃮪+�}�(~�u)��K\�Z��Qǃg"��y>�(���%~NUR,���1���(!�A1�v���1�d!fi��*԰��w���'bQth`?D�R`������)����J�Is�;x�!��_/�iJ&���cXY�����f�F��      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x���A�0@���� �NA;5.�Fb¦�14)4)������o�S��sqL�k<G2L����`�:S*S(Q��J�ey@]���+@	��d�O�5��-��)&#%t�北Yg��
n�X���dd}�V��l��c������L�h?�-4���ܐ!~~���      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�3��K-�4�4B##c]CC]C###+SK+S=K3cs�?*�2�t��+IL.IM��f��W�Z�Z�gL�>���Ĝ̴L�6b��r��� ����0���S�Wp�(-�[fF��=... ��C	      �      x������ � �      �      x������ � �      �      x������ � �      �   '  x�͘ێ�6�����P��L]��6��h
�&7�IY�x�@��Oߑ(iW9,�:ݬ%�򀄨of~�ؑm��=����m���K�Ʒ����H"M�C\K�B�,m�d�l�*��XsSǀ�����F+)8yBG����<m�_\�6�h�_�mgţrL��=��E*Aq�j-̸�+�g\P 
|�EP(�+�:m:�+���� � qXR�C 7o}q���Jc���:H�|������/�sʊ8�UHWH�;�;B޽�W���l�����<���=Q�\5yʑ�S0�
o�|����������*��c�2�	զ{�æ�.����g�/�R�P*W�a'G�Z���UM�M����^p�9XP��ٕ�6��6~9�����z6 �� u�0|���C�Zn+*@჆���B�L!ĦC(EP<�?x'E�c��TC\S���	�Sz'��8���s~<'Mg�⼐P0�s��ĘX���l�5y�wq��DX+�]sZ��TJ����3`J���r2Q@l#7b��c'|ĀV<���\1V0Wp�����A��zw��PS�u�~�e,&�L(��B,D�B����Y��N'>�Ob!Ln��(s��^i�,]^u���nc�e֒�<��x �����N�="A+����3�	�/6�g(j�����,]Ә��p9��綮A�a�#T���el���>�[�&)�l.f7j�%Pw�Wq�[)��)�e"�38���'�1�JFØҐrfISV�U:�S�&4�s��3�D��>�/0�1��ŕݹa�
�n���V� �V}���d݂μ`]�s��CA��2X��f���ka�~wn���#��z���0Ja]�$�U�J{Jn�B��* w(�cFjfN��	�9�W赿��$|X����K{�qQ��%1����Uړ}I�b�6����V�)o͘�r�[٧�L�S��1iew���Mƞ�.je�z)S3&�}������<I&z� ����D�@�JN|����L�̀��z,؞��O;��EH��D��4�#3 1=�'$fD�V<~����Af{&v�����l�-�w��LD�������M�;"A+�#���/���_���[߆�]�]�-�fML]^�����Ll��3�#�7��el�Yu���Lia�Z�J�C`��#V'��i�"��P/-A���Bʮ!U
sw�fA��W��?��1>������z�Y��κ��;7wH� �����j��헎҉�%����
L�����ʚԤ����Y���18w      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x���͊�0���S��ѯ-y74��2�t1P
�Qm%8�����Wv��Ih���^_��G��i�|H���6&i;�'c�u;x61�G?8�x��`#�u��}=A庶
s�k]J�Lɉ��⒔RR���BbD1e%�%�@H�E��k4�l9o��X�4��~�\�QՂ65E8�=�����|
�0�lf=��`u�����ϵ��c�q�Q~���VЪ��1z��ܯZ^W\�Z�PI�}��I��ONf�i4��:��ͿwtCh.��-�ϵ\$rn*³�����e�"5���4hcc7�h�;�C�$�ϷЯ�#��~N����`��zL �]9��	|�n�A���:���N�7f����W���]"*D�S��J�'INUz�|4/o2�ϖ5|�����hvz�h«�L��U���{������W��fo\��vo�r.B�3=r�$_97��/UQ? ��g8      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x��ϱ�@D��TA���^��"��;�/� �|���$H��d�ﾷ��5����"�<��G0��M���d��qׁ�I�}�I�ZR<�d�Ի����r�(�{Z��3�q�)��K�lt��)\��ƛ5�������,�z�Q@      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x����n�0Eg�+�8�{vl?o�,�*XY��A!X!��!�V�Vu����
Y}d9�:ORz�\��|��p��X�:ΰ�K_�\d,;���QG6�"::��aG�]D#Y�(]4�Y��	)&�[�����~��`C~Y������i�/��j�3����D�д��!��E���������br]����طM�|��dR      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�0����8/`�s,ٖ��rі��1��%8�Q�A����6H�j��α�O�,슴s��yBL�w��6��SH^�!9��������:���B���:�l%PR�D�U�Q�[�1��q�+��8��5)&�\"g��ZpVK��*x&�w�U��[�њ�����C<�r4���Dgξ�t[��)$.���4��֨�n�����+,�_�?��`�_Ǆ���0�����bF����$�T�n�y�j:�V	N�po��;9��`�\��b͠��Q�M޺x}��{[O�t�6�(͏0&x4c4�m���&��i�WC� DX��'�mw�F�5���M�kH>ǰW	P��L�VK������t������N~'����bo������ig���D�ۭ��`�O������e�Y�L��4WZr&eK��E��++���Z�      �      x������ � �      �      x������ � �      �      x������ � �           x����n�8��7O�� R�SV����I3���t�%ѱR����o�K�N�X����Ңx�Ï��C�n�����ڔU��5��%x�Z�p���v��)���Sc;
�%�I�NcH�"Rp�0��ŵ)�Ų���~�\4��}j�����/��յXS��DR�n%'�*�'7i"���2��(#4]��<�LG"Id*��'��gLc�M]��
,����`�+"B*�2(h%��	A)��ō��d,�eo������GYU��§�^�F��R�	W�cYJ
Yp��L�<NKu�����������롎��uH%���H�	
b�� �P��4�^-�*�$}�'���l�e��w���'��\꜑���r���%q����f����nL=��C��,]�\���a�$���
p��+[�no�$��qc̽�V�'�����r�o
�͜˨�4�T�$�+CV2�+%e�'G@�f�����f��/�Wq H@�q'��ꑀ۵�,�|�b8��
~sw�����U�
Xg�gyF4�+�P���Ȍ��q�$غ�vQV���H�{W�KWy GB���:�������}U?[M�h���nDH���B�o�gTq��S�� )M9a��ix��#�((̏���1���w���bv30S,F�ʂ����#�+����p�����<6.��Z�o�4�ia�<��2�H�5%Z�$V���EC[�?Je�q��Ɨ�ҕg��!8�ZAp�t�6lqg�fۿ�L)���L�ύ���0�L�v:D��1���TV�v,i��p��3XK!،�sl�`�����R����Է�ao;S��쪶���wp�3TÇ�׈?ғ��S���k�G���l}?��Fx�������E\����@0A�;C��F�Լ�m�mn*�O�k4��k�MUM�V�RU͠��J(��g�6����N2�Ӂ�&�g�*M��'[t7���Km�����q�-��;:M;�GIH;8��O�m�am�Ƭ#D�l��|up8}+(���C0F�g>9!�'�� N�HM90�{�l&��p��f�G�
{Ϩ|��a�!2�a!B?Ω�M���j�CcmK?�f�o���0D1A� cH�{d�}?�4�GK�O���	�J�P������!H칡B?!ן�D�t(g�ĵ�ϡ�<1�Ga�0O�"�(BD¹�~B����B2DO��6��,G�;W���/�
������8�\�0Ma�]�m�'��+������a&��&:�f�9�Ӊ�����%�2�_�<��,�X�_����-:;;�	-�W             x������ � �            x������ � �            x������ � �      $   Z  x���An�0е�sf$����A]�)�v�eQ�Q�$Oz�z���s�>���U[��Xv���#������!pE�A�8���?���@��y�v?k�	͗%�����J��۴�W�%��@1:�%B+5���y�m��g�������y���pU�)��=��x�&�I������_>�uw�8�����@#��ѡ�1ޛ�e�=*ڶ�߇�B�����f�<f`�
��qJ�r�滴m��ߦ�~���,ym�M�ҍRv�0B������">��Ds��m������<_�m����d)`J����flLU<�c5/����⦋      "   �   x�3��K-�4�4B##c]CC]C###+SK+S=K3cs�?*�2�t��+IL.IM��f��W�Z�Z�gL�>���Ĝ̴L�6b��r��� ����0����w�(-�[eF��=... /B�      �   �  x���Ak�0����(�11�����R(�V]�EK�m�߸Є�b����o&�Ip�sw=.%�S9��s�f_&E��Zx�����n黇ۛ;_{ AM�X!���ݑ�I�h�x^X4�Ѱ��D��f���B$P��e(06��FF�2Z@%j�}X:B4� ���a"ð6kX62,˰@Y^9J�0�b� �A�6''H	�G>H*k��B�|ꃄ2oj)��?Hm&E���ɛZJ?���ɻ)��@��: ��R9m���� ��P*� H���!t�	.���{��a����1\]'Ӽg���XD��O�\���k<���/���r�˃����L`ޡ��v�UFھ�����`e5B��)#��Z��EQ� Q�c=      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   A  x����N�0���S�:%i�v�M�4ƴ	��RZ3"���)oO:��\)7�����S��y�ź��$"��i��Rd���*�p�M����P9��B��b�׆���ڰʸ�B�x@C�I���0̃����u�[7xV��w��\[7^"��8v��=;�Ǩ��+`�ؾ��;��p�L���2���^�m<蘀{D���7lGCw&%��켮�v�L%�`�:ĝL��X�<CF�ASFț�}n���P?����R4Z���P�?#���i��6g��v���rX9c�5;f���&c�����B-U�f���Q}Ҟ      �      x������ � �      �      x������ � �      �      x������ � �      �   d   x�3�����Sp�O�4202�54�54W00�24�20�32�0����!N���.#Nǜ��T���̒"4���d��rs:�')�,+��#B�O~9W� �`%      �   �   x��ͱ�0������-�D�ĕ�����4��3ɿ~�	.a~;^y�[�<6�AfR%D	�0SUN���uY@w�ʄ���6�1�����s��t�*h�֏P��������Ç�1������&�TJ���t�꒨л�R!��Z9s         �   x����m�@D�s3
'0�޷ �.,��L0uЅc'�P�����Q����#��C�x�&�L�z��,�x0}�a�N��J��' Ж\��=i���' �晵�,��'�� ��y�5�	��^�Q������x�F�4���~�B]񲉛e��y_p@]�����bZ0�p~p�����]���9g!J�\�׾���o��ܶ�	��z            x������ � �            x������ � �            x������ � �         �  x���͊�0���S�$��톆B���Ja6�X��&��C����i��3�1ha#��=GW�������/c��B���}��Cۡ�ծD�*d@�c,�ԝV�ٰ�]lQZh���Ra�6`�$`+�� ��n�44c�ڳ�m�"f�TNj"5P���80�R�u6��%�G&���8��3zh�n�h��}���7�_t�����mz���ʍ!ƜЎ"c��K� JhjͿ�0�9�>U�ڗ�傝�qW��������y�����+��NJ��*��Y��ml�MR��gdr����55j�6^(�X�`��O�H��[���zZ�� � ©���^�\�`�h��S�	5~�y��s	�������(G9�C��[A���j��^p_�ں��|��/�ۡ{�7}��.�&<��fB��8�lQ�M߶�@�<mB�iZ.t����2"�5���4hR�U��111&���	����£U��|!�� 6� p¹1�,$y�� ��b            x������ � �            x������ � �      	      x������ � �         A  x�Œ�mC1Dky�,@��(��� �%n\������I�Ā]
 �x�ӐFU��n�@j)��<{�M{�F�B��2T�վ?%<�MFm	Ηy���?Rz{M�� ɺ�����mk`l2��so�����E�;%��]�0�T��}Z[\��_g�Ā���~�~$/�|e㵿?�-���kŒ4�{�� ���bf����b�[09U��_�4�훺A��hS7��0q�;��o]�P�k|K8��1�����
���յj=��\�l-����Zg��F���`8��Q�f��14*"�C���M����9po����	�P��            x������ � �            x������ � �            x������ � �           x����j�0���S�$Y���=�1莽؉=YmW��/�F����������S��#C!/ �&��*`��g�*E� PAj(qZG��m��Fv@-��q`��k�ɘ݋AC�M=۷�?k	�}�����&z�<p\�)��Q�s}ϋ���y�Ѿ>���d��~��r�J�r�TA�3$QUvS�^��dI'�>IoΜ��S�O��\���N�<b)cem��G禒s�lMt�J���e-��_{�S���~�w]�h���            x������ � �            x������ � �            x������ � �         �  x����n�F����� �3��wF��)Ҥ@r��h�(M
��~��RI,+�d)��]P����9��|uc��[�#lU�XXa�0�k{��+�ו߲�j�u�^��a�������d��Ի����ϻ'r��@�@9.��R#�\�Vެ�?
�">ז��B�:p:� @
U䣾��w�}xF;i�v��b���E��	U
�5W'���eme>��ݮ�C[)Q��Zv�UQJ'��*�m�SF�5�L%E�һ�z���L�7�P���RA�9Nڒ�B���:!�2���ߎ�vi�BG��p���R
ͭJ5d&���]��3ʭb��)�h�(Qn������	u�mA[2��Qy7����:�8�dB/j�:��μi����ؑ��8M4!e�Y�gN3md���"�R9�K�'ՙ�gO�ba�б$�x���Dgi�kU�R.K�y�Th�0	��?F\�nJP�0\:��3���̭��%2IJG"Ƨ5��$�iV����&���@�$��x�Yї��u>��OQ��J&ӝgZ���B2�q�xI%Q�'�|��8��-�r�4R�4�Ӎ�Tи��7��l1�`�2X�P���&��ڡﶇ���c�O�G�"Fo�&�>ɧU-����G}��\���C[J>��p���G��z>]�|��v8�B$�>:8�j��]!�X7�mxrB��5M�oq؍��t���/���c�S2c0Z���4M�x�&�ON@fڝZ�gm0���{��g����M�ݏ�Ů�n�u=�܅�!�[�������C�eC�~;�C�g�:gy�($*�f�����~s�������)] 5��i������W���z�g�:�9�U���WQ�����W�?���'e�g2�mA�t�dF�O�eB
�nIL&��(�$N�wm�x	D��JaL�(M4� 3�I:��H�� 5ᴲD��H2��<�Ӈr�^��fP            x������ � �            x������ � �            x������ � �         q   x�mͻ�0�����R`aEaꈄBti�;ʃ�ݳ���B��ě��Dq��)��Ư����,��Dw���V3R7'�q�gzXA���m��B��kC����]޿灙�\�AF            x������ � �     