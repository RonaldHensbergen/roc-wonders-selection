--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bonus_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bonus_type (
    id smallint NOT NULL,
    name_short character varying(50),
    description character varying(200)
);


ALTER TABLE public.bonus_type OWNER TO postgres;

--
-- Name: bonus_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.bonus_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bonus_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_wonders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_wonders (
    id integer NOT NULL,
    wonder_id smallint,
    user_id smallint,
    level smallint
);


ALTER TABLE public.user_wonders OWNER TO postgres;

--
-- Name: user_wonders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_wonders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_wonders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(200),
    user_name character varying(20)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: wonder_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wonder_type (
    id integer NOT NULL,
    name character varying(50),
    english_name character varying(50)
);


ALTER TABLE public.wonder_type OWNER TO postgres;

--
-- Name: wonders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wonders (
    id integer NOT NULL,
    name character varying(200),
    english_name character varying(200),
    allied boolean,
    wonder_type_1 smallint,
    wonder_type_2 smallint,
    synergy_bonus smallint,
    synergy_type smallint,
    synergy_amount numeric(6,2)
);


ALTER TABLE public.wonders OWNER TO postgres;

--
-- Name: vw_wonders; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_wonders AS
 SELECT w.id,
    w.name AS wonder_name,
    t1.name AS type_1,
    t2.name AS type_2,
    bt.name_short AS synergy_bonus_type,
    bt.description AS synergy_bonus,
    bs.name AS synergy_type,
    w.synergy_amount
   FROM ((((public.wonders w
     JOIN public.wonder_type t1 ON ((t1.id = w.wonder_type_1)))
     LEFT JOIN public.wonder_type t2 ON ((t2.id = w.wonder_type_2)))
     LEFT JOIN public.wonder_type bs ON ((bs.id = w.synergy_bonus)))
     LEFT JOIN public.bonus_type bt ON ((bt.id = w.synergy_type)));


ALTER VIEW public.vw_wonders OWNER TO postgres;

--
-- Name: vw_wonders_en; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_wonders_en AS
 SELECT w.id,
    w.english_name AS wonder_name,
    t1.english_name AS type_1,
    t2.english_name AS type_2
   FROM ((public.wonders w
     JOIN public.wonder_type t1 ON ((t1.id = w.wonder_type_1)))
     LEFT JOIN public.wonder_type t2 ON ((t2.id = w.wonder_type_2)))
  ORDER BY w.id;


ALTER VIEW public.vw_wonders_en OWNER TO postgres;

--
-- Name: wonder_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.wonder_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.wonder_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: wonders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.wonders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.wonders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: bonus_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bonus_type (id, name_short, description) FROM stdin;
1	RP	extra RP
2	peg	previous era goods
3	RCH	Ranged Critical Hit Chance
4	HID	Heavy Infantry Damage
5	DG	Donations Gears
6	ceg	current era goods
7	CD	Cavalry Damage
8	Fd	Food bonus
9	SRP	Speed up RP regeneration
10	TG	Trade Goods bonus
11	IHP	Infantry HP
12	BHP	Bastion HP
13	RHP	Ranged HP
14	ID	Infantry Damage
15	RD	Ranged Damage
17	HIHP	Heavy Infantry HP
18	CG	Boost Capital Goods
19	cepg	current era primary goods
20	AD	All Units Damage
\.


--
-- Data for Name: user_wonders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_wonders (id, wonder_id, user_id, level) FROM stdin;
1	25	1	11
2	24	1	16
3	26	1	7
4	21	1	21
5	22	1	14
6	23	1	25
7	17	1	6
8	9	1	19
9	15	1	5
10	6	1	11
11	18	1	4
12	7	1	22
13	2	1	15
14	11	1	19
15	14	1	12
16	3	1	25
17	12	1	22
18	8	1	6
19	19	1	4
20	4	1	27
21	13	1	6
22	16	1	21
23	1	1	11
24	20	1	24
25	5	1	26
26	10	1	20
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, user_name) FROM stdin;
1	Ronald Hensbergen	ronald
\.


--
-- Data for Name: wonder_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wonder_type (id, name, english_name) FROM stdin;
1	Arena	Arena
2	Fort	Fortress
3	Natuur	Nature
4	Marine	Naval
5	Paleis	Palace
6	Standbeeld	Statue
7	Tempel	Temple
\.


--
-- Data for Name: wonders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wonders (id, name, english_name, allied, wonder_type_1, wonder_type_2, synergy_bonus, synergy_type, synergy_amount) FROM stdin;
25	Hagia Sophia	Hagia Sophia	f	7	\N	\N	\N	\N
24	Drakenschip Ellida	Dragonship Ellida	t	4	6	\N	\N	\N
26	Cite van Carcassonne	Cite de Carcassonne	f	2	5	\N	\N	\N
21	Alhambra	Alhambra	f	2	3	\N	\N	\N
22	Yggdrasil	Yggdrasil	t	3	6	\N	\N	\N
23	Walhalla	Valhalla	t	1	3	5	20	1.50
17	Paleis van Sayil	Sayil Palace	t	2	5	2	12	2.00
9	Grote sfinx	Great Sphinx	t	6	\N	6	7	4.00
15	Verboden stad	Forbidden City	t	5	7	7	6	60.00
6	Mausoleum van Halicarnassus	Tomb of Mausolus	f	7	\N	7	19	100.00
18	Tikal	Tikal	t	1	5	1	18	5.00
7	Kolossus van Rhodos	Colossus of Rhodes	f	4	6	4	5	5.00
2	Hangende Tuinen	Hanging Gardens	f	3	5	5	8	8.00
11	Colosseum	Colosseum	f	1	2	6	4	4.00
14	Terracottaleger	Terracotta Army	t	2	6	2	17	2.00
3	Standbeeld van Zeus	Statue of Zeus	f	6	\N	6	14	4.00
12	Paleis in Aken	Palace of Aachen	f	2	5	2	11	2.00
8	Piramide van Cheops	Cheops Pyramid	t	7	\N	7	2	60.00
19	Chitzen Itza	Chichen Itza	t	1	7	1	3	1.00
4	Artemis	Temple of Artemis	f	7	\N	6	15	4.00
13	Sherwoodbos	Sherwood Forest	f	2	3	2	13	2.00
16	Chinese muur	Great Wall	t	2	7	2	1	1.00
1	Stonehenge	Stonehenge	f	6	7	7	1	1.00
20	Scheve toren van Pisa	Leaning Tower of Pisa	f	3	7	3	9	2.50
5	Pharos van Alexandrie	Lighthouse of Alexandria	f	4	7	4	10	5.00
10	Aboe Simbel	Abu Simbel	t	5	\N	6	1	1.00
\.


--
-- Name: bonus_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bonus_type_id_seq', 20, true);


--
-- Name: user_wonders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_wonders_id_seq', 26, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: wonder_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wonder_type_id_seq', 7, true);


--
-- Name: wonders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wonders_id_seq', 26, true);


--
-- Name: bonus_type bonus_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bonus_type
    ADD CONSTRAINT bonus_type_pkey PRIMARY KEY (id);


--
-- Name: bonus_type uq_name_short; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bonus_type
    ADD CONSTRAINT uq_name_short UNIQUE (name_short);


--
-- Name: user_wonders uq_user_wonders; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_wonders
    ADD CONSTRAINT uq_user_wonders UNIQUE (wonder_id, user_id);


--
-- Name: user_wonders user_wonders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_wonders
    ADD CONSTRAINT user_wonders_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wonder_type wonder_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonder_type
    ADD CONSTRAINT wonder_type_pkey PRIMARY KEY (id);


--
-- Name: wonders wonders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonders
    ADD CONSTRAINT wonders_pkey PRIMARY KEY (id);


--
-- Name: user_wonders user_wonders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_wonders
    ADD CONSTRAINT user_wonders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_wonders user_wonders_wonder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_wonders
    ADD CONSTRAINT user_wonders_wonder_id_fkey FOREIGN KEY (wonder_id) REFERENCES public.wonders(id);


--
-- Name: wonders wonders_synergy_bonus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonders
    ADD CONSTRAINT wonders_synergy_bonus_fkey FOREIGN KEY (synergy_bonus) REFERENCES public.wonder_type(id);


--
-- Name: wonders wonders_synergy_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonders
    ADD CONSTRAINT wonders_synergy_type_fkey FOREIGN KEY (synergy_type) REFERENCES public.bonus_type(id);


--
-- Name: wonders wonders_wonder_type_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonders
    ADD CONSTRAINT wonders_wonder_type_1_fkey FOREIGN KEY (wonder_type_1) REFERENCES public.wonder_type(id);


--
-- Name: wonders wonders_wonder_type_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonders
    ADD CONSTRAINT wonders_wonder_type_2_fkey FOREIGN KEY (wonder_type_2) REFERENCES public.wonder_type(id);


--
-- PostgreSQL database dump complete
--

