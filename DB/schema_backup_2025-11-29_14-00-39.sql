--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: contact_message_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.contact_message_status AS ENUM (
    'readed',
    'unreaded',
    'archived',
    'deleted'
);


ALTER TYPE public.contact_message_status OWNER TO postgres;

--
-- Name: platforms; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.platforms AS ENUM (
    'instagram',
    'tiktok',
    'youtube',
    'facebook',
    'twitter'
);


ALTER TYPE public.platforms OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: add_admin_recommendations(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_admin_recommendations(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_creator_id TEXT := payload->>'creator_id';
  v_admin_id UUID := (payload->>'admin_id')::UUID;
  v_type TEXT := lower(payload->>'recommendation_type');
  v_allowed_types TEXT[] := ARRAY['staff_pick', 'trending', 'category_leader', 'rising_star'];
  v_new_id UUID;
BEGIN
  -- Validate required fields
  IF v_creator_id IS NULL OR v_admin_id IS NULL OR v_type IS NULL THEN
    RETURN error_response('Missing required fields: creator_id, admin_id, or recommendation_type');
  END IF;

  -- Check allowed types
  IF NOT v_type = ANY(v_allowed_types) THEN
    RETURN error_response('Invalid recommendation_type');
  END IF;

  -- Insert new recommendation
  INSERT INTO public.admin_recommendations (
    creator_id, admin_id, recommendation_type, priority_score,
    categories, reason, is_active, expires_at
  )
  VALUES (
    v_creator_id,
    v_admin_id,
    v_type,
    COALESCE((payload->>'priority_score')::INT, 0),
    COALESCE(payload->'categories', '[]'::jsonb)::TEXT[],
    payload->>'reason',
    COALESCE((payload->>'is_active')::BOOLEAN, true),
    (payload->>'expires_at')::timestamptz
  )
  RETURNING id INTO v_new_id;

  RETURN success_response('Admin recommendation added', jsonb_build_object('id', v_new_id));
END;
$$;


ALTER FUNCTION public.add_admin_recommendations(payload jsonb) OWNER TO postgres;

--
-- Name: add_campaign_applications(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_campaign_applications(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_campaign_id UUID := (payload->>'campaign_id')::UUID;
  v_creator_id TEXT := payload->>'creator_id';
  v_existing UUID;
  v_application_id UUID;
BEGIN
  -- Validate required fields
  IF v_campaign_id IS NULL OR v_creator_id IS NULL THEN
    RETURN error_response('Missing required fields: campaign_id or creator_id');
  END IF;

  -- Check for existing application (unique constraint)
  SELECT id INTO v_existing FROM public.campaign_applications
  WHERE campaign_id = v_campaign_id AND creator_id = v_creator_id;

  IF v_existing IS NOT NULL THEN
    RETURN error_response('Application already exists for this campaign and creator', 409);
  END IF;

  -- Insert new application
  INSERT INTO public.campaign_applications (
    campaign_id, creator_id, user_id, status, message,
    proposed_rate, deliverables, timeline
  )
  VALUES (
    v_campaign_id,
    v_creator_id,
    (payload->>'user_id')::UUID,
    COALESCE(payload->>'status', 'pending'),
    payload->>'message',
    (payload->>'proposed_rate')::NUMERIC,
    COALESCE(payload->'deliverables', '{}'::jsonb),
    COALESCE(payload->'timeline', '{}'::jsonb)
  )
  RETURNING id INTO v_application_id;

  RETURN success_response('Campaign application submitted successfully', jsonb_build_object('id', v_application_id));
END;
$$;


ALTER FUNCTION public.add_campaign_applications(payload jsonb) OWNER TO postgres;

--
-- Name: add_campaigns(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_campaigns(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_name TEXT := payload->>'name';
  v_campaign_id UUID;
BEGIN
  -- Validate required fields
  IF v_user_id IS NULL OR v_name IS NULL THEN
    RETURN error_response('Missing required fields: user_id or name');
  END IF;

  -- Insert into campaigns
  INSERT INTO public.campaigns (
    user_id, name, description, brand, category, target_audience,
    budget, budget_per_creator, timeline, requirements,
    deliverables, platforms, status
  )
  VALUES (
    v_user_id,
    v_name,
    payload->>'description',
    payload->>'brand',
    payload->>'category',
    COALESCE(payload->'target_audience', '{}'::jsonb),
    (payload->>'budget')::NUMERIC,
    (payload->>'budget_per_creator')::NUMERIC,
    COALESCE(payload->'timeline', '{}'::jsonb),
    COALESCE(payload->'requirements', '{}'::jsonb),
    COALESCE(payload->'deliverables', '[]'::jsonb)::TEXT[],
    COALESCE(payload->'platforms', '[]'::jsonb)::TEXT[],
    COALESCE(payload->>'status', 'draft')
  )
  RETURNING id INTO v_campaign_id;

  RETURN success_response('Campaign created successfully', jsonb_build_object('id', v_campaign_id));
END;
$$;


ALTER FUNCTION public.add_campaigns(payload jsonb) OWNER TO postgres;

--
-- Name: add_contact_message(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_contact_message(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$declare
  effective_user_id uuid;
  v_subject text;
  v_message text;
  v_email text;
  v_first_name text;
  v_last_name text;
begin
  -- Extract fields from JSON payload
  v_subject := payload ->> 'subject';
  v_message := payload ->> 'message';
  v_email := payload ->> 'email';
  v_first_name := payload ->> 'first_name';
  v_last_name := payload ->> 'last_name';


  -- Validate required fields
  if v_subject is null or v_message is null then
    return jsonb_build_object(
      'status', 'error',
      'code', 400,
      'message', 'Payload must contain subject and message'
    );
  end if;
  
  if v_first_name is null or v_last_name is null then
    return jsonb_build_object(
      'status', 'error',
      'code', 400,
      'message', 'Payload must contain first name and last name'
    );
  end if;

  if v_email is null then
    return jsonb_build_object(
      'status', 'error',
      'code', 400,
      'message', 'Email is required'
    );
  end if;

  -- Validate email format (simple regex)
  if v_email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' then
    return jsonb_build_object(
      'status', 'error',
      'code', 400,
      'message', 'Invalid email format'
    );
  end if;

  -- Ensure user is logged in
  effective_user_id := auth.uid();
  if effective_user_id is null then
    return jsonb_build_object(
      'status', 'error',
      'code', 401,
      'message', 'You must be logged in to submit a message'
    );
  end if;

  -- Insert the contact message
  insert into public.contact_messages(user_id, email, subject, message , first_name , last_name)
  values (effective_user_id, v_email, v_subject, v_message , v_first_name , v_last_name);

  --Return success response
  return jsonb_build_object(
    'status', 'success',
    'message', 'Message submitted successfully'
  );

exception
  when others then
    return jsonb_build_object(
      'status', 'error',
      'code', 500,
      'message', sqlerrm
    );
end;$_$;


ALTER FUNCTION public.add_contact_message(payload jsonb) OWNER TO postgres;

--
-- Name: add_conversations(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_conversations(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_creator_id TEXT := payload->>'creator_id';
  v_campaign_id UUID := (payload->>'campaign_id')::UUID;
  v_existing UUID;
  v_conversation_id UUID;
BEGIN
  -- Validate required fields
  IF v_user_id IS NULL OR v_creator_id IS NULL OR v_campaign_id IS NULL THEN
    RETURN error_response('Missing required fields: user_id, creator_id, or campaign_id');
  END IF;

  -- Check if conversation already exists (based on unique constraint)
  SELECT id INTO v_existing FROM public.conversations
  WHERE user_id = v_user_id AND creator_id = v_creator_id AND campaign_id = v_campaign_id;

  IF v_existing IS NOT NULL THEN
    RETURN success_response('Conversation already exists', jsonb_build_object('id', v_existing));
  END IF;

  -- Insert new conversation
  INSERT INTO public.conversations (
    user_id, creator_id, campaign_id, status
  )
  VALUES (
    v_user_id,
    v_creator_id,
    v_campaign_id,
    COALESCE(payload->>'status', 'active')
  )
  RETURNING id INTO v_conversation_id;

  RETURN success_response('Conversation started successfully', jsonb_build_object('id', v_conversation_id));
END;
$$;


ALTER FUNCTION public.add_conversations(payload jsonb) OWNER TO postgres;

--
-- Name: add_creator_promotions(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_creator_promotions(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_creator_id TEXT := payload->>'creator_id';
  v_package_id UUID := (payload->>'package_id')::UUID;
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_amount NUMERIC := (payload->>'amount_paid')::NUMERIC;
  v_status TEXT := lower(payload->>'status');
  v_payment_status TEXT := lower(payload->>'payment_status');
  v_allowed_status TEXT[] := ARRAY['pending', 'active', 'expired', 'cancelled'];
  v_allowed_payment TEXT[] := ARRAY['pending', 'completed', 'failed', 'refunded'];
  v_promotion_id UUID;
BEGIN
  -- Validate required fields
  IF v_creator_id IS NULL OR v_package_id IS NULL OR v_user_id IS NULL OR v_amount IS NULL THEN
    RETURN error_response('Missing required fields: creator_id, package_id, user_id, or amount_paid');
  END IF;

  -- Validate enums
  IF v_status IS NOT NULL AND NOT v_status = ANY(v_allowed_status) THEN
    RETURN error_response('Invalid promotion status');
  END IF;

  IF v_payment_status IS NOT NULL AND NOT v_payment_status = ANY(v_allowed_payment) THEN
    RETURN error_response('Invalid payment status');
  END IF;

  -- Insert promotion
  INSERT INTO public.creator_promotions (
    creator_id, package_id, user_id, status, starts_at, expires_at,
    amount_paid, payment_status, placement_score, target_categories,
    performance_metrics
  )
  VALUES (
    v_creator_id,
    v_package_id,
    v_user_id,
    COALESCE(v_status, 'pending'),
    now(),
    (payload->>'expires_at')::timestamptz,
    v_amount,
    COALESCE(v_payment_status, 'pending'),
    (payload->>'placement_score')::INT,
    COALESCE(payload->'target_categories', '[]'::jsonb)::TEXT[],
    COALESCE(payload->'performance_metrics', '{}'::jsonb)
  )
  RETURNING id INTO v_promotion_id;

  RETURN success_response('Creator promotion added', jsonb_build_object('id', v_promotion_id));
END;
$$;


ALTER FUNCTION public.add_creator_promotions(payload jsonb) OWNER TO postgres;

--
-- Name: add_creator_search_logs(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_creator_search_logs(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_creator_name TEXT := payload->>'creator_name';
  v_platform TEXT := lower(payload->>'platform');
  v_allowed_platforms TEXT[] := ARRAY['instagram', 'tiktok', 'youtube', 'twitter', 'facebook'];
  v_log_id UUID;
BEGIN
  -- Validate required fields
  IF v_user_id IS NULL OR v_creator_name IS NULL OR v_platform IS NULL THEN
    RETURN error_response('Missing required fields: user_id, creator_name, or platform');
  END IF;

  -- Validate platform
  IF NOT v_platform = ANY(v_allowed_platforms) THEN
    RETURN error_response('Invalid platform');
  END IF;

  -- Insert search log
  INSERT INTO public.creator_search_logs (
    user_id, creator_name, platform
  )
  VALUES (
    v_user_id,
    v_creator_name,
    v_platform
  )
  RETURNING id INTO v_log_id;

  RETURN success_response('Creator search logged', jsonb_build_object('id', v_log_id));
END;
$$;


ALTER FUNCTION public.add_creator_search_logs(payload jsonb) OWNER TO postgres;

--
-- Name: add_creator_views(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_creator_views(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_creator_id TEXT := payload->>'creator_id';
  v_action TEXT := lower(payload->>'action');
  v_allowed_actions TEXT[] := ARRAY['viewed', 'shortlisted', 'rejected', 'messaged'];
  v_view_id UUID;
BEGIN
  -- Validate required fields
  IF v_user_id IS NULL OR v_creator_id IS NULL OR v_action IS NULL THEN
    RETURN error_response('Missing required fields: user_id, creator_id, or action');
  END IF;

  -- Validate action type
  IF NOT v_action = ANY(v_allowed_actions) THEN
    RETURN error_response('Invalid action type. Allowed: viewed, shortlisted, rejected, messaged');
  END IF;

  -- Insert creator view
  INSERT INTO public.creator_views (
    user_id, creator_id, action
  )
  VALUES (
    v_user_id,
    v_creator_id,
    v_action
  )
  RETURNING id INTO v_view_id;

  RETURN success_response('Creator view logged', jsonb_build_object('id', v_view_id));
END;
$$;


ALTER FUNCTION public.add_creator_views(payload jsonb) OWNER TO postgres;

--
-- Name: add_creators(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_creators(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_username TEXT := lower(payload->>'username');
  v_platform TEXT := lower(payload->>'platform');
  v_name TEXT := payload->>'name';
  v_id TEXT;
BEGIN
  -- Validate required fields
  IF v_username IS NULL OR v_platform IS NULL OR v_name IS NULL THEN
    RETURN error_response('Missing required fields: username, platform, or name');
  END IF;

  -- Generate ID as: creator_<username>
  v_id := 'creator_' || regexp_replace(v_username, '[^a-z0-9_]', '_', 'gi');

  -- Check if creator already exists
  IF EXISTS (SELECT 1 FROM public.creators WHERE id = v_id) THEN
    RETURN error_response('Creator already exists with id: ' || v_id, 409);
  END IF;

  -- Insert into creators table
  INSERT INTO public.creators (
    id, name, username, platform, avatar_url, bio, followers, engagement_rate,
    category, location, verified, contact_email, rate_per_post, rate_per_story,
    rate_per_reel, languages, audience_demographics, content_categories,
    recent_posts, match_score, match_reason
  )
  VALUES (
    v_id,
    v_name,
    v_username,
    v_platform,
    payload->>'avatar_url',
    payload->>'bio',
    (payload->>'followers')::INT,
    (payload->>'engagement_rate')::NUMERIC,
    payload->>'category',
    payload->>'location',
    (payload->>'verified')::BOOLEAN,
    payload->>'contact_email',
    (payload->>'rate_per_post')::NUMERIC,
    (payload->>'rate_per_story')::NUMERIC,
    (payload->>'rate_per_reel')::NUMERIC,
    COALESCE(payload->'languages', '[]'::jsonb)::TEXT[],
    COALESCE(payload->'audience_demographics', '{}'::jsonb),
    COALESCE(payload->'content_categories', '[]'::jsonb)::TEXT[],
    COALESCE(payload->'recent_posts', '[]'::jsonb),
    (payload->>'match_score')::INT,
    payload->>'match_reason'
  );

  RETURN success_response('Creator added successfully', jsonb_build_object('id', v_id));
END;
$$;


ALTER FUNCTION public.add_creators(payload jsonb) OWNER TO postgres;

--
-- Name: add_media_mentions(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_media_mentions(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_creator_id TEXT := payload->>'creator_id';
  v_platform TEXT := lower(payload->>'platform');
  v_mention_type TEXT := lower(payload->>'mention_type');
  v_keyword TEXT := payload->>'keyword';
  v_mentioned_at TIMESTAMPTZ := (payload->>'mentioned_at')::timestamptz;
  v_allowed_platforms TEXT[] := ARRAY['instagram', 'tiktok', 'youtube', 'twitter', 'facebook'];
  v_allowed_types TEXT[] := ARRAY['hashtag', 'mention', 'keyword'];
  v_mention_id UUID;
BEGIN
  -- Validate required fields
  IF v_creator_id IS NULL OR v_platform IS NULL OR v_mention_type IS NULL OR v_keyword IS NULL THEN
    RETURN error_response('Missing required fields: creator_id, platform, mention_type, or keyword');
  END IF;

  -- Validate values
  IF NOT v_platform = ANY(v_allowed_platforms) THEN
    RETURN error_response('Invalid platform');
  END IF;

  IF NOT v_mention_type = ANY(v_allowed_types) THEN
    RETURN error_response('Invalid mention_type');
  END IF;

  -- Insert mention
  INSERT INTO public.media_mentions (
    creator_id, platform, mention_type, keyword, context, mentioned_at
  )
  VALUES (
    v_creator_id,
    v_platform,
    v_mention_type,
    v_keyword,
    payload->>'context',
    v_mentioned_at
  )
  RETURNING id INTO v_mention_id;

  RETURN success_response('Media mention logged', jsonb_build_object('id', v_mention_id));
END;
$$;


ALTER FUNCTION public.add_media_mentions(payload jsonb) OWNER TO postgres;

--
-- Name: add_messages(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_messages(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_conversation_id UUID := (payload->>'conversation_id')::UUID;
  v_sender_id UUID := (payload->>'sender_id')::UUID;
  v_recipient_id UUID := (payload->>'recipient_id')::UUID;
  v_sender_type TEXT := lower(payload->>'sender_type');
  v_recipient_type TEXT := lower(payload->>'recipient_type');
  v_content TEXT := payload->>'content';
  v_message_id UUID;
BEGIN
  -- Validate required fields
  IF v_conversation_id IS NULL OR v_sender_id IS NULL OR v_recipient_id IS NULL OR v_sender_type IS NULL OR v_recipient_type IS NULL OR v_content IS NULL THEN
    RETURN error_response('Missing required fields: conversation_id, sender, recipient, types, or content');
  END IF;

  -- Validate sender/recipient types
  IF v_sender_type NOT IN ('user', 'creator', 'system') THEN
    RETURN error_response('Invalid sender_type');
  END IF;

  IF v_recipient_type NOT IN ('user', 'creator', 'system') THEN
    RETURN error_response('Invalid recipient_type');
  END IF;

  -- Insert message
  INSERT INTO public.messages (
    conversation_id, sender_id, recipient_id,
    sender_type, recipient_type, content,
    message_type, attachments
  )
  VALUES (
    v_conversation_id,
    v_sender_id,
    v_recipient_id,
    v_sender_type,
    v_recipient_type,
    v_content,
    COALESCE(payload->>'message_type', 'text'),
    COALESCE(payload->'attachments', '[]'::jsonb)
  )
  RETURNING id INTO v_message_id;

  RETURN success_response('Message sent successfully', jsonb_build_object('id', v_message_id));
END;
$$;


ALTER FUNCTION public.add_messages(payload jsonb) OWNER TO postgres;

--
-- Name: add_promotional_analytics(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_promotional_analytics(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_promotion_id UUID := (payload->>'promotion_id')::UUID;
  v_date DATE := (payload->>'date')::DATE;
  v_analytics_id UUID;
BEGIN
  -- Validate required fields
  IF v_promotion_id IS NULL OR v_date IS NULL THEN
    RETURN error_response('Missing required fields: promotion_id or date');
  END IF;

  -- Check for existing analytics entry for same date
  IF EXISTS (
    SELECT 1 FROM public.promotional_analytics
    WHERE promotion_id = v_promotion_id AND date = v_date
  ) THEN
    RETURN error_response('Analytics already exists for this promotion and date', 409);
  END IF;

  -- Insert analytics
  INSERT INTO public.promotional_analytics (
    promotion_id, date, views, clicks, conversions, revenue
  )
  VALUES (
    v_promotion_id,
    v_date,
    COALESCE((payload->>'views')::INT, 0),
    COALESCE((payload->>'clicks')::INT, 0),
    COALESCE((payload->>'conversions')::INT, 0),
    COALESCE((payload->>'revenue')::NUMERIC, 0)
  )
  RETURNING id INTO v_analytics_id;

  RETURN success_response('Promotional analytics recorded', jsonb_build_object('id', v_analytics_id));
END;
$$;


ALTER FUNCTION public.add_promotional_analytics(payload jsonb) OWNER TO postgres;

--
-- Name: add_promotional_packages(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_promotional_packages(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_name TEXT := payload->>'name';
  v_price NUMERIC := (payload->>'price')::NUMERIC;
  v_duration INT := (payload->>'duration_days')::INT;
  v_package_id UUID;
BEGIN
  -- Validate required fields
  IF v_name IS NULL OR v_price IS NULL OR v_duration IS NULL THEN
    RETURN error_response('Missing required fields: name, price, or duration_days');
  END IF;

  -- Insert package
  INSERT INTO public.promotional_packages (
    name, description, price, duration_days, features,
    placement_boost, highlighted, category_targeting,
    analytics_included, priority_support, is_active
  )
  VALUES (
    v_name,
    payload->>'description',
    v_price,
    v_duration,
    COALESCE(payload->'features', '{}'::jsonb),
    (payload->>'placement_boost')::INT,
    COALESCE((payload->>'highlighted')::BOOLEAN, false),
    COALESCE((payload->>'category_targeting')::BOOLEAN, false),
    COALESCE((payload->>'analytics_included')::BOOLEAN, false),
    COALESCE((payload->>'priority_support')::BOOLEAN, false),
    COALESCE((payload->>'is_active')::BOOLEAN, true)
  )
  RETURNING id INTO v_package_id;

  RETURN success_response('Promotional package created', jsonb_build_object('id', v_package_id));
END;
$$;


ALTER FUNCTION public.add_promotional_packages(payload jsonb) OWNER TO postgres;

--
-- Name: add_saved_creators(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_saved_creators(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_creator_id TEXT := payload->>'creator_id';
  v_existing UUID;
  v_saved_id UUID;
BEGIN
  -- Validate required fields
  IF v_user_id IS NULL OR v_creator_id IS NULL THEN
    RETURN error_response('Missing required fields: user_id or creator_id');
  END IF;

  -- Check if already saved (unique constraint)
  SELECT id INTO v_existing
  FROM public.saved_creators
  WHERE user_id = v_user_id AND creator_id = v_creator_id;

  IF v_existing IS NOT NULL THEN
    RETURN error_response('Creator already saved by this user', 409);
  END IF;

  -- Insert saved creator
  INSERT INTO public.saved_creators (
    user_id, creator_id, notes, tags
  )
  VALUES (
    v_user_id,
    v_creator_id,
    payload->>'notes',
    COALESCE(payload->'tags', '[]'::jsonb)::TEXT[]
  )
  RETURNING id INTO v_saved_id;

  RETURN success_response('Creator saved successfully', jsonb_build_object('id', v_saved_id));
END;
$$;


ALTER FUNCTION public.add_saved_creators(payload jsonb) OWNER TO postgres;

--
-- Name: add_saved_search_filters(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_saved_search_filters(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_name TEXT := payload->>'name';
  v_filters JSONB := payload->'filters';
  v_filter_id UUID;
BEGIN
  -- Validate required fields
  IF v_user_id IS NULL OR v_name IS NULL OR v_filters IS NULL THEN
    RETURN error_response('Missing required fields: user_id, name, or filters');
  END IF;

  -- Insert filter
  INSERT INTO public.saved_search_filters (
    user_id, name, filters
  )
  VALUES (
    v_user_id,
    v_name,
    v_filters
  )
  RETURNING id INTO v_filter_id;

  RETURN success_response('Search filter saved', jsonb_build_object('id', v_filter_id));
END;
$$;


ALTER FUNCTION public.add_saved_search_filters(payload jsonb) OWNER TO postgres;

--
-- Name: add_subscription(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_subscription(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_id uuid;
  v_user uuid := COALESCE((payload->>'user_id')::uuid, auth.uid());
  v_plan uuid := (payload->>'plan_id')::uuid;
  v_cycle text;
  v_end   timestamptz;
BEGIN
  IF v_plan IS NULL THEN
    RETURN error_response('plan_id is required');
  END IF;

  -- Compute end_date based on plan billing_cycle unless provided
  SELECT billing_cycle INTO v_cycle FROM public.subscription_plans WHERE id = v_plan;
  IF v_cycle IS NULL THEN
    RETURN error_response('Invalid plan_id');
  END IF;

  v_end := (payload->>'end_date')::timestamptz;
  IF v_end IS NULL THEN
    v_end := CASE v_cycle WHEN 'yearly' THEN now() + interval '1 year'
                          ELSE now() + interval '1 month' END;
  END IF;

  -- Cancel any currently active sub (soft approach) — optional
  UPDATE public.subscriptions
     SET status = 'cancelled', updated_at = now()
   WHERE user_id = v_user AND status = 'active' AND (end_date IS NULL OR end_date > now());

  INSERT INTO public.subscriptions(user_id, plan_id, status, start_date, end_date, auto_renew, trial_ends_at, external_ref, payment_metadata)
  VALUES (
    v_user, v_plan, 'active', now(), v_end,
    COALESCE((payload->>'auto_renew')::boolean, true),
    (payload->>'trial_ends_at')::timestamptz,
    NULLIF(payload->>'external_ref',''),
    COALESCE(payload->'payment_metadata','{}'::jsonb)
  )
  RETURNING id INTO v_id;

  -- Trigger will sync users.subscription_* fields
  RETURN success_response('Subscription started', jsonb_build_object('id', v_id, 'user_id', v_user, 'end_date', v_end));
END;
$$;


ALTER FUNCTION public.add_subscription(payload jsonb) OWNER TO postgres;

--
-- Name: add_subscription_plan(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_subscription_plan(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE v_id uuid;
BEGIN
  INSERT INTO public.subscription_plans(name, code, price, currency, billing_cycle, description, features, is_active)
  VALUES (
    payload->>'name',
    lower(payload->>'code'),
    COALESCE((payload->>'price')::numeric, 0),
    COALESCE(NULLIF(payload->>'currency',''), 'USD'),
    COALESCE(NULLIF(payload->>'billing_cycle',''), 'monthly'),
    payload->>'description',
    COALESCE(payload->'features','{}'::jsonb),
    COALESCE((payload->>'is_active')::boolean, true)
  )
  RETURNING id INTO v_id;

  RETURN success_response('Plan created', jsonb_build_object('id', v_id));
EXCEPTION WHEN unique_violation THEN
  RETURN error_response('Plan name/code already exists');
END;
$$;


ALTER FUNCTION public.add_subscription_plan(payload jsonb) OWNER TO postgres;

--
-- Name: create_user_session(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user_session(payload jsonb DEFAULT '{}'::jsonb) RETURNS uuid
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
declare
  v_user_id    uuid := auth.uid();
  v_session_id uuid := gen_random_uuid();
begin
  if v_user_id is null then
    raise exception 'Not authenticated';
  end if;

  insert into public.user_sessions (session_id, user_id)
  values (v_session_id, v_user_id);

  return v_session_id;
end;
$$;


ALTER FUNCTION public.create_user_session(payload jsonb) OWNER TO postgres;

--
-- Name: delete_contact_message(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_contact_message(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
  current_user_id uuid;
  is_admin_user boolean;
  p_id uuid;
begin
  -- Extract ID from payload
  p_id := (payload->>'id')::uuid;

  -- Check logged-in user
  current_user_id := auth.uid();
  if current_user_id is null then
    return jsonb_build_object(
      'status', 'error',
      'code', 401,
      'message', 'Not authenticated'
    );
  end if;

  -- Check admin
  select u.is_admin
  into is_admin_user
  from public.users u
  where u.id = current_user_id;

  if not coalesce(is_admin_user, false) then
    return jsonb_build_object(
      'status', 'error',
      'code', 403,
      'message', 'Not authorized'
    );
  end if;

  -- Delete the message
  delete from public.contact_messages where id = p_id;

  if not found then
    return jsonb_build_object(
      'status', 'error',
      'code', 404,
      'message', 'Message not found'
    );
  end if;

  return jsonb_build_object(
    'status', 'success',
    'message', 'Message deleted successfully',
    'data', jsonb_build_object('id', p_id)
  );

exception
  when others then
    return jsonb_build_object(
      'status', 'error',
      'code', 500,
      'message', sqlerrm
    );
end;
$$;


ALTER FUNCTION public.delete_contact_message(payload jsonb) OWNER TO postgres;

--
-- Name: error_response(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.error_response(message text, code integer DEFAULT 400) RETURNS jsonb
    LANGUAGE sql
    AS $$
  SELECT jsonb_build_object(
    'status', 'error',
    'code', code,
    'message', message
  );
$$;


ALTER FUNCTION public.error_response(message text, code integer) OWNER TO postgres;

--
-- Name: get_admin_recommendations(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_admin_recommendations(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_platform TEXT := lower(payload->>'platform');
  v_category TEXT := lower(payload->>'category');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  -- Count matching recommendations
  SELECT COUNT(*) INTO v_total
  FROM public.admin_recommendations r
  JOIN public.creators c ON r.creator_id = c.id
  WHERE
    (v_user_id IS NULL OR r.user_id = v_user_id)
    AND (v_platform IS NULL OR lower(c.platform) = v_platform)
    AND (v_category IS NULL OR lower(c.category) = v_category);

  -- Fetch paginated results
  SELECT jsonb_agg(to_jsonb(row)) INTO v_result
  FROM (
    SELECT
      r.id,
      r.user_id,
      r.creator_id,
      r.reason,
      r.created_at,
      c.name,
      c.username,
      c.platform,
      c.category,
      c.followers,
      c.engagement_rate,
      c.avatar_url
    FROM public.admin_recommendations r
    JOIN public.creators c ON r.creator_id = c.id
    WHERE
      (v_user_id IS NULL OR r.user_id = v_user_id)
      AND (v_platform IS NULL OR lower(c.platform) = v_platform)
      AND (v_category IS NULL OR lower(c.category) = v_category)
    ORDER BY r.created_at DESC
    LIMIT v_limit OFFSET v_offset
  ) row;

  RETURN success_response(
    'Admin recommendations fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_admin_recommendations(payload jsonb) OWNER TO postgres;

--
-- Name: get_ai_queries(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ai_queries(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_type TEXT := lower(payload->>'type');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN error_response('Missing required field: user_id');
  END IF;

  -- Count total queries
  SELECT COUNT(*) INTO v_total
  FROM public.ai_queries
  WHERE user_id = v_user_id
    AND (v_type IS NULL OR lower(type) = v_type);

  -- Fetch queries with pagination
  SELECT jsonb_agg(to_jsonb(q)) INTO v_result
  FROM (
    SELECT *
    FROM public.ai_queries
    WHERE user_id = v_user_id
      AND (v_type IS NULL OR lower(type) = v_type)
    ORDER BY created_at DESC
    LIMIT v_limit OFFSET v_offset
  ) q;

  RETURN success_response(
    'AI queries fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_ai_queries(payload jsonb) OWNER TO postgres;

--
-- Name: get_campaign_applications(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_campaign_applications(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_campaign_id UUID := (payload->>'campaign_id')::UUID;
  v_creator_id TEXT := payload->>'creator_id';
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_status TEXT := lower(payload->>'status');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  -- Count total applications matching filters
  SELECT COUNT(*) INTO v_total
  FROM public.campaign_applications
  WHERE
    (v_campaign_id IS NULL OR campaign_id = v_campaign_id)
    AND (v_creator_id IS NULL OR creator_id = v_creator_id)
    AND (v_user_id IS NULL OR user_id = v_user_id)
    AND (v_status IS NULL OR lower(status) = v_status);

  -- Fetch paginated results
  SELECT jsonb_agg(to_jsonb(c)) INTO v_result
  FROM (
    SELECT *
    FROM public.campaign_applications
    WHERE
      (v_campaign_id IS NULL OR campaign_id = v_campaign_id)
      AND (v_creator_id IS NULL OR creator_id = v_creator_id)
      AND (v_user_id IS NULL OR user_id = v_user_id)
      AND (v_status IS NULL OR lower(status) = v_status)
    ORDER BY submitted_at DESC
    LIMIT v_limit
    OFFSET v_offset
  ) c;

  RETURN success_response(
    'Campaign applications fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_campaign_applications(payload jsonb) OWNER TO postgres;

--
-- Name: get_campaigns(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_campaigns(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_search TEXT := lower(payload->>'search');
  v_status TEXT := lower(payload->>'status');
  v_platform TEXT := lower(payload->>'platform');
  v_category TEXT := lower(payload->>'category');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  result JSONB;
  total_count INT;
BEGIN
  -- Count total matching rows
  SELECT COUNT(*) INTO total_count
  FROM public.campaigns
  WHERE
    (v_user_id IS NULL OR user_id = v_user_id)
    AND (
      v_search IS NULL OR
      lower(name) ILIKE '%' || v_search || '%' OR
      lower(brand) ILIKE '%' || v_search || '%' OR
      lower(category) ILIKE '%' || v_search || '%'
    )
    AND (v_status IS NULL OR lower(status) = v_status)
    AND (v_category IS NULL OR lower(category) = v_category)
    AND (v_platform IS NULL OR v_platform = ANY(platforms));

  -- Fetch filtered & paginated data
  SELECT jsonb_agg(to_jsonb(c)) INTO result
  FROM (
    SELECT *
    FROM public.campaigns
    WHERE
      (v_user_id IS NULL OR user_id = v_user_id)
      AND (
        v_search IS NULL OR
        lower(name) ILIKE '%' || v_search || '%' OR
        lower(brand) ILIKE '%' || v_search || '%' OR
        lower(category) ILIKE '%' || v_search || '%'
      )
      AND (v_status IS NULL OR lower(status) = v_status)
      AND (v_category IS NULL OR lower(category) = v_category)
      AND (v_platform IS NULL OR v_platform = ANY(platforms))
    ORDER BY created_at DESC
    LIMIT v_limit OFFSET v_offset
  ) c;

  RETURN success_response(
    'Campaigns fetched successfully',
    jsonb_build_object(
      'total', total_count,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_campaigns(payload jsonb) OWNER TO postgres;

--
-- Name: get_contact_messages(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_contact_messages(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$declare
  current_user_id uuid;
  is_admin_user boolean;
  v_limit int := 20;
  v_offset int := 0;
  v_status text;
  v_from timestamptz;
  v_to timestamptz;
  v_result jsonb;
  v_statuses text[];
begin
  -- Get logged-in user
  current_user_id := auth.uid();
  if current_user_id is null then
    return jsonb_build_object(
      'status', 'error',
      'code', 401,
      'message', 'Not authenticated'
    );
  end if;

  -- Check if user is admin
  select u.is_admin into is_admin_user
  from public.users u
  where u.id = current_user_id;

  if not coalesce(is_admin_user, false) then
    return jsonb_build_object(
      'status', 'error',
      'code', 403,
      'message', 'Not authorized'
    );
  end if;

  -- Extract filters from payload
  if payload ? 'limit' then
    v_limit := coalesce((payload->>'limit')::int, 20);
  end if;
  if payload ? 'offset' then
    v_offset := coalesce((payload->>'offset')::int, 0);
  end if;
  if payload ? 'status' then
    v_status := lower(payload->>'status');
  end if;
  if payload ? 'from' then
    v_from := (payload->>'from')::timestamptz;
  end if;
  if payload ? 'to' then
    v_to := (payload->>'to')::timestamptz;
  end if;

  -- Fetch allowed statuses dynamically from the enum
  select array_agg(enumlabel::text)
  into v_statuses
  from pg_enum
  join pg_type on pg_enum.enumtypid = pg_type.oid
  where pg_type.typname = 'contact_message_status';

  -- Use CTE for total count and paginated results
  with base as (
    select *
    from public.contact_messages cm
    where (v_status is null or lower(cm.status::text) = v_status)
      and (v_from is null or cm.created_at >= v_from)
      and (v_to is null or cm.created_at <= v_to)
  ),
  total_ct as (
    select count(*)::int as total from base
  ),
  page as (
    select *
    from base
    order by created_at desc
    limit v_limit
    offset v_offset
  )
  select jsonb_build_object(
           'results', coalesce(jsonb_agg(to_jsonb(page)), '[]'::jsonb),
           'total', (select total from total_ct),
           'limit', v_limit,
           'offset', v_offset,
           'statuses', coalesce(to_jsonb(v_statuses), '[]'::jsonb)
         )
  into v_result
  from page;

  return success_response('Messages fetched successfully', v_result);

exception
  when others then
    return jsonb_build_object(
      'status', 'error',
      'code', 500,
      'message', sqlerrm
    );
end;$$;


ALTER FUNCTION public.get_contact_messages(payload jsonb) OWNER TO postgres;

--
-- Name: get_conversations(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_conversations(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_creator_id TEXT := payload->>'creator_id';
  v_agent_id UUID := (payload->>'agent_id')::UUID;
  v_search TEXT := lower(payload->>'search');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN error_response('Missing required field: user_id');
  END IF;

  -- Count total conversations
  SELECT COUNT(*)
  INTO v_total
  FROM public.conversations conv
  WHERE conv.user_id = v_user_id
    AND (v_creator_id IS NULL OR conv.creator_id = v_creator_id)
    AND (v_agent_id IS NULL OR conv.agent_id = v_agent_id)
    AND (
      v_search IS NULL OR
      EXISTS (
        SELECT 1
        FROM messages m
        WHERE m.conversation_id = conv.id
          AND lower(m.content) ILIKE '%' || v_search || '%'
      )
    );

  -- Fetch conversations with latest message
  SELECT jsonb_agg(to_jsonb(row)) INTO v_result
  FROM (
    SELECT
      conv.*,
      (
        SELECT m.content
        FROM messages m
        WHERE m.conversation_id = conv.id
        ORDER BY m.created_at DESC
        LIMIT 1
      ) AS latest_message
    FROM public.conversations conv
    WHERE conv.user_id = v_user_id
      AND (v_creator_id IS NULL OR conv.creator_id = v_creator_id)
      AND (v_agent_id IS NULL OR conv.agent_id = v_agent_id)
      AND (
        v_search IS NULL OR
        EXISTS (
          SELECT 1
          FROM messages m
          WHERE m.conversation_id = conv.id
            AND lower(m.content) ILIKE '%' || v_search || '%'
        )
      )
    ORDER BY conv.updated_at DESC
    LIMIT v_limit OFFSET v_offset
  ) row;

  RETURN success_response(
    'Conversations fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_conversations(payload jsonb) OWNER TO postgres;

--
-- Name: get_country_city_pairs(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_country_city_pairs(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_country text := payload->>'country';     -- optional filter by country name
  v_city    text := payload->>'city';        -- optional filter by city name
  result    jsonb;
BEGIN
  WITH countries AS (
    SELECT id, name
    FROM public.countries
    WHERE level = 'country'
      AND (v_country IS NULL OR name ILIKE '%'||v_country||'%')
  ),
  cities AS (
    SELECT c.id, c.name, c.parent_id
    FROM public.countries c
    WHERE level = 'city'
      AND (v_city IS NULL OR c.name ILIKE '%'||v_city||'%')
  ),
  pairs AS (
    SELECT jsonb_build_object(
             'country', co.name,
             'city', ci.name
           ) AS pair
    FROM cities ci
    JOIN public.countries co ON co.id = ci.parent_id
  )
  SELECT jsonb_agg(pair)
  INTO result
  FROM pairs;

  RETURN success_response(
    'Country-City pairs fetched',
    COALESCE(result, '[]'::jsonb)
  );
END;
$$;


ALTER FUNCTION public.get_country_city_pairs(payload jsonb) OWNER TO postgres;

--
-- Name: get_creator_categories(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_creator_categories(payload jsonb DEFAULT '{}'::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object('category', category))
  INTO result
  FROM (
    SELECT DISTINCT category
    FROM public.creators
    WHERE category IS NOT NULL
    ORDER BY category
  ) sub;

  RETURN success_response(
    'Distinct categories fetched successfully',
    COALESCE(result, '[]'::jsonb)
  );
END;
$$;


ALTER FUNCTION public.get_creator_categories(payload jsonb) OWNER TO postgres;

--
-- Name: get_creator_platforms(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_creator_platforms(payload jsonb DEFAULT '{}'::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object('platform', platform))
  INTO result
  FROM (
    SELECT DISTINCT platform
    FROM public.creators
    WHERE platform IS NOT NULL
    ORDER BY platform
  ) sub;

  RETURN success_response(
    'Distinct platforms fetched successfully',
    COALESCE(result, '[]'::jsonb)
  );
END;
$$;


ALTER FUNCTION public.get_creator_platforms(payload jsonb) OWNER TO postgres;

--
-- Name: get_creator_promotions(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_creator_promotions(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_creator_id TEXT := payload->>'creator_id';
  v_promotion_type TEXT := lower(payload->>'promotion_type');
  v_status TEXT := lower(payload->>'status');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  IF v_creator_id IS NULL THEN
    RETURN error_response('Missing required field: creator_id');
  END IF;

  -- Count total matching records
  SELECT COUNT(*) INTO v_total
  FROM public.creator_promotions
  WHERE creator_id = v_creator_id
    AND (v_promotion_type IS NULL OR lower(promotion_type) = v_promotion_type)
    AND (v_status IS NULL OR lower(status) = v_status);

  -- Fetch filtered promotions
  SELECT jsonb_agg(to_jsonb(cp)) INTO v_result
  FROM (
    SELECT *
    FROM public.creator_promotions
    WHERE creator_id = v_creator_id
      AND (v_promotion_type IS NULL OR lower(promotion_type) = v_promotion_type)
      AND (v_status IS NULL OR lower(status) = v_status)
    ORDER BY created_at DESC
    LIMIT v_limit OFFSET v_offset
  ) cp;

  RETURN success_response(
    'Creator promotions fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_creator_promotions(payload jsonb) OWNER TO postgres;

--
-- Name: get_creator_search_logs(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_creator_search_logs(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_search TEXT := lower(payload->>'search');
  v_platform TEXT := lower(payload->>'platform');
  v_category TEXT := lower(payload->>'category');
  v_location TEXT := lower(payload->>'location');
  v_verified BOOLEAN := CASE WHEN payload ? 'verified' THEN (payload->>'verified')::BOOLEAN ELSE NULL END;
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  -- Count total search logs
  SELECT COUNT(*) INTO v_total
  FROM public.creator_search_logs
  WHERE
    (v_user_id IS NULL OR user_id = v_user_id) AND
    (v_search IS NULL OR lower(search_query) ILIKE '%' || v_search || '%') AND
    (v_platform IS NULL OR lower(platform_filter) = v_platform) AND
    (v_category IS NULL OR lower(category_filter) = v_category) AND
    (v_location IS NULL OR lower(location_filter) = v_location) AND
    (v_verified IS NULL OR verified_filter = v_verified);

  -- Fetch logs
  SELECT jsonb_agg(to_jsonb(row)) INTO v_result
  FROM (
    SELECT *
    FROM public.creator_search_logs
    WHERE
      (v_user_id IS NULL OR user_id = v_user_id) AND
      (v_search IS NULL OR lower(search_query) ILIKE '%' || v_search || '%') AND
      (v_platform IS NULL OR lower(platform_filter) = v_platform) AND
      (v_category IS NULL OR lower(category_filter) = v_category) AND
      (v_location IS NULL OR lower(location_filter) = v_location) AND
      (v_verified IS NULL OR verified_filter = v_verified)
    ORDER BY searched_at DESC
    LIMIT v_limit OFFSET v_offset
  ) row;

  RETURN success_response(
    'Creator search logs fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_creator_search_logs(payload jsonb) OWNER TO postgres;

--
-- Name: get_creator_views(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_creator_views(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_creator_id TEXT := payload->>'creator_id';
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  -- Count total matching views
  SELECT COUNT(*) INTO v_total
  FROM public.creator_views
  WHERE
    (v_user_id IS NULL OR user_id = v_user_id) AND
    (v_creator_id IS NULL OR creator_id = v_creator_id);

  -- Fetch paginated view records
  SELECT jsonb_agg(to_jsonb(row)) INTO v_result
  FROM (
    SELECT
      id,
      user_id,
      creator_id,
      viewed_at
    FROM public.creator_views
    WHERE
      (v_user_id IS NULL OR user_id = v_user_id) AND
      (v_creator_id IS NULL OR creator_id = v_creator_id)
    ORDER BY viewed_at DESC
    LIMIT v_limit OFFSET v_offset
  ) row;

  RETURN success_response(
    'Creator views fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_creator_views(payload jsonb) OWNER TO postgres;

--
-- Name: get_creators(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_creators(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$DECLARE
  v_search        TEXT    := payload->>'search';
  v_creator_id    TEXT    := payload->>'creator_id';
  v_platform      TEXT    := lower(payload->>'platform');
  v_category      TEXT    := lower(payload->>'category');
  v_username      TEXT    := lower(payload->>'username');
  v_location      TEXT    := lower(payload->>'location');
  v_verified      BOOLEAN := CASE WHEN payload ? 'verified' THEN (payload->>'verified')::BOOLEAN ELSE NULL END;
  v_followers_min INT     := COALESCE((payload->>'followers_min')::INT, 0);
  v_followers_max INT     := COALESCE((payload->>'followers_max')::INT, 1000000000);
  v_limit         INT     := COALESCE((payload->>'limit')::INT, 20);
  v_offset        INT     := COALESCE((payload->>'offset')::INT, 0);
  result JSONB;
BEGIN
  WITH base AS (
    SELECT *
    FROM public.creators
    WHERE
      -- Search by name, username, or bio
      (
        v_search IS NULL OR
        name ILIKE '%' || v_search || '%' OR
        username ILIKE '%' || v_search || '%' OR
        bio ILIKE '%' || v_search || '%'
      )
      -- Platform filter
      AND (v_platform IS NULL OR platform = v_platform)
      AND (v_username IS NULL OR username = v_username)
      AND (v_creator_id IS NULL OR id = v_creator_id)
      -- Category filter
      AND (v_category IS NULL OR lower(category) = v_category)
      -- Location filter
      AND (v_location IS NULL OR lower(location) = v_location)
      -- Verified filter
      AND (v_verified IS NULL OR verified = v_verified)
      -- Followers filter
      AND followers BETWEEN v_followers_min AND v_followers_max
  ),
  total_ct AS (
    SELECT COUNT(*)::INT AS total FROM base
  ),
  page AS (
    SELECT *
    FROM base
    ORDER BY followers DESC
    LIMIT v_limit
    OFFSET v_offset
  )
  SELECT jsonb_build_object(
           'rows',  COALESCE(jsonb_agg(to_jsonb(page)), '[]'::jsonb),
           'total', (SELECT total FROM total_ct),
           'limit', v_limit,
           'offset', v_offset
         )
  INTO result
  FROM page;

  RETURN success_response('Creators fetched successfully', COALESCE(result, jsonb_build_object(
    'rows','[]'::jsonb, 'total', 0, 'limit', v_limit, 'offset', v_offset
  )));
END;$$;


ALTER FUNCTION public.get_creators(payload jsonb) OWNER TO postgres;

--
-- Name: get_locations(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_locations(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_name     text := payload->>'name';      -- optional: filter by name substring
  v_level    text := payload->>'level';     -- optional: filter by level (country/city/etc.)
  v_parent   uuid := NULLIF(payload->>'parent_id','')::uuid;
  result     jsonb;
BEGIN
  WITH RECURSIVE path AS (
    SELECT c.id, c.name, c.level, c.parent_id, c.name::text AS full_path
    FROM public.countries c
    WHERE c.parent_id IS NULL
    UNION ALL
    SELECT ch.id, ch.name, ch.level, ch.parent_id,
           (p.full_path || ' → ' || ch.name)
    FROM public.countries ch
    JOIN path p ON ch.parent_id = p.id
  ),
  filtered AS (
    SELECT * FROM path
    WHERE (v_name IS NULL OR name ILIKE '%'||v_name||'%')
      AND (v_level IS NULL OR level = v_level)
      AND (v_parent IS NULL OR parent_id = v_parent)
  )
  SELECT jsonb_agg(jsonb_build_object(
           'id', id,
           'name', name,
           'level', level,
           'path', full_path
         ))
  INTO result
  FROM filtered;

  RETURN success_response(
    'Locations fetched',
    COALESCE(result, '[]'::jsonb)
  );
END;
$$;


ALTER FUNCTION public.get_locations(payload jsonb) OWNER TO postgres;

--
-- Name: get_media_mentions(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_media_mentions(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_creator_id TEXT := payload->>'creator_id';
  v_search TEXT := lower(payload->>'search');
  v_source TEXT := lower(payload->>'source');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  -- Count total media mentions
  SELECT COUNT(*) INTO v_total
  FROM public.media_mentions
  WHERE
    (v_creator_id IS NULL OR creator_id = v_creator_id) AND
    (v_search IS NULL OR lower(headline) ILIKE '%' || v_search || '%' OR lower(summary) ILIKE '%' || v_search || '%') AND
    (v_source IS NULL OR lower(source) = v_source);

  -- Fetch paginated mentions
  SELECT jsonb_agg(to_jsonb(row)) INTO v_result
  FROM (
    SELECT *
    FROM public.media_mentions
    WHERE
      (v_creator_id IS NULL OR creator_id = v_creator_id) AND
      (v_search IS NULL OR lower(headline) ILIKE '%' || v_search || '%' OR lower(summary) ILIKE '%' || v_search || '%') AND
      (v_source IS NULL OR lower(source) = v_source)
    ORDER BY published_at DESC
    LIMIT v_limit OFFSET v_offset
  ) row;

  RETURN success_response(
    'Media mentions fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_media_mentions(payload jsonb) OWNER TO postgres;

--
-- Name: get_messages(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_messages(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_conversation_id UUID := (payload->>'conversation_id')::UUID;
  v_limit INT := COALESCE((payload->>'limit')::INT, 30);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN error_response('Missing required field: user_id');
  END IF;

  IF v_conversation_id IS NULL THEN
    RETURN error_response('Missing required field: conversation_id');
  END IF;

  -- Verify ownership of conversation
  IF NOT EXISTS (
    SELECT 1
    FROM conversations
    WHERE id = v_conversation_id AND user_id = v_user_id
  ) THEN
    RETURN error_response('Invalid or unauthorized conversation');
  END IF;

  -- Count total messages
  SELECT COUNT(*)
  INTO v_total
  FROM messages
  WHERE conversation_id = v_conversation_id;

  -- Get paginated messages
  SELECT jsonb_agg(to_jsonb(m)) INTO v_result
  FROM (
    SELECT
      id,
      role,
      sender,
      content,
      metadata,
      created_at
    FROM messages
    WHERE conversation_id = v_conversation_id
    ORDER BY created_at ASC
    LIMIT v_limit OFFSET v_offset
  ) m;

  RETURN success_response(
    'Messages fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'messages', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_messages(payload jsonb) OWNER TO postgres;

--
-- Name: get_promotional_analytics(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_promotional_analytics(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_creator_id TEXT := payload->>'creator_id';
  v_campaign_id UUID := (payload->>'campaign_id')::UUID;
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_metric TEXT := lower(payload->>'metric'); -- e.g. "reach", "clicks"
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  -- Count matching analytics
  SELECT COUNT(*) INTO v_total
  FROM public.promotional_analytics
  WHERE
    (v_creator_id IS NULL OR creator_id = v_creator_id)
    AND (v_campaign_id IS NULL OR campaign_id = v_campaign_id)
    AND (v_user_id IS NULL OR user_id = v_user_id)
    AND (v_metric IS NULL OR lower(metric) = v_metric);

  -- Fetch paginated analytics
  SELECT jsonb_agg(to_jsonb(a)) INTO v_result
  FROM (
    SELECT *
    FROM public.promotional_analytics
    WHERE
      (v_creator_id IS NULL OR creator_id = v_creator_id)
      AND (v_campaign_id IS NULL OR campaign_id = v_campaign_id)
      AND (v_user_id IS NULL OR user_id = v_user_id)
      AND (v_metric IS NULL OR lower(metric) = v_metric)
    ORDER BY recorded_at DESC
    LIMIT v_limit OFFSET v_offset
  ) a;

  RETURN success_response(
    'Promotional analytics fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_promotional_analytics(payload jsonb) OWNER TO postgres;

--
-- Name: get_promotional_packages(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_promotional_packages(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_platform TEXT := lower(payload->>'platform');
  v_min_price NUMERIC := COALESCE((payload->>'min_price')::NUMERIC, 0);
  v_max_price NUMERIC := COALESCE((payload->>'max_price')::NUMERIC, 1000000);
  v_audience TEXT := lower(payload->>'audience');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  -- Count matching promotional packages
  SELECT COUNT(*) INTO v_total
  FROM public.promotional_packages
  WHERE
    (v_platform IS NULL OR lower(platform) = v_platform)
    AND (v_audience IS NULL OR lower(audience) = v_audience)
    AND price BETWEEN v_min_price AND v_max_price;

  -- Fetch filtered and paginated data
  SELECT jsonb_agg(to_jsonb(p)) INTO v_result
  FROM (
    SELECT *
    FROM public.promotional_packages
    WHERE
      (v_platform IS NULL OR lower(platform) = v_platform)
      AND (v_audience IS NULL OR lower(audience) = v_audience)
      AND price BETWEEN v_min_price AND v_max_price
    ORDER BY created_at DESC
    LIMIT v_limit OFFSET v_offset
  ) p;

  RETURN success_response(
    'Promotional packages fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_promotional_packages(payload jsonb) OWNER TO postgres;

--
-- Name: get_recent_platform_data(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_recent_platform_data(p_input jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    platform_key  text;
    result        jsonb := '{}'::jsonb;
    one_month_ago timestamptz := now() - interval '1 month';
    v_uid uuid;
BEGIN

    SELECT auth.uid() INTO v_uid;

    IF v_uid IS NULL OR v_uid::text <> '75c5d9dd-c634-4d14-8e74-e0b8947fa545' THEN
        RAISE EXCEPTION 'insufficient_privilege: this function is restricted to a specific user';
    END IF;

    -- Guard: ensure top-level is an object
    IF jsonb_typeof(p_input) IS DISTINCT FROM 'object' THEN
        RAISE EXCEPTION 'Input must be a JSON object keyed by platform names -> arrays of {username}';
    END IF;

    -- Iterate over platforms in the input (instagram, facebook, etc.)
    FOR platform_key IN
        SELECT key FROM jsonb_each(p_input)
    LOOP
        -- Build the array for this platform
        result := result || jsonb_build_object(
            platform_key,
            (
                WITH input_users AS (
                    SELECT trim(both from (elem->>'username')) AS username
                    FROM jsonb_array_elements(p_input -> platform_key) AS elem
                    WHERE jsonb_typeof(p_input -> platform_key) = 'array'
                )
                SELECT COALESCE(
                    jsonb_agg(
                        jsonb_build_object(
                            'username', iu.username,
                            'platform_data', c.platform_data
                        )
                    ),
                    '[]'::jsonb
                )
                FROM input_users iu
                LEFT JOIN LATERAL (
                    SELECT c.platform_data
                    FROM public.creators c
                    WHERE lower(c.platform) = lower(platform_key)
                      AND lower(c.username) = lower(iu.username)
                      AND c.created_at >= one_month_ago
                    ORDER BY c.created_at DESC
                    LIMIT 1
                ) c ON true
            )
        );
    END LOOP;

    RETURN result;
END;
$$;


ALTER FUNCTION public.get_recent_platform_data(p_input jsonb) OWNER TO postgres;

--
-- Name: get_saved_creators(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_saved_creators(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_search TEXT := lower(payload->>'search');
  v_platform TEXT := lower(payload->>'platform');
  v_category TEXT := lower(payload->>'category');
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN error_response('Missing required field: user_id');
  END IF;

  -- Count total saved creators matching filters
  SELECT COUNT(*)
  INTO v_total
  FROM public.saved_creators sc
  JOIN public.creators c ON sc.creator_id = c.id
  WHERE sc.user_id = v_user_id
    AND (v_search IS NULL OR
         lower(c.name) ILIKE '%' || v_search || '%' OR
         lower(c.username) ILIKE '%' || v_search || '%' OR
         lower(sc.notes) ILIKE '%' || v_search || '%')
    AND (v_platform IS NULL OR lower(c.platform) = v_platform)
    AND (v_category IS NULL OR lower(c.category) = v_category);

  -- Fetch paginated list of saved creators
  SELECT jsonb_agg(to_jsonb(result_row)) INTO v_result
  FROM (
    SELECT
      c.*,
      sc.id AS saved_id,
      sc.notes,
      sc.tags,
      sc.saved_at
    FROM public.saved_creators sc
    JOIN public.creators c ON sc.creator_id = c.id
    WHERE sc.user_id = v_user_id
      AND (v_search IS NULL OR
           lower(c.name) ILIKE '%' || v_search || '%' OR
           lower(c.username) ILIKE '%' || v_search || '%' OR
           lower(sc.notes) ILIKE '%' || v_search || '%')
      AND (v_platform IS NULL OR lower(c.platform) = v_platform)
      AND (v_category IS NULL OR lower(c.category) = v_category)
    ORDER BY sc.saved_at DESC
    LIMIT v_limit OFFSET v_offset
  ) result_row;

  RETURN success_response(
    'Saved creators fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_saved_creators(payload jsonb) OWNER TO postgres;

--
-- Name: get_saved_search_filters(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_saved_search_filters(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_user_id UUID := (payload->>'user_id')::UUID;
  v_limit INT := COALESCE((payload->>'limit')::INT, 20);
  v_offset INT := COALESCE((payload->>'offset')::INT, 0);
  v_total INT;
  v_result JSONB;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN error_response('Missing required field: user_id');
  END IF;

  -- Count total filters
  SELECT COUNT(*) INTO v_total
  FROM public.saved_search_filters
  WHERE user_id = v_user_id;

  -- Fetch paginated filters
  SELECT jsonb_agg(to_jsonb(f)) INTO v_result
  FROM (
    SELECT *
    FROM public.saved_search_filters
    WHERE user_id = v_user_id
    ORDER BY created_at DESC
    LIMIT v_limit OFFSET v_offset
  ) f;

  RETURN success_response(
    'Saved search filters fetched successfully',
    jsonb_build_object(
      'total', v_total,
      'limit', v_limit,
      'offset', v_offset,
      'results', COALESCE(v_result, '[]'::jsonb)
    )
  );
END;
$$;


ALTER FUNCTION public.get_saved_search_filters(payload jsonb) OWNER TO postgres;

--
-- Name: get_subscriptions(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_subscriptions(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  p_user   uuid := NULLIF(payload->>'user_id','')::uuid;
  p_status text := NULLIF(payload->>'status','');
  p_limit  int  := COALESCE((payload->>'limit')::int, 20);
  p_offset int  := COALESCE((payload->>'offset')::int, 0);
  rows jsonb; total int;
BEGIN
  WITH base AS (
    SELECT s.*, p.name AS plan_name, p.code AS plan_code, p.price, p.currency, p.billing_cycle
    FROM public.subscriptions s
    JOIN public.subscription_plans p ON p.id = s.plan_id
    WHERE (p_user IS NULL OR s.user_id = p_user)
      AND (p_status IS NULL OR s.status = p_status)
  ),
  page AS (
    SELECT * FROM base
    ORDER BY s.updated_at DESC
    LIMIT p_limit OFFSET p_offset
  )
  SELECT jsonb_agg(to_jsonb(page)), (SELECT count(*) FROM base)
  INTO rows, total
  FROM page;

  RETURN success_response('OK', jsonb_build_object('rows', COALESCE(rows,'[]'::jsonb), 'total', total, 'limit', p_limit, 'offset', p_offset));
END;
$$;


ALTER FUNCTION public.get_subscriptions(payload jsonb) OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  insert into public.users (
    id,
    email,
    full_name,
    avatar_url,
    company_name,
    industry,
    website,
    bio,
    location,
    phone,
    timezone
  )
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', null),
    coalesce(new.raw_user_meta_data->>'avatar_url', null),
    coalesce(new.raw_user_meta_data->>'company_name', null),
    coalesce(new.raw_user_meta_data->>'industry', null),
    coalesce(new.raw_user_meta_data->>'website', null),
    coalesce(new.raw_user_meta_data->>'bio', null),
    coalesce(new.raw_user_meta_data->>'location', null),
    coalesce(new.raw_user_meta_data->>'phone', null),
    coalesce(new.raw_user_meta_data->>'timezone', 'UTC')
  )
  on conflict (id) do nothing; -- avoid errors if already inserted

  return new;
end;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: insert_creator_from_payload(text, text, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_creator_from_payload(p_username text, p_platform text, p_data jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_platform text := lower(trim(p_platform));
  v_username text := trim(p_username);
  v_id       text;
  v_inserted_id text;
  v_uid uuid;
BEGIN

SELECT auth.uid() INTO v_uid;

    IF v_uid IS NULL OR v_uid::text <> '75c5d9dd-c634-4d14-8e74-e0b8947fa545' THEN
        RAISE EXCEPTION 'insufficient_privilege: this function is restricted to a specific user';
    END IF;

  IF v_username IS NULL OR v_username = '' THEN
    RAISE EXCEPTION 'username is required';
  END IF;

  IF v_platform NOT IN ('instagram','youtube','tiktok','twitter','facebook') THEN
    RAISE EXCEPTION 'platform must be one of instagram|youtube|tiktok|twitter|facebook';
  END IF;

  -- Build id: creator_<normalized_username>
  -- normalize: lowercase, keep [a-z0-9_], collapse to underscores
  v_id := 'creator_' || regexp_replace(lower(v_username), '[^a-z0-9_]+', '_', 'g');

  -- Attempt pure insert (no updates)
  INSERT INTO public.creators (
    id,
    name,
    username,
    platform,
    avatar_url,
    bio,
    followers,
    engagement_rate,
    category,
    location,
    verified,
    contact_email,
    rate_per_post,
    rate_per_story,
    rate_per_reel,
    languages,
    audience_demographics,
    content_categories,
    recent_posts,
    match_score,
    match_reason,
    scraped_at,
    is_active,
    platform_data
  )
  VALUES (
    v_id,
    COALESCE(p_data->>'name', v_username),                                -- name fallback to username
    v_username,
    v_platform,
    p_data->>'avatar_url',
    p_data->>'bio',
    NULLIF(p_data->>'followers','')::int,
    NULLIF(p_data->>'engagement_rate','')::numeric(5,2),
    p_data->>'category',
    p_data->>'location',
    CASE WHEN p_data ? 'verified' THEN (p_data->>'verified')::boolean END,
    p_data->>'contact_email',
    NULLIF(p_data->>'rate_per_post','')::numeric(10,2),
    NULLIF(p_data->>'rate_per_story','')::numeric(10,2),
    NULLIF(p_data->>'rate_per_reel','')::numeric(10,2),

    CASE
      WHEN p_data ? 'languages'
      THEN (SELECT array_agg(elem::text)
            FROM jsonb_array_elements_text(p_data->'languages') AS elem)
    END,

    CASE WHEN p_data ? 'audience_demographics' THEN p_data->'audience_demographics' END,
 CASE WHEN p_data ? 'content_categories' THEN (SELECT array_agg(elem) FROM jsonb_array_elements_text(p_data->'content_categories') AS elem) END,
    CASE WHEN p_data ? 'recent_posts'          THEN p_data->'recent_posts'          END,

    NULLIF(p_data->>'match_score','')::int,
    p_data->>'match_reason',
    CASE WHEN p_data ? 'scraped_at' THEN (p_data->>'scraped_at')::timestamptz END,
    CASE WHEN p_data ? 'is_active'  THEN (p_data->>'is_active')::boolean      END,

    p_data  -- full bulk JSON stored here
  )
  ON CONFLICT (platform, lower(username)) DO NOTHING
  RETURNING id INTO v_inserted_id;

  IF v_inserted_id IS NULL THEN
    -- Either row exists (same platform+username) or id collided
    RETURN jsonb_build_object(
      'success', false,
      'reason',  'already_exists',
      'id',      v_id,
      'platform', v_platform,
      'username', v_username
    );
  END IF;

  RETURN jsonb_build_object(
    'success',  true,
    'id',       v_inserted_id,
    'platform', v_platform,
    'username', v_username
  );
END;
$$;


ALTER FUNCTION public.insert_creator_from_payload(p_username text, p_platform text, p_data jsonb) OWNER TO postgres;

--
-- Name: search_contact_messages(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_contact_messages(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_query text;
  v_result jsonb;
begin
  -- Extract search term
  v_query := trim(payload->>'query');

  if v_query is null or v_query = '' then
    return jsonb_build_object(
      'status', 'error',
      'message', 'Search query is required'
    );
  end if;

  -- Search messages
  select jsonb_agg(to_jsonb(cm)) into v_result
  from public.contact_messages cm
  where cm.subject ilike '%' || v_query || '%'
     or cm.email ilike '%' || v_query || '%'
     or cm.first_name ilike '%' || v_query || '%'
     or cm.last_name ilike '%' || v_query || '%';

  -- Return response
  return jsonb_build_object(
    'status', 'success',
    'message', 'Search completed',
    'data', coalesce(v_result, '[]'::jsonb)
  );

exception
  when others then
    return jsonb_build_object(
      'status', 'error',
      'message', sqlerrm
    );
end;
$$;


ALTER FUNCTION public.search_contact_messages(payload jsonb) OWNER TO postgres;

--
-- Name: success_response(text, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.success_response(message text, data jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE sql
    AS $$
  select jsonb_build_object(
    'status', 'success',
    'message', message,
    'data', coalesce(data, 'null'::jsonb)
  );
$$;


ALTER FUNCTION public.success_response(message text, data jsonb) OWNER TO postgres;

--
-- Name: sync_user_subscription_fields(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_user_subscription_fields() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_plan_code text;
  v_status    text;
  v_expires   timestamptz;
BEGIN
  -- Recompute from the active subscription, if any
  SELECT plan_code, 'active', end_date
    INTO v_plan_code, v_status, v_expires
  FROM public.v_user_active_subscription
  WHERE user_id = COALESCE(NEW.user_id, OLD.user_id)
  LIMIT 1;

  -- If none active, fall back to 'free' / 'expired'
  IF v_plan_code IS NULL THEN
    v_plan_code := 'free';
    v_status    := 'expired';
    v_expires   := NULL;
  END IF;

  UPDATE public.users
     SET subscription_tier        = v_plan_code,
         subscription_status      = v_status,
         subscription_expires_at  = v_expires,
         updated_at               = now()
   WHERE id = COALESCE(NEW.user_id, OLD.user_id);

  RETURN NULL;
END;
$$;


ALTER FUNCTION public.sync_user_subscription_fields() OWNER TO postgres;

--
-- Name: update_contact_message_status(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_contact_message_status(payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$declare
  current_user_id uuid;
  is_admin_user boolean;
  p_id uuid;
  p_status text;
  v_statuses text[];
begin
  -- Extract fields from payload
  p_id := (payload->>'id')::uuid;
  p_status := payload->>'status';

  -- get the logged in user
  current_user_id := auth.uid();
  if current_user_id is null then
    return jsonb_build_object(
      'status', 'error',
      'code', 401,
      'message', 'Not authenticated'
    );
  end if;

  -- check admin
  select u.is_admin
  into is_admin_user
  from public.users u
  where u.id = current_user_id;

  if not coalesce(is_admin_user, false) then
    return jsonb_build_object(
      'status', 'error',
      'code', 403,
      'message', 'Not authorized'
    );
  end if;

  -- Fetch allowed statuses dynamically from the enum
  select array_agg(enumlabel::text)
  into v_statuses
  from pg_enum
  join pg_type on pg_enum.enumtypid = pg_type.oid
  where pg_type.typname = 'contact_message_status';

  -- Validate payload status
  if p_status is null or not p_status = any(v_statuses) then
    return jsonb_build_object(
      'status', 'error',
      'code', 400,
      'message', 'Invalid status'
    );
  end if;

  -- update message status
  update public.contact_messages
  set status = p_status::contact_message_status,
      updated_at = now()
  where id = p_id;

  if not found then
    return jsonb_build_object(
      'status', 'error',
      'code', 404,
      'message', 'Message not found'
    );
  end if;

  return jsonb_build_object(
    'status', 'success',
    'message', 'Message status updated',
    'data', jsonb_build_object('id', p_id, 'status', p_status)
  );

exception
  when others then
    return jsonb_build_object(
      'status', 'error',
      'code', 500,
      'message', sqlerrm
    );
end;$$;


ALTER FUNCTION public.update_contact_message_status(payload jsonb) OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


ALTER FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_update_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_level_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.prefixes_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: admin_recommendations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_recommendations (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    creator_id text,
    admin_id uuid,
    recommendation_type text NOT NULL,
    priority_score integer DEFAULT 0,
    categories text[],
    reason text,
    is_active boolean DEFAULT true,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT admin_recommendations_recommendation_type_check CHECK ((recommendation_type = ANY (ARRAY['staff_pick'::text, 'trending'::text, 'category_leader'::text, 'rising_star'::text])))
);


ALTER TABLE public.admin_recommendations OWNER TO postgres;

--
-- Name: ai_queries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_queries (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    query_text text NOT NULL,
    response_text text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_queries OWNER TO postgres;

--
-- Name: campaign_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_applications (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    campaign_id uuid,
    creator_id text,
    user_id uuid,
    status text DEFAULT 'pending'::text,
    message text,
    proposed_rate numeric(10,2),
    deliverables jsonb DEFAULT '{}'::jsonb,
    timeline jsonb DEFAULT '{}'::jsonb,
    submitted_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT campaign_applications_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text, 'completed'::text])))
);


ALTER TABLE public.campaign_applications OWNER TO postgres;

--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaigns (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    name text NOT NULL,
    description text,
    brand text,
    category text,
    target_audience jsonb DEFAULT '{}'::jsonb,
    budget numeric(10,2),
    budget_per_creator numeric(10,2),
    timeline jsonb DEFAULT '{}'::jsonb,
    requirements jsonb DEFAULT '{}'::jsonb,
    deliverables text[],
    platforms text[],
    status text DEFAULT 'draft'::text,
    creator_count integer DEFAULT 0,
    applications_count integer DEFAULT 0,
    metrics jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT campaigns_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'paused'::text, 'completed'::text, 'cancelled'::text])))
);


ALTER TABLE public.campaigns OWNER TO postgres;

--
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    email text,
    subject text NOT NULL,
    message text NOT NULL,
    status public.contact_message_status DEFAULT 'unreaded'::public.contact_message_status NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    first_name text NOT NULL,
    last_name text NOT NULL
);


ALTER TABLE public.contact_messages OWNER TO postgres;

--
-- Name: conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversations (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    creator_id text,
    campaign_id uuid,
    status text DEFAULT 'active'::text,
    last_message_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT conversations_status_check CHECK ((status = ANY (ARRAY['active'::text, 'archived'::text, 'blocked'::text])))
);


ALTER TABLE public.conversations OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    level text NOT NULL,
    parent_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: creator_promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creator_promotions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    creator_id text,
    package_id uuid,
    user_id uuid,
    status text DEFAULT 'pending'::text,
    starts_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone,
    amount_paid numeric(10,2) NOT NULL,
    payment_status text DEFAULT 'pending'::text,
    placement_score integer DEFAULT 0,
    target_categories text[],
    performance_metrics jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT creator_promotions_payment_status_check CHECK ((payment_status = ANY (ARRAY['pending'::text, 'completed'::text, 'failed'::text, 'refunded'::text]))),
    CONSTRAINT creator_promotions_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'active'::text, 'expired'::text, 'cancelled'::text])))
);


ALTER TABLE public.creator_promotions OWNER TO postgres;

--
-- Name: creator_search_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creator_search_logs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    creator_name text NOT NULL,
    platform text NOT NULL,
    searched_at timestamp with time zone DEFAULT now(),
    CONSTRAINT creator_search_logs_platform_check CHECK ((platform = ANY (ARRAY['instagram'::text, 'tiktok'::text, 'youtube'::text, 'twitter'::text, 'facebook'::text])))
);


ALTER TABLE public.creator_search_logs OWNER TO postgres;

--
-- Name: creator_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creator_views (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    creator_id text,
    action text NOT NULL,
    viewed_at timestamp with time zone DEFAULT now(),
    CONSTRAINT creator_views_action_check CHECK ((action = ANY (ARRAY['viewed'::text, 'shortlisted'::text, 'rejected'::text, 'messaged'::text])))
);


ALTER TABLE public.creator_views OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    id text NOT NULL,
    name text NOT NULL,
    username text NOT NULL,
    platform text NOT NULL,
    avatar_url text,
    bio text,
    followers integer DEFAULT 0,
    engagement_rate numeric(5,2) DEFAULT 0,
    category text,
    location text,
    verified boolean DEFAULT false,
    contact_email text,
    rate_per_post numeric(10,2),
    rate_per_story numeric(10,2),
    rate_per_reel numeric(10,2),
    languages text[],
    audience_demographics jsonb DEFAULT '{}'::jsonb,
    content_categories text[],
    recent_posts jsonb DEFAULT '[]'::jsonb,
    match_score integer,
    match_reason text,
    scraped_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    platform_data jsonb DEFAULT '{}'::jsonb,
    CONSTRAINT creators_platform_check CHECK ((platform = ANY (ARRAY['instagram'::text, 'youtube'::text, 'tiktok'::text, 'twitter'::text, 'facebook'::text])))
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: media_mentions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media_mentions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    creator_id text,
    platform text NOT NULL,
    mention_type text NOT NULL,
    keyword text NOT NULL,
    context text,
    mentioned_at timestamp with time zone,
    collected_at timestamp with time zone DEFAULT now(),
    CONSTRAINT media_mentions_mention_type_check CHECK ((mention_type = ANY (ARRAY['hashtag'::text, 'mention'::text, 'keyword'::text]))),
    CONSTRAINT media_mentions_platform_check CHECK ((platform = ANY (ARRAY['instagram'::text, 'tiktok'::text, 'youtube'::text, 'twitter'::text, 'facebook'::text])))
);


ALTER TABLE public.media_mentions OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    conversation_id uuid,
    sender_id uuid,
    recipient_id uuid,
    sender_type text NOT NULL,
    recipient_type text NOT NULL,
    content text NOT NULL,
    message_type text DEFAULT 'text'::text,
    attachments jsonb DEFAULT '[]'::jsonb,
    read_at timestamp with time zone,
    sent_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT messages_message_type_check CHECK ((message_type = ANY (ARRAY['text'::text, 'image'::text, 'file'::text, 'system'::text]))),
    CONSTRAINT messages_recipient_type_check CHECK ((recipient_type = ANY (ARRAY['user'::text, 'creator'::text, 'system'::text]))),
    CONSTRAINT messages_sender_type_check CHECK ((sender_type = ANY (ARRAY['user'::text, 'creator'::text, 'system'::text])))
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: promotional_analytics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotional_analytics (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    promotion_id uuid,
    date date NOT NULL,
    views integer DEFAULT 0,
    clicks integer DEFAULT 0,
    conversions integer DEFAULT 0,
    revenue numeric(10,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.promotional_analytics OWNER TO postgres;

--
-- Name: promotional_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotional_packages (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    duration_days integer NOT NULL,
    features jsonb DEFAULT '{}'::jsonb,
    placement_boost integer DEFAULT 0,
    highlighted boolean DEFAULT false,
    category_targeting boolean DEFAULT false,
    analytics_included boolean DEFAULT false,
    priority_support boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.promotional_packages OWNER TO postgres;

--
-- Name: saved_creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_creators (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    creator_id text,
    notes text,
    tags text[],
    saved_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.saved_creators OWNER TO postgres;

--
-- Name: saved_search_filters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_search_filters (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    name text NOT NULL,
    filters jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.saved_search_filters OWNER TO postgres;

--
-- Name: subscription_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription_plans (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    price numeric(10,2) DEFAULT 0 NOT NULL,
    currency text DEFAULT 'USD'::text NOT NULL,
    billing_cycle text DEFAULT 'monthly'::text NOT NULL,
    description text,
    features jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT subscription_plans_billing_cycle_check CHECK ((billing_cycle = ANY (ARRAY['monthly'::text, 'yearly'::text])))
);


ALTER TABLE public.subscription_plans OWNER TO postgres;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    plan_id uuid NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    start_date timestamp with time zone DEFAULT now() NOT NULL,
    end_date timestamp with time zone,
    auto_renew boolean DEFAULT true NOT NULL,
    trial_ends_at timestamp with time zone,
    external_ref text,
    payment_metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT subscriptions_status_check CHECK ((status = ANY (ARRAY['active'::text, 'cancelled'::text, 'expired'::text])))
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_sessions (
    session_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    full_name text,
    avatar_url text,
    company_name text,
    industry text,
    website text,
    bio text,
    location text,
    phone text,
    timezone text DEFAULT 'UTC'::text,
    credits integer DEFAULT 100,
    subscription_tier text DEFAULT 'free'::text,
    subscription_status text DEFAULT 'active'::text,
    subscription_expires_at timestamp with time zone,
    is_admin boolean DEFAULT false,
    admin_level text,
    preferences jsonb DEFAULT '{}'::jsonb,
    notification_settings jsonb DEFAULT '{"push": true, "email": true, "marketing": false}'::jsonb,
    onboarding_completed boolean DEFAULT false,
    last_active_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT users_admin_level_check CHECK ((admin_level = ANY (ARRAY['admin'::text, 'super_admin'::text]))),
    CONSTRAINT users_subscription_status_check CHECK ((subscription_status = ANY (ARRAY['active'::text, 'cancelled'::text, 'expired'::text]))),
    CONSTRAINT users_subscription_tier_check CHECK ((subscription_tier = ANY (ARRAY['free'::text, 'basic'::text, 'pro'::text, 'enterprise'::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: v_user_active_subscription; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_user_active_subscription AS
 SELECT s.user_id,
    p.code AS plan_code,
    s.status,
    s.end_date
   FROM (public.subscriptions s
     JOIN public.subscription_plans p ON ((p.id = s.plan_id)))
  WHERE ((s.status = 'active'::text) AND ((s.end_date IS NULL) OR (s.end_date > now())));


ALTER VIEW public.v_user_active_subscription OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: admin_recommendations admin_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_recommendations
    ADD CONSTRAINT admin_recommendations_pkey PRIMARY KEY (id);


--
-- Name: ai_queries ai_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_queries
    ADD CONSTRAINT ai_queries_pkey PRIMARY KEY (id);


--
-- Name: campaign_applications campaign_applications_campaign_id_creator_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_applications
    ADD CONSTRAINT campaign_applications_campaign_id_creator_id_key UNIQUE (campaign_id, creator_id);


--
-- Name: campaign_applications campaign_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_applications
    ADD CONSTRAINT campaign_applications_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: contact_messages contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_user_id_creator_id_campaign_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_user_id_creator_id_campaign_id_key UNIQUE (user_id, creator_id, campaign_id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: creator_promotions creator_promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_promotions
    ADD CONSTRAINT creator_promotions_pkey PRIMARY KEY (id);


--
-- Name: creator_search_logs creator_search_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_search_logs
    ADD CONSTRAINT creator_search_logs_pkey PRIMARY KEY (id);


--
-- Name: creator_views creator_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_views
    ADD CONSTRAINT creator_views_pkey PRIMARY KEY (id);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (id);


--
-- Name: media_mentions media_mentions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_mentions
    ADD CONSTRAINT media_mentions_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: promotional_analytics promotional_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotional_analytics
    ADD CONSTRAINT promotional_analytics_pkey PRIMARY KEY (id);


--
-- Name: promotional_analytics promotional_analytics_promotion_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotional_analytics
    ADD CONSTRAINT promotional_analytics_promotion_id_date_key UNIQUE (promotion_id, date);


--
-- Name: promotional_packages promotional_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotional_packages
    ADD CONSTRAINT promotional_packages_pkey PRIMARY KEY (id);


--
-- Name: saved_creators saved_creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_creators
    ADD CONSTRAINT saved_creators_pkey PRIMARY KEY (id);


--
-- Name: saved_creators saved_creators_user_id_creator_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_creators
    ADD CONSTRAINT saved_creators_user_id_creator_id_key UNIQUE (user_id, creator_id);


--
-- Name: saved_search_filters saved_search_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_search_filters
    ADD CONSTRAINT saved_search_filters_pkey PRIMARY KEY (id);


--
-- Name: subscription_plans subscription_plans_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_code_key UNIQUE (code);


--
-- Name: subscription_plans subscription_plans_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_name_key UNIQUE (name);


--
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_ai_queries_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ai_queries_user ON public.ai_queries USING btree (user_id);


--
-- Name: idx_campaigns_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_campaigns_status ON public.campaigns USING btree (status);


--
-- Name: idx_campaigns_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_campaigns_user_id ON public.campaigns USING btree (user_id);


--
-- Name: idx_contact_messages_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contact_messages_status ON public.contact_messages USING btree (status);


--
-- Name: idx_contact_messages_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contact_messages_user_id ON public.contact_messages USING btree (user_id);


--
-- Name: idx_conversations_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_conversations_user_id ON public.conversations USING btree (user_id);


--
-- Name: idx_creator_promotions_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_creator_promotions_creator_id ON public.creator_promotions USING btree (creator_id);


--
-- Name: idx_creator_promotions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_creator_promotions_status ON public.creator_promotions USING btree (status);


--
-- Name: idx_creator_search_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_creator_search_user ON public.creator_search_logs USING btree (user_id);


--
-- Name: idx_creator_views_user_creator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_creator_views_user_creator ON public.creator_views USING btree (user_id, creator_id);


--
-- Name: idx_creators_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_creators_category ON public.creators USING btree (category);


--
-- Name: idx_creators_platform; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_creators_platform ON public.creators USING btree (platform);


--
-- Name: idx_creators_platform_lower_username_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_creators_platform_lower_username_created_at ON public.creators USING btree (platform, lower(username), created_at DESC);


--
-- Name: idx_media_mentions_keyword; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_media_mentions_keyword ON public.media_mentions USING btree (keyword);


--
-- Name: idx_messages_conversation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_conversation_id ON public.messages USING btree (conversation_id);


--
-- Name: idx_subscriptions_plan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subscriptions_plan ON public.subscriptions USING btree (plan_id);


--
-- Name: idx_subscriptions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subscriptions_status ON public.subscriptions USING btree (status);


--
-- Name: idx_subscriptions_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subscriptions_user_id ON public.subscriptions USING btree (user_id);


--
-- Name: idx_user_sessions_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_sessions_user_id ON public.user_sessions USING btree (user_id);


--
-- Name: idx_user_sessions_user_id_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_sessions_user_id_created_at ON public.user_sessions USING btree (user_id, created_at DESC);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: uq_creators_platform_username_ci; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_creators_platform_username_ci ON public.creators USING btree (platform, lower(username));


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: countries trg_countries_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_countries_updated_at BEFORE UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscriptions trg_sync_user_subscriptions_aiud; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sync_user_subscriptions_aiud AFTER INSERT OR DELETE OR UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.sync_user_subscription_fields();


--
-- Name: admin_recommendations update_admin_recommendations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_admin_recommendations_updated_at BEFORE UPDATE ON public.admin_recommendations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: campaign_applications update_campaign_applications_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_campaign_applications_updated_at BEFORE UPDATE ON public.campaign_applications FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: campaigns update_campaigns_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_campaigns_updated_at BEFORE UPDATE ON public.campaigns FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: conversations update_conversations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_conversations_updated_at BEFORE UPDATE ON public.conversations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: creator_promotions update_creator_promotions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_creator_promotions_updated_at BEFORE UPDATE ON public.creator_promotions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: creators update_creators_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_creators_updated_at BEFORE UPDATE ON public.creators FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: promotional_packages update_promotional_packages_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_promotional_packages_updated_at BEFORE UPDATE ON public.promotional_packages FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription_plans update_subscription_plans_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_subscription_plans_updated_at BEFORE UPDATE ON public.subscription_plans FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscriptions update_subscriptions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: admin_recommendations admin_recommendations_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_recommendations
    ADD CONSTRAINT admin_recommendations_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: admin_recommendations admin_recommendations_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_recommendations
    ADD CONSTRAINT admin_recommendations_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id) ON DELETE CASCADE;


--
-- Name: ai_queries ai_queries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_queries
    ADD CONSTRAINT ai_queries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: campaign_applications campaign_applications_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_applications
    ADD CONSTRAINT campaign_applications_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON DELETE CASCADE;


--
-- Name: campaign_applications campaign_applications_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_applications
    ADD CONSTRAINT campaign_applications_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id) ON DELETE CASCADE;


--
-- Name: campaign_applications campaign_applications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_applications
    ADD CONSTRAINT campaign_applications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: campaigns campaigns_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: conversations conversations_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON DELETE CASCADE;


--
-- Name: conversations conversations_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id) ON DELETE CASCADE;


--
-- Name: conversations conversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: countries countries_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.countries(id) ON DELETE CASCADE;


--
-- Name: creator_promotions creator_promotions_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_promotions
    ADD CONSTRAINT creator_promotions_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id) ON DELETE CASCADE;


--
-- Name: creator_promotions creator_promotions_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_promotions
    ADD CONSTRAINT creator_promotions_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.promotional_packages(id) ON DELETE CASCADE;


--
-- Name: creator_promotions creator_promotions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_promotions
    ADD CONSTRAINT creator_promotions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: creator_search_logs creator_search_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_search_logs
    ADD CONSTRAINT creator_search_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: creator_views creator_views_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_views
    ADD CONSTRAINT creator_views_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id) ON DELETE CASCADE;


--
-- Name: creator_views creator_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creator_views
    ADD CONSTRAINT creator_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: contact_messages fk_contact_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT fk_contact_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: media_mentions media_mentions_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media_mentions
    ADD CONSTRAINT media_mentions_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id) ON DELETE CASCADE;


--
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- Name: promotional_analytics promotional_analytics_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotional_analytics
    ADD CONSTRAINT promotional_analytics_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.creator_promotions(id) ON DELETE CASCADE;


--
-- Name: saved_creators saved_creators_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_creators
    ADD CONSTRAINT saved_creators_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id) ON DELETE CASCADE;


--
-- Name: saved_creators saved_creators_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_creators
    ADD CONSTRAINT saved_creators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: saved_search_filters saved_search_filters_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_search_filters
    ADD CONSTRAINT saved_search_filters_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id);


--
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: creator_promotions Admins can manage creator promotions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage creator promotions" ON public.creator_promotions USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.is_admin = true)))));


--
-- Name: admin_recommendations Admins can manage recommendations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage recommendations" ON public.admin_recommendations USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.is_admin = true)))));


--
-- Name: promotional_analytics Admins can view analytics; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view analytics" ON public.promotional_analytics FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.is_admin = true)))));


--
-- Name: creators Anyone can view creators; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view creators" ON public.creators FOR SELECT USING (true);


--
-- Name: promotional_packages Anyone can view promotional packages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view promotional packages" ON public.promotional_packages FOR SELECT USING (true);


--
-- Name: campaigns Users can delete own campaigns; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete own campaigns" ON public.campaigns FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: saved_creators Users can delete own saved creators; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete own saved creators" ON public.saved_creators FOR DELETE USING ((auth.uid() = user_id));


--
-- Name: campaign_applications Users can insert own applications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own applications" ON public.campaign_applications FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: campaigns Users can insert own campaigns; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own campaigns" ON public.campaigns FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: conversations Users can insert own conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own conversations" ON public.conversations FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: messages Users can insert own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own messages" ON public.messages FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.conversations
  WHERE ((conversations.id = messages.conversation_id) AND (conversations.user_id = auth.uid())))));


--
-- Name: saved_creators Users can insert own saved creators; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own saved creators" ON public.saved_creators FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- Name: campaign_applications Users can update own applications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own applications" ON public.campaign_applications FOR UPDATE USING ((auth.uid() = user_id));


--
-- Name: campaigns Users can update own campaigns; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own campaigns" ON public.campaigns FOR UPDATE USING ((auth.uid() = user_id));


--
-- Name: conversations Users can update own conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own conversations" ON public.conversations FOR UPDATE USING ((auth.uid() = user_id));


--
-- Name: users Users can update own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING ((auth.uid() = id));


--
-- Name: saved_creators Users can update own saved creators; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own saved creators" ON public.saved_creators FOR UPDATE USING ((auth.uid() = user_id));


--
-- Name: campaign_applications Users can view own applications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own applications" ON public.campaign_applications FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: campaigns Users can view own campaigns; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own campaigns" ON public.campaigns FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: conversations Users can view own conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own conversations" ON public.conversations FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: messages Users can view own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own messages" ON public.messages FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.conversations
  WHERE ((conversations.id = messages.conversation_id) AND (conversations.user_id = auth.uid())))));


--
-- Name: users Users can view own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own profile" ON public.users FOR SELECT USING ((auth.uid() = id));


--
-- Name: saved_creators Users can view own saved creators; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own saved creators" ON public.saved_creators FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: admin_recommendations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.admin_recommendations ENABLE ROW LEVEL SECURITY;

--
-- Name: campaign_applications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.campaign_applications ENABLE ROW LEVEL SECURITY;

--
-- Name: campaigns; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.campaigns ENABLE ROW LEVEL SECURITY;

--
-- Name: conversations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

--
-- Name: creator_promotions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.creator_promotions ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: promotional_analytics; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.promotional_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: saved_creators; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.saved_creators ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION add_admin_recommendations(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_admin_recommendations(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_admin_recommendations(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_admin_recommendations(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_campaign_applications(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_campaign_applications(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_campaign_applications(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_campaign_applications(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_campaigns(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_campaigns(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_campaigns(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_campaigns(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_contact_message(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_contact_message(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_contact_message(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_contact_message(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_conversations(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_conversations(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_conversations(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_conversations(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_creator_promotions(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_creator_promotions(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_creator_promotions(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_creator_promotions(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_creator_search_logs(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_creator_search_logs(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_creator_search_logs(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_creator_search_logs(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_creator_views(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_creator_views(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_creator_views(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_creator_views(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_creators(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_creators(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_creators(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_creators(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_media_mentions(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_media_mentions(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_media_mentions(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_media_mentions(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_messages(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_messages(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_messages(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_messages(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_promotional_analytics(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_promotional_analytics(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_promotional_analytics(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_promotional_analytics(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_promotional_packages(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_promotional_packages(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_promotional_packages(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_promotional_packages(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_saved_creators(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_saved_creators(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_saved_creators(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_saved_creators(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_saved_search_filters(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_saved_search_filters(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_saved_search_filters(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_saved_search_filters(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_subscription(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_subscription(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_subscription(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_subscription(payload jsonb) TO service_role;


--
-- Name: FUNCTION add_subscription_plan(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_subscription_plan(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.add_subscription_plan(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.add_subscription_plan(payload jsonb) TO service_role;


--
-- Name: FUNCTION create_user_session(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_user_session(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.create_user_session(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.create_user_session(payload jsonb) TO service_role;


--
-- Name: FUNCTION delete_contact_message(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.delete_contact_message(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.delete_contact_message(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.delete_contact_message(payload jsonb) TO service_role;


--
-- Name: FUNCTION error_response(message text, code integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.error_response(message text, code integer) TO anon;
GRANT ALL ON FUNCTION public.error_response(message text, code integer) TO authenticated;
GRANT ALL ON FUNCTION public.error_response(message text, code integer) TO service_role;


--
-- Name: FUNCTION get_admin_recommendations(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_admin_recommendations(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_admin_recommendations(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_admin_recommendations(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_ai_queries(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_ai_queries(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_ai_queries(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_ai_queries(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_campaign_applications(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_campaign_applications(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_campaign_applications(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_campaign_applications(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_campaigns(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_campaigns(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_campaigns(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_campaigns(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_contact_messages(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_contact_messages(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_contact_messages(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_contact_messages(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_conversations(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_conversations(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_conversations(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_conversations(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_country_city_pairs(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_country_city_pairs(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_country_city_pairs(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_country_city_pairs(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_creator_categories(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_creator_categories(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_creator_categories(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_creator_categories(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_creator_platforms(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_creator_platforms(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_creator_platforms(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_creator_platforms(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_creator_promotions(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_creator_promotions(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_creator_promotions(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_creator_promotions(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_creator_search_logs(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_creator_search_logs(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_creator_search_logs(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_creator_search_logs(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_creator_views(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_creator_views(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_creator_views(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_creator_views(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_creators(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_creators(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_creators(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_creators(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_locations(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_locations(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_locations(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_locations(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_media_mentions(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_media_mentions(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_media_mentions(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_media_mentions(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_messages(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_messages(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_messages(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_messages(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_promotional_analytics(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_promotional_analytics(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_promotional_analytics(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_promotional_analytics(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_promotional_packages(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_promotional_packages(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_promotional_packages(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_promotional_packages(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_recent_platform_data(p_input jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_recent_platform_data(p_input jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_recent_platform_data(p_input jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_recent_platform_data(p_input jsonb) TO service_role;
GRANT ALL ON FUNCTION public.get_recent_platform_data(p_input jsonb) TO core_kernel;


--
-- Name: FUNCTION get_saved_creators(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_saved_creators(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_saved_creators(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_saved_creators(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_saved_search_filters(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_saved_search_filters(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_saved_search_filters(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_saved_search_filters(payload jsonb) TO service_role;


--
-- Name: FUNCTION get_subscriptions(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_subscriptions(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.get_subscriptions(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.get_subscriptions(payload jsonb) TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION insert_creator_from_payload(p_username text, p_platform text, p_data jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.insert_creator_from_payload(p_username text, p_platform text, p_data jsonb) TO anon;
GRANT ALL ON FUNCTION public.insert_creator_from_payload(p_username text, p_platform text, p_data jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.insert_creator_from_payload(p_username text, p_platform text, p_data jsonb) TO service_role;


--
-- Name: FUNCTION search_contact_messages(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.search_contact_messages(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.search_contact_messages(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.search_contact_messages(payload jsonb) TO service_role;


--
-- Name: FUNCTION success_response(message text, data jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.success_response(message text, data jsonb) TO anon;
GRANT ALL ON FUNCTION public.success_response(message text, data jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.success_response(message text, data jsonb) TO service_role;


--
-- Name: FUNCTION sync_user_subscription_fields(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.sync_user_subscription_fields() TO anon;
GRANT ALL ON FUNCTION public.sync_user_subscription_fields() TO authenticated;
GRANT ALL ON FUNCTION public.sync_user_subscription_fields() TO service_role;


--
-- Name: FUNCTION update_contact_message_status(payload jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_contact_message_status(payload jsonb) TO anon;
GRANT ALL ON FUNCTION public.update_contact_message_status(payload jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.update_contact_message_status(payload jsonb) TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE admin_recommendations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.admin_recommendations TO anon;
GRANT ALL ON TABLE public.admin_recommendations TO authenticated;
GRANT ALL ON TABLE public.admin_recommendations TO service_role;


--
-- Name: TABLE ai_queries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ai_queries TO anon;
GRANT ALL ON TABLE public.ai_queries TO authenticated;
GRANT ALL ON TABLE public.ai_queries TO service_role;


--
-- Name: TABLE campaign_applications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.campaign_applications TO anon;
GRANT ALL ON TABLE public.campaign_applications TO authenticated;
GRANT ALL ON TABLE public.campaign_applications TO service_role;


--
-- Name: TABLE campaigns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.campaigns TO anon;
GRANT ALL ON TABLE public.campaigns TO authenticated;
GRANT ALL ON TABLE public.campaigns TO service_role;


--
-- Name: TABLE contact_messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.contact_messages TO anon;
GRANT ALL ON TABLE public.contact_messages TO authenticated;
GRANT ALL ON TABLE public.contact_messages TO service_role;


--
-- Name: TABLE conversations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.conversations TO anon;
GRANT ALL ON TABLE public.conversations TO authenticated;
GRANT ALL ON TABLE public.conversations TO service_role;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.countries TO anon;
GRANT ALL ON TABLE public.countries TO authenticated;
GRANT ALL ON TABLE public.countries TO service_role;


--
-- Name: TABLE creator_promotions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.creator_promotions TO anon;
GRANT ALL ON TABLE public.creator_promotions TO authenticated;
GRANT ALL ON TABLE public.creator_promotions TO service_role;


--
-- Name: TABLE creator_search_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.creator_search_logs TO anon;
GRANT ALL ON TABLE public.creator_search_logs TO authenticated;
GRANT ALL ON TABLE public.creator_search_logs TO service_role;


--
-- Name: TABLE creator_views; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.creator_views TO anon;
GRANT ALL ON TABLE public.creator_views TO authenticated;
GRANT ALL ON TABLE public.creator_views TO service_role;


--
-- Name: TABLE creators; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.creators TO anon;
GRANT ALL ON TABLE public.creators TO authenticated;
GRANT ALL ON TABLE public.creators TO service_role;
GRANT SELECT ON TABLE public.creators TO core_kernel;


--
-- Name: TABLE media_mentions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.media_mentions TO anon;
GRANT ALL ON TABLE public.media_mentions TO authenticated;
GRANT ALL ON TABLE public.media_mentions TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE promotional_analytics; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.promotional_analytics TO anon;
GRANT ALL ON TABLE public.promotional_analytics TO authenticated;
GRANT ALL ON TABLE public.promotional_analytics TO service_role;


--
-- Name: TABLE promotional_packages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.promotional_packages TO anon;
GRANT ALL ON TABLE public.promotional_packages TO authenticated;
GRANT ALL ON TABLE public.promotional_packages TO service_role;


--
-- Name: TABLE saved_creators; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.saved_creators TO anon;
GRANT ALL ON TABLE public.saved_creators TO authenticated;
GRANT ALL ON TABLE public.saved_creators TO service_role;


--
-- Name: TABLE saved_search_filters; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.saved_search_filters TO anon;
GRANT ALL ON TABLE public.saved_search_filters TO authenticated;
GRANT ALL ON TABLE public.saved_search_filters TO service_role;


--
-- Name: TABLE subscription_plans; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.subscription_plans TO anon;
GRANT ALL ON TABLE public.subscription_plans TO authenticated;
GRANT ALL ON TABLE public.subscription_plans TO service_role;


--
-- Name: TABLE subscriptions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.subscriptions TO anon;
GRANT ALL ON TABLE public.subscriptions TO authenticated;
GRANT ALL ON TABLE public.subscriptions TO service_role;


--
-- Name: TABLE user_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_sessions TO anon;
GRANT ALL ON TABLE public.user_sessions TO authenticated;
GRANT ALL ON TABLE public.user_sessions TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE v_user_active_subscription; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_user_active_subscription TO anon;
GRANT ALL ON TABLE public.v_user_active_subscription TO authenticated;
GRANT ALL ON TABLE public.v_user_active_subscription TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE prefixes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.prefixes TO service_role;
GRANT ALL ON TABLE storage.prefixes TO authenticated;
GRANT ALL ON TABLE storage.prefixes TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

