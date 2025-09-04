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

--
-- Name: te(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.te()
    LANGUAGE sql
    AS $$  select * from wonders
;
$$;


ALTER PROCEDURE public.te() OWNER TO postgres;

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
-- Name: user_bonus_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_bonus_preferences (
    id integer NOT NULL,
    preference_name character varying(50),
    bonus_type_id smallint,
    preference_value numeric(3,1),
    user_id integer
);


ALTER TABLE public.user_bonus_preferences OWNER TO postgres;

--
-- Name: user_bonus_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_bonus_preferences ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_bonus_preferences_id_seq
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
-- Name: wonder_level_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wonder_level_stats (
    id integer NOT NULL,
    wonder_id smallint,
    bonus_type_id smallint,
    stat_value numeric(10,2)
);


ALTER TABLE public.wonder_level_stats OWNER TO postgres;

--
-- Name: wonder_level_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.wonder_level_stats ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.wonder_level_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
6	ceg	current era goods
8	Fd	Food bonus
9	SRP	Speed up RP regeneration
12	BHP	Unit Bastion - Stat Hit Points
18	CG	Boost Capital Goods
19	cepg	current era primary goods
20	AD	Stat Damage
7	CD	Unit Cavalry - Stat Damage
15	RD	Unit Range - Stat Damage
11	IHP	Unit Infantry - Stat Hit Points
17	HIHP	Unit Heavy Infantry - Stat Hit Points
4	HID	Unit Heavy Infantry - Stat Damage
13	RHP	Unit Range - Stat Hit Points
14	ID	Unit Infantry - Stat Damage
3	RCH	Unit Range - Stat Crit Boost
10	TG	Trade Goods - Stat Bonus
5	DG	Gears
21	CC	China Crest - Goods
23	CHP	Unit Cavalry - Stat Hit Points
24	GS	Goods - Stat Goods
25	CS	Stat Coins
26	RPEC	extra RP / Event Coins
27	EC	Egypt Crest - Goods
28	RPF	Research - Research - Research - Food
29	RSCB	Trade Slot Cooldown Boost
30	HI	Unit Heavy Infantry
31	Co	Compass
32	KP	Questgiver King Pakal - Chest2
33	RPS	Stat RP
34	ccg	Icon chest customizations generic - Food
35	ICHC	Unit Infantry - Stat Crit Chance
36	RL	Commander Ragnar Lodbrok - Chest2
37	RPT	Research - Time Boost
38	GPG	Goods - Previous Goods
39	EW	Extra Worker
40	AB	Unit Aachen Boost
41	RPB	Research - Boost
42	MCG	Maya Empire Crest - Goods
43	EQ	Questgiver Emperor Qin - Chest2
44	MA	Unit Maya Archer
45	EDW	Extra Dock Worker
46	RPC	Research - Research - Research - Chest2
47	TP	Tavern Production Bonus
48	HICC	Unit Heavy Infantry - Stat Crit Chance
49	Me	Questgiver Menes - Chest2
\.


--
-- Data for Name: user_bonus_preferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_bonus_preferences (id, preference_name, bonus_type_id, preference_value, user_id) FROM stdin;
1	production 	1	2.0	1
2	production 	2	1.0	1
3	production 	6	1.0	1
4	production 	8	7.0	1
5	production 	9	8.0	1
6	production 	12	0.0	1
7	production 	18	2.0	1
8	production 	19	2.0	1
9	production 	20	2.0	1
10	production 	7	1.0	1
11	production 	15	1.0	1
12	production 	11	1.0	1
13	production 	17	1.0	1
14	production 	4	1.0	1
15	production 	13	1.0	1
16	production 	14	1.0	1
17	production 	3	1.0	1
18	production 	10	4.0	1
19	production 	5	6.0	1
20	production 	21	0.0	1
21	production 	23	1.0	1
22	production 	24	1.0	1
23	production 	25	2.0	1
24	production 	26	6.0	1
25	production 	27	0.0	1
26	production 	28	3.0	1
27	production 	29	6.0	1
28	production 	30	1.0	1
29	production 	31	4.0	1
30	production 	32	1.0	1
31	production 	33	3.0	1
32	production 	34	2.0	1
33	production 	35	1.0	1
34	production 	36	1.0	1
35	production 	37	6.0	1
36	production 	38	1.0	1
37	production 	39	4.0	1
38	production 	40	1.0	1
39	production 	41	4.0	1
40	production 	42	0.0	1
41	production 	43	1.0	1
42	production 	44	1.0	1
43	production 	45	5.0	1
44	production 	46	3.0	1
45	production 	47	2.0	1
46	production 	48	1.0	1
47	production 	49	1.0	1
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
-- Data for Name: wonder_level_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wonder_level_stats (id, wonder_id, bonus_type_id, stat_value) FROM stdin;
1	18	24	5.00
2	18	24	7.00
3	18	24	8.00
4	18	24	8.00
5	18	24	9.00
6	18	24	10.00
7	18	24	10.00
8	18	24	11.00
9	18	24	12.00
10	18	24	12.00
11	18	24	12.00
12	18	24	13.00
13	18	24	13.00
14	18	24	14.00
15	18	24	14.00
16	18	24	14.00
17	18	24	15.00
18	20	37	31.00
19	20	37	31.00
20	20	37	32.00
21	20	37	32.00
22	20	37	32.00
23	20	37	33.00
24	20	37	33.00
25	20	37	33.00
26	20	37	34.00
27	20	37	34.00
28	5	10	16.00
29	5	10	16.00
30	5	10	16.00
31	5	10	17.00
32	6	19	300.00
33	5	10	17.00
34	6	19	330.00
35	6	19	360.00
36	6	19	390.00
37	5	10	17.00
38	5	10	18.00
39	5	10	18.00
40	1	1	1.00
41	6	19	540.00
42	6	19	570.00
43	6	19	600.00
74	2	39	1.00
75	2	39	1.00
76	2	39	1.00
77	2	39	1.00
78	2	39	1.00
79	2	39	1.00
80	2	39	1.00
81	20	37	34.00
82	20	37	35.00
83	20	37	40.00
84	24	23	5.00
85	24	23	6.00
86	24	23	6.00
87	24	23	6.00
88	24	23	6.00
89	24	23	7.00
90	24	23	7.00
91	24	23	7.00
92	24	23	7.00
93	24	23	7.00
94	24	23	8.00
95	24	23	8.00
96	24	23	8.00
97	24	23	8.00
98	24	23	8.00
99	24	23	8.00
100	24	23	8.00
101	24	23	9.00
102	24	23	9.00
103	24	23	9.00
104	24	23	9.00
105	24	23	9.00
106	24	23	9.00
107	24	29	10.00
108	24	29	14.00
109	24	29	17.00
110	24	29	19.00
111	24	29	25.00
112	24	29	27.00
113	24	29	28.00
114	24	29	30.00
115	19	44	43.00
116	24	29	31.00
117	24	29	35.00
118	24	29	36.00
119	24	29	37.00
120	24	29	39.00
121	24	29	40.00
122	24	29	45.00
123	24	29	46.00
124	24	29	47.00
125	24	29	48.00
126	24	29	49.00
127	24	29	55.00
128	24	29	56.00
129	24	29	57.00
130	24	29	57.00
131	24	29	58.00
132	24	29	65.00
133	24	29	66.00
134	24	29	66.00
135	24	29	67.00
136	24	29	68.00
137	24	29	75.00
138	26	48	30.00
139	26	48	44.00
140	26	48	55.00
141	26	48	65.00
142	26	48	74.00
143	26	48	82.00
144	26	48	89.00
145	26	48	96.00
146	26	48	102.00
147	26	48	108.00
148	26	48	114.00
149	26	48	120.00
150	26	48	126.00
151	26	48	131.00
152	26	48	136.00
153	26	48	141.00
154	26	48	146.00
155	26	48	150.00
156	26	48	155.00
157	26	48	160.00
158	26	48	164.00
159	26	48	168.00
160	26	48	173.00
161	26	48	177.00
162	26	48	181.00
163	26	48	185.00
164	26	48	189.00
165	26	48	193.00
166	26	48	196.00
167	26	48	200.00
168	26	30	5.00
169	26	30	11.00
170	26	30	15.00
171	26	30	17.00
172	26	30	19.00
173	26	30	21.00
174	26	30	22.00
175	26	30	24.00
176	26	30	25.00
177	26	30	26.00
178	26	30	28.00
179	26	30	29.00
180	26	30	30.00
181	26	30	31.00
182	26	30	33.00
183	26	30	34.00
184	26	30	35.00
185	26	30	37.00
186	26	30	38.00
187	26	30	39.00
188	26	30	41.00
189	26	30	41.00
190	26	30	41.00
191	26	30	42.00
192	26	30	42.00
193	26	30	43.00
194	26	30	43.00
195	2	39	1.00
196	2	39	1.00
197	2	39	1.00
198	2	39	1.00
199	2	39	1.00
200	2	39	1.00
201	2	39	1.00
202	2	39	2.00
203	2	39	2.00
204	2	39	2.00
205	2	39	2.00
206	2	39	2.00
207	2	39	2.00
208	2	39	2.00
209	2	39	2.00
210	2	39	2.00
211	2	39	2.00
212	2	39	2.00
213	2	39	2.00
214	2	39	2.00
215	2	39	2.00
216	25	33	1.00
217	25	33	1.00
218	25	33	1.00
219	25	33	1.00
220	25	33	1.00
221	25	33	1.00
222	25	33	1.00
223	25	33	1.00
224	25	33	1.00
225	25	33	1.00
226	25	33	1.00
227	25	33	1.00
228	25	33	1.00
229	25	33	1.00
230	25	33	1.00
231	25	33	1.00
232	11	39	1.00
233	11	39	1.00
234	11	39	1.00
235	11	39	1.00
236	11	39	1.00
237	11	39	1.00
238	11	39	1.00
239	11	39	1.00
240	11	39	1.00
241	11	39	1.00
242	2	39	2.00
243	2	39	3.00
244	4	39	2.00
245	4	39	2.00
246	4	39	2.00
247	4	39	2.00
248	4	39	2.00
249	4	39	2.00
250	4	39	2.00
251	4	39	2.00
252	4	39	2.00
253	4	39	2.00
254	4	39	2.00
255	4	39	2.00
256	4	39	2.00
257	4	39	2.00
258	4	39	3.00
259	4	39	3.00
260	4	39	3.00
261	4	39	3.00
262	4	39	3.00
263	4	39	3.00
264	4	39	3.00
265	4	39	3.00
266	4	39	3.00
267	4	39	3.00
268	4	39	3.00
269	4	39	3.00
270	4	39	3.00
271	4	39	3.00
272	4	39	3.00
273	4	39	4.00
274	5	45	1.00
275	5	45	1.00
276	5	45	1.00
277	5	45	1.00
278	5	45	1.00
279	5	45	1.00
280	5	45	1.00
281	5	45	1.00
282	5	45	1.00
283	5	45	1.00
284	5	45	1.00
285	5	45	1.00
286	5	45	1.00
287	5	45	1.00
288	5	45	2.00
289	5	45	2.00
290	5	45	2.00
291	5	45	2.00
292	5	45	2.00
293	5	45	2.00
294	5	45	2.00
295	5	45	2.00
296	5	45	2.00
297	5	45	2.00
298	5	45	2.00
299	5	45	2.00
300	5	45	2.00
301	5	45	2.00
302	5	45	2.00
303	5	45	3.00
304	10	1	3.00
305	3	14	17.00
306	3	14	17.00
307	3	14	17.00
308	3	14	18.00
309	3	14	18.00
310	3	14	18.00
311	3	14	18.00
312	5	10	5.00
313	21	39	1.00
314	21	39	1.00
315	21	39	1.00
316	21	39	1.00
317	21	39	1.00
318	21	39	1.00
319	21	39	1.00
320	21	39	1.00
321	21	39	1.00
322	21	39	2.00
323	21	39	2.00
324	21	39	2.00
325	21	39	2.00
326	21	39	2.00
327	21	39	2.00
328	21	39	2.00
329	21	39	2.00
330	21	39	2.00
331	25	33	1.00
332	25	33	1.00
333	25	33	1.00
334	25	33	1.00
335	25	33	1.00
336	25	33	1.00
337	11	39	1.00
338	11	39	1.00
339	11	39	1.00
340	11	39	1.00
341	11	39	2.00
342	24	23	3.00
343	6	19	630.00
344	6	19	660.00
345	6	19	690.00
346	6	19	720.00
347	6	19	750.00
348	6	19	780.00
349	6	19	810.00
350	6	19	840.00
351	6	19	870.00
352	6	19	900.00
353	6	19	930.00
354	6	19	960.00
355	6	19	990.00
356	6	19	1020.00
357	6	19	1050.00
358	6	19	1080.00
359	6	19	1110.00
360	6	19	1140.00
361	6	19	1170.00
362	14	17	4.00
363	14	17	5.00
364	9	49	41.00
365	14	17	5.00
366	10	1	2.00
367	10	1	2.00
368	10	1	2.00
369	10	1	2.00
370	24	23	3.00
371	24	23	4.00
372	24	23	4.00
373	24	23	5.00
374	24	23	5.00
375	24	23	5.00
376	13	46	30.00
377	13	46	26.00
378	13	46	25.00
379	13	46	25.00
380	10	1	2.00
381	10	1	2.00
382	10	1	3.00
383	10	1	3.00
384	22	47	33.00
385	22	47	33.00
386	22	47	34.00
387	22	47	34.00
388	22	47	35.00
389	22	47	35.00
390	22	47	36.00
391	22	47	36.00
392	22	47	37.00
393	10	1	3.00
394	10	1	3.00
395	10	1	3.00
396	10	1	3.00
397	10	1	3.00
398	10	1	3.00
399	10	1	3.00
400	10	1	4.00
401	8	2	230.00
402	8	2	240.00
403	8	2	250.00
404	8	2	260.00
405	8	2	270.00
406	17	12	7.00
407	17	12	7.00
408	17	12	7.00
409	17	12	8.00
410	17	12	8.00
411	17	12	8.00
412	17	12	8.00
413	17	12	8.00
414	17	12	8.00
415	17	12	8.00
416	17	12	9.00
417	17	12	9.00
418	17	12	9.00
419	17	12	9.00
420	17	12	9.00
421	17	12	9.00
422	9	7	5.00
423	9	7	6.00
424	9	7	8.00
425	9	7	8.00
426	9	7	9.00
427	9	7	10.00
428	9	7	10.00
429	9	7	11.00
430	9	7	11.00
431	9	7	12.00
432	9	7	12.00
433	9	7	13.00
434	8	2	280.00
435	8	2	290.00
436	14	17	7.00
437	14	17	7.00
438	14	17	7.00
439	14	17	8.00
440	14	17	8.00
441	14	17	8.00
442	14	17	8.00
443	14	17	8.00
444	14	17	8.00
445	14	17	8.00
446	14	17	9.00
447	14	17	9.00
448	14	17	9.00
449	14	17	9.00
450	14	17	9.00
451	14	17	9.00
452	3	14	5.00
453	3	14	6.00
454	3	14	8.00
455	3	14	8.00
456	3	14	9.00
457	3	14	10.00
458	3	14	10.00
459	3	14	11.00
460	3	14	11.00
461	3	14	12.00
462	3	14	12.00
463	3	14	13.00
464	3	14	13.00
465	3	14	14.00
466	3	14	14.00
467	3	14	14.00
468	3	14	15.00
469	3	14	15.00
470	3	14	15.00
471	3	14	16.00
472	3	14	16.00
473	3	14	16.00
474	3	14	17.00
475	17	12	6.00
476	\N	26	200.00
477	\N	26	200.00
478	\N	26	200.00
479	\N	26	200.00
480	\N	26	240.00
481	\N	26	240.00
482	\N	26	240.00
483	\N	26	240.00
484	\N	26	240.00
485	\N	26	280.00
486	\N	26	280.00
487	\N	26	280.00
488	\N	26	280.00
489	\N	26	280.00
490	\N	26	320.00
491	\N	26	320.00
492	18	24	15.00
493	18	24	15.00
494	18	24	16.00
495	18	24	16.00
496	18	24	16.00
497	18	24	17.00
498	18	24	17.00
499	18	24	17.00
500	18	24	17.00
501	18	24	18.00
502	18	24	18.00
503	18	24	18.00
504	18	24	18.00
505	25	33	1.00
506	20	41	29.00
507	20	41	32.00
508	20	41	33.00
509	20	41	34.00
510	20	41	35.00
511	20	41	36.00
512	20	41	37.00
513	20	41	38.00
514	20	41	39.00
515	20	41	40.00
516	20	41	41.00
517	20	41	42.00
518	20	41	43.00
519	20	41	44.00
520	20	41	45.00
521	20	41	46.00
522	20	41	52.00
523	20	37	10.00
524	20	37	12.00
525	20	37	13.00
526	20	37	15.00
527	20	37	20.00
528	20	37	20.00
529	20	37	21.00
530	20	37	22.00
531	20	37	23.00
532	20	37	23.00
533	20	37	24.00
534	20	37	24.00
535	20	37	25.00
536	20	37	25.00
537	20	37	30.00
538	20	37	30.00
539	20	37	30.00
540	\N	26	320.00
541	\N	26	320.00
542	\N	26	320.00
543	\N	26	360.00
544	\N	26	360.00
545	\N	26	360.00
546	\N	26	360.00
547	\N	26	360.00
548	\N	26	400.00
549	\N	26	400.00
550	\N	26	400.00
551	\N	26	400.00
552	\N	26	400.00
553	\N	26	440.00
554	17	12	6.00
555	17	12	6.00
556	17	12	6.00
557	17	12	7.00
558	17	12	7.00
559	11	4	13.00
560	11	4	14.00
561	11	4	14.00
562	11	4	14.00
563	11	4	15.00
564	11	4	15.00
565	11	4	15.00
566	11	4	16.00
567	11	4	16.00
568	11	4	16.00
569	11	4	17.00
570	11	4	17.00
571	11	4	17.00
572	11	4	17.00
573	11	4	18.00
574	11	4	18.00
575	11	4	18.00
576	11	4	18.00
577	14	17	3.00
578	14	17	3.00
579	14	17	4.00
580	12	11	3.00
581	12	11	3.00
582	12	11	4.00
583	12	11	4.00
584	12	11	5.00
585	12	11	5.00
586	12	11	5.00
587	12	11	5.00
588	12	11	6.00
589	12	11	6.00
590	12	11	6.00
591	12	11	6.00
592	12	11	7.00
593	12	11	7.00
594	12	11	7.00
595	12	11	7.00
596	12	11	7.00
597	12	11	8.00
598	12	11	8.00
599	12	11	8.00
600	12	11	8.00
601	12	11	8.00
602	12	11	8.00
603	12	11	8.00
604	12	11	9.00
605	12	11	9.00
606	12	11	9.00
607	12	11	9.00
608	12	11	9.00
609	12	11	9.00
610	19	3	25.00
611	19	3	35.00
612	19	3	43.00
613	19	3	49.00
614	19	3	54.00
615	5	10	18.00
616	5	10	19.00
617	5	10	19.00
618	5	10	19.00
619	5	10	19.00
620	5	10	20.00
621	5	10	20.00
622	5	10	20.00
623	25	38	250.00
624	25	38	270.00
625	25	38	290.00
626	25	38	310.00
627	25	38	330.00
628	25	38	350.00
629	25	38	370.00
630	25	38	390.00
631	25	38	410.00
632	25	38	430.00
633	25	38	450.00
634	25	38	470.00
635	25	38	490.00
636	25	38	510.00
637	25	38	530.00
638	25	38	550.00
639	25	38	570.00
640	25	38	590.00
641	25	38	610.00
642	25	38	630.00
643	25	38	650.00
644	25	38	670.00
645	25	38	690.00
646	25	38	710.00
647	25	38	730.00
648	25	38	750.00
649	25	38	770.00
650	25	38	790.00
651	25	38	810.00
652	25	38	830.00
653	25	33	1.00
654	25	33	1.00
655	25	33	1.00
656	25	33	1.00
657	25	33	1.00
658	25	33	1.00
659	25	33	1.00
660	19	3	59.00
661	19	3	64.00
662	19	3	68.00
663	19	3	106.00
664	19	3	108.00
665	19	3	111.00
666	19	3	113.00
667	19	3	115.00
668	1	1	4.00
669	11	4	10.00
670	11	4	11.00
671	11	4	11.00
672	11	4	12.00
673	11	4	12.00
674	11	4	13.00
675	19	3	117.00
676	19	3	119.00
677	19	3	121.00
678	19	3	123.00
679	19	3	125.00
680	4	15	5.00
681	4	15	6.00
682	13	13	5.00
683	13	13	6.00
684	13	13	6.00
685	23	20	8.00
686	10	20	9.00
687	10	20	10.00
688	10	20	10.00
689	10	20	11.00
690	10	20	11.00
691	10	20	12.00
692	10	20	12.00
693	10	20	13.00
694	10	20	13.00
695	10	20	14.00
696	10	20	14.00
697	10	20	14.00
698	10	20	15.00
699	10	20	15.00
700	10	20	15.00
701	10	20	16.00
702	10	20	16.00
703	10	20	16.00
704	10	20	17.00
705	10	20	17.00
706	10	20	17.00
707	10	20	17.00
708	10	20	18.00
709	10	20	18.00
710	10	20	18.00
711	8	2	390.00
712	13	13	6.00
713	13	13	6.00
714	13	13	7.00
715	13	13	7.00
716	13	13	7.00
717	13	13	7.00
718	13	13	7.00
719	7	5	5.00
720	7	5	9.00
721	1	25	10.00
722	1	25	13.00
723	1	25	15.00
724	1	25	17.00
725	1	25	18.00
726	1	25	20.00
727	1	25	21.00
728	1	25	22.00
729	1	25	23.00
730	1	25	24.00
731	1	25	25.00
732	1	25	26.00
733	1	25	27.00
734	1	25	27.00
735	1	25	28.00
736	1	25	29.00
737	1	25	29.00
738	1	25	30.00
739	1	25	31.00
740	1	25	31.00
741	1	25	32.00
742	1	25	33.00
743	1	25	33.00
744	1	25	34.00
745	1	25	34.00
746	1	25	35.00
747	1	25	35.00
748	1	25	36.00
749	1	25	36.00
750	1	25	37.00
751	21	39	2.00
752	21	39	3.00
753	21	39	3.00
754	21	39	3.00
755	21	39	3.00
756	21	39	3.00
757	21	39	3.00
758	21	39	3.00
759	21	39	3.00
760	21	39	3.00
761	21	39	3.00
762	21	39	4.00
763	22	47	10.00
764	22	47	13.00
765	22	47	15.00
766	22	47	17.00
767	22	47	18.00
768	22	47	20.00
769	22	47	21.00
770	22	47	22.00
771	22	47	23.00
772	22	47	24.00
773	22	47	25.00
774	22	47	26.00
775	22	47	27.00
776	22	47	27.00
777	22	47	28.00
778	22	47	29.00
779	22	47	29.00
780	22	47	30.00
781	22	47	31.00
782	22	47	31.00
783	22	47	32.00
784	20	41	15.00
785	20	41	16.00
786	20	41	17.00
787	20	41	18.00
788	20	41	20.00
789	20	41	21.00
790	20	41	22.00
791	20	41	23.00
792	20	41	24.00
793	20	41	25.00
794	20	41	26.00
795	20	41	27.00
796	20	41	28.00
797	18	42	36.00
798	26	30	44.00
799	26	30	44.00
800	26	30	45.00
801	21	35	40.00
802	21	35	60.00
803	21	35	77.00
804	21	35	91.00
805	21	35	104.00
806	21	35	116.00
807	21	35	127.00
808	21	35	137.00
809	21	35	147.00
810	21	35	157.00
811	21	35	166.00
812	21	35	174.00
813	21	35	183.00
814	21	35	191.00
815	21	35	199.00
816	21	35	207.00
817	21	35	214.00
818	21	35	222.00
819	21	35	229.00
820	21	35	236.00
821	21	35	243.00
822	21	35	250.00
823	21	35	256.00
824	21	35	263.00
825	21	35	269.00
826	21	35	276.00
827	21	35	282.00
828	21	35	288.00
829	21	35	294.00
830	21	35	300.00
831	22	34	20.00
832	22	34	20.00
833	22	34	20.00
834	22	34	20.00
835	22	34	25.00
836	22	34	25.00
837	22	34	25.00
838	22	34	25.00
839	22	34	25.00
840	22	34	30.00
841	22	34	30.00
842	22	34	30.00
843	22	34	30.00
844	22	34	30.00
845	22	34	35.00
846	22	34	35.00
847	22	34	35.00
848	22	34	35.00
849	22	34	35.00
850	22	34	40.00
851	22	34	40.00
852	22	34	40.00
853	22	34	40.00
854	22	34	40.00
855	22	34	45.00
856	22	34	45.00
857	22	34	45.00
858	22	34	45.00
859	22	34	45.00
860	22	34	50.00
861	7	5	12.00
862	7	5	15.00
863	7	5	17.00
864	10	20	6.00
865	10	20	8.00
866	10	20	8.00
867	19	3	94.00
868	9	7	13.00
869	9	7	14.00
870	9	7	14.00
871	9	7	14.00
872	9	7	15.00
873	9	7	15.00
874	9	7	15.00
875	9	7	16.00
876	9	7	16.00
877	9	7	16.00
878	9	7	17.00
879	9	7	17.00
880	9	7	17.00
881	9	7	17.00
882	9	7	18.00
883	23	36	20.00
884	23	36	23.00
885	23	36	25.00
886	23	36	27.00
887	23	36	28.00
888	23	36	30.00
889	23	36	31.00
890	23	36	32.00
891	23	36	33.00
892	23	36	34.00
893	23	36	35.00
894	23	36	36.00
895	23	36	37.00
896	23	36	37.00
897	23	36	38.00
898	23	36	39.00
899	23	36	39.00
900	23	36	40.00
901	23	36	41.00
902	23	36	41.00
903	23	36	42.00
904	23	36	43.00
905	23	36	43.00
906	23	36	44.00
907	23	36	44.00
908	23	36	45.00
909	23	36	45.00
910	23	36	46.00
911	23	36	46.00
912	23	36	47.00
913	14	17	5.00
914	14	17	5.00
915	14	17	6.00
916	14	17	6.00
917	14	17	6.00
918	14	17	6.00
919	14	17	7.00
920	14	17	7.00
921	10	1	1.00
922	10	1	1.00
923	10	1	1.00
924	10	1	1.00
925	10	1	1.00
926	10	1	1.00
927	10	1	1.00
928	10	1	1.00
929	10	1	1.00
930	10	1	2.00
931	10	1	2.00
932	10	1	2.00
933	10	1	2.00
934	19	3	96.00
935	19	3	99.00
936	19	3	101.00
937	19	3	104.00
938	1	1	3.00
939	7	5	18.00
940	7	5	19.00
941	7	5	20.00
942	7	5	21.00
943	17	32	20.00
944	17	32	23.00
945	17	32	25.00
946	17	32	27.00
947	17	32	28.00
948	17	32	30.00
949	17	32	31.00
950	17	32	32.00
951	17	32	33.00
952	17	32	34.00
953	17	32	35.00
954	17	32	36.00
955	17	32	37.00
956	17	32	37.00
957	17	32	38.00
958	17	32	39.00
959	17	32	39.00
960	17	32	40.00
961	17	32	41.00
962	17	32	41.00
963	17	32	42.00
964	17	32	43.00
965	17	32	43.00
966	17	32	44.00
967	17	32	44.00
968	17	32	45.00
969	17	32	45.00
970	11	4	9.00
971	17	32	46.00
972	17	32	46.00
973	17	32	47.00
974	11	4	10.00
975	6	19	420.00
976	6	19	450.00
977	6	19	480.00
978	6	19	510.00
979	15	6	180.00
980	15	6	190.00
981	15	6	200.00
982	15	6	210.00
983	15	6	220.00
984	15	6	230.00
985	15	6	240.00
986	15	6	250.00
987	15	6	260.00
988	15	6	270.00
989	15	6	280.00
990	15	6	300.00
991	15	6	310.00
992	15	6	320.00
993	15	6	330.00
994	15	6	340.00
995	15	6	350.00
996	15	6	360.00
997	15	6	370.00
998	15	6	380.00
999	15	6	390.00
1000	10	20	18.00
1001	23	20	6.00
1002	23	20	6.00
1003	23	20	6.00
1004	9	49	20.00
1005	9	49	23.00
1006	9	49	25.00
1007	9	49	27.00
1008	9	49	28.00
1009	9	49	30.00
1010	9	49	31.00
1011	9	49	32.00
1012	9	49	33.00
1013	23	20	7.00
1014	23	20	7.00
1015	23	20	7.00
1016	23	20	7.00
1017	23	20	8.00
1018	9	49	41.00
1019	9	49	42.00
1020	9	49	43.00
1021	9	49	43.00
1022	9	49	44.00
1023	9	49	44.00
1024	9	49	45.00
1025	9	49	45.00
1026	9	49	46.00
1027	9	49	46.00
1028	9	49	47.00
1029	15	21	10.00
1030	15	21	13.00
1031	15	21	15.00
1032	15	21	17.00
1033	15	21	18.00
1034	15	21	20.00
1035	15	21	21.00
1036	15	21	22.00
1037	15	21	23.00
1038	15	21	24.00
1039	15	21	25.00
1040	15	21	26.00
1041	9	49	34.00
1042	9	49	35.00
1043	9	49	36.00
1044	9	49	37.00
1045	9	49	37.00
1046	9	49	38.00
1047	9	49	39.00
1048	9	49	39.00
1049	9	49	40.00
1050	15	21	27.00
1051	15	21	27.00
1052	15	21	28.00
1053	15	21	29.00
1054	15	21	29.00
1055	15	21	30.00
1056	15	21	31.00
1057	15	21	31.00
1058	15	21	32.00
1059	15	21	33.00
1060	15	21	33.00
1061	15	21	34.00
1062	15	21	34.00
1063	15	21	35.00
1064	15	21	35.00
1065	15	21	36.00
1066	15	21	36.00
1067	15	21	37.00
1068	19	3	72.00
1069	19	3	75.00
1070	19	3	79.00
1071	19	3	82.00
1072	19	3	85.00
1073	19	3	88.00
1074	19	3	91.00
1075	1	1	1.00
1076	1	1	1.00
1077	1	1	1.00
1078	1	1	1.00
1079	1	1	1.00
1080	1	1	1.00
1081	1	1	1.00
1082	1	1	1.00
1083	1	1	2.00
1084	1	1	2.00
1085	1	1	2.00
1086	1	1	2.00
1087	1	1	2.00
1088	1	1	2.00
1089	1	1	2.00
1090	1	1	2.00
1091	1	1	2.00
1092	1	1	2.00
1093	1	1	3.00
1094	23	20	8.00
1095	23	20	8.00
1096	6	28	40.00
1097	6	28	40.00
1098	6	28	40.00
1099	6	28	40.00
1100	6	28	35.00
1101	6	28	25.00
1102	6	28	25.00
1103	6	28	25.00
1104	6	28	25.00
1105	6	28	25.00
1106	6	28	25.00
1107	6	28	25.00
1108	6	28	25.00
1109	6	28	25.00
1110	6	28	25.00
1111	6	28	25.00
1112	6	28	25.00
1113	6	28	25.00
1114	6	28	35.00
1115	6	28	35.00
1116	6	28	35.00
1117	6	28	35.00
1118	6	28	30.00
1119	6	28	30.00
1120	6	28	26.00
1121	6	28	25.00
1122	6	28	25.00
1123	6	28	25.00
1124	6	28	25.00
1125	6	28	25.00
1126	18	42	10.00
1127	18	42	13.00
1128	18	42	15.00
1129	18	42	17.00
1130	18	42	18.00
1131	18	42	20.00
1132	18	42	21.00
1133	18	42	22.00
1134	18	42	23.00
1135	18	42	24.00
1136	18	42	25.00
1137	18	42	26.00
1138	18	42	27.00
1139	18	42	27.00
1140	18	42	28.00
1141	18	42	29.00
1142	18	42	29.00
1143	18	42	30.00
1144	18	42	31.00
1145	18	42	31.00
1146	18	42	32.00
1147	18	42	33.00
1148	18	42	33.00
1149	18	42	34.00
1150	18	42	34.00
1151	18	42	35.00
1152	18	42	35.00
1153	18	42	36.00
1154	18	42	37.00
1155	1	1	3.00
1156	1	1	3.00
1157	1	1	3.00
1158	1	1	3.00
1159	1	1	3.00
1160	7	31	1.00
1161	7	31	1.00
1162	7	31	1.00
1163	7	31	1.00
1164	7	31	1.00
1165	7	31	1.00
1166	7	31	1.00
1167	7	31	1.00
1168	7	31	1.00
1169	7	31	2.00
1170	7	31	2.00
1171	1	1	3.00
1172	1	1	3.00
1173	1	1	3.00
1174	8	2	300.00
1175	8	2	310.00
1176	8	2	320.00
1177	8	2	330.00
1178	8	2	340.00
1179	8	2	350.00
1180	8	2	360.00
1181	8	2	370.00
1182	8	2	380.00
1183	7	31	2.00
1184	7	31	2.00
1185	7	31	2.00
1186	7	31	2.00
1187	7	31	2.00
1188	7	31	2.00
1189	7	31	2.00
1190	7	31	2.00
1191	7	31	3.00
1192	7	31	3.00
1193	7	31	3.00
1194	7	31	3.00
1195	7	31	3.00
1196	7	31	3.00
1197	7	31	3.00
1198	7	31	3.00
1199	7	31	3.00
1200	7	31	3.00
1201	7	31	4.00
1202	15	6	290.00
1203	23	20	8.00
1204	23	20	9.00
1205	23	20	9.00
1206	23	20	9.00
1207	23	20	9.00
1208	23	20	9.00
1209	23	20	9.00
1210	23	20	9.00
1211	23	20	9.00
1212	23	20	10.00
1213	23	20	10.00
1214	23	20	10.00
1215	23	20	10.00
1216	23	20	10.00
1217	23	20	10.00
1218	23	20	10.00
1219	23	20	10.00
1220	17	12	3.00
1221	17	12	3.00
1222	17	12	4.00
1223	17	12	4.00
1224	17	12	5.00
1225	17	12	5.00
1226	17	12	5.00
1227	17	12	5.00
1228	9	7	18.00
1229	9	7	18.00
1230	9	7	18.00
1231	11	4	5.00
1232	11	4	6.00
1233	11	4	8.00
1234	11	4	8.00
1235	14	43	20.00
1236	14	43	23.00
1237	14	43	25.00
1238	14	43	27.00
1239	14	43	28.00
1240	14	43	30.00
1241	14	43	31.00
1242	14	43	32.00
1243	14	43	33.00
1244	14	43	34.00
1245	14	43	35.00
1246	14	43	36.00
1247	14	43	37.00
1248	14	43	37.00
1249	14	43	38.00
1250	14	43	39.00
1251	14	43	39.00
1252	14	43	40.00
1253	14	43	41.00
1254	14	43	41.00
1255	14	43	42.00
1256	14	43	43.00
1257	14	43	43.00
1258	14	43	44.00
1259	14	43	44.00
1260	14	43	45.00
1261	14	43	45.00
1262	14	43	46.00
1263	14	43	46.00
1264	14	43	47.00
1265	7	5	22.00
1266	7	5	23.00
1267	7	5	24.00
1268	7	5	25.00
1269	7	5	26.00
1270	7	5	27.00
1271	7	5	28.00
1272	7	5	29.00
1273	7	5	30.00
1274	7	5	31.00
1275	7	5	32.00
1276	7	5	33.00
1277	7	5	34.00
1278	7	5	35.00
1279	7	5	36.00
1280	7	5	37.00
1281	7	5	38.00
1282	7	5	39.00
1283	7	5	40.00
1284	7	5	41.00
1285	7	5	42.00
1286	15	6	100.00
1287	15	6	110.00
1288	12	40	5.00
1289	12	40	11.00
1290	12	40	15.00
1291	12	40	17.00
1292	12	40	19.00
1293	12	40	21.00
1294	12	40	22.00
1295	12	40	24.00
1296	12	40	25.00
1297	12	40	26.00
1298	12	40	28.00
1299	12	40	29.00
1300	12	40	30.00
1301	12	40	31.00
1302	12	40	33.00
1303	12	40	34.00
1304	12	40	35.00
1305	12	40	37.00
1306	12	40	38.00
1307	12	40	39.00
1308	12	40	41.00
1309	12	40	41.00
1310	12	40	41.00
1311	12	40	42.00
1312	12	40	42.00
1313	12	40	43.00
1314	12	40	43.00
1315	12	40	44.00
1316	12	40	44.00
1317	15	6	120.00
1318	15	6	130.00
1319	15	6	140.00
1320	15	6	150.00
1321	15	6	160.00
1322	15	6	170.00
1323	23	20	5.00
1324	23	20	8.00
1325	5	10	7.00
1326	5	10	8.00
1327	5	10	9.00
1328	5	10	10.00
1329	5	10	11.00
1330	5	10	12.00
1331	5	10	12.00
1332	5	10	13.00
1333	12	40	45.00
1334	8	27	10.00
1335	8	27	13.00
1336	8	27	15.00
1337	8	27	17.00
1338	8	27	18.00
1339	8	27	20.00
1340	8	27	21.00
1341	8	27	22.00
1342	8	27	23.00
1343	8	27	24.00
1344	8	27	25.00
1345	8	27	26.00
1346	8	27	27.00
1347	8	27	27.00
1348	8	27	28.00
1349	8	27	29.00
1350	8	27	29.00
1351	8	27	30.00
1352	8	27	31.00
1353	8	27	31.00
1354	8	27	32.00
1355	8	27	33.00
1356	8	27	33.00
1357	8	27	34.00
1358	8	27	34.00
1359	8	27	35.00
1360	8	27	35.00
1361	8	27	36.00
1362	8	27	36.00
1363	8	27	37.00
1364	19	44	5.00
1365	19	44	11.00
1366	19	44	15.00
1367	19	44	17.00
1368	19	44	19.00
1369	19	44	21.00
1370	19	44	22.00
1371	19	44	24.00
1372	19	44	25.00
1373	19	44	26.00
1374	19	44	28.00
1375	19	44	29.00
1376	19	44	30.00
1377	19	44	31.00
1378	19	44	33.00
1379	19	44	34.00
1380	19	44	35.00
1381	19	44	37.00
1382	19	44	38.00
1383	19	44	39.00
1384	19	44	41.00
1385	19	44	41.00
1386	19	44	41.00
1387	19	44	42.00
1388	19	44	42.00
1389	19	44	44.00
1390	19	44	45.00
1391	13	46	25.00
1392	13	46	25.00
1393	13	46	25.00
1394	13	46	25.00
1395	11	39	2.00
1396	11	39	2.00
1397	11	39	2.00
1398	11	39	2.00
1399	11	39	2.00
1400	11	39	2.00
1401	11	39	2.00
1402	11	39	2.00
1403	11	39	2.00
1404	11	39	2.00
1405	11	39	2.00
1406	11	39	2.00
1407	11	39	2.00
1408	11	39	2.00
1409	11	39	3.00
1410	5	10	14.00
1411	5	10	14.00
1412	5	10	14.00
1413	5	10	15.00
1414	5	10	15.00
1415	8	2	100.00
1416	8	2	110.00
1417	8	2	120.00
1418	8	2	130.00
1419	8	2	140.00
1420	8	2	150.00
1421	8	2	160.00
1422	8	2	170.00
1423	8	2	180.00
1424	8	2	190.00
1425	8	2	200.00
1426	8	2	210.00
1427	13	13	8.00
1428	13	13	8.00
1429	13	13	8.00
1430	13	13	8.00
1431	13	13	8.00
1432	13	13	8.00
1433	13	13	8.00
1434	13	13	9.00
1435	13	46	40.00
1436	13	46	40.00
1437	13	46	40.00
1438	13	46	40.00
1439	13	46	35.00
1440	13	46	35.00
1441	13	46	35.00
1442	13	46	35.00
1443	13	46	35.00
1444	13	46	30.00
1445	13	13	9.00
1446	13	13	9.00
1447	13	13	9.00
1448	13	13	9.00
1449	13	13	9.00
1450	8	2	220.00
1451	10	20	5.00
1452	4	15	8.00
1453	4	15	8.00
1454	4	15	9.00
1455	4	15	10.00
1456	4	15	10.00
1457	4	15	11.00
1458	4	15	11.00
1459	4	15	12.00
1460	4	15	12.00
1461	4	15	13.00
1462	4	15	13.00
1463	4	15	14.00
1464	4	15	14.00
1465	4	15	14.00
1466	4	15	15.00
1467	4	15	15.00
1468	4	15	15.00
1469	4	15	16.00
1470	4	15	16.00
1471	4	15	16.00
1472	4	15	17.00
1473	4	15	17.00
1474	4	15	17.00
1475	4	15	17.00
1476	4	15	18.00
1477	4	15	18.00
1478	4	15	18.00
1479	4	15	18.00
1480	13	13	3.00
1481	13	13	3.00
1482	13	13	4.00
1483	13	13	4.00
1484	13	13	5.00
1485	13	13	5.00
1486	13	13	5.00
1487	13	46	25.00
1488	13	46	25.00
1489	13	46	25.00
1490	13	46	25.00
1491	13	46	25.00
1492	13	46	25.00
1493	13	46	25.00
1494	13	46	25.00
1495	13	46	25.00
1496	13	46	25.00
1497	13	46	25.00
1498	13	46	25.00
1499	19	44	43.00
1500	19	44	44.00
44	2	8	10.00
45	2	8	13.00
46	2	8	15.00
47	2	8	17.00
48	2	8	18.00
49	2	8	20.00
50	2	8	21.00
51	2	8	22.00
52	2	8	23.00
53	2	8	24.00
54	2	8	25.00
55	2	8	26.00
56	2	8	27.00
57	2	8	27.00
58	2	8	28.00
59	2	8	29.00
60	2	8	29.00
61	2	8	30.00
62	2	8	31.00
63	2	8	31.00
64	2	8	32.00
65	2	8	33.00
66	2	8	33.00
67	2	8	34.00
68	2	8	34.00
69	2	8	35.00
70	2	8	35.00
71	2	8	36.00
72	2	8	36.00
73	2	8	8.00
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
5	Pharos van Alexandrie	Lighthouse of Alexandria	f	4	7	4	10	15.00
16	Chinese muur	Great Wall	t	2	7	2	1	1.00
1	Stonehenge	Stonehenge	f	6	7	7	1	1.00
20	Scheve toren van Pisa	Leaning Tower of Pisa	f	3	7	3	9	2.50
10	Aboe Simbel	Abu Simbel	t	5	\N	6	1	1.00
26	Cité van Carcassonne	Cité de Carcassonne	f	2	5	\N	\N	\N
\.


--
-- Name: bonus_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bonus_type_id_seq', 49, true);


--
-- Name: user_bonus_preferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_bonus_preferences_id_seq', 47, true);


--
-- Name: user_wonders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_wonders_id_seq', 26, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: wonder_level_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wonder_level_stats_id_seq', 1500, true);


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
-- Name: user_bonus_preferences user_bonus_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_bonus_preferences
    ADD CONSTRAINT user_bonus_preferences_pkey PRIMARY KEY (id);


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
-- Name: wonder_level_stats wonder_level_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonder_level_stats
    ADD CONSTRAINT wonder_level_stats_pkey PRIMARY KEY (id);


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
-- Name: user_bonus_preferences user_bonus_preferences_bonus_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_bonus_preferences
    ADD CONSTRAINT user_bonus_preferences_bonus_type_id_fkey FOREIGN KEY (bonus_type_id) REFERENCES public.bonus_type(id);


--
-- Name: user_bonus_preferences user_bonus_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_bonus_preferences
    ADD CONSTRAINT user_bonus_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


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
-- Name: wonder_level_stats wonder_level_stats_bonus_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonder_level_stats
    ADD CONSTRAINT wonder_level_stats_bonus_type_id_fkey FOREIGN KEY (bonus_type_id) REFERENCES public.bonus_type(id);


--
-- Name: wonder_level_stats wonder_level_stats_wonder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wonder_level_stats
    ADD CONSTRAINT wonder_level_stats_wonder_id_fkey FOREIGN KEY (wonder_id) REFERENCES public.wonders(id);


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

