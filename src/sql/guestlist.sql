--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'postgres';

--
-- TOC entry 4 (OID 2200)
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


SET SESSION AUTHORIZATION 'guestlist';

SET search_path = public, pg_catalog;

--
-- TOC entry 5 (OID 22559)
-- Name: guestlist; Type: TABLE; Schema: public; Owner: guestlist
--

CREATE TABLE guestlist (
    "GuestID" smallint NOT NULL,
    "Title" character varying(5) NOT NULL,
    "ProperName" character varying(100) NOT NULL,
    "InnerEnvelopeName" character varying(100) NOT NULL,
    "SigOtherTitle" character varying(5),
    "SigOtherProperName" character varying(100),
    "SigOtherEnvelopeName" character varying(100),
    "Address1" character varying(100) NOT NULL,
    "Address2" character varying(100),
    "City" character varying(100) NOT NULL,
    "State" character varying(25) NOT NULL,
    "Zip" integer NOT NULL,
    "ZipPlusFour" smallint,
    "SaveDateSent" boolean DEFAULT false NOT NULL,
    "InviteSent" boolean DEFAULT false NOT NULL,
    "HasReplied" boolean DEFAULT false NOT NULL,
    "Reply" boolean DEFAULT false NOT NULL,
    "ThankYouSent" boolean DEFAULT false NOT NULL,
    "GiftSource" character varying(100),
    "GiftItem" character varying(100),
    "UnderEighteen1" character varying(100),
    "UnderEighteen2" character varying(100),
    "UnderEighteen3" character varying(100),
    "UnderEighteen4" character varying(100),
    "UnderEighteenAttending" smallint DEFAULT 0 NOT NULL,
    "Lodging" character varying(50),
    "TravelType" character varying(50),
    "TravelDestination" character varying(50),
    "ArrivalDate" date,
    "ArrivalTime" time without time zone,
    "DepartureDate" date,
    "DepartureTime" time without time zone,
    "Telephone" character varying(25),
    "Email" character varying(50),
    "HostID" smallint NOT NULL
);


--
-- TOC entry 6 (OID 22559)
-- Name: guestlist; Type: ACL; Schema: public; Owner: guestlist
--

REVOKE ALL ON TABLE guestlist FROM PUBLIC;
GRANT ALL ON TABLE guestlist TO guestlist;


SET SESSION AUTHORIZATION 'guestlist';

--
-- TOC entry 7 (OID 22567)
-- Name: hostlist; Type: TABLE; Schema: public; Owner: guestlist
--

CREATE TABLE hostlist (
    "HostID" integer NOT NULL,
    "Name" character varying(32) NOT NULL,
    "Password" character varying(64) NOT NULL,
    "Color" character varying(16),
    "Login" character varying(32) NOT NULL
);


--
-- TOC entry 8 (OID 22567)
-- Name: hostlist; Type: ACL; Schema: public; Owner: guestlist
--

REVOKE ALL ON TABLE hostlist FROM PUBLIC;
GRANT ALL ON TABLE hostlist TO guestlist;


SET SESSION AUTHORIZATION 'guestlist';

--
-- TOC entry 9 (OID 22569)
-- Name: lockedlist; Type: TABLE; Schema: public; Owner: guestlist
--

CREATE TABLE lockedlist (
    list character varying(16) NOT NULL,
    locked boolean DEFAULT false NOT NULL
);


--
-- TOC entry 10 (OID 22569)
-- Name: lockedlist; Type: ACL; Schema: public; Owner: guestlist
--

REVOKE ALL ON TABLE lockedlist FROM PUBLIC;
GRANT SELECT,UPDATE ON TABLE lockedlist TO guestlist;


SET SESSION AUTHORIZATION 'guestlist';

--
-- Data for TOC entry 13 (OID 22559)
-- Name: guestlist; Type: TABLE DATA; Schema: public; Owner: guestlist
--

COPY guestlist ("GuestID", "Title", "ProperName", "InnerEnvelopeName", "SigOtherTitle", "SigOtherProperName", "SigOtherEnvelopeName", "Address1", "Address2", "City", "State", "Zip", "ZipPlusFour", "SaveDateSent", "InviteSent", "HasReplied", "Reply", "ThankYouSent", "GiftSource", "GiftItem", "UnderEighteen1", "UnderEighteen2", "UnderEighteen3", "UnderEighteen4", "UnderEighteenAttending", "Lodging", "TravelType", "TravelDestination", "ArrivalDate", "ArrivalTime", "DepartureDate", "DepartureTime", "Telephone", "Email", "HostID") FROM stdin;
\.


--
-- Data for TOC entry 14 (OID 22567)
-- Name: hostlist; Type: TABLE DATA; Schema: public; Owner: guestlist
--

COPY hostlist ("HostID", "Name", "Password", "Color", "Login") FROM stdin;
\.


--
-- Data for TOC entry 15 (OID 22569)
-- Name: lockedlist; Type: TABLE DATA; Schema: public; Owner: guestlist
--

COPY lockedlist (list, locked) FROM stdin;
hostlist	f
guestlist	f
\.


--
-- TOC entry 11 (OID 22575)
-- Name: guestlist_pkey; Type: CONSTRAINT; Schema: public; Owner: guestlist
--

ALTER TABLE ONLY guestlist
    ADD CONSTRAINT guestlist_pkey PRIMARY KEY ("GuestID");


--
-- TOC entry 12 (OID 22577)
-- Name: hostlist_pkey; Type: CONSTRAINT; Schema: public; Owner: guestlist
--

ALTER TABLE ONLY hostlist
    ADD CONSTRAINT hostlist_pkey PRIMARY KEY ("HostID");


SET SESSION AUTHORIZATION 'postgres';

--
-- TOC entry 3 (OID 2200)
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


