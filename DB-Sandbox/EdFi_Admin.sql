--
-- PostgreSQL database dump
--

-- Dumped from database version 11.9
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dbo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dbo;


ALTER SCHEMA dbo OWNER TO postgres;

--
-- Name: getclientfortoken(uuid); Type: FUNCTION; Schema: dbo; Owner: postgres
--

CREATE FUNCTION dbo.getclientfortoken(accesstoken uuid) RETURNS TABLE(key character varying, usesandbox boolean, studentidentificationsystemdescriptor character varying, educationorganizationid integer, claimsetname character varying, namespaceprefix character varying, profilename character varying, creatorownershiptokenid smallint, ownershiptokenid smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        ac.Key
        ,ac.UseSandbox
        ,ac.StudentIdentificationSystemDescriptor
        ,aeo.EducationOrganizationId
        ,app.ClaimSetName
        ,vnp.NamespacePrefix
        ,p.ProfileName
        ,ac.CreatorOwnershipTokenId_OwnershipTokenId as CreatorOwnershipTokenId
        ,acot.OwnershipToken_OwnershipTokenId as OwnershipTokenId
    FROM dbo.ClientAccessTokens cat
         INNER JOIN dbo.ApiClients ac ON
        cat.ApiClient_ApiClientId = ac.ApiClientId
        AND cat.Id = AccessToken
         INNER JOIN dbo.Applications app ON
        app.ApplicationId = ac.Application_ApplicationId
         LEFT OUTER JOIN dbo.Vendors v ON
        v.VendorId = app.Vendor_VendorId
         LEFT OUTER JOIN dbo.VendorNamespacePrefixes vnp ON
        v.VendorId = vnp.Vendor_VendorId
         -- Outer join so client key is always returned even if no EdOrgs have been enabled
         LEFT OUTER JOIN dbo.ApiClientApplicationEducationOrganizations acaeo ON
        acaeo.ApiClient_ApiClientId = cat.ApiClient_ApiClientId
         LEFT OUTER JOIN dbo.ApplicationEducationOrganizations aeo ON
        aeo.ApplicationEducationOrganizationId = acaeo.ApplicationEdOrg_ApplicationEdOrgId
			AND (cat.Scope IS NULL OR aeo.EducationOrganizationId = CAST(cat.Scope AS INTEGER))
         LEFT OUTER JOIN dbo.ProfileApplications ap ON
        ap.Application_ApplicationId = app.ApplicationId
         LEFT OUTER JOIN dbo.Profiles p ON
        p.ProfileId = ap.Profile_ProfileId
        LEFT OUTER JOIN dbo.ApiClientOwnershipTokens acot ON
        ac.ApiClientId = acot.ApiClient_ApiClientId;
END
$$;


ALTER FUNCTION dbo.getclientfortoken(accesstoken uuid) OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: apiclientapplicationeducationorganizations; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.apiclientapplicationeducationorganizations (
    apiclient_apiclientid integer NOT NULL,
    applicationedorg_applicationedorgid integer NOT NULL
);


ALTER TABLE dbo.apiclientapplicationeducationorganizations OWNER TO postgres;

--
-- Name: apiclientownershiptokens; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.apiclientownershiptokens (
    apiclientownershiptokenid integer NOT NULL,
    apiclient_apiclientid integer NOT NULL,
    ownershiptoken_ownershiptokenid smallint NOT NULL
);


ALTER TABLE dbo.apiclientownershiptokens OWNER TO postgres;

--
-- Name: apiclientownershiptokens_apiclientownershiptokenid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.apiclientownershiptokens_apiclientownershiptokenid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.apiclientownershiptokens_apiclientownershiptokenid_seq OWNER TO postgres;

--
-- Name: apiclientownershiptokens_apiclientownershiptokenid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.apiclientownershiptokens_apiclientownershiptokenid_seq OWNED BY dbo.apiclientownershiptokens.apiclientownershiptokenid;


--
-- Name: apiclients; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.apiclients (
    apiclientid integer NOT NULL,
    key character varying(50) NOT NULL,
    secret character varying(100) NOT NULL,
    name character varying(50) NOT NULL,
    isapproved boolean NOT NULL,
    usesandbox boolean NOT NULL,
    sandboxtype integer NOT NULL,
    application_applicationid integer,
    user_userid integer,
    keystatus character varying,
    challengeid character varying,
    challengeexpiry timestamp without time zone,
    activationcode character varying,
    activationretried integer,
    secretishashed boolean DEFAULT false NOT NULL,
    studentidentificationsystemdescriptor character varying(306),
    creatorownershiptokenid_ownershiptokenid smallint
);


ALTER TABLE dbo.apiclients OWNER TO postgres;

--
-- Name: apiclients_apiclientid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.apiclients_apiclientid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.apiclients_apiclientid_seq OWNER TO postgres;

--
-- Name: apiclients_apiclientid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.apiclients_apiclientid_seq OWNED BY dbo.apiclients.apiclientid;


--
-- Name: applicationeducationorganizations; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.applicationeducationorganizations (
    applicationeducationorganizationid integer NOT NULL,
    educationorganizationid integer NOT NULL,
    application_applicationid integer
);


ALTER TABLE dbo.applicationeducationorganizations OWNER TO postgres;

--
-- Name: applicationeducationorganizat_applicationeducationorganizat_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.applicationeducationorganizat_applicationeducationorganizat_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.applicationeducationorganizat_applicationeducationorganizat_seq OWNER TO postgres;

--
-- Name: applicationeducationorganizat_applicationeducationorganizat_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.applicationeducationorganizat_applicationeducationorganizat_seq OWNED BY dbo.applicationeducationorganizations.applicationeducationorganizationid;


--
-- Name: applications; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.applications (
    applicationid integer NOT NULL,
    applicationname character varying,
    vendor_vendorid integer,
    claimsetname character varying(255),
    odsinstance_odsinstanceid integer,
    operationalcontexturi character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE dbo.applications OWNER TO postgres;

--
-- Name: applications_applicationid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.applications_applicationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.applications_applicationid_seq OWNER TO postgres;

--
-- Name: applications_applicationid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.applications_applicationid_seq OWNED BY dbo.applications.applicationid;


--
-- Name: aspnetroleclaims; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.aspnetroleclaims (
    id integer NOT NULL,
    roleid text NOT NULL,
    claimtype text,
    claimvalue text
);


ALTER TABLE dbo.aspnetroleclaims OWNER TO postgres;

--
-- Name: aspnetroleclaims_id_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

ALTER TABLE dbo.aspnetroleclaims ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME dbo.aspnetroleclaims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: aspnetroles; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.aspnetroles (
    id text NOT NULL,
    name character varying(256),
    normalizedname character varying(256),
    concurrencystamp text
);


ALTER TABLE dbo.aspnetroles OWNER TO postgres;

--
-- Name: aspnetuserclaims; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.aspnetuserclaims (
    id integer NOT NULL,
    userid text NOT NULL,
    claimtype text,
    claimvalue text
);


ALTER TABLE dbo.aspnetuserclaims OWNER TO postgres;

--
-- Name: aspnetuserclaims_id_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

ALTER TABLE dbo.aspnetuserclaims ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME dbo.aspnetuserclaims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: aspnetuserlogins; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.aspnetuserlogins (
    loginprovider text NOT NULL,
    providerkey text NOT NULL,
    providerdisplayname text,
    userid text NOT NULL
);


ALTER TABLE dbo.aspnetuserlogins OWNER TO postgres;

--
-- Name: aspnetuserroles; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.aspnetuserroles (
    userid text NOT NULL,
    roleid text NOT NULL
);


ALTER TABLE dbo.aspnetuserroles OWNER TO postgres;

--
-- Name: aspnetusers; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.aspnetusers (
    id text NOT NULL,
    username character varying(256),
    normalizedusername character varying(256),
    email character varying(256),
    normalizedemail character varying(256),
    emailconfirmed boolean NOT NULL,
    passwordhash text,
    securitystamp text,
    concurrencystamp text,
    phonenumber text,
    phonenumberconfirmed boolean NOT NULL,
    twofactorenabled boolean NOT NULL,
    lockoutend timestamp with time zone,
    lockoutenabled boolean NOT NULL,
    accessfailedcount integer NOT NULL
);


ALTER TABLE dbo.aspnetusers OWNER TO postgres;

--
-- Name: aspnetusertokens; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.aspnetusertokens (
    userid text NOT NULL,
    loginprovider text NOT NULL,
    name text NOT NULL,
    value text
);


ALTER TABLE dbo.aspnetusertokens OWNER TO postgres;

--
-- Name: clientaccesstokens; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.clientaccesstokens (
    id uuid NOT NULL,
    expiration timestamp without time zone NOT NULL,
    scope character varying,
    apiclient_apiclientid integer
);


ALTER TABLE dbo.clientaccesstokens OWNER TO postgres;

--
-- Name: odsinstancecomponents; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.odsinstancecomponents (
    odsinstancecomponentid integer NOT NULL,
    name character varying(100) NOT NULL,
    url character varying(200) NOT NULL,
    version character varying(20) NOT NULL,
    odsinstance_odsinstanceid integer NOT NULL
);


ALTER TABLE dbo.odsinstancecomponents OWNER TO postgres;

--
-- Name: odsinstancecomponents_odsinstancecomponentid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.odsinstancecomponents_odsinstancecomponentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.odsinstancecomponents_odsinstancecomponentid_seq OWNER TO postgres;

--
-- Name: odsinstancecomponents_odsinstancecomponentid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.odsinstancecomponents_odsinstancecomponentid_seq OWNED BY dbo.odsinstancecomponents.odsinstancecomponentid;


--
-- Name: odsinstances; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.odsinstances (
    odsinstanceid integer NOT NULL,
    name character varying(100) NOT NULL,
    instancetype character varying(100) NOT NULL,
    status character varying(100) NOT NULL,
    isextended boolean NOT NULL,
    version character varying(20) NOT NULL
);


ALTER TABLE dbo.odsinstances OWNER TO postgres;

--
-- Name: odsinstances_odsinstanceid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.odsinstances_odsinstanceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.odsinstances_odsinstanceid_seq OWNER TO postgres;

--
-- Name: odsinstances_odsinstanceid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.odsinstances_odsinstanceid_seq OWNED BY dbo.odsinstances.odsinstanceid;


--
-- Name: ownershiptokens; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.ownershiptokens (
    ownershiptokenid smallint NOT NULL,
    description character varying(50)
);


ALTER TABLE dbo.ownershiptokens OWNER TO postgres;

--
-- Name: ownershiptokens_ownershiptokenid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.ownershiptokens_ownershiptokenid_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.ownershiptokens_ownershiptokenid_seq OWNER TO postgres;

--
-- Name: ownershiptokens_ownershiptokenid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.ownershiptokens_ownershiptokenid_seq OWNED BY dbo.ownershiptokens.ownershiptokenid;


--
-- Name: profileapplications; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.profileapplications (
    profile_profileid integer NOT NULL,
    application_applicationid integer NOT NULL
);


ALTER TABLE dbo.profileapplications OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.profiles (
    profileid integer NOT NULL,
    profilename character varying NOT NULL
);


ALTER TABLE dbo.profiles OWNER TO postgres;

--
-- Name: profiles_profileid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.profiles_profileid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.profiles_profileid_seq OWNER TO postgres;

--
-- Name: profiles_profileid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.profiles_profileid_seq OWNED BY dbo.profiles.profileid;


--
-- Name: users; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.users (
    userid integer NOT NULL,
    email character varying,
    fullname character varying,
    vendor_vendorid integer
);


ALTER TABLE dbo.users OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.users_userid_seq OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.users_userid_seq OWNED BY dbo.users.userid;


--
-- Name: vendornamespaceprefixes; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.vendornamespaceprefixes (
    vendornamespaceprefixid integer NOT NULL,
    namespaceprefix character varying(255) NOT NULL,
    vendor_vendorid integer NOT NULL
);


ALTER TABLE dbo.vendornamespaceprefixes OWNER TO postgres;

--
-- Name: vendornamespaceprefixes_vendornamespaceprefixid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.vendornamespaceprefixes_vendornamespaceprefixid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.vendornamespaceprefixes_vendornamespaceprefixid_seq OWNER TO postgres;

--
-- Name: vendornamespaceprefixes_vendornamespaceprefixid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.vendornamespaceprefixes_vendornamespaceprefixid_seq OWNED BY dbo.vendornamespaceprefixes.vendornamespaceprefixid;


--
-- Name: vendors; Type: TABLE; Schema: dbo; Owner: postgres
--

CREATE TABLE dbo.vendors (
    vendorid integer NOT NULL,
    vendorname character varying
);


ALTER TABLE dbo.vendors OWNER TO postgres;

--
-- Name: vendors_vendorid_seq; Type: SEQUENCE; Schema: dbo; Owner: postgres
--

CREATE SEQUENCE dbo.vendors_vendorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbo.vendors_vendorid_seq OWNER TO postgres;

--
-- Name: vendors_vendorid_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: postgres
--

ALTER SEQUENCE dbo.vendors_vendorid_seq OWNED BY dbo.vendors.vendorid;


--
-- Name: DeployJournal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DeployJournal" (
    schemaversionsid integer NOT NULL,
    scriptname character varying(255) NOT NULL,
    applied timestamp without time zone NOT NULL
);


ALTER TABLE public."DeployJournal" OWNER TO postgres;

--
-- Name: DeployJournal_schemaversionsid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."DeployJournal_schemaversionsid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."DeployJournal_schemaversionsid_seq" OWNER TO postgres;

--
-- Name: DeployJournal_schemaversionsid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."DeployJournal_schemaversionsid_seq" OWNED BY public."DeployJournal".schemaversionsid;


--
-- Name: apiclientownershiptokens apiclientownershiptokenid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclientownershiptokens ALTER COLUMN apiclientownershiptokenid SET DEFAULT nextval('dbo.apiclientownershiptokens_apiclientownershiptokenid_seq'::regclass);


--
-- Name: apiclients apiclientid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclients ALTER COLUMN apiclientid SET DEFAULT nextval('dbo.apiclients_apiclientid_seq'::regclass);


--
-- Name: applicationeducationorganizations applicationeducationorganizationid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.applicationeducationorganizations ALTER COLUMN applicationeducationorganizationid SET DEFAULT nextval('dbo.applicationeducationorganizat_applicationeducationorganizat_seq'::regclass);


--
-- Name: applications applicationid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.applications ALTER COLUMN applicationid SET DEFAULT nextval('dbo.applications_applicationid_seq'::regclass);


--
-- Name: odsinstancecomponents odsinstancecomponentid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.odsinstancecomponents ALTER COLUMN odsinstancecomponentid SET DEFAULT nextval('dbo.odsinstancecomponents_odsinstancecomponentid_seq'::regclass);


--
-- Name: odsinstances odsinstanceid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.odsinstances ALTER COLUMN odsinstanceid SET DEFAULT nextval('dbo.odsinstances_odsinstanceid_seq'::regclass);


--
-- Name: ownershiptokens ownershiptokenid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.ownershiptokens ALTER COLUMN ownershiptokenid SET DEFAULT nextval('dbo.ownershiptokens_ownershiptokenid_seq'::regclass);


--
-- Name: profiles profileid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.profiles ALTER COLUMN profileid SET DEFAULT nextval('dbo.profiles_profileid_seq'::regclass);


--
-- Name: users userid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.users ALTER COLUMN userid SET DEFAULT nextval('dbo.users_userid_seq'::regclass);


--
-- Name: vendornamespaceprefixes vendornamespaceprefixid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.vendornamespaceprefixes ALTER COLUMN vendornamespaceprefixid SET DEFAULT nextval('dbo.vendornamespaceprefixes_vendornamespaceprefixid_seq'::regclass);


--
-- Name: vendors vendorid; Type: DEFAULT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.vendors ALTER COLUMN vendorid SET DEFAULT nextval('dbo.vendors_vendorid_seq'::regclass);


--
-- Name: DeployJournal schemaversionsid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DeployJournal" ALTER COLUMN schemaversionsid SET DEFAULT nextval('public."DeployJournal_schemaversionsid_seq"'::regclass);


--
-- Data for Name: apiclientapplicationeducationorganizations; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.apiclientapplicationeducationorganizations (apiclient_apiclientid, applicationedorg_applicationedorgid) FROM stdin;
\.


--
-- Data for Name: apiclientownershiptokens; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.apiclientownershiptokens (apiclientownershiptokenid, apiclient_apiclientid, ownershiptoken_ownershiptokenid) FROM stdin;
\.


--
-- Data for Name: apiclients; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.apiclients (apiclientid, key, secret, name, isapproved, usesandbox, sandboxtype, application_applicationid, user_userid, keystatus, challengeid, challengeexpiry, activationcode, activationretried, secretishashed, studentidentificationsystemdescriptor, creatorownershiptokenid_ownershiptokenid) FROM stdin;
\.


--
-- Data for Name: applicationeducationorganizations; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.applicationeducationorganizations (applicationeducationorganizationid, educationorganizationid, application_applicationid) FROM stdin;
\.


--
-- Data for Name: applications; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.applications (applicationid, applicationname, vendor_vendorid, claimsetname, odsinstance_odsinstanceid, operationalcontexturi) FROM stdin;
\.


--
-- Data for Name: aspnetroleclaims; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.aspnetroleclaims (id, roleid, claimtype, claimvalue) FROM stdin;
\.


--
-- Data for Name: aspnetroles; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.aspnetroles (id, name, normalizedname, concurrencystamp) FROM stdin;
\.


--
-- Data for Name: aspnetuserclaims; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.aspnetuserclaims (id, userid, claimtype, claimvalue) FROM stdin;
\.


--
-- Data for Name: aspnetuserlogins; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.aspnetuserlogins (loginprovider, providerkey, providerdisplayname, userid) FROM stdin;
\.


--
-- Data for Name: aspnetuserroles; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.aspnetuserroles (userid, roleid) FROM stdin;
\.


--
-- Data for Name: aspnetusers; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.aspnetusers (id, username, normalizedusername, email, normalizedemail, emailconfirmed, passwordhash, securitystamp, concurrencystamp, phonenumber, phonenumberconfirmed, twofactorenabled, lockoutend, lockoutenabled, accessfailedcount) FROM stdin;
\.


--
-- Data for Name: aspnetusertokens; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.aspnetusertokens (userid, loginprovider, name, value) FROM stdin;
\.


--
-- Data for Name: clientaccesstokens; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.clientaccesstokens (id, expiration, scope, apiclient_apiclientid) FROM stdin;
\.


--
-- Data for Name: odsinstancecomponents; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.odsinstancecomponents (odsinstancecomponentid, name, url, version, odsinstance_odsinstanceid) FROM stdin;
\.


--
-- Data for Name: odsinstances; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.odsinstances (odsinstanceid, name, instancetype, status, isextended, version) FROM stdin;
\.


--
-- Data for Name: ownershiptokens; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.ownershiptokens (ownershiptokenid, description) FROM stdin;
\.


--
-- Data for Name: profileapplications; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.profileapplications (profile_profileid, application_applicationid) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.profiles (profileid, profilename) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.users (userid, email, fullname, vendor_vendorid) FROM stdin;
\.


--
-- Data for Name: vendornamespaceprefixes; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.vendornamespaceprefixes (vendornamespaceprefixid, namespaceprefix, vendor_vendorid) FROM stdin;
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: dbo; Owner: postgres
--

COPY dbo.vendors (vendorid, vendorname) FROM stdin;
\.


--
-- Data for Name: DeployJournal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DeployJournal" (schemaversionsid, scriptname, applied) FROM stdin;
1	Artifacts.PgSql.Structure.Admin.0010-Schemas.sql	2020-11-09 14:17:30.392293
2	Artifacts.PgSql.Structure.Admin.0020-Tables.sql	2020-11-09 14:17:30.523342
3	Artifacts.PgSql.Structure.Admin.0030-ForeignKey.sql	2020-11-09 14:17:30.5831
4	Artifacts.PgSql.Structure.Admin.0040-IdColumnIndexes.sql	2020-11-09 14:17:30.642952
5	Artifacts.PgSql.Structure.Admin.0050-StoredProcedures.sql	2020-11-09 14:17:30.652326
6	Artifacts.PgSql.Structure.Admin.0051-Rename-AccessToken-Function.sql	2020-11-09 14:17:30.660889
7	Artifacts.PgSql.Structure.Admin.0060-Add-OwnershipTokens.sql	2020-11-09 14:17:30.676621
8	Artifacts.PgSql.Structure.Admin.0061-Add-ApiClientsOwnershipTokens.sql	2020-11-09 14:17:30.711859
9	Artifacts.PgSql.Structure.Admin.0062-Add-CreatorOwnershipTokenId-To-ApiClients.sql	2020-11-09 14:17:30.729611
10	Artifacts.PgSql.Structure.Admin.0063-Update-GetClientForToken-For-Record-Level-Ownership.sql	2020-11-09 14:17:30.738195
11	Artifacts.PgSql.Structure.Admin.0065-Update-GetClientForToken-For-Scope-Support.sql	2020-11-09 14:17:30.749187
12	Artifacts.PgSql.Structure.Admin.0070-Identity-Support.sql	2020-11-09 14:17:30.900328
\.


--
-- Name: apiclientownershiptokens_apiclientownershiptokenid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.apiclientownershiptokens_apiclientownershiptokenid_seq', 1, false);


--
-- Name: apiclients_apiclientid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.apiclients_apiclientid_seq', 1, false);


--
-- Name: applicationeducationorganizat_applicationeducationorganizat_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.applicationeducationorganizat_applicationeducationorganizat_seq', 1, false);


--
-- Name: applications_applicationid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.applications_applicationid_seq', 1, false);


--
-- Name: aspnetroleclaims_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.aspnetroleclaims_id_seq', 1, false);


--
-- Name: aspnetuserclaims_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.aspnetuserclaims_id_seq', 1, false);


--
-- Name: odsinstancecomponents_odsinstancecomponentid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.odsinstancecomponents_odsinstancecomponentid_seq', 1, false);


--
-- Name: odsinstances_odsinstanceid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.odsinstances_odsinstanceid_seq', 1, false);


--
-- Name: ownershiptokens_ownershiptokenid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.ownershiptokens_ownershiptokenid_seq', 1, false);


--
-- Name: profiles_profileid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.profiles_profileid_seq', 1, false);


--
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.users_userid_seq', 1, false);


--
-- Name: vendornamespaceprefixes_vendornamespaceprefixid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.vendornamespaceprefixes_vendornamespaceprefixid_seq', 1, false);


--
-- Name: vendors_vendorid_seq; Type: SEQUENCE SET; Schema: dbo; Owner: postgres
--

SELECT pg_catalog.setval('dbo.vendors_vendorid_seq', 1, false);


--
-- Name: DeployJournal_schemaversionsid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DeployJournal_schemaversionsid_seq"', 12, true);


--
-- Name: apiclientapplicationeducationorganizations apiclientapplicationeducationorganizations_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclientapplicationeducationorganizations
    ADD CONSTRAINT apiclientapplicationeducationorganizations_pk PRIMARY KEY (apiclient_apiclientid, applicationedorg_applicationedorgid);


--
-- Name: apiclientownershiptokens apiclientownershiptokens_pkey; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclientownershiptokens
    ADD CONSTRAINT apiclientownershiptokens_pkey PRIMARY KEY (apiclientownershiptokenid);


--
-- Name: apiclients apiclients_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclients
    ADD CONSTRAINT apiclients_pk PRIMARY KEY (apiclientid);


--
-- Name: applicationeducationorganizations applicationeducationorganizations_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.applicationeducationorganizations
    ADD CONSTRAINT applicationeducationorganizations_pk PRIMARY KEY (applicationeducationorganizationid);


--
-- Name: applications applications_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.applications
    ADD CONSTRAINT applications_pk PRIMARY KEY (applicationid);


--
-- Name: clientaccesstokens clientaccesstokens_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.clientaccesstokens
    ADD CONSTRAINT clientaccesstokens_pk PRIMARY KEY (id);


--
-- Name: odsinstancecomponents odsinstancecomponents_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.odsinstancecomponents
    ADD CONSTRAINT odsinstancecomponents_pk PRIMARY KEY (odsinstancecomponentid);


--
-- Name: odsinstances odsinstances_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.odsinstances
    ADD CONSTRAINT odsinstances_pk PRIMARY KEY (odsinstanceid);


--
-- Name: ownershiptokens ownershiptokens_pkey; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.ownershiptokens
    ADD CONSTRAINT ownershiptokens_pkey PRIMARY KEY (ownershiptokenid);


--
-- Name: aspnetroleclaims pk_aspnetroleclaims; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetroleclaims
    ADD CONSTRAINT pk_aspnetroleclaims PRIMARY KEY (id);


--
-- Name: aspnetroles pk_aspnetroles; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetroles
    ADD CONSTRAINT pk_aspnetroles PRIMARY KEY (id);


--
-- Name: aspnetuserclaims pk_aspnetuserclaims; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetuserclaims
    ADD CONSTRAINT pk_aspnetuserclaims PRIMARY KEY (id);


--
-- Name: aspnetuserlogins pk_aspnetuserlogins; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetuserlogins
    ADD CONSTRAINT pk_aspnetuserlogins PRIMARY KEY (loginprovider, providerkey);


--
-- Name: aspnetuserroles pk_aspnetuserroles; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetuserroles
    ADD CONSTRAINT pk_aspnetuserroles PRIMARY KEY (userid, roleid);


--
-- Name: aspnetusers pk_aspnetusers; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetusers
    ADD CONSTRAINT pk_aspnetusers PRIMARY KEY (id);


--
-- Name: aspnetusertokens pk_aspnetusertokens; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetusertokens
    ADD CONSTRAINT pk_aspnetusertokens PRIMARY KEY (userid, loginprovider, name);


--
-- Name: profileapplications profileapplications_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.profileapplications
    ADD CONSTRAINT profileapplications_pk PRIMARY KEY (profile_profileid, application_applicationid);


--
-- Name: profiles profiles_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.profiles
    ADD CONSTRAINT profiles_pk PRIMARY KEY (profileid);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.users
    ADD CONSTRAINT users_pk PRIMARY KEY (userid);


--
-- Name: vendornamespaceprefixes vendornamespaceprefixes_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.vendornamespaceprefixes
    ADD CONSTRAINT vendornamespaceprefixes_pk PRIMARY KEY (vendornamespaceprefixid);


--
-- Name: vendors vendors_pk; Type: CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.vendors
    ADD CONSTRAINT vendors_pk PRIMARY KEY (vendorid);


--
-- Name: DeployJournal PK_DeployJournal_Id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DeployJournal"
    ADD CONSTRAINT "PK_DeployJournal_Id" PRIMARY KEY (schemaversionsid);


--
-- Name: emailindex; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX emailindex ON dbo.aspnetusers USING btree (normalizedemail);


--
-- Name: ix_apiclient_apiclientid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_apiclient_apiclientid ON dbo.apiclientapplicationeducationorganizations USING btree (apiclient_apiclientid);


--
-- Name: ix_application_applicationid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_application_applicationid ON dbo.apiclients USING btree (application_applicationid);


--
-- Name: ix_applicationedorg_applicationedorgid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_applicationedorg_applicationedorgid ON dbo.apiclientapplicationeducationorganizations USING btree (applicationedorg_applicationedorgid);


--
-- Name: ix_aspnetroleclaims_roleid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_aspnetroleclaims_roleid ON dbo.aspnetroleclaims USING btree (roleid);


--
-- Name: ix_aspnetuserclaims_userid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_aspnetuserclaims_userid ON dbo.aspnetuserclaims USING btree (userid);


--
-- Name: ix_aspnetuserlogins_userid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_aspnetuserlogins_userid ON dbo.aspnetuserlogins USING btree (userid);


--
-- Name: ix_aspnetuserroles_roleid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_aspnetuserroles_roleid ON dbo.aspnetuserroles USING btree (roleid);


--
-- Name: ix_creatorownershiptokenid_ownershiptokenid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_creatorownershiptokenid_ownershiptokenid ON dbo.apiclients USING btree (creatorownershiptokenid_ownershiptokenid);


--
-- Name: ix_odsinstance_odsinstanceid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_odsinstance_odsinstanceid ON dbo.applications USING btree (odsinstance_odsinstanceid);


--
-- Name: ix_ownershiptoken_ownershiptokenid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_ownershiptoken_ownershiptokenid ON dbo.apiclientownershiptokens USING btree (ownershiptoken_ownershiptokenid);


--
-- Name: ix_profile_profileid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_profile_profileid ON dbo.profileapplications USING btree (profile_profileid);


--
-- Name: ix_user_userid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_user_userid ON dbo.apiclients USING btree (user_userid);


--
-- Name: ix_vendor_vendorid; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE INDEX ix_vendor_vendorid ON dbo.applications USING btree (vendor_vendorid);


--
-- Name: rolenameindex; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE UNIQUE INDEX rolenameindex ON dbo.aspnetroles USING btree (normalizedname);


--
-- Name: usernameindex; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE UNIQUE INDEX usernameindex ON dbo.aspnetusers USING btree (normalizedusername);


--
-- Name: ux_name_instancetype; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE UNIQUE INDEX ux_name_instancetype ON dbo.odsinstances USING btree (name, instancetype);


--
-- Name: ux_odsinstance_odsinstanceid_name; Type: INDEX; Schema: dbo; Owner: postgres
--

CREATE UNIQUE INDEX ux_odsinstance_odsinstanceid_name ON dbo.odsinstancecomponents USING btree (odsinstance_odsinstanceid, name);


--
-- Name: apiclientapplicationeducationorganizations fk_apiclientapplicationedorg_applicationedorg; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclientapplicationeducationorganizations
    ADD CONSTRAINT fk_apiclientapplicationedorg_applicationedorg FOREIGN KEY (applicationedorg_applicationedorgid) REFERENCES dbo.applicationeducationorganizations(applicationeducationorganizationid) ON DELETE CASCADE;


--
-- Name: apiclientapplicationeducationorganizations fk_apiclientapplicationeducationorganizations_apiclients; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclientapplicationeducationorganizations
    ADD CONSTRAINT fk_apiclientapplicationeducationorganizations_apiclients FOREIGN KEY (apiclient_apiclientid) REFERENCES dbo.apiclients(apiclientid) ON DELETE CASCADE;


--
-- Name: apiclientownershiptokens fk_apiclientownershiptokens_apiclients_apiclient_apiclientid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclientownershiptokens
    ADD CONSTRAINT fk_apiclientownershiptokens_apiclients_apiclient_apiclientid FOREIGN KEY (apiclient_apiclientid) REFERENCES dbo.apiclients(apiclientid) ON DELETE CASCADE;


--
-- Name: apiclientownershiptokens fk_apiclientownershiptokens_ownershiptokens_ownershiptoken_owne; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclientownershiptokens
    ADD CONSTRAINT fk_apiclientownershiptokens_ownershiptokens_ownershiptoken_owne FOREIGN KEY (ownershiptoken_ownershiptokenid) REFERENCES dbo.ownershiptokens(ownershiptokenid) ON DELETE CASCADE;


--
-- Name: apiclients fk_apiclients_applications; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclients
    ADD CONSTRAINT fk_apiclients_applications FOREIGN KEY (application_applicationid) REFERENCES dbo.applications(applicationid);


--
-- Name: apiclients fk_apiclients_creatorownershiptokenid_ownershiptokenid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclients
    ADD CONSTRAINT fk_apiclients_creatorownershiptokenid_ownershiptokenid FOREIGN KEY (creatorownershiptokenid_ownershiptokenid) REFERENCES dbo.ownershiptokens(ownershiptokenid);


--
-- Name: apiclients fk_apiclients_users; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.apiclients
    ADD CONSTRAINT fk_apiclients_users FOREIGN KEY (user_userid) REFERENCES dbo.users(userid);


--
-- Name: applicationeducationorganizations fk_applicationeducationorganizations_applications; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.applicationeducationorganizations
    ADD CONSTRAINT fk_applicationeducationorganizations_applications FOREIGN KEY (application_applicationid) REFERENCES dbo.applications(applicationid);


--
-- Name: applications fk_applications_odsinstances; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.applications
    ADD CONSTRAINT fk_applications_odsinstances FOREIGN KEY (odsinstance_odsinstanceid) REFERENCES dbo.odsinstances(odsinstanceid);


--
-- Name: applications fk_applications_vendors; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.applications
    ADD CONSTRAINT fk_applications_vendors FOREIGN KEY (vendor_vendorid) REFERENCES dbo.vendors(vendorid);


--
-- Name: aspnetroleclaims fk_aspnetroleclaims_aspnetroles_roleid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetroleclaims
    ADD CONSTRAINT fk_aspnetroleclaims_aspnetroles_roleid FOREIGN KEY (roleid) REFERENCES dbo.aspnetroles(id) ON DELETE CASCADE;


--
-- Name: aspnetuserclaims fk_aspnetuserclaims_aspnetusers_userid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetuserclaims
    ADD CONSTRAINT fk_aspnetuserclaims_aspnetusers_userid FOREIGN KEY (userid) REFERENCES dbo.aspnetusers(id) ON DELETE CASCADE;


--
-- Name: aspnetuserlogins fk_aspnetuserlogins_aspnetusers_userid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetuserlogins
    ADD CONSTRAINT fk_aspnetuserlogins_aspnetusers_userid FOREIGN KEY (userid) REFERENCES dbo.aspnetusers(id) ON DELETE CASCADE;


--
-- Name: aspnetuserroles fk_aspnetuserroles_aspnetroles_roleid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetuserroles
    ADD CONSTRAINT fk_aspnetuserroles_aspnetroles_roleid FOREIGN KEY (roleid) REFERENCES dbo.aspnetroles(id) ON DELETE CASCADE;


--
-- Name: aspnetuserroles fk_aspnetuserroles_aspnetusers_userid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetuserroles
    ADD CONSTRAINT fk_aspnetuserroles_aspnetusers_userid FOREIGN KEY (userid) REFERENCES dbo.aspnetusers(id) ON DELETE CASCADE;


--
-- Name: aspnetusertokens fk_aspnetusertokens_aspnetusers_userid; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.aspnetusertokens
    ADD CONSTRAINT fk_aspnetusertokens_aspnetusers_userid FOREIGN KEY (userid) REFERENCES dbo.aspnetusers(id) ON DELETE CASCADE;


--
-- Name: clientaccesstokens fk_clientaccesstokens_apiclients; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.clientaccesstokens
    ADD CONSTRAINT fk_clientaccesstokens_apiclients FOREIGN KEY (apiclient_apiclientid) REFERENCES dbo.apiclients(apiclientid);


--
-- Name: odsinstancecomponents fk_odsinstancecomponents_odsinstances; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.odsinstancecomponents
    ADD CONSTRAINT fk_odsinstancecomponents_odsinstances FOREIGN KEY (odsinstance_odsinstanceid) REFERENCES dbo.odsinstances(odsinstanceid) ON DELETE CASCADE;


--
-- Name: profileapplications fk_profileapplications_applications; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.profileapplications
    ADD CONSTRAINT fk_profileapplications_applications FOREIGN KEY (application_applicationid) REFERENCES dbo.applications(applicationid) ON DELETE CASCADE;


--
-- Name: profileapplications fk_profileapplications_profiles; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.profileapplications
    ADD CONSTRAINT fk_profileapplications_profiles FOREIGN KEY (profile_profileid) REFERENCES dbo.profiles(profileid) ON DELETE CASCADE;


--
-- Name: users fk_users_vendors; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.users
    ADD CONSTRAINT fk_users_vendors FOREIGN KEY (vendor_vendorid) REFERENCES dbo.vendors(vendorid);


--
-- Name: vendornamespaceprefixes fk_vendornamespaceprefixes_vendors; Type: FK CONSTRAINT; Schema: dbo; Owner: postgres
--

ALTER TABLE ONLY dbo.vendornamespaceprefixes
    ADD CONSTRAINT fk_vendornamespaceprefixes_vendors FOREIGN KEY (vendor_vendorid) REFERENCES dbo.vendors(vendorid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

