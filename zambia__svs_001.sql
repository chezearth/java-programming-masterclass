--
-- PostgreSQL database dump
--

-- Dumped from database version 11.1 (Ubuntu 11.1-1.pgdg18.04+1)
-- Dumped by pg_dump version 11.1 (Ubuntu 11.1-1.pgdg14.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: zambia__svs_001; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA zambia__svs_001;


--
-- Name: __he_obj_change_type__; Type: TYPE; Schema: zambia__svs_001; Owner: -
--

CREATE TYPE zambia__svs_001.__he_obj_change_type__ AS ENUM (
    'create',
    'update'
);


--
-- Name: __he_sync_obj_change_type__; Type: TYPE; Schema: zambia__svs_001; Owner: -
--

CREATE TYPE zambia__svs_001.__he_sync_obj_change_type__ AS ENUM (
    'create',
    'update',
    'delete'
);


--
-- Name: __he_delete_table_or_view__(character varying); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.__he_delete_table_or_view__(objectname character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$ DECLARE    isTable integer;    isView integer;    isMatView integer; BEGIN    SELECT INTO isTable count(*) FROM pg_tables where tablename=objectName and schemaname = 'zambia__svs_001';    SELECT INTO isView count(*) FROM pg_views where viewname=objectName and schemaname = 'zambia__svs_001';    SELECT INTO isMatView count(*) FROM pg_matviews where matviewname=objectName and schemaname = 'zambia__svs_001';    IF isTable = 1 THEN        execute 'DROP TABLE IF EXISTS "zambia__svs_001".' || objectName;        RETURN;    END IF;    IF isView = 1 THEN        execute 'DROP VIEW IF EXISTS "zambia__svs_001".' || objectName;        RETURN;    END IF;    IF isMatView = 1 THEN        execute 'DROP MATERIALIZED VIEW IF EXISTS "zambia__svs_001".' || objectName;        RETURN;    END IF;    RETURN; END; $$;


--
-- Name: __he_sync_obj_delete_after__(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.__he_sync_obj_delete_after__() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ begin        if OLD."_tx_id_" = txid_current() then          delete from "zambia__svs_001"."__he_sync_obj_change__"              where "tx_id" = txid_current()              and "object_uuid" = OLD."_id_";          if OLD."_change_type_" <> 'create'::"zambia__svs_001"."__he_obj_change_type__" then                       insert into "zambia__svs_001"."__he_sync_obj_change__"("seq", "change", "object_name", "object_uuid", "tx_id")              values(nextval('zambia__svs_001.__he_sync_change_seq__'), 'delete'::"zambia__svs_001"."__he_sync_obj_change_type__", TG_TABLE_NAME, OLD."_id_", txid_current());          end if;     else                   insert into "zambia__svs_001"."__he_sync_obj_change__"("seq", "change", "object_name", "object_uuid", "tx_id")              values(nextval('zambia__svs_001.__he_sync_change_seq__'), 'delete'::"zambia__svs_001"."__he_sync_obj_change_type__", TG_TABLE_NAME, OLD."_id_", txid_current());      end if;     return NEW;end; $$;


--
-- Name: __he_sync_obj_insert_after__(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.__he_sync_obj_insert_after__() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ begin      insert into "zambia__svs_001"."__he_sync_obj_change__"("seq", "change", "object_name", "object_uuid", "tx_id")      values(NEW."_change_seq_", 'create'::"zambia__svs_001"."__he_sync_obj_change_type__", TG_TABLE_NAME, NEW."_id_", NEW."_tx_id_");      return NEW;end; $$;


--
-- Name: __he_sync_obj_update_after__(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.__he_sync_obj_update_after__() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ begin      if OLD."_tx_id_" <> NEW."_tx_id_" then         insert into "zambia__svs_001"."__he_sync_obj_change__"("seq", "change", "object_name", "object_uuid", "tx_id")              values(NEW."_change_seq_", 'update'::"zambia__svs_001"."__he_sync_obj_change_type__", TG_TABLE_NAME, NEW."_id_", NEW."_tx_id_");      end if;     return NEW;end; $$;


--
-- Name: __he_sync_obj_update_before__(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.__he_sync_obj_update_before__() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ begin      if OLD."_tx_id_" <> txid_current() then          NEW."_tx_id_" = txid_current();          NEW."_change_type_" = 'update'::"zambia__svs_001"."__he_obj_change_type__";          NEW."_change_seq_" = nextval('zambia__svs_001.__he_sync_change_seq__');      end if;     return NEW; end; $$;


--
-- Name: avestockoutdurationitems_aggregation_executor_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.avestockoutdurationitems_aggregation_executor_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
	the_schema = 'zambia__svs_001';
	EXECUTE 'TRUNCATE ' || the_schema || '.heliumonlyaveragestockoutdurationitems';
	EXECUTE 'INSERT INTO ' || the_schema || '.heliumonlyaveragestockoutdurationitems ( _id_, _tstamp_, arvCount, tbCount, vaccCount, location, heliumonlyaveragestockoutdurationitems_province_fk, heliumonlyaveragestockoutdurationitems_district_fk, heliumonlyaveragestockoutdurationitems_subdistrict_fk, heliumonlyaveragestockoutdurationitems_facility_fk)
	SELECT _id_, _tstamp_, arvCount, tbCount, vaccCount, location ,province_uuid, district_uuid, subdistrict_uuid, facility_uuid FROM ' || the_schema || '.averagestockoutdurationitems_aggr_logic_view';
	RETURN 1;
END;
$$;


--
-- Name: clear_heliumonlynationalstockavailability(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.clear_heliumonlynationalstockavailability() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	DELETE FROM heliumonlynationalstockavailability;

	RETURN 1;
	END;
	$$;


--
-- Name: clear_lowandoverstockreport(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.clear_lowandoverstockreport() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	DELETE FROM heliumonlylowandoverstockreport;

	RETURN 1;
	END;
	$$;


--
-- Name: clear_successmatrixstockavailability(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.clear_successmatrixstockavailability() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	DELETE FROM SuccessMatrix_StockAvailabilityP;

	RETURN 1;
	END;
	$$;


--
-- Name: clear_successmatrixstockbycategory(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.clear_successmatrixstockbycategory() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	DELETE FROM SuccessMatrix_StockByCategory;

	RETURN 1;
	END;
	$$;


--
-- Name: clear_successmatrixtenoutofstock(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.clear_successmatrixtenoutofstock() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	DELETE FROM SuccessMatrix_TenOutOfStock;

	RETURN 1;
	END;
	$$;


--
-- Name: dpm_facility_stock_level_aggr_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.dpm_facility_stock_level_aggr_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
 the_schema = 'zambia__svs_001';
 EXECUTE 'TRUNCATE ' || the_schema || '.dpm_facility_stock_level_aggr_table';
 EXECUTE 'INSERT INTO ' || the_schema || '.dpm_facility_stock_level_aggr_table
 (_id_, _tstamp_,facilityname, facility_status, facility_status_colour,
   FacilityStatusOrder,_districtpharmacymanagerid,district,subdistrict)
  SELECT public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
  facilityname,
  facility_status, facility_status_colour,
  Facilitystatusorder,
  _districtpharmacymanagerid,
  district,
  subdistrict
  FROM ' || the_schema || '.dpm_facility_stock_level_aggr_logic_view';
 RETURN 1;
END;
$$;


--
-- Name: facility_stockupdate_add_star_for_non_deployed(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.facility_stockupdate_add_star_for_non_deployed() RETURNS integer
    LANGUAGE plpgsql
    AS $$

BEGIN

    with
    vfacilitydeploymentguide as (
      select f._id_, f.name as oldname,
          (case when su.stockupdate_facility_fk is null
            then 0 else 1 end) as su_count
      from zambia__svs_001.facility f
          left join
          (select distinct stockupdate_facility_fk
            from zambia__svs_001.stockupdate) su on f._id_ = su.stockupdate_facility_fk
    ),
    vfacilitydeploymentguidewithnewname as (
      select u.*, (case when u.su_count > 0
        then replace(u.oldname,' *','')
        else concat(replace(u.oldname,' *',''),' *') end) as newname
      from vfacilitydeploymentguide u
    )
    update zambia__svs_001.facility as f
    set name = u.newname
    from vfacilitydeploymentguidewithnewname u
    where f._id_ = u._id_
      and f.name != u.newname;

  RETURN 1;
END;
$$;


--
-- Name: facilitystock_sync_aggregation_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.facilitystock_sync_aggregation_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
	the_schema = 'zambia__svs_001';
	EXECUTE 'UPDATE ' || the_schema || '.facilitystock ' || ' SET ' || ' _id_ '||'='||'_id_'||' WHERE '||'_id_'|| ' IN'||' (SELECT _facilitystockid from FacilityStock_to_Sync Order By date_created ASC LIMIT 500)';
  DELETE FROM FacilityStock_to_Sync where _facilitystockid in (SELECT _facilitystockid from FacilityStock_to_Sync Order By date_created ASC LIMIT 500);
  RETURN 1;
END;
$$;


--
-- Name: funcextractsuccessmatrixdata(date, date); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.funcextractsuccessmatrixdata(startdate date, enddate date) RETURNS TABLE(registeredfacilities integer, reportingfacilities integer, numberofstockouts integer, numberofupdates integer)
    LANGUAGE sql
    AS $$

 with

 /* **************************************************************************************************** */
 /* ************************************ FOR AGGREGATION PURPOSES ************************************** */
 /* **************************************************************************************************** */

 facilityhierarchy as (
  SELECT  p._id_ as _provinceid, p.name as provincename,
    d._id_ as _districtid, d.name as districtname,
    sd._id_ as _subdistrictid, sd.name as subdistrictname,
    f._id_ as _facilityid, f.name as facilityname,
    f.*
  FROM facility f
    LEFT JOIN subdistrict sd ON sd._id_ = f.facility_subdistrict_fk
    LEFT JOIN district d ON d._id_ = sd.subdistrict_district_fk
    LEFT JOIN province p ON p._id_ = d.district_province_fk
  WHERE f.deleted = 'No'
    AND (lower(p.name) like lower('%@provincename%') OR left('@provincename',1)='@')
    AND p.name not in ('Training Demos')
 ),

 /* **************************************************************************************************** */
 /* ************************************** STOCK LEVEL AGGREGATION ************************************* */
 /* **************************************************************************************************** */

 /* Get from DSL history table? */
 qnationalstockupdates_source as (
  SELECT q.*
  FROM
 (
   SELECT
    row_number() over (partition by /*SVSA-1162*/ fh._facilityid, fs.facilitystock_stock_fk /**/ order by su._tstamp_ desc) as row,
    su._tstamp_ as _tstamp_,
    su.update_date + '2 hours'::interval as update_date,
    su._id_ as _id_,
    fh.provincename, fh.districtname, fh.subdistrictname, fh.facilityname,
    su.current_level as "stocklevel",


    s._id_ as _stockid, fh._provinceid, fh._districtid, fh._subdistrictid, fh._facilityid
   FROM facilityhierarchy fh
     JOIN facilitystock fs on (fs.facilitystock_facility_fk = fh._facilityid AND fs.deleted = 'No')
    LEFT JOIN stock s on (fs.facilitystock_stock_fk = s._id_)
    LEFT JOIN stockupdate su on (su.stockupdate_facility_fk = fh._facilityid AND fs.facilitystock_stock_fk = su.stockupdate_stock_fk)
   ) q
    where row = 1
 ),

 qsummary as (
   select
  (SELECT COUNT(distinct _facilityid)::integer FROM facilityhierarchy) AS registeredFacilities,
  (SELECT COUNT(distinct _facilityid)::integer FROM qnationalstockupdates_source WHERE update_date >= startdate::timestamp AND update_date < enddate::timestamp) AS reportingFacilities,
  (SELECT COUNT(distinct _facilityid)::integer FROM qnationalstockupdates_source where stocklevel = '0' and  update_date >= startdate::timestamp AND update_date < enddate::timestamp) AS numberOfStockouts,
  (SELECT COUNT(*)::integer FROM qnationalstockupdates_source   WHERE update_date >= startdate::timestamp AND update_date < enddate::timestamp) as numberOfUpdates
 )
 select * from qsummary;
$$;


--
-- Name: generate_availabledistrictstockpercentage(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_availabledistrictstockpercentage() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO SuccessMatrix_StockAvailabilityP
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level",
		province_fk , district_fk--, subdistrict_fk, facility_fk
	)
	SELECT
		public.uuid_generate_v4(), now(),
		result.districtname AS "name",
		result.all_districtstock_count,
		result.stockout_districtstock_count,
		result.stockavailability_percentage,
    result.level,
		result.province_id AS province_fk,
		result.district_id AS district_fk

	FROM
	  (
	  SELECT
	  	data_set.district_id,
	    data_set.province_id,
	  	data_set.districtname,
	  	data_set.all_districtstock_count,
	  	data_set.stockout_districtstock_count,
      data_set.level,
	  	CASE
	  		WHEN data_set.all_districtstock_count IS NOT NULL AND data_set.all_districtstock_count != 0 AND
	  		     data_set.stockout_districtstock_count IS NOT NULL AND data_set.stockout_districtstock_count != 0
	  		THEN ( ROUND( ( ( data_set.all_districtstock_count - data_set.stockout_districtstock_count ) * 100 ) / data_set.all_districtstock_count ) )::text || '%'
	  		ELSE '100%'
	  	END AS stockavailability_percentage
	  FROM
	  (
	    SELECT
        'District' AS level,
	    	district._id_ AS district_id,
	    	district.name AS districtname,
	      province._id_ AS province_id,
	    	COALESCE( SUM( facility_data.all_facilitystock_count ), 0 ) AS all_districtstock_count,
	    	COALESCE( SUM( facility_data.stockout_facilitystock_count ), 0 ) AS stockout_districtstock_count
	    FROM district
	    JOIN province ON district.district_province_fk = province._id_
	    JOIN
	    (

	  	  SELECT
	    		facility._id_ AS facility_id,
	    		facility.name AS facilityname,
	    		facility.facility_district_fk AS district_id,
	    		COUNT( DISTINCT all_alive_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS all_facilitystock_count,
	    		COUNT( DISTINCT stockout_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS stockout_facilitystock_count
	  	  FROM facility

        LEFT JOIN
  	    (
    	  	SELECT
    	  		materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
    	  		materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
    	  	FROM materializednationalstockupdates_levels_tableau_view

  	    ) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_

  	    LEFT JOIN
  	    (
    	  	SELECT
    	  		materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
    	  		materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
    	  	FROM materializednationalstockupdates_levels_tableau_view
    	  	WHERE materializednationalstockupdates_levels_tableau_view.stocklevel = '0'
  	    ) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_

	  	  WHERE facility.deleted = 'No'
	  	  GROUP BY facility._id_

	    ) AS facility_data ON facility_data.district_id = district._id_
	    GROUP BY district._id_, province._id_
	  ) AS data_set
	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_availablefacilitystockpercentage(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_availablefacilitystockpercentage() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO SuccessMatrix_StockAvailabilityP
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level",
		province_fk , district_fk, subdistrict_fk, facility_fk
	)
  SELECT
  		public.uuid_generate_v4(), now(),
  		result.facilityname AS "name",
  		result.all_facilitystock_count,
  		result.stockout_facilitystock_count,
  		result.stockavailability_percentage,
      result.level,
  		result.province_id AS province_fk,
  		result.district_id AS district_fk,
      result.subdistrict_id AS subdistrict_fk,
  		result.facility_id AS facility_fk


  	FROM
  	  (
  	  SELECT

  	  	data_set.facility_id,
  	  	data_set.facilityname,
  	    data_set.subdistrict_id,
  	    data_set.district_id,
  	    data_set.province_id,
  	  	data_set.all_facilitystock_count,
  	  	data_set.stockout_facilitystock_count,
        data_set.level,
  	  	CASE
  	  		WHEN data_set.all_facilitystock_count IS NOT NULL AND data_set.all_facilitystock_count != 0 AND
  	  		     data_set.stockout_facilitystock_count IS NOT NULL AND data_set.stockout_facilitystock_count != 0
  	  		THEN ( ( ( data_set.all_facilitystock_count - data_set.stockout_facilitystock_count ) * 100 ) / data_set.all_facilitystock_count )::text || '%'
  	  		ELSE '100%'
  	  	END AS stockavailability_percentage
  	  FROM
  	  (
  	    SELECT
        'Facility' AS level,
  	  	facility._id_ AS facility_id,
  	  	facility.name AS facilityname,
  	    subdistrict._id_ AS subdistrict_id,
  	    district._id_ AS district_id,
  	    province._id_ AS province_id,
  	  	COUNT( DISTINCT all_alive_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS all_facilitystock_count,
  	  	COUNT( DISTINCT stockout_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS stockout_facilitystock_count


  	    FROM facility

  	    JOIN subdistrict ON facility.facility_subdistrict_fk = subdistrict._id_
  	    JOIN district ON subdistrict.subdistrict_district_fk = district._id_
        JOIN province ON district.district_province_fk = province._id_


  	    LEFT JOIN
  	    (
    	  	SELECT
    	  		materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
    	  		materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
    	  	FROM materializednationalstockupdates_levels_tableau_view

  	    ) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_

  	    LEFT JOIN
  	    (
    	  	SELECT
    	  		materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
    	  		materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
    	  	FROM materializednationalstockupdates_levels_tableau_view
    	  	WHERE materializednationalstockupdates_levels_tableau_view.stocklevel = '0'
  	    ) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_

  	    WHERE facility.deleted = 'No'
  	    GROUP BY facility._id_, subdistrict._id_, district._id_, province._id_

  	  ) AS data_set
  	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_availableprovincestockpercentage(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_availableprovincestockpercentage() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO SuccessMatrix_StockAvailabilityP
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level",
		province_fk --, district_fk, subdistrict_fk, facility_fk
	)
	SELECT
		public.uuid_generate_v4(), now(),
		result.provincename AS "name",
		result.all_provincestock_count,
		result.stockout_provincestock_count,
		result.stockavailability_percentage,
    result.level,
		result.province_id AS province_fk
	FROM
	(
		SELECT
			data_set.province_id,
			data_set.provincename,
			data_set.all_provincestock_count,
			data_set.stockout_provincestock_count,
      data_set.level,
			CASE
				WHEN data_set.all_provincestock_count IS NOT NULL AND data_set.all_provincestock_count != 0 AND
				     data_set.stockout_provincestock_count IS NOT NULL AND data_set.stockout_provincestock_count != 0
				THEN ( ROUND( ( ( data_set.all_provincestock_count - data_set.stockout_provincestock_count ) * 100 ) / data_set.all_provincestock_count ) )::text || '%'
				ELSE '100%'
			END AS stockavailability_percentage
		FROM
		(
		  SELECT
      'Province' AS level,
			province._id_ AS province_id,
			province.name AS provincename,
			COALESCE( SUM( district_facility_data.all_districtstock_count ), 0 ) AS all_provincestock_count,
			COALESCE( SUM( district_facility_data.stockout_districtstock_count ), 0 ) AS stockout_provincestock_count
		  FROM province
		  JOIN
		    (
		    SELECT
			district._id_ AS district_id,
			district.name AS districtname,
			district.district_province_fk AS province_id,
			COALESCE( SUM( facility_data.all_facilitystock_count ), 0 ) AS all_districtstock_count,
			COALESCE( SUM( facility_data.stockout_facilitystock_count ), 0 ) AS stockout_districtstock_count
		    FROM district
		    JOIN
		    (

			  SELECT
				facility._id_ AS facility_id,
				facility.name AS facilityname,
				facility.facility_district_fk AS district_id,
				COUNT( DISTINCT all_alive_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS all_facilitystock_count,
				COUNT( DISTINCT stockout_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS stockout_facilitystock_count
			  FROM facility

        LEFT JOIN
        (
          SELECT
            materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
            materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
          FROM materializednationalstockupdates_levels_tableau_view

        ) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_

        LEFT JOIN
        (
          SELECT
            materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
            materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
          FROM materializednationalstockupdates_levels_tableau_view
          WHERE materializednationalstockupdates_levels_tableau_view.stocklevel = '0'
        ) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_
			  WHERE facility.deleted = 'No'
			  GROUP BY facility._id_

		    ) AS facility_data ON facility_data.district_id = district._id_
		    GROUP BY district._id_

		  ) AS district_facility_data ON district_facility_data.province_id = province._id_
		  GROUP BY province._id_

		) AS data_set
	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_availablesubdistrictstockpercentage(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_availablesubdistrictstockpercentage() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
		SET search_path = zambia__svs_001;
	INSERT INTO SuccessMatrix_StockAvailabilityP
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level",
		province_fk , district_fk, subdistrict_fk--, facility_fk
	)
  SELECT
		public.uuid_generate_v4(), now(),
		result.subdistrictname AS "name",
		result.all_subdistrictstock_count,
		result.stockout_subdistrictstock_count,
		result.stockavailability_percentage,
    result.level,
		result.province_id AS province_fk,
		result.district_id AS district_fk,
		result.subdistrict_id AS subdistrict_fk


	FROM
	  (
	  SELECT
	  	data_set.subdistrict_id,
	  	data_set.subdistrictname,
	    data_set.district_id,
	    data_set.province_id,
	  	data_set.all_subdistrictstock_count,
	  	data_set.stockout_subdistrictstock_count,
      data_set.level,
	  	CASE
	  		WHEN data_set.all_subdistrictstock_count IS NOT NULL AND data_set.all_subdistrictstock_count != 0 AND
	  		     data_set.stockout_subdistrictstock_count IS NOT NULL AND data_set.stockout_subdistrictstock_count != 0
	  		THEN ( ROUND( ( ( data_set.all_subdistrictstock_count - data_set.stockout_subdistrictstock_count ) * 100 ) / data_set.all_subdistrictstock_count ) )::text || '%'
	  		ELSE '100%'
	  	END AS stockavailability_percentage
	  FROM
	  (
	    SELECT
        'SubDistrict' AS level,
	    	subdistrict._id_ AS subdistrict_id,
	    	subdistrict.name AS subdistrictname,
	      district._id_ AS district_id,
	      province._id_ AS province_id,
	    	COALESCE( SUM( facility_data.all_facilitystock_count ), 0 ) AS all_subdistrictstock_count,
	    	COALESCE( SUM( facility_data.stockout_facilitystock_count ), 0 ) AS stockout_subdistrictstock_count
	    FROM subdistrict
	    JOIN district ON subdistrict.subdistrict_district_fk = district._id_
	    JOIN province ON district.district_province_fk = province._id_
	    JOIN
	    (

	  	  SELECT
	    		facility._id_ AS facility_id,
	    		facility.name AS facilityname,
	    		facility.facility_subdistrict_fk AS subdistrict_id,
	    		COUNT( DISTINCT all_alive_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS all_facilitystock_count,
	    		COUNT( DISTINCT stockout_facilitystocks.materializednationalstockupdates_levels_tableau_view_id ) AS stockout_facilitystock_count
	  	  FROM facility

	      LEFT JOIN
	    (
  	  	SELECT
  	  		materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
  	  		materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
  	  	FROM materializednationalstockupdates_levels_tableau_view

	    ) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_

	    LEFT JOIN
	    (
  	  	SELECT
  	  		materializednationalstockupdates_levels_tableau_view._id_ AS materializednationalstockupdates_levels_tableau_view_id,
  	  		materializednationalstockupdates_levels_tableau_view._facilityid AS facility_id
  	  	FROM materializednationalstockupdates_levels_tableau_view
  	  	WHERE materializednationalstockupdates_levels_tableau_view.stocklevel = '0'
	    ) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_
	  	  WHERE facility.deleted = 'No'
	  	  GROUP BY facility._id_

	    ) AS facility_data ON facility_data.subdistrict_id = subdistrict._id_
	    GROUP BY subdistrict._id_, district._id_, province._id_
	  ) AS data_set
	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_districtstockbycategory(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_districtstockbycategory() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO SuccessMatrix_StockByCategory
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level", category,
		province_fk , district_fk--, subdistrict_fk, facility_fk
	)
	SELECT
		public.uuid_generate_v4(), now(),
		result.districtname AS "name",
		result.all_districtstock_count,
		result.stockout_districtstock_count,
		result.stockavailability_percentage,
    result.level,
    result.category,
		result.province_id AS province_fk,
		result.district_id AS district_fk

	FROM
	  (
	  SELECT
	  	data_set.district_id,
	    data_set.province_id,
	  	data_set.districtname,
	  	data_set.all_districtstock_count,
	  	data_set.stockout_districtstock_count,
      data_set.level,
      data_set.category,
	  	CASE
	  		WHEN data_set.all_districtstock_count IS NOT NULL AND data_set.all_districtstock_count != 0 AND
	  		     data_set.stockout_districtstock_count IS NOT NULL AND data_set.stockout_districtstock_count != 0
	  		THEN ( ROUND( ( ( data_set.all_districtstock_count - data_set.stockout_districtstock_count ) * 100 ) / data_set.all_districtstock_count ) )::text || '%'
	  		ELSE '100%'
	  	END AS stockavailability_percentage
	  FROM
	  (
	    SELECT
        'District' AS level,
	    	district._id_ AS district_id,
	    	district.name AS districtname,
	      province._id_ AS province_id,
	    	COALESCE( SUM( facility_data.all_facilitystock_count ), 0 ) AS all_districtstock_count,
	    	COALESCE( SUM( facility_data.stockout_facilitystock_count ), 0 ) AS stockout_districtstock_count,
        facility_data.category
	    FROM district
	    JOIN province ON district.district_province_fk = province._id_
	    JOIN
	    (
        SELECT

        		facility._id_ AS facility_id,
        		facility.name AS facilityname,
        		facility.facility_district_fk AS district_id,
        		COUNT( DISTINCT all_alive_facilitystocks.facilitystock_id ) AS all_facilitystock_count,
        		COUNT( DISTINCT stockout_facilitystocks.facilitystock_id ) AS stockout_facilitystock_count,
        		stringgroup.value AS category

        	FROM facility
        	JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
        	JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
        	JOIN stringgroup ON stock.stock_stringgroup_fk = stringgroup._id_
        	JOIN
        	(
        		SELECT
        			facilitystock._id_ AS facilitystock_id,
        			facilitystock.facilitystock_facility_fk AS facility_id,
        			facilitystock.facilitystock_stock_fk AS stock_id
        		FROM facilitystock
        		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

        		WHERE facilitystock.deleted = 'No'
        	) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_ AND all_alive_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk

        	LEFT JOIN
        	(
        		SELECT
        			facilitystock._id_ AS facilitystock_id,
        			facilitystock.facilitystock_facility_fk AS facility_id,
        			facilitystock.facilitystock_stock_fk AS stock_id
        		FROM facilitystock
        		LEFT JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

        		WHERE facilitystock.deleted = 'No' AND facilitystock.stock_out = 'Yes'
        	) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_ AND stockout_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk


        	WHERE facility.deleted = 'No'
        	GROUP BY facility._id_, category

	    ) AS facility_data ON facility_data.district_id = district._id_
	    GROUP BY district._id_, province._id_, category
	  ) AS data_set
	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_facility_product_status(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_facility_product_status() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE Counter INT;
DECLARE the_schema text;
DECLARE concatQuery text;
BEGIN
	the_schema = 'zambia__svs_001';
	--the_schema = 'ndoh_001';

 --Remove old generated data
 --EXECUTE 'DELETE FROM ' || the_schema || '.__facilityproductstatusviewoutput__ WHERE _tstamp_ < (current_timestamp - interval ''1 hours'')';
 --EXECUTE 'DELETE FROM ' || the_schema || '.__facilityproductstatusviewoutput__';
 --Jev Prentice (2016-02-17)
   EXECUTE 'TRUNCATE ' || the_schema || '.__facilityproductstatusviewoutput__;';

 --Increment the counter stored in the configuration table by 1
 EXECUTE '(SELECT (value::INT + 1) FROM ' || the_schema || '.Configuration WHERE Key = ''product_status_view_update_counter'' LIMIT 1)'
	INTO Counter;

 --Generate new data
 EXECUTE 'INSERT INTO ' || the_schema || '.__facilityproductstatusviewoutput__ ( _id_, _tstamp_, facility_name, priority, icon, code, mobile, gps_longitude, gps_latitude, dataset, facilityproductstatusviewoutput_facility_fk)
    SELECT _id_, _tstamp_, facility_name, priority, icon, code, mobile, gps_longitude, gps_latitude, '||Counter||', facilityproductstatusview_facility_fk FROM ' || the_schema || '.FacilityProductStatusView';

 --Increment the dataset counter(used to retrieve the latest generated batch)
 EXECUTE 'UPDATE ' || the_schema || '.Configuration
 SET Value = '||Counter||'
 WHERE Key = ''product_status_view_update_counter''';

 --Return latest dataset counter
 RETURN Counter;--EXECUTE '(SELECT value::INT FROM ' || the_schema || '.Configuration WHERE Key = ''product_status_view_update_counter'' LIMIT 1)::INT';
END;
$$;


--
-- Name: generate_facility_stockupdate(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_facility_stockupdate() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
   the_schema = 'zambia__svs_001';

 --Remove old generated data
 --EXECUTE 'insert into' scheduledeventlog (_id_,_tstamp_,functionname,outcome,startdatetime,enddatetime) values (public.uuid_generate_v4() ,now(),'Aggregate Average Stockout Items','Done',now() - '2 hours'::interval,now() - '2 hours'::interval);
 --EXECUTE 'DELETE FROM ' || the_schema || '.__facilitystockupdateoutput__ WHERE _tstamp_ < (current_timestamp - interval ''1 hours'')';
 	EXECUTE 'DELETE FROM ' || the_schema || '.__facilitystockupdateoutput__';
   --EXECUTE 'DELETE FROM ' || the_schema || '.__facilitystockupdateoutput__ WHERE _tstamp_ < (current_timestamp - interval ''2 minutes'')';

 --Increment the counter stored in the configuration table by 1
 --EXECUTE '(SELECT (value::INT + 1) FROM ' || the_schema || '.Configuration WHERE Key = ''product_stockupdate_view_update_counter'' LIMIT 1)'
--	INTO Counter;

 --Generate new data
EXECUTE 'INSERT INTO ' || the_schema || '.__facilitystockupdateoutput__ (
	_id_,
	_tstamp_,
	low_stock,
	stock_out,
	total,
	min,
	max,
	low_stock_time,
	stock_out_time,
	low_stock_resolved_time,
	stock_out_resolved_time,
	stock_out_reported,
	barcode,
	deleted,
	facilitystock_id,
	facilitystock_facility,
	facilitystock_stock,
	facilitystock_lowstock,
	facilitystock_stockout
)
   SELECT
		public.uuid_generate_v4(),
		_tstamp_,
		low_stock,
		stock_out,
		total,
		min,
		max,
		low_stock_time,
		stock_out_time,
		low_stock_resolved_time,
		stock_out_resolved_time,
		stock_out_reported,
		barcode,
		deleted,
		facilitystock_id,
		facilitystock_facility,
		facilitystock_stock,
		facilitystock_lowstock,
		facilitystock_stockout
   FROM ' || the_schema || '.__facilitystocktoupdateview__ limit 3000';

 --Increment the dataset counter(used to retrieve the latest generated batch)
 --EXECUTE 'UPDATE ' || the_schema || '.Configuration
 --SET Value = '||Counter||'
 --WHERE Key = ''product_stockupdate_view_update_counter''';

 --Return latest dataset counter
 --RETURN Counter;--EXECUTE '(SELECT value::INT FROM ' || the_schema || '.Configuration WHERE Key = ''product_status_view_update_counter'' LIMIT 1)::INT';

   RETURN 0;
END;

$$;


--
-- Name: generate_facilitystockbycategory(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_facilitystockbycategory() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO SuccessMatrix_StockByCategory
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level", category,
		province_fk , district_fk, subdistrict_fk, facility_fk
	)
  SELECT
		public.uuid_generate_v4(), now(),
		result.facilityname AS "name",
		result.all_facilitystock_count,
		result.stockout_facilitystock_count,
		result.stockavailability_percentage,
    result.level,
    result.category,
		result.province_id AS province_fk,
		result.district_id AS district_fk,
    result.subdistrict_id AS subdistrict_fk,
		result.facility_id AS facility_fk


	FROM
	  (
	  SELECT

	  	data_set.facility_id,
	  	data_set.facilityname,
	    data_set.subdistrict_id,
	    data_set.district_id,
	    data_set.province_id,
	  	data_set.all_facilitystock_count,
	  	data_set.stockout_facilitystock_count,
      data_set.level,
      data_set.category,
	  	CASE
	  		WHEN data_set.all_facilitystock_count IS NOT NULL AND data_set.all_facilitystock_count != 0 AND
	  		     data_set.stockout_facilitystock_count IS NOT NULL AND data_set.stockout_facilitystock_count != 0
	  		THEN ( ( ( data_set.all_facilitystock_count - data_set.stockout_facilitystock_count ) * 100 ) / data_set.all_facilitystock_count )::text || '%'
	  		ELSE '100%'
	  	END AS stockavailability_percentage
	  FROM
	  (

	SELECT
		'Facility' AS level,
		facility._id_ AS facility_id,
		facility.name AS facilityname,
		subdistrict._id_ AS subdistrict_id,
		district._id_ AS district_id,
		province._id_ AS province_id,
		COUNT( DISTINCT all_alive_facilitystocks.facilitystock_id ) AS all_facilitystock_count,
		COUNT( DISTINCT stockout_facilitystocks.facilitystock_id ) AS stockout_facilitystock_count,
		stringgroup.value AS category

	FROM facility

	JOIN subdistrict ON facility.facility_subdistrict_fk = subdistrict._id_
	JOIN district ON subdistrict.subdistrict_district_fk = district._id_
	JOIN province ON district.district_province_fk = province._id_
	JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
	JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
	JOIN stringgroup ON stock.stock_stringgroup_fk = stringgroup._id_
	JOIN
	(
		SELECT
			facilitystock._id_ AS facilitystock_id,
			facilitystock.facilitystock_facility_fk AS facility_id,
			facilitystock.facilitystock_stock_fk AS stock_id
		FROM facilitystock
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

		WHERE facilitystock.deleted = 'No'
	) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_ AND all_alive_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk

	LEFT JOIN
	(
		SELECT
			facilitystock._id_ AS facilitystock_id,
			facilitystock.facilitystock_facility_fk AS facility_id,
			facilitystock.facilitystock_stock_fk AS stock_id
		FROM facilitystock
		LEFT JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

		WHERE facilitystock.deleted = 'No' AND facilitystock.stock_out = 'Yes'
	) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_ AND stockout_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk


	WHERE facility.deleted = 'No'
	GROUP BY facility._id_, subdistrict._id_, district._id_, province._id_, category

	  ) AS data_set
	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_heliumonlyfacilitystatus(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_heliumonlyfacilitystatus() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM heliumonlyfacilitystatus;

	INSERT INTO heliumonlyfacilitystatus
	(
		_id_, _tstamp_, name, code, mobile, latitude, longitude, date_created,
		icon, description, facility_fk, province_fk, district_fk, subdistrict_fk
	)
	/*SELECT
		heliumonlynationalstockavailability.heliumonlynationalstockavailability_stockupdate_fk AS _id_, now() AS _tstamp_,
		facility.name, facility.code, facility.mobile, facility.gps_latitude, facility.gps_longitude, facility.date_created,
		CASE
			WHEN COUNT(facility._id_)::integer = 0 THEN 'vs_green'::text
			WHEN COUNT(facility._id_)::integer BETWEEN 1 AND 5 THEN 'vs_yellow'::text
			WHEN COUNT(facility._id_)::integer BETWEEN 6 AND 10 THEN 'vs_brown'::text
			ELSE 'vs_red'::text END AS icon,
		'-'::text AS description, facility._id_ AS facility_id, province._id_ AS province_id,
		district._id_ AS district_id, subdistrict._id_ AS subdistrict_id--,
		--heliumonlynationalstockavailability.heliumonlynationalstockavailability_stockupdate_fk AS stockupdate_id
	FROM facility
	JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
	JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
	JOIN subdistrict ON facility.facility_subdistrict_fk = subdistrict._id_
	JOIN district ON subdistrict.subdistrict_district_fk = district._id_
	JOIN province ON district.district_province_fk = province._id_
	JOIN heliumonlynationalstockavailability
		ON heliumonlynationalstockavailability.heliumonlynationalstockavailability_facility_fk = facility._id_
		AND heliumonlynationalstockavailability.heliumonlynationalstockavailability_stock_fk = stock._id_
	WHERE heliumonlynationalstockavailability.stock_level = 0 and facilitystock.deleted='No' and facility.deleted='No' and stock.deleted='No'
	GROUP BY
		heliumonlynationalstockavailability.heliumonlynationalstockavailability_stockupdate_fk,
		facility.name, facility.code, facility.mobile, facility.gps_latitude, facility.gps_longitude, facility.date_created,
		facility._id_, subdistrict._id_, district._id_, province._id_;*/

    -- ADDED by A Thompson 23/05/17 - Above function only selected yellow because it was selecting on facility and no green(no stockout facilities) were selected
    WITH beta AS(

      SELECT public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
      location, facility.code AS code, facility.mobile AS mobile, facility.gps_latitude AS gps_latitude, facility.gps_longitude AS gps_longitude, facility.date_created AS date_created,
      	CASE
      		WHEN count(facility._id_)::integer   BETWEEN 1 AND 5  THEN 'vs_yellow'::text
      		WHEN count(facility._id_)::integer  BETWEEN 6 AND 10  THEN 'vs_brown'::text
      		ELSE 'vs_red'::text END AS icon,
      '-'::text AS description, facility._id_ AS facility_id, province._id_ AS province_id,
      		district._id_ AS district_id, subdistrict._id_ AS subdistrict_id
      FROM heliumonlynationalstockavailability
      	INNER JOIN facility ON facility._id_ = heliumonlynationalstockavailability.heliumonlynationalstockavailability_facility_fk
      	JOIN subdistrict ON facility.facility_subdistrict_fk = subdistrict._id_
      	JOIN district ON subdistrict.subdistrict_district_fk = district._id_
      	JOIN province ON district.district_province_fk = province._id_
      WHERE stock_level = 0
      GROUP BY location, code, mobile, facility.gps_latitude, facility.gps_longitude, facility.date_created, facility._id_, province_id, district_id, subdistrict_id
    ),

    theta AS(
      SELECT public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
      facility.name, facility.code AS code, facility.mobile AS mobile, facility.gps_latitude AS gps_latitude, facility.gps_longitude AS gps_longitude, facility.date_created AS date_created,
      'vs_green'::text AS icon,
      '-'::text AS description, facility._id_ AS facility_id, province._id_ AS province_id,
      		district._id_ AS district_id, subdistrict._id_ AS subdistrict_id
      FROM facility
      	LEFT JOIN beta ON beta.facility_id = facility._id_
      	JOIN subdistrict ON facility.facility_subdistrict_fk = subdistrict._id_
      	JOIN district ON subdistrict.subdistrict_district_fk = district._id_
      	JOIN province ON district.district_province_fk = province._id_
      WHERE beta.facility_id IS NULL AND deleted = 'No'
    )

    SELECT * FROM theta
    UNION
    SELECT * FROM beta
    ORDER BY name;

	SELECT 1 INTO result;
	RETURN result;
END;
$$;


--
-- Name: generate_heliumonlynationalstockavailability(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_heliumonlynationalstockavailability() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
result integer;
BEGIN
SET search_path = zambia__svs_001;
PERFORM clear_heliumonlynationalstockavailability();

INSERT INTO heliumonlynationalstockavailability
(
  _id_, _tstamp_,
  stockcategory,
  itemname,
  abbreviation,
  inventorycode,
  barcode,

  expiry_date,
  last_updatedate_timestamp,
  first_stockout_date,
  last_stock_update_datetime,
  stockout_reported_to_pdm,


  stock_level,
  stock_received,
  stock_lost,
  current_stock_out,

  days_since_first_stockout,
  days_since_last_update_timestamp,
  days_since_stockout_reported_to_pdm_timestamp,

  location,
  heliumonlynationalstockavailability_stock_fk,
  heliumonlynationalstockavailability_stockupdate_fk,
  heliumonlynationalstockavailability_facilitystock_fk,
  heliumonlynationalstockavailability_facility_fk,
  heliumonlynationalstockavailability_vendor_fk
)
WITH facilityhierarchy AS (
  SELECT p.name AS provincename,
  d.name AS districtname,
  sd.name AS subdistrictname,
  f._id_ AS _facilityid,
  f.name AS facilityname
  FROM facility f
  LEFT JOIN subdistrict sd ON f.facility_subdistrict_fk = sd._id_
  LEFT JOIN district d ON sd.subdistrict_district_fk = d._id_
  LEFT JOIN province p ON d.district_province_fk = p._id_
  WHERE f.deleted = 'No'::text
), qnationalstockupdates_new AS (
  SELECT q."timestamp",
  q.update_date,
  q.expiry_date,
  q.provincename,
  q.districtname,
  q.subdistrictname,
  q.facilityname,
  q.vendor,
  q.stockcategory,
  q.itemname,
  q.abbreviation,
  q.inventorycode,
  q.barcode,
  q."stock level",
  q."stock received",
  q."stock lost",
  q.first_stockout_date,
  q.stockout_reported_to_pdm,
  q._facilityid,
  q.stock_uuid,
  q.stockupdate_uuid,
  q.facilitystock_uuid,
  q.vendor_uuid,
  (date_part('epoch'::text, age(now(), COALESCE(q.first_stockout_date::timestamp with time zone, now()))) / (60 * 60 * 24)::double precision)::integer AS days_since_first_stockout,
  (date_part('epoch'::text, age(now(), q."timestamp"::timestamp with time zone)) / (60 * 60 * 24)::double precision)::integer AS days_since_last_update_timestamp,
  (date_part('epoch'::text, age(now(), q.stockout_reported_to_pdm::timestamp with time zone)) / (60 * 60 * 24)::double precision)::integer AS days_since_stockout_reported_to_pdm_timestamp,
  CASE
  WHEN COALESCE(q."stock level", '0'::text)::integer <> 0 THEN 0
  ELSE 1
  END AS current_stock_out
  FROM ( SELECT
    CASE
    WHEN su._tstamp_ >= '2014-10-09'::date THEN su._tstamp_
    ELSE su.update_date + '02:00:00'::interval
    END AS "timestamp",
    su.update_date + '02:00:00'::interval AS update_date,
    CASE
    WHEN COALESCE(su.expiry_date, now()::date) >= '1900-01-01'::date AND COALESCE(su.expiry_date, now()::date) <= '2100-01-01'::date THEN su.expiry_date
    ELSE NULL::date
    END AS expiry_date,
    fh.provincename,
    fh.districtname,
    fh.subdistrictname,
    fh.facilityname,
    v.name AS vendor,
    sg.value AS stockcategory,
    s.itemname,
    s.abbreviation,
    s.inventorycode,
    s.barcode,
    su.current_level AS "stock level",
    su.stock_received AS "stock received",
    su.stock_lost AS "stock lost",
    CASE
    WHEN COALESCE(su.first_stockout_date, now()::date::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone AND COALESCE(su.first_stockout_date, now()::date::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone THEN su.first_stockout_date
    ELSE NULL::timestamp without time zone
    END AS first_stockout_date,
    CASE
    WHEN COALESCE(su.stockout_reported_to_pdm, now()::date::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone AND COALESCE(su.stockout_reported_to_pdm, now()::date::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone THEN su.stockout_reported_to_pdm
    ELSE NULL::timestamp without time zone
    END AS stockout_reported_to_pdm,
    fh._facilityid,
    s._id_ AS stock_uuid,
    su._id_ AS stockupdate_uuid,
    fs._id_ AS facilitystock_uuid,
    v._id_ AS vendor_uuid
    FROM stockupdate su
    JOIN facilityhierarchy fh ON su.stockupdate_facility_fk = fh._facilityid
    JOIN facilitystock fs ON fs.facilitystock_facility_fk = fh._facilityid AND fs.facilitystock_stock_fk = su.stockupdate_stock_fk AND fs.deleted = 'No'::text
    JOIN stock s ON su.stockupdate_stock_fk = s._id_
    JOIN stringgroup sg ON s.stock_stringgroup_fk = sg._id_
    JOIN vendorstock vs ON s.inventorycode = vs.inventorycode
    JOIN vendor v ON vs.vendorstock_vendor_fk = v._id_
    WHERE su.stockupdate_facility_fk IS NOT NULL AND s.deleted = 'No'::text AND v.deleted = 'No'::text AND vs.deleted = 'No'::text AND fs.deleted = 'No'::text AND (s.inventorycode = '@inventorycode'::text OR "left"('@inventorycode'::text, 1) = '@'::text)) q
  ), heliumonlynationalstockavailability AS (
    SELECT asu.provincename,
    asu.districtname,
    asu.subdistrictname,
    asu.facilityname,
    asu.vendor,
    asu.stockcategory,
    asu.itemname,
    asu.abbreviation,
    asu.inventorycode,
    asu.barcode,
    asu.expiry_date,
    asu."timestamp" AS last_updatedate_timestamp,
    asu.update_date AS last_stock_update_datetime,
    asu.first_stockout_date,
    asu.stockout_reported_to_pdm,
    asu."stock level"::integer AS stock_level,
    asu."stock received"::integer AS stock_received,
    asu."stock lost"::integer AS stock_lost,
    asu.current_stock_out,
    asu.days_since_first_stockout,
    asu.days_since_last_update_timestamp,
    asu.days_since_stockout_reported_to_pdm_timestamp,
    asu.facilityname AS location,
    asu.stock_uuid,
    asu.stockupdate_uuid,
    asu.facilitystock_uuid,
    asu._facilityid AS facility_uuid,
    asu.vendor_uuid
    FROM qnationalstockupdates_new asu
    JOIN ( SELECT qnationalstockupdates_new._facilityid,
      qnationalstockupdates_new.stock_uuid,
      max(qnationalstockupdates_new."timestamp") AS mxt
      FROM qnationalstockupdates_new
      GROUP BY qnationalstockupdates_new._facilityid, qnationalstockupdates_new.stock_uuid) mud ON asu._facilityid = mud._facilityid AND asu.stock_uuid = mud.stock_uuid AND asu."timestamp" = mud.mxt
    )

    SELECT
    public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    heliumonlynationalstockavailability.stockcategory,
    heliumonlynationalstockavailability.itemname,
    heliumonlynationalstockavailability.abbreviation,
    heliumonlynationalstockavailability.inventorycode,
    heliumonlynationalstockavailability.barcode,
    heliumonlynationalstockavailability.expiry_date,
    heliumonlynationalstockavailability.last_updatedate_timestamp,
    heliumonlynationalstockavailability.first_stockout_date,
    heliumonlynationalstockavailability.last_stock_update_datetime,
    heliumonlynationalstockavailability.stockout_reported_to_pdm,
    heliumonlynationalstockavailability.stock_level,
    heliumonlynationalstockavailability.stock_received,
    heliumonlynationalstockavailability.stock_lost,
    heliumonlynationalstockavailability.current_stock_out,
    heliumonlynationalstockavailability.days_since_first_stockout,
    heliumonlynationalstockavailability.days_since_last_update_timestamp,
    heliumonlynationalstockavailability.days_since_stockout_reported_to_pdm_timestamp,
    heliumonlynationalstockavailability.location,
    heliumonlynationalstockavailability.stock_uuid,
    heliumonlynationalstockavailability.stockupdate_uuid,
    heliumonlynationalstockavailability.facilitystock_uuid,
    heliumonlynationalstockavailability.facility_uuid,
    heliumonlynationalstockavailability.vendor_uuid
    FROM heliumonlynationalstockavailability;

    RETURN 1;
    END;
    $$;


--
-- Name: generate_heliumonlyreportingaggregate(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_heliumonlyreportingaggregate() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM heliumonlyreportingaggregate;

	WITH provincialreportingfacilities AS
	(
		SELECT DISTINCT ON (province._id_)
			province._id_ AS _id_, province.name AS region,
			COUNT(DISTINCT facility._id_) AS totalfacilities,
			ROUND((COUNT(DISTINCT reportingfacilities._id_)::decimal*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text || '%' AS reportingfacilities,
			ROUND(((COUNT(DISTINCT facility._id_)::decimal-COUNT(DISTINCT reportingfacilities._id_)::decimal)*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text || '%' AS nonreportingfacilities,
			ROUND(((COUNT(DISTINCT facility._id_)::decimal-COUNT(DISTINCT stockoutreportingfacilities._id_)::decimal)*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text ||'%' AS reportingstockoutfacilities
		FROM province
		JOIN district ON district.district_province_fk = province._id_
		JOIN facility ON facility.facility_district_fk = district._id_
		JOIN
		(
			SELECT
				heliumonlyreportingfacility._id_, heliumonlyreportingfacility.name, heliumonlyreportingfacility.hasstockout,
				heliumonlyreportingfacility.province_fk AS province_id, heliumonlyreportingfacility.stockupdate_fk AS stockupdate_id
			FROM heliumonlyreportingfacility
		) AS reportingfacilities ON reportingfacilities.province_id = province._id_
		LEFT JOIN
		(
			SELECT
				heliumonlyreportingfacility._id_, heliumonlyreportingfacility.name, heliumonlyreportingfacility.hasstockout,
				heliumonlyreportingfacility.province_fk AS province_id, heliumonlyreportingfacility.stockupdate_fk AS stockupdate_id
			FROM heliumonlyreportingfacility
			WHERE heliumonlyreportingfacility.hasstockout = true
		) AS stockoutreportingfacilities ON stockoutreportingfacilities.province_id = province._id_
    --WHERE and province.name not in ('Training Demos') /* NY ADDED */
		GROUP BY province._id_
	), districtalreportingfacilities AS
	(
		SELECT DISTINCT ON (district._id_)
			district._id_ AS _id_, district.name AS region,
			COUNT(DISTINCT facility._id_) AS totalfacilities,
			ROUND((COUNT(DISTINCT reportingfacilities._id_)::decimal*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text || '%' AS reportingfacilities,
			ROUND(((COUNT(DISTINCT facility._id_)::decimal-COUNT(DISTINCT reportingfacilities._id_)::decimal)*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text || '%' AS nonreportingfacilities,
			ROUND(((COUNT(DISTINCT facility._id_)::decimal-COUNT(DISTINCT stockoutreportingfacilities._id_)::decimal)*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text ||'%' AS reportingstockoutfacilities
		FROM district
		JOIN facility ON facility.facility_district_fk = district._id_
		JOIN
		(
			SELECT
				heliumonlyreportingfacility._id_, heliumonlyreportingfacility.name, heliumonlyreportingfacility.hasstockout,
				heliumonlyreportingfacility.district_fk AS district_id, heliumonlyreportingfacility.stockupdate_fk AS stockupdate_id
			FROM heliumonlyreportingfacility
		) AS reportingfacilities ON reportingfacilities.district_id = district._id_
		LEFT JOIN
		(
			SELECT
				heliumonlyreportingfacility._id_, heliumonlyreportingfacility.name, heliumonlyreportingfacility.hasstockout,
				heliumonlyreportingfacility.district_fk AS district_id, heliumonlyreportingfacility.stockupdate_fk AS stockupdate_id
			FROM heliumonlyreportingfacility
			WHERE heliumonlyreportingfacility.hasstockout = true
		) AS stockoutreportingfacilities ON stockoutreportingfacilities.district_id = district._id_
		GROUP BY district._id_
	), subdistrictalreportingfacilities AS
	(
		SELECT DISTINCT ON (subdistrict._id_)
			subdistrict._id_ AS _id_, subdistrict.name AS region,
			COUNT(DISTINCT facility._id_) AS totalfacilities,
			ROUND((COUNT(DISTINCT reportingfacilities._id_)::decimal*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text || '%' AS reportingfacilities,
			ROUND(((COUNT(DISTINCT facility._id_)::decimal-COUNT(DISTINCT reportingfacilities._id_)::decimal)*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text || '%' AS nonreportingfacilities,
			ROUND(((COUNT(DISTINCT facility._id_)::decimal-COUNT(DISTINCT stockoutreportingfacilities._id_)::decimal)*100)::decimal/COUNT(DISTINCT facility._id_)::decimal, 2)::decimal::text ||'%' AS reportingstockoutfacilities
		FROM subdistrict
		JOIN facility ON facility.facility_subdistrict_fk = subdistrict._id_
		JOIN
		(
			SELECT
				heliumonlyreportingfacility._id_, heliumonlyreportingfacility.name, heliumonlyreportingfacility.hasstockout,
				heliumonlyreportingfacility.subdistrict_fk AS subdistrict_id, heliumonlyreportingfacility.stockupdate_fk AS stockupdate_id
			FROM heliumonlyreportingfacility
		) AS reportingfacilities ON reportingfacilities.subdistrict_id = subdistrict._id_
		LEFT JOIN
		(
			SELECT
				heliumonlyreportingfacility._id_, heliumonlyreportingfacility.name, heliumonlyreportingfacility.hasstockout,
				heliumonlyreportingfacility.subdistrict_fk AS subdistrict_id, heliumonlyreportingfacility.stockupdate_fk AS stockupdate_id
			FROM heliumonlyreportingfacility
			WHERE heliumonlyreportingfacility.hasstockout = true
		) AS stockoutreportingfacilities ON stockoutreportingfacilities.subdistrict_id = subdistrict._id_
		GROUP BY subdistrict._id_
	),
	aggregate AS
	(
		SELECT _id_, region, totalfacilities, reportingfacilities, nonreportingfacilities, reportingstockoutfacilities
		FROM
		(
			SELECT
				provincialreportingfacilities._id_, provincialreportingfacilities.region,
				provincialreportingfacilities.totalfacilities, provincialreportingfacilities.reportingfacilities,
				provincialreportingfacilities.nonreportingfacilities, provincialreportingfacilities.reportingstockoutfacilities
			FROM provincialreportingfacilities
			UNION SELECT
				districtalreportingfacilities._id_, districtalreportingfacilities.region,
				districtalreportingfacilities.totalfacilities, districtalreportingfacilities.reportingfacilities,
				districtalreportingfacilities.nonreportingfacilities, districtalreportingfacilities.reportingstockoutfacilities
			FROM districtalreportingfacilities
			UNION SELECT
				subdistrictalreportingfacilities._id_, subdistrictalreportingfacilities.region,
				subdistrictalreportingfacilities.totalfacilities, subdistrictalreportingfacilities.reportingfacilities,
				subdistrictalreportingfacilities.nonreportingfacilities, subdistrictalreportingfacilities.reportingstockoutfacilities
			FROM subdistrictalreportingfacilities
		) AS base_data
	)


	INSERT INTO heliumonlyreportingaggregate
	(
		_id_, _tstamp_, region, totalfacilities, reportingfacilities, nonreportingfacilities, reportingstockoutfacilities
	)
	SELECT
		aggregate._id_, now(), aggregate.region, aggregate.totalfacilities, aggregate.reportingfacilities,
		aggregate.nonreportingfacilities, aggregate.reportingstockoutfacilities
	FROM aggregate;

	SELECT 1 INTO result;
	RETURN result;
END;
$$;


--
-- Name: generate_heliumonlyreportingfacility(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_heliumonlyreportingfacility() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM heliumonlyreportingfacility;

	WITH aggregate AS
	(
		SELECT
			result.facility_id, result.facilityname, result.subdistrict_id, result.district_id, result.province_id,
			result.stockupdate_id, result.hasstockout
		FROM
		(
			SELECT
				base_data.facility_id, base_data.facilityname, base_data.subdistrict_id, base_data.district_id, base_data.province_id,
				base_data.stockupdate_id, base_data.latest_update, base_data.stock_id,
			CASE
				WHEN base_data.current_level::integer = 0 THEN true
				ELSE false
			END AS hasstockout
			FROM
			(
				SELECT
					DISTINCT ON (facilitystocks.facilitystock_id)
					facility._id_ AS facility_id, facility.name AS facilityname, stocks.stock_id,
					facility.facility_subdistrict_fk AS subdistrict_id, districts.district_id, districts.province_id,
					stockupdates.stockupdate_id, stockupdates.current_level, stockupdates.latest_update
				FROM facility
				JOIN
				(
					SELECT
						facilitystock._id_ AS facilitystock_id, facilitystock.facilitystock_facility_fk AS facility_id,
						facilitystock.facilitystock_stock_fk AS stock_id
					FROM facilitystock
					WHERE facilitystock.deleted = 'No'
				) AS facilitystocks ON facilitystocks.facility_id = facility._id_
				JOIN
				(
					SELECT stock._id_ AS stock_id
					FROM stock
					WHERE stock.deleted = 'No'
				) AS stocks ON stocks.stock_id = facilitystocks.stock_id
				JOIN
				(
					SELECT
						stockupdate._id_ AS stockupdate_id, MAX(stockupdate.update_date) AS latest_update, stockupdate.current_level,
						stockupdate.stockupdate_facility_fk AS facility_id, stockupdate.stockupdate_stock_fk AS stock_id,
						stockupdate.stockupdate_facilitystock_fk AS facilitystock_id
					FROM stockupdate
					GROUP BY stockupdate._id_
				) AS stockupdates ON stockupdates.facility_id = facility._id_ AND stockupdates.facilitystock_id = facilitystocks.facilitystock_id AND stockupdates.stock_id = stocks.stock_id
				JOIN
				(
					SELECT district._id_ AS district_id, district.district_province_fk AS province_id
					FROM district
				) AS districts ON districts.district_id = facility.facility_district_fk
				WHERE facility.deleted = 'No'
				GROUP BY facility._id_, facilitystocks.facilitystock_id, districts.district_id, districts.province_id, stocks.stock_id, stockupdates.stockupdate_id, stockupdates.current_level, stockupdates.latest_update
			) AS base_data
			ORDER BY base_data.facility_id, base_data.stock_id, base_data.latest_update DESC
		) AS result
	)

	INSERT INTO heliumonlyreportingfacility
	(
		_id_, _tstamp_, name, hasstockout, province_fk, district_fk, subdistrict_fk, facility_fk, stockupdate_fk
	)
	SELECT DISTINCT ON (aggregate.facility_id)
		aggregate.facility_id, now(), aggregate.facilityname, aggregate.hasstockout, aggregate.province_id, aggregate.district_id,
		aggregate.subdistrict_id, aggregate.facility_id, aggregate.stockupdate_id
	FROM aggregate;

	SELECT 1 INTO result;
	RETURN result;
END;
$$;


--
-- Name: generate_heliumonlystockout(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_heliumonlystockout() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM heliumonlystockout;

	INSERT INTO heliumonlystockout
	(
		_id_, _tstamp_, category, itemname, barcode, inventorycode, latest_update_date, first_update_date, stockupdate_fk, facility_fk, stock_fk, facilitystock_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		stock.stock_type AS category, stock.itemname, stock.barcode, stock.inventorycode,
		--heliumonlynationalstockavailability.stock_level,
		heliumonlynationalstockavailability.last_stock_update_datetime, heliumonlynationalstockavailability.first_stockout_date,
		heliumonlynationalstockavailability.heliumonlynationalstockavailability_stockupdate_fk AS stockupdate_id,
		facility._id_ AS facility_id, stock._id_ AS stock_id_, facilitystock._id_ AS facilitystock_id
	FROM facility
	JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
	JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
	JOIN heliumonlynationalstockavailability
		ON heliumonlynationalstockavailability.heliumonlynationalstockavailability_facility_fk = facility._id_
		AND heliumonlynationalstockavailability.heliumonlynationalstockavailability_stock_fk = stock._id_
	WHERE heliumonlynationalstockavailability.stock_level = 0 and facilitystock.deleted='No' and facility.deleted='No' and stock.deleted='No';

	SELECT 1 INTO result;
	RETURN result;
END;
$$;


--
-- Name: generate_lowandoverstock_aggregation(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_lowandoverstock_aggregation() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

-- ================================================= Clear Tables
-- Available Stock Percentage
  PERFORM clear_lowAndOverStockReport();


-- =================================================

-- ================================================= Execute Functions
-- Available Stock Percentage
  PERFORM generate_lowAndOverStockReport();


-- =================================================

	RETURN 1;
	END;
	$$;


--
-- Name: generate_lowandoverstockreport(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_lowandoverstockreport() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO heliumonlylowandoverstockreport
	(
		_id_,	_tstamp_,
		stockitem,	inventory_code,	abbreviasion,	supplier,	category,
		stock_level,	min,	max, "stock_status",
		--StockOutTime,
		facility_name,	subdistrict_name,	district_name,	province_name,
		stock_fk,
		facility_fk,	subDistrict_fk,	district_fk,	province_fK,
		"type"
	)
	SELECT
	*
	FROM
	(
    WITH facilitydata AS(
    	SELECT
    		public.uuid_generate_v4() AS _id_,
    		now() AS _tstamp_,
    		stock.itemname AS stockitem,
    		stock.inventorycode AS inventory_code,
    		stock.abbreviation AS abbreviasion,
    		stock.supplier AS supplier,
    		stock.stock_type AS category,
    		facilitystock.total AS stock_level,
    		facilitystock.min AS min,
    		facilitystock.max AS max,
    		CASE WHEN facilitystock.total = 0 THEN 'Out of stock' WHEN facilitystock.total < facilitystock.min THEN 'Low stock' WHEN facilitystock.total > facilitystock.max THEN 'Over stock' WHEN facilitystock.total IS NULL THEN 'Not submitted' ELSE 'Within range' END AS "stock_status",
    		--facilitystock.stock_out_time::_tstamp_ AS StockOutTime,
    		facility.name::text AS facility_name,
    		subdistrict.name AS subdistrict_name,
    		district.name AS district_name,
    		province.name AS province_name,
    		stock._id_ AS stock_fk,
    		facility._id_ AS facility_fk,
    		facility.facility_subdistrict_fk AS subdistrict_fk,
    		facility.facility_district_fk AS district_fk,
    		province._id_ AS province_fk,
    		'facility'::text AS "type"
    	FROM facilitystock
    	JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
    	JOIN facility ON facilitystock.facilitystock_facility_fk=facility._id_
    	JOIN subdistrict ON facility.facility_subdistrict_fk = subdistrict._id_
    	JOIN district ON facility.facility_district_fk = district._id_
    	JOIN province ON district.district_province_fk = province._id_

    	WHERE facilitystock.deleted = 'No'
    )/*, SubDistrictData AS(
    	SELECT
    		public.uuid_generate_v4() AS _id_,
    		now() AS _tstamp_,
    		facilitydata.stockitem,
    		facilitydata.inventory_code,
    		facilitydata.abbreviasion,
    		facilitydata.supplier,
    		facilitydata.category,
    		SUM(facilitydata.stock_level) AS stock_level,
    		SUM(facilitydata.min) AS min,
    		SUM(facilitydata.max) AS max,
    		CASE  WHEN 	SUM(facilitydata.stock_level) < SUM(facilitydata.min) THEN 'lowStock' WHEN 	SUM(facilitydata.stock_level) > SUM(facilitydata.max) THEN 'overStock' WHEN SUM(facilitydata.stock_level) IS NULL THEN 'notSubmitted' ELSE 'good'  END AS "stock_status",
    		--NULL::_tstamp_ AS StockOutTime,
    		'N/A'::text AS "facility_name",
    		facilitydata.subdistrict_name,
    		facilitydata.district_name,
    		facilitydata.province_name,
    		facilitydata.stock_fk,
    		NULL::uuid AS facility_fk,
    		facilitydata.subdistrict_fk,
    		facilitydata.district_fk,
    		facilitydata.province_fk,
    		'subdistrict'::text AS "type"
    	FROM subdistrict
    	JOIN facilitydata ON facilitydata.subdistrict_fk = subdistrict._id_
    	GROUP BY (facilitydata.stockitem, facilitydata.inventory_code, facilitydata.abbreviasion, facilitydata.supplier, facilitydata.category, facilitydata.subdistrict_name, facilitydata.district_name,
    		facilitydata.province_name, facilitydata.stock_fk, facilitydata.subdistrict_fk, facilitydata.district_fk, facilitydata.province_fk )
    ), DistrictData AS(
    	SELECT
    		public.uuid_generate_v4() AS _id_,
    		now() AS _tstamp_,
    		facilitydata.stockitem,
    		facilitydata.inventory_code,
    		facilitydata.abbreviasion,
    		facilitydata.supplier,
    		facilitydata.category,
    		SUM(facilitydata.stock_level) AS stock_level,
    		SUM(facilitydata.min) AS min,
    		SUM(facilitydata.max) AS max,
        CASE  WHEN 	SUM(facilitydata.stock_level) < SUM(facilitydata.min) THEN 'lowStock' WHEN 	SUM(facilitydata.stock_level) > SUM(facilitydata.max) THEN 'overStock' WHEN SUM(facilitydata.stock_level) IS NULL THEN 'notSubmitted' ELSE 'good'  END AS "stock_status",
    		--NULL::_tstamp_ AS StockOutTime,
    		'N/A'::text AS "facility_name",
    		'N/A'::text AS "subdistrict_name",
    		facilitydata.district_name,
    		facilitydata.province_name,
    		facilitydata.stock_fk,
    		NULL::uuid AS facility_fk,
    		NULL::uuid AS subdistrict_fk,
    		facilitydata.district_fk,
    		facilitydata.province_fk,
    		'district'::text AS "type"
    	FROM district
    	JOIN facilitydata ON facilitydata.district_fk = district._id_
    	GROUP BY (facilitydata.stockitem, facilitydata.inventory_code, facilitydata.abbreviasion, facilitydata.supplier, facilitydata.category, facilitydata.district_name,
    		facilitydata.province_name, facilitydata.stock_fk, facilitydata.district_fk, facilitydata.province_fk )
    ), ProvinceData AS(
    	SELECT
    		public.uuid_generate_v4() AS _id_,
    		now() AS _tstamp_,
    		facilitydata.stockitem,
    		facilitydata.inventory_code,
    		facilitydata.abbreviasion,
    		facilitydata.supplier,
    		facilitydata.category,
    		SUM(facilitydata.stock_level) AS stock_level,
    		SUM(facilitydata.min) AS min,
    		SUM(facilitydata.max) AS max,
        CASE  WHEN 	SUM(facilitydata.stock_level) < SUM(facilitydata.min) THEN 'lowStock' WHEN 	SUM(facilitydata.stock_level) > SUM(facilitydata.max) THEN 'overStock' WHEN SUM(facilitydata.stock_level) IS NULL THEN 'notSubmitted' ELSE 'good'  END AS "stock_status",
    		--NULL::_tstamp_ AS StockOutTime,
    		'N/A'::text AS "facility_name",
    		'N/A'::text AS "subdistrict_name",
    		'N/A'::text AS "district_name",
    		facilitydata.province_name,
    		facilitydata.stock_fk,
    		NULL::uuid AS facility_fk,
    		NULL::uuid AS subdistrict_fk,
    		NULL::uuid AS district_fk,
    		facilitydata.province_fk,
    		'province'::text AS "type"
    	FROM province
    	JOIN facilitydata ON facilitydata.province_fk = province._id_
    	GROUP BY (facilitydata.stockitem, facilitydata.inventory_code, facilitydata.abbreviasion, facilitydata.supplier, facilitydata.category,
    		facilitydata.province_name, facilitydata.stock_fk, facilitydata.province_fk )
      )*/

    	Select * FROM facilitydata
    	/*UNION
    	SELECT * FROM SubDistrictData
    	UNION
    	SELECT * FROM DistrictData
    	UNION
    	SELECT * FROM ProvinceData*/
) AS result;



	RETURN 1;
	END;
	$$;


--
-- Name: generate_product_stockupdate(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_product_stockupdate() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE Counter INT;
DECLARE the_schema text;
DECLARE concatQuery text;
BEGIN

 	/* */
	--Remove old generated data
	--EXECUTE 'DELETE FROM ' || the_schema || '.__productstockupdateoutput__ WHERE _tstamp_ < (current_timestamp - interval ''1 hours'')';
 	DELETE FROM zambia__svs_001.__productstockupdateoutput__ WHERE _tstamp_ < (current_timestamp - interval '1 hours');
 	--Increment the counter stored in the configuration table by 1
 	--EXECUTE '(SELECT (value::INT + 1) FROM ' || the_schema || '.Configuration WHERE Key = ''product_stockupdate_view_update_counter'' LIMIT 1)'
	--INTO Counter;
	SELECT (value::INT + 1) FROM zambia__svs_001.Configuration WHERE Key = 'product_stockupdate_view_update_counter' LIMIT 1
	INTO Counter;

 	--Generate new data
	--EXECUTE 'INSERT INTO ' || the_schema || '.__productstockupdateoutput__ ( _tstamp_, category, itemname, inventorycode, update_date, days_stockout, available_stock, expiry_date, stock_received, stock_lost, dataset, productupdatedetails_facility_fk, days_since_update )
   	--SELECT _tstamp_, category, itemname, inventorycode, update_date, days_stockout, available_stock, expiry_date, stock_received, stock_lost, '||Counter||', productupdatedetails_facility_fk, days_since_update
   	--FROM ' || the_schema || '.ProductStockUpdateView';
   	INSERT INTO zambia__svs_001.__productstockupdateoutput__ (
   			_id_,
	   		_tstamp_,
	   		category,
	   		itemname,
	   		inventorycode,
	   		update_date,
	   		days_stockout,
	   		available_stock,
	   		expiry_date,
	   		stock_received,
	   		stock_lost,
	   		dataset,
	   		productupdatedetails_facility_fk,
	   		days_since_update
   	)
   	SELECT 	public.uuid_generate_v4(),
   			_tstamp_,
	   		category,
	   		itemname,
	   		inventorycode,
	   		update_date,
	   		days_stockout,
	   		available_stock,
	   		expiry_date,
	   		stock_received,
	   		stock_lost,
	   		Counter,
	   		productupdatedetails_facility_fk,
	   		days_since_update
   	FROM	zambia__svs_001.ProductStockUpdateView;

 	--Increment the dataset counter(used to retrieve the latest generated batch)
 	--EXECUTE 'UPDATE ' || the_schema || '.Configuration
 	--SET Value = '||Counter||'
 	--WHERE Key = ''product_stockupdate_view_update_counter''';

 	UPDATE 	zambia__svs_001.Configuration
 	SET 	Value = Counter
 	WHERE	Key = 'product_stockupdate_view_update_counter';

 --Return latest dataset counter
 RETURN Counter;--EXECUTE '(SELECT value::INT FROM ' || the_schema || '.Configuration WHERE Key = ''product_status_view_update_counter'' LIMIT 1)::INT';
END;
$$;


--
-- Name: generate_provincestockbycategory(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_provincestockbycategory() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO SuccessMatrix_StockByCategory
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level", category,
		province_fk --, district_fk, subdistrict_fk, facility_fk
	)
	SELECT
		public.uuid_generate_v4(), now(),
		result.provincename AS "name",
		result.all_provincestock_count,
		result.stockout_provincestock_count,
		result.stockavailability_percentage,
    result.level,
    result.category,
		result.province_id AS province_fk
	FROM
	(
		SELECT
			data_set.province_id,
			data_set.provincename,
			data_set.all_provincestock_count,
			data_set.stockout_provincestock_count,
      data_set.level,
      data_set.category,
			CASE
				WHEN data_set.all_provincestock_count IS NOT NULL AND data_set.all_provincestock_count != 0 AND
				     data_set.stockout_provincestock_count IS NOT NULL AND data_set.stockout_provincestock_count != 0
				THEN ( ROUND( ( ( data_set.all_provincestock_count - data_set.stockout_provincestock_count ) * 100 ) / data_set.all_provincestock_count ) )::text || '%'
				ELSE '100%'
			END AS stockavailability_percentage
		FROM
		(
		  SELECT
      'Province' AS level,
			province._id_ AS province_id,
			province.name AS provincename,
			COALESCE( SUM( district_facility_data.all_districtstock_count ), 0 ) AS all_provincestock_count,
			COALESCE( SUM( district_facility_data.stockout_districtstock_count ), 0 ) AS stockout_provincestock_count,
      district_facility_data.category
		  FROM province
		  JOIN
		    (
		    SELECT
            district._id_ AS district_id,
            district.name AS districtname,
            district.district_province_fk AS province_id,
            COALESCE( SUM( facility_data.all_facilitystock_count ), 0 ) AS all_districtstock_count,
            COALESCE( SUM( facility_data.stockout_facilitystock_count ), 0 ) AS stockout_districtstock_count,
            facility_data.category
		    FROM district
		    JOIN
		    (
        SELECT

        		facility._id_ AS facility_id,
        		facility.name AS facilityname,
        		facility.facility_district_fk AS district_id,
        		COUNT( DISTINCT all_alive_facilitystocks.facilitystock_id ) AS all_facilitystock_count,
        		COUNT( DISTINCT stockout_facilitystocks.facilitystock_id ) AS stockout_facilitystock_count,
        		stringgroup.value AS category

        	FROM facility
        	JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
        	JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
        	JOIN stringgroup ON stock.stock_stringgroup_fk = stringgroup._id_
        	JOIN
        	(
        		SELECT
        			facilitystock._id_ AS facilitystock_id,
        			facilitystock.facilitystock_facility_fk AS facility_id,
        			facilitystock.facilitystock_stock_fk AS stock_id
        		FROM facilitystock
        		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

        		WHERE facilitystock.deleted = 'No'
        	) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_ AND all_alive_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk

        	LEFT JOIN
        	(
        		SELECT
        			facilitystock._id_ AS facilitystock_id,
        			facilitystock.facilitystock_facility_fk AS facility_id,
        			facilitystock.facilitystock_stock_fk AS stock_id
        		FROM facilitystock
        		LEFT JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

        		WHERE facilitystock.deleted = 'No' AND facilitystock.stock_out = 'Yes'
        	) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_ AND stockout_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk


        	WHERE facility.deleted = 'No'
        	GROUP BY facility._id_, category

		    ) AS facility_data ON facility_data.district_id = district._id_
		    GROUP BY district._id_, category

		  ) AS district_facility_data ON district_facility_data.province_id = province._id_
		  GROUP BY province._id_, category

		) AS data_set
	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_refresh_tableau_aggregation_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_refresh_tableau_aggregation_function() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    result integer;
BEGIN
  --REFRESH MATERIALIZED VIEW materializednationalstockupdates_levels_tableau_view;
  EXECUTE 'REFRESH MATERIALIZED VIEW materializednationalstockupdates_levels_tableau_view';

 RETURN 1;
END;
$$;


--
-- Name: generate_shadowfacility(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowfacility() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM shadowfacility;
	INSERT INTO shadowfacility
	(
		_id_, _tstamp_,
		hasstockouts, reporting, facilityname, latitude, longitude,
		subdistrictname, districtname, provincename,
		facility_fk, subdistrict_fk, district_fk, province_fk
	)

  with facilityhierarchy as (
  select p.name as provincename ,
  d.name as districtname,
  sd.name as subdistrictname ,
  f.name as facilityname,
  f.gps_latitude, f.gps_longitude
  , f._id_ as facility_id,
  sd._id_ as subdistrict_id,
  d._id_ as district_id,
  p._id_ as province_id
  from facility f
  left join subdistrict sd on sd._id_=f.facility_subdistrict_fk
  left join district d on d._id_=sd.subdistrict_district_fk
  left join province p on p._id_=d.district_province_fk
  WHERE f.deleted = 'No'::text AND (lower(p.name) ~~ lower('%@provincename%'::text) OR "left"('@provincename'::text, 1) = '@'::text) AND p.name <> 'Training Demos'::text
  ) ,

 qnationalstockupdates_source AS (
  SELECT
        q."row",
        q._tstamp_,
        q.update_date,
        q.provincename,
        q.districtname,
        q.subdistrictname,
        q.facilityname,
        q.itemname,
        q.abbreviation,
        q.stockcategory,
        q.inventorycode,
        q.stocklevel,
        q.stockreceived,
        q.stocklost,
        q.stockout_status,
        q.stockout_reason,
        q.stockout_alternative,
        q.stockout_ordered,
        q.current_stock_out,
        q.stockout_alternative_code,
        q.stock_type_new,
        q.first_stockout_date,
        q._stockid,
        q.province_id,
        q.district_id,
        q.subdistrict_id,
        q.facility_id,
        q.gps_longitude,
        q.gps_latitude,
        COALESCE((date_part('epoch'::text, age(now()::date::timestamp with time zone, q._tstamp_::timestamp with time zone::date::timestamp with time zone)) / (60 * 60 * 24)::double precision)::integer, NULL::integer) AS days_since_last_update_tstamp_
  FROM (
        SELECT row_number() OVER (PARTITION BY fh.facility_id, fs.facilitystock_stock_fk ORDER BY su._tstamp_ DESC) AS "row",
        su._tstamp_,
        su.update_date + '02:00:00'::interval AS update_date,
        fh.provincename,
        fh.districtname,
        fh.subdistrictname,
        fh.facilityname,
        s.itemname,
        s.abbreviation,
        sg_category.value AS stockcategory,
        s.inventorycode,
        su.current_level AS stocklevel,
        su.stock_received AS stockreceived,
        su.stock_lost AS stocklost,
        sg_stockout_status.value AS stockout_status,
        sg_stockout_reason.value AS stockout_reason,
        sg_stockout_alternative.value AS stockout_alternative,
        sg_stockout_ordered.value AS stockout_ordered,
        CASE
        WHEN su.current_level = '0'::text THEN 1
        ELSE 0
        END AS current_stock_out,
        CASE
        WHEN su.current_level = '0'::text AND "left"(COALESCE(sg_stockout_alternative.value, 'N'::text), 1) = 'Y'::text THEN 1
        ELSE 0
        END AS stockout_alternative_code,
        CASE
        WHEN upper(sg_category.value) = ANY (ARRAY['ARV'::text, 'TB'::text, 'VACC'::text]) THEN upper(sg_category.value)
        ELSE 'TRACER'::text
        END AS stock_type_new,
        CASE
        WHEN COALESCE(su.first_stockout_date, now()::date::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone AND COALESCE(su.first_stockout_date, now()::date::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone THEN su.first_stockout_date + '02:00:00'::interval
        ELSE NULL::timestamp without time zone
        END AS first_stockout_date,
        s._id_ AS _stockid,
        fh.province_id,
        fh.district_id,
        fh.subdistrict_id,
        fh.facility_id,
        fh.gps_longitude,
        fh.gps_latitude
        FROM facilityhierarchy fh
        JOIN facilitystock fs ON fs.facilitystock_facility_fk = fh.facility_id AND fs.deleted = 'No'::text
        LEFT JOIN stock s ON fs.facilitystock_stock_fk = s._id_
        LEFT JOIN stockupdate su ON su.stockupdate_facility_fk = fh.facility_id AND fs.facilitystock_stock_fk = su.stockupdate_stock_fk
        LEFT JOIN stringgroup sg_category ON s.stock_stringgroup_fk = sg_category._id_
        LEFT JOIN stringgroup sg_stockout_status ON su.stockupdate_stockout_status_fk = sg_stockout_status._id_
        LEFT JOIN stringgroup sg_stockout_reason ON su.stockupdate_stockout_reason_fk = sg_stockout_reason._id_
        LEFT JOIN stringgroup sg_stockout_alternative ON su.stockupdate_stockout_alternative_fk = sg_stockout_alternative._id_
        LEFT JOIN stringgroup sg_stockout_ordered ON su.stockupdate_stockout_ordered_fk = sg_stockout_ordered._id_) q
        WHERE q."row" = 1
  ) , --select * from qnationalstockupdates_source;

    qnationalstockupdates_new AS (
    SELECT qs."row",
    qs._tstamp_,
    qs.update_date,
    qs.provincename,
    qs.districtname,
    qs.subdistrictname,
    qs.facilityname,
    qs.itemname,
    qs.abbreviation,
    qs.stockcategory,
    qs.inventorycode,
    qs.stocklevel,
    qs.stockreceived,
    qs.stocklost,
    qs.stockout_status,
    qs.stockout_reason,
    qs.stockout_alternative,
    qs.stockout_ordered,
    qs.current_stock_out,
    qs.stockout_alternative_code,
    qs.stock_type_new,
    qs.first_stockout_date,
    qs._stockid,
    qs.province_id,
    qs.district_id,
    qs.subdistrict_id,
    qs.facility_id,
    qs.gps_longitude,
    qs.gps_latitude,
    qs.days_since_last_update_tstamp_,
    CASE qs.stock_type_new
    WHEN 'ARV'::text THEN 1
    ELSE 0
    END AS arv_items_linked,
    CASE qs.stock_type_new
    WHEN 'TB'::text THEN 1
    ELSE 0
    END AS tb_items_linked,
    CASE qs.stock_type_new
    WHEN 'VACC'::text THEN 1
    ELSE 0
    END AS vacc_items_linked,
    CASE qs.stock_type_new
    WHEN 'TRACER'::text THEN 1
    ELSE 0
    END AS tracer_items_linked,
    CASE qs.stock_type_new
    WHEN 'ARV'::text THEN qs.days_since_last_update_tstamp_
    ELSE NULL::integer
    END AS arv_days_since_last_update_tstamp_,
    CASE qs.stock_type_new
    WHEN 'TB'::text THEN qs.days_since_last_update_tstamp_
    ELSE NULL::integer
    END AS tb_days_since_last_update_tstamp_,
    CASE qs.stock_type_new
    WHEN 'VACC'::text THEN qs.days_since_last_update_tstamp_
    ELSE NULL::integer
    END AS vacc_days_since_last_update_tstamp_,
    CASE qs.stock_type_new
    WHEN 'TRACER'::text THEN qs.days_since_last_update_tstamp_
    ELSE NULL::integer
    END AS tracer_days_since_last_update_tstamp_,
    CASE
    WHEN qs.days_since_last_update_tstamp_ < (select value::integer from configuration where key ='facility_reporting_period' limit 1 ) THEN 1
    ELSE 0
    END AS purpleindicatorbyline
    FROM qnationalstockupdates_source qs
  ),

  facilityhierarchyRespondingGeneral as (
  select
  fh.facility_id,
  fh.facilityname,
  fh.gps_latitude,
  fh.gps_longitude,
  fh.subdistrict_id,
  fh.subdistrictname,
  fh.district_id,
  fh.districtname,
  fh.province_id,
  fh.provincename,
  CASE
    WHEN max(COALESCE(qs.stocklevel::integer , 0 )) > 0 THEN true
    ELSE false
  END AS hasstockouts,
  CASE
    WHEN max(COALESCE(qs.purpleindicatorbyline::integer,0))>0  THEN true
    ELSE false
  END AS reporting
  from facilityhierarchy fh
  left Join qnationalstockupdates_new qs ON qs.facility_id = fh.facility_id
  GROUP BY fh.provincename,fh.province_id,fh.districtname,fh.district_id,fh.subdistrictname,fh.subdistrict_id,fh.facilityname,fh.facility_id,
  fh.gps_latitude,
  fh.gps_longitude
)
--select * from qnationalstockupdates_new;
select public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
hasstockouts, reporting, facilityname, gps_latitude, gps_longitude,
subdistrictname, districtname, provincename,
facility_id, subdistrict_id, district_id, province_id from facilityhierarchyRespondingGeneral;
--select * from qnationalstockupdates_new;
--select * from facilityhierarchyRespondingGeneral;
--select * from configuration where key ='facility_reporting_period' ;
--select count(*) from facility; // 523
--select count(*) from facilityhierarchy
--select count(*) from facilityhierarchyRespondingGeneral;

RETURN 1;
END;
$$;


--
-- Name: generate_shadowfacilityvendor(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowfacilityvendor() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO shadowreportingvendorfacility
	(
		_id_, _tstamp_,facilityname,
		vendorname, hasstockout, province_fk , district_fk, subdistrict_fk, facility_fk, vendor_fk
	)

	SELECT
		public.uuid_generate_v4(), now(),
		result.facilityname,
    result.vendorname,
    result.hasstockout,
		result.province_id AS province_fk,
		result.district_id AS district_fk,
    result.subdistrict_id AS subdistrict_fk,
		result.facility_id AS facility_fk,
    result.vendor_id AS vendor_fk


	FROM
	  (
	  SELECT

	  	data_set.facility_id,
	  	data_set.facilityname,
		data_set.subdistrict_id,
		data_set.district_id,
		data_set.province_id,
	  	data_set._vendorid AS vendor_id,
	  	data_set.vendorname,
		data_set.hasstockout

	  FROM
	  (

      SELECT
    		DISTINCT hsa.heliumonlynationalstockavailability_vendor_fk as _vendorid,
		fh._facilityid AS facility_id,
		fh._subdistrictid AS subdistrict_id,
		fh._districtid AS district_id,
		fh._provinceid AS province_id,
    		v.name as vendorname,
		fh.facilityname AS facilityname,
    		CASE
    			WHEN MAX (hsa.current_stock_out)::integer = 0 THEN false
    			ELSE true
    		END AS hasstockout

    	FROM heliumonlynationalstockavailability hsa
    		LEFT JOIN
        (
          SELECT
            p._id_ AS _provinceid,
            d._id_ AS _districtid,
            sd._id_ AS _subdistrictid,
            f._id_ AS _facilityid,
            f.name AS facilityname

          FROM facility f
            LEFT JOIN subdistrict sd ON f.facility_subdistrict_fk = sd._id_
            LEFT JOIN district d ON sd.subdistrict_district_fk = d._id_
            LEFT JOIN province p ON d.district_province_fk = p._id_
          WHERE f.deleted = 'No'::text

        )AS fh on (fh._facilityid = hsa.heliumonlynationalstockavailability_facility_fk)
    		LEFT JOIN vendor v on (v._id_ = hsa.heliumonlynationalstockavailability_vendor_fk)
    	--WHERE  hsa.days_since_last_update_timestamp <= 7
    	GROUP BY _vendorid, fh._facilityid, vendorname, fh.facilityname,fh._subdistrictid, fh._districtid, fh._provinceid
    	ORDER BY facilityname, vendorname, hasstockout DESC

	  ) AS data_set

	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_shadowfirststockout(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowfirststockout() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM shadowfirststockout;

	INSERT INTO shadowfirststockout
	(
		_id_, _tstamp_,
		update_date, stock_level, days_since_stockout, days_since_update, days_since_reported,
		facility_fk, facilitystock_fk, stockupdate_fk, stock_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.update_date, result.current_level, result.days_since_first_stockout, result.days_since_last_update, result.days_since_stockout_reported,
		result.facility_id, result.facilitystock_id, result.stockupdate_id, result.stock_id
	FROM
	(
		SELECT DISTINCT ON( facilitystock._id_ )
			facility._id_ AS facility_id, facility.name AS facilityname, facilitystock._id_ AS facilitystock_id,
			stock._id_ AS stock_id, stock.itemname,
			stockupdate._id_ AS stockupdate_id, stockupdate.update_date, stockupdate.current_level::integer,
			(
				date_part( 'epoch'::text, age( now(), COALESCE(
					stockupdate.first_stockout_date::timestamp with time zone, now()
				) ) ) / (60 * 60 * 24)::double precision
			)::integer AS days_since_first_stockout,
			(
				date_part( 'epoch'::text, age( now(),
				(
					stockupdate.update_date + '02:00:00'::interval
				) ) ) / (60 * 60 * 24)::double precision
			)::integer AS days_since_last_update,
			(
				date_part( 'epoch'::text, age( now(),
				(
					stockupdate.stockout_reported_to_pdm::timestamp with time zone
				) ) ) / (60 * 60 * 24)::double precision
			 )::integer AS days_since_stockout_reported
		FROM facility
		JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
		JOIN stockupdate ON stockupdate.stockupdate_stock_fk = stock._id_ AND stockupdate.stockupdate_facility_fk = facility._id_
               --result.current_level = '0';
	) AS result
	WHERE result.current_level = 0;

	RETURN 1;
END;
$$;


--
-- Name: generate_shadowfirstupdate(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowfirstupdate() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM shadowfirstupdate;

	INSERT INTO shadowfirstupdate
	(
		_id_, _tstamp_,
		facilityname, itemname, category, inventorycode, barcode,
		update_date, stock_level, facility_fk, stock_fk, stockupdate_fk, facilitystock_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.facilityname, result.itemname, result.category, result.inventorycode, result.barcode,
		result.update_date, result.stock_level, result.facility_id, result.stock_id,
		result.stockupdate_id, result.facilitystock_id
	FROM
	(
		SELECT DISTINCT ON( facilitystock._id_ )
			facility._id_ AS facility_id, facility.name AS facilityname,
			stock._id_ AS stock_id, stock.itemname, stock.stock_type AS category, stock.inventorycode, stock.barcode,
			MIN( stockupdates.update_date ) AS update_date, stockupdates.current_level::integer AS stock_level,
			stockupdates.stockupdate_id, facilitystock._id_ AS facilitystock_id
		FROM facility
		JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
		JOIN
		(
			SELECT
				stockupdate._id_ AS stockupdate_id, stockupdate.update_date,
				stockupdate.current_level, stockupdate.stockupdate_facility_fk AS facility_id,
				stockupdate.stockupdate_stock_fk AS stock_id, stockupdate.stockupdate_facilitystock_fk AS facilitystock_id
			FROM stockupdate
		) AS stockupdates ON stockupdates.facility_id = facility._id_ AND stockupdates.stock_id = stock._id_ AND stockupdates.facilitystock_id = facilitystock._id_
		WHERE facility.deleted = 'No' AND stock.deleted = 'No' AND facilitystock.deleted = 'No'
		GROUP BY facility._id_, stock._id_, stockupdates.stockupdate_id, facilitystock._id_, stockupdates.current_level, stockupdates.update_date
		ORDER BY facilitystock._id_, stockupdates.update_date
	) AS result;

	RETURN 1;
END;
$$;


--
-- Name: generate_shadowlaststockout(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowlaststockout() RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM shadowlaststockout;

	INSERT INTO shadowlaststockout
	(
		_id_, _tstamp_,
		update_date, stock_level, days_since_stockout, days_since_update, days_since_reported,
		facility_fk, facilitystock_fk, stockupdate_fk, stock_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.update_date, result.current_level, result.days_since_first_stockout, result.days_since_last_update, result.days_since_stockout_reported,
		result.facility_id, result.facilitystock_id, result.stockupdate_id, result.stock_id
	FROM
	(
		SELECT DISTINCT ON( facilitystock._id_ )
			facility._id_ AS facility_id, facility.name AS facilityname, facilitystock._id_ AS facilitystock_id,
			stock._id_ AS stock_id, stock.itemname,
			stockupdate._id_ AS stockupdate_id, stockupdate.update_date, stockupdate.current_level::integer,
			(
				date_part( 'epoch'::text, age( now(), COALESCE(
					stockupdate.first_stockout_date::timestamp with time zone, now()
				) ) ) / (60 * 60 * 24)::double precision
			)::integer AS days_since_first_stockout,
			(
				date_part( 'epoch'::text, age( now(),
				(
					stockupdate.update_date + '02:00:00'::interval
				) ) ) / (60 * 60 * 24)::double precision
			)::integer AS days_since_last_update,
			(
				date_part( 'epoch'::text, age( now(),
				(
					stockupdate.stockout_reported_to_pdm::timestamp with time zone
				) ) ) / (60 * 60 * 24)::double precision
			 )::integer AS days_since_stockout_reported
		FROM facility
		JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
		JOIN stockupdate ON stockupdate.stockupdate_stock_fk = stock._id_ AND stockupdate.stockupdate_facility_fk = facility._id_
		LEFT JOIN
		(
			SELECT
				stockupdate._id_ AS stockupdate_id,
				stockupdate.stockupdate_facility_fk AS facility_id,
				stockupdate.stockupdate_stock_fk AS stock_id
			FROM stockupdate
			ORDER BY stockupdate.update_date DESC
		) AS last_update
			ON last_update.facility_id = facility._id_
			AND last_update.stock_id = stock._id_
			AND last_update.stockupdate_id = stockupdate._id_
	) AS result
	WHERE result.current_level = 0;

	RETURN 1;
END;

$$;


--
-- Name: generate_shadowlastupdate(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowlastupdate() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM shadowlastupdate;

	INSERT INTO shadowlastupdate
	(
		_id_, _tstamp_,
		facilityname, itemname, category, inventorycode, barcode,
		update_date, stock_level, facility_fk, stock_fk, stockupdate_fk, facilitystock_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.facilityname, result.itemname, result.category, result.inventorycode, result.barcode,
		result.update_date, result.stock_level, result.facility_id, result.stock_id,
		result.stockupdate_id, result.facilitystock_id
	FROM
	(
		SELECT DISTINCT ON( facilitystock._id_ )
			facility._id_ AS facility_id, facility.name AS facilityname,
			stock._id_ AS stock_id, stock.itemname, stock.stock_type AS category, stock.inventorycode, stock.barcode,
			MAX( stockupdates.update_date ) AS update_date, stockupdates.current_level::integer AS stock_level,
			stockupdates.stockupdate_id, facilitystock._id_ AS facilitystock_id
		FROM facility
		JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
		JOIN
		(
			SELECT
				stockupdate._id_ AS stockupdate_id, stockupdate.update_date,
				stockupdate.current_level, stockupdate.stockupdate_facility_fk AS facility_id,
				stockupdate.stockupdate_stock_fk AS stock_id, stockupdate.stockupdate_facilitystock_fk AS facilitystock_id
			FROM stockupdate
		) AS stockupdates ON stockupdates.facility_id = facility._id_ AND stockupdates.stock_id = stock._id_ AND stockupdates.facilitystock_id = facilitystock._id_
		WHERE facility.deleted = 'No' AND stock.deleted = 'No' AND facilitystock.deleted = 'No'
		GROUP BY facility._id_, stock._id_, stockupdates.stockupdate_id, facilitystock._id_, stockupdates.current_level, stockupdates.update_date
		ORDER BY facilitystock._id_, stockupdates.update_date DESC
	) AS result;

	RETURN 1;
END;
$$;


--
-- Name: generate_shadowreportingaggregate(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowreportingaggregate() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM shadowreportingaggregate;

	INSERT INTO shadowreportingaggregate
	(
		_id_, _tstamp_, 
		total_facilities, reporting_facilities, nonreporting_facilities, reporting_stockout_facilities, level,
		subdistrictname, districtname, provincename,
		subdistrict_fk, district_fk, province_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.total_facilities, result.reporting_facilities_percentage, result.nonreporting_facilities_percentage, result.stockout_facilities_percentage,
		result.level, result.subdistrictname, result.districtname, result.provincename,
		result.subdistrict_id, result.district_id, result.province_id
	FROM
	(
		SELECT
			base_data.total_facilities, base_data.reporting_facilities_integer, base_data.nonreporting_facilities_integer, base_data.stockout_facilities_integer, base_data.level,
			subdistrict.name AS subdistrictname, district.name AS districtname, province.name AS provincename,
			subdistrict._id_ AS subdistrict_id, district._id_ AS district_id, province._id_ AS province_id,
			CASE
				WHEN ( base_data.reporting_facilities_integer > 0 )
				THEN ( ROUND( ( base_data.reporting_facilities_integer * 100 ) / base_data.total_facilities ) )::text || '%'
				ELSE '0%'
			END AS reporting_facilities_percentage,
			CASE
				WHEN ( base_data.nonreporting_facilities_integer > 0 )
				THEN ( ROUND( ( base_data.nonreporting_facilities_integer * 100 ) / base_data.total_facilities ) )::text || '%'
				ELSE '0%'
			END AS nonreporting_facilities_percentage,
			CASE
				WHEN ( base_data.stockout_facilities_integer > 0 AND base_data.reporting_facilities_integer > 0 )
				THEN ( ROUND( ( base_data.stockout_facilities_integer * 100 ) / base_data.reporting_facilities_integer ) )::text || '%'
				ELSE '0%'
			END AS stockout_facilities_percentage
		FROM
		(
			SELECT
				subdistrict._id_ AS region_id, 'SubDistrict'::text AS level,
				COUNT( shadowfacility._id_ ) AS total_facilities,
				COALESCE( SUM( CASE WHEN shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) AS reporting_facilities_integer,
				COALESCE( COUNT( shadowfacility._id_ ) - COALESCE( SUM( CASE WHEN shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) ) AS nonreporting_facilities_integer,
				COALESCE( SUM( CASE WHEN shadowfacility.hasstockouts AND shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) AS stockout_facilities_integer
			FROM subdistrict
			LEFT JOIN shadowfacility ON shadowfacility.subdistrict_fk = subdistrict._id_
			GROUP BY subdistrict._id_
			UNION
			SELECT
				district._id_ AS region_id, 'District'::text AS level,
				COUNT( shadowfacility._id_ ) AS total_facilities,
				COALESCE( SUM( CASE WHEN shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) AS reporting_facilities_integer,
				COALESCE( COUNT( shadowfacility._id_ ) - COALESCE( SUM( CASE WHEN shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) ) AS nonreporting_facilities_integer,
				COALESCE( SUM( CASE WHEN shadowfacility.hasstockouts AND shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) AS stockout_facilities_integer
			FROM district
			LEFT JOIN shadowfacility ON shadowfacility.district_fk = district._id_
			GROUP BY district._id_
			UNION
			SELECT
				province._id_ AS region_id, 'Province'::text AS level,
				COUNT( shadowfacility._id_ ) AS total_facilities,
				COALESCE( SUM( CASE WHEN shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) AS reporting_facilities_integer,
				COALESCE( COUNT( shadowfacility._id_ ) - COALESCE( SUM( CASE WHEN shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) ) AS nonreporting_facilities_integer,
				COALESCE( SUM( CASE WHEN shadowfacility.hasstockouts AND shadowfacility.reporting THEN 1 ELSE 0 END ), 0 ) AS stockout_facilities_integer
			FROM province
			LEFT JOIN shadowfacility ON shadowfacility.province_fk = province._id_
			GROUP BY province._id_
		) AS base_data
		LEFT JOIN subdistrict ON base_data.region_id = subdistrict._id_
		LEFT JOIN district ON base_data.region_id = district._id_
		LEFT JOIN province ON base_data.region_id = province._id_
	) AS result;

	RETURN 1;
END;
$$;


--
-- Name: generate_shadowreportingsupplieraggregate(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowreportingsupplieraggregate() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO shadowreportingsupplieraggregate
	(
    /*_id_, _tstamp_,
		total_facilities, reporting_facilities, nonreporting_facilities, reporting_stockout_facilities, level,
		subdistrictname, districtname, provincename,
		subdistrict_fk, district_fk, province_fk*/

  -- Currently This. Needs to be Top one

    _id_, _tstamp_,facilityname,
		vendorname, hasstockout, province_fk , district_fk, subdistrict_fk, facility_fk, vendor_fk

	)

	SELECT
		public.uuid_generate_v4(), now(),
		result.facilityname,
    result.vendorname,
    result.hasstockout,
		result.province_id AS province_fk,
		result.district_id AS district_fk,
    result.subdistrict_id AS subdistrict_fk,
		result.facility_id AS facility_fk,
    result.vendor_id AS vendor_fk


	FROM
	  (
	  SELECT

	  	data_set.facility_id,
	  	data_set.facilityname,
		data_set.subdistrict_id,
		data_set.district_id,
		data_set.province_id,
	  	data_set._vendorid AS vendor_id,
	  	data_set.vendorname,
		data_set.hasstockout

	  FROM
	  (

      SELECT
    		DISTINCT hsa.heliumonlynationalstockavailability_vendor_fk as _vendorid,
		fh._facilityid AS facility_id,
		fh._subdistrictid AS subdistrict_id,
		fh._districtid AS district_id,
		fh._provinceid AS province_id,
    		v.name as vendorname,
		fh.facilityname AS facilityname,
    		CASE
    			WHEN MAX (hsa.current_stock_out)::integer = 0 THEN false
    			ELSE true
    		END AS hasstockout

    	FROM heliumonlynationalstockavailability hsa
    		LEFT JOIN
        (
          SELECT
            p._id_ AS _provinceid,
            d._id_ AS _districtid,
            sd._id_ AS _subdistrictid,
            f._id_ AS _facilityid,
            f.name AS facilityname

          FROM facility f
            LEFT JOIN subdistrict sd ON f.facility_subdistrict_fk = sd._id_
            LEFT JOIN district d ON sd.subdistrict_district_fk = d._id_
            LEFT JOIN province p ON d.district_province_fk = p._id_
          WHERE f.deleted = 'No'::text

        )AS fh on (fh._facilityid = hsa.heliumonlynationalstockavailability_facility_fk)
    		LEFT JOIN vendor v on (v._id_ = hsa.heliumonlynationalstockavailability_vendor_fk)
    	--WHERE  hsa.days_since_last_update_timestamp <= 7
    	GROUP BY _vendorid, fh._facilityid, vendorname, fh.facilityname,fh._subdistrictid, fh._districtid, fh._provinceid
    	ORDER BY facilityname, vendorname, hasstockout DESC

	  ) AS data_set

	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_shadowstockoutsequence(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_shadowstockoutsequence() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
	DELETE FROM shadowstockoutsequence;

	INSERT INTO shadowstockoutsequence
	(
		_id_, _tstamp_,
		firststockout, laststockout, days_since_stockout, days_since_update, days_since_reported,
		facility_fk, facilitystock_fk, stock_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.first_stockout, result.last_stockout, result.days_since_stockout, result.days_since_update, result.days_since_reported,
		result.facility_id, result.facilitystock_id, result.stock_id
	FROM
	(
		SELECT
			facility._id_ AS facility_id,
			shadowfirststockout.update_date AS first_stockout,
			shadowlaststockout.update_date AS last_stockout,
			shadowlaststockout.days_since_stockout, shadowlaststockout.days_since_update, shadowlaststockout.days_since_reported,
			facilitystock._id_ AS facilitystock_id, stock._id_ AS stock_id
		FROM facility
		JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
		JOIN stockupdate ON stockupdate.stockupdate_facilitystock_fk = facilitystock._id_
		JOIN shadowfirststockout
			ON shadowfirststockout.facility_fk = facility._id_
			AND shadowfirststockout.stock_fk = stock._id_
			AND shadowfirststockout.stockupdate_fk = stockupdate._id_
		JOIN shadowlaststockout
			ON shadowlaststockout.facility_fk = facility._id_
			AND shadowlaststockout.stock_fk = stock._id_
			AND shadowlaststockout.stockupdate_fk = stockupdate._id_
		WHERE facility.deleted = 'No' AND stock.deleted = 'No' AND facilitystock.deleted = 'No'
	) AS result;

	RETURN 1;
END;
$$;


--
-- Name: generate_subdistrictstockbycategory(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_subdistrictstockbycategory() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
		SET search_path = zambia__svs_001;
	INSERT INTO SuccessMatrix_StockByCategory
	(
		_id_, _tstamp_,
		"name", stockout_count, stockout_hierarchy_count, availability_percentage, "level", category,
		province_fk , district_fk, subdistrict_fk--, facility_fk
	)
	SELECT
		public.uuid_generate_v4(), now(),
		result.subdistrictname AS "name",
		result.all_subdistrictstock_count,
		result.stockout_subdistrictstock_count,
		result.stockavailability_percentage,
    result.level,
    result.category,
		result.province_id AS province_fk,
		result.district_id AS district_fk,
		result.subdistrict_id AS subdistrict_fk


	FROM
	  (
	  SELECT
	  	data_set.subdistrict_id,
	  	data_set.subdistrictname,
	    data_set.district_id,
	    data_set.province_id,
	  	data_set.all_subdistrictstock_count,
	  	data_set.stockout_subdistrictstock_count,
      data_set.level,
      data_set.category,
	  	CASE
	  		WHEN data_set.all_subdistrictstock_count IS NOT NULL AND data_set.all_subdistrictstock_count != 0 AND
	  		     data_set.stockout_subdistrictstock_count IS NOT NULL AND data_set.stockout_subdistrictstock_count != 0
	  		THEN ( ROUND( ( ( data_set.all_subdistrictstock_count - data_set.stockout_subdistrictstock_count ) * 100 ) / data_set.all_subdistrictstock_count ) )::text || '%'
	  		ELSE '100%'
	  	END AS stockavailability_percentage
	  FROM
	  (
	    SELECT
        'SubDistrict' AS level,
	    	subdistrict._id_ AS subdistrict_id,
	    	subdistrict.name AS subdistrictname,
	      district._id_ AS district_id,
	      province._id_ AS province_id,
	    	COALESCE( SUM( facility_data.all_facilitystock_count ), 0 ) AS all_subdistrictstock_count,
	    	COALESCE( SUM( facility_data.stockout_facilitystock_count ), 0 ) AS stockout_subdistrictstock_count,
        facility_data.category
	    FROM subdistrict
	    JOIN district ON subdistrict.subdistrict_district_fk = district._id_
	    JOIN province ON district.district_province_fk = province._id_
	    JOIN
	    (

        SELECT

      		facility._id_ AS facility_id,
      		facility.name AS facilityname,
      		facility.facility_subdistrict_fk AS subdistrict_id,
      		COUNT( DISTINCT all_alive_facilitystocks.facilitystock_id ) AS all_facilitystock_count,
      		COUNT( DISTINCT stockout_facilitystocks.facilitystock_id ) AS stockout_facilitystock_count,
      		stringgroup.value AS category

      	FROM facility
      	JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
      	JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
      	JOIN stringgroup ON stock.stock_stringgroup_fk = stringgroup._id_
      	JOIN
      	(
      		SELECT
      			facilitystock._id_ AS facilitystock_id,
      			facilitystock.facilitystock_facility_fk AS facility_id,
      			facilitystock.facilitystock_stock_fk AS stock_id
      		FROM facilitystock
      		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

      		WHERE facilitystock.deleted = 'No'
      	) AS all_alive_facilitystocks ON all_alive_facilitystocks.facility_id = facility._id_ AND all_alive_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk

      	LEFT JOIN
      	(
      		SELECT
      			facilitystock._id_ AS facilitystock_id,
      			facilitystock.facilitystock_facility_fk AS facility_id,
      			facilitystock.facilitystock_stock_fk AS stock_id
      		FROM facilitystock
      		LEFT JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_

      		WHERE facilitystock.deleted = 'No' AND facilitystock.stock_out = 'Yes'
      	) AS stockout_facilitystocks ON stockout_facilitystocks.facility_id = facility._id_ AND stockout_facilitystocks.stock_id = facilitystock.facilitystock_stock_fk


      	WHERE facility.deleted = 'No'
      	GROUP BY facility._id_, category

	    ) AS facility_data ON facility_data.subdistrict_id = subdistrict._id_
	    GROUP BY subdistrict._id_, district._id_, province._id_, category
	  ) AS data_set
	) AS result;

	RETURN 1;
	END;
	$$;


--
-- Name: generate_successmatrix_aggregation(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_successmatrix_aggregation() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

-- ================================================= Clear Tables
-- Available Stock Percentage
  PERFORM clear_successMatrixStockAvailability();

-- Stock by category
  PERFORM clear_successMatrixStockByCategory();

-- top Ten Out Of Stock Items
  PERFORM clear_successMatrixTenOutOfStock();
-- =================================================

-- ================================================= Execute Functions
-- Available Stock Percentage
  PERFORM generate_availableFacilityStockPercentage();
  PERFORM generate_availableSubDistrictStockPercentage();
  PERFORM generate_availableDistrictStockPercentage();
  PERFORM generate_availableProvinceStockPercentage();

-- Stock by category
  PERFORM generate_FacilityStockByCategory();
  PERFORM generate_SubDistrictStockByCategory();
  PERFORM generate_DistrictStockByCategory();
  PERFORM generate_ProvinceStockByCategory();

-- top Ten Out Of Stock Items
  PERFORM generate_TenOutOfStockItemsNational();
  PERFORM generate_TenOutOfStockItemsSubDistrict();
  PERFORM generate_TenOutOfStockItemsDistrict();
  PERFORM generate_TenOutOfStockItemsProvince();

-- =================================================

	RETURN 1;
	END;
	$$;


--
-- Name: generate_tenoutofstockitemsdistrict(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_tenoutofstockitemsdistrict() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;
BEGIN
	SET search_path = zambia__svs_001;
	INSERT INTO SuccessMatrix_TenOutOfStock
	(
		_id_, _tstamp_,
		itemname, facility_count, "name", level, stock_fk, district_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.itemname, result.facility_count, result.districtname AS "name", result.level, result.stock_id, result.district_id
	FROM
	(
		SELECT DISTINCT ON ( district._id_, stock._id_ )
			district._id_ AS district_id, district.name AS districtname, stock._id_ AS stock_id, stock.itemname,
			stockout_aggregate.facility_count AS facility_count, 'District' AS level
		FROM district
		JOIN facility ON facility.facility_district_fk = district._id_
		JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
		JOIN
		(
			SELECT
				stock._id_ AS stock_id, facility.facility_district_fk AS district_id,
				COUNT( DISTINCT shadowlastupdate.facility_fk ) AS facility_count
			FROM shadowlastupdate
			JOIN stock ON shadowlastupdate.stock_fk = stock._id_
			JOIN facility ON shadowlastupdate.facility_fk = facility._id_
			WHERE stock.deleted = 'No' AND shadowlastupdate.stock_level = 0
			GROUP BY stock._id_, facility.facility_district_fk
		) AS stockout_aggregate ON stockout_aggregate.stock_id = stock._id_ AND stockout_aggregate.district_id = district._id_
		WHERE facilitystock.deleted = 'No' AND facility.deleted = 'No'
		GROUP BY district._id_, district.name, stock._id_, stock.itemname, stockout_aggregate.facility_count
	) AS result;
	return 1;
END;
$$;


--
-- Name: generate_tenoutofstockitemsnational(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_tenoutofstockitemsnational() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;

	INSERT INTO SuccessMatrix_TenOutOfStock
	(
		_id_, _tstamp_,
		itemname, facility_count, "name", level, stock_fk
	)
  SELECT
  	public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
  	result.itemname, result.facility_count, result.level AS "name", result.level, result.stock_id
  FROM
  (
    SELECT
	   stock._id_ AS stock_id, stock.itemname, stockout_data.facility_count, 'National' AS level
    FROM stock
    JOIN
    (
      SELECT
	     stock._id_ AS stock_id,
       COUNT( DISTINCT shadowlastupdate.facility_fk ) AS facility_count
      FROM shadowlastupdate
      JOIN stock ON shadowlastupdate.stock_fk = stock._id_

      WHERE stock.deleted = 'No' AND stock_level = 0
      GROUP BY stock._id_

    ) AS stockout_data ON stockout_data.stock_id = stock._id_
    ORDER BY  stockout_data.facility_count DESC
    LIMIT 10
  ) AS result;

	RETURN 1;

END;
$$;


--
-- Name: generate_tenoutofstockitemsprovince(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_tenoutofstockitemsprovince() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;
BEGIN
	SET search_path = zambia__svs_001;
	INSERT INTO SuccessMatrix_TenOutOfStock
	(
		_id_, _tstamp_,
		itemname, facility_count, "name", level, stock_fk, province_fk
	)

SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.itemname, result.district_count, result.provincename AS "name",
    result.level, result.stock_id, result.province_id
	FROM
	(
	    SELECT
		    'Province' AS level,
		    province._id_ AS province_id,
		    province.name AS provincename,
		    district_data.itemname,
		    COALESCE( SUM( district_data.facility_count ), 0 ) AS district_count,
		    district_data.stock_id
	    FROM province
	    JOIN
	    (
			SELECT DISTINCT ON ( district._id_, stock._id_ )
				district._id_ AS district_id, district.name AS districtname, stock._id_ AS stock_id, stock.itemname,
				stockout_aggregate.facility_count AS facility_count, district.district_province_fk AS province_id
			FROM district
			JOIN facility ON facility.facility_district_fk = district._id_
			JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
			JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
			JOIN
			(
				SELECT
					stock._id_ AS stock_id, facility.facility_district_fk AS district_id,
					COUNT( DISTINCT shadowlastupdate.facility_fk ) AS facility_count
				FROM shadowlastupdate
				JOIN stock ON shadowlastupdate.stock_fk = stock._id_
				JOIN facility ON shadowlastupdate.facility_fk = facility._id_
				WHERE stock.deleted = 'No' AND shadowlastupdate.stock_level = 0
				GROUP BY stock._id_, facility.facility_district_fk
			) AS stockout_aggregate ON stockout_aggregate.stock_id = stock._id_ AND stockout_aggregate.district_id = district._id_
	      WHERE facilitystock.deleted = 'No' AND facility.deleted = 'No'
	      GROUP BY district._id_, district.name, stock._id_, stock.itemname, stockout_aggregate.facility_count
	) AS district_data ON province_id = province._id_
	GROUP BY province._id_,province.name, district_data.stock_id, district_data.itemname
) AS result;

	return 1;
END;
$$;


--
-- Name: generate_tenoutofstockitemssubdistrict(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.generate_tenoutofstockitemssubdistrict() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;
BEGIN
	SET search_path = zambia__svs_001;
	INSERT INTO SuccessMatrix_TenOutOfStock
	(
		_id_, _tstamp_,
		itemname, facility_count, "name", level, stock_fk, subdistrict_fk
	)
	SELECT
		public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
		result.itemname, result.facility_count, result.subdistrictname AS "name", result.level, result.stock_id, result.subdistrict_id
	FROM
	(
		SELECT DISTINCT ON ( subdistrict._id_, stock._id_ )
			subdistrict._id_ AS subdistrict_id, subdistrict.name AS subdistrictname, stock._id_ AS stock_id, stock.itemname,
			stockout_aggregate.facility_count AS facility_count, 'SubDistrict' AS level
		FROM subdistrict
		JOIN facility ON facility.facility_subdistrict_fk = subdistrict._id_
		JOIN facilitystock ON facilitystock.facilitystock_facility_fk = facility._id_
		JOIN stock ON facilitystock.facilitystock_stock_fk = stock._id_
		JOIN
		(
			SELECT
				stock._id_ AS stock_id, facility.facility_subdistrict_fk AS subdistrict_id,
				COUNT( DISTINCT shadowlastupdate.facility_fk ) AS facility_count
			FROM shadowlastupdate
			JOIN stock ON shadowlastupdate.stock_fk = stock._id_
			JOIN facility ON shadowlastupdate.facility_fk = facility._id_
			WHERE stock.deleted = 'No' AND shadowlastupdate.stock_level = 0
			GROUP BY stock._id_, facility.facility_subdistrict_fk
		) AS stockout_aggregate ON stockout_aggregate.stock_id = stock._id_ AND stockout_aggregate.subdistrict_id = subdistrict._id_
		WHERE facilitystock.deleted = 'No' AND facility.deleted = 'No'
		GROUP BY subdistrict._id_, subdistrict.name, stock._id_, stock.itemname, stockout_aggregate.facility_count
	) AS result;
	return 1;
END;
$$;


--
-- Name: __he_sync_change_seq__; Type: SEQUENCE; Schema: zambia__svs_001; Owner: -
--

CREATE SEQUENCE zambia__svs_001.__he_sync_change_seq__
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: facilitystock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.facilitystock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    low_stock text,
    stock_out text,
    total integer,
    low_stock_time timestamp without time zone,
    stock_out_time timestamp without time zone,
    low_stock_resolved_time timestamp without time zone,
    stock_out_resolved_time timestamp without time zone,
    stock_out_reported timestamp without time zone,
    min integer,
    max integer,
    barcode text,
    deleted text,
    facilitystock_facility_fk uuid,
    facilitystock_stock_fk uuid,
    facilitystock_lowstock_fk uuid,
    facilitystock_stockout_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: get_facilitystock_copy(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.get_facilitystock_copy() RETURNS SETOF zambia__svs_001.facilitystock
    LANGUAGE plpgsql
    AS $$
BEGIN
	create temp table if not exists facilitystock_copy (like facilitystock) on commit drop;

	return query select * from facilitystock_copy;
END;
$$;


--
-- Name: heliumonlyhierarchystocklevel_aggregation_executor_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.heliumonlyhierarchystocklevel_aggregation_executor_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
the_schema = 'zambia__svs_001';
EXECUTE 'TRUNCATE ' || the_schema || '.HeliumOnlyHierarchyStockLevel';
EXECUTE 'INSERT INTO ' || the_schema || '.HeliumOnlyHierarchyStockLevel ( _id_, _tstamp_, itemname, inventorycode, total_stocks, hierarchystocklevel_province_fk, hierarchystocklevel_district_fk, hierarchystocklevel_subdistrict_fk, hierarchystocklevel_facility_fk, hierarchy_name)
SELECT _id_, _tstamp_, itemname, inventorycode, total_stocks, province_uuid, district_uuid, subdistrict_uuid, facility_uuid, hierarchy_name FROM ' || the_schema || '.HeliumOnlyhierarchystocklevel_aggregation_logic_view';
RETURN 1;
END;
$$;


--
-- Name: heliumonlynationalstockavailability_aggregation_executor_functi(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.heliumonlynationalstockavailability_aggregation_executor_functi() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
the_schema = 'zambia__svs_001';
EXECUTE 'TRUNCATE ' || the_schema || '.HeliumOnlyNationalStockAvailability';
EXECUTE 'INSERT INTO ' || the_schema || '.HeliumOnlyNationalStockAvailability ( _id_, _tstamp_, 
stockcategory, 
        itemname, 
        abbreviation,
        inventorycode, 
        barcode,
         
        expiry_date, 
        last_updatedate_timestamp, 
        first_stockout_date, 
        last_stock_update_datetime, 
        stockout_reported_to_pdm, 


        stock_level, 
        stock_received, 
        stock_lost, 
        current_stock_out,
                    
        days_since_first_stockout, 
        days_since_last_update_timestamp, 
        days_since_stockout_reported_to_pdm_timestamp,

        location,
heliumonlynationalstockavailability_stock_fk,
heliumonlynationalstockavailability_stockupdate_fk,
heliumonlynationalstockavailability_facilitystock_fk,
heliumonlynationalstockavailability_facility_fk)

SELECT _id_, _tstamp_, 
stockcategory, 
        itemname, 
        abbreviation,
        inventorycode, 
        barcode,
         
        expiry_date, 
        last_updatedate_timestamp, 
        first_stockout_date, 
        last_stock_update_datetime, 
        stockout_reported_to_pdm, 


        stock_level, 
        stock_received, 
        stock_lost, 
        current_stock_out,
                    
        days_since_first_stockout, 
        days_since_last_update_timestamp, 
        days_since_stockout_reported_to_pdm_timestamp,

        location,

        stock_uuid,
        stockupdate_uuid,
        facilitystock_uuid,
        facility_uuid FROM ' || the_schema || '.heliumonlynationalstockavailability_aggregation_logic_view';
RETURN 1;
END;
$$;


--
-- Name: heliumonlynationalstockoutreasons_agg_executor_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.heliumonlynationalstockoutreasons_agg_executor_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
the_schema = 'zambia__svs_001';
EXECUTE 'TRUNCATE ' || the_schema || '.heliumonlynationalstockoutreasons';
EXECUTE 'INSERT INTO ' || the_schema || '.heliumonlynationalstockoutreasons (
_id_, _tstamp_,
stockcategory,
itemname,
inventorycode,
barcode,
first_stockout_date,
last_stock_out_update_datetime,
stockout_reported_to_pdm,
location,
days_since_first_stockout,
days_since_last_update_timestamp,
days_since_stockout_reported_to_pdm_timestamp,
stockoutreasonsstatus,
stockoutreasons,
availabilityofalternative,
heliumonlynationalstockoutreasons_stock_fk,
heliumonlynationalstockoutreasons_stockupdate_fk,
heliumonlynationalstockoutreasons_facilitystock_fk,
heliumonlynationalstockoutreasons_facility_fk )

SELECT
_id_, _tstamp_,
stockcategory,
itemname,
inventorycode,
barcode,
first_stockout_date,
last_stock_out_update_datetime,
stockout_reported_to_pdm,
location,
days_since_first_stockout,
days_since_last_update_timestamp,
days_since_stockout_reported_to_pdm_timestamp,
stockoutreasonsstatus,
stockoutreasons,
availabilityofalternative,
stock_uuid,
stockupdate_uuid,
facilitystock_uuid,
facility_uuid
FROM ' || the_schema || '.heliumonlynationalstockoutreasons_agg_logic_view';
RETURN 1;
END;
$$;


--
-- Name: heliumonlynationalstockoutreasons_aggregation_executor_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.heliumonlynationalstockoutreasons_aggregation_executor_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
the_schema = 'zambia__svs_001';
EXECUTE 'TRUNCATE ' || the_schema || '.heliumonlynationalstockoutreasons';
EXECUTE 'INSERT INTO ' || the_schema || '.heliumonlynationalstockoutreasons (
_id_, _tstamp_,
stockcategory,
itemname,
inventorycode,
barcode,
first_stockout_date,
last_stock_out_update_datetime,
stockout_reported_to_pdm,
location,
days_since_first_stockout,
days_since_last_update_timestamp,
days_since_stockout_reported_to_pdm_timestamp,
stockoutreasonsstatus,
stockoutreasons,
availabilityofalternative,
heliumonlynationalstockoutreasons_stock_fk,
heliumonlynationalstockoutreasons_stockupdate_fk,
heliumonlynationalstockoutreasons_facilitystock_fk,
heliumonlynationalstockoutreasons_facility_fk )

SELECT
_id_, _tstamp_,
stockcategory,
itemname,
inventorycode,
barcode,
first_stockout_date,
last_stock_out_update_datetime,
stockout_reported_to_pdm,
location,
days_since_first_stockout,
days_since_last_update_timestamp,
days_since_stockout_reported_to_pdm_timestamp,
stockoutreasonsstatus,
stockoutreasons,
availabilityofalternative,
stock_uuid,
stockupdate_uuid,
facilitystock_uuid,
facility_uuid
FROM ' || the_schema || '.heliumonlynationalstockoutreasons_aggregation_logic_view';
RETURN 1;
END;
$$;


--
-- Name: heliumonlypdm_facilities_with_stockouts_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.heliumonlypdm_facilities_with_stockouts_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
 the_schema = 'zambia__svs_001';
 EXECUTE 'TRUNCATE ' || the_schema || '.heliumonlypdm_facilities_with_stockouts';
 EXECUTE 'INSERT INTO ' || the_schema || '.heliumonlypdm_facilities_with_stockouts
 (_id_, _tstamp_, districtname,
   facilityname, numberofstockouts, numberofstockouts_with_alternative,
   facilityuuid, districtuuid, provinceuuid)
  SELECT public.uuid_generate_v4() AS _id_, now() AS _tstamp_,districtname,
  facilityname, numberofstockouts, numberofstockouts_with_alternative,
  facilityuuid, districtuuid, provinceuuid
  FROM ' || the_schema || '.heliumonlypdm_facilities_with_stockouts_agg_logic_view';
 RETURN 1;
END;
$$;


--
-- Name: pdm_facility_outstanding_update_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.pdm_facility_outstanding_update_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
 the_schema = 'zambia__svs_001';
 EXECUTE 'TRUNCATE ' || the_schema || '.pdm_facility_outstanding_update';
 EXECUTE 'INSERT INTO ' || the_schema || '.pdm_facility_outstanding_update
 (_id_, _tstamp_,
   facilityname, contact_number, subdistrictname,
   districtname,facilityuuid, provinceuuid
 )
  SELECT public.uuid_generate_v4() AS _id_, now() AS _tstamp_,
  facilityname, contact_number, subdistrictname,
  districtname,facilityuuid, provinceuuid
  FROM ' || the_schema || '.pdm_facility_outstanding_update_aggregation_logic_view';
 RETURN 1;
END;
$$;


--
-- Name: refresh_materializedviews_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.refresh_materializedviews_function() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE the_schema text;
BEGIN
 the_schema = 'zambia__svs_001 ';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.reportstockoutnationalview';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.reportstockoutprovincialview';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.reportstockoutdistrictview';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.reportstockoutsubdistrictview';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.stockresponseratesubdistrictview';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.stockresponserateview';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.national_facility_topitems_currentweek';
 EXECUTE 'REFRESH MATERIALIZED VIEW ' || the_schema || '.facilityoutstandingstocksubmission_materializedview';
 RETURN 1;
END;
$$;


--
-- Name: refresh_survailance_reports_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.refresh_survailance_reports_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result integer;
BEGIN
	SET search_path = zambia__svs_001;
  REFRESH MATERIALIZED VIEW surveilanceupdates_levels_materialized_view;
  REFRESH MATERIALIZED VIEW surveilanceupdates_aggr_materialized_view;
	SELECT 1 INTO result;
	RETURN result;
END;
$$;


--
-- Name: stockoutdurationitemscategory_aggr_function(); Type: FUNCTION; Schema: zambia__svs_001; Owner: -
--

CREATE FUNCTION zambia__svs_001.stockoutdurationitemscategory_aggr_function() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE the_schema text;
BEGIN
 the_schema = 'zambia__svs_001';
 EXECUTE 'TRUNCATE ' || the_schema || '.heliumonlystockoutdurationitemsforcategory';
EXECUTE 'INSERT INTO ' || the_schema || '.heliumonlystockoutdurationitemsforcategory ( _id_, _tstamp_, stockcategory, itemname, inventorycode, barcode, first_stockout_date, last_stock_out_update_datetime, stockout_reported_to_pdm, location, days_since_first_stockout, days_since_last_update_timestamp, days_since_stockout_reported_to_pdm_timestamp,
heliumonlystockoutdurationitemsforcategory_stock_fk,
heliumonlystockoutdurationitemsforcategory_stockupdate_fk,
heliumonlystockoutdurationitemsforcategory_facilitystock_fk,
heliumonlystockoutdurationitemsforcategory_facility_fk,
heliumonlystockoutdurationitemsforcategory_subdistrict_fk,
heliumonlystockoutdurationitemsforcategory_district_fk,
heliumonlystockoutdurationitemsforcategory_province_fk)

SELECT
_id_, _tstamp_, stockcategory, itemname, inventorycode, barcode,
first_stockout_date,
last_stock_out_update_datetime,
stockout_reported_to_pdm, location,
days_since_first_stockout,
days_since_last_update_timestamp,
days_since_stockout_reported_to_pdm_timestamp,
    stock_uuid,
    stockupdate_uuid,
    facilitystock_uuid,
    facility_uuid,
    subdistrict_uuid,
    district_uuid,
    province_uuid FROM ' || the_schema || '.stockoutdurationitemsforcategory_aggr_logic_view';
RETURN 1;
END;
$$;


--
-- Name: districtstock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.districtstock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    low_stock text,
    stock_out text,
    total integer,
    stock_out_time timestamp without time zone,
    low_stock_time timestamp without time zone,
    low_stock_resolved_time timestamp without time zone,
    stock_out_resolved_time timestamp without time zone,
    stock_level_min integer NOT NULL,
    stock_level_max integer NOT NULL,
    deleted text,
    districtstock_district_fk uuid,
    districtstock_stock_fk uuid,
    districtstock_lowstock_fk uuid,
    districtstock_stockout_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: stock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    inventorycode text NOT NULL,
    itemname text NOT NULL,
    abbreviation text NOT NULL,
    supplier text NOT NULL,
    ven_status text,
    message_construct_placeholder text,
    barcode character varying(13) NOT NULL,
    total integer,
    packsize text,
    stock_level_min integer NOT NULL,
    stock_level_max integer NOT NULL,
    stock_type text NOT NULL,
    deleted text,
    stock_stringgroup_fk uuid,
    stock_vendor_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: vendordistrictstock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.vendordistrictstock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    low_stock text,
    stock_out text,
    total integer,
    stock_out_time timestamp without time zone,
    low_stock_time timestamp without time zone,
    low_stock_resolved_time timestamp without time zone,
    stock_out_resolved_time timestamp without time zone,
    stock_level_min integer NOT NULL,
    stock_level_max integer NOT NULL,
    deleted text,
    vendordistrictstock_district_fk uuid,
    vendordistrictstock_vendorstock_fk uuid,
    vendordistrictstock_districtpharmacymanager_lowstock_fk uuid,
    vendordistrictstock_districtpharmacymanager_stockout_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: vendorstock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.vendorstock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    inventorycode text NOT NULL,
    itemname text NOT NULL,
    abbreviation text NOT NULL,
    supplier text NOT NULL,
    message_construct_placeholder text,
    barcode character varying(13) NOT NULL,
    ven_status text,
    total integer,
    packsize text,
    stock_level_min integer NOT NULL,
    stock_level_max integer NOT NULL,
    stock_type text NOT NULL,
    deleted text,
    vendorstock_stringgroup_fk uuid,
    vendorstock_vendor_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: __districtstocktoupdateview__; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.__districtstocktoupdateview__ AS
 SELECT stockrow._id_,
    stockrow._tstamp_,
    stockrow.low_stock,
    stockrow.stock_out,
    stockrow.total,
    stockrow.stock_out_time,
    stockrow.low_stock_time,
    stockrow.low_stock_resolved_time,
    stockrow.stock_out_resolved_time,
    stockrow.stock_level_min,
    stockrow.stock_level_max,
    stockrow.deleted,
    productstock._id_ AS districtstock_id,
    stockrow.vendordistrictstock_district_fk AS districtstock_district,
    s._id_ AS districtstock_stock,
    stockrow.vendordistrictstock_districtpharmacymanager_lowstock_fk AS districtstock_lowstock,
    stockrow.vendordistrictstock_districtpharmacymanager_stockout_fk AS districtstock_stockout
   FROM ((( SELECT row_number() OVER (PARTITION BY vds.vendordistrictstock_district_fk, vs.inventorycode ORDER BY vs.deleted, vs.inventorycode, vs.itemname, vds.deleted, vs.abbreviation) AS row_num,
            vds._id_,
            vds._tstamp_,
            vds.low_stock,
            vds.stock_out,
            vds.total,
            vds.stock_out_time,
            vds.low_stock_time,
            vds.low_stock_resolved_time,
            vds.stock_out_resolved_time,
            vds.stock_level_min,
            vds.stock_level_max,
            vds.deleted,
            vds.vendordistrictstock_district_fk,
            vds.vendordistrictstock_vendorstock_fk,
            vds.vendordistrictstock_districtpharmacymanager_lowstock_fk,
            vds.vendordistrictstock_districtpharmacymanager_stockout_fk,
            vs.inventorycode
           FROM (zambia__svs_001.vendordistrictstock vds
             JOIN zambia__svs_001.vendorstock vs ON ((vds.vendordistrictstock_vendorstock_fk = vs._id_)))) stockrow
     JOIN zambia__svs_001.stock s ON ((stockrow.inventorycode = s.inventorycode)))
     LEFT JOIN ( SELECT s_1.inventorycode,
            ds._id_,
            ds._tstamp_,
            ds.low_stock,
            ds.stock_out,
            ds.total,
            ds.stock_out_time,
            ds.low_stock_time,
            ds.low_stock_resolved_time,
            ds.stock_out_resolved_time,
            ds.districtstock_district_fk,
            ds.districtstock_stock_fk,
            ds.districtstock_lowstock_fk,
            ds.districtstock_stockout_fk,
            ds.stock_level_min,
            ds.stock_level_max,
            ds.deleted
           FROM (zambia__svs_001.districtstock ds
             JOIN zambia__svs_001.stock s_1 ON ((ds.districtstock_stock_fk = s_1._id_)))) productstock ON (((stockrow.vendordistrictstock_district_fk = productstock.districtstock_district_fk) AND (stockrow.inventorycode = productstock.inventorycode))))
  WHERE ((stockrow.row_num = 1) AND ((stockrow.deleted <> productstock.deleted) OR (stockrow.inventorycode <> productstock.inventorycode) OR (productstock.inventorycode IS NULL)) AND (stockrow.vendordistrictstock_district_fk IS NOT NULL));


--
-- Name: __facilityproductstatusviewoutput__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__facilityproductstatusviewoutput__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    facility_name text,
    priority integer,
    icon text,
    code text,
    mobile text,
    gps_longitude numeric,
    gps_latitude numeric,
    dataset integer,
    facilityproductstatusviewoutput_facility_fk uuid
);


--
-- Name: vendorfacilitystock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.vendorfacilitystock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    low_stock text,
    stock_out text,
    total integer,
    low_stock_time timestamp without time zone,
    stock_out_time timestamp without time zone,
    low_stock_resolved_time timestamp without time zone,
    stock_out_resolved_time timestamp without time zone,
    stock_out_reported timestamp without time zone,
    min integer,
    max integer,
    barcode text,
    deleted text,
    vendorfacilitystock_facility_fk uuid,
    vendorfacilitystock_vendorstock_fk uuid,
    vendorfacilitystock_facilitymanager_lowstock_fk uuid,
    vendorfacilitystock_facilitymanager_stockout_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: __facilitystocktoupdateview__; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.__facilitystocktoupdateview__ AS
 SELECT stockrow._id_,
    stockrow._tstamp_,
    stockrow.low_stock,
    stockrow.stock_out,
    stockrow.total,
    stockrow.low_stock_time,
    stockrow.stock_out_time,
    stockrow.low_stock_resolved_time,
    stockrow.stock_out_resolved_time,
    stockrow.stock_out_reported,
    stockrow.min,
    stockrow.max,
    stockrow.barcode,
    stockrow.deleted,
    productstock._id_ AS facilitystock_id,
    stockrow.vendorfacilitystock_facility_fk AS facilitystock_facility,
    s._id_ AS facilitystock_stock,
    stockrow.vendorfacilitystock_facilitymanager_lowstock_fk AS facilitystock_lowstock,
    stockrow.vendorfacilitystock_facilitymanager_lowstock_fk AS facilitystock_stockout
   FROM ((( SELECT row_number() OVER (PARTITION BY vfs.vendorfacilitystock_facility_fk, vs.inventorycode ORDER BY vs.deleted, vfs.deleted, vs.itemname) AS row_num,
            vfs._id_,
            vfs._tstamp_,
            vfs.low_stock,
            vfs.stock_out,
            vfs.total,
            vfs.low_stock_time,
            vfs.stock_out_time,
            vfs.low_stock_resolved_time,
            vfs.stock_out_resolved_time,
            vfs.stock_out_reported,
            vfs.min,
            vfs.max,
            vfs.barcode,
            vfs.deleted,
            vfs.vendorfacilitystock_facility_fk,
            vfs.vendorfacilitystock_vendorstock_fk,
            vfs.vendorfacilitystock_facilitymanager_lowstock_fk,
            vfs.vendorfacilitystock_facilitymanager_stockout_fk,
            vs.inventorycode
           FROM (zambia__svs_001.vendorfacilitystock vfs
             JOIN zambia__svs_001.vendorstock vs ON ((vfs.vendorfacilitystock_vendorstock_fk = vs._id_)))) stockrow
     JOIN zambia__svs_001.stock s ON ((stockrow.inventorycode = s.inventorycode)))
     LEFT JOIN ( SELECT s_1.inventorycode,
            fs._id_,
            fs._tstamp_,
            fs.low_stock,
            fs.stock_out,
            fs.total,
            fs.low_stock_time,
            fs.stock_out_time,
            fs.low_stock_resolved_time,
            fs.stock_out_resolved_time,
            fs.min,
            fs.max,
            fs.barcode,
            fs.facilitystock_facility_fk,
            fs.facilitystock_stock_fk,
            fs.facilitystock_lowstock_fk,
            fs.facilitystock_stockout_fk,
            fs.stock_out_reported,
            fs.deleted
           FROM (zambia__svs_001.facilitystock fs
             JOIN zambia__svs_001.stock s_1 ON ((fs.facilitystock_stock_fk = s_1._id_)))) productstock ON (((stockrow.vendorfacilitystock_facility_fk = productstock.facilitystock_facility_fk) AND (stockrow.inventorycode = productstock.inventorycode))))
  WHERE ((stockrow.row_num = 1) AND ((stockrow.deleted <> productstock.deleted) OR (stockrow.inventorycode <> productstock.inventorycode) OR (productstock.inventorycode IS NULL)) AND (stockrow.vendorfacilitystock_facility_fk IS NOT NULL) AND (stockrow.barcode <> 'Attached'::text));


--
-- Name: __facilitystockupdateoutput__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__facilitystockupdateoutput__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    low_stock text,
    stock_out text,
    total integer,
    min integer,
    max integer,
    low_stock_time timestamp without time zone,
    stock_out_time timestamp without time zone,
    low_stock_resolved_time timestamp without time zone,
    stock_out_resolved_time timestamp without time zone,
    stock_out_reported timestamp without time zone,
    barcode text,
    deleted text,
    facilitystock_id uuid,
    facilitystock_facility uuid,
    facilitystock_stock uuid,
    facilitystock_lowstock uuid,
    facilitystock_stockout uuid
);


--
-- Name: __he_data_version__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_data_version__ (
    id integer NOT NULL,
    objects_hash integer NOT NULL,
    migration_tstamp timestamp with time zone NOT NULL
);


--
-- Name: __he_data_version___id_seq; Type: SEQUENCE; Schema: zambia__svs_001; Owner: -
--

CREATE SEQUENCE zambia__svs_001.__he_data_version___id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: __he_data_version___id_seq; Type: SEQUENCE OWNED BY; Schema: zambia__svs_001; Owner: -
--

ALTER SEQUENCE zambia__svs_001.__he_data_version___id_seq OWNED BY zambia__svs_001.__he_data_version__.id;


--
-- Name: __he_meta_data_version__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_meta_data_version__ (
    id integer NOT NULL,
    migration_tstamp timestamp with time zone NOT NULL
);


--
-- Name: __he_sync_bookmark__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_bookmark__ (
    tx_id bigint NOT NULL,
    tx_tstamp timestamp with time zone NOT NULL,
    entity jsonb NOT NULL,
    client_id uuid NOT NULL
);


--
-- Name: __he_sync_bookmark_current__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_bookmark_current__ (
    CONSTRAINT check_tx_id CHECK ((tx_id >= 0))
)
INHERITS (zambia__svs_001.__he_sync_bookmark__);


--
-- Name: __he_sync_client__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_client__ (
    client_id uuid NOT NULL,
    entity jsonb NOT NULL
);


--
-- Name: __he_sync_client_request_log__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_client_request_log__ (
    tx_id bigint NOT NULL,
    tx_tstamp timestamp with time zone NOT NULL,
    client_id uuid NOT NULL,
    request_bookmark_id bigint,
    response_bookmark_id bigint NOT NULL
);


--
-- Name: __he_sync_client_request_log_current__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_client_request_log_current__ (
    CONSTRAINT check_tx_id CHECK ((tx_id >= 0))
)
INHERITS (zambia__svs_001.__he_sync_client_request_log__);


--
-- Name: __he_sync_many_to_many_unlink__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_many_to_many_unlink__ (
    seq bigint NOT NULL,
    relationship_name character varying(128) NOT NULL,
    left_uuid uuid NOT NULL,
    right_uuid uuid NOT NULL,
    tx_id bigint NOT NULL
);


--
-- Name: __he_sync_many_to_many_unlink_current__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_many_to_many_unlink_current__ (
    CONSTRAINT check_tx_id CHECK ((tx_id >= 0))
)
INHERITS (zambia__svs_001.__he_sync_many_to_many_unlink__);


--
-- Name: __he_sync_obj_change__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_obj_change__ (
    seq bigint NOT NULL,
    change zambia__svs_001.__he_sync_obj_change_type__ NOT NULL,
    object_name character varying(64) NOT NULL,
    object_uuid uuid NOT NULL,
    tx_id bigint
);


--
-- Name: __he_sync_obj_change_current__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_obj_change_current__ (
    CONSTRAINT check_tx_id CHECK ((tx_id >= 0))
)
INHERITS (zambia__svs_001.__he_sync_obj_change__);


--
-- Name: __he_sync_transaction_log__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_transaction_log__ (
    tx_id bigint NOT NULL,
    tx_tstamp timestamp with time zone NOT NULL,
    seq_before bigint NOT NULL,
    seq_after bigint NOT NULL,
    identity_id uuid
);


--
-- Name: __he_sync_transaction_log_current__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__he_sync_transaction_log_current__ (
    CONSTRAINT check_tx_id CHECK ((tx_id >= 0))
)
INHERITS (zambia__svs_001.__he_sync_transaction_log__);


--
-- Name: __identity_invite_user__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__identity_invite_user__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    userreference uuid,
    contactfield text,
    userrole text,
    emailaddress text
);


--
-- Name: __identity_remove_role__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__identity_remove_role__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    userreferenceid uuid
);


--
-- Name: __logging_log__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__logging_log__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    userid uuid,
    key text,
    value text,
    "time" timestamp without time zone
);


--
-- Name: __ndoh_message_log__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__ndoh_message_log__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    user_names text,
    contact text,
    message_type text,
    user_role text,
    location text,
    date_created timestamp without time zone,
    content text,
    message_title text,
    sender_name text,
    sender_contact text
);


--
-- Name: __notification_email__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__notification_email__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    userreferenceid uuid,
    destinationreferenceid uuid,
    destinationaddress text,
    descriptionkey text,
    subjectkey text,
    bodykey text,
    templatename text
);


--
-- Name: __notification_email_attachment__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__notification_email_attachment__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    attachmenttype text,
    resourceindex integer,
    notificationemail_fk uuid
);


--
-- Name: __notification_message__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__notification_message__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    userreferenceid uuid,
    destinationreferenceid uuid,
    descriptionkey text,
    smskey text,
    emailsubjectkey text,
    emailbodykey text,
    smspreferred boolean
);


--
-- Name: __notification_message_arg__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__notification_message_arg__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    key text,
    valuetype text,
    value text,
    notificationemail_fk uuid,
    message_fk uuid
);


--
-- Name: __notification_sms__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__notification_sms__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    userreferenceid uuid,
    destinationreferenceid uuid,
    destination text,
    message text,
    tags text
);


--
-- Name: __payment__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__payment__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    senderid uuid,
    sendertype text,
    receiverid uuid,
    receivertype text,
    amount integer,
    currencycode text,
    tags text,
    paymentstatus_fk uuid
);


--
-- Name: __payment_status_record__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__payment_status_record__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    status character varying(64)
);


--
-- Name: __payment_with_ref__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__payment_with_ref__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    senderid uuid,
    sendertype text,
    receiverid uuid,
    receivertype text,
    amount integer,
    currencycode text,
    ref text,
    description text,
    paymentstatus_fk uuid
);


--
-- Name: __payment_with_ref_status_record__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__payment_with_ref_status_record__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    status character varying(64)
);


--
-- Name: __productstockupdateoutput__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__productstockupdateoutput__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    category text,
    itemname text,
    inventorycode text,
    update_date text,
    days_stockout integer,
    days_since_update integer,
    available_stock text,
    expiry_date date,
    stock_received integer,
    stock_lost integer,
    dataset integer,
    productupdatedetails_facility_fk uuid
);


--
-- Name: provincialstock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.provincialstock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    low_stock text,
    stock_out text,
    total integer,
    stock_out_time timestamp without time zone,
    low_stock_time timestamp without time zone,
    low_stock_resolved_time timestamp without time zone,
    stock_out_resolved_time timestamp without time zone,
    deleted text,
    provincialstock_province_fk uuid,
    provincialstock_stock_fk uuid,
    provincialstock_lowstock_fk uuid,
    provincialstock_stockout_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: vendorprovincialstock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.vendorprovincialstock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    low_stock text,
    stock_out text,
    total integer,
    stock_out_time timestamp without time zone,
    low_stock_time timestamp without time zone,
    low_stock_resolved_time timestamp without time zone,
    stock_out_resolved_time timestamp without time zone,
    deleted text,
    vendorprovincialstock_province_fk uuid,
    vendorprovincialstock_vendorstock_fk uuid,
    vendorprovincialstock_provincialdepotmanager_lowstock_fk uuid,
    vendorprovincialstock_provincialdepotmanager_stockout_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: __provincialstocktoupdateview__; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.__provincialstocktoupdateview__ AS
 SELECT stockrow._id_,
    stockrow._tstamp_,
    stockrow.low_stock,
    stockrow.stock_out,
    stockrow.total,
    stockrow.stock_out_time,
    stockrow.low_stock_time,
    stockrow.low_stock_resolved_time,
    stockrow.stock_out_resolved_time,
    stockrow.deleted,
    productstock._id_ AS provincialstock_id,
    stockrow.vendorprovincialstock_province_fk AS provincialstock_province,
    s._id_ AS provincialstock_stock,
    stockrow.vendorprovincialstock_provincialdepotmanager_lowstock_fk AS provincialstock_lowstock,
    stockrow.vendorprovincialstock_provincialdepotmanager_stockout_fk AS provincialstock_stockout
   FROM ((( SELECT row_number() OVER (PARTITION BY vps.vendorprovincialstock_province_fk, vs.inventorycode ORDER BY vs.deleted, vs.inventorycode, vs.itemname, vps.deleted, vs.abbreviation) AS row_num,
            vps._id_,
            vps._tstamp_,
            vps.low_stock,
            vps.stock_out,
            vps.total,
            vps.stock_out_time,
            vps.low_stock_time,
            vps.low_stock_resolved_time,
            vps.stock_out_resolved_time,
            vps.deleted,
            vps.vendorprovincialstock_province_fk,
            vps.vendorprovincialstock_vendorstock_fk,
            vps.vendorprovincialstock_provincialdepotmanager_lowstock_fk,
            vps.vendorprovincialstock_provincialdepotmanager_stockout_fk,
            vs.inventorycode
           FROM (zambia__svs_001.vendorprovincialstock vps
             JOIN zambia__svs_001.vendorstock vs ON ((vps.vendorprovincialstock_vendorstock_fk = vs._id_)))) stockrow
     JOIN zambia__svs_001.stock s ON ((stockrow.inventorycode = s.inventorycode)))
     LEFT JOIN ( SELECT s_1.inventorycode,
            ps._id_,
            ps._tstamp_,
            ps.low_stock,
            ps.stock_out,
            ps.total,
            ps.stock_out_time,
            ps.low_stock_time,
            ps.low_stock_resolved_time,
            ps.stock_out_resolved_time,
            ps.provincialstock_province_fk,
            ps.provincialstock_stock_fk,
            ps.provincialstock_lowstock_fk,
            ps.provincialstock_stockout_fk,
            ps.deleted
           FROM (zambia__svs_001.provincialstock ps
             JOIN zambia__svs_001.stock s_1 ON ((ps.provincialstock_stock_fk = s_1._id_)))) productstock ON (((stockrow.vendorprovincialstock_province_fk = productstock.provincialstock_province_fk) AND (stockrow.inventorycode = productstock.inventorycode))))
  WHERE ((stockrow.row_num = 1) AND ((stockrow.deleted <> productstock.deleted) OR (stockrow.inventorycode <> productstock.inventorycode) OR (productstock.inventorycode IS NULL)));


--
-- Name: __scheduled_function_result__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__scheduled_function_result__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    datetimestampstarted timestamp without time zone,
    datetimestampfinished timestamp without time zone,
    qualifiedname text,
    schedule text,
    error text,
    stacktrace text,
    success boolean
);


--
-- Name: __sms_result__; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.__sms_result__ (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    datetimestampstarted timestamp without time zone,
    datetimestampfinished timestamp without time zone,
    destination text,
    attempt integer,
    success boolean,
    error text,
    doneprocessing boolean,
    smsoutboundconfigurationversionid uuid,
    smsoutboundconfigurationname text,
    smspartnername text,
    smsid uuid
);


--
-- Name: __stocktoupdateview__; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.__stocktoupdateview__ AS
 SELECT stockbyrow._id_,
    stockbyrow._tstamp_,
    stockbyrow.inventorycode,
    stockbyrow.itemname,
    stockbyrow.itemname AS abbreviation,
    stockbyrow.supplier,
    stockbyrow.message_construct_placeholder,
    stockbyrow.barcode,
    stockbyrow.total,
    stockbyrow.stock_level_min,
    stockbyrow.stock_level_max,
    stockbyrow.stock_type,
    stockbyrow.deleted,
    s._id_ AS stock_id,
    stockbyrow.vendorstock_stringgroup_fk AS stock_stringgroup,
    stockbyrow.vendorstock_vendor_fk AS stock_vendor,
    stockbyrow.ven_status,
    stockbyrow.packsize
   FROM (( SELECT row_number() OVER (PARTITION BY vendorstock.inventorycode ORDER BY vendorstock.deleted, vendorstock.inventorycode, vendorstock.itemname, vendorstock.abbreviation) AS row_num,
            vendorstock._id_,
            vendorstock._tstamp_,
            vendorstock.inventorycode,
            vendorstock.itemname,
            vendorstock.abbreviation,
            vendorstock.supplier,
            vendorstock.message_construct_placeholder,
            vendorstock.barcode,
            vendorstock.total,
            vendorstock.stock_level_min,
            vendorstock.stock_level_max,
            vendorstock.stock_type,
            vendorstock.deleted,
            vendorstock.vendorstock_stringgroup_fk,
            vendorstock.vendorstock_vendor_fk,
            vendorstock.ven_status,
            vendorstock.packsize
           FROM zambia__svs_001.vendorstock
          ORDER BY vendorstock.inventorycode) stockbyrow
     LEFT JOIN zambia__svs_001.stock s ON ((stockbyrow.inventorycode = s.inventorycode)))
  WHERE ((stockbyrow.row_num = 1) AND ((stockbyrow.inventorycode <> s.inventorycode) OR (s.inventorycode IS NULL) OR (stockbyrow.itemname <> s.itemname) OR (stockbyrow.packsize <> s.packsize) OR (stockbyrow.ven_status <> s.ven_status) OR (stockbyrow.message_construct_placeholder <> s.message_construct_placeholder) OR ((stockbyrow.barcode)::text <> (s.barcode)::text) OR (stockbyrow.total <> s.total) OR (stockbyrow.stock_level_min <> s.stock_level_min) OR (stockbyrow.stock_level_max <> s.stock_level_max) OR (stockbyrow.stock_type <> s.stock_type) OR (stockbyrow.deleted <> s.deleted) OR (stockbyrow.vendorstock_stringgroup_fk <> s.stock_stringgroup_fk) OR (stockbyrow.vendorstock_vendor_fk <> s.stock_vendor_fk)));


--
-- Name: admin; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.admin (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text
);


--
-- Name: dispensarystockmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.dispensarystockmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    designation text,
    preferredcontact text,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    dispensarystockmanager_facility_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: districtmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.districtmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    districtmanager_district_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: districtpharmacymanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.districtpharmacymanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    districtpharmacymanager_district_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    champion text,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: districtphcmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.districtphcmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    districtphcmanager_district_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: districtstockmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.districtstockmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: hod; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.hod (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    hod_province_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text
);


--
-- Name: masteradmin; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.masteradmin (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text
);


--
-- Name: nationalmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.nationalmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactemail text NOT NULL,
    contactnum text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: nationalstockadministrator; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.nationalstockadministrator (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: nationalsystemadministrator; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.nationalsystemadministrator (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    nationalsystemadministrator_district_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: provincialdepotmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.provincialdepotmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactemail text NOT NULL,
    contactnum text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    provincialdepotmanager_province_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    champion text,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: provincialmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.provincialmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactemail text NOT NULL,
    contactnum text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    provincialmanager_province_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: provincialprogrammedirector; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.provincialprogrammedirector (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    provincialprogrammedirector_province_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: subdistrictmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.subdistrictmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    subdistrictmanager_subdistrict_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: subdistrictpharmacymanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.subdistrictpharmacymanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    subdistrictpharmacymanager_subdistrict_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: subdistrictstockmanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.subdistrictstockmanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    subdistrictstockmanager_subdistrict_fk uuid,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: supplieruser; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.supplieruser (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    supplieruser_supplier_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: support; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.support (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: _at_roles; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001._at_roles AS
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.admin a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.dispensarystockmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.districtmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.districtpharmacymanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.districtphcmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.districtstockmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.hod a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.masteradmin a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.nationalmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.nationalstockadministrator a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.nationalsystemadministrator a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.provincialdepotmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.provincialmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.provincialprogrammedirector a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.subdistrictmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.subdistrictpharmacymanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.subdistrictstockmanager a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.supplieruser a ON ((a._id_ = hl.identity_id)))
UNION
 SELECT a.name,
    a.surname
   FROM (zambia__svs_001.__he_sync_transaction_log__ hl
     JOIN zambia__svs_001.support a ON ((a._id_ = hl.identity_id)));


--
-- Name: activitylog; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.activitylog (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    user_uuid uuid,
    user_role text,
    user_desc text,
    user_mobile text,
    object_uuid uuid,
    object_name text,
    event_desc text,
    event_source text,
    activity_desc text
);


--
-- Name: asn; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.asn (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    asn_uuid text,
    invoice_number text,
    invoice_date timestamp without time zone,
    poinfo_fk uuid,
    poinfo_asn_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: attachment; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.attachment (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    attachment_type text,
    content bytea,
    date_of_upload timestamp without time zone,
    content_fname__ character varying(255),
    content_mtype__ character varying(255),
    content_size__ integer,
    admin_fk uuid,
    dispensarystockmanager_fk uuid,
    districtmanager_fk uuid,
    districtphcmanager_fk uuid,
    districtpharmacymanager_fk uuid,
    districtstockmanager_fk uuid,
    facilitymanager_fk uuid,
    masteradmin_fk uuid,
    nationalmanager_fk uuid,
    nationalstockadministrator_fk uuid,
    nationalsystemadministrator_fk uuid,
    provincialdepotmanager_fk uuid,
    provincialmanager_fk uuid,
    provincialprogrammedirector_fk uuid,
    subdistrictmanager_fk uuid,
    subdistrictpharmacymanager_fk uuid,
    subdistrictstockmanager_fk uuid,
    supplieruser_fk uuid,
    support_fk uuid
);


--
-- Name: district; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.district (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    gps_longitude numeric,
    gps_latitude numeric,
    district_province_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: facility; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.facility (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    mobile text,
    gps_longitude numeric,
    gps_latitude numeric,
    deleted text,
    hasdevice text,
    flagged_reason text,
    mustexit text,
    date_created timestamp without time zone,
    updatedon timestamp without time zone,
    enrollment_allowed_access_x text,
    enrollment_enrolled_x text,
    enrollment_journey_launcher_version_x text,
    enrollment_device_os_x text,
    enrollment_device_model_x text,
    enrollment_last_connected_x text,
    enrollment_barcode_x text,
    jira text,
    enrollment_perform_re_enrollment_x text,
    enrollment_re_enrollment_last_processed_x timestamp without time zone,
    sig_image bytea,
    sig_image_blob bytea,
    defaultpasswordupdated text,
    appversion text,
    upgradeddate date,
    enrollmentallowedaccess text,
    enrollmentenrolled text,
    enrollmentjourneylauncherversion text,
    enrollmentdeviceos text,
    enrollmentdevicemodel text,
    enrollmentlastconnected text,
    enrollmentbarcode text,
    enrollmenturl text,
    enrollmentreenrollment text,
    enrollmentlastprocessed text,
    enrollmentbarcodezr text,
    enrollmentsms text,
    enrollmentnotification integer,
    sig_image_fname__ character varying(255),
    sig_image_mtype__ character varying(255),
    sig_image_size__ integer,
    sig_image_blob_fname__ character varying(255),
    sig_image_blob_mtype__ character varying(255),
    sig_image_blob_size__ integer,
    facility_district_fk uuid,
    facility_subdistrict_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    last_facilitydeactivationlog_fk uuid
);


--
-- Name: province; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.province (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    gps_longitude numeric,
    gps_latitude numeric,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: stockupdate; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stockupdate (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    update_date timestamp without time zone,
    week_index integer,
    update_year integer,
    update_month integer,
    update_day integer,
    update_hour integer,
    update_minute integer,
    update_second integer,
    current_level text,
    expiry_date date,
    stock_received text,
    stock_lost text,
    first_stockout_date timestamp without time zone,
    stockout_reported_to_pdm timestamp without time zone,
    stockupdate_submissionattempt_fk uuid,
    stockupdate_dispensarystockamanger_fk uuid,
    stockupdate_facility_fk uuid,
    stockupdate_stock_fk uuid,
    stockupdate_facilitystock_fk uuid,
    stockupdate_stockout_ordered_fk uuid,
    stockupdate_stockout_reason_fk uuid,
    stockupdate_stockout_alternative_fk uuid,
    stockupdate_stockout_status_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: stringgroup; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stringgroup (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    value text NOT NULL,
    group_name text NOT NULL,
    index integer,
    deleted text NOT NULL,
    value_ident integer,
    unique_group text,
    grouptype text,
    description text,
    comment text,
    date_created timestamp without time zone,
    date_archived timestamp without time zone,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: subdistrict; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.subdistrict (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    gps_longitude numeric,
    gps_latitude numeric,
    subdistrict_district_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: averagestockoutdurationitems_aggr_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.averagestockoutdurationitems_aggr_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p.name AS provincename,
            d.name AS districtname,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
             LEFT JOIN zambia__svs_001.district d ON ((sd.subdistrict_district_fk = d._id_)))
             LEFT JOIN zambia__svs_001.province p ON ((d.district_province_fk = p._id_)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_new AS (
         SELECT q."timestamp",
            q.update_date,
            q.expiry_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.stockcategory,
            q.itemname,
            q.abbreviation,
            q.inventorycode,
            q."stock level",
            q."stock received",
            q."stock lost",
            q.first_stockout_date,
            q.stockout_reported_to_pdm,
            q._facilityid,
            q._stockid,
            ((date_part('epoch'::text, age(now(), COALESCE((q.first_stockout_date)::timestamp with time zone, now()))) / (((60 * 60) * 24))::double precision))::integer AS days_since_first_stockout,
            ((date_part('epoch'::text, age(now(), (q."timestamp")::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp,
                CASE
                    WHEN ((COALESCE(q."stock level", '0'::text))::integer <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out
           FROM ( SELECT
                        CASE
                            WHEN (su._tstamp_ >= '2014-10-09'::date) THEN su._tstamp_
                            ELSE (su.update_date + '02:00:00'::interval)
                        END AS "timestamp",
                    (su.update_date + '02:00:00'::interval) AS update_date,
                        CASE
                            WHEN ((COALESCE(su.expiry_date, (now())::date) >= '1900-01-01'::date) AND (COALESCE(su.expiry_date, (now())::date) <= '2100-01-01'::date)) THEN su.expiry_date
                            ELSE NULL::date
                        END AS expiry_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    sg.value AS stockcategory,
                    s.itemname,
                    s.abbreviation,
                    s.inventorycode,
                    su.current_level AS "stock level",
                    su.stock_received AS "stock received",
                    su.stock_lost AS "stock lost",
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.first_stockout_date
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                        CASE
                            WHEN ((COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.stockout_reported_to_pdm
                            ELSE NULL::timestamp without time zone
                        END AS stockout_reported_to_pdm,
                    fh._facilityid,
                    s._id_ AS _stockid
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN facilityhierarchy fh ON ((su.stockupdate_facility_fk = fh._facilityid)))
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk) AND (fs.deleted = 'No'::text))))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
                  WHERE ((su.stockupdate_facility_fk IS NOT NULL) AND (sg.value = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text])) AND ((s.inventorycode = '@inventorycode'::text) OR ("left"('@inventorycode'::text, 1) = '@'::text)))) q
        ), qnationalstockupdatelevels AS (
         SELECT asu.provincename,
            asu.districtname,
            asu.subdistrictname,
            asu.facilityname,
            asu.stockcategory,
            asu.itemname,
            asu.abbreviation,
            asu.inventorycode,
            asu."timestamp",
            asu.update_date,
            asu."stock level",
            asu."stock received",
            asu."stock lost",
            asu.expiry_date,
            asu.first_stockout_date,
            asu.stockout_reported_to_pdm,
            asu.days_since_first_stockout,
            asu.days_since_last_update_timestamp,
            asu.current_stock_out,
            asu._facilityid,
            asu._stockid
           FROM (qnationalstockupdates_new asu
             JOIN ( SELECT qnationalstockupdates_new._facilityid,
                    qnationalstockupdates_new._stockid,
                    max(qnationalstockupdates_new."timestamp") AS mxt
                   FROM qnationalstockupdates_new
                  GROUP BY qnationalstockupdates_new._facilityid, qnationalstockupdates_new._stockid) mud ON (((asu._facilityid = mud._facilityid) AND (asu._stockid = mud._stockid) AND (asu."timestamp" = mud.mxt))))
        ), nationalstockoutdurationitems AS (
         SELECT qnationalstockupdatelevels.stockcategory,
            qnationalstockupdatelevels.itemname AS stock,
            qnationalstockupdatelevels.inventorycode,
            qnationalstockupdatelevels.days_since_first_stockout,
            qnationalstockupdatelevels.days_since_last_update_timestamp,
            qnationalstockupdatelevels.facilityname,
            qnationalstockupdatelevels.subdistrictname,
            qnationalstockupdatelevels.districtname,
            qnationalstockupdatelevels.provincename,
            qnationalstockupdatelevels._facilityid
           FROM qnationalstockupdatelevels
          WHERE (qnationalstockupdatelevels."stock level" = '0'::text)
          ORDER BY qnationalstockupdatelevels.stockcategory, qnationalstockupdatelevels.itemname, qnationalstockupdatelevels.inventorycode
        ), averagestockoutdurationsummaryfacility AS (
         SELECT DISTINCT fh.facilityname AS location,
            round(COALESCE(arv."ARV", (0)::numeric), 0) AS arvcount,
            round(COALESCE(tb."TB", (0)::numeric), 0) AS tbcount,
            round(COALESCE(vacc."Vacc", (0)::numeric), 0) AS vacccount,
            NULL::uuid AS province_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            fh._facilityid AS facility_uuid
           FROM (((facilityhierarchy fh
             LEFT JOIN ( SELECT avg(nationalstockoutdurationitems.days_since_first_stockout) AS "ARV",
                    nationalstockoutdurationitems._facilityid,
                    nationalstockoutdurationitems.stockcategory
                   FROM nationalstockoutdurationitems
                  WHERE (nationalstockoutdurationitems.stockcategory = 'ARV'::text)
                  GROUP BY nationalstockoutdurationitems.stockcategory, nationalstockoutdurationitems._facilityid) arv ON ((fh._facilityid = arv._facilityid)))
             LEFT JOIN ( SELECT avg(nationalstockoutdurationitems.days_since_first_stockout) AS "TB",
                    nationalstockoutdurationitems._facilityid,
                    nationalstockoutdurationitems.stockcategory
                   FROM nationalstockoutdurationitems
                  WHERE (nationalstockoutdurationitems.stockcategory = 'TB'::text)
                  GROUP BY nationalstockoutdurationitems.stockcategory, nationalstockoutdurationitems._facilityid) tb ON ((fh._facilityid = tb._facilityid)))
             LEFT JOIN ( SELECT avg(nationalstockoutdurationitems.days_since_first_stockout) AS "Vacc",
                    nationalstockoutdurationitems._facilityid,
                    nationalstockoutdurationitems.stockcategory
                   FROM nationalstockoutdurationitems
                  WHERE (nationalstockoutdurationitems.stockcategory = 'Vacc'::text)
                  GROUP BY nationalstockoutdurationitems.stockcategory, nationalstockoutdurationitems._facilityid) vacc ON ((fh._facilityid = vacc._facilityid)))
          ORDER BY fh.facilityname
        ), averagestockoutdurationsummarysubdistrict AS (
         SELECT sdh.name AS location,
            round(COALESCE(avgstockout.arv, (0)::numeric), 0) AS arvcount,
            round(COALESCE(avgstockout_1.tb, (0)::numeric), 0) AS tbcount,
            round(COALESCE(avgstockout_2.vacc, (0)::numeric), 0) AS vacccount,
            NULL::uuid AS province_uuid,
            NULL::uuid AS district_uuid,
            sdh._id_ AS subdistrict_uuid,
            NULL::uuid AS facility_uuid
           FROM (((zambia__svs_001.subdistrict sdh
             LEFT JOIN ( SELECT avg(averagestockoutdurationsummaryfacility.arvcount) AS arv,
                    sd._id_ AS subdistrictid
                   FROM ((averagestockoutdurationsummaryfacility
                     LEFT JOIN zambia__svs_001.facility f ON ((f._id_ = averagestockoutdurationsummaryfacility.facility_uuid)))
                     LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
                  WHERE (averagestockoutdurationsummaryfacility.arvcount <> (0)::numeric)
                  GROUP BY sd._id_) avgstockout ON ((sdh._id_ = avgstockout.subdistrictid)))
             LEFT JOIN ( SELECT avg(averagestockoutdurationsummaryfacility.tbcount) AS tb,
                    sd._id_ AS subdistrictid
                   FROM ((averagestockoutdurationsummaryfacility
                     LEFT JOIN zambia__svs_001.facility f ON ((f._id_ = averagestockoutdurationsummaryfacility.facility_uuid)))
                     LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
                  WHERE (averagestockoutdurationsummaryfacility.tbcount <> (0)::numeric)
                  GROUP BY sd._id_) avgstockout_1 ON ((sdh._id_ = avgstockout_1.subdistrictid)))
             LEFT JOIN ( SELECT avg(averagestockoutdurationsummaryfacility.vacccount) AS vacc,
                    sd._id_ AS subdistrictid
                   FROM ((averagestockoutdurationsummaryfacility
                     LEFT JOIN zambia__svs_001.facility f ON ((f._id_ = averagestockoutdurationsummaryfacility.facility_uuid)))
                     LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
                  WHERE (averagestockoutdurationsummaryfacility.vacccount <> (0)::numeric)
                  GROUP BY sd._id_) avgstockout_2 ON ((sdh._id_ = avgstockout_2.subdistrictid)))
        ), averagestockoutdurationsummarydistrict AS (
         SELECT d.name AS location,
            round(COALESCE(avgstockout_d.arv, (0)::numeric), 0) AS arvcount,
            round(COALESCE(avgstockout_d1.tb, (0)::numeric), 0) AS tbcount,
            round(COALESCE(avgstockout_d2.vacc, (0)::numeric), 0) AS vacccount,
            NULL::uuid AS province_uuid,
            d._id_ AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            NULL::uuid AS facility_uuid
           FROM (((zambia__svs_001.district d
             LEFT JOIN ( SELECT avg(avgst.arvcount) AS arv,
                    d_1._id_ AS districtid
                   FROM ((averagestockoutdurationsummarysubdistrict avgst
                     JOIN zambia__svs_001.subdistrict sd ON ((avgst.subdistrict_uuid = sd._id_)))
                     JOIN zambia__svs_001.district d_1 ON ((sd.subdistrict_district_fk = d_1._id_)))
                  WHERE (avgst.arvcount <> (0)::numeric)
                  GROUP BY d_1._id_) avgstockout_d ON ((d._id_ = avgstockout_d.districtid)))
             LEFT JOIN ( SELECT avg(avgst.tbcount) AS tb,
                    d_1._id_ AS districtid
                   FROM ((averagestockoutdurationsummarysubdistrict avgst
                     JOIN zambia__svs_001.subdistrict sd ON ((avgst.subdistrict_uuid = sd._id_)))
                     JOIN zambia__svs_001.district d_1 ON ((sd.subdistrict_district_fk = d_1._id_)))
                  WHERE (avgst.tbcount <> (0)::numeric)
                  GROUP BY d_1._id_) avgstockout_d1 ON ((d._id_ = avgstockout_d1.districtid)))
             LEFT JOIN ( SELECT avg(avgst.vacccount) AS vacc,
                    d_1._id_ AS districtid
                   FROM ((averagestockoutdurationsummarysubdistrict avgst
                     JOIN zambia__svs_001.subdistrict sd ON ((avgst.subdistrict_uuid = sd._id_)))
                     JOIN zambia__svs_001.district d_1 ON ((sd.subdistrict_district_fk = d_1._id_)))
                  WHERE (avgst.vacccount <> (0)::numeric)
                  GROUP BY d_1._id_) avgstockout_d2 ON ((d._id_ = avgstockout_d2.districtid)))
        ), averagestockoutdurationsummaryprovince AS (
         SELECT p.name AS location,
            round(COALESCE(avgstockout_p.arv, (0)::numeric), 0) AS arvcount,
            round(COALESCE(avgstockout_p1.tb, (0)::numeric), 0) AS tbcount,
            round(COALESCE(avgstockout_p2.vacc, (0)::numeric), 0) AS vacccount,
            p._id_ AS province_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            NULL::uuid AS facility_uuid
           FROM (((zambia__svs_001.province p
             LEFT JOIN ( SELECT avg(avgst.arvcount) AS arv,
                    p_1._id_ AS provinceid
                   FROM ((averagestockoutdurationsummarydistrict avgst
                     JOIN zambia__svs_001.district d ON ((avgst.district_uuid = d._id_)))
                     JOIN zambia__svs_001.province p_1 ON ((d.district_province_fk = p_1._id_)))
                  WHERE ((avgst.arvcount <> (0)::numeric) AND (avgst.tbcount <> (0)::numeric) AND (avgst.vacccount <> (0)::numeric) AND (p_1.name <> 'Training Demos'::text))
                  GROUP BY p_1._id_) avgstockout_p ON ((p._id_ = avgstockout_p.provinceid)))
             LEFT JOIN ( SELECT avg(avgst.tbcount) AS tb,
                    p_1._id_ AS provinceid
                   FROM ((averagestockoutdurationsummarydistrict avgst
                     JOIN zambia__svs_001.district d ON ((avgst.district_uuid = d._id_)))
                     JOIN zambia__svs_001.province p_1 ON ((d.district_province_fk = p_1._id_)))
                  WHERE ((avgst.tbcount <> (0)::numeric) AND (p_1.name <> 'Training Demos'::text))
                  GROUP BY p_1._id_) avgstockout_p1 ON ((p._id_ = avgstockout_p1.provinceid)))
             LEFT JOIN ( SELECT avg(avgst.vacccount) AS vacc,
                    p_1._id_ AS provinceid
                   FROM ((averagestockoutdurationsummarydistrict avgst
                     JOIN zambia__svs_001.district d ON ((avgst.district_uuid = d._id_)))
                     JOIN zambia__svs_001.province p_1 ON ((d.district_province_fk = p_1._id_)))
                  WHERE ((avgst.vacccount <> (0)::numeric) AND (p_1.name <> 'Training Demos'::text))
                  GROUP BY p_1._id_) avgstockout_p2 ON ((p._id_ = avgstockout_p2.provinceid)))
        )
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummaryfacility.arvcount,
    averagestockoutdurationsummaryfacility.tbcount,
    averagestockoutdurationsummaryfacility.vacccount,
    averagestockoutdurationsummaryfacility.location,
    averagestockoutdurationsummaryfacility.province_uuid,
    averagestockoutdurationsummaryfacility.district_uuid,
    averagestockoutdurationsummaryfacility.subdistrict_uuid,
    averagestockoutdurationsummaryfacility.facility_uuid
   FROM averagestockoutdurationsummaryfacility
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummarysubdistrict.arvcount,
    averagestockoutdurationsummarysubdistrict.tbcount,
    averagestockoutdurationsummarysubdistrict.vacccount,
    averagestockoutdurationsummarysubdistrict.location,
    averagestockoutdurationsummarysubdistrict.province_uuid,
    averagestockoutdurationsummarysubdistrict.district_uuid,
    averagestockoutdurationsummarysubdistrict.subdistrict_uuid,
    averagestockoutdurationsummarysubdistrict.facility_uuid
   FROM averagestockoutdurationsummarysubdistrict
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummarydistrict.arvcount,
    averagestockoutdurationsummarydistrict.tbcount,
    averagestockoutdurationsummarydistrict.vacccount,
    averagestockoutdurationsummarydistrict.location,
    averagestockoutdurationsummarydistrict.province_uuid,
    averagestockoutdurationsummarydistrict.district_uuid,
    averagestockoutdurationsummarydistrict.subdistrict_uuid,
    averagestockoutdurationsummarydistrict.facility_uuid
   FROM averagestockoutdurationsummarydistrict
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummaryprovince.arvcount,
    averagestockoutdurationsummaryprovince.tbcount,
    averagestockoutdurationsummaryprovince.vacccount,
    averagestockoutdurationsummaryprovince.location,
    averagestockoutdurationsummaryprovince.province_uuid,
    averagestockoutdurationsummaryprovince.district_uuid,
    averagestockoutdurationsummaryprovince.subdistrict_uuid,
    averagestockoutdurationsummaryprovince.facility_uuid
   FROM averagestockoutdurationsummaryprovince;


--
-- Name: avestockoutdurationitems_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.avestockoutdurationitems_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.avestockoutdurationitems_aggregation_executor_function() AS counter;


--
-- Name: batchprocess; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.batchprocess (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    date_completed timestamp without time zone,
    completed text,
    process text,
    str_value_1 text,
    batchprocess_provincialstock_fk uuid,
    batchprocess_stock_fk uuid,
    batchprocess_vendorprovincialstock_fk uuid,
    batchprocess_vendorstock_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: billingfacilityreport; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.billingfacilityreport (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    provincename text,
    districtname text,
    subdistrictname text,
    facilityname text,
    gps_longitude numeric,
    gps_latitude numeric,
    inovice text,
    model text,
    imei_number text,
    cell_number text,
    sim_number text,
    app_installed text,
    app_enrolled text,
    stock_added text,
    mobile_registered text,
    lastconnected timestamp without time zone,
    days_since_last_update integer,
    stock_updates integer,
    min_tstamp timestamp without time zone,
    max_tstamp timestamp without time zone,
    deleted text,
    date_created timestamp without time zone,
    mobiledevice_facility_fk uuid
);


--
-- Name: mobiledevice; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.mobiledevice (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    model text,
    imei_number text,
    sim_number text,
    cell_number text,
    inovice text,
    app_installed text,
    app_enrolled text,
    stock_added text,
    mobile_registered text,
    updatedon timestamp without time zone,
    appversion text,
    upgradeddate date,
    deleted text,
    date_created timestamp without time zone,
    mobiledevice_facility_fk uuid
);


--
-- Name: billingfacilityreport_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.billingfacilityreport_view AS
 WITH facilityhierarchy AS (
         SELECT p._id_ AS _provinceid,
            p.name AS provincename,
            d._id_ AS _districtid,
            d.name AS districtname,
            sd._id_ AS _subdistrictid,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname,
            f._id_,
            f._tstamp_,
            f.name,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
            f.deleted,
            f.mustexit,
            f.date_created,
            f.enrollment_allowed_access_x,
            f.enrollment_enrolled_x,
            f.enrollment_journey_launcher_version_x,
            f.enrollment_device_os_x,
            f.enrollment_device_model_x,
            f.enrollment_last_connected_x,
            f.enrollment_barcode_x,
            f.enrollment_perform_re_enrollment_x,
            f.enrollment_re_enrollment_last_processed_x,
            f.sig_image,
            f.sig_image_blob,
            f.sig_image_fname__,
            f.sig_image_mtype__,
            f.sig_image_size__,
            f.sig_image_blob_fname__,
            f.sig_image_blob_mtype__,
            f.sig_image_blob_size__,
            f.facility_district_fk,
            f.facility_subdistrict_fk,
            f._tx_id_,
            f._change_type_,
            f._change_seq_,
            f.updatedon,
            f.jira,
            f.enrollmentallowedaccess,
            f.enrollmentenrolled,
            f.enrollmentjourneylauncherversion,
            f.enrollmentdeviceos,
            f.enrollmentdevicemodel,
            f.enrollmentlastconnected,
            f.enrollmentbarcode,
            f.enrollmenturl,
            f.enrollmentreenrollment,
            f.enrollmentlastprocessed,
            f.enrollmentbarcodezr,
            f.enrollmentsms,
            f.enrollmentnotification,
            f.defaultpasswordupdated,
            f.appversion,
            f.upgradeddate,
            f.hasdevice,
            f.flagged_reason
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qfacilitystockupdateaggr AS (
         SELECT fh.provincename,
            fh.districtname,
            fh.subdistrictname,
            fh.facilityname,
            count(su.stockupdate_facility_fk) AS stock_updates,
            max(LEAST((su.update_date + '02:00:00'::interval), su._tstamp_)) AS max_tstamp,
            min(LEAST((su.update_date + '02:00:00'::interval), su._tstamp_)) AS min_tstamp,
            fh._facilityid
           FROM (zambia__svs_001.stockupdate su
             RIGHT JOIN facilityhierarchy fh ON ((fh._facilityid = su.stockupdate_facility_fk)))
          GROUP BY fh.provincename, fh.districtname, fh.subdistrictname, fh.facilityname, fh._facilityid
        ), billingfacilityreport AS (
         SELECT fh.provincename,
            fh.districtname,
            fh.subdistrictname,
            fh.facilityname,
            fh.gps_longitude,
            fh.gps_latitude,
            mb.inovice,
            mb.model,
            mb.imei_number,
            mb.cell_number,
            mb.sim_number,
            mb.app_installed,
            fh.enrollmentenrolled AS app_enrolled,
                CASE
                    WHEN (fs._id_ IS NOT NULL) THEN 'Yes'::text
                    ELSE 'No'::text
                END AS stock_added,
            mb.mobile_registered,
            fh.enrollmentlastconnected AS lastconnected,
            ((date_part('epoch'::text, age(now(), (na.max_tstamp)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update,
            na.stock_updates,
            na.min_tstamp,
            na.max_tstamp,
            fh.deleted,
            fh.date_created,
            fh._facilityid
           FROM (((facilityhierarchy fh
             LEFT JOIN zambia__svs_001.mobiledevice mb ON ((mb.mobiledevice_facility_fk = fh._facilityid)))
             LEFT JOIN qfacilitystockupdateaggr na ON ((na._facilityid = fh._facilityid)))
             LEFT JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.deleted = 'No'::text))))
        )
 SELECT billingfacilityreport.provincename,
    billingfacilityreport.districtname,
    billingfacilityreport.subdistrictname,
    billingfacilityreport.facilityname,
    billingfacilityreport.gps_longitude,
    billingfacilityreport.gps_latitude,
    billingfacilityreport.inovice,
    billingfacilityreport.model,
    billingfacilityreport.imei_number,
    billingfacilityreport.cell_number,
    billingfacilityreport.sim_number,
    billingfacilityreport.app_installed,
    billingfacilityreport.app_enrolled,
    billingfacilityreport.stock_added,
    billingfacilityreport.mobile_registered,
    billingfacilityreport.lastconnected,
    billingfacilityreport.days_since_last_update,
    billingfacilityreport.stock_updates,
    billingfacilityreport.min_tstamp,
    billingfacilityreport.max_tstamp,
    billingfacilityreport.deleted,
    billingfacilityreport.date_created,
    billingfacilityreport._facilityid
   FROM billingfacilityreport
  ORDER BY billingfacilityreport.provincename, billingfacilityreport.districtname, billingfacilityreport.subdistrictname, billingfacilityreport.facilityname;


--
-- Name: client; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.client (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    firstname text,
    surname text,
    address text,
    code text,
    id_number text,
    dob text,
    age text,
    sex text,
    contactemail text,
    contactnum text,
    date_created timestamp without time zone,
    deleted text
);


--
-- Name: config; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.config (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    date_archived timestamp without time zone,
    archived integer,
    key text,
    value text,
    description text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: configpair; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.configpair (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    date_archived timestamp without time zone,
    archived integer,
    key text,
    value text,
    description text
);


--
-- Name: configuration; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.configuration (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    key text,
    description text,
    value text,
    test_image_blob bytea,
    test_image_blob_fname__ character varying(255),
    test_image_blob_mtype__ character varying(255),
    test_image_blob_size__ integer,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: container; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.container (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    container_uuid text,
    barcode text,
    asn_fk uuid,
    tripsheet_fk uuid,
    asn_cantainer_fk uuid,
    poinfo_container_fk uuid,
    tripsheet_container_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    condition text,
    rejected_reasons text,
    deleted text,
    date_created timestamp without time zone,
    container_delivery_fk uuid
);


--
-- Name: delivery; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.delivery (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    category text,
    reference text,
    deleted text,
    date_created timestamp without time zone,
    stockdelivery_vehicle_fk uuid,
    stockdelivery_client_fk uuid,
    delivery_facility_fk uuid,
    invoice_number text,
    reciever text,
    delevery_date timestamp without time zone,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: deliveryattachment; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.deliveryattachment (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    description text,
    reference text,
    category text,
    attachment bytea,
    deleted text,
    date_created timestamp without time zone,
    attachment_fname__ character varying(255),
    attachment_mtype__ character varying(255),
    attachment_size__ integer,
    deliveryattachment_delivery_fk uuid,
    deliveryattachment_facility_fk uuid
);


--
-- Name: deploymentslamanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.deploymentslamanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    emailsent text,
    deleted text,
    _firstnames text,
    _nickname text,
    _surname text,
    _locale text,
    _timezone text
);


--
-- Name: dpm_facility_stock_level_aggr_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.dpm_facility_stock_level_aggr_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.dpm_facility_stock_level_aggr_function() AS result;


--
-- Name: dpm_facility_stock_level_aggr_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.dpm_facility_stock_level_aggr_logic_view AS
 SELECT facility.name AS facilityname,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Stock out'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Stock out - Alternative available'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Stock without updates'::text
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'No recent updates'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'No stock assigned'::text
            ELSE 'Normal'::text
        END AS facility_status,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Red'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Yellow'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Purple'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'Green'::text
            ELSE 'Green'::text
        END AS facility_status_colour,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 1
                WHEN (stockouts.stockoutstatus = 2) THEN 2
                ELSE NULL::integer
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 3
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 4
            WHEN (facilitynostock._id_ IS NOT NULL) THEN 6
            ELSE 5
        END AS facilitystatusorder,
    districtpharmacymanager._id_ AS _districtpharmacymanagerid,
    district.name AS district,
    subdistrict.name AS subdistrict
   FROM (((((((zambia__svs_001.facility
     LEFT JOIN zambia__svs_001.subdistrict ON ((facility.facility_subdistrict_fk = subdistrict._id_)))
     LEFT JOIN zambia__svs_001.district ON ((facility.facility_district_fk = district._id_)))
     JOIN zambia__svs_001.districtpharmacymanager ON ((facility.facility_district_fk = districtpharmacymanager.districtpharmacymanager_district_fk)))
     LEFT JOIN ( SELECT stockoutpriority.stockoutfacilityid,
            stockoutpriority.stockoutstatus
           FROM ( SELECT row_number() OVER (PARTITION BY stockoutbypriorityorder.stockoutfacilityid ORDER BY stockoutbypriorityorder.stockoutfacilityid) AS therownum,
                    stockoutbypriorityorder.stockoutfacilityid,
                    stockoutbypriorityorder.stockoutstatus
                   FROM ( SELECT stockupdate.stockupdate_facility_fk AS stockoutfacilityid,
                                CASE
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NULL) THEN 1
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NOT NULL) THEN stringgroup.value_ident
                                    ELSE NULL::integer
                                END AS stockoutstatus
                           FROM ((zambia__svs_001.stockupdate
                             JOIN ( SELECT stockupdate_1.stockupdate_facility_fk AS facility_id,
                                    stockupdate_1.stockupdate_stock_fk AS stock_id,
                                    max(stockupdate_1.update_date) AS max_update_date
                                   FROM (zambia__svs_001.stockupdate stockupdate_1
                                     JOIN zambia__svs_001.facilitystock ON ((stockupdate_1.stockupdate_facilitystock_fk = facilitystock._id_)))
                                  WHERE ((stockupdate_1.stockupdate_facility_fk IS NOT NULL) AND (facilitystock.deleted = 'No'::text))
                                  GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) latest_stockupdate ON (((stockupdate.stockupdate_facility_fk = latest_stockupdate.facility_id) AND (stockupdate.stockupdate_stock_fk = latest_stockupdate.stock_id))))
                             LEFT JOIN zambia__svs_001.stringgroup ON ((stockupdate.stockupdate_stockout_status_fk = stringgroup._id_)))
                          WHERE ((stockupdate.update_date = latest_stockupdate.max_update_date) AND (stockupdate.current_level = '0'::text))
                          ORDER BY stockupdate.stockupdate_facility_fk,
                                CASE
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NULL) THEN 1
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NOT NULL) THEN stringgroup.value_ident
                                    ELSE NULL::integer
                                END) stockoutbypriorityorder) stockoutpriority
          WHERE (stockoutpriority.therownum = 1)) stockouts ON ((facility._id_ = stockouts.stockoutfacilityid)))
     LEFT JOIN ( SELECT DISTINCT facilitystock.facilitystock_facility_fk AS facilityid
           FROM (zambia__svs_001.facilitystock
             LEFT JOIN ( SELECT stockupdate.stockupdate_facility_fk AS facilityid,
                    stockupdate.stockupdate_stock_fk AS stockid
                   FROM zambia__svs_001.stockupdate
                  WHERE (stockupdate.stockupdate_facility_fk IS NOT NULL)
                  GROUP BY stockupdate.stockupdate_facility_fk, stockupdate.stockupdate_stock_fk) facility_with_update ON (((facilitystock.facilitystock_facility_fk = facility_with_update.facilityid) AND (facilitystock.facilitystock_stock_fk = facility_with_update.stockid))))
          WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facility_with_update.facilityid IS NULL) AND (facility_with_update.stockid IS NULL) AND (facilitystock.deleted = 'No'::text))
          GROUP BY facilitystock.facilitystock_facility_fk) stockwithoutanyupdate ON ((facility._id_ = stockwithoutanyupdate.facilityid)))
     LEFT JOIN ( SELECT DISTINCT facilitystock.facilitystock_facility_fk AS facilityid
           FROM (zambia__svs_001.facilitystock
             LEFT JOIN ( SELECT stockupdate.stockupdate_facility_fk AS facilityid,
                    stockupdate.stockupdate_stock_fk AS stockid
                   FROM zambia__svs_001.stockupdate
                  WHERE ((stockupdate.stockupdate_facility_fk IS NOT NULL) AND (date(stockupdate.update_date) IN ( SELECT ((date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone))::date - (i.i - 6))
                           FROM generate_series(0, 6) i(i))))
                  GROUP BY stockupdate.stockupdate_facility_fk, stockupdate.stockupdate_stock_fk) facility_with_update ON (((facilitystock.facilitystock_facility_fk = facility_with_update.facilityid) AND (facilitystock.facilitystock_stock_fk = facility_with_update.stockid))))
          WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facility_with_update.facilityid IS NULL) AND (facility_with_update.stockid IS NULL) AND (facilitystock.deleted = 'No'::text))
          GROUP BY facilitystock.facilitystock_facility_fk) stockwithoutanyupdateinrange ON ((facility._id_ = stockwithoutanyupdateinrange.facilityid)))
     LEFT JOIN ( SELECT facility_1._id_
           FROM (zambia__svs_001.facility facility_1
             LEFT JOIN ( SELECT facilitystock.facilitystock_facility_fk
                   FROM zambia__svs_001.facilitystock
                  WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facilitystock.deleted = 'No'::text))
                  GROUP BY facilitystock.facilitystock_facility_fk) facilitywithstock ON ((facility_1._id_ = facilitywithstock.facilitystock_facility_fk)))
          WHERE (facilitywithstock.facilitystock_facility_fk IS NULL)) facilitynostock ON ((facility._id_ = facilitynostock._id_)))
  WHERE ((districtpharmacymanager.deleted = 'No'::text) AND (facility.deleted = 'No'::text))
  GROUP BY stockouts.stockoutfacilityid, stockwithoutanyupdate.facilityid, stockwithoutanyupdateinrange.facilityid, facilitynostock._id_, facility.name,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Stock out'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Stock out - Alternative available'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Stock without updates'::text
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'No recent updates'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'No stock assigned'::text
            ELSE 'Normal'::text
        END,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Red'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Yellow'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Purple'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'Green'::text
            ELSE 'Green'::text
        END, district.name, subdistrict.name, stockouts.stockoutstatus, districtpharmacymanager._id_
  ORDER BY
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 1
                WHEN (stockouts.stockoutstatus = 2) THEN 2
                ELSE NULL::integer
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 3
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 4
            WHEN (facilitynostock._id_ IS NOT NULL) THEN 6
            ELSE 5
        END, facility.name;


--
-- Name: dpm_facility_stock_level_aggr_table; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.dpm_facility_stock_level_aggr_table (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    facilityname text,
    facility_status text,
    facility_status_colour text,
    facilitystatusorder integer,
    _districtpharmacymanagerid uuid,
    district text,
    subdistrict text
);


--
-- Name: errorlog; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.errorlog (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    error_code text,
    err_desc text,
    code_source text,
    err_effect text,
    user_uuid text
);


--
-- Name: execute_clear_stockavailability; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_clear_stockavailability AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowfacility() AS result;


--
-- Name: execute_generate_shadowfacility; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowfacility AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowfacility() AS result;


--
-- Name: execute_generate_shadowfacilityvendor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowfacilityvendor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowfacilityvendor() AS result;


--
-- Name: execute_generate_shadowfirststockout; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowfirststockout AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowfirststockout() AS result;


--
-- Name: execute_generate_shadowfirstupdate; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowfirstupdate AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowfirstupdate() AS result;


--
-- Name: execute_generate_shadowlaststockout; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowlaststockout AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowlaststockout() AS result;


--
-- Name: execute_generate_shadowlastupdate; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowlastupdate AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowlastupdate() AS result;


--
-- Name: execute_generate_shadowreportingaggregate; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowreportingaggregate AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowreportingaggregate() AS result;


--
-- Name: execute_generate_shadowreportingsupaggregate; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowreportingsupaggregate AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowreportingsupplieraggregate() AS result;


--
-- Name: execute_generate_shadowstockoutsequence; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_generate_shadowstockoutsequence AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_shadowstockoutsequence() AS result;


--
-- Name: execute_lowandoverstock_aggregation; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_lowandoverstock_aggregation AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_lowandoverstock_aggregation() AS result;


--
-- Name: execute_refresh_surveilance_reports; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_refresh_surveilance_reports AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.refresh_survailance_reports_function() AS counter;


--
-- Name: execute_successmatrix_aggregation; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.execute_successmatrix_aggregation AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_successmatrix_aggregation() AS result;


--
-- Name: extractedsuccessmatrixdata; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.extractedsuccessmatrixdata (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    reportingfacilities integer,
    numberofstockouts integer,
    registeredfacilities integer,
    numberofupdates integer
);


--
-- Name: facilitycompliance_materializedview; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.facilitycompliance_materializedview (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    hierarchy_name text,
    number_of_facilitiesloaded integer,
    facility_reporting_compliant integer,
    compliant_percentage numeric,
    noncompliant_percentage numeric,
    _provinceid_fk uuid,
    _districtid_fk uuid,
    _subdistrictid_fk uuid,
    _level text
);


--
-- Name: facilitydeactivation; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.facilitydeactivation (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    facility_uuid uuid,
    province_name text,
    district_name text,
    subdistrict_name text,
    facility_name text,
    mobile text,
    flagged_reason text,
    user_details text,
    deactivateddate date,
    daysdeactivated integer
);


--
-- Name: facilitydeactivationlog; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.facilitydeactivationlog (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    user_id text,
    user_role text,
    user_details text,
    contact_details text,
    contact_emails text,
    text text,
    event_type text,
    comment text,
    loggedat timestamp without time zone,
    deleted text,
    object_uuid uuid,
    facility_fk uuid
);


--
-- Name: facilitymanager; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.facilitymanager (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    contactnum text NOT NULL,
    contactemail text NOT NULL,
    date_created timestamp without time zone,
    deleted text,
    facilitymanager_facility_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    emailsent text,
    last_upload_date timestamp without time zone
);


--
-- Name: facilityoutstandingstocksubmission_materializedview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.facilityoutstandingstocksubmission_materializedview_actual AS
 SELECT facility._id_ AS facilityid,
    maxupdate.update_date,
    (((date_part('epoch'::text, age(now(), (maxupdate.update_date)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer - 1) AS days_since_last_update,
    facility.name AS facilityname,
    facility.mobile AS contact_number,
    facility.gps_longitude AS gpslongitude,
    facility.gps_latitude AS gpslatitude,
    subdistrict.name AS subdistrict,
    district.name AS district,
    province.name AS province,
    subdistrict._id_ AS subdistrictid,
    district._id_ AS districtid,
    province._id_ AS provinceid,
        CASE
            WHEN (COALESCE(noupdatefacilities.top_categories, (0)::bigint) < 3) THEN 0
            ELSE 3
        END AS top_categories
   FROM (((((zambia__svs_001.facility facility
     JOIN zambia__svs_001.subdistrict subdistrict ON ((subdistrict._id_ = facility.facility_subdistrict_fk)))
     JOIN zambia__svs_001.district district ON ((subdistrict.subdistrict_district_fk = district._id_)))
     JOIN zambia__svs_001.province province ON ((district.district_province_fk = province._id_)))
     LEFT JOIN ( SELECT DISTINCT su.stockupdate_facility_fk,
            max(LEAST(date(su.update_date), date(su._tstamp_))) AS update_date
           FROM zambia__svs_001.stockupdate su
          GROUP BY su.stockupdate_facility_fk) maxupdate ON ((facility._id_ = maxupdate.stockupdate_facility_fk)))
     LEFT JOIN ( SELECT DISTINCT su.stockupdate_facility_fk,
            count(DISTINCT sg._id_) AS top_categories
           FROM ((zambia__svs_001.stockupdate su
             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
             JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
          WHERE ((LEAST(date(su.update_date), date(su._tstamp_)) IN ( SELECT ((date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone))::date + (i.i - 7))
                   FROM generate_series(0, 6) i(i))) AND (sg.value = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text])))
          GROUP BY su.stockupdate_facility_fk) noupdatefacilities ON ((facility._id_ = noupdatefacilities.stockupdate_facility_fk)))
  WHERE (facility.deleted = 'No'::text);


--
-- Name: facilityoutstandingstocksubmission_materializedview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.facilityoutstandingstocksubmission_materializedview AS
 SELECT facilityoutstandingstocksubmission_materializedview_actual.facilityid,
    facilityoutstandingstocksubmission_materializedview_actual.update_date,
    facilityoutstandingstocksubmission_materializedview_actual.days_since_last_update,
    facilityoutstandingstocksubmission_materializedview_actual.facilityname,
    facilityoutstandingstocksubmission_materializedview_actual.contact_number,
    facilityoutstandingstocksubmission_materializedview_actual.gpslongitude,
    facilityoutstandingstocksubmission_materializedview_actual.gpslatitude,
    facilityoutstandingstocksubmission_materializedview_actual.subdistrict,
    facilityoutstandingstocksubmission_materializedview_actual.district,
    facilityoutstandingstocksubmission_materializedview_actual.province,
    facilityoutstandingstocksubmission_materializedview_actual.subdistrictid,
    facilityoutstandingstocksubmission_materializedview_actual.districtid,
    facilityoutstandingstocksubmission_materializedview_actual.provinceid,
    facilityoutstandingstocksubmission_materializedview_actual.top_categories
   FROM zambia__svs_001.facilityoutstandingstocksubmission_materializedview_actual
  WITH NO DATA;


--
-- Name: facilityproductstatusview; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.facilityproductstatusview AS
 SELECT f._id_,
    now() AS _tstamp_,
    f.name AS facility_name,
    f._id_ AS facilityproductstatusview_facility_fk,
    f.code,
    f.mobile,
    f.gps_longitude,
    f.gps_latitude,
        CASE
            WHEN (stockout.bluestockout IS NOT NULL) THEN 3
            WHEN (stockout.facility_id IS NOT NULL) THEN stockout.priority
            WHEN (oldvenderstockout.facility_id IS NOT NULL) THEN 3
            ELSE 5
        END AS priority,
        CASE
            WHEN (stockout.bluestockout IS NOT NULL) THEN 'vs_blue'::text
            WHEN (stockout.facility_id IS NOT NULL) THEN stockout.icon
            WHEN (oldvenderstockout.facility_id IS NOT NULL) THEN 'vs_blue'::text
            ELSE 'vs_green'::text
        END AS icon
   FROM ((zambia__svs_001.facility f
     LEFT JOIN ( SELECT nostock.facility_id,
                CASE
                    WHEN (nostocknoalternative.facility_id IS NOT NULL) THEN 1
                    WHEN (nostockwithalternative.facility_id IS NOT NULL) THEN 2
                    ELSE 1
                END AS priority,
                CASE
                    WHEN (nostocknoalternative.facility_id IS NOT NULL) THEN 'vs_red'::text
                    WHEN (nostockwithalternative.facility_id IS NOT NULL) THEN 'vs_yellow'::text
                    ELSE 'vs_red'::text
                END AS icon,
            last_facility_stockout.facility_id AS bluestockout
           FROM (((( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id
                   FROM (((zambia__svs_001.stockupdate su
                     JOIN ( SELECT su_1.stockupdate_facility_fk,
                            su_1.stockupdate_stock_fk,
                            max(su_1.update_date) AS dteweeks
                           FROM zambia__svs_001.stockupdate su_1
                          GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
                     JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                  WHERE (fs.deleted = 'No'::text)
                  GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                 HAVING (sum((su.current_level)::integer) = 0)) nostock
             LEFT JOIN ( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN ( SELECT su_1.stockupdate_facility_fk,
                            su_1.stockupdate_stock_fk,
                            max(su_1.update_date) AS dteweeks
                           FROM zambia__svs_001.stockupdate su_1
                          GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
                     JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((su.stockupdate_stockout_alternative_fk = sg._id_)))
                  WHERE ((fs.deleted = 'No'::text) AND (sg.value_ident = 1))
                  GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                 HAVING (sum((su.current_level)::integer) = 0)) nostocknoalternative ON ((nostock.facility_id = nostocknoalternative.facility_id)))
             LEFT JOIN ( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN ( SELECT su_1.stockupdate_facility_fk,
                            su_1.stockupdate_stock_fk,
                            max(su_1.update_date) AS dteweeks
                           FROM zambia__svs_001.stockupdate su_1
                          GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
                     JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((su.stockupdate_stockout_alternative_fk = sg._id_)))
                  WHERE ((fs.deleted = 'No'::text) AND (sg.value_ident = 2))
                  GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                 HAVING (sum((su.current_level)::integer) = 0)) nostockwithalternative ON ((nostock.facility_id = nostockwithalternative.facility_id)))
             LEFT JOIN ( SELECT stockout_maxdate.facility_id,
                    max(stockout_maxdate.max_update_date) AS last_stockout_date
                   FROM ( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id,
                            max(su.update_date) AS max_update_date
                           FROM (((zambia__svs_001.stockupdate su
                             JOIN ( SELECT su_1.stockupdate_facility_fk,
                                    su_1.stockupdate_stock_fk,
                                    max(su_1.update_date) AS dteweeks
                                   FROM zambia__svs_001.stockupdate su_1
                                  GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                          WHERE (fs.deleted = 'No'::text)
                          GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                         HAVING (sum((su.current_level)::integer) = 0)) stockout_maxdate
                  GROUP BY stockout_maxdate.facility_id
                 HAVING (max(stockout_maxdate.max_update_date) < ((('now'::text)::date - '21 days'::interval))::date)) last_facility_stockout ON ((nostock.facility_id = last_facility_stockout.facility_id)))) stockout ON ((f._id_ = stockout.facility_id)))
     LEFT JOIN ( SELECT DISTINCT hasvenderstockout.facility_id
           FROM (( SELECT fs.facilitystock_facility_fk AS facility_id,
                    s.inventorycode
                   FROM (((zambia__svs_001.stockupdate su
                     JOIN ( SELECT su_1.stockupdate_facility_fk,
                            su_1.stockupdate_stock_fk,
                            max(su_1.update_date) AS dteweeks
                           FROM zambia__svs_001.stockupdate su_1
                          GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
                     JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                  WHERE (fs.deleted = 'No'::text)
                  GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                 HAVING (sum((su.current_level)::integer) > 0)) hasstock
             JOIN ( SELECT f_1._id_ AS facility_id,
                    s.inventorycode
                   FROM (((((zambia__svs_001.stockupdate su
                     JOIN ( SELECT su_1.stockupdate_facility_fk,
                            su_1.stockupdate_stock_fk,
                            max(su_1.update_date) AS dteweeks
                           FROM zambia__svs_001.stockupdate su_1
                          GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.facility f_1 ON ((su.stockupdate_facility_fk = f_1._id_)))
                     JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg ON ((su.stockupdate_stockout_alternative_fk = sg._id_)))
                  WHERE ((sg.value_ident = ANY (ARRAY[1, 2])) AND (fs.deleted = 'No'::text) AND ((su.current_level)::integer = 0) AND ((su.update_date < ((('now'::text)::date - '21 days'::interval))::date) OR (su.first_stockout_date < ((('now'::text)::date - '21 days'::interval))::date)))
                  GROUP BY f_1._id_, s.inventorycode) hasvenderstockout ON (((hasstock.facility_id = hasvenderstockout.facility_id) AND (hasstock.inventorycode = hasvenderstockout.inventorycode))))) oldvenderstockout ON ((f._id_ = oldvenderstockout.facility_id)))
  WHERE (f.deleted = 'No'::text)
  ORDER BY
        CASE
            WHEN (stockout.bluestockout IS NOT NULL) THEN 3
            WHEN (stockout.facility_id IS NOT NULL) THEN stockout.priority
            WHEN (oldvenderstockout.facility_id IS NOT NULL) THEN 3
            ELSE 5
        END;


--
-- Name: facilityreortingtopitems_aggregation_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.facilityreortingtopitems_aggregation_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p._id_ AS _provinceid,
            p.name AS provincename,
            d._id_ AS _districtid,
            d.name AS districtname,
            sd._id_ AS _subdistrictid,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname,
            f._id_,
            f._tstamp_,
            f.name,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
            f.deleted,
            f.mustexit,
            f.facility_district_fk,
            f.facility_subdistrict_fk,
            f.date_created,
            f._tx_id_,
            f._change_type_,
            f._change_seq_
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), maxupdatelevels AS (
         SELECT q._facilityid,
            q._stockid,
            q.update_date,
            ((date_part('epoch'::text, age(now(), (q.update_date)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp
           FROM ( SELECT su.stockupdate_facility_fk AS _facilityid,
                    su.stockupdate_stock_fk AS _stockid,
                    (max(su.update_date) + '02:00:00'::interval) AS update_date
                   FROM zambia__svs_001.stockupdate su
                  GROUP BY su.stockupdate_facility_fk, su.stockupdate_stock_fk) q
        ), qnationalfacilitystockextra AS (
         SELECT DISTINCT fh.provincename,
            fh.districtname,
            fh.subdistrictname,
            fh.facilityname,
            sg.value AS stocktype,
            s.itemname,
            s.abbreviation,
            s.inventorycode,
            vs.stock_type,
            mud.update_date,
            fs.total AS "stock level",
                CASE
                    WHEN (COALESCE(fs.total, 1) <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out,
                CASE
                    WHEN (COALESCE(fs.total, 1) <> 0) THEN NULL::integer
                    ELSE ((date_part('epoch'::text, age(now(), (fs.stock_out_time)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer
                END AS days_since_first_stockout,
            COALESCE(mud.days_since_last_update_timestamp, 1000) AS days_since_last_update_timestamp,
            fh._facilityid,
            fs._id_ AS _stockid,
            sg._id_ AS _stocktypeid
           FROM (((((facilityhierarchy fh
             JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.deleted = 'No'::text))))
             JOIN zambia__svs_001.stock s ON (((fs.facilitystock_stock_fk = s._id_) AND (fs.deleted = 'No'::text))))
             JOIN zambia__svs_001.stringgroup sg ON (((s.stock_stringgroup_fk = sg._id_) AND (sg.deleted = 'No'::text))))
             JOIN ( SELECT vs_1.inventorycode,
                    vs_1.stock_type
                   FROM zambia__svs_001.vendorstock vs_1
                  GROUP BY vs_1.inventorycode, vs_1.stock_type) vs ON ((vs.inventorycode = s.inventorycode)))
             JOIN maxupdatelevels mud ON (((fs.facilitystock_facility_fk = mud._facilityid) AND (fs.facilitystock_stock_fk = mud._stockid))))
          WHERE (btrim(COALESCE(s.itemname, ''::text)) <> ''::text)
        ), qnationalfacilitystockextra_facility AS (
         SELECT qnationalfacilitystockextra.provincename,
            qnationalfacilitystockextra.districtname,
            qnationalfacilitystockextra.subdistrictname,
            qnationalfacilitystockextra.facilityname,
            qnationalfacilitystockextra._facilityid,
            max(qnationalfacilitystockextra.current_stock_out) AS current_stock_out,
            min(qnationalfacilitystockextra.days_since_last_update_timestamp) AS days_since_last_update_timestamp
           FROM qnationalfacilitystockextra
          GROUP BY qnationalfacilitystockextra.provincename, qnationalfacilitystockextra.districtname, qnationalfacilitystockextra.subdistrictname, qnationalfacilitystockextra.facilityname, qnationalfacilitystockextra._facilityid
        ), qnationalfacilitystockextra_facility_topitems AS (
         SELECT qnationalfacilitystockextra.provincename,
            qnationalfacilitystockextra.districtname,
            qnationalfacilitystockextra.subdistrictname,
            qnationalfacilitystockextra.facilityname,
            qnationalfacilitystockextra._facilityid,
            max(qnationalfacilitystockextra.current_stock_out) AS current_stock_out,
            min(qnationalfacilitystockextra.days_since_last_update_timestamp) AS days_since_last_update_timestamp,
            count(DISTINCT qnationalfacilitystockextra._stocktypeid) AS top_cotegories
           FROM qnationalfacilitystockextra
          WHERE (qnationalfacilitystockextra.stocktype = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text]))
          GROUP BY qnationalfacilitystockextra.provincename, qnationalfacilitystockextra.districtname, qnationalfacilitystockextra.subdistrictname, qnationalfacilitystockextra.facilityname, qnationalfacilitystockextra._facilityid
        )
 SELECT qnationalfacilitystockextra_facility_topitems.provincename,
    qnationalfacilitystockextra_facility_topitems.districtname,
    qnationalfacilitystockextra_facility_topitems.subdistrictname,
    qnationalfacilitystockextra_facility_topitems.facilityname,
    qnationalfacilitystockextra_facility_topitems._facilityid,
    qnationalfacilitystockextra_facility_topitems.current_stock_out,
    qnationalfacilitystockextra_facility_topitems.days_since_last_update_timestamp,
    qnationalfacilitystockextra_facility_topitems.top_cotegories
   FROM qnationalfacilitystockextra_facility_topitems;


--
-- Name: facilityresponserate_materializedview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.facilityresponserate_materializedview_actual AS
 WITH facilityhierarchy AS (
         SELECT p.name AS provincename,
            d.name AS districtname,
            sd.name AS subdistrictname,
            f.name AS facilityname,
            f._id_ AS _facilityid,
            sd._id_ AS _subdistrictid,
            d._id_ AS _districtid,
            p._id_ AS _provinceid
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          WHERE ((f.deleted = 'No'::text) AND ((lower(p.name) ~~ lower('%@provincename%'::text)) OR ("left"('@provincename'::text, 1) = '@'::text)) AND (p.name <> 'Training Demos'::text))
        ), lastweekreportedfacilitiesstatus AS (
         SELECT fh.provincename,
            fh.districtname,
            fh.subdistrictname,
            fh.facilityname,
            fh._facilityid,
            fh._subdistrictid,
            fh._districtid,
            fh._provinceid,
                CASE
                    WHEN (COALESCE(reportedlastweek.top_categories, (0)::bigint) < 1) THEN 0
                    ELSE 1
                END AS reporting_indicator
           FROM (facilityhierarchy fh
             LEFT JOIN ( SELECT DISTINCT su.stockupdate_facility_fk AS facilityid,
                    count(DISTINCT sg._id_) AS top_categories
                   FROM ((zambia__svs_001.stockupdate su
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
                  WHERE ((LEAST(date(su.update_date), date(su._tstamp_)) IN ( SELECT ((date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone))::date + (i.i - 7))
                           FROM generate_series(0, 6) i(i))) AND (sg.value = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text])))
                  GROUP BY su.stockupdate_facility_fk) reportedlastweek ON ((fh._facilityid = reportedlastweek.facilityid)))
          ORDER BY fh.provincename, fh.districtname, fh.subdistrictname, fh.facilityname
        ), facilitiesreportingratesummarysubdistrict AS (
         SELECT sd.name AS hierarchy_name,
            count(DISTINCT rp._facilityid) AS number_of_facilitiesloaded,
            sum(rp.reporting_indicator) AS number_of_responses,
            rp._subdistrictid AS subdistrict_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS province_uuid
           FROM (zambia__svs_001.subdistrict sd
             JOIN lastweekreportedfacilitiesstatus rp ON ((sd._id_ = rp._subdistrictid)))
          GROUP BY sd.name, rp._subdistrictid, NULL::uuid
          ORDER BY sd.name
        ), facilitiesreportingratesummarydistrict AS (
         SELECT rp.districtname AS hierarchy_name,
            count(DISTINCT rp._facilityid) AS number_of_facilitiesloaded,
            sum(rp.reporting_indicator) AS number_of_responses,
            NULL::uuid AS subdistrict_uuid,
            rp._districtid AS district_uuid,
            NULL::uuid AS province_uuid
           FROM (zambia__svs_001.district d
             JOIN lastweekreportedfacilitiesstatus rp ON ((d._id_ = rp._districtid)))
          GROUP BY rp.districtname, NULL::uuid, rp._districtid
          ORDER BY rp.districtname
        ), facilitiesreportingratesummaryprovince AS (
         SELECT rp.provincename AS hierarchy_name,
            count(DISTINCT rp._facilityid) AS number_of_facilitiesloaded,
            sum(rp.reporting_indicator) AS number_of_responses,
            NULL::uuid AS subdistrict_uuid,
            NULL::uuid AS district_uuid,
            rp._provinceid AS province_uuid
           FROM (zambia__svs_001.province p
             JOIN lastweekreportedfacilitiesstatus rp ON ((p._id_ = rp._provinceid)))
          GROUP BY rp.provincename, NULL::uuid, rp._provinceid
          ORDER BY rp.provincename
        ), facilitiesreportingratesummarynational AS (
         SELECT facilitiesreportingratesummarysubdistrict.hierarchy_name,
            facilitiesreportingratesummarysubdistrict.number_of_facilitiesloaded,
            facilitiesreportingratesummarysubdistrict.number_of_responses,
            facilitiesreportingratesummarysubdistrict.subdistrict_uuid,
            facilitiesreportingratesummarysubdistrict.district_uuid,
            facilitiesreportingratesummarysubdistrict.province_uuid
           FROM facilitiesreportingratesummarysubdistrict
        UNION
         SELECT facilitiesreportingratesummarydistrict.hierarchy_name,
            facilitiesreportingratesummarydistrict.number_of_facilitiesloaded,
            facilitiesreportingratesummarydistrict.number_of_responses,
            facilitiesreportingratesummarydistrict.subdistrict_uuid,
            facilitiesreportingratesummarydistrict.district_uuid,
            facilitiesreportingratesummarydistrict.province_uuid
           FROM facilitiesreportingratesummarydistrict
        UNION
         SELECT facilitiesreportingratesummaryprovince.hierarchy_name,
            facilitiesreportingratesummaryprovince.number_of_facilitiesloaded,
            facilitiesreportingratesummaryprovince.number_of_responses,
            facilitiesreportingratesummaryprovince.subdistrict_uuid,
            facilitiesreportingratesummaryprovince.district_uuid,
            facilitiesreportingratesummaryprovince.province_uuid
           FROM facilitiesreportingratesummaryprovince
        )
 SELECT facilitiesreportingratesummarynational.hierarchy_name,
    facilitiesreportingratesummarynational.number_of_facilitiesloaded,
    facilitiesreportingratesummarynational.number_of_responses,
    facilitiesreportingratesummarynational.subdistrict_uuid,
    facilitiesreportingratesummarynational.district_uuid,
    facilitiesreportingratesummarynational.province_uuid
   FROM facilitiesreportingratesummarynational;


--
-- Name: facilityresponserate_materializedview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.facilityresponserate_materializedview AS
 SELECT facilityresponserate_materializedview_actual.hierarchy_name,
    facilityresponserate_materializedview_actual.number_of_facilitiesloaded,
    facilityresponserate_materializedview_actual.number_of_responses,
    facilityresponserate_materializedview_actual.subdistrict_uuid,
    facilityresponserate_materializedview_actual.district_uuid,
    facilityresponserate_materializedview_actual.province_uuid
   FROM zambia__svs_001.facilityresponserate_materializedview_actual
  WITH NO DATA;


--
-- Name: facilitystatusview; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.facilitystatusview AS
 SELECT facility._id_,
    facility._tstamp_,
    facility.name,
    facility.code,
    facility.mobile,
    facility.gps_longitude,
    facility.gps_latitude,
    facility.deleted,
    facility._id_ AS facilitystatusview_facility_fk,
    freport.facility_status AS status,
    freport.facility_status_colour AS status_colour,
    freport.facilitystatusorder AS status_order
   FROM (zambia__svs_001.facility
     JOIN ( SELECT facility_1._id_ AS facility_id,
            facility_1.name AS facilityname,
                CASE
                    WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
                    CASE
                        WHEN (stockouts.stockoutstatus = 1) THEN 'Stock out'::text
                        WHEN (stockouts.stockoutstatus = 2) THEN 'Stock out - Alternative available'::text
                        ELSE NULL::text
                    END
                    WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Stock without updates'::text
                    WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'No recent updates'::text
                    WHEN (facilitynostock.* IS NOT NULL) THEN 'No stock assigned'::text
                    ELSE 'Normal'::text
                END AS facility_status,
                CASE
                    WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
                    CASE
                        WHEN (stockouts.stockoutstatus = 1) THEN 'vs_red'::text
                        WHEN (stockouts.stockoutstatus = 2) THEN 'vs_blue'::text
                        ELSE NULL::text
                    END
                    WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'vs_purple'::text
                    WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'vs_orange'::text
                    WHEN (facilitynostock.* IS NOT NULL) THEN 'vs_green'::text
                    ELSE 'vs_green'::text
                END AS facility_status_colour,
                CASE
                    WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
                    CASE
                        WHEN (stockouts.stockoutstatus = 1) THEN 1
                        WHEN (stockouts.stockoutstatus = 2) THEN 2
                        ELSE NULL::integer
                    END
                    WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 3
                    WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 4
                    WHEN (facilitynostock._id_ IS NOT NULL) THEN 5
                    ELSE 5
                END AS facilitystatusorder
           FROM ((((zambia__svs_001.facility facility_1
             LEFT JOIN ( SELECT stockoutpriority.stockoutfacilityid,
                    stockoutpriority.stockoutstatus
                   FROM ( SELECT row_number() OVER (PARTITION BY stockoutbypriorityorder.stockoutfacilityid ORDER BY stockoutbypriorityorder.stockoutfacilityid) AS therownum,
                            stockoutbypriorityorder.stockoutfacilityid,
                            stockoutbypriorityorder.stockoutstatus
                           FROM ( SELECT stockupdate.stockupdate_facility_fk AS stockoutfacilityid,
CASE
 WHEN (stockupdate.stockupdate_stockout_status_fk IS NULL) THEN 1
 WHEN (stockupdate.stockupdate_stockout_status_fk IS NOT NULL) THEN stringgroup.value_ident
 ELSE NULL::integer
END AS stockoutstatus
                                   FROM ((zambia__svs_001.stockupdate
                                     JOIN ( SELECT stockupdate_1.stockupdate_facility_fk AS facility_id,
    stockupdate_1.stockupdate_stock_fk AS stock_id,
    max(stockupdate_1.update_date) AS max_update_date
   FROM (zambia__svs_001.stockupdate stockupdate_1
     JOIN zambia__svs_001.facilitystock ON ((stockupdate_1.stockupdate_facilitystock_fk = facilitystock._id_)))
  WHERE ((stockupdate_1.stockupdate_facility_fk IS NOT NULL) AND (facilitystock.deleted = 'No'::text))
  GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) latest_stockupdate ON (((stockupdate.stockupdate_facility_fk = latest_stockupdate.facility_id) AND (stockupdate.stockupdate_stock_fk = latest_stockupdate.stock_id))))
                                     LEFT JOIN zambia__svs_001.stringgroup ON ((stockupdate.stockupdate_stockout_status_fk = stringgroup._id_)))
                                  WHERE ((stockupdate.update_date = latest_stockupdate.max_update_date) AND (stockupdate.current_level = '0'::text))
                                  ORDER BY stockupdate.stockupdate_facility_fk,
CASE
 WHEN (stockupdate.stockupdate_stockout_status_fk IS NULL) THEN 1
 WHEN (stockupdate.stockupdate_stockout_status_fk IS NOT NULL) THEN stringgroup.value_ident
 ELSE NULL::integer
END) stockoutbypriorityorder) stockoutpriority
                  WHERE (stockoutpriority.therownum = 1)) stockouts ON ((facility_1._id_ = stockouts.stockoutfacilityid)))
             LEFT JOIN ( SELECT DISTINCT facilitystock.facilitystock_facility_fk AS facilityid
                   FROM (zambia__svs_001.facilitystock
                     LEFT JOIN ( SELECT stockupdate.stockupdate_facility_fk AS facilityid,
                            stockupdate.stockupdate_stock_fk AS stockid
                           FROM zambia__svs_001.stockupdate
                          WHERE (stockupdate.stockupdate_facility_fk IS NOT NULL)
                          GROUP BY stockupdate.stockupdate_facility_fk, stockupdate.stockupdate_stock_fk) facility_with_update ON (((facilitystock.facilitystock_facility_fk = facility_with_update.facilityid) AND (facilitystock.facilitystock_stock_fk = facility_with_update.stockid))))
                  WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facility_with_update.facilityid IS NULL) AND (facility_with_update.stockid IS NULL) AND (facilitystock.deleted = 'No'::text))
                  GROUP BY facilitystock.facilitystock_facility_fk) stockwithoutanyupdate ON ((facility_1._id_ = stockwithoutanyupdate.facilityid)))
             LEFT JOIN ( SELECT DISTINCT facilitystock.facilitystock_facility_fk AS facilityid
                   FROM (zambia__svs_001.facilitystock
                     LEFT JOIN ( SELECT stockupdate.stockupdate_facility_fk AS facilityid,
                            stockupdate.stockupdate_stock_fk AS stockid
                           FROM zambia__svs_001.stockupdate
                          WHERE ((stockupdate.stockupdate_facility_fk IS NOT NULL) AND (stockupdate.update_date >= ((('now'::text)::date)::timestamp without time zone + '-32 days'::interval day)) AND (stockupdate.update_date <= now()))
                          GROUP BY stockupdate.stockupdate_facility_fk, stockupdate.stockupdate_stock_fk) facility_with_update ON (((facilitystock.facilitystock_facility_fk = facility_with_update.facilityid) AND (facilitystock.facilitystock_stock_fk = facility_with_update.stockid))))
                  WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facility_with_update.facilityid IS NULL) AND (facility_with_update.stockid IS NULL) AND (facilitystock.deleted = 'No'::text))
                  GROUP BY facilitystock.facilitystock_facility_fk) stockwithoutanyupdateinrange ON ((facility_1._id_ = stockwithoutanyupdateinrange.facilityid)))
             LEFT JOIN ( SELECT facility_2._id_
                   FROM (zambia__svs_001.facility facility_2
                     LEFT JOIN ( SELECT facilitystock.facilitystock_facility_fk
                           FROM zambia__svs_001.facilitystock
                          WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facilitystock.deleted = 'No'::text))
                          GROUP BY facilitystock.facilitystock_facility_fk) facilitywithstock ON ((facility_2._id_ = facilitywithstock.facilitystock_facility_fk)))
                  WHERE (facilitywithstock.facilitystock_facility_fk IS NULL)) facilitynostock ON ((facility_1._id_ = facilitynostock._id_)))
          WHERE (facility_1.deleted = 'No'::text)
          GROUP BY stockouts.stockoutfacilityid, stockwithoutanyupdate.facilityid, stockwithoutanyupdateinrange.facilityid, facilitynostock._id_, facility_1.name, facility_1._id_,
                CASE
                    WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
                    CASE
                        WHEN (stockouts.stockoutstatus = 1) THEN 'Stock out'::text
                        WHEN (stockouts.stockoutstatus = 2) THEN 'Stock out - Alternative available'::text
                        ELSE NULL::text
                    END
                    WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Stock without updates'::text
                    WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'No recent updates'::text
                    WHEN (facilitynostock.* IS NOT NULL) THEN 'No stock assigned'::text
                    ELSE 'Normal'::text
                END,
                CASE
                    WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
                    CASE
                        WHEN (stockouts.stockoutstatus = 1) THEN 'vs_red'::text
                        WHEN (stockouts.stockoutstatus = 2) THEN 'vs_blue'::text
                        ELSE NULL::text
                    END
                    WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'vs_purple'::text
                    WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'vs_orange'::text
                    WHEN (facilitynostock.* IS NOT NULL) THEN 'vs_green'::text
                    ELSE 'vs_green'::text
                END, stockouts.stockoutstatus) freport ON ((freport.facility_id = facility._id_)))
  ORDER BY freport.facilitystatusorder;


--
-- Name: facilitystock_sync_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.facilitystock_sync_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.facilitystock_sync_aggregation_function() AS counter;


--
-- Name: facilitystock_to_sync; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.facilitystock_to_sync (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    by_userrole text,
    _userroleid uuid,
    _facilitystockid uuid,
    date_created timestamp without time zone
);


--
-- Name: facilitystocklevelstatus_materializedview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.facilitystocklevelstatus_materializedview_actual AS
SELECT
    NULL::text AS facilityname,
    NULL::text AS facility_status,
    NULL::text AS facility_status_colour,
    NULL::integer AS facilitystatusorder,
    NULL::text AS province,
    NULL::text AS district,
    NULL::text AS subdistrict,
    NULL::uuid AS facilityid,
    NULL::uuid AS subdistrictid,
    NULL::uuid AS districtid,
    NULL::uuid AS provinceid;


--
-- Name: facilitystocklevelstatus_materializedview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.facilitystocklevelstatus_materializedview AS
 SELECT facilitystocklevelstatus_materializedview_actual.facilityname,
    facilitystocklevelstatus_materializedview_actual.facility_status,
    facilitystocklevelstatus_materializedview_actual.facility_status_colour,
    facilitystocklevelstatus_materializedview_actual.facilitystatusorder,
    facilitystocklevelstatus_materializedview_actual.province,
    facilitystocklevelstatus_materializedview_actual.district,
    facilitystocklevelstatus_materializedview_actual.subdistrict,
    facilitystocklevelstatus_materializedview_actual.facilityid,
    facilitystocklevelstatus_materializedview_actual.subdistrictid,
    facilitystocklevelstatus_materializedview_actual.districtid,
    facilitystocklevelstatus_materializedview_actual.provinceid
   FROM zambia__svs_001.facilitystocklevelstatus_materializedview_actual
  WITH NO DATA;


--
-- Name: fire_generate_heliumonlyfacilitystatus; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.fire_generate_heliumonlyfacilitystatus AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_heliumonlyfacilitystatus() AS result;


--
-- Name: fire_generate_heliumonlyreportingaggregate; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.fire_generate_heliumonlyreportingaggregate AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_heliumonlyreportingaggregate() AS result;


--
-- Name: fire_generate_heliumonlyreportingfacility; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.fire_generate_heliumonlyreportingfacility AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_heliumonlyreportingfacility() AS result;


--
-- Name: fire_generate_heliumonlystockout; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.fire_generate_heliumonlystockout AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_heliumonlystockout() AS result;


--
-- Name: form_type; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.form_type (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    value text,
    date_created timestamp without time zone,
    deleted text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: fridge; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.fridge (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    description text,
    facility_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: heliumonlyaveragestockoutdurationitems; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyaveragestockoutdurationitems (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    arvcount integer,
    tbcount integer,
    vacccount integer,
    location text,
    heliumonlyaveragestockoutdurationitems_province_fk uuid,
    heliumonlyaveragestockoutdurationitems_district_fk uuid,
    heliumonlyaveragestockoutdurationitems_subdistrict_fk uuid,
    heliumonlyaveragestockoutdurationitems_facility_fk uuid
);


--
-- Name: heliumonlyaveragestockoutdurationitems_aggregation_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlyaveragestockoutdurationitems_aggregation_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p.name AS provincename,
            d.name AS districtname,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
             LEFT JOIN zambia__svs_001.district d ON ((sd.subdistrict_district_fk = d._id_)))
             LEFT JOIN zambia__svs_001.province p ON ((d.district_province_fk = p._id_)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_new AS (
         SELECT q."timestamp",
            q.update_date,
            q.expiry_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.stockcategory,
            q.itemname,
            q.abbreviation,
            q.inventorycode,
            q."stock level",
            q."stock received",
            q."stock lost",
            q.first_stockout_date,
            q.stockout_reported_to_pdm,
            q._facilityid,
            q._stockid,
            ((date_part('epoch'::text, age(now(), COALESCE((q.first_stockout_date)::timestamp with time zone, now()))) / (((60 * 60) * 24))::double precision))::integer AS days_since_first_stockout,
            ((date_part('epoch'::text, age(now(), (q."timestamp")::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp,
                CASE
                    WHEN ((COALESCE(q."stock level", '0'::text))::integer <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out
           FROM ( SELECT
                        CASE
                            WHEN (su._tstamp_ >= '2014-10-09'::date) THEN su._tstamp_
                            ELSE (su.update_date + '02:00:00'::interval)
                        END AS "timestamp",
                    (su.update_date + '02:00:00'::interval) AS update_date,
                        CASE
                            WHEN ((COALESCE(su.expiry_date, (now())::date) >= '1900-01-01'::date) AND (COALESCE(su.expiry_date, (now())::date) <= '2100-01-01'::date)) THEN su.expiry_date
                            ELSE NULL::date
                        END AS expiry_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    sg.value AS stockcategory,
                    s.itemname,
                    s.abbreviation,
                    s.inventorycode,
                    su.current_level AS "stock level",
                    su.stock_received AS "stock received",
                    su.stock_lost AS "stock lost",
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.first_stockout_date
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                        CASE
                            WHEN ((COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.stockout_reported_to_pdm
                            ELSE NULL::timestamp without time zone
                        END AS stockout_reported_to_pdm,
                    fh._facilityid,
                    s._id_ AS _stockid
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN facilityhierarchy fh ON ((su.stockupdate_facility_fk = fh._facilityid)))
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk) AND (fs.deleted = 'No'::text))))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
                  WHERE ((su.stockupdate_facility_fk IS NOT NULL) AND (sg.value = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text])) AND ((s.inventorycode = '@inventorycode'::text) OR ("left"('@inventorycode'::text, 1) = '@'::text)))) q
        ), qnationalstockupdatelevels AS (
         SELECT asu.provincename,
            asu.districtname,
            asu.subdistrictname,
            asu.facilityname,
            asu.stockcategory,
            asu.itemname,
            asu.abbreviation,
            asu.inventorycode,
            asu."timestamp",
            asu.update_date,
            asu."stock level",
            asu."stock received",
            asu."stock lost",
            asu.expiry_date,
            asu.first_stockout_date,
            asu.stockout_reported_to_pdm,
            asu.days_since_first_stockout,
            asu.days_since_last_update_timestamp,
            asu.current_stock_out,
            asu._facilityid,
            asu._stockid
           FROM (qnationalstockupdates_new asu
             JOIN ( SELECT qnationalstockupdates_new._facilityid,
                    qnationalstockupdates_new._stockid,
                    max(qnationalstockupdates_new."timestamp") AS mxt
                   FROM qnationalstockupdates_new
                  GROUP BY qnationalstockupdates_new._facilityid, qnationalstockupdates_new._stockid) mud ON (((asu._facilityid = mud._facilityid) AND (asu._stockid = mud._stockid) AND (asu."timestamp" = mud.mxt))))
        ), nationalstockoutdurationitems AS (
         SELECT qnationalstockupdatelevels.stockcategory,
            qnationalstockupdatelevels.itemname AS stock,
            qnationalstockupdatelevels.inventorycode,
            qnationalstockupdatelevels.days_since_first_stockout,
            qnationalstockupdatelevels.days_since_last_update_timestamp,
            qnationalstockupdatelevels.facilityname,
            qnationalstockupdatelevels.subdistrictname,
            qnationalstockupdatelevels.districtname,
            qnationalstockupdatelevels.provincename,
            qnationalstockupdatelevels._facilityid
           FROM qnationalstockupdatelevels
          WHERE (qnationalstockupdatelevels."stock level" = '0'::text)
          ORDER BY qnationalstockupdatelevels.stockcategory, qnationalstockupdatelevels.itemname, qnationalstockupdatelevels.inventorycode
        ), averagestockoutdurationsummaryfacility AS (
         SELECT DISTINCT fh.facilityname AS location,
            round(COALESCE(arv."ARV", (0)::numeric), 0) AS arvcount,
            round(COALESCE(tb."TB", (0)::numeric), 0) AS tbcount,
            round(COALESCE(vacc."Vacc", (0)::numeric), 0) AS vacccount,
            NULL::uuid AS province_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            fh._facilityid AS facility_uuid
           FROM (((facilityhierarchy fh
             LEFT JOIN ( SELECT avg(nationalstockoutdurationitems.days_since_first_stockout) AS "ARV",
                    nationalstockoutdurationitems._facilityid,
                    nationalstockoutdurationitems.stockcategory
                   FROM nationalstockoutdurationitems
                  WHERE (nationalstockoutdurationitems.stockcategory = 'ARV'::text)
                  GROUP BY nationalstockoutdurationitems.stockcategory, nationalstockoutdurationitems._facilityid) arv ON ((fh._facilityid = arv._facilityid)))
             LEFT JOIN ( SELECT avg(nationalstockoutdurationitems.days_since_first_stockout) AS "TB",
                    nationalstockoutdurationitems._facilityid,
                    nationalstockoutdurationitems.stockcategory
                   FROM nationalstockoutdurationitems
                  WHERE (nationalstockoutdurationitems.stockcategory = 'TB'::text)
                  GROUP BY nationalstockoutdurationitems.stockcategory, nationalstockoutdurationitems._facilityid) tb ON ((fh._facilityid = tb._facilityid)))
             LEFT JOIN ( SELECT avg(nationalstockoutdurationitems.days_since_first_stockout) AS "Vacc",
                    nationalstockoutdurationitems._facilityid,
                    nationalstockoutdurationitems.stockcategory
                   FROM nationalstockoutdurationitems
                  WHERE (nationalstockoutdurationitems.stockcategory = 'Vacc'::text)
                  GROUP BY nationalstockoutdurationitems.stockcategory, nationalstockoutdurationitems._facilityid) vacc ON ((fh._facilityid = vacc._facilityid)))
          ORDER BY fh.facilityname
        ), averagestockoutdurationsummarysubdistrict AS (
         SELECT sdh.name AS location,
            round(COALESCE(avgstockout.arv, (0)::numeric), 0) AS arvcount,
            round(COALESCE(avgstockout_1.tb, (0)::numeric), 0) AS tbcount,
            round(COALESCE(avgstockout_2.vacc, (0)::numeric), 0) AS vacccount,
            NULL::uuid AS province_uuid,
            NULL::uuid AS district_uuid,
            sdh._id_ AS subdistrict_uuid,
            NULL::uuid AS facility_uuid
           FROM (((zambia__svs_001.subdistrict sdh
             LEFT JOIN ( SELECT avg(averagestockoutdurationsummaryfacility.arvcount) AS arv,
                    sd._id_ AS subdistrictid
                   FROM ((averagestockoutdurationsummaryfacility
                     LEFT JOIN zambia__svs_001.facility f ON ((f._id_ = averagestockoutdurationsummaryfacility.facility_uuid)))
                     LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
                  WHERE (averagestockoutdurationsummaryfacility.arvcount <> (0)::numeric)
                  GROUP BY sd._id_) avgstockout ON ((sdh._id_ = avgstockout.subdistrictid)))
             LEFT JOIN ( SELECT avg(averagestockoutdurationsummaryfacility.tbcount) AS tb,
                    sd._id_ AS subdistrictid
                   FROM ((averagestockoutdurationsummaryfacility
                     LEFT JOIN zambia__svs_001.facility f ON ((f._id_ = averagestockoutdurationsummaryfacility.facility_uuid)))
                     LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
                  WHERE (averagestockoutdurationsummaryfacility.tbcount <> (0)::numeric)
                  GROUP BY sd._id_) avgstockout_1 ON ((sdh._id_ = avgstockout_1.subdistrictid)))
             LEFT JOIN ( SELECT avg(averagestockoutdurationsummaryfacility.vacccount) AS vacc,
                    sd._id_ AS subdistrictid
                   FROM ((averagestockoutdurationsummaryfacility
                     LEFT JOIN zambia__svs_001.facility f ON ((f._id_ = averagestockoutdurationsummaryfacility.facility_uuid)))
                     LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
                  WHERE (averagestockoutdurationsummaryfacility.vacccount <> (0)::numeric)
                  GROUP BY sd._id_) avgstockout_2 ON ((sdh._id_ = avgstockout_2.subdistrictid)))
        ), averagestockoutdurationsummarydistrict AS (
         SELECT d.name AS location,
            round(COALESCE(avgstockout_d.arv, (0)::numeric), 0) AS arvcount,
            round(COALESCE(avgstockout_d1.tb, (0)::numeric), 0) AS tbcount,
            round(COALESCE(avgstockout_d2.vacc, (0)::numeric), 0) AS vacccount,
            NULL::uuid AS province_uuid,
            d._id_ AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            NULL::uuid AS facility_uuid
           FROM (((zambia__svs_001.district d
             LEFT JOIN ( SELECT avg(avgst.arvcount) AS arv,
                    d_1._id_ AS districtid
                   FROM ((averagestockoutdurationsummarysubdistrict avgst
                     JOIN zambia__svs_001.subdistrict sd ON ((avgst.subdistrict_uuid = sd._id_)))
                     JOIN zambia__svs_001.district d_1 ON ((sd.subdistrict_district_fk = d_1._id_)))
                  WHERE (avgst.arvcount <> (0)::numeric)
                  GROUP BY d_1._id_) avgstockout_d ON ((d._id_ = avgstockout_d.districtid)))
             LEFT JOIN ( SELECT avg(avgst.tbcount) AS tb,
                    d_1._id_ AS districtid
                   FROM ((averagestockoutdurationsummarysubdistrict avgst
                     JOIN zambia__svs_001.subdistrict sd ON ((avgst.subdistrict_uuid = sd._id_)))
                     JOIN zambia__svs_001.district d_1 ON ((sd.subdistrict_district_fk = d_1._id_)))
                  WHERE (avgst.tbcount <> (0)::numeric)
                  GROUP BY d_1._id_) avgstockout_d1 ON ((d._id_ = avgstockout_d1.districtid)))
             LEFT JOIN ( SELECT avg(avgst.vacccount) AS vacc,
                    d_1._id_ AS districtid
                   FROM ((averagestockoutdurationsummarysubdistrict avgst
                     JOIN zambia__svs_001.subdistrict sd ON ((avgst.subdistrict_uuid = sd._id_)))
                     JOIN zambia__svs_001.district d_1 ON ((sd.subdistrict_district_fk = d_1._id_)))
                  WHERE (avgst.vacccount <> (0)::numeric)
                  GROUP BY d_1._id_) avgstockout_d2 ON ((d._id_ = avgstockout_d2.districtid)))
        ), averagestockoutdurationsummaryprovince AS (
         SELECT p.name AS location,
            round(COALESCE(avgstockout_p.arv, (0)::numeric), 0) AS arvcount,
            round(COALESCE(avgstockout_p1.tb, (0)::numeric), 0) AS tbcount,
            round(COALESCE(avgstockout_p2.vacc, (0)::numeric), 0) AS vacccount,
            p._id_ AS province_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            NULL::uuid AS facility_uuid
           FROM (((zambia__svs_001.province p
             LEFT JOIN ( SELECT avg(avgst.arvcount) AS arv,
                    p_1._id_ AS provinceid
                   FROM ((averagestockoutdurationsummarydistrict avgst
                     JOIN zambia__svs_001.district d ON ((avgst.district_uuid = d._id_)))
                     JOIN zambia__svs_001.province p_1 ON ((d.district_province_fk = p_1._id_)))
                  WHERE ((avgst.arvcount <> (0)::numeric) AND (avgst.tbcount <> (0)::numeric) AND (avgst.vacccount <> (0)::numeric) AND (p_1.name <> 'Training Demos'::text))
                  GROUP BY p_1._id_) avgstockout_p ON ((p._id_ = avgstockout_p.provinceid)))
             LEFT JOIN ( SELECT avg(avgst.tbcount) AS tb,
                    p_1._id_ AS provinceid
                   FROM ((averagestockoutdurationsummarydistrict avgst
                     JOIN zambia__svs_001.district d ON ((avgst.district_uuid = d._id_)))
                     JOIN zambia__svs_001.province p_1 ON ((d.district_province_fk = p_1._id_)))
                  WHERE ((avgst.tbcount <> (0)::numeric) AND (p_1.name <> 'Training Demos'::text))
                  GROUP BY p_1._id_) avgstockout_p1 ON ((p._id_ = avgstockout_p1.provinceid)))
             LEFT JOIN ( SELECT avg(avgst.vacccount) AS vacc,
                    p_1._id_ AS provinceid
                   FROM ((averagestockoutdurationsummarydistrict avgst
                     JOIN zambia__svs_001.district d ON ((avgst.district_uuid = d._id_)))
                     JOIN zambia__svs_001.province p_1 ON ((d.district_province_fk = p_1._id_)))
                  WHERE ((avgst.vacccount <> (0)::numeric) AND (p_1.name <> 'Training Demos'::text))
                  GROUP BY p_1._id_) avgstockout_p2 ON ((p._id_ = avgstockout_p2.provinceid)))
        )
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummaryfacility.arvcount,
    averagestockoutdurationsummaryfacility.tbcount,
    averagestockoutdurationsummaryfacility.vacccount,
    averagestockoutdurationsummaryfacility.location,
    averagestockoutdurationsummaryfacility.province_uuid,
    averagestockoutdurationsummaryfacility.district_uuid,
    averagestockoutdurationsummaryfacility.subdistrict_uuid,
    averagestockoutdurationsummaryfacility.facility_uuid
   FROM averagestockoutdurationsummaryfacility
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummarysubdistrict.arvcount,
    averagestockoutdurationsummarysubdistrict.tbcount,
    averagestockoutdurationsummarysubdistrict.vacccount,
    averagestockoutdurationsummarysubdistrict.location,
    averagestockoutdurationsummarysubdistrict.province_uuid,
    averagestockoutdurationsummarysubdistrict.district_uuid,
    averagestockoutdurationsummarysubdistrict.subdistrict_uuid,
    averagestockoutdurationsummarysubdistrict.facility_uuid
   FROM averagestockoutdurationsummarysubdistrict
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummarydistrict.arvcount,
    averagestockoutdurationsummarydistrict.tbcount,
    averagestockoutdurationsummarydistrict.vacccount,
    averagestockoutdurationsummarydistrict.location,
    averagestockoutdurationsummarydistrict.province_uuid,
    averagestockoutdurationsummarydistrict.district_uuid,
    averagestockoutdurationsummarydistrict.subdistrict_uuid,
    averagestockoutdurationsummarydistrict.facility_uuid
   FROM averagestockoutdurationsummarydistrict
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    averagestockoutdurationsummaryprovince.arvcount,
    averagestockoutdurationsummaryprovince.tbcount,
    averagestockoutdurationsummaryprovince.vacccount,
    averagestockoutdurationsummaryprovince.location,
    averagestockoutdurationsummaryprovince.province_uuid,
    averagestockoutdurationsummaryprovince.district_uuid,
    averagestockoutdurationsummaryprovince.subdistrict_uuid,
    averagestockoutdurationsummaryprovince.facility_uuid
   FROM averagestockoutdurationsummaryprovince;


--
-- Name: heliumonlycontactnumberblacklist; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlycontactnumberblacklist (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    contactnum text,
    blacklist_reason text,
    blacklist_service_provider text,
    deleted text,
    date_created timestamp without time zone
);


--
-- Name: heliumonlyfacilitystatus; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyfacilitystatus (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    code text,
    mobile text,
    longitude numeric,
    latitude numeric,
    date_created timestamp without time zone,
    icon text,
    description text,
    province_fk uuid,
    district_fk uuid,
    subdistrict_fk uuid,
    facility_fk uuid
);


--
-- Name: heliumonlyfacilitywithstockoutitem; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyfacilitywithstockoutitem (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    currentperoidcount text,
    previousperoidcount text,
    status text,
    location text,
    heliumonlyfacilitywithstockoutitem_province_fk uuid,
    heliumonlyfacilitywithstockoutitem_district_fk uuid,
    heliumonlyfacilitywithstockoutitem_subdistrict_fk uuid,
    heliumonlyfacilitywithstockoutitem_facility_fk uuid
);


--
-- Name: heliumonlyhierarchystocklevel; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyhierarchystocklevel (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    itemname text,
    inventorycode text,
    total_stocks integer,
    hierarchy_name text,
    hierarchystocklevel_province_fk uuid,
    hierarchystocklevel_district_fk uuid,
    hierarchystocklevel_subdistrict_fk uuid,
    hierarchystocklevel_facility_fk uuid,
    hierarchystocklevel_stock_fk uuid,
    hierarchystocklevel_vendor_fk uuid,
    dayssincelastupdate integer,
    lastupdate_date timestamp without time zone
);


--
-- Name: heliumonlyhierarchystocklevel_aggregation_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyhierarchystocklevel_aggregation_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: materializednationalstockupdates_levels_tableau_view_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.materializednationalstockupdates_levels_tableau_view_actual AS
 WITH facilityhierarchy AS (
         SELECT p._id_ AS _provinceid,
            p.name AS provincename,
            d._id_ AS _districtid,
            d.name AS districtname,
            sd._id_ AS _subdistrictid,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname,
            f._id_,
            f._tstamp_,
            f.name,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
            f.deleted,
            f.mustexit,
            f.date_created,
            f.enrollmentallowedaccess,
            f.enrollmentenrolled,
            f.enrollmentjourneylauncherversion,
            f.enrollmentdeviceos,
            f.enrollmentdevicemodel,
            f.enrollmentlastconnected,
            f.enrollmentbarcode,
            f.enrollmenturl,
            f.enrollmentreenrollment,
            f.enrollmentlastprocessed,
            f.enrollmentbarcodezr,
            f.enrollmentsms,
            f.enrollmentnotification,
            f.defaultpasswordupdated,
            f.appversion,
            f.upgradeddate
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          WHERE ((f.deleted = 'No'::text) AND ((lower(p.name) ~~ lower('%@provincename%'::text)) OR ("left"('@provincename'::text, 1) = '@'::text)) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_source AS (
         SELECT q."row",
            q._tstamp_,
            q.update_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.itemname,
            q.abbreviation,
            q.stockcategory,
            q.inventorycode,
            q.stocklevel,
            q.stockreceived,
            q.stocklost,
            q.stockout_status,
            q.stockout_reason,
            q.stockout_alternative,
            q.stockout_ordered,
            q.ven,
            q.current_stock_out,
            q.stockout_alternative_code,
            q.stock_type_new,
            q.first_stockout_date,
            q._stockid,
            q._provinceid,
            q._districtid,
            q._subdistrictid,
            q._facilityid,
            q.gps_longitude,
            q.gps_latitude,
            COALESCE(((date_part('epoch'::text, age(((now())::date)::timestamp with time zone, (((q._tstamp_)::timestamp with time zone)::date)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer, NULL::integer) AS days_since_last_update_tstamp_
           FROM ( SELECT row_number() OVER (PARTITION BY fh._facilityid, fs.facilitystock_stock_fk ORDER BY su._tstamp_ DESC) AS "row",
                    su._tstamp_,
                    (su.update_date + '02:00:00'::interval) AS update_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    s.itemname,
                    s.abbreviation,
                    sg_category.value AS stockcategory,
                    s.inventorycode,
                    su.current_level AS stocklevel,
                    su.stock_received AS stockreceived,
                    su.stock_lost AS stocklost,
                    sg_stockout_status.value AS stockout_status,
                    sg_stockout_reason.value AS stockout_reason,
                    sg_stockout_alternative.value AS stockout_alternative,
                    sg_stockout_ordered.value AS stockout_ordered,
                    s.ven_status AS ven,
                        CASE
                            WHEN (su.current_level = '0'::text) THEN 1
                            ELSE 0
                        END AS current_stock_out,
                        CASE
                            WHEN ((su.current_level = '0'::text) AND ("left"(COALESCE(sg_stockout_alternative.value, 'N'::text), 1) = 'Y'::text)) THEN 1
                            ELSE 0
                        END AS stockout_alternative_code,
                        CASE
                            WHEN (upper(sg_category.value) = ANY (ARRAY['ARV'::text, 'TB'::text, 'VACC'::text])) THEN upper(sg_category.value)
                            ELSE 'TRACER'::text
                        END AS stock_type_new,
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN (su.first_stockout_date + '02:00:00'::interval)
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                    s._id_ AS _stockid,
                    fh._provinceid,
                    fh._districtid,
                    fh._subdistrictid,
                    fh._facilityid,
                    fh.gps_longitude,
                    fh.gps_latitude
                   FROM ((((((((facilityhierarchy fh
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.deleted = 'No'::text))))
                     LEFT JOIN zambia__svs_001.stock s ON ((fs.facilitystock_stock_fk = s._id_)))
                     LEFT JOIN zambia__svs_001.stockupdate su ON (((su.stockupdate_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk))))
                     LEFT JOIN zambia__svs_001.stringgroup sg_category ON ((s.stock_stringgroup_fk = sg_category._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_status ON ((su.stockupdate_stockout_status_fk = sg_stockout_status._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_reason ON ((su.stockupdate_stockout_reason_fk = sg_stockout_reason._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_alternative ON ((su.stockupdate_stockout_alternative_fk = sg_stockout_alternative._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_ordered ON ((su.stockupdate_stockout_ordered_fk = sg_stockout_ordered._id_)))) q
          WHERE (q."row" = 1)
        ), qnationalstockupdates_new AS (
         SELECT qs."row",
            qs._tstamp_,
            qs.update_date,
            qs.provincename,
            qs.districtname,
            qs.subdistrictname,
            qs.facilityname,
            qs.itemname,
            qs.abbreviation,
            qs.stockcategory,
            qs.inventorycode,
            qs.stocklevel,
            qs.stockreceived,
            qs.stocklost,
            qs.stockout_status,
            qs.stockout_reason,
            qs.stockout_alternative,
            qs.stockout_ordered,
            qs.ven,
            qs.current_stock_out,
            qs.stockout_alternative_code,
            qs.stock_type_new,
            qs.first_stockout_date,
            qs._stockid,
            qs._provinceid,
            qs._districtid,
            qs._subdistrictid,
            qs._facilityid,
            qs.gps_longitude,
            qs.gps_latitude,
            qs.days_since_last_update_tstamp_,
                CASE qs.stock_type_new
                    WHEN 'ARV'::text THEN 1
                    ELSE 0
                END AS arv_items_linked,
                CASE qs.stock_type_new
                    WHEN 'TB'::text THEN 1
                    ELSE 0
                END AS tb_items_linked,
                CASE qs.stock_type_new
                    WHEN 'VACC'::text THEN 1
                    ELSE 0
                END AS vacc_items_linked,
                CASE qs.stock_type_new
                    WHEN 'TRACER'::text THEN 1
                    ELSE 0
                END AS tracer_items_linked,
                CASE qs.stock_type_new
                    WHEN 'ARV'::text THEN qs.days_since_last_update_tstamp_
                    ELSE NULL::integer
                END AS arv_days_since_last_update_tstamp_,
                CASE qs.stock_type_new
                    WHEN 'TB'::text THEN qs.days_since_last_update_tstamp_
                    ELSE NULL::integer
                END AS tb_days_since_last_update_tstamp_,
                CASE qs.stock_type_new
                    WHEN 'VACC'::text THEN qs.days_since_last_update_tstamp_
                    ELSE NULL::integer
                END AS vacc_days_since_last_update_tstamp_,
                CASE qs.stock_type_new
                    WHEN 'TRACER'::text THEN qs.days_since_last_update_tstamp_
                    ELSE NULL::integer
                END AS tracer_days_since_last_update_tstamp_,
                CASE
                    WHEN (qs.days_since_last_update_tstamp_ < 14) THEN 1
                    ELSE 0
                END AS purpleindicatorbyline
           FROM qnationalstockupdates_source qs
        ), qhierarchysummaryfacility AS (
         SELECT q._provinceid,
            q._districtid,
            q._subdistrictid,
            q._facilityid,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.facility_min_days_since_last_update_tstamp_,
            q.purpleindicator,
            q.reported_stocks,
            q.all_stocks,
            q.arv_items_linked,
            q.tb_items_linked,
            q.vacc_items_linked,
            q.tracer_items_linked,
            q.arv_days_since_last_update_tstamp_,
            q.tb_days_since_last_update_tstamp_,
            q.vacc_days_since_last_update_tstamp_,
            q.tracer_days_since_last_update_tstamp_,
            q.arv_reporting,
            q.tb_reporting,
            q.vacc_reporting,
            q.tracer_reporting,
                CASE
                    WHEN ((((q.arv_reporting * q.tb_reporting) * q.vacc_reporting) * q.tracer_reporting) = 1) THEN 1
                    ELSE 0
                END AS reporting_kpi,
            round((((q.reported_stocks)::numeric / (q.all_stocks)::numeric) * (100)::numeric), 2) AS completeness_percentage,
                CASE
                    WHEN (((q.reported_stocks)::numeric / (q.all_stocks)::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS completeness_kpi
           FROM ( SELECT qn._provinceid,
                    qn._districtid,
                    qn._subdistrictid,
                    qn._facilityid,
                    qn.provincename,
                    qn.districtname,
                    qn.subdistrictname,
                    qn.facilityname,
                    min(qn.days_since_last_update_tstamp_) AS facility_min_days_since_last_update_tstamp_,
                        CASE
                            WHEN (min(qn.days_since_last_update_tstamp_) < 15) THEN 1
                            ELSE 0
                        END AS purpleindicator,
                    sum(
                        CASE
                            WHEN (COALESCE(qn.days_since_last_update_tstamp_, 99) < 8) THEN 1
                            ELSE 0
                        END) AS reported_stocks,
                    count(*) AS all_stocks,
                    sum(qn.arv_items_linked) AS arv_items_linked,
                    sum(qn.tb_items_linked) AS tb_items_linked,
                    sum(qn.vacc_items_linked) AS vacc_items_linked,
                    sum(qn.tracer_items_linked) AS tracer_items_linked,
                    min(qn.arv_days_since_last_update_tstamp_) AS arv_days_since_last_update_tstamp_,
                    min(qn.tb_days_since_last_update_tstamp_) AS tb_days_since_last_update_tstamp_,
                    min(qn.vacc_days_since_last_update_tstamp_) AS vacc_days_since_last_update_tstamp_,
                    min(qn.tracer_days_since_last_update_tstamp_) AS tracer_days_since_last_update_tstamp_,
                        CASE
                            WHEN ((COALESCE(min(qn.arv_days_since_last_update_tstamp_), 99) < 8) OR (sum(qn.arv_items_linked) = 0)) THEN 1
                            ELSE 0
                        END AS arv_reporting,
                        CASE
                            WHEN ((COALESCE(min(qn.tb_days_since_last_update_tstamp_), 99) < 8) OR (sum(qn.tb_items_linked) = 0)) THEN 1
                            ELSE 0
                        END AS tb_reporting,
                        CASE
                            WHEN ((COALESCE(min(qn.vacc_days_since_last_update_tstamp_), 99) < 8) OR (sum(qn.vacc_items_linked) = 0)) THEN 1
                            ELSE 0
                        END AS vacc_reporting,
                        CASE
                            WHEN ((COALESCE(min(qn.tracer_days_since_last_update_tstamp_), 99) < 8) OR (sum(qn.tracer_items_linked) = 0)) THEN 1
                            ELSE 0
                        END AS tracer_reporting
                   FROM qnationalstockupdates_new qn
                  GROUP BY qn._provinceid, qn._districtid, qn._subdistrictid, qn._facilityid, qn.provincename, qn.districtname, qn.subdistrictname, qn.facilityname) q
        ), qhierarchysummarysubdistrict AS (
         SELECT qhierarchysummaryfacility._subdistrictid,
            qhierarchysummaryfacility.subdistrictname,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.purpleindicator))::numeric / (count(qhierarchysummaryfacility.purpleindicator))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS subdistrict_purpleindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.reporting_kpi))::numeric / (count(qhierarchysummaryfacility.reporting_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS subdistrict_reportingindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.completeness_kpi))::numeric / (count(qhierarchysummaryfacility.completeness_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS subdistrict_completenessindicator
           FROM qhierarchysummaryfacility
          GROUP BY qhierarchysummaryfacility._subdistrictid, qhierarchysummaryfacility.subdistrictname
        ), qhierarchysummarydistrict AS (
         SELECT qhierarchysummaryfacility._districtid,
            qhierarchysummaryfacility.districtname,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.purpleindicator))::numeric / (count(qhierarchysummaryfacility.purpleindicator))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS district_purpleindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.reporting_kpi))::numeric / (count(qhierarchysummaryfacility.reporting_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS district_reportingindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.completeness_kpi))::numeric / (count(qhierarchysummaryfacility.completeness_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS district_completenessindicator
           FROM qhierarchysummaryfacility
          GROUP BY qhierarchysummaryfacility._districtid, qhierarchysummaryfacility.districtname
        ), qhierarchysummaryprovince AS (
         SELECT qhierarchysummaryfacility._provinceid,
            qhierarchysummaryfacility.provincename,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.purpleindicator))::numeric / (count(qhierarchysummaryfacility.purpleindicator))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS province_purpleindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.reporting_kpi))::numeric / (count(qhierarchysummaryfacility.reporting_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS province_reportingindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.completeness_kpi))::numeric / (count(qhierarchysummaryfacility.completeness_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS province_completenessindicator
           FROM qhierarchysummaryfacility
          GROUP BY qhierarchysummaryfacility._provinceid, qhierarchysummaryfacility.provincename
        ), qnationalstockupdates_levels_tableau AS (
         SELECT qn."row",
            qn._tstamp_,
            qn.update_date,
            qn.provincename,
            qn.districtname,
            qn.subdistrictname,
            qn.facilityname,
            qn.itemname,
            qn.abbreviation,
            qn.stockcategory,
            qn.inventorycode,
            qn.stocklevel,
            qn.stockreceived,
            qn.stocklost,
            qn.stockout_status,
            qn.stockout_reason,
            qn.stockout_alternative,
            qn.stockout_ordered,
            qn.ven,
            qn.current_stock_out,
            qn.stockout_alternative_code,
            qn.stock_type_new,
            qn.first_stockout_date,
            qn._stockid,
            qn._provinceid,
            qn._districtid,
            qn._subdistrictid,
            qn._facilityid,
            qn.gps_longitude,
            qn.gps_latitude,
            qn.days_since_last_update_tstamp_,
            qn.arv_items_linked,
            qn.tb_items_linked,
            qn.vacc_items_linked,
            qn.tracer_items_linked,
            qn.arv_days_since_last_update_tstamp_,
            qn.tb_days_since_last_update_tstamp_,
            qn.vacc_days_since_last_update_tstamp_,
            qn.tracer_days_since_last_update_tstamp_,
            qn.purpleindicatorbyline,
            '|f|'::text AS facility,
            qhf.purpleindicator,
            qhf.arv_reporting,
            qhf.tb_reporting,
            qhf.vacc_reporting,
            qhf.tracer_reporting,
            qhf.reported_stocks,
            qhf.all_stocks,
            qhf.completeness_percentage,
            qhf.reporting_kpi,
            qhf.completeness_kpi,
            '|sd|'::text AS subdistrict,
            qhsd.subdistrict_purpleindicator,
            qhsd.subdistrict_reportingindicator,
            qhsd.subdistrict_completenessindicator,
            '|d|'::text AS district,
            qhd.district_purpleindicator,
            qhd.district_reportingindicator,
            qhd.district_completenessindicator,
            '|p|'::text AS province,
            qhp.province_purpleindicator,
            qhp.province_reportingindicator,
            qhp.province_completenessindicator
           FROM ((((qnationalstockupdates_new qn
             JOIN qhierarchysummaryfacility qhf ON ((qn._facilityid = qhf._facilityid)))
             JOIN qhierarchysummarysubdistrict qhsd ON ((qn._subdistrictid = qhsd._subdistrictid)))
             JOIN qhierarchysummarydistrict qhd ON ((qn._districtid = qhd._districtid)))
             JOIN qhierarchysummaryprovince qhp ON ((qn._provinceid = qhp._provinceid)))
        ), qfinalselect AS (
         SELECT qlt."row",
            (qlt._tstamp_ - '02:00:00'::interval hour) AS _tstamp_,
            qlt.update_date,
            qlt.provincename,
            qlt.districtname,
            qlt.subdistrictname,
            qlt.facilityname,
            qlt.itemname,
            qlt.abbreviation,
            qlt.stockcategory,
            qlt.inventorycode,
            qlt.stocklevel,
            qlt.stockreceived,
            qlt.stocklost,
            qlt.stockout_status,
            qlt.stockout_reason,
            qlt.stockout_alternative,
            qlt.stockout_ordered,
            qlt.ven,
            qlt.current_stock_out,
            qlt.stockout_alternative_code,
            qlt.stock_type_new,
            qlt.first_stockout_date,
            qlt._stockid,
            qlt._provinceid,
            qlt._districtid,
            qlt._subdistrictid,
            qlt._facilityid,
            qlt.gps_longitude,
            qlt.gps_latitude,
            qlt.days_since_last_update_tstamp_,
            qlt.arv_items_linked,
            qlt.tb_items_linked,
            qlt.vacc_items_linked,
            qlt.tracer_items_linked,
            qlt.arv_days_since_last_update_tstamp_,
            qlt.tb_days_since_last_update_tstamp_,
            qlt.vacc_days_since_last_update_tstamp_,
            qlt.tracer_days_since_last_update_tstamp_,
            qlt.purpleindicatorbyline,
            qlt.facility,
            qlt.purpleindicator,
            qlt.arv_reporting,
            qlt.tb_reporting,
            qlt.vacc_reporting,
            qlt.tracer_reporting,
            qlt.reported_stocks,
            qlt.all_stocks,
            qlt.completeness_percentage,
            qlt.reporting_kpi,
            qlt.completeness_kpi,
            qlt.subdistrict,
            qlt.subdistrict_purpleindicator,
            qlt.subdistrict_reportingindicator,
            qlt.subdistrict_completenessindicator,
            qlt.district,
            qlt.district_purpleindicator,
            qlt.district_reportingindicator,
            qlt.district_completenessindicator,
            qlt.province,
            qlt.province_purpleindicator,
            qlt.province_reportingindicator,
            qlt.province_completenessindicator
           FROM qnationalstockupdates_levels_tableau qlt
          ORDER BY qlt.provincename, qlt.districtname, qlt.subdistrictname, qlt.facilityname, qlt.itemname
        )
 SELECT public.uuid_generate_v4() AS _id_,
    (qfinalselect."row")::integer AS "row",
    qfinalselect._tstamp_,
    qfinalselect.update_date,
    qfinalselect.provincename,
    qfinalselect.districtname,
    qfinalselect.subdistrictname,
    qfinalselect.facilityname,
    qfinalselect.itemname,
    qfinalselect.abbreviation,
    qfinalselect.stockcategory,
    qfinalselect.inventorycode,
    qfinalselect.stocklevel,
    qfinalselect.stockreceived,
    qfinalselect.stocklost,
    qfinalselect.stockout_status,
    qfinalselect.stockout_reason,
    qfinalselect.stockout_alternative,
    qfinalselect.stockout_ordered,
    qfinalselect.ven,
    qfinalselect.current_stock_out,
    qfinalselect.stockout_alternative_code,
    qfinalselect.stock_type_new,
    qfinalselect.first_stockout_date,
    qfinalselect._tstamp_ AS tstamp,
    qfinalselect._stockid,
    qfinalselect._provinceid,
    qfinalselect._districtid,
    qfinalselect._subdistrictid,
    qfinalselect._facilityid,
    qfinalselect.gps_longitude,
    qfinalselect.gps_latitude,
    qfinalselect.days_since_last_update_tstamp_,
    qfinalselect.arv_items_linked,
    qfinalselect.tb_items_linked,
    qfinalselect.vacc_items_linked,
    qfinalselect.tracer_items_linked,
    qfinalselect.arv_days_since_last_update_tstamp_,
    qfinalselect.tb_days_since_last_update_tstamp_,
    qfinalselect.vacc_days_since_last_update_tstamp_,
    qfinalselect.tracer_days_since_last_update_tstamp_,
    qfinalselect.purpleindicatorbyline,
    qfinalselect.facility,
    qfinalselect.purpleindicator,
    qfinalselect.arv_reporting,
    qfinalselect.tb_reporting,
    qfinalselect.vacc_reporting,
    qfinalselect.tracer_reporting,
    (qfinalselect.reported_stocks)::integer AS reported_stocks,
    (qfinalselect.all_stocks)::integer AS all_stocks,
    qfinalselect.completeness_percentage,
    qfinalselect.reporting_kpi,
    qfinalselect.completeness_kpi,
    qfinalselect.subdistrict,
    qfinalselect.subdistrict_purpleindicator,
    qfinalselect.subdistrict_reportingindicator,
    qfinalselect.subdistrict_completenessindicator,
    qfinalselect.district,
    qfinalselect.district_purpleindicator,
    qfinalselect.district_reportingindicator,
    qfinalselect.district_completenessindicator,
    qfinalselect.province,
    qfinalselect.province_purpleindicator,
    qfinalselect.province_reportingindicator,
    qfinalselect.province_completenessindicator
   FROM qfinalselect;


--
-- Name: materializednationalstockupdates_levels_tableau_view; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.materializednationalstockupdates_levels_tableau_view AS
 SELECT materializednationalstockupdates_levels_tableau_view_actual._id_,
    materializednationalstockupdates_levels_tableau_view_actual."row",
    materializednationalstockupdates_levels_tableau_view_actual._tstamp_,
    materializednationalstockupdates_levels_tableau_view_actual.update_date,
    materializednationalstockupdates_levels_tableau_view_actual.provincename,
    materializednationalstockupdates_levels_tableau_view_actual.districtname,
    materializednationalstockupdates_levels_tableau_view_actual.subdistrictname,
    materializednationalstockupdates_levels_tableau_view_actual.facilityname,
    materializednationalstockupdates_levels_tableau_view_actual.itemname,
    materializednationalstockupdates_levels_tableau_view_actual.abbreviation,
    materializednationalstockupdates_levels_tableau_view_actual.stockcategory,
    materializednationalstockupdates_levels_tableau_view_actual.inventorycode,
    materializednationalstockupdates_levels_tableau_view_actual.stocklevel,
    materializednationalstockupdates_levels_tableau_view_actual.stockreceived,
    materializednationalstockupdates_levels_tableau_view_actual.stocklost,
    materializednationalstockupdates_levels_tableau_view_actual.stockout_status,
    materializednationalstockupdates_levels_tableau_view_actual.stockout_reason,
    materializednationalstockupdates_levels_tableau_view_actual.stockout_alternative,
    materializednationalstockupdates_levels_tableau_view_actual.stockout_ordered,
    materializednationalstockupdates_levels_tableau_view_actual.ven,
    materializednationalstockupdates_levels_tableau_view_actual.current_stock_out,
    materializednationalstockupdates_levels_tableau_view_actual.stockout_alternative_code,
    materializednationalstockupdates_levels_tableau_view_actual.stock_type_new,
    materializednationalstockupdates_levels_tableau_view_actual.first_stockout_date,
    materializednationalstockupdates_levels_tableau_view_actual.tstamp,
    materializednationalstockupdates_levels_tableau_view_actual._stockid,
    materializednationalstockupdates_levels_tableau_view_actual._provinceid,
    materializednationalstockupdates_levels_tableau_view_actual._districtid,
    materializednationalstockupdates_levels_tableau_view_actual._subdistrictid,
    materializednationalstockupdates_levels_tableau_view_actual._facilityid,
    materializednationalstockupdates_levels_tableau_view_actual.gps_longitude,
    materializednationalstockupdates_levels_tableau_view_actual.gps_latitude,
    materializednationalstockupdates_levels_tableau_view_actual.days_since_last_update_tstamp_,
    materializednationalstockupdates_levels_tableau_view_actual.arv_items_linked,
    materializednationalstockupdates_levels_tableau_view_actual.tb_items_linked,
    materializednationalstockupdates_levels_tableau_view_actual.vacc_items_linked,
    materializednationalstockupdates_levels_tableau_view_actual.tracer_items_linked,
    materializednationalstockupdates_levels_tableau_view_actual.arv_days_since_last_update_tstamp_,
    materializednationalstockupdates_levels_tableau_view_actual.tb_days_since_last_update_tstamp_,
    materializednationalstockupdates_levels_tableau_view_actual.vacc_days_since_last_update_tstamp_,
    materializednationalstockupdates_levels_tableau_view_actual.tracer_days_since_last_update_tstamp_,
    materializednationalstockupdates_levels_tableau_view_actual.purpleindicatorbyline,
    materializednationalstockupdates_levels_tableau_view_actual.facility,
    materializednationalstockupdates_levels_tableau_view_actual.purpleindicator,
    materializednationalstockupdates_levels_tableau_view_actual.arv_reporting,
    materializednationalstockupdates_levels_tableau_view_actual.tb_reporting,
    materializednationalstockupdates_levels_tableau_view_actual.vacc_reporting,
    materializednationalstockupdates_levels_tableau_view_actual.tracer_reporting,
    materializednationalstockupdates_levels_tableau_view_actual.reported_stocks,
    materializednationalstockupdates_levels_tableau_view_actual.all_stocks,
    materializednationalstockupdates_levels_tableau_view_actual.completeness_percentage,
    materializednationalstockupdates_levels_tableau_view_actual.reporting_kpi,
    materializednationalstockupdates_levels_tableau_view_actual.completeness_kpi,
    materializednationalstockupdates_levels_tableau_view_actual.subdistrict,
    materializednationalstockupdates_levels_tableau_view_actual.subdistrict_purpleindicator,
    materializednationalstockupdates_levels_tableau_view_actual.subdistrict_reportingindicator,
    materializednationalstockupdates_levels_tableau_view_actual.subdistrict_completenessindicator,
    materializednationalstockupdates_levels_tableau_view_actual.district,
    materializednationalstockupdates_levels_tableau_view_actual.district_purpleindicator,
    materializednationalstockupdates_levels_tableau_view_actual.district_reportingindicator,
    materializednationalstockupdates_levels_tableau_view_actual.district_completenessindicator,
    materializednationalstockupdates_levels_tableau_view_actual.province,
    materializednationalstockupdates_levels_tableau_view_actual.province_purpleindicator,
    materializednationalstockupdates_levels_tableau_view_actual.province_reportingindicator,
    materializednationalstockupdates_levels_tableau_view_actual.province_completenessindicator
   FROM zambia__svs_001.materializednationalstockupdates_levels_tableau_view_actual
  WITH NO DATA;


--
-- Name: heliumonlyhierarchystocklevel_aggregation_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlyhierarchystocklevel_aggregation_logic_view AS
 WITH facilityquery AS (
         SELECT tbl.itemname,
            tbl.inventorycode,
            (tbl.stocklevel)::integer AS total_stocks,
            tbl.days_since_last_update_tstamp_ AS dayssincelastupdate,
            tbl.update_date AS lastupdate_date,
            NULL::uuid AS province_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            tbl._facilityid AS facility_uuid,
            tbl.facilityname AS hierarchy_name,
            tbl._stockid AS stock_uuid,
            NULL::uuid AS vendor_uuid
           FROM zambia__svs_001.materializednationalstockupdates_levels_tableau_view tbl
          WHERE (tbl.stocklevel IS NOT NULL)
        ), subdistrictquery AS (
         SELECT facilityquery.stock_uuid,
            facilityquery.itemname,
            facilityquery.inventorycode,
            sum(facilityquery.total_stocks) AS total_stocks,
            min(facilityquery.dayssincelastupdate) AS dayssincelastupdate,
            max(facilityquery.lastupdate_date) AS lastupdate_date,
            NULL::uuid AS province_uuid,
            NULL::uuid AS district_uuid,
            sd._id_ AS subdistrict_uuid,
            NULL::uuid AS facility_uuid,
            sd.name AS hierarchy_name,
            facilityquery.vendor_uuid
           FROM ((facilityquery
             JOIN zambia__svs_001.facility f ON ((f._id_ = facilityquery.facility_uuid)))
             JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
          GROUP BY facilityquery.inventorycode, facilityquery.itemname, sd.name, facilityquery.vendor_uuid, sd._id_, facilityquery.stock_uuid
          ORDER BY sd.name, facilityquery.itemname, facilityquery.inventorycode
        ), districtquery AS (
         SELECT DISTINCT subdistrictquery.stock_uuid,
            subdistrictquery.itemname,
            subdistrictquery.inventorycode,
            sum(subdistrictquery.total_stocks) AS total_stocks,
            min(subdistrictquery.dayssincelastupdate) AS dayssincelastupdate,
            max(subdistrictquery.lastupdate_date) AS lastupdate_date,
            NULL::uuid AS province_uuid,
            d._id_ AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            NULL::uuid AS facility_uuid,
            d.name AS hierarchy_name,
            subdistrictquery.vendor_uuid
           FROM ((subdistrictquery
             JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = subdistrictquery.subdistrict_uuid)))
             JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
          GROUP BY subdistrictquery.stock_uuid, subdistrictquery.itemname, subdistrictquery.inventorycode, subdistrictquery.vendor_uuid, d._id_, d.name
          ORDER BY d.name, subdistrictquery.itemname, subdistrictquery.inventorycode
        ), provincequery AS (
         SELECT DISTINCT districtquery.stock_uuid,
            districtquery.itemname,
            districtquery.inventorycode,
            sum(districtquery.total_stocks) AS total_stocks,
            min(districtquery.dayssincelastupdate) AS dayssincelastupdate,
            max(districtquery.lastupdate_date) AS lastupdate_date,
            p._id_ AS province_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS subdistrict_uuid,
            NULL::uuid AS facility_uuid,
            p.name AS hierarchy_name,
            districtquery.vendor_uuid
           FROM ((districtquery
             JOIN zambia__svs_001.district d ON ((d._id_ = districtquery.district_uuid)))
             JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          GROUP BY districtquery.stock_uuid, districtquery.itemname, districtquery.inventorycode, p._id_, districtquery.vendor_uuid, p.name
          ORDER BY p.name, districtquery.itemname, districtquery.inventorycode
        )
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    facilityquery.itemname,
    facilityquery.inventorycode,
    facilityquery.total_stocks,
    facilityquery.dayssincelastupdate,
    facilityquery.lastupdate_date,
    facilityquery.province_uuid,
    facilityquery.district_uuid,
    facilityquery.subdistrict_uuid,
    facilityquery.facility_uuid,
    facilityquery.hierarchy_name,
    facilityquery.stock_uuid,
    facilityquery.vendor_uuid
   FROM facilityquery
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    subdistrictquery.itemname,
    subdistrictquery.inventorycode,
    subdistrictquery.total_stocks,
    subdistrictquery.dayssincelastupdate,
    subdistrictquery.lastupdate_date,
    subdistrictquery.province_uuid,
    subdistrictquery.district_uuid,
    subdistrictquery.subdistrict_uuid,
    subdistrictquery.facility_uuid,
    subdistrictquery.hierarchy_name,
    subdistrictquery.stock_uuid,
    subdistrictquery.vendor_uuid
   FROM subdistrictquery
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    districtquery.itemname,
    districtquery.inventorycode,
    districtquery.total_stocks,
    districtquery.dayssincelastupdate,
    districtquery.lastupdate_date,
    districtquery.province_uuid,
    districtquery.district_uuid,
    districtquery.subdistrict_uuid,
    districtquery.facility_uuid,
    districtquery.hierarchy_name,
    districtquery.stock_uuid,
    districtquery.vendor_uuid
   FROM districtquery
UNION
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    provincequery.itemname,
    provincequery.inventorycode,
    provincequery.total_stocks,
    provincequery.dayssincelastupdate,
    provincequery.lastupdate_date,
    provincequery.province_uuid,
    provincequery.district_uuid,
    provincequery.subdistrict_uuid,
    provincequery.facility_uuid,
    provincequery.hierarchy_name,
    provincequery.stock_uuid,
    provincequery.vendor_uuid
   FROM provincequery;


--
-- Name: heliumonlylowandoverstockreport; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlylowandoverstockreport (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    stockitem text,
    inventory_code text,
    abbreviasion text,
    supplier text,
    category text,
    stock_level integer,
    min integer,
    max integer,
    stock_status text,
    facility_name text,
    subdistrict_name text,
    district_name text,
    province_name text,
    type text,
    stock_fk uuid,
    facility_fk uuid,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid
);


--
-- Name: heliumonlynationalstockavailability; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlynationalstockavailability (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    stockcategory text,
    itemname text,
    abbreviation text,
    inventorycode text,
    barcode text,
    expiry_date timestamp without time zone,
    last_updatedate_timestamp timestamp without time zone,
    first_stockout_date timestamp without time zone,
    last_stock_update_datetime timestamp without time zone,
    stockout_reported_to_pdm timestamp without time zone,
    stock_level integer,
    stock_received integer,
    stock_lost integer,
    current_stock_out integer,
    days_since_first_stockout integer,
    days_since_last_update_timestamp integer,
    days_since_stockout_reported_to_pdm_timestamp integer,
    location text,
    heliumonlynationalstockavailability_vendor_fk uuid,
    heliumonlynationalstockavailability_stock_fk uuid,
    heliumonlynationalstockavailability_facilitystock_fk uuid,
    heliumonlynationalstockavailability_stockupdate_fk uuid,
    heliumonlynationalstockavailability_facility_fk uuid
);


--
-- Name: heliumonlynationalstockavailability_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlynationalstockavailability_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_heliumonlynationalstockavailability() AS counter;


--
-- Name: heliumonlynationalstockavailability_aggregation_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlynationalstockavailability_aggregation_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p.name AS provincename,
            d.name AS districtname,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
             LEFT JOIN zambia__svs_001.district d ON ((sd.subdistrict_district_fk = d._id_)))
             LEFT JOIN zambia__svs_001.province p ON ((d.district_province_fk = p._id_)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_new AS (
         SELECT q."timestamp",
            q.update_date,
            q.expiry_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.stockcategory,
            q.itemname,
            q.abbreviation,
            q.inventorycode,
            q.barcode,
            q."stock level",
            q."stock received",
            q."stock lost",
            q.first_stockout_date,
            q.stockout_reported_to_pdm,
            q._facilityid,
            q.stock_uuid,
            q.stockupdate_uuid,
            q.facilitystock_uuid,
            ((date_part('epoch'::text, age(now(), COALESCE((q.first_stockout_date)::timestamp with time zone, now()))) / (((60 * 60) * 24))::double precision))::integer AS days_since_first_stockout,
            ((date_part('epoch'::text, age(now(), (q."timestamp")::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp,
            ((date_part('epoch'::text, age(now(), (q.stockout_reported_to_pdm)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_stockout_reported_to_pdm_timestamp,
                CASE
                    WHEN ((COALESCE(q."stock level", '0'::text))::integer <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out
           FROM ( SELECT
                        CASE
                            WHEN (su._tstamp_ >= '2014-10-09'::date) THEN su._tstamp_
                            ELSE (su.update_date + '02:00:00'::interval)
                        END AS "timestamp",
                    (su.update_date + '02:00:00'::interval) AS update_date,
                        CASE
                            WHEN ((COALESCE(su.expiry_date, (now())::date) >= '1900-01-01'::date) AND (COALESCE(su.expiry_date, (now())::date) <= '2100-01-01'::date)) THEN su.expiry_date
                            ELSE NULL::date
                        END AS expiry_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    sg.value AS stockcategory,
                    s.itemname,
                    s.abbreviation,
                    s.inventorycode,
                    s.barcode,
                    su.current_level AS "stock level",
                    su.stock_received AS "stock received",
                    su.stock_lost AS "stock lost",
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.first_stockout_date
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                        CASE
                            WHEN ((COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.stockout_reported_to_pdm
                            ELSE NULL::timestamp without time zone
                        END AS stockout_reported_to_pdm,
                    fh._facilityid,
                    s._id_ AS stock_uuid,
                    su._id_ AS stockupdate_uuid,
                    fs._id_ AS facilitystock_uuid
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN facilityhierarchy fh ON ((su.stockupdate_facility_fk = fh._facilityid)))
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk) AND (fs.deleted = 'No'::text))))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
                  WHERE ((su.stockupdate_facility_fk IS NOT NULL) AND (sg.value = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text])) AND ((s.inventorycode = '@inventorycode'::text) OR ("left"('@inventorycode'::text, 1) = '@'::text)))) q
        ), heliumonlynationalstockavailability AS (
         SELECT asu.provincename,
            asu.districtname,
            asu.subdistrictname,
            asu.facilityname,
            asu.stockcategory,
            asu.itemname,
            asu.abbreviation,
            asu.inventorycode,
            asu.barcode,
            asu.expiry_date,
            asu."timestamp" AS last_updatedate_timestamp,
            asu.update_date AS last_stock_update_datetime,
            asu.first_stockout_date,
            asu.stockout_reported_to_pdm,
            (asu."stock level")::integer AS stock_level,
            (asu."stock received")::integer AS stock_received,
            (asu."stock lost")::integer AS stock_lost,
            asu.current_stock_out,
            asu.days_since_first_stockout,
            asu.days_since_last_update_timestamp,
            asu.days_since_stockout_reported_to_pdm_timestamp,
            asu.facilityname AS location,
            asu.stock_uuid,
            asu.stockupdate_uuid,
            asu.facilitystock_uuid,
            asu._facilityid AS facility_uuid
           FROM (qnationalstockupdates_new asu
             JOIN ( SELECT qnationalstockupdates_new._facilityid,
                    qnationalstockupdates_new.stock_uuid,
                    max(qnationalstockupdates_new."timestamp") AS mxt
                   FROM qnationalstockupdates_new
                  GROUP BY qnationalstockupdates_new._facilityid, qnationalstockupdates_new.stock_uuid) mud ON (((asu._facilityid = mud._facilityid) AND (asu.stock_uuid = mud.stock_uuid) AND (asu."timestamp" = mud.mxt))))
        )
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    heliumonlynationalstockavailability.stockcategory,
    heliumonlynationalstockavailability.itemname,
    heliumonlynationalstockavailability.abbreviation,
    heliumonlynationalstockavailability.inventorycode,
    heliumonlynationalstockavailability.barcode,
    heliumonlynationalstockavailability.expiry_date,
    heliumonlynationalstockavailability.last_updatedate_timestamp,
    heliumonlynationalstockavailability.first_stockout_date,
    heliumonlynationalstockavailability.last_stock_update_datetime,
    heliumonlynationalstockavailability.stockout_reported_to_pdm,
    heliumonlynationalstockavailability.stock_level,
    heliumonlynationalstockavailability.stock_received,
    heliumonlynationalstockavailability.stock_lost,
    heliumonlynationalstockavailability.current_stock_out,
    heliumonlynationalstockavailability.days_since_first_stockout,
    heliumonlynationalstockavailability.days_since_last_update_timestamp,
    heliumonlynationalstockavailability.days_since_stockout_reported_to_pdm_timestamp,
    heliumonlynationalstockavailability.location,
    heliumonlynationalstockavailability.stock_uuid,
    heliumonlynationalstockavailability.stockupdate_uuid,
    heliumonlynationalstockavailability.facilitystock_uuid,
    heliumonlynationalstockavailability.facility_uuid
   FROM heliumonlynationalstockavailability;


--
-- Name: heliumonlynationalstockoutreasons; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlynationalstockoutreasons (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    stockcategory text,
    itemname text,
    inventorycode text,
    barcode text,
    first_stockout_date timestamp without time zone,
    last_stock_out_update_datetime timestamp without time zone,
    stockout_reported_to_pdm timestamp without time zone,
    location text,
    days_since_first_stockout integer,
    days_since_last_update_timestamp integer,
    days_since_stockout_reported_to_pdm_timestamp integer,
    stockoutreasonsstatus text,
    stockoutreasons text,
    availabilityofalternative text,
    heliumonlynationalstockoutreasons_stock_fk uuid,
    heliumonlynationalstockoutreasons_facilitystock_fk uuid,
    heliumonlynationalstockoutreasons_stockupdate_fk uuid,
    heliumonlynationalstockoutreasons_facility_fk uuid
);


--
-- Name: heliumonlynationalstockoutreasons_agg_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlynationalstockoutreasons_agg_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p.name AS provincename,
            d.name AS districtname,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
             LEFT JOIN zambia__svs_001.district d ON ((sd.subdistrict_district_fk = d._id_)))
             LEFT JOIN zambia__svs_001.province p ON ((d.district_province_fk = p._id_)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_new AS (
         SELECT q."timestamp",
            q.update_date,
            q.expiry_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.stockcategory,
            q.itemname,
            q.abbreviation,
            q.inventorycode,
            q.barcode,
            q."stock level",
            q."stock received",
            q."stock lost",
            q.first_stockout_date,
            q.stockout_reported_to_pdm,
            q._facilityid,
            q.stock_uuid,
            q.stockupdate_uuid,
            q.facilitystock_uuid,
            ((date_part('epoch'::text, age(now(), COALESCE((q.first_stockout_date)::timestamp with time zone, now()))) / (((60 * 60) * 24))::double precision))::integer AS days_since_first_stockout,
            ((date_part('epoch'::text, age(now(), (q."timestamp")::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp,
            ((date_part('epoch'::text, age(now(), (q.stockout_reported_to_pdm)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_stockout_reported_to_pdm_timestamp,
                CASE
                    WHEN ((COALESCE(q."stock level", '0'::text))::integer <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out
           FROM ( SELECT
                        CASE
                            WHEN (su._tstamp_ >= '2014-10-09'::date) THEN su._tstamp_
                            ELSE (su.update_date + '02:00:00'::interval)
                        END AS "timestamp",
                    (su.update_date + '02:00:00'::interval) AS update_date,
                        CASE
                            WHEN ((COALESCE(su.expiry_date, (now())::date) >= '1900-01-01'::date) AND (COALESCE(su.expiry_date, (now())::date) <= '2100-01-01'::date)) THEN su.expiry_date
                            ELSE NULL::date
                        END AS expiry_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    sg.value AS stockcategory,
                    s.itemname,
                    s.abbreviation,
                    s.inventorycode,
                    s.barcode,
                    su.current_level AS "stock level",
                    su.stock_received AS "stock received",
                    su.stock_lost AS "stock lost",
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.first_stockout_date
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                        CASE
                            WHEN ((COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.stockout_reported_to_pdm
                            ELSE NULL::timestamp without time zone
                        END AS stockout_reported_to_pdm,
                    fh._facilityid,
                    s._id_ AS stock_uuid,
                    su._id_ AS stockupdate_uuid,
                    fs._id_ AS facilitystock_uuid
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN facilityhierarchy fh ON ((su.stockupdate_facility_fk = fh._facilityid)))
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk) AND (fs.deleted = 'No'::text))))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
                  WHERE ((su.stockupdate_facility_fk IS NOT NULL) AND ((s.inventorycode = '@inventorycode'::text) OR ("left"('@inventorycode'::text, 1) = '@'::text)))) q
        ), qnationalstockoutreasons AS (
         SELECT asu.provincename,
            asu.districtname,
            asu.subdistrictname,
            asu.facilityname,
            asu.stockcategory,
            asu.itemname,
            asu.abbreviation,
            asu.inventorycode,
            asu.barcode,
            asu."timestamp",
            asu.update_date AS last_stock_out_update_datetime,
            asu."stock level",
            asu."stock received",
            asu."stock lost",
            asu.expiry_date,
            asu.first_stockout_date,
            asu.stockout_reported_to_pdm,
            sg_order.value AS stockoutreasonsstatus,
            sg_reason.value AS stockoutreasons,
            sg_alter.value AS availabilityofalternative,
            asu.days_since_first_stockout,
            asu.days_since_last_update_timestamp,
            asu.days_since_stockout_reported_to_pdm_timestamp,
            asu.current_stock_out,
            asu._facilityid,
            asu.stock_uuid,
            asu.stockupdate_uuid,
            asu.facilitystock_uuid
           FROM (((((qnationalstockupdates_new asu
             JOIN ( SELECT qnationalstockupdates_new._facilityid,
                    qnationalstockupdates_new.stock_uuid,
                    max(qnationalstockupdates_new."timestamp") AS mxt
                   FROM qnationalstockupdates_new
                  GROUP BY qnationalstockupdates_new._facilityid, qnationalstockupdates_new.stock_uuid) mud ON (((asu._facilityid = mud._facilityid) AND (asu.stock_uuid = mud.stock_uuid) AND (asu."timestamp" = mud.mxt))))
             JOIN zambia__svs_001.stockupdate su ON ((asu.stockupdate_uuid = su._id_)))
             JOIN zambia__svs_001.stringgroup sg_order ON ((su.stockupdate_stockout_ordered_fk = sg_order._id_)))
             JOIN zambia__svs_001.stringgroup sg_reason ON ((su.stockupdate_stockout_reason_fk = sg_reason._id_)))
             JOIN zambia__svs_001.stringgroup sg_alter ON ((su.stockupdate_stockout_alternative_fk = sg_alter._id_)))
          WHERE (asu."stock level" = '0'::text)
        ), nationalstockoutitemsreasonfacility AS (
         SELECT public.uuid_generate_v4() AS _id_,
            now() AS _tstamp_,
            qnationalstockoutreasons.stockcategory,
            qnationalstockoutreasons.itemname,
            qnationalstockoutreasons.inventorycode,
            qnationalstockoutreasons.barcode,
            qnationalstockoutreasons.first_stockout_date,
            qnationalstockoutreasons.last_stock_out_update_datetime,
            qnationalstockoutreasons.stockout_reported_to_pdm,
            qnationalstockoutreasons.facilityname AS location,
            qnationalstockoutreasons.days_since_first_stockout,
            qnationalstockoutreasons.days_since_last_update_timestamp,
            qnationalstockoutreasons.days_since_stockout_reported_to_pdm_timestamp,
            qnationalstockoutreasons.stockoutreasonsstatus,
            qnationalstockoutreasons.stockoutreasons,
            qnationalstockoutreasons.availabilityofalternative,
            qnationalstockoutreasons._facilityid AS facility_uuid,
            qnationalstockoutreasons.stock_uuid,
            qnationalstockoutreasons.stockupdate_uuid,
            qnationalstockoutreasons.facilitystock_uuid
           FROM qnationalstockoutreasons
          GROUP BY qnationalstockoutreasons.stockcategory, qnationalstockoutreasons.itemname, qnationalstockoutreasons.stockoutreasonsstatus, qnationalstockoutreasons.stockoutreasons, qnationalstockoutreasons.availabilityofalternative, qnationalstockoutreasons.facilityname, qnationalstockoutreasons.inventorycode, qnationalstockoutreasons.barcode, qnationalstockoutreasons.first_stockout_date, qnationalstockoutreasons.last_stock_out_update_datetime, qnationalstockoutreasons.days_since_first_stockout, qnationalstockoutreasons.days_since_last_update_timestamp, qnationalstockoutreasons.days_since_stockout_reported_to_pdm_timestamp, qnationalstockoutreasons.stockout_reported_to_pdm, qnationalstockoutreasons._facilityid, qnationalstockoutreasons.stock_uuid, qnationalstockoutreasons.stockupdate_uuid, qnationalstockoutreasons.facilitystock_uuid
          ORDER BY qnationalstockoutreasons.stockcategory, qnationalstockoutreasons.itemname, qnationalstockoutreasons.stockoutreasonsstatus, qnationalstockoutreasons.stockoutreasons, qnationalstockoutreasons.availabilityofalternative, qnationalstockoutreasons.facilityname, qnationalstockoutreasons.inventorycode, qnationalstockoutreasons.barcode, qnationalstockoutreasons.days_since_first_stockout, qnationalstockoutreasons.last_stock_out_update_datetime, qnationalstockoutreasons.days_since_last_update_timestamp, qnationalstockoutreasons.stockout_reported_to_pdm, qnationalstockoutreasons._facilityid
        )
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    nationalstockoutitemsreasonfacility.stockcategory,
    nationalstockoutitemsreasonfacility.itemname,
    nationalstockoutitemsreasonfacility.inventorycode,
    nationalstockoutitemsreasonfacility.barcode,
    nationalstockoutitemsreasonfacility.first_stockout_date,
    nationalstockoutitemsreasonfacility.last_stock_out_update_datetime,
    nationalstockoutitemsreasonfacility.stockout_reported_to_pdm,
    nationalstockoutitemsreasonfacility.location,
    nationalstockoutitemsreasonfacility.days_since_first_stockout,
    nationalstockoutitemsreasonfacility.days_since_last_update_timestamp,
    nationalstockoutitemsreasonfacility.days_since_stockout_reported_to_pdm_timestamp,
    nationalstockoutitemsreasonfacility.stockoutreasonsstatus,
    nationalstockoutitemsreasonfacility.stockoutreasons,
    nationalstockoutitemsreasonfacility.availabilityofalternative,
    nationalstockoutitemsreasonfacility.facility_uuid,
    nationalstockoutitemsreasonfacility.stock_uuid,
    nationalstockoutitemsreasonfacility.stockupdate_uuid,
    nationalstockoutitemsreasonfacility.facilitystock_uuid
   FROM nationalstockoutitemsreasonfacility;


--
-- Name: heliumonlynationalstockoutreasons_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlynationalstockoutreasons_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.heliumonlynationalstockoutreasons_agg_executor_function() AS counter;


--
-- Name: heliumonlynationalstockoutreasons_aggregation_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlynationalstockoutreasons_aggregation_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p.name AS provincename,
            d.name AS districtname,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
             LEFT JOIN zambia__svs_001.district d ON ((sd.subdistrict_district_fk = d._id_)))
             LEFT JOIN zambia__svs_001.province p ON ((d.district_province_fk = p._id_)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_new AS (
         SELECT q."timestamp",
            q.update_date,
            q.expiry_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.stockcategory,
            q.itemname,
            q.abbreviation,
            q.inventorycode,
            q.barcode,
            q."stock level",
            q."stock received",
            q."stock lost",
            q.first_stockout_date,
            q.stockout_reported_to_pdm,
            q._facilityid,
            q.stock_uuid,
            q.stockupdate_uuid,
            q.facilitystock_uuid,
            ((date_part('epoch'::text, age(now(), COALESCE((q.first_stockout_date)::timestamp with time zone, now()))) / (((60 * 60) * 24))::double precision))::integer AS days_since_first_stockout,
            ((date_part('epoch'::text, age(now(), (q."timestamp")::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp,
            ((date_part('epoch'::text, age(now(), (q.stockout_reported_to_pdm)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_stockout_reported_to_pdm_timestamp,
                CASE
                    WHEN ((COALESCE(q."stock level", '0'::text))::integer <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out
           FROM ( SELECT
                        CASE
                            WHEN (su._tstamp_ >= '2014-10-09'::date) THEN su._tstamp_
                            ELSE (su.update_date + '02:00:00'::interval)
                        END AS "timestamp",
                    (su.update_date + '02:00:00'::interval) AS update_date,
                        CASE
                            WHEN ((COALESCE(su.expiry_date, (now())::date) >= '1900-01-01'::date) AND (COALESCE(su.expiry_date, (now())::date) <= '2100-01-01'::date)) THEN su.expiry_date
                            ELSE NULL::date
                        END AS expiry_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    sg.value AS stockcategory,
                    s.itemname,
                    s.abbreviation,
                    s.inventorycode,
                    s.barcode,
                    su.current_level AS "stock level",
                    su.stock_received AS "stock received",
                    su.stock_lost AS "stock lost",
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.first_stockout_date
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                        CASE
                            WHEN ((COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.stockout_reported_to_pdm
                            ELSE NULL::timestamp without time zone
                        END AS stockout_reported_to_pdm,
                    fh._facilityid,
                    s._id_ AS stock_uuid,
                    su._id_ AS stockupdate_uuid,
                    fs._id_ AS facilitystock_uuid
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN facilityhierarchy fh ON ((su.stockupdate_facility_fk = fh._facilityid)))
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk) AND (fs.deleted = 'No'::text))))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
                  WHERE ((su.stockupdate_facility_fk IS NOT NULL) AND ((s.inventorycode = '@inventorycode'::text) OR ("left"('@inventorycode'::text, 1) = '@'::text)))) q
        ), qnationalstockoutreasons AS (
         SELECT asu.provincename,
            asu.districtname,
            asu.subdistrictname,
            asu.facilityname,
            asu.stockcategory,
            asu.itemname,
            asu.abbreviation,
            asu.inventorycode,
            asu.barcode,
            asu."timestamp",
            asu.update_date AS last_stock_out_update_datetime,
            asu."stock level",
            asu."stock received",
            asu."stock lost",
            asu.expiry_date,
            asu.first_stockout_date,
            asu.stockout_reported_to_pdm,
            sg_order.value AS stockoutreasonsstatus,
            sg_reason.value AS stockoutreasons,
            sg_alter.value AS availabilityofalternative,
            asu.days_since_first_stockout,
            asu.days_since_last_update_timestamp,
            asu.days_since_stockout_reported_to_pdm_timestamp,
            asu.current_stock_out,
            asu._facilityid,
            asu.stock_uuid,
            asu.stockupdate_uuid,
            asu.facilitystock_uuid
           FROM (((((qnationalstockupdates_new asu
             JOIN ( SELECT qnationalstockupdates_new._facilityid,
                    qnationalstockupdates_new.stock_uuid,
                    max(qnationalstockupdates_new."timestamp") AS mxt
                   FROM qnationalstockupdates_new
                  GROUP BY qnationalstockupdates_new._facilityid, qnationalstockupdates_new.stock_uuid) mud ON (((asu._facilityid = mud._facilityid) AND (asu.stock_uuid = mud.stock_uuid) AND (asu."timestamp" = mud.mxt))))
             JOIN zambia__svs_001.stockupdate su ON ((asu.stockupdate_uuid = su._id_)))
             JOIN zambia__svs_001.stringgroup sg_order ON ((su.stockupdate_stockout_ordered_fk = sg_order._id_)))
             JOIN zambia__svs_001.stringgroup sg_reason ON ((su.stockupdate_stockout_reason_fk = sg_reason._id_)))
             JOIN zambia__svs_001.stringgroup sg_alter ON ((su.stockupdate_stockout_alternative_fk = sg_alter._id_)))
          WHERE (asu."stock level" = '0'::text)
        ), nationalstockoutitemsreasonfacility AS (
         SELECT public.uuid_generate_v4() AS _id_,
            now() AS _tstamp_,
            qnationalstockoutreasons.stockcategory,
            qnationalstockoutreasons.itemname,
            qnationalstockoutreasons.inventorycode,
            qnationalstockoutreasons.barcode,
            qnationalstockoutreasons.first_stockout_date,
            qnationalstockoutreasons.last_stock_out_update_datetime,
            qnationalstockoutreasons.stockout_reported_to_pdm,
            qnationalstockoutreasons.facilityname AS location,
            qnationalstockoutreasons.days_since_first_stockout,
            qnationalstockoutreasons.days_since_last_update_timestamp,
            qnationalstockoutreasons.days_since_stockout_reported_to_pdm_timestamp,
            qnationalstockoutreasons.stockoutreasonsstatus,
            qnationalstockoutreasons.stockoutreasons,
            qnationalstockoutreasons.availabilityofalternative,
            qnationalstockoutreasons._facilityid AS facility_uuid,
            qnationalstockoutreasons.stock_uuid,
            qnationalstockoutreasons.stockupdate_uuid,
            qnationalstockoutreasons.facilitystock_uuid
           FROM qnationalstockoutreasons
          GROUP BY qnationalstockoutreasons.stockcategory, qnationalstockoutreasons.itemname, qnationalstockoutreasons.stockoutreasonsstatus, qnationalstockoutreasons.stockoutreasons, qnationalstockoutreasons.availabilityofalternative, qnationalstockoutreasons.facilityname, qnationalstockoutreasons.inventorycode, qnationalstockoutreasons.barcode, qnationalstockoutreasons.first_stockout_date, qnationalstockoutreasons.last_stock_out_update_datetime, qnationalstockoutreasons.days_since_first_stockout, qnationalstockoutreasons.days_since_last_update_timestamp, qnationalstockoutreasons.days_since_stockout_reported_to_pdm_timestamp, qnationalstockoutreasons.stockout_reported_to_pdm, qnationalstockoutreasons._facilityid, qnationalstockoutreasons.stock_uuid, qnationalstockoutreasons.stockupdate_uuid, qnationalstockoutreasons.facilitystock_uuid
          ORDER BY qnationalstockoutreasons.stockcategory, qnationalstockoutreasons.itemname, qnationalstockoutreasons.stockoutreasonsstatus, qnationalstockoutreasons.stockoutreasons, qnationalstockoutreasons.availabilityofalternative, qnationalstockoutreasons.facilityname, qnationalstockoutreasons.inventorycode, qnationalstockoutreasons.barcode, qnationalstockoutreasons.days_since_first_stockout, qnationalstockoutreasons.last_stock_out_update_datetime, qnationalstockoutreasons.days_since_last_update_timestamp, qnationalstockoutreasons.stockout_reported_to_pdm, qnationalstockoutreasons._facilityid
        )
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    nationalstockoutitemsreasonfacility.stockcategory,
    nationalstockoutitemsreasonfacility.itemname,
    nationalstockoutitemsreasonfacility.inventorycode,
    nationalstockoutitemsreasonfacility.barcode,
    nationalstockoutitemsreasonfacility.first_stockout_date,
    nationalstockoutitemsreasonfacility.last_stock_out_update_datetime,
    nationalstockoutitemsreasonfacility.stockout_reported_to_pdm,
    nationalstockoutitemsreasonfacility.location,
    nationalstockoutitemsreasonfacility.days_since_first_stockout,
    nationalstockoutitemsreasonfacility.days_since_last_update_timestamp,
    nationalstockoutitemsreasonfacility.days_since_stockout_reported_to_pdm_timestamp,
    nationalstockoutitemsreasonfacility.stockoutreasonsstatus,
    nationalstockoutitemsreasonfacility.stockoutreasons,
    nationalstockoutitemsreasonfacility.availabilityofalternative,
    nationalstockoutitemsreasonfacility.facility_uuid,
    nationalstockoutitemsreasonfacility.stock_uuid,
    nationalstockoutitemsreasonfacility.stockupdate_uuid,
    nationalstockoutitemsreasonfacility.facilitystock_uuid
   FROM nationalstockoutitemsreasonfacility;


--
-- Name: heliumonlypdm_facilities_with_stockouts; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlypdm_facilities_with_stockouts (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    districtname text,
    facilityname text,
    numberofstockouts integer,
    numberofstockouts_with_alternative integer,
    facilityuuid uuid,
    districtuuid uuid,
    provinceuuid uuid
);


--
-- Name: heliumonlypdm_facilities_with_stockouts_agg_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlypdm_facilities_with_stockouts_agg_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.heliumonlypdm_facilities_with_stockouts_function() AS counter;


--
-- Name: heliumonlypdm_facilities_with_stockouts_agg_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlypdm_facilities_with_stockouts_agg_logic_view AS
 SELECT district.name AS districtname,
    facility.name AS facilityname,
    facilitywithstockout.nostock AS numberofstockouts,
    facilitywithstockout.nostockwithalternative AS numberofstockouts_with_alternative,
    facility._id_ AS facilityuuid,
    district._id_ AS districtuuid,
    district.district_province_fk AS provinceuuid
   FROM ((zambia__svs_001.district
     JOIN zambia__svs_001.facility ON ((district._id_ = facility.facility_district_fk)))
     JOIN ( SELECT stockoutbypriorityorder.stockoutfacilityid,
            sum(
                CASE
                    WHEN (stockoutbypriorityorder.stockoutstatus = ANY (ARRAY[1, 2])) THEN 1
                    ELSE 0
                END) AS nostock,
            sum(
                CASE
                    WHEN (stockoutbypriorityorder.stockoutstatus = 2) THEN 1
                    ELSE 0
                END) AS nostockwithalternative
           FROM ( SELECT stockupdate.stockupdate_facility_fk AS stockoutfacilityid,
                        CASE
                            WHEN (stockupdate.stockupdate_stockout_status_fk IS NULL) THEN 1
                            WHEN (stockupdate.stockupdate_stockout_status_fk IS NOT NULL) THEN stringgroup.value_ident
                            ELSE NULL::integer
                        END AS stockoutstatus
                   FROM ((zambia__svs_001.stockupdate
                     JOIN ( SELECT stockupdate_1.stockupdate_facility_fk AS facility_id,
                            stockupdate_1.stockupdate_stock_fk AS stock_id,
                            max(stockupdate_1.update_date) AS max_update_date
                           FROM (zambia__svs_001.stockupdate stockupdate_1
                             JOIN zambia__svs_001.facilitystock ON ((stockupdate_1.stockupdate_facilitystock_fk = facilitystock._id_)))
                          WHERE ((stockupdate_1.stockupdate_facility_fk IS NOT NULL) AND (facilitystock.deleted = 'No'::text))
                          GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) latest_stockupdate ON (((stockupdate.stockupdate_facility_fk = latest_stockupdate.facility_id) AND (stockupdate.stockupdate_stock_fk = latest_stockupdate.stock_id))))
                     LEFT JOIN zambia__svs_001.stringgroup ON ((stockupdate.stockupdate_stockout_status_fk = stringgroup._id_)))
                  WHERE ((stockupdate.update_date = latest_stockupdate.max_update_date) AND (stockupdate.current_level = '0'::text))
                  ORDER BY stockupdate.stockupdate_facility_fk) stockoutbypriorityorder
          GROUP BY stockoutbypriorityorder.stockoutfacilityid) facilitywithstockout ON ((facility._id_ = facilitywithstockout.stockoutfacilityid)))
  WHERE ((district.district_province_fk IS NOT NULL) AND (facility.deleted = 'No'::text))
  ORDER BY district.name, facility.name;


--
-- Name: heliumonlyqationalstockupdates_levels_tableau_aggr_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.heliumonlyqationalstockupdates_levels_tableau_aggr_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p._id_ AS _provinceid,
            p.name AS provincename,
            d._id_ AS _districtid,
            d.name AS districtname,
            sd._id_ AS _subdistrictid,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname,
            f._id_,
            f._tstamp_,
            f.name,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
            f.deleted,
            f.hasdevice,
            f.flagged_reason,
            f.mustexit,
            f.date_created,
            f.updatedon,
            f.enrollment_allowed_access_x,
            f.enrollment_enrolled_x,
            f.enrollment_journey_launcher_version_x,
            f.enrollment_device_os_x,
            f.enrollment_device_model_x,
            f.enrollment_last_connected_x,
            f.enrollment_barcode_x,
            f.jira,
            f.enrollment_perform_re_enrollment_x,
            f.enrollment_re_enrollment_last_processed_x,
            f.sig_image,
            f.sig_image_blob,
            f.defaultpasswordupdated,
            f.appversion,
            f.upgradeddate,
            f.enrollmentallowedaccess,
            f.enrollmentenrolled,
            f.enrollmentjourneylauncherversion,
            f.enrollmentdeviceos,
            f.enrollmentdevicemodel,
            f.enrollmentlastconnected,
            f.enrollmentbarcode,
            f.enrollmenturl,
            f.enrollmentreenrollment,
            f.enrollmentlastprocessed,
            f.enrollmentbarcodezr,
            f.enrollmentsms,
            f.enrollmentnotification,
            f.sig_image_fname__,
            f.sig_image_mtype__,
            f.sig_image_size__,
            f.sig_image_blob_fname__,
            f.sig_image_blob_mtype__,
            f.sig_image_blob_size__,
            f.facility_district_fk,
            f.facility_subdistrict_fk,
            f._tx_id_,
            f._change_type_,
            f._change_seq_
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_source AS (
         SELECT q."row",
            q._tstamp_,
            q.update_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.itemname,
            q.abbreviation,
            q.stockcategory,
            q.inventorycode,
            q."stock level",
            q."stock received",
            q."stock lost",
            q.stockout_status,
            q.stockout_reason,
            q.stockout_alternative,
            q.stockout_ordered,
            q."VEN",
            q.current_stock_out,
            q.stockout_alternative_code,
            q.stock_type_new,
            q.first_stockout_date,
            q._stockid,
            q._provinceid,
            q._districtid,
            q._subdistrictid,
            q._facilityid,
            q.gps_longitude,
            q.gps_latitude,
            COALESCE(((date_part('epoch'::text, age(now(), (q._tstamp_)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer, NULL::integer) AS days_since_last_update_tstamp_
           FROM ( SELECT row_number() OVER (PARTITION BY su.stockupdate_facility_fk, su.stockupdate_stock_fk ORDER BY su._tstamp_ DESC) AS "row",
                    su._tstamp_,
                    (su.update_date + '02:00:00'::interval) AS update_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    s.itemname,
                    s.abbreviation,
                    sg_category.value AS stockcategory,
                    s.inventorycode,
                    su.current_level AS "stock level",
                    su.stock_received AS "stock received",
                    su.stock_lost AS "stock lost",
                    sg_stockout_status.value AS stockout_status,
                    sg_stockout_reason.value AS stockout_reason,
                    sg_stockout_alternative.value AS stockout_alternative,
                    sg_stockout_ordered.value AS stockout_ordered,
                    s.ven_status AS "VEN",
                        CASE
                            WHEN (su.current_level = '0'::text) THEN 1
                            ELSE 0
                        END AS current_stock_out,
                        CASE
                            WHEN ((su.current_level = '0'::text) AND ("left"(COALESCE(sg_stockout_alternative.value, 'N'::text), 1) = 'Y'::text)) THEN 1
                            ELSE 0
                        END AS stockout_alternative_code,
                        CASE
                            WHEN (upper(sg_category.value) = ANY (ARRAY['ARV'::text, 'TB'::text, 'VACC'::text])) THEN upper(sg_category.value)
                            ELSE 'Tracer'::text
                        END AS stock_type_new,
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN (su.first_stockout_date + '02:00:00'::interval)
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                    s._id_ AS _stockid,
                    fh._provinceid,
                    fh._districtid,
                    fh._subdistrictid,
                    fh._facilityid,
                    fh.gps_longitude,
                    fh.gps_latitude
                   FROM ((((((((facilityhierarchy fh
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.deleted = 'No'::text))))
                     LEFT JOIN zambia__svs_001.stockupdate su ON (((su.stockupdate_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk))))
                     LEFT JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_category ON ((s.stock_stringgroup_fk = sg_category._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_status ON ((su.stockupdate_stockout_status_fk = sg_stockout_status._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_reason ON ((su.stockupdate_stockout_reason_fk = sg_stockout_reason._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_alternative ON ((su.stockupdate_stockout_alternative_fk = sg_stockout_alternative._id_)))
                     LEFT JOIN zambia__svs_001.stringgroup sg_stockout_ordered ON ((su.stockupdate_stockout_ordered_fk = sg_stockout_ordered._id_)))
                  WHERE ((su.stockupdate_facility_fk IS NOT NULL) AND (su.stockupdate_stock_fk IS NOT NULL))) q
          WHERE (q."row" = 1)
        ), qnationalstockupdates_new AS (
         SELECT qnationalstockupdates_source."row",
            qnationalstockupdates_source._tstamp_,
            qnationalstockupdates_source.update_date,
            qnationalstockupdates_source.provincename,
            qnationalstockupdates_source.districtname,
            qnationalstockupdates_source.subdistrictname,
            qnationalstockupdates_source.facilityname,
            qnationalstockupdates_source.itemname,
            qnationalstockupdates_source.abbreviation,
            qnationalstockupdates_source.stockcategory,
            qnationalstockupdates_source.inventorycode,
            qnationalstockupdates_source."stock level",
            qnationalstockupdates_source."stock received",
            qnationalstockupdates_source."stock lost",
            qnationalstockupdates_source.stockout_status,
            qnationalstockupdates_source.stockout_reason,
            qnationalstockupdates_source.stockout_alternative,
            qnationalstockupdates_source.stockout_ordered,
            qnationalstockupdates_source."VEN",
            qnationalstockupdates_source.current_stock_out,
            qnationalstockupdates_source.stockout_alternative_code,
            qnationalstockupdates_source.stock_type_new,
            qnationalstockupdates_source.first_stockout_date,
            qnationalstockupdates_source._stockid,
            qnationalstockupdates_source._provinceid,
            qnationalstockupdates_source._districtid,
            qnationalstockupdates_source._subdistrictid,
            qnationalstockupdates_source._facilityid,
            qnationalstockupdates_source.gps_longitude,
            qnationalstockupdates_source.gps_latitude,
            qnationalstockupdates_source.days_since_last_update_tstamp_,
                CASE qnationalstockupdates_source.stock_type_new
                    WHEN 'ARV'::text THEN qnationalstockupdates_source.days_since_last_update_tstamp_
                    ELSE NULL::integer
                END AS arv_days_since_last_update_tstamp_,
                CASE qnationalstockupdates_source.stock_type_new
                    WHEN 'TB'::text THEN qnationalstockupdates_source.days_since_last_update_tstamp_
                    ELSE NULL::integer
                END AS tb_days_since_last_update_tstamp_,
                CASE qnationalstockupdates_source.stock_type_new
                    WHEN 'VACC'::text THEN qnationalstockupdates_source.days_since_last_update_tstamp_
                    ELSE NULL::integer
                END AS vacc_days_since_last_update_tstamp_
           FROM qnationalstockupdates_source
        ), qhierarchysummaryfacility AS (
         SELECT q._provinceid,
            q._districtid,
            q._subdistrictid,
            q._facilityid,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.purpleindicator,
            q.arv_reporting,
            q.tb_reporting,
            q.vacc_reporting,
            q.reported_stocks,
            q.all_stocks,
                CASE
                    WHEN (((q.arv_reporting * q.tb_reporting) * q.vacc_reporting) = 1) THEN 1
                    ELSE 0
                END AS reporting_kpi,
            round((((q.reported_stocks)::numeric / (q.all_stocks)::numeric) * (100)::numeric), 2) AS completeness_percentage,
                CASE
                    WHEN (((q.reported_stocks)::numeric / (q.all_stocks)::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS completeness_kpi
           FROM ( SELECT qnationalstockupdates_new._provinceid,
                    qnationalstockupdates_new._districtid,
                    qnationalstockupdates_new._subdistrictid,
                    qnationalstockupdates_new._facilityid,
                    qnationalstockupdates_new.provincename,
                    qnationalstockupdates_new.districtname,
                    qnationalstockupdates_new.subdistrictname,
                    qnationalstockupdates_new.facilityname,
                        CASE
                            WHEN (min(qnationalstockupdates_new.days_since_last_update_tstamp_) <= 14) THEN 1
                            ELSE 0
                        END AS purpleindicator,
                        CASE
                            WHEN (min(qnationalstockupdates_new.arv_days_since_last_update_tstamp_) <= 7) THEN 1
                            ELSE 0
                        END AS arv_reporting,
                        CASE
                            WHEN (min(qnationalstockupdates_new.tb_days_since_last_update_tstamp_) <= 7) THEN 1
                            ELSE 0
                        END AS tb_reporting,
                        CASE
                            WHEN (min(qnationalstockupdates_new.vacc_days_since_last_update_tstamp_) <= 7) THEN 1
                            ELSE 0
                        END AS vacc_reporting,
                    sum(
                        CASE
                            WHEN (qnationalstockupdates_new.days_since_last_update_tstamp_ <= 7) THEN 1
                            ELSE 0
                        END) AS reported_stocks,
                    count(*) AS all_stocks
                   FROM qnationalstockupdates_new
                  GROUP BY qnationalstockupdates_new._provinceid, qnationalstockupdates_new._districtid, qnationalstockupdates_new._subdistrictid, qnationalstockupdates_new._facilityid, qnationalstockupdates_new.provincename, qnationalstockupdates_new.districtname, qnationalstockupdates_new.subdistrictname, qnationalstockupdates_new.facilityname) q
        ), qhierarchysummarysubdistrict AS (
         SELECT qhierarchysummaryfacility._subdistrictid,
            qhierarchysummaryfacility.subdistrictname,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.purpleindicator))::numeric / (count(qhierarchysummaryfacility.purpleindicator))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS subdistrict_purpleindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.reporting_kpi))::numeric / (count(qhierarchysummaryfacility.reporting_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS subdistrict_reportingindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.completeness_kpi))::numeric / (count(qhierarchysummaryfacility.completeness_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS subdistrict_completenessindicator
           FROM qhierarchysummaryfacility
          GROUP BY qhierarchysummaryfacility._subdistrictid, qhierarchysummaryfacility.subdistrictname
        ), qhierarchysummarydistrict AS (
         SELECT qhierarchysummaryfacility._districtid,
            qhierarchysummaryfacility.districtname,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.purpleindicator))::numeric / (count(qhierarchysummaryfacility.purpleindicator))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS district_purpleindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.reporting_kpi))::numeric / (count(qhierarchysummaryfacility.reporting_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS district_reportingindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.completeness_kpi))::numeric / (count(qhierarchysummaryfacility.completeness_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS district_completenessindicator
           FROM qhierarchysummaryfacility
          GROUP BY qhierarchysummaryfacility._districtid, qhierarchysummaryfacility.districtname
        ), qhierarchysummaryprovince AS (
         SELECT qhierarchysummaryfacility._provinceid,
            qhierarchysummaryfacility.provincename,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.purpleindicator))::numeric / (count(qhierarchysummaryfacility.purpleindicator))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS province_purpleindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.reporting_kpi))::numeric / (count(qhierarchysummaryfacility.reporting_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS province_reportingindicator,
                CASE
                    WHEN (((sum(qhierarchysummaryfacility.completeness_kpi))::numeric / (count(qhierarchysummaryfacility.completeness_kpi))::numeric) >= 0.8) THEN 1
                    ELSE 0
                END AS province_completenessindicator
           FROM qhierarchysummaryfacility
          GROUP BY qhierarchysummaryfacility._provinceid, qhierarchysummaryfacility.provincename
        ), qnationalstockupdates_levels_tableau AS (
         SELECT qn."row",
            qn._tstamp_,
            qn.update_date,
            qn.provincename,
            qn.districtname,
            qn.subdistrictname,
            qn.facilityname,
            qn.itemname,
            qn.abbreviation,
            qn.stockcategory,
            qn.inventorycode,
            qn."stock level",
            qn."stock received",
            qn."stock lost",
            qn.stockout_status,
            qn.stockout_reason,
            qn.stockout_alternative,
            qn.stockout_ordered,
            qn."VEN",
            qn.current_stock_out,
            qn.stockout_alternative_code,
            qn.stock_type_new,
            qn.first_stockout_date,
            qn._stockid,
            qn._provinceid,
            qn._districtid,
            qn._subdistrictid,
            qn._facilityid,
            qn.gps_longitude,
            qn.gps_latitude,
            qn.days_since_last_update_tstamp_,
            qn.arv_days_since_last_update_tstamp_,
            qn.tb_days_since_last_update_tstamp_,
            qn.vacc_days_since_last_update_tstamp_,
            '|f|'::text AS "|f|",
            qhf.purpleindicator,
            qhf.arv_reporting,
            qhf.tb_reporting,
            qhf.vacc_reporting,
            qhf.reported_stocks,
            qhf.all_stocks,
            qhf.completeness_percentage,
            qhf.reporting_kpi,
            qhf.completeness_kpi,
            '|sd|'::text AS "|sd|",
            qhsd.subdistrict_purpleindicator,
            qhsd.subdistrict_reportingindicator,
            qhsd.subdistrict_completenessindicator,
            '|d|'::text AS "|d|",
            qhd.district_purpleindicator,
            qhd.district_reportingindicator,
            qhd.district_completenessindicator,
            '|p|'::text AS "|p|",
            qhp.province_purpleindicator,
            qhp.province_reportingindicator,
            qhp.province_completenessindicator
           FROM ((((qnationalstockupdates_new qn
             JOIN qhierarchysummaryfacility qhf ON ((qn._facilityid = qhf._facilityid)))
             JOIN qhierarchysummarysubdistrict qhsd ON ((qn._subdistrictid = qhsd._subdistrictid)))
             JOIN qhierarchysummarydistrict qhd ON ((qn._districtid = qhd._districtid)))
             JOIN qhierarchysummaryprovince qhp ON ((qn._provinceid = qhp._provinceid)))
        ), qfinalselect AS (
         SELECT qnationalstockupdates_levels_tableau."row",
            qnationalstockupdates_levels_tableau._tstamp_,
            qnationalstockupdates_levels_tableau.update_date,
            qnationalstockupdates_levels_tableau.provincename,
            qnationalstockupdates_levels_tableau.districtname,
            qnationalstockupdates_levels_tableau.subdistrictname,
            qnationalstockupdates_levels_tableau.facilityname,
            qnationalstockupdates_levels_tableau.itemname,
            qnationalstockupdates_levels_tableau.abbreviation,
            qnationalstockupdates_levels_tableau.stockcategory,
            qnationalstockupdates_levels_tableau.inventorycode,
            qnationalstockupdates_levels_tableau."stock level",
            qnationalstockupdates_levels_tableau."stock received",
            qnationalstockupdates_levels_tableau."stock lost",
            qnationalstockupdates_levels_tableau.stockout_status,
            qnationalstockupdates_levels_tableau.stockout_reason,
            qnationalstockupdates_levels_tableau.stockout_alternative,
            qnationalstockupdates_levels_tableau.stockout_ordered,
            qnationalstockupdates_levels_tableau."VEN",
            qnationalstockupdates_levels_tableau.current_stock_out,
            qnationalstockupdates_levels_tableau.stockout_alternative_code,
            qnationalstockupdates_levels_tableau.stock_type_new,
            qnationalstockupdates_levels_tableau.first_stockout_date,
            qnationalstockupdates_levels_tableau._stockid,
            qnationalstockupdates_levels_tableau._provinceid,
            qnationalstockupdates_levels_tableau._districtid,
            qnationalstockupdates_levels_tableau._subdistrictid,
            qnationalstockupdates_levels_tableau._facilityid,
            qnationalstockupdates_levels_tableau.gps_longitude,
            qnationalstockupdates_levels_tableau.gps_latitude,
            qnationalstockupdates_levels_tableau.days_since_last_update_tstamp_,
            qnationalstockupdates_levels_tableau.arv_days_since_last_update_tstamp_,
            qnationalstockupdates_levels_tableau.tb_days_since_last_update_tstamp_,
            qnationalstockupdates_levels_tableau.vacc_days_since_last_update_tstamp_,
            qnationalstockupdates_levels_tableau."|f|",
            qnationalstockupdates_levels_tableau.purpleindicator,
            qnationalstockupdates_levels_tableau.arv_reporting,
            qnationalstockupdates_levels_tableau.tb_reporting,
            qnationalstockupdates_levels_tableau.vacc_reporting,
            qnationalstockupdates_levels_tableau.reported_stocks,
            qnationalstockupdates_levels_tableau.all_stocks,
            qnationalstockupdates_levels_tableau.completeness_percentage,
            qnationalstockupdates_levels_tableau.reporting_kpi,
            qnationalstockupdates_levels_tableau.completeness_kpi,
            qnationalstockupdates_levels_tableau."|sd|",
            qnationalstockupdates_levels_tableau.subdistrict_purpleindicator,
            qnationalstockupdates_levels_tableau.subdistrict_reportingindicator,
            qnationalstockupdates_levels_tableau.subdistrict_completenessindicator,
            qnationalstockupdates_levels_tableau."|d|",
            qnationalstockupdates_levels_tableau.district_purpleindicator,
            qnationalstockupdates_levels_tableau.district_reportingindicator,
            qnationalstockupdates_levels_tableau.district_completenessindicator,
            qnationalstockupdates_levels_tableau."|p|",
            qnationalstockupdates_levels_tableau.province_purpleindicator,
            qnationalstockupdates_levels_tableau.province_reportingindicator,
            qnationalstockupdates_levels_tableau.province_completenessindicator
           FROM qnationalstockupdates_levels_tableau
          ORDER BY qnationalstockupdates_levels_tableau.provincename, qnationalstockupdates_levels_tableau.districtname, qnationalstockupdates_levels_tableau.subdistrictname, qnationalstockupdates_levels_tableau.facilityname, qnationalstockupdates_levels_tableau.itemname
        )
 SELECT qfinalselect."row",
    qfinalselect._tstamp_,
    qfinalselect.update_date,
    qfinalselect.provincename,
    qfinalselect.districtname,
    qfinalselect.subdistrictname,
    qfinalselect.facilityname,
    qfinalselect.itemname,
    qfinalselect.abbreviation,
    qfinalselect.stockcategory,
    qfinalselect.inventorycode,
    qfinalselect."stock level",
    qfinalselect."stock received",
    qfinalselect."stock lost",
    qfinalselect.stockout_status,
    qfinalselect.stockout_reason,
    qfinalselect.stockout_alternative,
    qfinalselect.stockout_ordered,
    qfinalselect."VEN",
    qfinalselect.current_stock_out,
    qfinalselect.stockout_alternative_code,
    qfinalselect.stock_type_new,
    qfinalselect.first_stockout_date,
    qfinalselect._stockid,
    qfinalselect._provinceid,
    qfinalselect._districtid,
    qfinalselect._subdistrictid,
    qfinalselect._facilityid,
    qfinalselect.gps_longitude,
    qfinalselect.gps_latitude,
    qfinalselect.days_since_last_update_tstamp_,
    qfinalselect.arv_days_since_last_update_tstamp_,
    qfinalselect.tb_days_since_last_update_tstamp_,
    qfinalselect.vacc_days_since_last_update_tstamp_,
    qfinalselect."|f|",
    qfinalselect.purpleindicator,
    qfinalselect.arv_reporting,
    qfinalselect.tb_reporting,
    qfinalselect.vacc_reporting,
    qfinalselect.reported_stocks,
    qfinalselect.all_stocks,
    qfinalselect.completeness_percentage,
    qfinalselect.reporting_kpi,
    qfinalselect.completeness_kpi,
    qfinalselect."|sd|",
    qfinalselect.subdistrict_purpleindicator,
    qfinalselect.subdistrict_reportingindicator,
    qfinalselect.subdistrict_completenessindicator,
    qfinalselect."|d|",
    qfinalselect.district_purpleindicator,
    qfinalselect.district_reportingindicator,
    qfinalselect.district_completenessindicator,
    qfinalselect."|p|",
    qfinalselect.province_purpleindicator,
    qfinalselect.province_reportingindicator,
    qfinalselect.province_completenessindicator
   FROM qfinalselect;


--
-- Name: heliumonlyreportingaggregate; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyreportingaggregate (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    level text,
    region text,
    totalfacilities integer,
    reportingfacilities text,
    nonreportingfacilities text,
    reportingstockoutfacilities text
);


--
-- Name: heliumonlyreportingfacility; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyreportingfacility (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    hasstockout boolean,
    province_fk uuid,
    district_fk uuid,
    subdistrict_fk uuid,
    facility_fk uuid,
    stockupdate_fk uuid
);


--
-- Name: heliumonlyreportingvendorfacility; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyreportingvendorfacility (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    hasstockouts boolean,
    reporting boolean,
    facilityname text,
    latitude numeric(20,10),
    longitude numeric(20,10),
    subdistrictname text,
    districtname text,
    provincename text,
    facility_fk uuid,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid,
    vendor_fk uuid
);


--
-- Name: heliumonlystockout; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlystockout (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    category text,
    itemname text,
    barcode text,
    inventorycode text,
    latest_update_date timestamp without time zone,
    first_update_date timestamp without time zone,
    stockupdate_fk uuid,
    facility_fk uuid,
    stock_fk uuid,
    facilitystock_fk uuid
);


--
-- Name: heliumonlystockoutdurationitemsforcategory; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlystockoutdurationitemsforcategory (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    stockcategory text,
    itemname text,
    inventorycode text,
    barcode text,
    first_stockout_date timestamp without time zone,
    last_stock_out_update_datetime timestamp without time zone,
    stockout_reported_to_pdm timestamp without time zone,
    location text,
    days_since_first_stockout integer,
    days_since_last_update_timestamp integer,
    days_since_stockout_reported_to_pdm_timestamp integer,
    heliumonlystockoutdurationitemsforcategory_stock_fk uuid,
    heliumonlystockoutdurationitemsforcategory_facilitystock_fk uuid,
    heliumonlystockoutdurationitemsforcategory_stockupdate_fk uuid,
    heliumonlystockoutdurationitemsforcategory_province_fk uuid,
    heliumonlystockoutdurationitemsforcategory_district_fk uuid,
    heliumonlystockoutdurationitemsforcategory_subdistrict_fk uuid,
    heliumonlystockoutdurationitemsforcategory_facility_fk uuid
);


--
-- Name: heliumonlyuseractivitylogging; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumonlyuseractivitylogging (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    user_id text,
    user_role text,
    user_details text,
    contact_details text,
    contact_emails text,
    text text,
    event_type text,
    comment text,
    loggedat timestamp without time zone,
    deleted text,
    province text,
    district text,
    subdistrict text
);


--
-- Name: heliumscheduledfunctionanalysis; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumscheduledfunctionanalysis (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    fqdn text,
    schemaname text,
    datetimestamp_request date,
    successful text,
    datetimestamp_response date,
    qualifiedname text,
    index integer,
    schedule text,
    error text,
    exception text,
    stacktrace text,
    sumtotal integer,
    sumsuccessful integer,
    duration_minutes integer
);


--
-- Name: heliumscheduledfunctionanalysis_aggregation_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumscheduledfunctionanalysis_aggregation_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: heliumscheduledfunctionfailure; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumscheduledfunctionfailure (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    fqdn text,
    schemaname text,
    datetimestamp_request timestamp without time zone,
    successful text,
    datetimestamp_response timestamp without time zone,
    qualifiedname text,
    index integer,
    schedule text,
    error text,
    exception text,
    stacktrace text,
    sumtotal integer,
    sumsuccessful integer,
    duration_minutes integer
);


--
-- Name: heliumscheduledfunctionfalure_aggregation_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumscheduledfunctionfalure_aggregation_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: heliumscheduledfunctionsummary; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumscheduledfunctionsummary (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    index integer,
    qualifiedname text,
    total integer,
    totalsuccessful integer,
    totalfailed integer,
    failurepercentage integer
);


--
-- Name: heliumscheduledfunctionsummary_aggregation_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumscheduledfunctionsummary_aggregation_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: heliumweblogin; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumweblogin (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    instance_name text,
    app_name text,
    app_fqdn text,
    firstname text,
    surname text,
    mobilenumber text,
    rolename text,
    count_value integer,
    mindatestamp timestamp without time zone,
    maxdatestamp timestamp without time zone,
    days_since_last_login integer
);


--
-- Name: heliumweblogin_aggregation_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.heliumweblogin_aggregation_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: hierachreportattachment; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.hierachreportattachment (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    startdatetime timestamp without time zone,
    enddatetime timestamp without time zone,
    file_attachement bytea,
    location text,
    hierachy_level text,
    date_created timestamp without time zone,
    deleted text,
    file_attachement_fname__ character varying(255),
    file_attachement_mtype__ character varying(255),
    file_attachement_size__ integer,
    hierachyreportattachment_province_fk uuid,
    hierachyreportattachment_district_fk uuid,
    hierachyreportattachment_subdistrict_fk uuid,
    hierachyreportattachment_facility_fk uuid
);


--
-- Name: hospital; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.hospital (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    mobile text NOT NULL,
    gps_longitude numeric,
    gps_latitude numeric,
    deleted text,
    date_created timestamp without time zone,
    hospital_district_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: informationdocument; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.informationdocument (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    document_type text,
    content bytea,
    date_of_upload timestamp without time zone,
    deleted text,
    content_fname__ character varying(255),
    content_mtype__ character varying(255),
    content_size__ integer
);


--
-- Name: linelevel; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.linelevel (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    line_level_uuid text,
    item_code text,
    batch text,
    expiry timestamp without time zone,
    serial_no text,
    line_quality text,
    asn_fk uuid,
    containers_fk uuid,
    linelevel_uuid text,
    serial_number text,
    asn_linelevel_fk uuid,
    container_linelevel_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: mezbatch; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.mezbatch (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    header text
);


--
-- Name: mezbatchitem; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.mezbatchitem (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    processed boolean,
    value text,
    batch_fk uuid
);


--
-- Name: national_facility_topitems_currentweek_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.national_facility_topitems_currentweek_actual AS
 WITH facilityhierarchy AS (
         SELECT p._id_ AS _provinceid,
            p.name AS provincename,
            d._id_ AS _districtid,
            d.name AS districtname,
            sd._id_ AS _subdistrictid,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname,
            f._id_,
            f._tstamp_,
            f.name,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
            f.deleted,
            f.mustexit,
            f.facility_district_fk,
            f.facility_subdistrict_fk,
            f.date_created,
            f._tx_id_,
            f._change_type_,
            f._change_seq_,
            f.enrollment_allowed_access_x,
            f.enrollment_enrolled_x,
            f.enrollment_journey_launcher_version_x,
            f.enrollment_device_os_x,
            f.enrollment_device_model_x,
            f.enrollment_last_connected_x,
            f.enrollment_barcode_x,
            f.enrollmenturl,
            f.enrollment_perform_re_enrollment_x,
            f.enrollment_re_enrollment_last_processed_x,
            f.sig_image,
            f.sig_image_blob,
            f.sig_image_fname__,
            f.sig_image_mtype__,
            f.sig_image_size__,
            f.sig_image_blob_fname__,
            f.sig_image_blob_mtype__,
            f.sig_image_blob_size__
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          WHERE (f.deleted = 'No'::text)
        ), maxupdatelevels AS (
         SELECT q._facilityid,
            q._stockid,
            q.update_date,
            ((date_part('epoch'::text, age(now(), (q.update_date)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp
           FROM ( SELECT su.stockupdate_facility_fk AS _facilityid,
                    su.stockupdate_stock_fk AS _stockid,
                    (max(su.update_date) + '02:00:00'::interval) AS update_date
                   FROM zambia__svs_001.stockupdate su
                  GROUP BY su.stockupdate_facility_fk, su.stockupdate_stock_fk) q
        ), qnationalfacilitystockextra AS (
         SELECT DISTINCT fh.provincename,
            fh.districtname,
            fh.subdistrictname,
            fh.facilityname,
            sg.value AS stocktype,
            s.itemname,
            s.abbreviation,
            s.inventorycode,
            vs.stock_type,
            mud.update_date,
            fs.total AS "stock level",
                CASE
                    WHEN (COALESCE(fs.total, 1) <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out,
                CASE
                    WHEN (COALESCE(fs.total, 1) <> 0) THEN NULL::integer
                    ELSE ((date_part('epoch'::text, age(now(), (fs.stock_out_time)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer
                END AS days_since_first_stockout,
            COALESCE(mud.days_since_last_update_timestamp, 1000) AS days_since_last_update_timestamp,
            fs._id_ AS _stockid,
            sg._id_ AS _stocktypeid,
            fh._facilityid,
            fh._subdistrictid,
            fh._districtid,
            fh._provinceid
           FROM (((((facilityhierarchy fh
             JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.deleted = 'No'::text))))
             JOIN zambia__svs_001.stock s ON (((fs.facilitystock_stock_fk = s._id_) AND (fs.deleted = 'No'::text))))
             JOIN zambia__svs_001.stringgroup sg ON (((s.stock_stringgroup_fk = sg._id_) AND (sg.deleted = 'No'::text))))
             JOIN ( SELECT vs_1.inventorycode,
                    vs_1.stock_type
                   FROM zambia__svs_001.vendorstock vs_1
                  GROUP BY vs_1.inventorycode, vs_1.stock_type) vs ON ((vs.inventorycode = s.inventorycode)))
             JOIN maxupdatelevels mud ON (((fs.facilitystock_facility_fk = mud._facilityid) AND (fs.facilitystock_stock_fk = mud._stockid))))
          WHERE (btrim(COALESCE(s.itemname, ''::text)) <> ''::text)
        ), qnationalfacilitystockextra_facility_topitems AS (
         SELECT qnationalfacilitystockextra.provincename,
            qnationalfacilitystockextra.districtname,
            qnationalfacilitystockextra.subdistrictname,
            qnationalfacilitystockextra.facilityname,
            max(qnationalfacilitystockextra.current_stock_out) AS current_stock_out,
            min(qnationalfacilitystockextra.days_since_last_update_timestamp) AS days_since_last_update_timestamp,
            count(DISTINCT qnationalfacilitystockextra._stocktypeid) AS top_cotegories,
            qnationalfacilitystockextra._facilityid,
            qnationalfacilitystockextra._subdistrictid,
            qnationalfacilitystockextra._districtid,
            qnationalfacilitystockextra._provinceid
           FROM qnationalfacilitystockextra
          WHERE ((qnationalfacilitystockextra.stocktype = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text])) AND (date(qnationalfacilitystockextra.update_date) IN ( SELECT ((date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone))::date - (i.i - 13))
                   FROM generate_series(0, 13) i(i))))
          GROUP BY qnationalfacilitystockextra.provincename, qnationalfacilitystockextra.districtname, qnationalfacilitystockextra.subdistrictname, qnationalfacilitystockextra.facilityname, qnationalfacilitystockextra._facilityid, qnationalfacilitystockextra._subdistrictid, qnationalfacilitystockextra._districtid, qnationalfacilitystockextra._provinceid
        )
 SELECT qnationalfacilitystockextra_facility_topitems.provincename,
    qnationalfacilitystockextra_facility_topitems.districtname,
    qnationalfacilitystockextra_facility_topitems.subdistrictname,
    qnationalfacilitystockextra_facility_topitems.facilityname,
    qnationalfacilitystockextra_facility_topitems.current_stock_out,
    qnationalfacilitystockextra_facility_topitems.days_since_last_update_timestamp,
    qnationalfacilitystockextra_facility_topitems.top_cotegories,
    qnationalfacilitystockextra_facility_topitems._facilityid,
    qnationalfacilitystockextra_facility_topitems._subdistrictid,
    qnationalfacilitystockextra_facility_topitems._districtid,
    qnationalfacilitystockextra_facility_topitems._provinceid
   FROM qnationalfacilitystockextra_facility_topitems;


--
-- Name: national_facility_topitems_currentweek; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.national_facility_topitems_currentweek AS
 SELECT national_facility_topitems_currentweek_actual.provincename,
    national_facility_topitems_currentweek_actual.districtname,
    national_facility_topitems_currentweek_actual.subdistrictname,
    national_facility_topitems_currentweek_actual.facilityname,
    national_facility_topitems_currentweek_actual.current_stock_out,
    national_facility_topitems_currentweek_actual.days_since_last_update_timestamp,
    national_facility_topitems_currentweek_actual.top_cotegories,
    national_facility_topitems_currentweek_actual._facilityid,
    national_facility_topitems_currentweek_actual._subdistrictid,
    national_facility_topitems_currentweek_actual._districtid,
    national_facility_topitems_currentweek_actual._provinceid
   FROM zambia__svs_001.national_facility_topitems_currentweek_actual
  WITH NO DATA;


--
-- Name: pdm_facility_outstanding_update; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.pdm_facility_outstanding_update (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    facilityname text,
    subdistrictname text,
    districtname text,
    contact_number text,
    facilityuuid uuid,
    provinceuuid uuid
);


--
-- Name: pdm_facility_outstanding_update_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.pdm_facility_outstanding_update_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.pdm_facility_outstanding_update_function() AS result;


--
-- Name: pdm_facility_outstanding_update_aggregation_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.pdm_facility_outstanding_update_aggregation_logic_view AS
 SELECT DISTINCT all_facilities.facilityname,
    all_facilities.contact_number,
    all_facilities.subdistrictname,
    all_facilities.districtname,
    all_facilities._id_ AS facilityuuid,
    all_facilities.provinceuuid
   FROM (( SELECT facility._id_,
            facility.name AS facilityname,
            subdistrict.name AS subdistrictname,
            district.name AS districtname,
            facility.mobile AS contact_number,
            province._id_ AS provinceuuid
           FROM (((zambia__svs_001.province province
             JOIN zambia__svs_001.district district ON ((province._id_ = district.district_province_fk)))
             JOIN zambia__svs_001.subdistrict subdistrict ON ((district._id_ = subdistrict.subdistrict_district_fk)))
             JOIN zambia__svs_001.facility facility ON ((subdistrict._id_ = facility.facility_subdistrict_fk)))
          WHERE ((province._id_ IS NOT NULL) AND (facility.deleted = 'No'::text))) all_facilities
     LEFT JOIN ( SELECT facility._id_,
            province._id_ AS provinceuuid
           FROM ((((zambia__svs_001.province province
             JOIN zambia__svs_001.district district ON ((province._id_ = district.district_province_fk)))
             JOIN zambia__svs_001.subdistrict subdistrict ON ((district._id_ = subdistrict.subdistrict_district_fk)))
             JOIN zambia__svs_001.facility facility ON (((subdistrict._id_ = facility.facility_subdistrict_fk) AND (facility.facility_district_fk = district._id_) AND (facility.deleted = 'No'::text))))
             JOIN zambia__svs_001.stockupdate stockupdate ON ((facility._id_ = stockupdate.stockupdate_facility_fk)))
          WHERE ((province._id_ IS NOT NULL) AND (date(stockupdate.update_date) IN ( SELECT ((date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone))::date + (i.i - 6))
                   FROM generate_series(0, 6) i(i))))) f_no_updates ON (((all_facilities._id_ = f_no_updates._id_) AND (all_facilities.provinceuuid = f_no_updates.provinceuuid))))
  WHERE (f_no_updates._id_ IS NULL)
  ORDER BY all_facilities.districtname, all_facilities.subdistrictname, all_facilities.facilityname;


--
-- Name: poinfo; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.poinfo (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    order_uuid text,
    order_number text,
    supplier_identifier text,
    demander_id text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL,
    order_barcode text,
    deleted text,
    date_created timestamp without time zone,
    poinfo_facility_fk uuid,
    poinfo_delivery_fk uuid,
    accept text
);


--
-- Name: productstockupdateview; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.productstockupdateview AS
 SELECT fsg.facility_id AS _id_,
    now() AS _tstamp_,
    firststockitem.category,
    firststockitem.itemname,
    fsg.inventorycode,
    (stocksum.update_date + '02:00:00'::interval) AS update_date,
    dso.days_stockout,
        CASE
            WHEN (stocksum.available_stock IS NULL) THEN 'Not Sub'::text
            ELSE (stocksum.available_stock)::text
        END AS available_stock,
    stocksum.expiry_date,
    stocksum.stock_received,
    stocksum.stock_lost,
    fsg.facility_id AS productupdatedetails_facility_fk,
    date_part('day'::text, (now() - (stocksum.update_date)::timestamp with time zone)) AS days_since_update
   FROM (((( SELECT f._id_ AS facility_id,
            s.inventorycode
           FROM ((zambia__svs_001.facility f
             JOIN zambia__svs_001.facilitystock fs ON ((f._id_ = fs.facilitystock_facility_fk)))
             JOIN zambia__svs_001.stock s ON ((fs.facilitystock_stock_fk = s._id_)))
          WHERE ((f.deleted = 'No'::text) AND (fs.deleted = 'No'::text))
          GROUP BY f._id_, s.inventorycode) fsg
     JOIN ( SELECT firstitem.inventorycode,
            firstitem.itemname,
            sg.value AS category
           FROM (( SELECT row_number() OVER (PARTITION BY stock.inventorycode ORDER BY stock.itemname) AS row_num,
                    stock._id_,
                    stock._tstamp_,
                    stock.inventorycode,
                    stock.itemname,
                    stock.abbreviation,
                    stock.supplier,
                    stock.message_construct_placeholder,
                    stock.barcode,
                    stock.total,
                    stock.stock_level_min,
                    stock.stock_level_max,
                    stock.stock_type,
                    stock.stock_stringgroup_fk,
                    stock.deleted
                   FROM zambia__svs_001.stock) firstitem
             LEFT JOIN zambia__svs_001.stringgroup sg ON ((firstitem.stock_stringgroup_fk = sg._id_)))
          WHERE (firstitem.row_num = 1)
          ORDER BY firstitem.inventorycode) firststockitem ON ((fsg.inventorycode = firststockitem.inventorycode)))
     LEFT JOIN ( SELECT fs.facilitystock_facility_fk AS facility_id,
            s.inventorycode,
            sum((su.current_level)::integer) AS available_stock,
            max(su.update_date) AS update_date,
            max(su.expiry_date) AS expiry_date,
            sum((su.stock_received)::integer) AS stock_received,
            sum((su.stock_lost)::integer) AS stock_lost
           FROM (((zambia__svs_001.stockupdate su
             JOIN ( SELECT su_1.stockupdate_facility_fk,
                    su_1.stockupdate_stock_fk,
                    max(su_1.update_date) AS dteweeks
                   FROM zambia__svs_001.stockupdate su_1
                  GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
          WHERE (fs.deleted = 'No'::text)
          GROUP BY fs.facilitystock_facility_fk, s.inventorycode) stocksum ON (((fsg.facility_id = stocksum.facility_id) AND (fsg.inventorycode = stocksum.inventorycode))))
     LEFT JOIN ( SELECT fs.facilitystock_facility_fk AS facility_id,
            s.inventorycode,
            (date_part('day'::text, (now() - (
                CASE
                    WHEN (max(su.first_stockout_date) IS NOT NULL) THEN max(su.first_stockout_date)
                    ELSE max(su.update_date)
                END)::timestamp with time zone)))::integer AS days_stockout
           FROM (((zambia__svs_001.stockupdate su
             JOIN ( SELECT su_1.stockupdate_facility_fk,
                    su_1.stockupdate_stock_fk,
                    max(su_1.update_date) AS dteweeks
                   FROM zambia__svs_001.stockupdate su_1
                  GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) maxweeks ON (((su.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (su.update_date = maxweeks.dteweeks))))
             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
          WHERE (fs.deleted = 'No'::text)
          GROUP BY fs.facilitystock_facility_fk, s.inventorycode
         HAVING (sum((su.current_level)::integer) = 0)) dso ON (((fsg.facility_id = dso.facility_id) AND (fsg.inventorycode = dso.inventorycode))));


--
-- Name: receipt; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.receipt (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    receipt_uuid text,
    receipt_date timestamp without time zone,
    asn_fk uuid,
    container_fk uuid,
    asn_receipt_fk uuid,
    container_receipt_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: recieptperline; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.recieptperline (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    recieptperline_uuid text,
    reciept_fk uuid,
    linelevel_fk uuid,
    reciept_receiptperline_fk uuid,
    linelevel_receiptperline_fk uuid,
    container_receiptperline_fk uuid,
    tripsheet_receiptperline_fk uuid,
    asn_receiptperline_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: refresh_jasperreports_materializedview_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.refresh_jasperreports_materializedview_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    result integer
);


--
-- Name: refresh_materializedview_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.refresh_materializedview_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.refresh_materializedviews_function() AS counter;


--
-- Name: refresh_tableau_report_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.refresh_tableau_report_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_refresh_tableau_aggregation_function() AS counter;


--
-- Name: report_category; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.report_category (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    deleted text,
    report_indicator_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: report_facility_type; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.report_facility_type (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    deleted text,
    report_type_fk uuid,
    facility_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: report_indicator; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.report_indicator (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    deleted text,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: report_object; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.report_object (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    reported_cases text,
    date_time timestamp without time zone,
    report_facility_type_fk uuid,
    report_type_fk uuid,
    facility_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: report_type; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.report_type (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    priority text,
    deleted text,
    report_category_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: reportfacilityproductstatus_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.reportfacilityproductstatus_view AS
 WITH temp_table_latest_stock_update_id AS (
         SELECT su._id_
           FROM (zambia__svs_001.stockupdate su
             JOIN ( SELECT su_1.stockupdate_facility_fk,
                    su_1.stockupdate_stock_fk,
                    max(su_1.update_date) AS maxupdatedate
                   FROM zambia__svs_001.stockupdate su_1
                  GROUP BY su_1.stockupdate_facility_fk, su_1.stockupdate_stock_fk) lastupdate ON (((su.stockupdate_facility_fk = lastupdate.stockupdate_facility_fk) AND (su.stockupdate_stock_fk = lastupdate.stockupdate_stock_fk) AND (su.update_date = lastupdate.maxupdatedate))))
        ), facilityproductstatusview AS (
         SELECT f._id_,
            now() AS _tstamp_,
            f.name AS facility_name,
            f._id_ AS _facilityid,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
                CASE
                    WHEN (stockout.bluestockout IS NOT NULL) THEN 3
                    WHEN (stockout.facility_id IS NOT NULL) THEN stockout.priority
                    WHEN (oldvenderstockout.facility_id IS NOT NULL) THEN 3
                    WHEN (twoweekoldvenderstockout.facility_id IS NOT NULL) THEN 4
                    ELSE 5
                END AS priority,
                CASE
                    WHEN (stockout.bluestockout IS NOT NULL) THEN 'vs_blue'::text
                    WHEN (stockout.facility_id IS NOT NULL) THEN stockout.icon
                    WHEN (oldvenderstockout.facility_id IS NOT NULL) THEN 'vs_blue'::text
                    WHEN (twoweekoldvenderstockout.facility_id IS NOT NULL) THEN 'vs_purple'::text
                    ELSE 'vs_green'::text
                END AS icon,
            sd.name AS subdistrictname,
            sd.name AS districtname,
            sd.name AS provincename,
            sd._id_ AS _subdistricid,
            d._id_ AS _districid,
            p._id_ AS _provinceid
           FROM ((((((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
             LEFT JOIN ( SELECT nostock.facility_id,
                        CASE
                            WHEN (nostocknoalternative.facility_id IS NOT NULL) THEN 1
                            WHEN (nostockwithalternative.facility_id IS NOT NULL) THEN 2
                            ELSE 1
                        END AS priority,
                        CASE
                            WHEN (nostocknoalternative.facility_id IS NOT NULL) THEN 'vs_red'::text
                            WHEN (nostockwithalternative.facility_id IS NOT NULL) THEN 'vs_yellow'::text
                            ELSE 'vs_red'::text
                        END AS icon,
                    last_facility_stockout.facility_id AS bluestockout
                   FROM (((( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id
                           FROM (((zambia__svs_001.stockupdate su
                             JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                          WHERE (fs.deleted = 'No'::text)
                          GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                         HAVING (sum((su.current_level)::integer) = 0)) nostock
                     LEFT JOIN ( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id
                           FROM ((((zambia__svs_001.stockupdate su
                             JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                             JOIN zambia__svs_001.stringgroup sg ON ((su.stockupdate_stockout_alternative_fk = sg._id_)))
                          WHERE ((fs.deleted = 'No'::text) AND (sg.value_ident = 1))
                          GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                         HAVING (sum((su.current_level)::integer) = 0)) nostocknoalternative ON ((nostock.facility_id = nostocknoalternative.facility_id)))
                     LEFT JOIN ( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id
                           FROM ((((zambia__svs_001.stockupdate su
                             JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                             JOIN zambia__svs_001.stringgroup sg ON ((su.stockupdate_stockout_alternative_fk = sg._id_)))
                          WHERE ((fs.deleted = 'No'::text) AND (sg.value_ident = 2))
                          GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                         HAVING (sum((su.current_level)::integer) = 0)) nostockwithalternative ON ((nostock.facility_id = nostockwithalternative.facility_id)))
                     LEFT JOIN ( SELECT stockout_maxdate.facility_id,
                            max(stockout_maxdate.max_update_date) AS last_stockout_date
                           FROM ( SELECT DISTINCT fs.facilitystock_facility_fk AS facility_id,
                                    max(su.update_date) AS max_update_date
                                   FROM (((zambia__svs_001.stockupdate su
                                     JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                                     JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                                  WHERE (fs.deleted = 'No'::text)
                                  GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                                 HAVING (sum((su.current_level)::integer) = 0)) stockout_maxdate
                          GROUP BY stockout_maxdate.facility_id
                         HAVING (max(stockout_maxdate.max_update_date) < ((('now'::text)::date - '14 days'::interval))::date)) last_facility_stockout ON ((nostock.facility_id = last_facility_stockout.facility_id)))) stockout ON ((f._id_ = stockout.facility_id)))
             LEFT JOIN ( SELECT DISTINCT hasvenderstockout.facility_id
                   FROM (( SELECT fs.facilitystock_facility_fk AS facility_id,
                            s.inventorycode
                           FROM (((zambia__svs_001.stockupdate su
                             JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                          WHERE (fs.deleted = 'No'::text)
                          GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                         HAVING (sum((su.current_level)::integer) > 0)) hasstock
                     JOIN ( SELECT f_1._id_ AS facility_id,
                            s.inventorycode
                           FROM (((((zambia__svs_001.stockupdate su
                             JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                             JOIN zambia__svs_001.facility f_1 ON ((su.stockupdate_facility_fk = f_1._id_)))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             LEFT JOIN zambia__svs_001.stringgroup sg ON ((su.stockupdate_stockout_alternative_fk = sg._id_)))
                          WHERE ((sg.value_ident = ANY (ARRAY[1, 2])) AND (fs.deleted = 'No'::text) AND ((su.current_level)::integer = 0) AND ((su.update_date < ((('now'::text)::date - '14 days'::interval))::date) OR (su.first_stockout_date < ((('now'::text)::date - '14 days'::interval))::date)))
                          GROUP BY f_1._id_, s.inventorycode) hasvenderstockout ON (((hasstock.facility_id = hasvenderstockout.facility_id) AND (hasstock.inventorycode = hasvenderstockout.inventorycode))))) twoweekoldvenderstockout ON ((f._id_ = twoweekoldvenderstockout.facility_id)))
             LEFT JOIN ( SELECT DISTINCT hasvenderstockout.facility_id
                   FROM (( SELECT fs.facilitystock_facility_fk AS facility_id,
                            s.inventorycode
                           FROM (((zambia__svs_001.stockupdate su
                             JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                          WHERE (fs.deleted = 'No'::text)
                          GROUP BY fs.facilitystock_facility_fk, s.inventorycode
                         HAVING (sum((su.current_level)::integer) > 0)) hasstock
                     JOIN ( SELECT f_1._id_ AS facility_id,
                            s.inventorycode
                           FROM (((((zambia__svs_001.stockupdate su
                             JOIN temp_table_latest_stock_update_id ttlsui ON ((su._id_ = ttlsui._id_)))
                             JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                             JOIN zambia__svs_001.facility f_1 ON ((su.stockupdate_facility_fk = f_1._id_)))
                             JOIN zambia__svs_001.facilitystock fs ON ((su.stockupdate_facilitystock_fk = fs._id_)))
                             LEFT JOIN zambia__svs_001.stringgroup sg ON ((su.stockupdate_stockout_alternative_fk = sg._id_)))
                          WHERE ((sg.value_ident = ANY (ARRAY[1, 2])) AND (fs.deleted = 'No'::text) AND ((su.current_level)::integer = 0) AND ((su.update_date < ((('now'::text)::date - '21 days'::interval))::date) OR (su.first_stockout_date < ((('now'::text)::date - '21 days'::interval))::date)))
                          GROUP BY f_1._id_, s.inventorycode) hasvenderstockout ON (((hasstock.facility_id = hasvenderstockout.facility_id) AND (hasstock.inventorycode = hasvenderstockout.inventorycode))))) oldvenderstockout ON ((f._id_ = oldvenderstockout.facility_id)))
          WHERE (f.deleted = 'No'::text)
          ORDER BY
                CASE
                    WHEN (stockout.bluestockout IS NOT NULL) THEN 3
                    WHEN (stockout.facility_id IS NOT NULL) THEN stockout.priority
                    WHEN (oldvenderstockout.facility_id IS NOT NULL) THEN 3
                    WHEN (twoweekoldvenderstockout.facility_id IS NOT NULL) THEN 4
                    ELSE 5
                END
        )
 SELECT facilityproductstatusview._id_,
    facilityproductstatusview._tstamp_,
    facilityproductstatusview.facility_name,
    facilityproductstatusview._facilityid,
    facilityproductstatusview.code,
    facilityproductstatusview.mobile,
    facilityproductstatusview.gps_longitude,
    facilityproductstatusview.gps_latitude,
    facilityproductstatusview.priority,
    facilityproductstatusview.icon,
    facilityproductstatusview._subdistricid,
    facilityproductstatusview._districid,
    facilityproductstatusview._provinceid
   FROM facilityproductstatusview;


--
-- Name: reportfacilityproductstatus_materializedview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.reportfacilityproductstatus_materializedview AS
 SELECT reportfacilityproductstatus_view._id_,
    reportfacilityproductstatus_view._tstamp_,
    reportfacilityproductstatus_view.facility_name,
    reportfacilityproductstatus_view._facilityid,
    reportfacilityproductstatus_view.code,
    reportfacilityproductstatus_view.mobile,
    reportfacilityproductstatus_view.gps_longitude,
    reportfacilityproductstatus_view.gps_latitude,
    reportfacilityproductstatus_view.priority,
    reportfacilityproductstatus_view.icon,
    reportfacilityproductstatus_view._subdistricid,
    reportfacilityproductstatus_view._districid,
    reportfacilityproductstatus_view._provinceid
   FROM zambia__svs_001.reportfacilityproductstatus_view
  WITH NO DATA;


--
-- Name: reportstockoutdistrictview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.reportstockoutdistrictview_actual AS
SELECT
    NULL::uuid AS _id_,
    NULL::timestamp with time zone AS _tstamp_,
    NULL::text AS stock_item,
    NULL::text AS stock_abbreviation,
    NULL::numeric AS num_facilities,
    NULL::numeric AS out_of_stock,
    NULL::numeric AS not_reported,
    NULL::numeric AS out_of_stock_actual,
    NULL::uuid AS reportstockoutdistrictview_stock_fk,
    NULL::uuid AS reportstockoutdistrictview_district_fk,
    NULL::numeric AS stock_out_percentage,
    NULL::numeric AS stock_out_percentage_and_reported;


--
-- Name: reportstockoutdistrictview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.reportstockoutdistrictview AS
 SELECT reportstockoutdistrictview_actual._id_,
    reportstockoutdistrictview_actual._tstamp_,
    reportstockoutdistrictview_actual.stock_item,
    reportstockoutdistrictview_actual.stock_abbreviation,
    reportstockoutdistrictview_actual.num_facilities,
    reportstockoutdistrictview_actual.out_of_stock,
    reportstockoutdistrictview_actual.not_reported,
    reportstockoutdistrictview_actual.out_of_stock_actual,
    reportstockoutdistrictview_actual.reportstockoutdistrictview_stock_fk,
    reportstockoutdistrictview_actual.reportstockoutdistrictview_district_fk,
    reportstockoutdistrictview_actual.stock_out_percentage,
    reportstockoutdistrictview_actual.stock_out_percentage_and_reported
   FROM zambia__svs_001.reportstockoutdistrictview_actual
  WITH NO DATA;


--
-- Name: reportstockoutfacilityview; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.reportstockoutfacilityview AS
 SELECT facility._id_,
    now() AS _tstamp_,
    province._id_ AS reportstockoutfacilityview_province_fk,
    province.name AS province_name,
    district._id_ AS reportstockoutfacilityview_district_fk,
    district.name AS district_name,
    subdistrict._id_ AS reportstockoutfacilityview_subdistrict_fk,
    subdistrict.name AS subdistrict_name,
    facility._id_ AS reportstockoutfacilityview_facility_fk,
    facility.name AS facility_name,
    stock._id_ AS reportstockoutfacilityview_stock_fk
   FROM ((((((zambia__svs_001.province
     JOIN zambia__svs_001.district ON ((district.district_province_fk = province._id_)))
     JOIN zambia__svs_001.facility ON ((facility.facility_district_fk = district._id_)))
     JOIN zambia__svs_001.subdistrict ON (((subdistrict.subdistrict_district_fk = district._id_) AND (facility.facility_subdistrict_fk = subdistrict._id_))))
     JOIN zambia__svs_001.facilitystock ON ((facility._id_ = facilitystock.facilitystock_facility_fk)))
     JOIN zambia__svs_001.stock ON ((facilitystock.facilitystock_stock_fk = stock._id_)))
     JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
  WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (facilitystock.stock_out = 'Yes'::text) AND (facilitystock.total = 0))
  GROUP BY province._id_, province.name, district._id_, district.name, facility._id_, facility.name, stock._id_, stock.abbreviation, stock.itemname, stock.supplier, subdistrict._id_, subdistrict.name;


--
-- Name: reportstockoutnationalview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.reportstockoutnationalview_actual AS
SELECT
    NULL::uuid AS _id_,
    NULL::timestamp with time zone AS _tstamp_,
    NULL::uuid AS reportstockoutnationalview_stock_fk,
    NULL::text AS stock_item,
    NULL::text AS stock_abbreviation,
    NULL::numeric AS num_facilities,
    NULL::numeric AS out_of_stock,
    NULL::numeric AS not_reported,
    NULL::numeric AS out_of_stock_actual,
    NULL::numeric AS stock_out_percentage,
    NULL::numeric AS stock_out_percentage_and_reported;


--
-- Name: reportstockoutnationalview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.reportstockoutnationalview AS
 SELECT reportstockoutnationalview_actual._id_,
    reportstockoutnationalview_actual._tstamp_,
    reportstockoutnationalview_actual.reportstockoutnationalview_stock_fk,
    reportstockoutnationalview_actual.stock_item,
    reportstockoutnationalview_actual.stock_abbreviation,
    reportstockoutnationalview_actual.num_facilities,
    reportstockoutnationalview_actual.out_of_stock,
    reportstockoutnationalview_actual.not_reported,
    reportstockoutnationalview_actual.out_of_stock_actual,
    reportstockoutnationalview_actual.stock_out_percentage,
    reportstockoutnationalview_actual.stock_out_percentage_and_reported
   FROM zambia__svs_001.reportstockoutnationalview_actual
  WITH NO DATA;


--
-- Name: reportstockoutprovincialview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.reportstockoutprovincialview_actual AS
SELECT
    NULL::uuid AS _id_,
    NULL::timestamp with time zone AS _tstamp_,
    NULL::text AS stock_item,
    NULL::text AS stock_abbreviation,
    NULL::numeric AS num_facilities,
    NULL::numeric AS out_of_stock,
    NULL::numeric AS not_reported,
    NULL::numeric AS out_of_stock_actual,
    NULL::uuid AS reportstockoutprovincialview_stock_fk,
    NULL::uuid AS reportstockoutprovincialview_province_fk,
    NULL::numeric AS stock_out_percentage,
    NULL::numeric AS stock_out_percentage_and_reported;


--
-- Name: reportstockoutprovincialview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.reportstockoutprovincialview AS
 SELECT reportstockoutprovincialview_actual._id_,
    reportstockoutprovincialview_actual._tstamp_,
    reportstockoutprovincialview_actual.stock_item,
    reportstockoutprovincialview_actual.stock_abbreviation,
    reportstockoutprovincialview_actual.num_facilities,
    reportstockoutprovincialview_actual.out_of_stock,
    reportstockoutprovincialview_actual.not_reported,
    reportstockoutprovincialview_actual.out_of_stock_actual,
    reportstockoutprovincialview_actual.reportstockoutprovincialview_stock_fk,
    reportstockoutprovincialview_actual.reportstockoutprovincialview_province_fk,
    reportstockoutprovincialview_actual.stock_out_percentage,
    reportstockoutprovincialview_actual.stock_out_percentage_and_reported
   FROM zambia__svs_001.reportstockoutprovincialview_actual
  WITH NO DATA;


--
-- Name: reportstockoutsubdistrictview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.reportstockoutsubdistrictview_actual AS
SELECT
    NULL::uuid AS _id_,
    NULL::timestamp with time zone AS _tstamp_,
    NULL::text AS stock_item,
    NULL::text AS stock_abbreviation,
    NULL::numeric AS num_facilities,
    NULL::numeric AS out_of_stock,
    NULL::numeric AS not_reported,
    NULL::numeric AS out_of_stock_actual,
    NULL::uuid AS reportstockoutsubdistrictview_stock_fk,
    NULL::uuid AS reportstockoutsubdistrictview_subdistrict_fk,
    NULL::numeric AS stock_out_percentage,
    NULL::numeric AS stock_out_percentage_and_reported;


--
-- Name: reportstockoutsubdistrictview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.reportstockoutsubdistrictview AS
 SELECT reportstockoutsubdistrictview_actual._id_,
    reportstockoutsubdistrictview_actual._tstamp_,
    reportstockoutsubdistrictview_actual.stock_item,
    reportstockoutsubdistrictview_actual.stock_abbreviation,
    reportstockoutsubdistrictview_actual.num_facilities,
    reportstockoutsubdistrictview_actual.out_of_stock,
    reportstockoutsubdistrictview_actual.not_reported,
    reportstockoutsubdistrictview_actual.out_of_stock_actual,
    reportstockoutsubdistrictview_actual.reportstockoutsubdistrictview_stock_fk,
    reportstockoutsubdistrictview_actual.reportstockoutsubdistrictview_subdistrict_fk,
    reportstockoutsubdistrictview_actual.stock_out_percentage,
    reportstockoutsubdistrictview_actual.stock_out_percentage_and_reported
   FROM zambia__svs_001.reportstockoutsubdistrictview_actual
  WITH NO DATA;


--
-- Name: result; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.result (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    success integer,
    message text
);


--
-- Name: scheduledeventlog; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.scheduledeventlog (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    functionname text,
    outcome text,
    eventtype text,
    startdatetime timestamp without time zone,
    enddatetime timestamp without time zone
);


--
-- Name: setting; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.setting (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    state integer,
    value text
);


--
-- Name: shadowfacility; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowfacility (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    hasstockouts boolean,
    reporting boolean,
    facilityname text,
    latitude numeric,
    longitude numeric,
    subdistrictname text,
    districtname text,
    provincename text,
    facility_fk uuid,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid
);


--
-- Name: shadowfirststockout; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowfirststockout (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    update_date timestamp without time zone,
    stock_level integer,
    days_since_stockout integer,
    days_since_update integer,
    days_since_reported integer,
    facility_fk uuid,
    facilitystock_fk uuid,
    stockupdate_fk uuid,
    stock_fk uuid
);


--
-- Name: shadowfirstupdate; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowfirstupdate (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    facilityname text,
    itemname text,
    category text,
    inventorycode text,
    barcode text,
    update_date timestamp without time zone,
    stock_level integer,
    facility_fk uuid,
    facilitystock_fk uuid,
    stockupdate_fk uuid,
    stock_fk uuid
);


--
-- Name: shadowlaststockout; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowlaststockout (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    update_date timestamp without time zone,
    stock_level integer,
    days_since_stockout integer,
    days_since_update integer,
    days_since_reported integer,
    facility_fk uuid,
    facilitystock_fk uuid,
    stockupdate_fk uuid,
    stock_fk uuid
);


--
-- Name: shadowlastupdate; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowlastupdate (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    facilityname text,
    itemname text,
    category text,
    inventorycode text,
    barcode text,
    update_date timestamp without time zone,
    stock_level integer,
    facility_fk uuid,
    facilitystock_fk uuid,
    stockupdate_fk uuid,
    stock_fk uuid
);


--
-- Name: shadowreportingaggregate; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowreportingaggregate (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    total_facilities integer,
    reporting_facilities text,
    nonreporting_facilities text,
    reporting_stockout_facilities text,
    level text,
    subdistrictname text,
    districtname text,
    provincename text,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid
);


--
-- Name: shadowreportingsupplieraggregate; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowreportingsupplieraggregate (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    total_facilities integer,
    reporting_facilities text,
    nonreporting_facilities text,
    reporting_stockout_facilities text,
    level text,
    subdistrictname text,
    districtname text,
    provincename text,
    date_created timestamp without time zone,
    supplier_fk uuid,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid
);


--
-- Name: shadowstockoutsequence; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.shadowstockoutsequence (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    firststockout timestamp without time zone,
    laststockout timestamp without time zone,
    days_since_stockout integer,
    days_since_update integer,
    days_since_reported integer,
    facility_fk uuid,
    facilitystock_fk uuid,
    stock_fk uuid
);


--
-- Name: smslog; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.smslog (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    userid uuid,
    user_role text,
    mobile_number text,
    "desc" text,
    source text,
    direction text,
    type text,
    sms_fk uuid
);


--
-- Name: smsmessage; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.smsmessage (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    title text,
    content text
);


--
-- Name: smsoutbound; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.smsoutbound (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    date_archived timestamp without time zone,
    archived integer,
    mobile_number text,
    message_content text,
    sms_type text,
    sent integer,
    approved integer,
    date_sent timestamp without time zone
);


--
-- Name: stock_category_link; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stock_category_link (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    stock uuid,
    form_type uuid,
    stock_itemname text,
    form_type_value text,
    date_created timestamp without time zone,
    deleted text,
    stock_category_link_stock_fk uuid,
    stock_category_link_form_type_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: stockoutdurationitems_tmp; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stockoutdurationitems_tmp (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: stockoutdurationitemscategory_aggregation_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.stockoutdurationitemscategory_aggregation_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.stockoutdurationitemscategory_aggr_function() AS counter;


--
-- Name: stockoutdurationitemsforcategory_aggr_logic_view; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.stockoutdurationitemsforcategory_aggr_logic_view AS
 WITH facilityhierarchy AS (
         SELECT p.name AS provincename,
            d.name AS districtname,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid,
            f.name AS facilityname
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((f.facility_subdistrict_fk = sd._id_)))
             LEFT JOIN zambia__svs_001.district d ON ((sd.subdistrict_district_fk = d._id_)))
             LEFT JOIN zambia__svs_001.province p ON ((d.district_province_fk = p._id_)))
          WHERE ((f.deleted = 'No'::text) AND (p.name <> 'Training Demos'::text))
        ), qnationalstockupdates_new AS (
         SELECT q."timestamp",
            q.update_date,
            q.expiry_date,
            q.provincename,
            q.districtname,
            q.subdistrictname,
            q.facilityname,
            q.stockcategory,
            q.itemname,
            q.abbreviation,
            q.inventorycode,
            q.barcode,
            q."stock level",
            q."stock received",
            q."stock lost",
            q.first_stockout_date,
            q.stockout_reported_to_pdm,
            q._facilityid,
            q.stock_uuid,
            q.stockupdate_uuid,
            q.facilitystock_uuid,
            ((date_part('epoch'::text, age(now(), COALESCE((q.first_stockout_date)::timestamp with time zone, now()))) / (((60 * 60) * 24))::double precision))::integer AS days_since_first_stockout,
            ((date_part('epoch'::text, age(now(), (q."timestamp")::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp,
            ((date_part('epoch'::text, age(now(), (q.stockout_reported_to_pdm)::timestamp with time zone)) / (((60 * 60) * 24))::double precision))::integer AS days_since_stockout_reported_to_pdm_timestamp,
                CASE
                    WHEN ((COALESCE(q."stock level", '0'::text))::integer <> 0) THEN 0
                    ELSE 1
                END AS current_stock_out
           FROM ( SELECT
                        CASE
                            WHEN (su._tstamp_ >= '2014-10-09'::date) THEN su._tstamp_
                            ELSE (su.update_date + '02:00:00'::interval)
                        END AS "timestamp",
                    (su.update_date + '02:00:00'::interval) AS update_date,
                        CASE
                            WHEN ((COALESCE(su.expiry_date, (now())::date) >= '1900-01-01'::date) AND (COALESCE(su.expiry_date, (now())::date) <= '2100-01-01'::date)) THEN su.expiry_date
                            ELSE NULL::date
                        END AS expiry_date,
                    fh.provincename,
                    fh.districtname,
                    fh.subdistrictname,
                    fh.facilityname,
                    sg.value AS stockcategory,
                    s.itemname,
                    s.abbreviation,
                    s.inventorycode,
                    s.barcode,
                    su.current_level AS "stock level",
                    su.stock_received AS "stock received",
                    su.stock_lost AS "stock lost",
                        CASE
                            WHEN ((COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.first_stockout_date, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.first_stockout_date
                            ELSE NULL::timestamp without time zone
                        END AS first_stockout_date,
                        CASE
                            WHEN ((COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) >= '1900-01-01 00:00:00'::timestamp without time zone) AND (COALESCE(su.stockout_reported_to_pdm, ((now())::date)::timestamp without time zone) <= '2100-01-01 00:00:00'::timestamp without time zone)) THEN su.stockout_reported_to_pdm
                            ELSE NULL::timestamp without time zone
                        END AS stockout_reported_to_pdm,
                    fh._facilityid,
                    s._id_ AS stock_uuid,
                    su._id_ AS stockupdate_uuid,
                    fs._id_ AS facilitystock_uuid
                   FROM ((((zambia__svs_001.stockupdate su
                     JOIN facilityhierarchy fh ON ((su.stockupdate_facility_fk = fh._facilityid)))
                     JOIN zambia__svs_001.facilitystock fs ON (((fs.facilitystock_facility_fk = fh._facilityid) AND (fs.facilitystock_stock_fk = su.stockupdate_stock_fk) AND (fs.deleted = 'No'::text))))
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON ((s.stock_stringgroup_fk = sg._id_)))
                  WHERE ((su.stockupdate_facility_fk IS NOT NULL) AND (sg.value = ANY (ARRAY['ARV'::text, 'TB'::text, 'Vacc'::text])) AND ((s.inventorycode = '@inventorycode'::text) OR ("left"('@inventorycode'::text, 1) = '@'::text)))) q
        ), qnationalstockupdatelevels AS (
         SELECT asu.provincename,
            asu.districtname,
            asu.subdistrictname,
            asu.facilityname,
            asu.stockcategory,
            asu.itemname,
            asu.abbreviation,
            asu.inventorycode,
            asu.barcode,
            asu."timestamp",
            asu.update_date AS last_stock_out_update_datetime,
            asu."stock level",
            asu."stock received",
            asu."stock lost",
            asu.expiry_date,
            asu.first_stockout_date,
            asu.stockout_reported_to_pdm,
            asu.days_since_first_stockout,
            asu.days_since_last_update_timestamp,
            asu.days_since_stockout_reported_to_pdm_timestamp,
            asu.current_stock_out,
            asu._facilityid,
            asu.stock_uuid,
            asu.stockupdate_uuid,
            asu.facilitystock_uuid
           FROM (qnationalstockupdates_new asu
             JOIN ( SELECT qnationalstockupdates_new._facilityid,
                    qnationalstockupdates_new.stock_uuid,
                    max(qnationalstockupdates_new."timestamp") AS mxt
                   FROM qnationalstockupdates_new
                  GROUP BY qnationalstockupdates_new._facilityid, qnationalstockupdates_new.stock_uuid) mud ON (((asu._facilityid = mud._facilityid) AND (asu.stock_uuid = mud.stock_uuid) AND (asu."timestamp" = mud.mxt))))
        ), nationalstockoutdurationitemsfacility AS (
         SELECT qnationalstockupdatelevels.stockcategory,
            qnationalstockupdatelevels.itemname,
            qnationalstockupdatelevels.inventorycode,
            qnationalstockupdatelevels.barcode,
            qnationalstockupdatelevels.first_stockout_date,
            qnationalstockupdatelevels.last_stock_out_update_datetime,
            qnationalstockupdatelevels.stockout_reported_to_pdm,
            qnationalstockupdatelevels.facilityname AS location,
            qnationalstockupdatelevels.days_since_first_stockout,
            qnationalstockupdatelevels.days_since_last_update_timestamp,
            qnationalstockupdatelevels.days_since_stockout_reported_to_pdm_timestamp,
            qnationalstockupdatelevels._facilityid AS facility_uuid,
            qnationalstockupdatelevels.stock_uuid,
            qnationalstockupdatelevels.stockupdate_uuid,
            qnationalstockupdatelevels.facilitystock_uuid,
            NULL::uuid AS province_uuid,
            NULL::uuid AS district_uuid,
            NULL::uuid AS subdistrict_uuid
           FROM qnationalstockupdatelevels
          WHERE (qnationalstockupdatelevels."stock level" = '0'::text)
          GROUP BY qnationalstockupdatelevels.stockcategory, qnationalstockupdatelevels.itemname, qnationalstockupdatelevels.facilityname, qnationalstockupdatelevels.inventorycode, qnationalstockupdatelevels.barcode, qnationalstockupdatelevels.first_stockout_date, qnationalstockupdatelevels.last_stock_out_update_datetime, qnationalstockupdatelevels.days_since_first_stockout, qnationalstockupdatelevels.days_since_last_update_timestamp, qnationalstockupdatelevels.days_since_stockout_reported_to_pdm_timestamp, qnationalstockupdatelevels.stockout_reported_to_pdm, qnationalstockupdatelevels._facilityid, qnationalstockupdatelevels.stock_uuid, qnationalstockupdatelevels.stockupdate_uuid, qnationalstockupdatelevels.facilitystock_uuid
          ORDER BY qnationalstockupdatelevels.stockcategory, qnationalstockupdatelevels.itemname, qnationalstockupdatelevels.facilityname, qnationalstockupdatelevels.inventorycode, qnationalstockupdatelevels.barcode, qnationalstockupdatelevels.last_stock_out_update_datetime, qnationalstockupdatelevels.days_since_first_stockout, qnationalstockupdatelevels.days_since_last_update_timestamp, qnationalstockupdatelevels.stockout_reported_to_pdm, qnationalstockupdatelevels._facilityid
        )
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    nationalstockoutdurationitemsfacility.stockcategory,
    nationalstockoutdurationitemsfacility.itemname,
    nationalstockoutdurationitemsfacility.inventorycode,
    nationalstockoutdurationitemsfacility.barcode,
    nationalstockoutdurationitemsfacility.first_stockout_date,
    nationalstockoutdurationitemsfacility.last_stock_out_update_datetime,
    nationalstockoutdurationitemsfacility.stockout_reported_to_pdm,
    nationalstockoutdurationitemsfacility.location,
    nationalstockoutdurationitemsfacility.days_since_first_stockout,
    nationalstockoutdurationitemsfacility.days_since_last_update_timestamp,
    nationalstockoutdurationitemsfacility.days_since_stockout_reported_to_pdm_timestamp,
    nationalstockoutdurationitemsfacility.stock_uuid,
    nationalstockoutdurationitemsfacility.facility_uuid,
    nationalstockoutdurationitemsfacility.stockupdate_uuid,
    nationalstockoutdurationitemsfacility.facilitystock_uuid,
    nationalstockoutdurationitemsfacility.subdistrict_uuid,
    nationalstockoutdurationitemsfacility.district_uuid,
    nationalstockoutdurationitemsfacility.province_uuid
   FROM nationalstockoutdurationitemsfacility;


--
-- Name: stockresponseratesubdistrictview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.stockresponseratesubdistrictview_actual AS
 SELECT subdistrict._id_,
    now() AS _tstamp_,
    submissions.week_start,
    submissions.week_end,
    subdistrict.name AS subdistrict_name,
    (submissions.total_facilities)::integer AS num_facilities,
    (submissions.response_count)::integer AS facilities_responded,
    (submissions.average_updates)::integer AS avrg_num_submissions,
    (submissions.total_updates)::integer AS num_stock_updates,
    subdistrict._id_ AS stockresponserateview_subdistrict_fk
   FROM (zambia__svs_001.subdistrict
     JOIN ( SELECT updates.subdistrict_id_,
            updates.week_start,
            updates.week_end,
            count(DISTINCT updates.facility_id_) AS response_count,
            round(avg(updates.total_updates), 0) AS average_updates,
            sum(updates.total_updates) AS total_updates,
            loaded_facilities.total_facilities
           FROM (( SELECT facility._id_ AS facility_id_,
                    facility.facility_subdistrict_fk AS subdistrict_id_,
                    update_week.week_start,
                    update_week.week_end,
                    count(stockupdate._id_) AS total_updates
                   FROM ((zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility ON ((stockupdate.stockupdate_facility_fk = facility._id_)))
                     JOIN ( SELECT (week_start_days.week_start + '22:00:00'::interval) AS week_start,
                            ((week_start_days.week_start + '7 days'::interval) + '08:00:00'::interval) AS week_end
                           FROM ( SELECT generate_series((((now())::date - ((((date_part('dow'::text, now()))::character varying)::text || ' day'::text))::interval) - '378 days'::interval), ((now())::date)::timestamp without time zone, '7 days'::interval) AS week_start) week_start_days) update_week ON (((stockupdate.update_date >= update_week.week_start) AND (stockupdate.update_date <= update_week.week_end))))
                  GROUP BY facility._id_, facility.facility_subdistrict_fk, update_week.week_start, update_week.week_end) updates
             JOIN ( SELECT facility.facility_subdistrict_fk AS subdistrict_id_,
                    count(facility._id_) AS total_facilities
                   FROM zambia__svs_001.facility
                  WHERE (facility.deleted = 'No'::text)
                  GROUP BY facility.facility_subdistrict_fk) loaded_facilities ON ((loaded_facilities.subdistrict_id_ = updates.subdistrict_id_)))
          GROUP BY updates.subdistrict_id_, updates.week_start, updates.week_end, loaded_facilities.total_facilities) submissions ON ((submissions.subdistrict_id_ = subdistrict._id_)))
  ORDER BY submissions.week_start DESC, submissions.week_end DESC, subdistrict.name;


--
-- Name: stockresponseratesubdistrictview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.stockresponseratesubdistrictview AS
 SELECT stockresponseratesubdistrictview_actual._id_,
    stockresponseratesubdistrictview_actual._tstamp_,
    stockresponseratesubdistrictview_actual.week_start,
    stockresponseratesubdistrictview_actual.week_end,
    stockresponseratesubdistrictview_actual.subdistrict_name,
    stockresponseratesubdistrictview_actual.num_facilities,
    stockresponseratesubdistrictview_actual.facilities_responded,
    stockresponseratesubdistrictview_actual.avrg_num_submissions,
    stockresponseratesubdistrictview_actual.num_stock_updates,
    stockresponseratesubdistrictview_actual.stockresponserateview_subdistrict_fk
   FROM zambia__svs_001.stockresponseratesubdistrictview_actual
  WITH NO DATA;


--
-- Name: stockresponserateview_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.stockresponserateview_actual AS
 SELECT district._id_,
    now() AS _tstamp_,
    submissions.week_start,
    submissions.week_end,
    district.name AS district_name,
    (submissions.total_facilities)::integer AS num_facilities,
    (submissions.response_count)::integer AS facilities_responded,
    (submissions.average_updates)::integer AS avrg_num_submissions,
    (submissions.total_updates)::integer AS num_stock_updates,
    district._id_ AS stockresponserateview_district_fk
   FROM (zambia__svs_001.district
     JOIN ( SELECT updates.district_id_,
            updates.week_start,
            updates.week_end,
            count(DISTINCT updates.facility_id_) AS response_count,
            round(avg(updates.total_updates), 0) AS average_updates,
            sum(updates.total_updates) AS total_updates,
            loaded_facilities.total_facilities
           FROM (( SELECT facility._id_ AS facility_id_,
                    facility.facility_district_fk AS district_id_,
                    update_week.week_start,
                    update_week.week_end,
                    count(stockupdate._id_) AS total_updates
                   FROM ((zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility ON ((stockupdate.stockupdate_facility_fk = facility._id_)))
                     JOIN ( SELECT (week_start_days.week_start + '22:00:00'::interval) AS week_start,
                            ((week_start_days.week_start + '7 days'::interval) + '08:00:00'::interval) AS week_end
                           FROM ( SELECT generate_series((((now())::date - ((((date_part('dow'::text, now()))::character varying)::text || ' day'::text))::interval) - '378 days'::interval), ((now())::date)::timestamp without time zone, '7 days'::interval) AS week_start) week_start_days) update_week ON (((stockupdate.update_date >= update_week.week_start) AND (stockupdate.update_date <= update_week.week_end))))
                  GROUP BY facility._id_, facility.facility_district_fk, update_week.week_start, update_week.week_end) updates
             JOIN ( SELECT facility.facility_district_fk AS district_id_,
                    count(facility._id_) AS total_facilities
                   FROM zambia__svs_001.facility
                  WHERE (facility.deleted = 'No'::text)
                  GROUP BY facility.facility_district_fk) loaded_facilities ON ((loaded_facilities.district_id_ = updates.district_id_)))
          GROUP BY updates.district_id_, updates.week_start, updates.week_end, loaded_facilities.total_facilities) submissions ON ((submissions.district_id_ = district._id_)))
  ORDER BY submissions.week_start DESC, submissions.week_end DESC, district.name;


--
-- Name: stockresponserateview; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.stockresponserateview AS
 SELECT stockresponserateview_actual._id_,
    stockresponserateview_actual._tstamp_,
    stockresponserateview_actual.week_start,
    stockresponserateview_actual.week_end,
    stockresponserateview_actual.district_name,
    stockresponserateview_actual.num_facilities,
    stockresponserateview_actual.facilities_responded,
    stockresponserateview_actual.avrg_num_submissions,
    stockresponserateview_actual.num_stock_updates,
    stockresponserateview_actual.stockresponserateview_district_fk
   FROM zambia__svs_001.stockresponserateview_actual
  WITH NO DATA;


--
-- Name: stockupdate_stocklost_detail; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stockupdate_stocklost_detail (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    description text,
    date_created timestamp without time zone,
    deleted text,
    stock_lost_reason_fk uuid,
    stockupdate_fk uuid,
    facility_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: stockupdatefacilitystockview; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stockupdatefacilitystockview (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    "timestamp" timestamp without time zone,
    update_date timestamp without time zone,
    expiry_date date,
    provincename text,
    districtname text,
    subdistrictname text,
    facilityname text,
    itemname text,
    abbreviation text,
    invetorycode text,
    stock_category text,
    stocklevel text,
    stockreceived text,
    stocklost text,
    first_stockout_date timestamp without time zone,
    stockout_reported_to_pdm_date timestamp without time zone,
    days_since_first_stockout integer,
    days_since_last_update_timestamp integer,
    current_stock_out integer,
    _facilityid uuid,
    _facilitystockid uuid,
    _stockid uuid,
    _stockstringgroupid uuid
);


--
-- Name: storedproc_generatefacilityproductstatus; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.storedproc_generatefacilityproductstatus AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_facility_product_status() AS counter;


--
-- Name: storedproc_generatefacilitystockupdate; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.storedproc_generatefacilitystockupdate AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_facility_stockupdate() AS counter;


--
-- Name: storedproc_generateproductstockupdate; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.storedproc_generateproductstockupdate AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.generate_product_stockupdate() AS counter;


--
-- Name: stringgrouplog; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.stringgrouplog (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    date_created timestamp without time zone,
    date_archived timestamp without time zone,
    archived integer,
    grouptype text,
    description text,
    comment text,
    stringgroup_fk uuid
);


--
-- Name: sub_dpm_facility_stock_level_aggr_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.sub_dpm_facility_stock_level_aggr_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    result integer
);


--
-- Name: sub_dpm_facility_stock_level_aggr_table; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.sub_dpm_facility_stock_level_aggr_table (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    facilityname text,
    facility_status text,
    facility_status_colour text,
    facilitystatusorder integer,
    _subdistrictpharmacymanagerid uuid
);


--
-- Name: submissionattempt; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.submissionattempt (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    accepted text,
    content text,
    notification_sent text,
    sender text,
    dispensarystockmanager_submissionattempt_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: successmatrix_stockavailabilityp; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.successmatrix_stockavailabilityp (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    stockout_count integer,
    stockout_hierarchy_count integer,
    availability_percentage text,
    level text,
    facility_fk uuid,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid
);


--
-- Name: successmatrix_stockbycategory; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.successmatrix_stockbycategory (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text,
    stockout_count integer,
    stockout_hierarchy_count integer,
    availability_percentage text,
    level text,
    category text,
    facility_fk uuid,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid
);


--
-- Name: successmatrix_tenoutofstock; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.successmatrix_tenoutofstock (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    itemname text,
    facility_count integer,
    name text,
    level text,
    stock_fk uuid,
    facility_fk uuid,
    subdistrict_fk uuid,
    district_fk uuid,
    province_fk uuid
);


--
-- Name: supplier; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.supplier (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    code text,
    gps_longitude numeric,
    gps_latitude numeric,
    deleted text,
    date_created timestamp without time zone,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: suppliervendor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.suppliervendor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    edited timestamp without time zone,
    date_created timestamp without time zone,
    deleted text,
    suppliervendor_vendor_fk uuid,
    suppliervendor_supplier_fk uuid,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: surveilanceupdates_aggr_materialized; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.surveilanceupdates_aggr_materialized (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    hierarchy_name text,
    reported_cases integer,
    month_cases integer,
    year_cases integer,
    alltime_cases integer,
    _facilityid_fk uuid,
    _provinceid_fk uuid,
    _districtid_fk uuid,
    _subdistrictid_fk uuid,
    report_category text,
    report_type text
);


--
-- Name: surveilanceupdates_levels_materialized_view_actual; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.surveilanceupdates_levels_materialized_view_actual AS
 WITH facilityhierarchy AS (
         SELECT p._id_ AS _provinceid_fk,
            p.name AS provincename,
            d._id_ AS _districtid_fk,
            d.name AS districtname,
            sd._id_ AS _subdistrictid_fk,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid_fk,
            f.name AS facilityname,
            f._id_,
            f._tstamp_,
            f.name,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
            f.deleted,
            f.mustexit,
            f.date_created,
            f.updatedon,
            f.enrollment_allowed_access_x,
            f.enrollment_enrolled_x,
            f.enrollment_journey_launcher_version_x,
            f.enrollment_device_os_x,
            f.enrollment_device_model_x,
            f.enrollment_last_connected_x,
            f.enrollment_barcode_x,
            f.jira,
            f.enrollment_perform_re_enrollment_x,
            f.enrollment_re_enrollment_last_processed_x,
            f.sig_image,
            f.sig_image_blob,
            f.defaultpasswordupdated,
            f.appversion,
            f.upgradeddate,
            f.enrollmentallowedaccess,
            f.enrollmentenrolled,
            f.enrollmentjourneylauncherversion,
            f.enrollmentdeviceos,
            f.enrollmentdevicemodel,
            f.enrollmentlastconnected,
            f.enrollmentbarcode,
            f.enrollmenturl,
            f.enrollmentreenrollment,
            f.enrollmentlastprocessed,
            f.enrollmentbarcodezr,
            f.enrollmentsms,
            f.enrollmentnotification,
            f.sig_image_fname__,
            f.sig_image_mtype__,
            f.sig_image_size__,
            f.sig_image_blob_fname__,
            f.sig_image_blob_mtype__,
            f.sig_image_blob_size__,
            f.facility_district_fk,
            f.facility_subdistrict_fk,
            f._tx_id_,
            f._change_type_,
            f._change_seq_,
            f.hasdevice,
            f.flagged_reason
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
        ), nationalsurveilanceupdates_source AS (
         SELECT ro._id_,
            ro._tstamp_,
            fh.provincename,
            fh.districtname,
            fh.subdistrictname,
            fh.facilityname,
            rc.name AS report_category,
            rt.name AS report_type,
            ro.reported_cases,
            ro.date_time,
            ((date_part('epoch'::text, age(now(), COALESCE((ro.date_time)::timestamp with time zone, now()))) / (((60 * 60) * 24))::double precision))::integer AS days_since_last_update_timestamp,
            fh._facilityid_fk,
            rt._id_ AS _reporttypeid_fk,
            rc._id_ AS _reportcategoryid_fk,
            fh._provinceid_fk,
            fh._districtid_fk,
            fh._subdistrictid_fk
           FROM ((((zambia__svs_001.report_object ro
             LEFT JOIN zambia__svs_001.report_type rt ON ((ro.report_type_fk = rt._id_)))
             LEFT JOIN zambia__svs_001.report_category rc ON ((rt.report_category_fk = rc._id_)))
             LEFT JOIN facilityhierarchy fh ON ((ro.facility_fk = fh._id_)))
             LEFT JOIN zambia__svs_001.report_facility_type rft ON (((fh._id_ = rft.facility_fk) AND (ro.report_facility_type_fk = rft._id_) AND (rft.deleted = 'No'::text))))
          WHERE (ro.facility_fk IS NOT NULL)
        ), nationalsurveilanceupdates_source_latest AS (
         SELECT public.uuid_generate_v4() AS _id_,
            now() AS _tstamp_,
            row_number() OVER (PARTITION BY ro_n._facilityid_fk, mxro._reporttypeid_fk ORDER BY ro_n._tstamp_ DESC) AS "row",
            ro_n.provincename,
            ro_n.districtname,
            ro_n.subdistrictname,
            ro_n.facilityname,
            ro_n.report_category,
            ro_n.report_type,
            ro_n.date_time,
            ro_n.days_since_last_update_timestamp,
            ro_n.reported_cases,
            COALESCE((monthofloaded.month_cases)::integer, 0) AS month_cases,
            COALESCE((yearloaded.year_cases)::integer, 0) AS year_cases,
            COALESCE((alltime.alltime_cases)::integer, 0) AS alltime_cases,
            ro_n._facilityid_fk,
            ro_n._reporttypeid_fk,
            ro_n._reportcategoryid_fk,
            ro_n._provinceid_fk,
            ro_n._districtid_fk,
            ro_n._subdistrictid_fk
           FROM ((((nationalsurveilanceupdates_source ro_n
             LEFT JOIN ( SELECT nationalsurveilanceupdates_source._facilityid_fk,
                    nationalsurveilanceupdates_source._reporttypeid_fk,
                    max(nationalsurveilanceupdates_source.date_time) AS latest_date
                   FROM nationalsurveilanceupdates_source
                  GROUP BY nationalsurveilanceupdates_source._facilityid_fk, nationalsurveilanceupdates_source._reporttypeid_fk) mxro ON (((ro_n._facilityid_fk = mxro._facilityid_fk) AND (mxro._reporttypeid_fk = ro_n._reporttypeid_fk) AND (ro_n.date_time = mxro.latest_date))))
             LEFT JOIN ( SELECT nationalsurveilanceupdates_source._facilityid_fk,
                    nationalsurveilanceupdates_source._reporttypeid_fk,
                    sum((nationalsurveilanceupdates_source.reported_cases)::integer) AS month_cases
                   FROM nationalsurveilanceupdates_source
                  WHERE ((nationalsurveilanceupdates_source.days_since_last_update_timestamp >= 0) AND (nationalsurveilanceupdates_source.days_since_last_update_timestamp <= 31))
                  GROUP BY nationalsurveilanceupdates_source._facilityid_fk, nationalsurveilanceupdates_source._reporttypeid_fk) monthofloaded ON (((ro_n._facilityid_fk = monthofloaded._facilityid_fk) AND (monthofloaded._reporttypeid_fk = ro_n._reporttypeid_fk))))
             LEFT JOIN ( SELECT nationalsurveilanceupdates_source._facilityid_fk,
                    nationalsurveilanceupdates_source._reporttypeid_fk,
                    sum((nationalsurveilanceupdates_source.reported_cases)::integer) AS year_cases
                   FROM nationalsurveilanceupdates_source
                  WHERE ((nationalsurveilanceupdates_source.days_since_last_update_timestamp >= '-1000'::integer) AND (nationalsurveilanceupdates_source.days_since_last_update_timestamp <= 365))
                  GROUP BY nationalsurveilanceupdates_source._facilityid_fk, nationalsurveilanceupdates_source._reporttypeid_fk) yearloaded ON (((ro_n._facilityid_fk = yearloaded._facilityid_fk) AND (yearloaded._reporttypeid_fk = ro_n._reporttypeid_fk))))
             LEFT JOIN ( SELECT nationalsurveilanceupdates_source._facilityid_fk,
                    nationalsurveilanceupdates_source._reporttypeid_fk,
                    sum((nationalsurveilanceupdates_source.reported_cases)::integer) AS alltime_cases
                   FROM nationalsurveilanceupdates_source
                  GROUP BY nationalsurveilanceupdates_source._facilityid_fk, nationalsurveilanceupdates_source._reporttypeid_fk) alltime ON (((ro_n._facilityid_fk = alltime._facilityid_fk) AND (alltime._reporttypeid_fk = ro_n._reporttypeid_fk))))
        )
 SELECT nationalsurveilanceupdates_source_latest._id_,
    nationalsurveilanceupdates_source_latest._tstamp_,
    nationalsurveilanceupdates_source_latest."row",
    nationalsurveilanceupdates_source_latest.provincename,
    nationalsurveilanceupdates_source_latest.districtname,
    nationalsurveilanceupdates_source_latest.subdistrictname,
    nationalsurveilanceupdates_source_latest.facilityname,
    nationalsurveilanceupdates_source_latest.report_category,
    nationalsurveilanceupdates_source_latest.report_type,
    nationalsurveilanceupdates_source_latest.date_time,
    nationalsurveilanceupdates_source_latest.days_since_last_update_timestamp,
    nationalsurveilanceupdates_source_latest.reported_cases,
    nationalsurveilanceupdates_source_latest.month_cases,
    nationalsurveilanceupdates_source_latest.year_cases,
    nationalsurveilanceupdates_source_latest.alltime_cases,
    nationalsurveilanceupdates_source_latest._facilityid_fk,
    nationalsurveilanceupdates_source_latest._reporttypeid_fk,
    nationalsurveilanceupdates_source_latest._reportcategoryid_fk,
    nationalsurveilanceupdates_source_latest._provinceid_fk,
    nationalsurveilanceupdates_source_latest._districtid_fk,
    nationalsurveilanceupdates_source_latest._subdistrictid_fk
   FROM nationalsurveilanceupdates_source_latest;


--
-- Name: surveilanceupdates_levels_materialized_view; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.surveilanceupdates_levels_materialized_view AS
 SELECT surveilanceupdates_levels_materialized_view_actual._id_,
    surveilanceupdates_levels_materialized_view_actual._tstamp_,
    surveilanceupdates_levels_materialized_view_actual."row",
    surveilanceupdates_levels_materialized_view_actual.provincename,
    surveilanceupdates_levels_materialized_view_actual.districtname,
    surveilanceupdates_levels_materialized_view_actual.subdistrictname,
    surveilanceupdates_levels_materialized_view_actual.facilityname,
    surveilanceupdates_levels_materialized_view_actual.report_category,
    surveilanceupdates_levels_materialized_view_actual.report_type,
    surveilanceupdates_levels_materialized_view_actual.date_time,
    surveilanceupdates_levels_materialized_view_actual.days_since_last_update_timestamp,
    surveilanceupdates_levels_materialized_view_actual.reported_cases,
    surveilanceupdates_levels_materialized_view_actual.month_cases,
    surveilanceupdates_levels_materialized_view_actual.year_cases,
    surveilanceupdates_levels_materialized_view_actual.alltime_cases,
    surveilanceupdates_levels_materialized_view_actual._facilityid_fk,
    surveilanceupdates_levels_materialized_view_actual._reporttypeid_fk,
    surveilanceupdates_levels_materialized_view_actual._reportcategoryid_fk,
    surveilanceupdates_levels_materialized_view_actual._provinceid_fk,
    surveilanceupdates_levels_materialized_view_actual._districtid_fk,
    surveilanceupdates_levels_materialized_view_actual._subdistrictid_fk
   FROM zambia__svs_001.surveilanceupdates_levels_materialized_view_actual
  WITH NO DATA;


--
-- Name: surveilanceupdates_aggr_materialized_view; Type: MATERIALIZED VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE MATERIALIZED VIEW zambia__svs_001.surveilanceupdates_aggr_materialized_view AS
 WITH facilityhierarchy AS (
         SELECT p._id_ AS _provinceid,
            p.name AS provincename,
            d._id_ AS _districtid,
            d.name AS districtname,
            sd._id_ AS _subdistrictid,
            sd.name AS subdistrictname,
            f._id_ AS _facilityid_fk,
            f.name AS facilityname,
            f._id_,
            f._tstamp_,
            f.name,
            f.code,
            f.mobile,
            f.gps_longitude,
            f.gps_latitude,
            f.deleted,
            f.mustexit,
            f.date_created,
            f.updatedon,
            f.enrollment_allowed_access_x,
            f.enrollment_enrolled_x,
            f.enrollment_journey_launcher_version_x,
            f.enrollment_device_os_x,
            f.enrollment_device_model_x,
            f.enrollment_last_connected_x,
            f.enrollment_barcode_x,
            f.jira,
            f.enrollment_perform_re_enrollment_x,
            f.enrollment_re_enrollment_last_processed_x,
            f.sig_image,
            f.sig_image_blob,
            f.defaultpasswordupdated,
            f.appversion,
            f.upgradeddate,
            f.enrollmentallowedaccess,
            f.enrollmentenrolled,
            f.enrollmentjourneylauncherversion,
            f.enrollmentdeviceos,
            f.enrollmentdevicemodel,
            f.enrollmentlastconnected,
            f.enrollmentbarcode,
            f.enrollmenturl,
            f.enrollmentreenrollment,
            f.enrollmentlastprocessed,
            f.enrollmentbarcodezr,
            f.enrollmentsms,
            f.enrollmentnotification,
            f.sig_image_fname__,
            f.sig_image_mtype__,
            f.sig_image_size__,
            f.sig_image_blob_fname__,
            f.sig_image_blob_mtype__,
            f.sig_image_blob_size__,
            f.facility_district_fk,
            f.facility_subdistrict_fk,
            f._tx_id_,
            f._change_type_,
            f._change_seq_,
            f.hasdevice,
            f.flagged_reason
           FROM (((zambia__svs_001.facility f
             LEFT JOIN zambia__svs_001.subdistrict sd ON ((sd._id_ = f.facility_subdistrict_fk)))
             LEFT JOIN zambia__svs_001.district d ON ((d._id_ = sd.subdistrict_district_fk)))
             LEFT JOIN zambia__svs_001.province p ON ((p._id_ = d.district_province_fk)))
          WHERE ((f.deleted = 'No'::text) AND ((lower(p.name) ~~ lower('%@provincename%'::text)) OR ("left"('@provincename'::text, 1) = '@'::text)) AND (p.name <> 'Training Demos'::text))
        ), nationalsurveilanceupdates_source_latest AS (
         SELECT ro_n.provincename,
            ro_n.districtname,
            ro_n.subdistrictname,
            ro_n.facilityname,
            ro_n.report_category,
            ro_n.report_type,
            ro_n.reported_cases,
            ro_n.month_cases,
            ro_n.year_cases,
            ro_n.alltime_cases,
            ro_n.date_time,
            ro_n._facilityid_fk,
            ro_n._subdistrictid_fk,
            ro_n._districtid_fk,
            ro_n._provinceid_fk,
            ro_n._reporttypeid_fk,
            ro_n._reportcategoryid_fk
           FROM zambia__svs_001.surveilanceupdates_levels_materialized_view ro_n
        ), surveilancefacilitiesreportingratesummarysubdistrict AS (
         SELECT sd.name AS hierarchy_name,
            count(DISTINCT rp._facilityid_fk) AS number_of_facilitiesloaded,
            rp.report_category,
            rp.report_type,
            sum(rp.month_cases) AS month_cases,
            sum(rp.year_cases) AS year_cases,
            sum(rp.alltime_cases) AS alltime_cases,
            rp._subdistrictid_fk,
            NULL::uuid AS _districtid_fk,
            NULL::uuid AS _proviceid_fk
           FROM (zambia__svs_001.subdistrict sd
             JOIN nationalsurveilanceupdates_source_latest rp ON ((sd._id_ = rp._subdistrictid_fk)))
          GROUP BY rp.report_category, rp.report_type, sd.name, rp._subdistrictid_fk, NULL::uuid
          ORDER BY sd.name
        ), surveilancefacilitiesreportingratesummarydistrict AS (
         SELECT rp.districtname AS hierarchy_name,
            count(DISTINCT rp._facilityid_fk) AS number_of_facilitiesloaded,
            rp.report_category,
            rp.report_type,
            (sum(rp.month_cases))::integer AS month_cases,
            sum(rp.year_cases) AS year_cases,
            (sum(rp.alltime_cases))::integer AS alltime_cases,
            NULL::uuid AS sub_districtid_fk,
            rp._districtid_fk,
            NULL::uuid AS _proviceid_fk
           FROM (zambia__svs_001.district d
             JOIN nationalsurveilanceupdates_source_latest rp ON ((d._id_ = rp._districtid_fk)))
          GROUP BY rp.report_category, rp.report_type, rp.districtname, NULL::uuid, rp._districtid_fk
          ORDER BY rp.districtname
        ), surveilancefacilitiesreportingratesummaryprovince AS (
         SELECT rp.provincename AS hierarchy_name,
            count(DISTINCT rp._facilityid_fk) AS number_of_facilitiesloaded,
            rp.report_category,
            rp.report_type,
            sum(rp.month_cases) AS month_cases,
            sum(rp.year_cases) AS year_cases,
            sum(rp.alltime_cases) AS alltime_cases,
            NULL::uuid AS sub_districtid_fk,
            NULL::uuid AS _districtid_fk,
            rp._provinceid_fk
           FROM (zambia__svs_001.province p
             JOIN nationalsurveilanceupdates_source_latest rp ON ((p._id_ = rp._provinceid_fk)))
          GROUP BY rp.report_category, rp.report_type, rp.provincename, NULL::uuid, rp._provinceid_fk
          ORDER BY rp.provincename
        ), surveilancefacilitiesreportingratesummarynational AS (
         SELECT surveilancefacilitiesreportingratesummarysubdistrict.hierarchy_name,
            surveilancefacilitiesreportingratesummarysubdistrict.number_of_facilitiesloaded,
            surveilancefacilitiesreportingratesummarysubdistrict.report_category,
            surveilancefacilitiesreportingratesummarysubdistrict.report_type,
            surveilancefacilitiesreportingratesummarysubdistrict.month_cases,
            surveilancefacilitiesreportingratesummarysubdistrict.year_cases,
            surveilancefacilitiesreportingratesummarysubdistrict.alltime_cases,
            surveilancefacilitiesreportingratesummarysubdistrict._subdistrictid_fk,
            surveilancefacilitiesreportingratesummarysubdistrict._districtid_fk,
            surveilancefacilitiesreportingratesummarysubdistrict._proviceid_fk
           FROM surveilancefacilitiesreportingratesummarysubdistrict
        UNION
         SELECT surveilancefacilitiesreportingratesummarydistrict.hierarchy_name,
            surveilancefacilitiesreportingratesummarydistrict.number_of_facilitiesloaded,
            surveilancefacilitiesreportingratesummarydistrict.report_category,
            surveilancefacilitiesreportingratesummarydistrict.report_type,
            surveilancefacilitiesreportingratesummarydistrict.month_cases,
            surveilancefacilitiesreportingratesummarydistrict.year_cases,
            surveilancefacilitiesreportingratesummarydistrict.alltime_cases,
            surveilancefacilitiesreportingratesummarydistrict.sub_districtid_fk,
            surveilancefacilitiesreportingratesummarydistrict._districtid_fk,
            surveilancefacilitiesreportingratesummarydistrict._proviceid_fk
           FROM surveilancefacilitiesreportingratesummarydistrict
        UNION
         SELECT surveilancefacilitiesreportingratesummaryprovince.hierarchy_name,
            surveilancefacilitiesreportingratesummaryprovince.number_of_facilitiesloaded,
            surveilancefacilitiesreportingratesummaryprovince.report_category,
            surveilancefacilitiesreportingratesummaryprovince.report_type,
            surveilancefacilitiesreportingratesummaryprovince.month_cases,
            surveilancefacilitiesreportingratesummaryprovince.year_cases,
            surveilancefacilitiesreportingratesummaryprovince.alltime_cases,
            surveilancefacilitiesreportingratesummaryprovince.sub_districtid_fk,
            surveilancefacilitiesreportingratesummaryprovince._districtid_fk,
            surveilancefacilitiesreportingratesummaryprovince._provinceid_fk
           FROM surveilancefacilitiesreportingratesummaryprovince
        )
 SELECT surveilancefacilitiesreportingratesummarynational.hierarchy_name,
    surveilancefacilitiesreportingratesummarynational.number_of_facilitiesloaded,
    surveilancefacilitiesreportingratesummarynational.report_category,
    surveilancefacilitiesreportingratesummarynational.report_type,
    surveilancefacilitiesreportingratesummarynational.month_cases,
    surveilancefacilitiesreportingratesummarynational.year_cases,
    surveilancefacilitiesreportingratesummarynational.alltime_cases,
    surveilancefacilitiesreportingratesummarynational._subdistrictid_fk,
    surveilancefacilitiesreportingratesummarynational._districtid_fk,
    surveilancefacilitiesreportingratesummarynational._proviceid_fk
   FROM surveilancefacilitiesreportingratesummarynational
  WITH NO DATA;


--
-- Name: surveilanceupdates_levels_materialized_wiew; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.surveilanceupdates_levels_materialized_wiew (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    _provinceid uuid,
    _districtid uuid,
    _subdistrictid uuid,
    _facilityid uuid
);


--
-- Name: svs_zambia_facility_stockupdate_add_star_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.svs_zambia_facility_stockupdate_add_star_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.facility_stockupdate_add_star_for_non_deployed() AS result;


--
-- Name: svs_zambia_facility_update_executor; Type: VIEW; Schema: zambia__svs_001; Owner: -
--

CREATE VIEW zambia__svs_001.svs_zambia_facility_update_executor AS
 SELECT public.uuid_generate_v4() AS _id_,
    now() AS _tstamp_,
    zambia__svs_001.facility_stockupdate_add_star_for_non_deployed() AS result;


--
-- Name: svsreconreport; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.svsreconreport (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    rownum integer,
    description text,
    count integer
);


--
-- Name: svsreconreport_aggregation_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.svsreconreport_aggregation_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: svsshadowcompare; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.svsshadowcompare (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    provincename text,
    districtname text,
    subdistrictname text,
    facilityname text,
    "timestamp" timestamp without time zone,
    reportinghasstockouts boolean,
    _facilityid uuid
);


--
-- Name: svsshadowcompare_aggregation_executor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.svsshadowcompare_aggregation_executor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    counter integer
);


--
-- Name: tableaulatesttstamp_object; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.tableaulatesttstamp_object (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    "timestamp" timestamp without time zone,
    update_date timestamp without time zone
);


--
-- Name: temprecord; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.temprecord (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    capturetstamp timestamp without time zone,
    capture_year integer,
    capture_month integer,
    capture_day integer,
    capture_hour integer,
    capture_minute integer,
    capture_second integer,
    temp numeric,
    abnormaltemp text,
    abovenormaltemp text,
    belownormaltemp text,
    abnormaltemp_reason text,
    abnormaltemp_desc text,
    smssent text,
    record_fridge_fk uuid
);


--
-- Name: tripsheet; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.tripsheet (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    tripsheet_uuid text,
    tripsheet_number text,
    dispatch_date timestamp without time zone,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: vehicle; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.vehicle (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    registration_number text,
    vin_number text,
    make text,
    model text,
    category text,
    courier_company text,
    date_created timestamp without time zone,
    deleted text
);


--
-- Name: vendor; Type: TABLE; Schema: zambia__svs_001; Owner: -
--

CREATE TABLE zambia__svs_001.vendor (
    _id_ uuid NOT NULL,
    _tstamp_ timestamp without time zone NOT NULL,
    name text NOT NULL,
    contactnum text NOT NULL,
    contactemail text,
    code text,
    gps_longitude numeric,
    gps_latitude numeric,
    deleted text,
    date_created timestamp without time zone,
    _tx_id_ bigint DEFAULT txid_current() NOT NULL,
    _change_type_ zambia__svs_001.__he_obj_change_type__ DEFAULT 'create'::zambia__svs_001.__he_obj_change_type__ NOT NULL,
    _change_seq_ bigint DEFAULT nextval('zambia__svs_001.__he_sync_change_seq__'::regclass) NOT NULL
);


--
-- Name: __he_data_version__ id; Type: DEFAULT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_data_version__ ALTER COLUMN id SET DEFAULT nextval('zambia__svs_001.__he_data_version___id_seq'::regclass);


--
-- Name: __facilityproductstatusviewoutput__ __facilityproductstatusviewoutput___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__facilityproductstatusviewoutput__
    ADD CONSTRAINT __facilityproductstatusviewoutput___pkey PRIMARY KEY (_id_);


--
-- Name: __facilitystockupdateoutput__ __facilitystockupdateoutput___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__facilitystockupdateoutput__
    ADD CONSTRAINT __facilitystockupdateoutput___pkey PRIMARY KEY (_id_);


--
-- Name: __he_data_version__ __he_data_version___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_data_version__
    ADD CONSTRAINT __he_data_version___pkey PRIMARY KEY (id);


--
-- Name: __he_meta_data_version__ __he_meta_data_version___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_meta_data_version__
    ADD CONSTRAINT __he_meta_data_version___pkey PRIMARY KEY (id);


--
-- Name: __he_sync_bookmark__ __he_sync_bookmark___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_bookmark__
    ADD CONSTRAINT __he_sync_bookmark___pkey PRIMARY KEY (tx_id);


--
-- Name: __he_sync_bookmark_current__ __he_sync_bookmark_current___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_bookmark_current__
    ADD CONSTRAINT __he_sync_bookmark_current___pkey PRIMARY KEY (tx_id);


--
-- Name: __he_sync_client__ __he_sync_client___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_client__
    ADD CONSTRAINT __he_sync_client___pkey PRIMARY KEY (client_id);


--
-- Name: __he_sync_client_request_log__ __he_sync_client_request_log___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_client_request_log__
    ADD CONSTRAINT __he_sync_client_request_log___pkey PRIMARY KEY (tx_id);


--
-- Name: __he_sync_client_request_log_current__ __he_sync_client_request_log_current___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_client_request_log_current__
    ADD CONSTRAINT __he_sync_client_request_log_current___pkey PRIMARY KEY (tx_id);


--
-- Name: __he_sync_many_to_many_unlink__ __he_sync_many_to_many_unlink___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_many_to_many_unlink__
    ADD CONSTRAINT __he_sync_many_to_many_unlink___pkey PRIMARY KEY (seq);


--
-- Name: __he_sync_many_to_many_unlink_current__ __he_sync_many_to_many_unlink_current___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_many_to_many_unlink_current__
    ADD CONSTRAINT __he_sync_many_to_many_unlink_current___pkey PRIMARY KEY (seq);


--
-- Name: __he_sync_obj_change__ __he_sync_obj_change___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_obj_change__
    ADD CONSTRAINT __he_sync_obj_change___pkey PRIMARY KEY (seq);


--
-- Name: __he_sync_obj_change_current__ __he_sync_obj_change_current___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_obj_change_current__
    ADD CONSTRAINT __he_sync_obj_change_current___pkey PRIMARY KEY (seq);


--
-- Name: __he_sync_transaction_log__ __he_sync_transaction_log___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_transaction_log__
    ADD CONSTRAINT __he_sync_transaction_log___pkey PRIMARY KEY (tx_id);


--
-- Name: __he_sync_transaction_log_current__ __he_sync_transaction_log_current___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_transaction_log_current__
    ADD CONSTRAINT __he_sync_transaction_log_current___pkey PRIMARY KEY (tx_id);


--
-- Name: __identity_invite_user__ __identity_invite_user___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__identity_invite_user__
    ADD CONSTRAINT __identity_invite_user___pkey PRIMARY KEY (_id_);


--
-- Name: __identity_remove_role__ __identity_remove_role___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__identity_remove_role__
    ADD CONSTRAINT __identity_remove_role___pkey PRIMARY KEY (_id_);


--
-- Name: __logging_log__ __logging_log___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__logging_log__
    ADD CONSTRAINT __logging_log___pkey PRIMARY KEY (_id_);


--
-- Name: __ndoh_message_log__ __ndoh_message_log___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__ndoh_message_log__
    ADD CONSTRAINT __ndoh_message_log___pkey PRIMARY KEY (_id_);


--
-- Name: __notification_email__ __notification_email___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_email__
    ADD CONSTRAINT __notification_email___pkey PRIMARY KEY (_id_);


--
-- Name: __notification_email_attachment__ __notification_email_attachment___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_email_attachment__
    ADD CONSTRAINT __notification_email_attachment___pkey PRIMARY KEY (_id_);


--
-- Name: __notification_message__ __notification_message___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_message__
    ADD CONSTRAINT __notification_message___pkey PRIMARY KEY (_id_);


--
-- Name: __notification_message_arg__ __notification_message_arg___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_message_arg__
    ADD CONSTRAINT __notification_message_arg___pkey PRIMARY KEY (_id_);


--
-- Name: __notification_sms__ __notification_sms___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_sms__
    ADD CONSTRAINT __notification_sms___pkey PRIMARY KEY (_id_);


--
-- Name: __payment__ __payment___paymentstatus_fk_key; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment__
    ADD CONSTRAINT __payment___paymentstatus_fk_key UNIQUE (paymentstatus_fk);


--
-- Name: __payment__ __payment___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment__
    ADD CONSTRAINT __payment___pkey PRIMARY KEY (_id_);


--
-- Name: __payment_status_record__ __payment_status_record___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment_status_record__
    ADD CONSTRAINT __payment_status_record___pkey PRIMARY KEY (_id_);


--
-- Name: __payment_with_ref__ __payment_with_ref___paymentstatus_fk_key; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment_with_ref__
    ADD CONSTRAINT __payment_with_ref___paymentstatus_fk_key UNIQUE (paymentstatus_fk);


--
-- Name: __payment_with_ref__ __payment_with_ref___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment_with_ref__
    ADD CONSTRAINT __payment_with_ref___pkey PRIMARY KEY (_id_);


--
-- Name: __payment_with_ref_status_record__ __payment_with_ref_status_record___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment_with_ref_status_record__
    ADD CONSTRAINT __payment_with_ref_status_record___pkey PRIMARY KEY (_id_);


--
-- Name: __productstockupdateoutput__ __productstockupdateoutput___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__productstockupdateoutput__
    ADD CONSTRAINT __productstockupdateoutput___pkey PRIMARY KEY (_id_);


--
-- Name: __scheduled_function_result__ __scheduled_function_result___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__scheduled_function_result__
    ADD CONSTRAINT __scheduled_function_result___pkey PRIMARY KEY (_id_);


--
-- Name: __sms_result__ __sms_result___pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__sms_result__
    ADD CONSTRAINT __sms_result___pkey PRIMARY KEY (_id_);


--
-- Name: activitylog activitylog_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.activitylog
    ADD CONSTRAINT activitylog_pkey PRIMARY KEY (_id_);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (_id_);


--
-- Name: asn asn_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.asn
    ADD CONSTRAINT asn_pkey PRIMARY KEY (_id_);


--
-- Name: attachment attachment_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_pkey PRIMARY KEY (_id_);


--
-- Name: batchprocess batchprocess_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.batchprocess
    ADD CONSTRAINT batchprocess_pkey PRIMARY KEY (_id_);


--
-- Name: billingfacilityreport billingfacilityreport_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.billingfacilityreport
    ADD CONSTRAINT billingfacilityreport_pkey PRIMARY KEY (_id_);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (_id_);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (_id_);


--
-- Name: configpair configpair_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.configpair
    ADD CONSTRAINT configpair_pkey PRIMARY KEY (_id_);


--
-- Name: configuration configuration_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.configuration
    ADD CONSTRAINT configuration_pkey PRIMARY KEY (_id_);


--
-- Name: container container_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.container
    ADD CONSTRAINT container_pkey PRIMARY KEY (_id_);


--
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (_id_);


--
-- Name: deliveryattachment deliveryattachment_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.deliveryattachment
    ADD CONSTRAINT deliveryattachment_pkey PRIMARY KEY (_id_);


--
-- Name: deploymentslamanager deploymentslamanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.deploymentslamanager
    ADD CONSTRAINT deploymentslamanager_pkey PRIMARY KEY (_id_);


--
-- Name: dispensarystockmanager dispensarystockmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.dispensarystockmanager
    ADD CONSTRAINT dispensarystockmanager_pkey PRIMARY KEY (_id_);


--
-- Name: district district_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.district
    ADD CONSTRAINT district_pkey PRIMARY KEY (_id_);


--
-- Name: districtmanager districtmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtmanager
    ADD CONSTRAINT districtmanager_pkey PRIMARY KEY (_id_);


--
-- Name: districtpharmacymanager districtpharmacymanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtpharmacymanager
    ADD CONSTRAINT districtpharmacymanager_pkey PRIMARY KEY (_id_);


--
-- Name: districtphcmanager districtphcmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtphcmanager
    ADD CONSTRAINT districtphcmanager_pkey PRIMARY KEY (_id_);


--
-- Name: districtstock districtstock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtstock
    ADD CONSTRAINT districtstock_pkey PRIMARY KEY (_id_);


--
-- Name: districtstockmanager districtstockmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtstockmanager
    ADD CONSTRAINT districtstockmanager_pkey PRIMARY KEY (_id_);


--
-- Name: dpm_facility_stock_level_aggr_table dpm_facility_stock_level_aggr_table_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.dpm_facility_stock_level_aggr_table
    ADD CONSTRAINT dpm_facility_stock_level_aggr_table_pkey PRIMARY KEY (_id_);


--
-- Name: errorlog errorlog_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.errorlog
    ADD CONSTRAINT errorlog_pkey PRIMARY KEY (_id_);


--
-- Name: extractedsuccessmatrixdata extractedsuccessmatrixdata_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.extractedsuccessmatrixdata
    ADD CONSTRAINT extractedsuccessmatrixdata_pkey PRIMARY KEY (_id_);


--
-- Name: facility facility_last_facilitydeactivationlog_fk_key; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facility
    ADD CONSTRAINT facility_last_facilitydeactivationlog_fk_key UNIQUE (last_facilitydeactivationlog_fk);


--
-- Name: facility facility_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facility
    ADD CONSTRAINT facility_pkey PRIMARY KEY (_id_);


--
-- Name: facilitycompliance_materializedview facilitycompliance_materializedview_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitycompliance_materializedview
    ADD CONSTRAINT facilitycompliance_materializedview_pkey PRIMARY KEY (_id_);


--
-- Name: facilitydeactivation facilitydeactivation_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitydeactivation
    ADD CONSTRAINT facilitydeactivation_pkey PRIMARY KEY (_id_);


--
-- Name: facilitydeactivationlog facilitydeactivationlog_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitydeactivationlog
    ADD CONSTRAINT facilitydeactivationlog_pkey PRIMARY KEY (_id_);


--
-- Name: facilitymanager facilitymanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitymanager
    ADD CONSTRAINT facilitymanager_pkey PRIMARY KEY (_id_);


--
-- Name: facilitystock facilitystock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitystock
    ADD CONSTRAINT facilitystock_pkey PRIMARY KEY (_id_);


--
-- Name: facilitystock_to_sync facilitystock_to_sync_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitystock_to_sync
    ADD CONSTRAINT facilitystock_to_sync_pkey PRIMARY KEY (_id_);


--
-- Name: form_type form_type_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.form_type
    ADD CONSTRAINT form_type_pkey PRIMARY KEY (_id_);


--
-- Name: fridge fridge_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.fridge
    ADD CONSTRAINT fridge_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyaveragestockoutdurationitems heliumonlyaveragestockoutdurationitems_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyaveragestockoutdurationitems
    ADD CONSTRAINT heliumonlyaveragestockoutdurationitems_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlycontactnumberblacklist heliumonlycontactnumberblacklist_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlycontactnumberblacklist
    ADD CONSTRAINT heliumonlycontactnumberblacklist_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyfacilitystatus heliumonlyfacilitystatus_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitystatus
    ADD CONSTRAINT heliumonlyfacilitystatus_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyfacilitywithstockoutitem heliumonlyfacilitywithstockoutitem_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitywithstockoutitem
    ADD CONSTRAINT heliumonlyfacilitywithstockoutitem_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyhierarchystocklevel_aggregation_executor heliumonlyhierarchystocklevel_aggregation_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel_aggregation_executor
    ADD CONSTRAINT heliumonlyhierarchystocklevel_aggregation_executor_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyhierarchystocklevel heliumonlyhierarchystocklevel_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel
    ADD CONSTRAINT heliumonlyhierarchystocklevel_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlylowandoverstockreport heliumonlylowandoverstockreport_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlylowandoverstockreport
    ADD CONSTRAINT heliumonlylowandoverstockreport_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlynationalstockavailability heliumonlynationalstockavailability_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockavailability
    ADD CONSTRAINT heliumonlynationalstockavailability_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlynationalstockoutreasons heliumonlynationalstockoutreasons_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockoutreasons
    ADD CONSTRAINT heliumonlynationalstockoutreasons_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlypdm_facilities_with_stockouts heliumonlypdm_facilities_with_stockouts_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlypdm_facilities_with_stockouts
    ADD CONSTRAINT heliumonlypdm_facilities_with_stockouts_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyreportingaggregate heliumonlyreportingaggregate_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingaggregate
    ADD CONSTRAINT heliumonlyreportingaggregate_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyreportingfacility heliumonlyreportingfacility_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingfacility
    ADD CONSTRAINT heliumonlyreportingfacility_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlystockout heliumonlystockout_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockout
    ADD CONSTRAINT heliumonlystockout_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationitemsforcategory_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationitemsforcategory_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyuseractivitylogging heliumonlyuseractivitylogging_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyuseractivitylogging
    ADD CONSTRAINT heliumonlyuseractivitylogging_pkey PRIMARY KEY (_id_);


--
-- Name: heliumscheduledfunctionanalysis_aggregation_executor heliumscheduledfunctionanalysis_aggregation_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumscheduledfunctionanalysis_aggregation_executor
    ADD CONSTRAINT heliumscheduledfunctionanalysis_aggregation_executor_pkey PRIMARY KEY (_id_);


--
-- Name: heliumscheduledfunctionanalysis heliumscheduledfunctionanalysis_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumscheduledfunctionanalysis
    ADD CONSTRAINT heliumscheduledfunctionanalysis_pkey PRIMARY KEY (_id_);


--
-- Name: heliumscheduledfunctionfailure heliumscheduledfunctionfailure_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumscheduledfunctionfailure
    ADD CONSTRAINT heliumscheduledfunctionfailure_pkey PRIMARY KEY (_id_);


--
-- Name: heliumscheduledfunctionfalure_aggregation_executor heliumscheduledfunctionfalure_aggregation_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumscheduledfunctionfalure_aggregation_executor
    ADD CONSTRAINT heliumscheduledfunctionfalure_aggregation_executor_pkey PRIMARY KEY (_id_);


--
-- Name: heliumscheduledfunctionsummary_aggregation_executor heliumscheduledfunctionsummary_aggregation_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumscheduledfunctionsummary_aggregation_executor
    ADD CONSTRAINT heliumscheduledfunctionsummary_aggregation_executor_pkey PRIMARY KEY (_id_);


--
-- Name: heliumscheduledfunctionsummary heliumscheduledfunctionsummary_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumscheduledfunctionsummary
    ADD CONSTRAINT heliumscheduledfunctionsummary_pkey PRIMARY KEY (_id_);


--
-- Name: heliumweblogin_aggregation_executor heliumweblogin_aggregation_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumweblogin_aggregation_executor
    ADD CONSTRAINT heliumweblogin_aggregation_executor_pkey PRIMARY KEY (_id_);


--
-- Name: heliumweblogin heliumweblogin_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumweblogin
    ADD CONSTRAINT heliumweblogin_pkey PRIMARY KEY (_id_);


--
-- Name: hierachreportattachment hierachreportattachment_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hierachreportattachment
    ADD CONSTRAINT hierachreportattachment_pkey PRIMARY KEY (_id_);


--
-- Name: hod hod_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hod
    ADD CONSTRAINT hod_pkey PRIMARY KEY (_id_);


--
-- Name: hospital hospital_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hospital
    ADD CONSTRAINT hospital_pkey PRIMARY KEY (_id_);


--
-- Name: informationdocument informationdocument_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.informationdocument
    ADD CONSTRAINT informationdocument_pkey PRIMARY KEY (_id_);


--
-- Name: linelevel linelevel_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.linelevel
    ADD CONSTRAINT linelevel_pkey PRIMARY KEY (_id_);


--
-- Name: masteradmin masteradmin_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.masteradmin
    ADD CONSTRAINT masteradmin_pkey PRIMARY KEY (_id_);


--
-- Name: mezbatch mezbatch_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.mezbatch
    ADD CONSTRAINT mezbatch_pkey PRIMARY KEY (_id_);


--
-- Name: mezbatchitem mezbatchitem_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.mezbatchitem
    ADD CONSTRAINT mezbatchitem_pkey PRIMARY KEY (_id_);


--
-- Name: mobiledevice mobiledevice_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.mobiledevice
    ADD CONSTRAINT mobiledevice_pkey PRIMARY KEY (_id_);


--
-- Name: nationalmanager nationalmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.nationalmanager
    ADD CONSTRAINT nationalmanager_pkey PRIMARY KEY (_id_);


--
-- Name: nationalstockadministrator nationalstockadministrator_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.nationalstockadministrator
    ADD CONSTRAINT nationalstockadministrator_pkey PRIMARY KEY (_id_);


--
-- Name: nationalsystemadministrator nationalsystemadministrator_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.nationalsystemadministrator
    ADD CONSTRAINT nationalsystemadministrator_pkey PRIMARY KEY (_id_);


--
-- Name: pdm_facility_outstanding_update pdm_facility_outstanding_update_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.pdm_facility_outstanding_update
    ADD CONSTRAINT pdm_facility_outstanding_update_pkey PRIMARY KEY (_id_);


--
-- Name: poinfo poinfo_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.poinfo
    ADD CONSTRAINT poinfo_pkey PRIMARY KEY (_id_);


--
-- Name: province province_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.province
    ADD CONSTRAINT province_pkey PRIMARY KEY (_id_);


--
-- Name: provincialdepotmanager provincialdepotmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialdepotmanager
    ADD CONSTRAINT provincialdepotmanager_pkey PRIMARY KEY (_id_);


--
-- Name: provincialmanager provincialmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialmanager
    ADD CONSTRAINT provincialmanager_pkey PRIMARY KEY (_id_);


--
-- Name: provincialprogrammedirector provincialprogrammedirector_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialprogrammedirector
    ADD CONSTRAINT provincialprogrammedirector_pkey PRIMARY KEY (_id_);


--
-- Name: provincialstock provincialstock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialstock
    ADD CONSTRAINT provincialstock_pkey PRIMARY KEY (_id_);


--
-- Name: receipt receipt_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.receipt
    ADD CONSTRAINT receipt_pkey PRIMARY KEY (_id_);


--
-- Name: recieptperline recieptperline_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_pkey PRIMARY KEY (_id_);


--
-- Name: refresh_jasperreports_materializedview_executor refresh_jasperreports_materializedview_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.refresh_jasperreports_materializedview_executor
    ADD CONSTRAINT refresh_jasperreports_materializedview_executor_pkey PRIMARY KEY (_id_);


--
-- Name: report_category report_category_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_category
    ADD CONSTRAINT report_category_pkey PRIMARY KEY (_id_);


--
-- Name: report_facility_type report_facility_type_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_facility_type
    ADD CONSTRAINT report_facility_type_pkey PRIMARY KEY (_id_);


--
-- Name: report_indicator report_indicator_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_indicator
    ADD CONSTRAINT report_indicator_pkey PRIMARY KEY (_id_);


--
-- Name: report_object report_object_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_object
    ADD CONSTRAINT report_object_pkey PRIMARY KEY (_id_);


--
-- Name: report_type report_type_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_type
    ADD CONSTRAINT report_type_pkey PRIMARY KEY (_id_);


--
-- Name: result result_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.result
    ADD CONSTRAINT result_pkey PRIMARY KEY (_id_);


--
-- Name: scheduledeventlog scheduledeventlog_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.scheduledeventlog
    ADD CONSTRAINT scheduledeventlog_pkey PRIMARY KEY (_id_);


--
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (_id_);


--
-- Name: heliumonlyreportingvendorfacility shadowfacility1_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingvendorfacility
    ADD CONSTRAINT shadowfacility1_pkey PRIMARY KEY (_id_);


--
-- Name: shadowfacility shadowfacility_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfacility
    ADD CONSTRAINT shadowfacility_pkey PRIMARY KEY (_id_);


--
-- Name: shadowfirststockout shadowfirststockout_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirststockout
    ADD CONSTRAINT shadowfirststockout_pkey PRIMARY KEY (_id_);


--
-- Name: shadowfirstupdate shadowfirstupdate_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirstupdate
    ADD CONSTRAINT shadowfirstupdate_pkey PRIMARY KEY (_id_);


--
-- Name: shadowlaststockout shadowlaststockout_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlaststockout
    ADD CONSTRAINT shadowlaststockout_pkey PRIMARY KEY (_id_);


--
-- Name: shadowlastupdate shadowlastupdate_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlastupdate
    ADD CONSTRAINT shadowlastupdate_pkey PRIMARY KEY (_id_);


--
-- Name: shadowreportingaggregate shadowreportingaggregate_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingaggregate
    ADD CONSTRAINT shadowreportingaggregate_pkey PRIMARY KEY (_id_);


--
-- Name: shadowreportingsupplieraggregate shadowreportingsupplieraggregate_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingsupplieraggregate
    ADD CONSTRAINT shadowreportingsupplieraggregate_pkey PRIMARY KEY (_id_);


--
-- Name: shadowstockoutsequence shadowstockoutsequence_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowstockoutsequence
    ADD CONSTRAINT shadowstockoutsequence_pkey PRIMARY KEY (_id_);


--
-- Name: smslog smslog_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.smslog
    ADD CONSTRAINT smslog_pkey PRIMARY KEY (_id_);


--
-- Name: smsmessage smsmessage_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.smsmessage
    ADD CONSTRAINT smsmessage_pkey PRIMARY KEY (_id_);


--
-- Name: smsoutbound smsoutbound_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.smsoutbound
    ADD CONSTRAINT smsoutbound_pkey PRIMARY KEY (_id_);


--
-- Name: stock_category_link stock_category_link_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stock_category_link
    ADD CONSTRAINT stock_category_link_pkey PRIMARY KEY (_id_);


--
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (_id_);


--
-- Name: stockoutdurationitems_tmp stockoutdurationitems_tmp_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockoutdurationitems_tmp
    ADD CONSTRAINT stockoutdurationitems_tmp_pkey PRIMARY KEY (_id_);


--
-- Name: stockupdate stockupdate_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_pkey PRIMARY KEY (_id_);


--
-- Name: stockupdate_stocklost_detail stockupdate_stocklost_detail_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate_stocklost_detail
    ADD CONSTRAINT stockupdate_stocklost_detail_pkey PRIMARY KEY (_id_);


--
-- Name: stockupdatefacilitystockview stockupdatefacilitystockview_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdatefacilitystockview
    ADD CONSTRAINT stockupdatefacilitystockview_pkey PRIMARY KEY (_id_);


--
-- Name: stringgroup stringgroup_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stringgroup
    ADD CONSTRAINT stringgroup_pkey PRIMARY KEY (_id_);


--
-- Name: stringgrouplog stringgrouplog_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stringgrouplog
    ADD CONSTRAINT stringgrouplog_pkey PRIMARY KEY (_id_);


--
-- Name: sub_dpm_facility_stock_level_aggr_executor sub_dpm_facility_stock_level_aggr_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.sub_dpm_facility_stock_level_aggr_executor
    ADD CONSTRAINT sub_dpm_facility_stock_level_aggr_executor_pkey PRIMARY KEY (_id_);


--
-- Name: sub_dpm_facility_stock_level_aggr_table sub_dpm_facility_stock_level_aggr_table_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.sub_dpm_facility_stock_level_aggr_table
    ADD CONSTRAINT sub_dpm_facility_stock_level_aggr_table_pkey PRIMARY KEY (_id_);


--
-- Name: subdistrict subdistrict_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrict
    ADD CONSTRAINT subdistrict_pkey PRIMARY KEY (_id_);


--
-- Name: subdistrictmanager subdistrictmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrictmanager
    ADD CONSTRAINT subdistrictmanager_pkey PRIMARY KEY (_id_);


--
-- Name: subdistrictpharmacymanager subdistrictpharmacymanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrictpharmacymanager
    ADD CONSTRAINT subdistrictpharmacymanager_pkey PRIMARY KEY (_id_);


--
-- Name: subdistrictstockmanager subdistrictstockmanager_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrictstockmanager
    ADD CONSTRAINT subdistrictstockmanager_pkey PRIMARY KEY (_id_);


--
-- Name: submissionattempt submissionattempt_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.submissionattempt
    ADD CONSTRAINT submissionattempt_pkey PRIMARY KEY (_id_);


--
-- Name: successmatrix_stockavailabilityp successmatrix_stockavailabilityp_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockavailabilityp
    ADD CONSTRAINT successmatrix_stockavailabilityp_pkey PRIMARY KEY (_id_);


--
-- Name: successmatrix_stockbycategory successmatrix_stockbycategory_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockbycategory
    ADD CONSTRAINT successmatrix_stockbycategory_pkey PRIMARY KEY (_id_);


--
-- Name: successmatrix_tenoutofstock successmatrix_tenoutofstock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_tenoutofstock
    ADD CONSTRAINT successmatrix_tenoutofstock_pkey PRIMARY KEY (_id_);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (_id_);


--
-- Name: supplieruser supplieruser_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.supplieruser
    ADD CONSTRAINT supplieruser_pkey PRIMARY KEY (_id_);


--
-- Name: suppliervendor suppliervendor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.suppliervendor
    ADD CONSTRAINT suppliervendor_pkey PRIMARY KEY (_id_);


--
-- Name: support support_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.support
    ADD CONSTRAINT support_pkey PRIMARY KEY (_id_);


--
-- Name: surveilanceupdates_aggr_materialized surveilanceupdates_aggr_materialized_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.surveilanceupdates_aggr_materialized
    ADD CONSTRAINT surveilanceupdates_aggr_materialized_pkey PRIMARY KEY (_id_);


--
-- Name: surveilanceupdates_levels_materialized_wiew surveilanceupdates_levels_materialized_wiew_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.surveilanceupdates_levels_materialized_wiew
    ADD CONSTRAINT surveilanceupdates_levels_materialized_wiew_pkey PRIMARY KEY (_id_);


--
-- Name: svsreconreport_aggregation_executor svsreconreport_aggregation_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.svsreconreport_aggregation_executor
    ADD CONSTRAINT svsreconreport_aggregation_executor_pkey PRIMARY KEY (_id_);


--
-- Name: svsreconreport svsreconreport_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.svsreconreport
    ADD CONSTRAINT svsreconreport_pkey PRIMARY KEY (_id_);


--
-- Name: svsshadowcompare_aggregation_executor svsshadowcompare_aggregation_executor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.svsshadowcompare_aggregation_executor
    ADD CONSTRAINT svsshadowcompare_aggregation_executor_pkey PRIMARY KEY (_id_);


--
-- Name: svsshadowcompare svsshadowcompare_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.svsshadowcompare
    ADD CONSTRAINT svsshadowcompare_pkey PRIMARY KEY (_id_);


--
-- Name: tableaulatesttstamp_object tableaulatesttstamp_object_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.tableaulatesttstamp_object
    ADD CONSTRAINT tableaulatesttstamp_object_pkey PRIMARY KEY (_id_);


--
-- Name: temprecord temprecord_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.temprecord
    ADD CONSTRAINT temprecord_pkey PRIMARY KEY (_id_);


--
-- Name: tripsheet tripsheet_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.tripsheet
    ADD CONSTRAINT tripsheet_pkey PRIMARY KEY (_id_);


--
-- Name: vehicle vehicle_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vehicle
    ADD CONSTRAINT vehicle_pkey PRIMARY KEY (_id_);


--
-- Name: vendor vendor_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendor
    ADD CONSTRAINT vendor_pkey PRIMARY KEY (_id_);


--
-- Name: vendordistrictstock vendordistrictstock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendordistrictstock
    ADD CONSTRAINT vendordistrictstock_pkey PRIMARY KEY (_id_);


--
-- Name: vendorfacilitystock vendorfacilitystock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorfacilitystock
    ADD CONSTRAINT vendorfacilitystock_pkey PRIMARY KEY (_id_);


--
-- Name: vendorprovincialstock vendorprovincialstock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorprovincialstock
    ADD CONSTRAINT vendorprovincialstock_pkey PRIMARY KEY (_id_);


--
-- Name: vendorstock vendorstock_pkey; Type: CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorstock
    ADD CONSTRAINT vendorstock_pkey PRIMARY KEY (_id_);


--
-- Name: __idx_he_sync_admin_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_admin_txid__ ON zambia__svs_001.admin USING btree (_tx_id_);


--
-- Name: __idx_he_sync_asn_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_asn_txid__ ON zambia__svs_001.asn USING btree (_tx_id_);


--
-- Name: __idx_he_sync_batchprocess_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_batchprocess_txid__ ON zambia__svs_001.batchprocess USING btree (_tx_id_);


--
-- Name: __idx_he_sync_config_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_config_txid__ ON zambia__svs_001.config USING btree (_tx_id_);


--
-- Name: __idx_he_sync_configuration_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_configuration_txid__ ON zambia__svs_001.configuration USING btree (_tx_id_);


--
-- Name: __idx_he_sync_container_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_container_txid__ ON zambia__svs_001.container USING btree (_tx_id_);


--
-- Name: __idx_he_sync_delivery_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_delivery_txid__ ON zambia__svs_001.delivery USING btree (_tx_id_);


--
-- Name: __idx_he_sync_dispensarystockmanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_dispensarystockmanager_txid__ ON zambia__svs_001.dispensarystockmanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_district_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_district_txid__ ON zambia__svs_001.district USING btree (_tx_id_);


--
-- Name: __idx_he_sync_districtmanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_districtmanager_txid__ ON zambia__svs_001.districtmanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_districtpharmacymanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_districtpharmacymanager_txid__ ON zambia__svs_001.districtpharmacymanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_districtphcmanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_districtphcmanager_txid__ ON zambia__svs_001.districtphcmanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_districtstock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_districtstock_txid__ ON zambia__svs_001.districtstock USING btree (_tx_id_);


--
-- Name: __idx_he_sync_facility_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_facility_txid__ ON zambia__svs_001.facility USING btree (_tx_id_);


--
-- Name: __idx_he_sync_facilitymanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_facilitymanager_txid__ ON zambia__svs_001.facilitymanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_facilitystock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_facilitystock_txid__ ON zambia__svs_001.facilitystock USING btree (_tx_id_);


--
-- Name: __idx_he_sync_form_type_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_form_type_txid__ ON zambia__svs_001.form_type USING btree (_tx_id_);


--
-- Name: __idx_he_sync_fridge_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_fridge_txid__ ON zambia__svs_001.fridge USING btree (_tx_id_);


--
-- Name: __idx_he_sync_hod_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_hod_txid__ ON zambia__svs_001.hod USING btree (_tx_id_);


--
-- Name: __idx_he_sync_hospital_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_hospital_txid__ ON zambia__svs_001.hospital USING btree (_tx_id_);


--
-- Name: __idx_he_sync_linelevel_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_linelevel_txid__ ON zambia__svs_001.linelevel USING btree (_tx_id_);


--
-- Name: __idx_he_sync_many_to_many_unlink_txid_name__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_many_to_many_unlink_txid_name__ ON zambia__svs_001.__he_sync_many_to_many_unlink_current__ USING btree (tx_id, relationship_name);


--
-- Name: __idx_he_sync_masteradmin_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_masteradmin_txid__ ON zambia__svs_001.masteradmin USING btree (_tx_id_);


--
-- Name: __idx_he_sync_nationalmanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_nationalmanager_txid__ ON zambia__svs_001.nationalmanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_nationalstockadministrator_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_nationalstockadministrator_txid__ ON zambia__svs_001.nationalstockadministrator USING btree (_tx_id_);


--
-- Name: __idx_he_sync_nationalsystemadministrator_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_nationalsystemadministrator_txid__ ON zambia__svs_001.nationalsystemadministrator USING btree (_tx_id_);


--
-- Name: __idx_he_sync_obj_change_txid_seq__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_obj_change_txid_seq__ ON zambia__svs_001.__he_sync_obj_change_current__ USING btree (tx_id, seq);


--
-- Name: __idx_he_sync_poinfo_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_poinfo_txid__ ON zambia__svs_001.poinfo USING btree (_tx_id_);


--
-- Name: __idx_he_sync_province_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_province_txid__ ON zambia__svs_001.province USING btree (_tx_id_);


--
-- Name: __idx_he_sync_provincialdepotmanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_provincialdepotmanager_txid__ ON zambia__svs_001.provincialdepotmanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_provincialmanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_provincialmanager_txid__ ON zambia__svs_001.provincialmanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_provincialprogrammedirector_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_provincialprogrammedirector_txid__ ON zambia__svs_001.provincialprogrammedirector USING btree (_tx_id_);


--
-- Name: __idx_he_sync_provincialstock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_provincialstock_txid__ ON zambia__svs_001.provincialstock USING btree (_tx_id_);


--
-- Name: __idx_he_sync_receipt_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_receipt_txid__ ON zambia__svs_001.receipt USING btree (_tx_id_);


--
-- Name: __idx_he_sync_recieptperline_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_recieptperline_txid__ ON zambia__svs_001.recieptperline USING btree (_tx_id_);


--
-- Name: __idx_he_sync_report_category_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_report_category_txid__ ON zambia__svs_001.report_category USING btree (_tx_id_);


--
-- Name: __idx_he_sync_report_facility_type_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_report_facility_type_txid__ ON zambia__svs_001.report_facility_type USING btree (_tx_id_);


--
-- Name: __idx_he_sync_report_indicator_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_report_indicator_txid__ ON zambia__svs_001.report_indicator USING btree (_tx_id_);


--
-- Name: __idx_he_sync_report_object_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_report_object_txid__ ON zambia__svs_001.report_object USING btree (_tx_id_);


--
-- Name: __idx_he_sync_report_type_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_report_type_txid__ ON zambia__svs_001.report_type USING btree (_tx_id_);


--
-- Name: __idx_he_sync_stock_category_link_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_stock_category_link_txid__ ON zambia__svs_001.stock_category_link USING btree (_tx_id_);


--
-- Name: __idx_he_sync_stock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_stock_txid__ ON zambia__svs_001.stock USING btree (_tx_id_);


--
-- Name: __idx_he_sync_stockupdate_stocklost_detail_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_stockupdate_stocklost_detail_txid__ ON zambia__svs_001.stockupdate_stocklost_detail USING btree (_tx_id_);


--
-- Name: __idx_he_sync_stockupdate_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_stockupdate_txid__ ON zambia__svs_001.stockupdate USING btree (_tx_id_);


--
-- Name: __idx_he_sync_stringgroup_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_stringgroup_txid__ ON zambia__svs_001.stringgroup USING btree (_tx_id_);


--
-- Name: __idx_he_sync_subdistrict_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_subdistrict_txid__ ON zambia__svs_001.subdistrict USING btree (_tx_id_);


--
-- Name: __idx_he_sync_subdistrictmanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_subdistrictmanager_txid__ ON zambia__svs_001.subdistrictmanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_subdistrictpharmacymanager_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_subdistrictpharmacymanager_txid__ ON zambia__svs_001.subdistrictpharmacymanager USING btree (_tx_id_);


--
-- Name: __idx_he_sync_submissionattempt_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_submissionattempt_txid__ ON zambia__svs_001.submissionattempt USING btree (_tx_id_);


--
-- Name: __idx_he_sync_supplier_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_supplier_txid__ ON zambia__svs_001.supplier USING btree (_tx_id_);


--
-- Name: __idx_he_sync_supplieruser_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_supplieruser_txid__ ON zambia__svs_001.supplieruser USING btree (_tx_id_);


--
-- Name: __idx_he_sync_suppliervendor_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_suppliervendor_txid__ ON zambia__svs_001.suppliervendor USING btree (_tx_id_);


--
-- Name: __idx_he_sync_tripsheet_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_tripsheet_txid__ ON zambia__svs_001.tripsheet USING btree (_tx_id_);


--
-- Name: __idx_he_sync_vendor_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_vendor_txid__ ON zambia__svs_001.vendor USING btree (_tx_id_);


--
-- Name: __idx_he_sync_vendordistrictstock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_vendordistrictstock_txid__ ON zambia__svs_001.vendordistrictstock USING btree (_tx_id_);


--
-- Name: __idx_he_sync_vendorfacilitystock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_vendorfacilitystock_txid__ ON zambia__svs_001.vendorfacilitystock USING btree (_tx_id_);


--
-- Name: __idx_he_sync_vendorprovincialstock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_vendorprovincialstock_txid__ ON zambia__svs_001.vendorprovincialstock USING btree (_tx_id_);


--
-- Name: __idx_he_sync_vendorstock_txid__; Type: INDEX; Schema: zambia__svs_001; Owner: -
--

CREATE INDEX __idx_he_sync_vendorstock_txid__ ON zambia__svs_001.vendorstock USING btree (_tx_id_);


--
-- Name: facilitystocklevelstatus_materializedview_actual _RETURN; Type: RULE; Schema: zambia__svs_001; Owner: -
--

CREATE OR REPLACE VIEW zambia__svs_001.facilitystocklevelstatus_materializedview_actual AS
 SELECT facility.name AS facilityname,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Stock out'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Stock out - Alternative available'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Stock without updates'::text
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'No recent updates'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'No stock assigned'::text
            ELSE 'Normal'::text
        END AS facility_status,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Red'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Yellow'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.update_date IS NULL) THEN 'Purple'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'Green'::text
            ELSE 'Green'::text
        END AS facility_status_colour,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 1
                WHEN (stockouts.stockoutstatus = 2) THEN 2
                ELSE NULL::integer
            END
            WHEN (stockwithoutanyupdate.update_date IS NULL) THEN 3
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 4
            WHEN (facilitynostock._id_ IS NOT NULL) THEN 6
            ELSE 5
        END AS facilitystatusorder,
    province.name AS province,
    district.name AS district,
    subdistrict.name AS subdistrict,
    facility._id_ AS facilityid,
    subdistrict._id_ AS subdistrictid,
    district._id_ AS districtid,
    province._id_ AS provinceid
   FROM (((((((zambia__svs_001.facility
     LEFT JOIN zambia__svs_001.subdistrict ON ((facility.facility_subdistrict_fk = subdistrict._id_)))
     LEFT JOIN zambia__svs_001.district ON ((subdistrict.subdistrict_district_fk = district._id_)))
     LEFT JOIN zambia__svs_001.province ON ((district.district_province_fk = province._id_)))
     LEFT JOIN ( SELECT facility_1._id_ AS facilityid,
            stockwithoutanyupdate1.update_date
           FROM (zambia__svs_001.facility facility_1
             LEFT JOIN ( SELECT DISTINCT su.stockupdate_facility_fk,
                    max(su.update_date) AS update_date
                   FROM ((zambia__svs_001.stockupdate su
                     JOIN zambia__svs_001.stock s ON ((su.stockupdate_stock_fk = s._id_)))
                     JOIN zambia__svs_001.stringgroup sg ON (((s.stock_stringgroup_fk = sg._id_) AND (su.update_date > ((now())::date - '14 days'::interval)))))
                  GROUP BY su.stockupdate_facility_fk) stockwithoutanyupdate1 ON ((facility_1._id_ = stockwithoutanyupdate1.stockupdate_facility_fk)))) stockwithoutanyupdate ON ((facility._id_ = stockwithoutanyupdate.facilityid)))
     LEFT JOIN ( SELECT stockoutpriority.stockoutfacilityid,
            stockoutpriority.stockoutstatus
           FROM ( SELECT row_number() OVER (PARTITION BY stockoutbypriorityorder.stockoutfacilityid ORDER BY stockoutbypriorityorder.stockoutfacilityid) AS therownum,
                    stockoutbypriorityorder.stockoutfacilityid,
                    stockoutbypriorityorder.stockoutstatus
                   FROM ( SELECT stockupdate.stockupdate_facility_fk AS stockoutfacilityid,
                                CASE
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NULL) THEN 1
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NOT NULL) THEN stringgroup.value_ident
                                    ELSE NULL::integer
                                END AS stockoutstatus
                           FROM ((zambia__svs_001.stockupdate
                             JOIN ( SELECT stockupdate_1.stockupdate_facility_fk AS facility_id,
                                    stockupdate_1.stockupdate_stock_fk AS stock_id,
                                    max(stockupdate_1.update_date) AS max_update_date
                                   FROM (zambia__svs_001.stockupdate stockupdate_1
                                     JOIN zambia__svs_001.facilitystock ON ((stockupdate_1.stockupdate_facilitystock_fk = facilitystock._id_)))
                                  WHERE ((stockupdate_1.stockupdate_facility_fk IS NOT NULL) AND (facilitystock.deleted = 'No'::text))
                                  GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) latest_stockupdate ON (((stockupdate.stockupdate_facility_fk = latest_stockupdate.facility_id) AND (stockupdate.stockupdate_stock_fk = latest_stockupdate.stock_id))))
                             LEFT JOIN zambia__svs_001.stringgroup ON ((stockupdate.stockupdate_stockout_status_fk = stringgroup._id_)))
                          WHERE ((stockupdate.update_date = latest_stockupdate.max_update_date) AND (stockupdate.current_level = '0'::text))
                          ORDER BY stockupdate.stockupdate_facility_fk,
                                CASE
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NULL) THEN 1
                                    WHEN (stockupdate.stockupdate_stockout_status_fk IS NOT NULL) THEN stringgroup.value_ident
                                    ELSE NULL::integer
                                END) stockoutbypriorityorder) stockoutpriority
          WHERE (stockoutpriority.therownum = 1)) stockouts ON (((facility._id_ = stockouts.stockoutfacilityid) AND (facility.deleted = 'No'::text))))
     LEFT JOIN ( SELECT DISTINCT facilitystock.facilitystock_facility_fk AS facilityid
           FROM (zambia__svs_001.facilitystock
             LEFT JOIN ( SELECT stockupdate.stockupdate_facility_fk AS facilityid,
                    stockupdate.stockupdate_stock_fk AS stockid
                   FROM zambia__svs_001.stockupdate
                  WHERE ((stockupdate.stockupdate_facility_fk IS NOT NULL) AND (date(stockupdate.update_date) >= ((now())::date - '8 days'::interval)) AND (stockupdate.update_date < ((now())::date - '00:00:00'::interval)))
                  GROUP BY stockupdate.stockupdate_facility_fk, stockupdate.stockupdate_stock_fk) facility_with_update ON (((facilitystock.facilitystock_facility_fk = facility_with_update.facilityid) AND (facilitystock.facilitystock_stock_fk = facility_with_update.stockid))))
          WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facility_with_update.facilityid IS NULL) AND (facility_with_update.stockid IS NULL) AND (facilitystock.deleted = 'No'::text))
          GROUP BY facilitystock.facilitystock_facility_fk) stockwithoutanyupdateinrange ON (((facility._id_ = stockwithoutanyupdateinrange.facilityid) AND (facility.deleted = 'No'::text))))
     LEFT JOIN ( SELECT facility_1._id_
           FROM (zambia__svs_001.facility facility_1
             LEFT JOIN ( SELECT facilitystock.facilitystock_facility_fk
                   FROM zambia__svs_001.facilitystock
                  WHERE ((facilitystock.facilitystock_facility_fk IS NOT NULL) AND (facilitystock.deleted = 'No'::text))
                  GROUP BY facilitystock.facilitystock_facility_fk) facilitywithstock ON (((facility_1._id_ = facilitywithstock.facilitystock_facility_fk) AND (facility_1.deleted = 'No'::text))))
          WHERE (facilitywithstock.facilitystock_facility_fk IS NULL)) facilitynostock ON (((facility._id_ = facilitynostock._id_) AND (facility.deleted = 'No'::text))))
  WHERE (facility.deleted = 'No'::text)
  GROUP BY stockouts.stockoutfacilityid, stockwithoutanyupdate.facilityid, stockwithoutanyupdate.update_date, stockwithoutanyupdateinrange.facilityid, facilitynostock._id_, district.name, subdistrict.name, facility.name,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Stock out'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Stock out - Alternative available'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.facilityid IS NOT NULL) THEN 'Stock without updates'::text
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 'No recent updates'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'No stock assigned'::text
            ELSE 'Normal'::text
        END,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 'Red'::text
                WHEN (stockouts.stockoutstatus = 2) THEN 'Yellow'::text
                ELSE NULL::text
            END
            WHEN (stockwithoutanyupdate.update_date IS NULL) THEN 'Purple'::text
            WHEN (facilitynostock.* IS NOT NULL) THEN 'Green'::text
            ELSE 'Green'::text
        END, stockouts.stockoutstatus, facility._id_, subdistrict._id_, district._id_, province._id_
  ORDER BY province.name, district.name, subdistrict.name, facility.name,
        CASE
            WHEN (stockouts.stockoutfacilityid IS NOT NULL) THEN
            CASE
                WHEN (stockouts.stockoutstatus = 1) THEN 1
                WHEN (stockouts.stockoutstatus = 2) THEN 2
                ELSE NULL::integer
            END
            WHEN (stockwithoutanyupdate.update_date IS NULL) THEN 3
            WHEN (stockwithoutanyupdateinrange.facilityid IS NOT NULL) THEN 4
            WHEN (facilitynostock._id_ IS NOT NULL) THEN 6
            ELSE 5
        END;


--
-- Name: reportstockoutdistrictview_actual _RETURN; Type: RULE; Schema: zambia__svs_001; Owner: -
--

CREATE OR REPLACE VIEW zambia__svs_001.reportstockoutdistrictview_actual AS
 SELECT stock._id_,
    now() AS _tstamp_,
    stock.itemname AS stock_item,
    stock.abbreviation AS stock_abbreviation,
    COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) AS num_facilities,
    COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) AS out_of_stock,
    COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric) AS not_reported,
    COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) AS out_of_stock_actual,
    stock._id_ AS reportstockoutdistrictview_stock_fk,
    district._id_ AS reportstockoutdistrictview_district_fk,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) / COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric)) * (100)::numeric))
        END AS stock_out_percentage,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR ((COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric)) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) / (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric))) * (100)::numeric))
        END AS stock_out_percentage_and_reported
   FROM ((((((zambia__svs_001.stock
     JOIN zambia__svs_001.districtstock ON ((stock._id_ = districtstock.districtstock_stock_fk)))
     JOIN zambia__svs_001.district ON ((districtstock.districtstock_district_fk = district._id_)))
     LEFT JOIN ( SELECT facility.facility_district_fk,
            stock_1._id_,
            count(DISTINCT facility._id_) AS num_of_fac_stocked_item
           FROM (((zambia__svs_001.facility
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             LEFT JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text))
          GROUP BY facility.facility_district_fk, stock_1._id_) facilities_stocking_item ON (((facilities_stocking_item._id_ = stock._id_) AND (facilities_stocking_item.facility_district_fk = district._id_))))
     LEFT JOIN ( SELECT facility.facility_district_fk,
            stock_1._id_,
            count(DISTINCT facility._id_) AS stock_out
           FROM ((((zambia__svs_001.facility
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
             JOIN ( SELECT stockupdate_1.stockupdate_facility_fk,
                    stockupdate_1.stockupdate_stock_fk,
                    max(stockupdate_1.update_date) AS last_update
                   FROM (zambia__svs_001.stockupdate stockupdate_1
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate_1.stockupdate_facility_fk = facility_1._id_)))
                  GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) maxweeks ON (((stockupdate.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (stockupdate.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (stockupdate.update_date = maxweeks.last_update))))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (facilitystock.stock_out = 'Yes'::text) AND (facilitystock.total = 0))
          GROUP BY facility.facility_district_fk, stock_1._id_) facilities_stocked_and_stockout ON (((facilities_stocked_and_stockout._id_ = stock._id_) AND (facilities_stocked_and_stockout.facility_district_fk = district._id_))))
     LEFT JOIN ( SELECT facility.facility_district_fk,
            facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS facilities_not_reported
           FROM ((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk
                   FROM (zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate.stockupdate_facility_fk = facility_1._id_)))
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.stockupdate_facilitystock_fk IS NULL))
          GROUP BY facility.facility_district_fk, facilitystock.facilitystock_stock_fk) not_reported ON (((not_reported._id_ = stock._id_) AND (not_reported.facility_district_fk = district._id_))))
     LEFT JOIN ( SELECT facility.facility_district_fk,
            facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS number_of_stocked_stockouts
           FROM (((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             LEFT JOIN zambia__svs_001.district district_1 ON ((facility.facility_district_fk = district_1._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk,
                    stockupdate.current_level
                   FROM (zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate.stockupdate_facility_fk = facility_1._id_)))
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk, stockupdate.current_level) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.current_level = '0'::text))
          GROUP BY facility.facility_district_fk, facilitystock.facilitystock_stock_fk) reported_and_stocked_in_two_weeks ON (((reported_and_stocked_in_two_weeks._id_ = stock._id_) AND (reported_and_stocked_in_two_weeks.facility_district_fk = district._id_))))
  WHERE ((stock.deleted = 'No'::text) AND (districtstock.deleted = 'No'::text))
  GROUP BY district._id_, stock._id_;


--
-- Name: reportstockoutnationalview_actual _RETURN; Type: RULE; Schema: zambia__svs_001; Owner: -
--

CREATE OR REPLACE VIEW zambia__svs_001.reportstockoutnationalview_actual AS
 SELECT stock._id_,
    now() AS _tstamp_,
    stock._id_ AS reportstockoutnationalview_stock_fk,
    stock.itemname AS stock_item,
    stock.abbreviation AS stock_abbreviation,
    COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) AS num_facilities,
    COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) AS out_of_stock,
    COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric) AS not_reported,
    COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) AS out_of_stock_actual,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) / COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric)) * (100)::numeric))
        END AS stock_out_percentage,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR ((COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric)) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) / (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric))) * (100)::numeric))
        END AS stock_out_percentage_and_reported
   FROM ((((zambia__svs_001.stock
     LEFT JOIN ( SELECT stock_1._id_,
            count(DISTINCT facility._id_) AS num_of_fac_stocked_item
           FROM (((zambia__svs_001.facility
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             LEFT JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text))
          GROUP BY stock_1._id_) facilities_stocking_item ON ((facilities_stocking_item._id_ = stock._id_)))
     LEFT JOIN ( SELECT stock_1._id_,
            count(DISTINCT facility._id_) AS stock_out
           FROM ((((zambia__svs_001.facility
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
             JOIN ( SELECT stockupdate_1.stockupdate_facility_fk,
                    stockupdate_1.stockupdate_stock_fk,
                    max(stockupdate_1.update_date) AS last_update
                   FROM zambia__svs_001.stockupdate stockupdate_1
                  GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) maxweeks ON (((stockupdate.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (stockupdate.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (stockupdate.update_date = maxweeks.last_update))))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (facilitystock.stock_out = 'Yes'::text) AND (facilitystock.total = 0))
          GROUP BY stock_1._id_) facilities_stocked_and_stockout ON ((facilities_stocked_and_stockout._id_ = stock._id_)))
     LEFT JOIN ( SELECT facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS facilities_not_reported
           FROM ((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk
                   FROM zambia__svs_001.stockupdate
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.stockupdate_facilitystock_fk IS NULL))
          GROUP BY facilitystock.facilitystock_stock_fk) not_reported ON ((not_reported._id_ = stock._id_)))
     LEFT JOIN ( SELECT facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS number_of_stocked_stockouts
           FROM ((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk,
                    stockupdate.current_level
                   FROM (zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate.stockupdate_facility_fk = facility_1._id_)))
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk, stockupdate.current_level) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.current_level = '0'::text))
          GROUP BY facilitystock.facilitystock_stock_fk) reported_and_stocked_in_two_weeks ON ((reported_and_stocked_in_two_weeks._id_ = stock._id_)))
  WHERE (stock.deleted = 'No'::text)
  GROUP BY stock._id_
  ORDER BY stock.abbreviation;


--
-- Name: reportstockoutprovincialview_actual _RETURN; Type: RULE; Schema: zambia__svs_001; Owner: -
--

CREATE OR REPLACE VIEW zambia__svs_001.reportstockoutprovincialview_actual AS
 SELECT stock._id_,
    now() AS _tstamp_,
    stock.itemname AS stock_item,
    stock.abbreviation AS stock_abbreviation,
    COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) AS num_facilities,
    COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) AS out_of_stock,
    COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric) AS not_reported,
    COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) AS out_of_stock_actual,
    stock._id_ AS reportstockoutprovincialview_stock_fk,
    province._id_ AS reportstockoutprovincialview_province_fk,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) / COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric)) * (100)::numeric))
        END AS stock_out_percentage,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR ((COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric)) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) / (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric))) * (100)::numeric))
        END AS stock_out_percentage_and_reported
   FROM ((((((zambia__svs_001.stock
     JOIN zambia__svs_001.provincialstock ON ((stock._id_ = provincialstock.provincialstock_stock_fk)))
     JOIN zambia__svs_001.province ON ((province._id_ = provincialstock.provincialstock_province_fk)))
     LEFT JOIN ( SELECT district.district_province_fk,
            stock_1._id_,
            count(DISTINCT facility._id_) AS num_of_fac_stocked_item
           FROM ((((zambia__svs_001.facility
             JOIN zambia__svs_001.district ON ((facility.facility_district_fk = district._id_)))
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             LEFT JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text))
          GROUP BY district.district_province_fk, stock_1._id_) facilities_stocking_item ON (((facilities_stocking_item._id_ = stock._id_) AND (facilities_stocking_item.district_province_fk = province._id_))))
     LEFT JOIN ( SELECT district.district_province_fk,
            stock_1._id_,
            count(DISTINCT facility._id_) AS stock_out
           FROM (((((zambia__svs_001.facility
             JOIN zambia__svs_001.district ON ((facility.facility_district_fk = district._id_)))
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
             JOIN ( SELECT stockupdate_1.stockupdate_facility_fk,
                    stockupdate_1.stockupdate_stock_fk,
                    max(stockupdate_1.update_date) AS last_update
                   FROM ((zambia__svs_001.stockupdate stockupdate_1
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate_1.stockupdate_facility_fk = facility_1._id_)))
                     JOIN zambia__svs_001.district district_1 ON ((facility_1.facility_district_fk = district_1._id_)))
                  GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) maxweeks ON (((stockupdate.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (stockupdate.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (stockupdate.update_date = maxweeks.last_update))))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (facilitystock.stock_out = 'Yes'::text) AND (facilitystock.total = 0))
          GROUP BY district.district_province_fk, stock_1._id_) facilities_stocked_and_stockout ON (((facilities_stocked_and_stockout._id_ = stock._id_) AND (facilities_stocked_and_stockout.district_province_fk = province._id_))))
     LEFT JOIN ( SELECT district.district_province_fk,
            facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS facilities_not_reported
           FROM (((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.district ON ((facility.facility_district_fk = district._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk
                   FROM ((zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate.stockupdate_facility_fk = facility_1._id_)))
                     JOIN zambia__svs_001.district district_1 ON ((facility_1.facility_district_fk = district_1._id_)))
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.stockupdate_facilitystock_fk IS NULL))
          GROUP BY district.district_province_fk, facilitystock.facilitystock_stock_fk) not_reported ON (((not_reported._id_ = stock._id_) AND (not_reported.district_province_fk = province._id_))))
     LEFT JOIN ( SELECT district.district_province_fk,
            facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS number_of_stocked_stockouts
           FROM (((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             LEFT JOIN zambia__svs_001.district ON ((facility.facility_district_fk = district._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk,
                    stockupdate.current_level
                   FROM (zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate.stockupdate_facility_fk = facility_1._id_)))
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk, stockupdate.current_level) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.current_level = '0'::text))
          GROUP BY district.district_province_fk, facilitystock.facilitystock_stock_fk) reported_and_stocked_in_two_weeks ON (((reported_and_stocked_in_two_weeks._id_ = stock._id_) AND (reported_and_stocked_in_two_weeks.district_province_fk = province._id_))))
  WHERE ((provincialstock.deleted = 'No'::text) AND (stock.deleted = 'No'::text))
  GROUP BY province._id_, stock._id_;


--
-- Name: reportstockoutsubdistrictview_actual _RETURN; Type: RULE; Schema: zambia__svs_001; Owner: -
--

CREATE OR REPLACE VIEW zambia__svs_001.reportstockoutsubdistrictview_actual AS
 SELECT stock._id_,
    now() AS _tstamp_,
    stock.itemname AS stock_item,
    stock.abbreviation AS stock_abbreviation,
    COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) AS num_facilities,
    COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) AS out_of_stock,
    COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric) AS not_reported,
    COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) AS out_of_stock_actual,
    stock._id_ AS reportstockoutsubdistrictview_stock_fk,
    subdistrict._id_ AS reportstockoutsubdistrictview_subdistrict_fk,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) / COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric)) * (100)::numeric))
        END AS stock_out_percentage,
        CASE
            WHEN ((COALESCE(sum(facilities_stocked_and_stockout.stock_out), (0)::numeric) = (0)::numeric) OR ((COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric)) = (0)::numeric)) THEN (0)::numeric
            ELSE round(((COALESCE(sum(reported_and_stocked_in_two_weeks.number_of_stocked_stockouts), (0)::numeric) / (COALESCE(sum(facilities_stocking_item.num_of_fac_stocked_item), (0)::numeric) - COALESCE(sum(not_reported.facilities_not_reported), (0)::numeric))) * (100)::numeric))
        END AS stock_out_percentage_and_reported
   FROM (((((((zambia__svs_001.stock
     JOIN zambia__svs_001.districtstock ON ((stock._id_ = districtstock.districtstock_stock_fk)))
     JOIN zambia__svs_001.district ON ((districtstock.districtstock_district_fk = district._id_)))
     JOIN zambia__svs_001.subdistrict ON ((subdistrict.subdistrict_district_fk = district._id_)))
     LEFT JOIN ( SELECT facility.facility_subdistrict_fk,
            stock_1._id_,
            count(DISTINCT facility._id_) AS num_of_fac_stocked_item
           FROM (((zambia__svs_001.facility
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             LEFT JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text))
          GROUP BY facility.facility_subdistrict_fk, stock_1._id_) facilities_stocking_item ON (((facilities_stocking_item._id_ = stock._id_) AND (facilities_stocking_item.facility_subdistrict_fk = subdistrict._id_))))
     LEFT JOIN ( SELECT facility.facility_subdistrict_fk,
            stock_1._id_,
            count(DISTINCT facility._id_) AS stock_out
           FROM ((((zambia__svs_001.facility
             JOIN zambia__svs_001.facilitystock ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             JOIN zambia__svs_001.stock stock_1 ON ((facilitystock.facilitystock_stock_fk = stock_1._id_)))
             JOIN zambia__svs_001.stockupdate ON ((stockupdate.stockupdate_facilitystock_fk = facilitystock._id_)))
             JOIN ( SELECT stockupdate_1.stockupdate_facility_fk,
                    stockupdate_1.stockupdate_stock_fk,
                    max(stockupdate_1.update_date) AS last_update
                   FROM (zambia__svs_001.stockupdate stockupdate_1
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate_1.stockupdate_facility_fk = facility_1._id_)))
                  GROUP BY stockupdate_1.stockupdate_facility_fk, stockupdate_1.stockupdate_stock_fk) maxweeks ON (((stockupdate.stockupdate_facility_fk = maxweeks.stockupdate_facility_fk) AND (stockupdate.stockupdate_stock_fk = maxweeks.stockupdate_stock_fk) AND (stockupdate.update_date = maxweeks.last_update))))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (facilitystock.stock_out = 'Yes'::text) AND (facilitystock.total = 0))
          GROUP BY facility.facility_subdistrict_fk, stock_1._id_) facilities_stocked_and_stockout ON (((facilities_stocked_and_stockout._id_ = stock._id_) AND (facilities_stocked_and_stockout.facility_subdistrict_fk = subdistrict._id_))))
     LEFT JOIN ( SELECT facility.facility_subdistrict_fk,
            facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS facilities_not_reported
           FROM ((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk
                   FROM (zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate.stockupdate_facility_fk = facility_1._id_)))
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.stockupdate_facilitystock_fk IS NULL))
          GROUP BY facility.facility_subdistrict_fk, facilitystock.facilitystock_stock_fk) not_reported ON (((not_reported._id_ = stock._id_) AND (not_reported.facility_subdistrict_fk = subdistrict._id_))))
     LEFT JOIN ( SELECT facility.facility_subdistrict_fk,
            facilitystock.facilitystock_stock_fk AS _id_,
            count(DISTINCT facility._id_) AS number_of_stocked_stockouts
           FROM (((zambia__svs_001.facilitystock
             JOIN zambia__svs_001.facility ON ((facilitystock.facilitystock_facility_fk = facility._id_)))
             LEFT JOIN zambia__svs_001.subdistrict subdistrict_1 ON ((facility.facility_subdistrict_fk = subdistrict_1._id_)))
             LEFT JOIN ( SELECT stockupdate.stockupdate_facilitystock_fk,
                    stockupdate.current_level
                   FROM (zambia__svs_001.stockupdate
                     JOIN zambia__svs_001.facility facility_1 ON ((stockupdate.stockupdate_facility_fk = facility_1._id_)))
                  WHERE ((stockupdate.update_date >= (date_trunc('week'::text, now()) + '-14 days'::interval)) AND (stockupdate.stockupdate_facilitystock_fk IS NOT NULL))
                  GROUP BY stockupdate.stockupdate_facilitystock_fk, stockupdate.current_level) stockupdates ON ((facilitystock._id_ = stockupdates.stockupdate_facilitystock_fk)))
          WHERE ((facility.deleted = 'No'::text) AND (facilitystock.deleted = 'No'::text) AND (stockupdates.current_level = '0'::text))
          GROUP BY facility.facility_subdistrict_fk, facilitystock.facilitystock_stock_fk) reported_and_stocked_in_two_weeks ON (((reported_and_stocked_in_two_weeks._id_ = stock._id_) AND (reported_and_stocked_in_two_weeks.facility_subdistrict_fk = subdistrict._id_))))
  WHERE ((stock.deleted = 'No'::text) AND (districtstock.deleted = 'No'::text))
  GROUP BY subdistrict._id_, stock._id_;


--
-- Name: asn __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.asn FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: batchprocess __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.batchprocess FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: configuration __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.configuration FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: container __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.container FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: delivery __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.delivery FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: district __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.district FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: districtstock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.districtstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: facility __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.facility FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: facilitystock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.facilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: form_type __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.form_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: fridge __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.fridge FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: hospital __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.hospital FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: linelevel __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.linelevel FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: poinfo __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.poinfo FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: province __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.province FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: provincialstock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.provincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: receipt __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.receipt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: recieptperline __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.recieptperline FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: report_category __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.report_category FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: report_facility_type __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.report_facility_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: report_indicator __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.report_indicator FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: report_object __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.report_object FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: report_type __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.report_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: stock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.stock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: stockupdate __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.stockupdate FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: stock_category_link __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.stock_category_link FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: stockupdate_stocklost_detail __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.stockupdate_stocklost_detail FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: stringgroup __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.stringgroup FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: subdistrict __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.subdistrict FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: submissionattempt __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.submissionattempt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: supplier __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.supplier FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: suppliervendor __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.suppliervendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: tripsheet __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.tripsheet FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: vendor __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.vendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: vendordistrictstock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.vendordistrictstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: vendorfacilitystock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.vendorfacilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: vendorprovincialstock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.vendorprovincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: vendorstock __he_sync_obj_delete_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_delete_after__ AFTER DELETE ON zambia__svs_001.vendorstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_delete_after__();


--
-- Name: asn __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.asn FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: batchprocess __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.batchprocess FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: configuration __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.configuration FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: container __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.container FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: delivery __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.delivery FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: district __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.district FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: districtstock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.districtstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: facility __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.facility FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: facilitystock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.facilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: form_type __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.form_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: fridge __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.fridge FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: hospital __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.hospital FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: linelevel __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.linelevel FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: poinfo __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.poinfo FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: province __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.province FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: provincialstock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.provincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: receipt __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.receipt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: recieptperline __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.recieptperline FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: report_category __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.report_category FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: report_facility_type __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.report_facility_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: report_indicator __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.report_indicator FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: report_object __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.report_object FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: report_type __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.report_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: stock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.stock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: stockupdate __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.stockupdate FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: stock_category_link __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.stock_category_link FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: stockupdate_stocklost_detail __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.stockupdate_stocklost_detail FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: stringgroup __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.stringgroup FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: subdistrict __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.subdistrict FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: submissionattempt __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.submissionattempt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: supplier __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.supplier FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: suppliervendor __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.suppliervendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: tripsheet __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.tripsheet FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: vendor __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.vendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: vendordistrictstock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.vendordistrictstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: vendorfacilitystock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.vendorfacilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: vendorprovincialstock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.vendorprovincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: vendorstock __he_sync_obj_insert_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_insert_after__ AFTER INSERT ON zambia__svs_001.vendorstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_insert_after__();


--
-- Name: asn __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.asn FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: batchprocess __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.batchprocess FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: configuration __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.configuration FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: container __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.container FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: delivery __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.delivery FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: district __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.district FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: districtstock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.districtstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: facility __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.facility FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: facilitystock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.facilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: form_type __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.form_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: fridge __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.fridge FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: hospital __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.hospital FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: linelevel __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.linelevel FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: poinfo __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.poinfo FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: province __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.province FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: provincialstock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.provincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: receipt __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.receipt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: recieptperline __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.recieptperline FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: report_category __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.report_category FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: report_facility_type __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.report_facility_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: report_indicator __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.report_indicator FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: report_object __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.report_object FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: report_type __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.report_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: stock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.stock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: stockupdate __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.stockupdate FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: stock_category_link __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.stock_category_link FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: stockupdate_stocklost_detail __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.stockupdate_stocklost_detail FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: stringgroup __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.stringgroup FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: subdistrict __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.subdistrict FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: submissionattempt __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.submissionattempt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: supplier __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.supplier FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: suppliervendor __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.suppliervendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: tripsheet __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.tripsheet FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: vendor __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.vendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: vendordistrictstock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.vendordistrictstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: vendorfacilitystock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.vendorfacilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: vendorprovincialstock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.vendorprovincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: vendorstock __he_sync_obj_update_after__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_after__ AFTER UPDATE ON zambia__svs_001.vendorstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_after__();


--
-- Name: asn __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.asn FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: batchprocess __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.batchprocess FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: configuration __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.configuration FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: container __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.container FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: delivery __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.delivery FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: district __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.district FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: districtstock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.districtstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: facility __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.facility FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: facilitystock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.facilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: form_type __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.form_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: fridge __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.fridge FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: hospital __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.hospital FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: linelevel __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.linelevel FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: poinfo __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.poinfo FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: province __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.province FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: provincialstock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.provincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: receipt __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.receipt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: recieptperline __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.recieptperline FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: report_category __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.report_category FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: report_facility_type __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.report_facility_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: report_indicator __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.report_indicator FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: report_object __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.report_object FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: report_type __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.report_type FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: stock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.stock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: stockupdate __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.stockupdate FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: stock_category_link __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.stock_category_link FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: stockupdate_stocklost_detail __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.stockupdate_stocklost_detail FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: stringgroup __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.stringgroup FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: subdistrict __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.subdistrict FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: submissionattempt __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.submissionattempt FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: supplier __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.supplier FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: suppliervendor __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.suppliervendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: tripsheet __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.tripsheet FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: vendor __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.vendor FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: vendordistrictstock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.vendordistrictstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: vendorfacilitystock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.vendorfacilitystock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: vendorprovincialstock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.vendorprovincialstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: vendorstock __he_sync_obj_update_before__; Type: TRIGGER; Schema: zambia__svs_001; Owner: -
--

CREATE TRIGGER __he_sync_obj_update_before__ BEFORE UPDATE ON zambia__svs_001.vendorstock FOR EACH ROW EXECUTE PROCEDURE zambia__svs_001.__he_sync_obj_update_before__();


--
-- Name: __facilityproductstatusviewoutput__ __facilityproductstatusviewou_facilityproductstatusviewout_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__facilityproductstatusviewoutput__
    ADD CONSTRAINT __facilityproductstatusviewou_facilityproductstatusviewout_fkey FOREIGN KEY (facilityproductstatusviewoutput_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: __he_sync_client_request_log__ __he_sync_client_request_log___client_id_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__he_sync_client_request_log__
    ADD CONSTRAINT __he_sync_client_request_log___client_id_fkey FOREIGN KEY (client_id) REFERENCES zambia__svs_001.__he_sync_client__(client_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: __notification_email_attachment__ __notification_email_attachment___notificationemail_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_email_attachment__
    ADD CONSTRAINT __notification_email_attachment___notificationemail_fk_fkey FOREIGN KEY (notificationemail_fk) REFERENCES zambia__svs_001.__notification_email__(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: __notification_message_arg__ __notification_message_arg___message_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_message_arg__
    ADD CONSTRAINT __notification_message_arg___message_fk_fkey FOREIGN KEY (message_fk) REFERENCES zambia__svs_001.__notification_message__(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: __notification_message_arg__ __notification_message_arg___notificationemail_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__notification_message_arg__
    ADD CONSTRAINT __notification_message_arg___notificationemail_fk_fkey FOREIGN KEY (notificationemail_fk) REFERENCES zambia__svs_001.__notification_email__(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: __payment__ __payment___paymentstatus_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment__
    ADD CONSTRAINT __payment___paymentstatus_fk_fkey FOREIGN KEY (paymentstatus_fk) REFERENCES zambia__svs_001.__payment_status_record__(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: __payment_with_ref__ __payment_with_ref___paymentstatus_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__payment_with_ref__
    ADD CONSTRAINT __payment_with_ref___paymentstatus_fk_fkey FOREIGN KEY (paymentstatus_fk) REFERENCES zambia__svs_001.__payment_with_ref_status_record__(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: __productstockupdateoutput__ __productstockupdateoutput___productupdatedetails_facility_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.__productstockupdateoutput__
    ADD CONSTRAINT __productstockupdateoutput___productupdatedetails_facility_fkey FOREIGN KEY (productupdatedetails_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: asn asn_poinfo_asn_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.asn
    ADD CONSTRAINT asn_poinfo_asn_fk_fkey FOREIGN KEY (poinfo_asn_fk) REFERENCES zambia__svs_001.poinfo(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: asn asn_poinfo_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.asn
    ADD CONSTRAINT asn_poinfo_fk_fkey FOREIGN KEY (poinfo_fk) REFERENCES zambia__svs_001.poinfo(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_admin_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_admin_fk_fkey FOREIGN KEY (admin_fk) REFERENCES zambia__svs_001.admin(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_dispensarystockmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_dispensarystockmanager_fk_fkey FOREIGN KEY (dispensarystockmanager_fk) REFERENCES zambia__svs_001.dispensarystockmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_districtmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_districtmanager_fk_fkey FOREIGN KEY (districtmanager_fk) REFERENCES zambia__svs_001.districtmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_districtpharmacymanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_districtpharmacymanager_fk_fkey FOREIGN KEY (districtpharmacymanager_fk) REFERENCES zambia__svs_001.districtpharmacymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_districtphcmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_districtphcmanager_fk_fkey FOREIGN KEY (districtphcmanager_fk) REFERENCES zambia__svs_001.districtphcmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_districtstockmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_districtstockmanager_fk_fkey FOREIGN KEY (districtstockmanager_fk) REFERENCES zambia__svs_001.districtstockmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_facilitymanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_facilitymanager_fk_fkey FOREIGN KEY (facilitymanager_fk) REFERENCES zambia__svs_001.facilitymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_masteradmin_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_masteradmin_fk_fkey FOREIGN KEY (masteradmin_fk) REFERENCES zambia__svs_001.masteradmin(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_nationalmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_nationalmanager_fk_fkey FOREIGN KEY (nationalmanager_fk) REFERENCES zambia__svs_001.nationalmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_nationalstockadministrator_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_nationalstockadministrator_fk_fkey FOREIGN KEY (nationalstockadministrator_fk) REFERENCES zambia__svs_001.nationalstockadministrator(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_nationalsystemadministrator_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_nationalsystemadministrator_fk_fkey FOREIGN KEY (nationalsystemadministrator_fk) REFERENCES zambia__svs_001.nationalsystemadministrator(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_provincialdepotmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_provincialdepotmanager_fk_fkey FOREIGN KEY (provincialdepotmanager_fk) REFERENCES zambia__svs_001.provincialdepotmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_provincialmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_provincialmanager_fk_fkey FOREIGN KEY (provincialmanager_fk) REFERENCES zambia__svs_001.provincialmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_provincialprogrammedirector_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_provincialprogrammedirector_fk_fkey FOREIGN KEY (provincialprogrammedirector_fk) REFERENCES zambia__svs_001.provincialprogrammedirector(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_subdistrictmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_subdistrictmanager_fk_fkey FOREIGN KEY (subdistrictmanager_fk) REFERENCES zambia__svs_001.subdistrictmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_subdistrictpharmacymanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_subdistrictpharmacymanager_fk_fkey FOREIGN KEY (subdistrictpharmacymanager_fk) REFERENCES zambia__svs_001.subdistrictpharmacymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_subdistrictstockmanager_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_subdistrictstockmanager_fk_fkey FOREIGN KEY (subdistrictstockmanager_fk) REFERENCES zambia__svs_001.subdistrictstockmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_supplieruser_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_supplieruser_fk_fkey FOREIGN KEY (supplieruser_fk) REFERENCES zambia__svs_001.supplieruser(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: attachment attachment_support_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.attachment
    ADD CONSTRAINT attachment_support_fk_fkey FOREIGN KEY (support_fk) REFERENCES zambia__svs_001.support(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: batchprocess batchprocess_batchprocess_provincialstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.batchprocess
    ADD CONSTRAINT batchprocess_batchprocess_provincialstock_fk_fkey FOREIGN KEY (batchprocess_provincialstock_fk) REFERENCES zambia__svs_001.provincialstock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: batchprocess batchprocess_batchprocess_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.batchprocess
    ADD CONSTRAINT batchprocess_batchprocess_stock_fk_fkey FOREIGN KEY (batchprocess_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: batchprocess batchprocess_batchprocess_vendorprovincialstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.batchprocess
    ADD CONSTRAINT batchprocess_batchprocess_vendorprovincialstock_fk_fkey FOREIGN KEY (batchprocess_vendorprovincialstock_fk) REFERENCES zambia__svs_001.vendorprovincialstock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: batchprocess batchprocess_batchprocess_vendorstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.batchprocess
    ADD CONSTRAINT batchprocess_batchprocess_vendorstock_fk_fkey FOREIGN KEY (batchprocess_vendorstock_fk) REFERENCES zambia__svs_001.vendorstock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: billingfacilityreport billingfacilityreport_mobiledevice_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.billingfacilityreport
    ADD CONSTRAINT billingfacilityreport_mobiledevice_facility_fk_fkey FOREIGN KEY (mobiledevice_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: container container_asn_cantainer_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.container
    ADD CONSTRAINT container_asn_cantainer_fk_fkey FOREIGN KEY (asn_cantainer_fk) REFERENCES zambia__svs_001.asn(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: container container_asn_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.container
    ADD CONSTRAINT container_asn_fk_fkey FOREIGN KEY (asn_fk) REFERENCES zambia__svs_001.asn(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: container container_container_delivery_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.container
    ADD CONSTRAINT container_container_delivery_fk_fkey FOREIGN KEY (container_delivery_fk) REFERENCES zambia__svs_001.delivery(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: container container_poinfo_container_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.container
    ADD CONSTRAINT container_poinfo_container_fk_fkey FOREIGN KEY (poinfo_container_fk) REFERENCES zambia__svs_001.poinfo(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: container container_tripsheet_container_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.container
    ADD CONSTRAINT container_tripsheet_container_fk_fkey FOREIGN KEY (tripsheet_container_fk) REFERENCES zambia__svs_001.tripsheet(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: container container_tripsheet_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.container
    ADD CONSTRAINT container_tripsheet_fk_fkey FOREIGN KEY (tripsheet_fk) REFERENCES zambia__svs_001.tripsheet(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: delivery delivery_delivery_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.delivery
    ADD CONSTRAINT delivery_delivery_facility_fk_fkey FOREIGN KEY (delivery_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: delivery delivery_stockdelivery_client_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.delivery
    ADD CONSTRAINT delivery_stockdelivery_client_fk_fkey FOREIGN KEY (stockdelivery_client_fk) REFERENCES zambia__svs_001.client(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: delivery delivery_stockdelivery_vehicle_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.delivery
    ADD CONSTRAINT delivery_stockdelivery_vehicle_fk_fkey FOREIGN KEY (stockdelivery_vehicle_fk) REFERENCES zambia__svs_001.vehicle(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: deliveryattachment deliveryattachment_deliveryattachment_delivery_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.deliveryattachment
    ADD CONSTRAINT deliveryattachment_deliveryattachment_delivery_fk_fkey FOREIGN KEY (deliveryattachment_delivery_fk) REFERENCES zambia__svs_001.delivery(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: deliveryattachment deliveryattachment_deliveryattachment_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.deliveryattachment
    ADD CONSTRAINT deliveryattachment_deliveryattachment_facility_fk_fkey FOREIGN KEY (deliveryattachment_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: dispensarystockmanager dispensarystockmanager_dispensarystockmanager_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.dispensarystockmanager
    ADD CONSTRAINT dispensarystockmanager_dispensarystockmanager_facility_fk_fkey FOREIGN KEY (dispensarystockmanager_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: district district_district_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.district
    ADD CONSTRAINT district_district_province_fk_fkey FOREIGN KEY (district_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: districtmanager districtmanager_districtmanager_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtmanager
    ADD CONSTRAINT districtmanager_districtmanager_district_fk_fkey FOREIGN KEY (districtmanager_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: districtpharmacymanager districtpharmacymanager_districtpharmacymanager_district_f_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtpharmacymanager
    ADD CONSTRAINT districtpharmacymanager_districtpharmacymanager_district_f_fkey FOREIGN KEY (districtpharmacymanager_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: districtphcmanager districtphcmanager_districtphcmanager_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtphcmanager
    ADD CONSTRAINT districtphcmanager_districtphcmanager_district_fk_fkey FOREIGN KEY (districtphcmanager_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: districtstock districtstock_districtstock_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtstock
    ADD CONSTRAINT districtstock_districtstock_district_fk_fkey FOREIGN KEY (districtstock_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: districtstock districtstock_districtstock_lowstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtstock
    ADD CONSTRAINT districtstock_districtstock_lowstock_fk_fkey FOREIGN KEY (districtstock_lowstock_fk) REFERENCES zambia__svs_001.districtpharmacymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: districtstock districtstock_districtstock_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtstock
    ADD CONSTRAINT districtstock_districtstock_stock_fk_fkey FOREIGN KEY (districtstock_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: districtstock districtstock_districtstock_stockout_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.districtstock
    ADD CONSTRAINT districtstock_districtstock_stockout_fk_fkey FOREIGN KEY (districtstock_stockout_fk) REFERENCES zambia__svs_001.districtpharmacymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facility facility_facility_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facility
    ADD CONSTRAINT facility_facility_district_fk_fkey FOREIGN KEY (facility_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facility facility_facility_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facility
    ADD CONSTRAINT facility_facility_subdistrict_fk_fkey FOREIGN KEY (facility_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facility facility_last_facilitydeactivationlog_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facility
    ADD CONSTRAINT facility_last_facilitydeactivationlog_fk_fkey FOREIGN KEY (last_facilitydeactivationlog_fk) REFERENCES zambia__svs_001.facilitydeactivationlog(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitycompliance_materializedview facilitycompliance_materializedview__districtid_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitycompliance_materializedview
    ADD CONSTRAINT facilitycompliance_materializedview__districtid_fk_fkey FOREIGN KEY (_districtid_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitycompliance_materializedview facilitycompliance_materializedview__provinceid_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitycompliance_materializedview
    ADD CONSTRAINT facilitycompliance_materializedview__provinceid_fk_fkey FOREIGN KEY (_provinceid_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitycompliance_materializedview facilitycompliance_materializedview__subdistrictid_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitycompliance_materializedview
    ADD CONSTRAINT facilitycompliance_materializedview__subdistrictid_fk_fkey FOREIGN KEY (_subdistrictid_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitydeactivationlog facilitydeactivationlog_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitydeactivationlog
    ADD CONSTRAINT facilitydeactivationlog_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitymanager facilitymanager_facilitymanager_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitymanager
    ADD CONSTRAINT facilitymanager_facilitymanager_facility_fk_fkey FOREIGN KEY (facilitymanager_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitystock facilitystock_facilitystock_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitystock
    ADD CONSTRAINT facilitystock_facilitystock_facility_fk_fkey FOREIGN KEY (facilitystock_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitystock facilitystock_facilitystock_lowstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitystock
    ADD CONSTRAINT facilitystock_facilitystock_lowstock_fk_fkey FOREIGN KEY (facilitystock_lowstock_fk) REFERENCES zambia__svs_001.facilitymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitystock facilitystock_facilitystock_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitystock
    ADD CONSTRAINT facilitystock_facilitystock_stock_fk_fkey FOREIGN KEY (facilitystock_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: facilitystock facilitystock_facilitystock_stockout_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.facilitystock
    ADD CONSTRAINT facilitystock_facilitystock_stockout_fk_fkey FOREIGN KEY (facilitystock_stockout_fk) REFERENCES zambia__svs_001.facilitymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fridge fridge_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.fridge
    ADD CONSTRAINT fridge_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyaveragestockoutdurationitems heliumonlyaveragestockoutdur_heliumonlyaveragestockoutdur_fkey1; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyaveragestockoutdurationitems
    ADD CONSTRAINT heliumonlyaveragestockoutdur_heliumonlyaveragestockoutdur_fkey1 FOREIGN KEY (heliumonlyaveragestockoutdurationitems_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyaveragestockoutdurationitems heliumonlyaveragestockoutdur_heliumonlyaveragestockoutdur_fkey2; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyaveragestockoutdurationitems
    ADD CONSTRAINT heliumonlyaveragestockoutdur_heliumonlyaveragestockoutdur_fkey2 FOREIGN KEY (heliumonlyaveragestockoutdurationitems_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyaveragestockoutdurationitems heliumonlyaveragestockoutdur_heliumonlyaveragestockoutdur_fkey3; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyaveragestockoutdurationitems
    ADD CONSTRAINT heliumonlyaveragestockoutdur_heliumonlyaveragestockoutdur_fkey3 FOREIGN KEY (heliumonlyaveragestockoutdurationitems_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyaveragestockoutdurationitems heliumonlyaveragestockoutdura_heliumonlyaveragestockoutdur_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyaveragestockoutdurationitems
    ADD CONSTRAINT heliumonlyaveragestockoutdura_heliumonlyaveragestockoutdur_fkey FOREIGN KEY (heliumonlyaveragestockoutdurationitems_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitystatus heliumonlyfacilitystatus_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitystatus
    ADD CONSTRAINT heliumonlyfacilitystatus_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitystatus heliumonlyfacilitystatus_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitystatus
    ADD CONSTRAINT heliumonlyfacilitystatus_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitystatus heliumonlyfacilitystatus_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitystatus
    ADD CONSTRAINT heliumonlyfacilitystatus_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitystatus heliumonlyfacilitystatus_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitystatus
    ADD CONSTRAINT heliumonlyfacilitystatus_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitywithstockoutitem heliumonlyfacilitywithstocko_heliumonlyfacilitywithstocko_fkey1; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitywithstockoutitem
    ADD CONSTRAINT heliumonlyfacilitywithstocko_heliumonlyfacilitywithstocko_fkey1 FOREIGN KEY (heliumonlyfacilitywithstockoutitem_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitywithstockoutitem heliumonlyfacilitywithstocko_heliumonlyfacilitywithstocko_fkey2; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitywithstockoutitem
    ADD CONSTRAINT heliumonlyfacilitywithstocko_heliumonlyfacilitywithstocko_fkey2 FOREIGN KEY (heliumonlyfacilitywithstockoutitem_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitywithstockoutitem heliumonlyfacilitywithstocko_heliumonlyfacilitywithstocko_fkey3; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitywithstockoutitem
    ADD CONSTRAINT heliumonlyfacilitywithstocko_heliumonlyfacilitywithstocko_fkey3 FOREIGN KEY (heliumonlyfacilitywithstockoutitem_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyfacilitywithstockoutitem heliumonlyfacilitywithstockou_heliumonlyfacilitywithstocko_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyfacilitywithstockoutitem
    ADD CONSTRAINT heliumonlyfacilitywithstockou_heliumonlyfacilitywithstocko_fkey FOREIGN KEY (heliumonlyfacilitywithstockoutitem_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyhierarchystocklevel heliumonlyhierarchystocklevel_hierarchystocklevel_district_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel
    ADD CONSTRAINT heliumonlyhierarchystocklevel_hierarchystocklevel_district_fkey FOREIGN KEY (hierarchystocklevel_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyhierarchystocklevel heliumonlyhierarchystocklevel_hierarchystocklevel_facility_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel
    ADD CONSTRAINT heliumonlyhierarchystocklevel_hierarchystocklevel_facility_fkey FOREIGN KEY (hierarchystocklevel_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyhierarchystocklevel heliumonlyhierarchystocklevel_hierarchystocklevel_province_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel
    ADD CONSTRAINT heliumonlyhierarchystocklevel_hierarchystocklevel_province_fkey FOREIGN KEY (hierarchystocklevel_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyhierarchystocklevel heliumonlyhierarchystocklevel_hierarchystocklevel_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel
    ADD CONSTRAINT heliumonlyhierarchystocklevel_hierarchystocklevel_stock_fk_fkey FOREIGN KEY (hierarchystocklevel_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyhierarchystocklevel heliumonlyhierarchystocklevel_hierarchystocklevel_subdistr_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel
    ADD CONSTRAINT heliumonlyhierarchystocklevel_hierarchystocklevel_subdistr_fkey FOREIGN KEY (hierarchystocklevel_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyhierarchystocklevel heliumonlyhierarchystocklevel_hierarchystocklevel_vendor_f_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyhierarchystocklevel
    ADD CONSTRAINT heliumonlyhierarchystocklevel_hierarchystocklevel_vendor_f_fkey FOREIGN KEY (hierarchystocklevel_vendor_fk) REFERENCES zambia__svs_001.vendor(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlylowandoverstockreport heliumonlylowandoverstockreport_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlylowandoverstockreport
    ADD CONSTRAINT heliumonlylowandoverstockreport_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlylowandoverstockreport heliumonlylowandoverstockreport_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlylowandoverstockreport
    ADD CONSTRAINT heliumonlylowandoverstockreport_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlylowandoverstockreport heliumonlylowandoverstockreport_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlylowandoverstockreport
    ADD CONSTRAINT heliumonlylowandoverstockreport_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlylowandoverstockreport heliumonlylowandoverstockreport_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlylowandoverstockreport
    ADD CONSTRAINT heliumonlylowandoverstockreport_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlylowandoverstockreport heliumonlylowandoverstockreport_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlylowandoverstockreport
    ADD CONSTRAINT heliumonlylowandoverstockreport_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockavailability heliumonlynationalstockavail_heliumonlynationalstockavail_fkey1; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockavailability
    ADD CONSTRAINT heliumonlynationalstockavail_heliumonlynationalstockavail_fkey1 FOREIGN KEY (heliumonlynationalstockavailability_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockavailability heliumonlynationalstockavail_heliumonlynationalstockavail_fkey2; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockavailability
    ADD CONSTRAINT heliumonlynationalstockavail_heliumonlynationalstockavail_fkey2 FOREIGN KEY (heliumonlynationalstockavailability_facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockavailability heliumonlynationalstockavail_heliumonlynationalstockavail_fkey3; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockavailability
    ADD CONSTRAINT heliumonlynationalstockavail_heliumonlynationalstockavail_fkey3 FOREIGN KEY (heliumonlynationalstockavailability_stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockavailability heliumonlynationalstockavail_heliumonlynationalstockavail_fkey4; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockavailability
    ADD CONSTRAINT heliumonlynationalstockavail_heliumonlynationalstockavail_fkey4 FOREIGN KEY (heliumonlynationalstockavailability_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockavailability heliumonlynationalstockavaila_heliumonlynationalstockavail_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockavailability
    ADD CONSTRAINT heliumonlynationalstockavaila_heliumonlynationalstockavail_fkey FOREIGN KEY (heliumonlynationalstockavailability_vendor_fk) REFERENCES zambia__svs_001.vendor(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockoutreasons heliumonlynationalstockoutre_heliumonlynationalstockoutre_fkey1; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockoutreasons
    ADD CONSTRAINT heliumonlynationalstockoutre_heliumonlynationalstockoutre_fkey1 FOREIGN KEY (heliumonlynationalstockoutreasons_facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockoutreasons heliumonlynationalstockoutre_heliumonlynationalstockoutre_fkey2; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockoutreasons
    ADD CONSTRAINT heliumonlynationalstockoutre_heliumonlynationalstockoutre_fkey2 FOREIGN KEY (heliumonlynationalstockoutreasons_stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockoutreasons heliumonlynationalstockoutre_heliumonlynationalstockoutre_fkey3; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockoutreasons
    ADD CONSTRAINT heliumonlynationalstockoutre_heliumonlynationalstockoutre_fkey3 FOREIGN KEY (heliumonlynationalstockoutreasons_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlynationalstockoutreasons heliumonlynationalstockoutrea_heliumonlynationalstockoutre_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlynationalstockoutreasons
    ADD CONSTRAINT heliumonlynationalstockoutrea_heliumonlynationalstockoutre_fkey FOREIGN KEY (heliumonlynationalstockoutreasons_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyreportingfacility heliumonlyreportingfacility_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingfacility
    ADD CONSTRAINT heliumonlyreportingfacility_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyreportingfacility heliumonlyreportingfacility_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingfacility
    ADD CONSTRAINT heliumonlyreportingfacility_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyreportingfacility heliumonlyreportingfacility_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingfacility
    ADD CONSTRAINT heliumonlyreportingfacility_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyreportingfacility heliumonlyreportingfacility_stockupdate_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingfacility
    ADD CONSTRAINT heliumonlyreportingfacility_stockupdate_fk_fkey FOREIGN KEY (stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlyreportingfacility heliumonlyreportingfacility_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlyreportingfacility
    ADD CONSTRAINT heliumonlyreportingfacility_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockout heliumonlystockout_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockout
    ADD CONSTRAINT heliumonlystockout_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockout heliumonlystockout_facilitystock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockout
    ADD CONSTRAINT heliumonlystockout_facilitystock_fk_fkey FOREIGN KEY (facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockout heliumonlystockout_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockout
    ADD CONSTRAINT heliumonlystockout_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockout heliumonlystockout_stockupdate_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockout
    ADD CONSTRAINT heliumonlystockout_stockupdate_fk_fkey FOREIGN KEY (stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey1; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey1 FOREIGN KEY (heliumonlystockoutdurationitemsforcategory_facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey2; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey2 FOREIGN KEY (heliumonlystockoutdurationitemsforcategory_stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey3; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey3 FOREIGN KEY (heliumonlystockoutdurationitemsforcategory_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey4; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey4 FOREIGN KEY (heliumonlystockoutdurationitemsforcategory_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey5; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey5 FOREIGN KEY (heliumonlystockoutdurationitemsforcategory_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey6; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationit_heliumonlystockoutdurationit_fkey6 FOREIGN KEY (heliumonlystockoutdurationitemsforcategory_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: heliumonlystockoutdurationitemsforcategory heliumonlystockoutdurationite_heliumonlystockoutdurationit_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.heliumonlystockoutdurationitemsforcategory
    ADD CONSTRAINT heliumonlystockoutdurationite_heliumonlystockoutdurationit_fkey FOREIGN KEY (heliumonlystockoutdurationitemsforcategory_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hierachreportattachment hierachreportattachment_hierachyreportattachment_district__fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hierachreportattachment
    ADD CONSTRAINT hierachreportattachment_hierachyreportattachment_district__fkey FOREIGN KEY (hierachyreportattachment_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hierachreportattachment hierachreportattachment_hierachyreportattachment_facility__fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hierachreportattachment
    ADD CONSTRAINT hierachreportattachment_hierachyreportattachment_facility__fkey FOREIGN KEY (hierachyreportattachment_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hierachreportattachment hierachreportattachment_hierachyreportattachment_province__fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hierachreportattachment
    ADD CONSTRAINT hierachreportattachment_hierachyreportattachment_province__fkey FOREIGN KEY (hierachyreportattachment_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hierachreportattachment hierachreportattachment_hierachyreportattachment_subdistri_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hierachreportattachment
    ADD CONSTRAINT hierachreportattachment_hierachyreportattachment_subdistri_fkey FOREIGN KEY (hierachyreportattachment_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hod hod_hod_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hod
    ADD CONSTRAINT hod_hod_province_fk_fkey FOREIGN KEY (hod_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hospital hospital_hospital_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.hospital
    ADD CONSTRAINT hospital_hospital_district_fk_fkey FOREIGN KEY (hospital_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: linelevel linelevel_asn_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.linelevel
    ADD CONSTRAINT linelevel_asn_fk_fkey FOREIGN KEY (asn_fk) REFERENCES zambia__svs_001.asn(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: linelevel linelevel_asn_linelevel_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.linelevel
    ADD CONSTRAINT linelevel_asn_linelevel_fk_fkey FOREIGN KEY (asn_linelevel_fk) REFERENCES zambia__svs_001.asn(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: linelevel linelevel_container_linelevel_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.linelevel
    ADD CONSTRAINT linelevel_container_linelevel_fk_fkey FOREIGN KEY (container_linelevel_fk) REFERENCES zambia__svs_001.container(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: linelevel linelevel_containers_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.linelevel
    ADD CONSTRAINT linelevel_containers_fk_fkey FOREIGN KEY (containers_fk) REFERENCES zambia__svs_001.container(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mezbatchitem mezbatchitem_batch_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.mezbatchitem
    ADD CONSTRAINT mezbatchitem_batch_fk_fkey FOREIGN KEY (batch_fk) REFERENCES zambia__svs_001.mezbatch(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: mobiledevice mobiledevice_mobiledevice_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.mobiledevice
    ADD CONSTRAINT mobiledevice_mobiledevice_facility_fk_fkey FOREIGN KEY (mobiledevice_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: nationalsystemadministrator nationalsystemadministrator_nationalsystemadministrator_di_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.nationalsystemadministrator
    ADD CONSTRAINT nationalsystemadministrator_nationalsystemadministrator_di_fkey FOREIGN KEY (nationalsystemadministrator_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: poinfo poinfo_poinfo_delivery_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.poinfo
    ADD CONSTRAINT poinfo_poinfo_delivery_fk_fkey FOREIGN KEY (poinfo_delivery_fk) REFERENCES zambia__svs_001.delivery(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: poinfo poinfo_poinfo_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.poinfo
    ADD CONSTRAINT poinfo_poinfo_facility_fk_fkey FOREIGN KEY (poinfo_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provincialdepotmanager provincialdepotmanager_provincialdepotmanager_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialdepotmanager
    ADD CONSTRAINT provincialdepotmanager_provincialdepotmanager_province_fk_fkey FOREIGN KEY (provincialdepotmanager_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provincialmanager provincialmanager_provincialmanager_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialmanager
    ADD CONSTRAINT provincialmanager_provincialmanager_province_fk_fkey FOREIGN KEY (provincialmanager_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provincialprogrammedirector provincialprogrammedirector_provincialprogrammedirector_pr_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialprogrammedirector
    ADD CONSTRAINT provincialprogrammedirector_provincialprogrammedirector_pr_fkey FOREIGN KEY (provincialprogrammedirector_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provincialstock provincialstock_provincialstock_lowstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialstock
    ADD CONSTRAINT provincialstock_provincialstock_lowstock_fk_fkey FOREIGN KEY (provincialstock_lowstock_fk) REFERENCES zambia__svs_001.provincialdepotmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provincialstock provincialstock_provincialstock_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialstock
    ADD CONSTRAINT provincialstock_provincialstock_province_fk_fkey FOREIGN KEY (provincialstock_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provincialstock provincialstock_provincialstock_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialstock
    ADD CONSTRAINT provincialstock_provincialstock_stock_fk_fkey FOREIGN KEY (provincialstock_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provincialstock provincialstock_provincialstock_stockout_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.provincialstock
    ADD CONSTRAINT provincialstock_provincialstock_stockout_fk_fkey FOREIGN KEY (provincialstock_stockout_fk) REFERENCES zambia__svs_001.provincialdepotmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: receipt receipt_asn_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.receipt
    ADD CONSTRAINT receipt_asn_fk_fkey FOREIGN KEY (asn_fk) REFERENCES zambia__svs_001.asn(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: receipt receipt_asn_receipt_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.receipt
    ADD CONSTRAINT receipt_asn_receipt_fk_fkey FOREIGN KEY (asn_receipt_fk) REFERENCES zambia__svs_001.asn(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: receipt receipt_container_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.receipt
    ADD CONSTRAINT receipt_container_fk_fkey FOREIGN KEY (container_fk) REFERENCES zambia__svs_001.container(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: receipt receipt_container_receipt_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.receipt
    ADD CONSTRAINT receipt_container_receipt_fk_fkey FOREIGN KEY (container_receipt_fk) REFERENCES zambia__svs_001.container(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recieptperline recieptperline_asn_receiptperline_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_asn_receiptperline_fk_fkey FOREIGN KEY (asn_receiptperline_fk) REFERENCES zambia__svs_001.asn(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recieptperline recieptperline_container_receiptperline_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_container_receiptperline_fk_fkey FOREIGN KEY (container_receiptperline_fk) REFERENCES zambia__svs_001.container(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recieptperline recieptperline_linelevel_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_linelevel_fk_fkey FOREIGN KEY (linelevel_fk) REFERENCES zambia__svs_001.linelevel(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recieptperline recieptperline_linelevel_receiptperline_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_linelevel_receiptperline_fk_fkey FOREIGN KEY (linelevel_receiptperline_fk) REFERENCES zambia__svs_001.linelevel(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recieptperline recieptperline_reciept_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_reciept_fk_fkey FOREIGN KEY (reciept_fk) REFERENCES zambia__svs_001.receipt(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recieptperline recieptperline_reciept_receiptperline_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_reciept_receiptperline_fk_fkey FOREIGN KEY (reciept_receiptperline_fk) REFERENCES zambia__svs_001.receipt(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recieptperline recieptperline_tripsheet_receiptperline_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.recieptperline
    ADD CONSTRAINT recieptperline_tripsheet_receiptperline_fk_fkey FOREIGN KEY (tripsheet_receiptperline_fk) REFERENCES zambia__svs_001.tripsheet(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_category report_category_report_indicator_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_category
    ADD CONSTRAINT report_category_report_indicator_fk_fkey FOREIGN KEY (report_indicator_fk) REFERENCES zambia__svs_001.report_indicator(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_facility_type report_facility_type_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_facility_type
    ADD CONSTRAINT report_facility_type_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_facility_type report_facility_type_report_type_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_facility_type
    ADD CONSTRAINT report_facility_type_report_type_fk_fkey FOREIGN KEY (report_type_fk) REFERENCES zambia__svs_001.report_type(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_object report_object_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_object
    ADD CONSTRAINT report_object_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_object report_object_report_facility_type_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_object
    ADD CONSTRAINT report_object_report_facility_type_fk_fkey FOREIGN KEY (report_facility_type_fk) REFERENCES zambia__svs_001.report_facility_type(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_object report_object_report_type_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_object
    ADD CONSTRAINT report_object_report_type_fk_fkey FOREIGN KEY (report_type_fk) REFERENCES zambia__svs_001.report_type(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: report_type report_type_report_category_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.report_type
    ADD CONSTRAINT report_type_report_category_fk_fkey FOREIGN KEY (report_category_fk) REFERENCES zambia__svs_001.report_category(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfacility shadowfacility_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfacility
    ADD CONSTRAINT shadowfacility_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfacility shadowfacility_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfacility
    ADD CONSTRAINT shadowfacility_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfacility shadowfacility_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfacility
    ADD CONSTRAINT shadowfacility_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfacility shadowfacility_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfacility
    ADD CONSTRAINT shadowfacility_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirststockout shadowfirststockout_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirststockout
    ADD CONSTRAINT shadowfirststockout_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirststockout shadowfirststockout_facilitystock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirststockout
    ADD CONSTRAINT shadowfirststockout_facilitystock_fk_fkey FOREIGN KEY (facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirststockout shadowfirststockout_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirststockout
    ADD CONSTRAINT shadowfirststockout_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirststockout shadowfirststockout_stockupdate_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirststockout
    ADD CONSTRAINT shadowfirststockout_stockupdate_fk_fkey FOREIGN KEY (stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirstupdate shadowfirstupdate_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirstupdate
    ADD CONSTRAINT shadowfirstupdate_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirstupdate shadowfirstupdate_facilitystock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirstupdate
    ADD CONSTRAINT shadowfirstupdate_facilitystock_fk_fkey FOREIGN KEY (facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirstupdate shadowfirstupdate_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirstupdate
    ADD CONSTRAINT shadowfirstupdate_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowfirstupdate shadowfirstupdate_stockupdate_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowfirstupdate
    ADD CONSTRAINT shadowfirstupdate_stockupdate_fk_fkey FOREIGN KEY (stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlaststockout shadowlaststockout_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlaststockout
    ADD CONSTRAINT shadowlaststockout_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlaststockout shadowlaststockout_facilitystock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlaststockout
    ADD CONSTRAINT shadowlaststockout_facilitystock_fk_fkey FOREIGN KEY (facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlaststockout shadowlaststockout_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlaststockout
    ADD CONSTRAINT shadowlaststockout_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlaststockout shadowlaststockout_stockupdate_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlaststockout
    ADD CONSTRAINT shadowlaststockout_stockupdate_fk_fkey FOREIGN KEY (stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlastupdate shadowlastupdate_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlastupdate
    ADD CONSTRAINT shadowlastupdate_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlastupdate shadowlastupdate_facilitystock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlastupdate
    ADD CONSTRAINT shadowlastupdate_facilitystock_fk_fkey FOREIGN KEY (facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlastupdate shadowlastupdate_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlastupdate
    ADD CONSTRAINT shadowlastupdate_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowlastupdate shadowlastupdate_stockupdate_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowlastupdate
    ADD CONSTRAINT shadowlastupdate_stockupdate_fk_fkey FOREIGN KEY (stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowreportingaggregate shadowreportingaggregate_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingaggregate
    ADD CONSTRAINT shadowreportingaggregate_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowreportingaggregate shadowreportingaggregate_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingaggregate
    ADD CONSTRAINT shadowreportingaggregate_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowreportingaggregate shadowreportingaggregate_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingaggregate
    ADD CONSTRAINT shadowreportingaggregate_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowreportingsupplieraggregate shadowreportingsupplieraggregate_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingsupplieraggregate
    ADD CONSTRAINT shadowreportingsupplieraggregate_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowreportingsupplieraggregate shadowreportingsupplieraggregate_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingsupplieraggregate
    ADD CONSTRAINT shadowreportingsupplieraggregate_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowreportingsupplieraggregate shadowreportingsupplieraggregate_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingsupplieraggregate
    ADD CONSTRAINT shadowreportingsupplieraggregate_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowreportingsupplieraggregate shadowreportingsupplieraggregate_supplier_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowreportingsupplieraggregate
    ADD CONSTRAINT shadowreportingsupplieraggregate_supplier_fk_fkey FOREIGN KEY (supplier_fk) REFERENCES zambia__svs_001.supplier(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowstockoutsequence shadowstockoutsequence_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowstockoutsequence
    ADD CONSTRAINT shadowstockoutsequence_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowstockoutsequence shadowstockoutsequence_facilitystock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowstockoutsequence
    ADD CONSTRAINT shadowstockoutsequence_facilitystock_fk_fkey FOREIGN KEY (facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shadowstockoutsequence shadowstockoutsequence_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.shadowstockoutsequence
    ADD CONSTRAINT shadowstockoutsequence_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_category_link stock_category_link_stock_category_link_form_type_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stock_category_link
    ADD CONSTRAINT stock_category_link_stock_category_link_form_type_fk_fkey FOREIGN KEY (stock_category_link_form_type_fk) REFERENCES zambia__svs_001.form_type(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_category_link stock_category_link_stock_category_link_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stock_category_link
    ADD CONSTRAINT stock_category_link_stock_category_link_stock_fk_fkey FOREIGN KEY (stock_category_link_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock stock_stock_stringgroup_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stock
    ADD CONSTRAINT stock_stock_stringgroup_fk_fkey FOREIGN KEY (stock_stringgroup_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock stock_stock_vendor_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stock
    ADD CONSTRAINT stock_stock_vendor_fk_fkey FOREIGN KEY (stock_vendor_fk) REFERENCES zambia__svs_001.vendor(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate_stocklost_detail stockupdate_stocklost_detail_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate_stocklost_detail
    ADD CONSTRAINT stockupdate_stocklost_detail_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate_stocklost_detail stockupdate_stocklost_detail_stock_lost_reason_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate_stocklost_detail
    ADD CONSTRAINT stockupdate_stocklost_detail_stock_lost_reason_fk_fkey FOREIGN KEY (stock_lost_reason_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate_stocklost_detail stockupdate_stocklost_detail_stockupdate_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate_stocklost_detail
    ADD CONSTRAINT stockupdate_stocklost_detail_stockupdate_fk_fkey FOREIGN KEY (stockupdate_fk) REFERENCES zambia__svs_001.stockupdate(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_dispensarystockamanger_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_dispensarystockamanger_fk_fkey FOREIGN KEY (stockupdate_dispensarystockamanger_fk) REFERENCES zambia__svs_001.dispensarystockmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_facility_fk_fkey FOREIGN KEY (stockupdate_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_facilitystock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_facilitystock_fk_fkey FOREIGN KEY (stockupdate_facilitystock_fk) REFERENCES zambia__svs_001.facilitystock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_stock_fk_fkey FOREIGN KEY (stockupdate_stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_stockout_alternative_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_stockout_alternative_fk_fkey FOREIGN KEY (stockupdate_stockout_alternative_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_stockout_ordered_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_stockout_ordered_fk_fkey FOREIGN KEY (stockupdate_stockout_ordered_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_stockout_reason_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_stockout_reason_fk_fkey FOREIGN KEY (stockupdate_stockout_reason_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_stockout_status_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_stockout_status_fk_fkey FOREIGN KEY (stockupdate_stockout_status_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stockupdate stockupdate_stockupdate_submissionattempt_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stockupdate
    ADD CONSTRAINT stockupdate_stockupdate_submissionattempt_fk_fkey FOREIGN KEY (stockupdate_submissionattempt_fk) REFERENCES zambia__svs_001.submissionattempt(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stringgrouplog stringgrouplog_stringgroup_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.stringgrouplog
    ADD CONSTRAINT stringgrouplog_stringgroup_fk_fkey FOREIGN KEY (stringgroup_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: subdistrict subdistrict_subdistrict_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrict
    ADD CONSTRAINT subdistrict_subdistrict_district_fk_fkey FOREIGN KEY (subdistrict_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: subdistrictmanager subdistrictmanager_subdistrictmanager_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrictmanager
    ADD CONSTRAINT subdistrictmanager_subdistrictmanager_subdistrict_fk_fkey FOREIGN KEY (subdistrictmanager_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: subdistrictpharmacymanager subdistrictpharmacymanager_subdistrictpharmacymanager_subd_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrictpharmacymanager
    ADD CONSTRAINT subdistrictpharmacymanager_subdistrictpharmacymanager_subd_fkey FOREIGN KEY (subdistrictpharmacymanager_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: subdistrictstockmanager subdistrictstockmanager_subdistrictstockmanager_subdistric_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.subdistrictstockmanager
    ADD CONSTRAINT subdistrictstockmanager_subdistrictstockmanager_subdistric_fkey FOREIGN KEY (subdistrictstockmanager_subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: submissionattempt submissionattempt_dispensarystockmanager_submissionattempt_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.submissionattempt
    ADD CONSTRAINT submissionattempt_dispensarystockmanager_submissionattempt_fkey FOREIGN KEY (dispensarystockmanager_submissionattempt_fk) REFERENCES zambia__svs_001.dispensarystockmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockavailabilityp successmatrix_stockavailabilityp_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockavailabilityp
    ADD CONSTRAINT successmatrix_stockavailabilityp_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockavailabilityp successmatrix_stockavailabilityp_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockavailabilityp
    ADD CONSTRAINT successmatrix_stockavailabilityp_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockavailabilityp successmatrix_stockavailabilityp_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockavailabilityp
    ADD CONSTRAINT successmatrix_stockavailabilityp_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockavailabilityp successmatrix_stockavailabilityp_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockavailabilityp
    ADD CONSTRAINT successmatrix_stockavailabilityp_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockbycategory successmatrix_stockbycategory_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockbycategory
    ADD CONSTRAINT successmatrix_stockbycategory_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockbycategory successmatrix_stockbycategory_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockbycategory
    ADD CONSTRAINT successmatrix_stockbycategory_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockbycategory successmatrix_stockbycategory_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockbycategory
    ADD CONSTRAINT successmatrix_stockbycategory_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_stockbycategory successmatrix_stockbycategory_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_stockbycategory
    ADD CONSTRAINT successmatrix_stockbycategory_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_tenoutofstock successmatrix_tenoutofstock_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_tenoutofstock
    ADD CONSTRAINT successmatrix_tenoutofstock_district_fk_fkey FOREIGN KEY (district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_tenoutofstock successmatrix_tenoutofstock_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_tenoutofstock
    ADD CONSTRAINT successmatrix_tenoutofstock_facility_fk_fkey FOREIGN KEY (facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_tenoutofstock successmatrix_tenoutofstock_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_tenoutofstock
    ADD CONSTRAINT successmatrix_tenoutofstock_province_fk_fkey FOREIGN KEY (province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_tenoutofstock successmatrix_tenoutofstock_stock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_tenoutofstock
    ADD CONSTRAINT successmatrix_tenoutofstock_stock_fk_fkey FOREIGN KEY (stock_fk) REFERENCES zambia__svs_001.stock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: successmatrix_tenoutofstock successmatrix_tenoutofstock_subdistrict_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.successmatrix_tenoutofstock
    ADD CONSTRAINT successmatrix_tenoutofstock_subdistrict_fk_fkey FOREIGN KEY (subdistrict_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: supplieruser supplieruser_supplieruser_supplier_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.supplieruser
    ADD CONSTRAINT supplieruser_supplieruser_supplier_fk_fkey FOREIGN KEY (supplieruser_supplier_fk) REFERENCES zambia__svs_001.supplier(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: suppliervendor suppliervendor_suppliervendor_supplier_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.suppliervendor
    ADD CONSTRAINT suppliervendor_suppliervendor_supplier_fk_fkey FOREIGN KEY (suppliervendor_supplier_fk) REFERENCES zambia__svs_001.supplier(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: suppliervendor suppliervendor_suppliervendor_vendor_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.suppliervendor
    ADD CONSTRAINT suppliervendor_suppliervendor_vendor_fk_fkey FOREIGN KEY (suppliervendor_vendor_fk) REFERENCES zambia__svs_001.vendor(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: surveilanceupdates_aggr_materialized surveilanceupdates_aggr_materialized__districtid_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.surveilanceupdates_aggr_materialized
    ADD CONSTRAINT surveilanceupdates_aggr_materialized__districtid_fk_fkey FOREIGN KEY (_districtid_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: surveilanceupdates_aggr_materialized surveilanceupdates_aggr_materialized__facilityid_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.surveilanceupdates_aggr_materialized
    ADD CONSTRAINT surveilanceupdates_aggr_materialized__facilityid_fk_fkey FOREIGN KEY (_facilityid_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: surveilanceupdates_aggr_materialized surveilanceupdates_aggr_materialized__provinceid_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.surveilanceupdates_aggr_materialized
    ADD CONSTRAINT surveilanceupdates_aggr_materialized__provinceid_fk_fkey FOREIGN KEY (_provinceid_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: surveilanceupdates_aggr_materialized surveilanceupdates_aggr_materialized__subdistrictid_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.surveilanceupdates_aggr_materialized
    ADD CONSTRAINT surveilanceupdates_aggr_materialized__subdistrictid_fk_fkey FOREIGN KEY (_subdistrictid_fk) REFERENCES zambia__svs_001.subdistrict(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: temprecord temprecord_record_fridge_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.temprecord
    ADD CONSTRAINT temprecord_record_fridge_fk_fkey FOREIGN KEY (record_fridge_fk) REFERENCES zambia__svs_001.fridge(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendordistrictstock vendordistrictstock_vendordistrictstock_district_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendordistrictstock
    ADD CONSTRAINT vendordistrictstock_vendordistrictstock_district_fk_fkey FOREIGN KEY (vendordistrictstock_district_fk) REFERENCES zambia__svs_001.district(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendordistrictstock vendordistrictstock_vendordistrictstock_districtpharmacym_fkey1; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendordistrictstock
    ADD CONSTRAINT vendordistrictstock_vendordistrictstock_districtpharmacym_fkey1 FOREIGN KEY (vendordistrictstock_districtpharmacymanager_stockout_fk) REFERENCES zambia__svs_001.districtpharmacymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendordistrictstock vendordistrictstock_vendordistrictstock_districtpharmacyma_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendordistrictstock
    ADD CONSTRAINT vendordistrictstock_vendordistrictstock_districtpharmacyma_fkey FOREIGN KEY (vendordistrictstock_districtpharmacymanager_lowstock_fk) REFERENCES zambia__svs_001.districtpharmacymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendordistrictstock vendordistrictstock_vendordistrictstock_vendorstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendordistrictstock
    ADD CONSTRAINT vendordistrictstock_vendordistrictstock_vendorstock_fk_fkey FOREIGN KEY (vendordistrictstock_vendorstock_fk) REFERENCES zambia__svs_001.vendorstock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorfacilitystock vendorfacilitystock_vendorfacilitystock_facility_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorfacilitystock
    ADD CONSTRAINT vendorfacilitystock_vendorfacilitystock_facility_fk_fkey FOREIGN KEY (vendorfacilitystock_facility_fk) REFERENCES zambia__svs_001.facility(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorfacilitystock vendorfacilitystock_vendorfacilitystock_facilitymanager_lo_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorfacilitystock
    ADD CONSTRAINT vendorfacilitystock_vendorfacilitystock_facilitymanager_lo_fkey FOREIGN KEY (vendorfacilitystock_facilitymanager_lowstock_fk) REFERENCES zambia__svs_001.facilitymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorfacilitystock vendorfacilitystock_vendorfacilitystock_facilitymanager_st_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorfacilitystock
    ADD CONSTRAINT vendorfacilitystock_vendorfacilitystock_facilitymanager_st_fkey FOREIGN KEY (vendorfacilitystock_facilitymanager_stockout_fk) REFERENCES zambia__svs_001.facilitymanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorfacilitystock vendorfacilitystock_vendorfacilitystock_vendorstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorfacilitystock
    ADD CONSTRAINT vendorfacilitystock_vendorfacilitystock_vendorstock_fk_fkey FOREIGN KEY (vendorfacilitystock_vendorstock_fk) REFERENCES zambia__svs_001.vendorstock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorprovincialstock vendorprovincialstock_vendorprovincialstock_province_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorprovincialstock
    ADD CONSTRAINT vendorprovincialstock_vendorprovincialstock_province_fk_fkey FOREIGN KEY (vendorprovincialstock_province_fk) REFERENCES zambia__svs_001.province(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorprovincialstock vendorprovincialstock_vendorprovincialstock_provincialdep_fkey1; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorprovincialstock
    ADD CONSTRAINT vendorprovincialstock_vendorprovincialstock_provincialdep_fkey1 FOREIGN KEY (vendorprovincialstock_provincialdepotmanager_stockout_fk) REFERENCES zambia__svs_001.provincialdepotmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorprovincialstock vendorprovincialstock_vendorprovincialstock_provincialdepo_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorprovincialstock
    ADD CONSTRAINT vendorprovincialstock_vendorprovincialstock_provincialdepo_fkey FOREIGN KEY (vendorprovincialstock_provincialdepotmanager_lowstock_fk) REFERENCES zambia__svs_001.provincialdepotmanager(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorprovincialstock vendorprovincialstock_vendorprovincialstock_vendorstock_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorprovincialstock
    ADD CONSTRAINT vendorprovincialstock_vendorprovincialstock_vendorstock_fk_fkey FOREIGN KEY (vendorprovincialstock_vendorstock_fk) REFERENCES zambia__svs_001.vendorstock(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorstock vendorstock_vendorstock_stringgroup_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorstock
    ADD CONSTRAINT vendorstock_vendorstock_stringgroup_fk_fkey FOREIGN KEY (vendorstock_stringgroup_fk) REFERENCES zambia__svs_001.stringgroup(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vendorstock vendorstock_vendorstock_vendor_fk_fkey; Type: FK CONSTRAINT; Schema: zambia__svs_001; Owner: -
--

ALTER TABLE ONLY zambia__svs_001.vendorstock
    ADD CONSTRAINT vendorstock_vendorstock_vendor_fk_fkey FOREIGN KEY (vendorstock_vendor_fk) REFERENCES zambia__svs_001.vendor(_id_) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

