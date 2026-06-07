--
-- PostgreSQL database dump
--

\restrict t30EeIcC8P5U1A22HVTD26iTOWbNMPgfp52IDZ6H5se6gl4sMbNavxrCJ0Aweqh

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

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
-- Name: activities; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    user_id character varying,
    activity_type character varying,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    duration_minutes integer,
    steps integer,
    distance_meters double precision,
    calories double precision,
    avg_heart_rate integer,
    max_heart_rate integer,
    intensity_level character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.activities OWNER TO healthsync_user;

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activities_id_seq OWNER TO healthsync_user;

--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: health_tips; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.health_tips (
    id integer NOT NULL,
    category character varying(50) NOT NULL,
    condition_type character varying(10) NOT NULL,
    threshold_low numeric,
    threshold_high numeric,
    severity character varying(10) DEFAULT 'info'::character varying NOT NULL,
    tip text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.health_tips OWNER TO healthsync_user;

--
-- Name: health_tips_id_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.health_tips_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.health_tips_id_seq OWNER TO healthsync_user;

--
-- Name: health_tips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.health_tips_id_seq OWNED BY public.health_tips.id;


--
-- Name: heart_rate_records; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.heart_rate_records (
    id integer NOT NULL,
    user_id character varying,
    measured_at timestamp without time zone,
    bpm integer,
    resting boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.heart_rate_records OWNER TO healthsync_user;

--
-- Name: heart_rate_records_id_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.heart_rate_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heart_rate_records_id_seq OWNER TO healthsync_user;

--
-- Name: heart_rate_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.heart_rate_records_id_seq OWNED BY public.heart_rate_records.id;


--
-- Name: oxygen_saturation; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.oxygen_saturation (
    id integer NOT NULL,
    user_id character varying,
    measured_at timestamp without time zone,
    spo2_percent integer,
    created_at timestamp without time zone
);


ALTER TABLE public.oxygen_saturation OWNER TO healthsync_user;

--
-- Name: oxygen_saturation_id_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.oxygen_saturation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.oxygen_saturation_id_seq OWNER TO healthsync_user;

--
-- Name: oxygen_saturation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.oxygen_saturation_id_seq OWNED BY public.oxygen_saturation.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.password_reset_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token character varying(128) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    used boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.password_reset_tokens OWNER TO healthsync_user;

--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.password_reset_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.password_reset_tokens_id_seq OWNER TO healthsync_user;

--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.password_reset_tokens_id_seq OWNED BY public.password_reset_tokens.id;


--
-- Name: processed_drive_files; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.processed_drive_files (
    drive_file_id character varying NOT NULL,
    user_id character varying NOT NULL,
    file_name character varying,
    processed_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.processed_drive_files OWNER TO healthsync_user;

--
-- Name: sleep_sessions; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.sleep_sessions (
    id integer NOT NULL,
    user_id character varying,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    total_sleep_minutes integer,
    deep_minutes integer,
    light_minutes integer,
    rem_minutes integer,
    awake_minutes integer,
    sleep_quality_score integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.sleep_sessions OWNER TO healthsync_user;

--
-- Name: sleep_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.sleep_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sleep_sessions_id_seq OWNER TO healthsync_user;

--
-- Name: sleep_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.sleep_sessions_id_seq OWNED BY public.sleep_sessions.id;


--
-- Name: step_records; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.step_records (
    id integer NOT NULL,
    user_id character varying,
    recorded_at timestamp without time zone,
    steps integer,
    distance_meters double precision,
    calories double precision,
    walking_speed double precision,
    created_at timestamp without time zone
);


ALTER TABLE public.step_records OWNER TO healthsync_user;

--
-- Name: step_records_id_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.step_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.step_records_id_seq OWNER TO healthsync_user;

--
-- Name: step_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.step_records_id_seq OWNED BY public.step_records.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: healthsync_user
--

CREATE TABLE public.users (
    uid integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    password_hash character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO healthsync_user;

--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: healthsync_user
--

CREATE SEQUENCE public.users_uid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_uid_seq OWNER TO healthsync_user;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healthsync_user
--

ALTER SEQUENCE public.users_uid_seq OWNED BY public.users.uid;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: health_tips id; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.health_tips ALTER COLUMN id SET DEFAULT nextval('public.health_tips_id_seq'::regclass);


--
-- Name: heart_rate_records id; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.heart_rate_records ALTER COLUMN id SET DEFAULT nextval('public.heart_rate_records_id_seq'::regclass);


--
-- Name: oxygen_saturation id; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.oxygen_saturation ALTER COLUMN id SET DEFAULT nextval('public.oxygen_saturation_id_seq'::regclass);


--
-- Name: password_reset_tokens id; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.password_reset_tokens ALTER COLUMN id SET DEFAULT nextval('public.password_reset_tokens_id_seq'::regclass);


--
-- Name: sleep_sessions id; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.sleep_sessions ALTER COLUMN id SET DEFAULT nextval('public.sleep_sessions_id_seq'::regclass);


--
-- Name: step_records id; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.step_records ALTER COLUMN id SET DEFAULT nextval('public.step_records_id_seq'::regclass);


--
-- Name: users uid; Type: DEFAULT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.users ALTER COLUMN uid SET DEFAULT nextval('public.users_uid_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.activities (id, user_id, activity_type, start_time, end_time, duration_minutes, steps, distance_meters, calories, avg_heart_rate, max_heart_rate, intensity_level, created_at) FROM stdin;
1	alex.k.kaczmarczyk@gmail.com	training	2026-04-10 17:19:24	2026-04-10 18:41:48	82	\N	0	\N	\N	\N	\N	2026-04-30 12:10:19
2	alex.k.kaczmarczyk@gmail.com	walking	2026-04-15 20:04:00	2026-04-15 20:17:00	13	\N	990	\N	\N	\N	\N	2026-04-30 12:10:19
3	alex.k.kaczmarczyk@gmail.com	walking	2026-04-16 17:42:18	2026-04-16 17:54:00	11	\N	1005	\N	\N	\N	\N	2026-04-30 12:10:19
4	alex.k.kaczmarczyk@gmail.com	walking	2026-04-17 20:12:06	2026-04-17 20:23:00	10	\N	899	\N	\N	\N	\N	2026-04-30 12:10:19
5	alex.k.kaczmarczyk@gmail.com	training	2026-04-25 19:43:06	2026-04-25 21:14:32	91	\N	0	\N	\N	\N	\N	2026-04-30 12:10:19
6	alex.k.kaczmarczyk@gmail.com	training	2026-04-29 18:42:53	2026-04-29 20:12:58	90	\N	0	\N	\N	\N	\N	2026-04-30 12:10:19
31	alex.k.kaczmarczyk@gmail.com	training	2026-05-04 20:05:32	2026-05-04 21:42:17	96	\N	0	\N	\N	\N	\N	2026-05-06 23:11:14
\.


--
-- Data for Name: health_tips; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.health_tips (id, category, condition_type, threshold_low, threshold_high, severity, tip, created_at) FROM stdin;
1	steps	below	\N	3000	warning	You barely moved today. Even a 10-minute walk around the block makes a difference — try to hit at least 3 000 steps tomorrow.	2026-04-09 13:07:56.574512
2	steps	range	3000	6999	info	You're below the recommended daily target. Aim for 7 000–10 000 steps. Try taking the stairs or parking a bit further away.	2026-04-09 13:07:56.574512
3	steps	range	7000	9999	info	Good effort! You're close to the 10 000-step goal. A short evening walk would push you over the line.	2026-04-09 13:07:56.574512
4	steps	range	10000	14999	info	Great job hitting your daily step goal! Consistency is key — keep it up.	2026-04-09 13:07:56.574512
5	steps	range	15000	19999	info	Very active day! Make sure you're drinking enough water and stretching after all that movement.	2026-04-09 13:07:56.574512
6	steps	above	20000	\N	info	Outstanding activity level today! Prioritise recovery — good sleep and hydration help your body repair.	2026-04-09 13:07:56.574512
7	heart_rate	below	\N	50	warning	Your average heart rate is unusually low. If you're not a trained athlete and feel dizzy or tired, consider mentioning this to your doctor.	2026-04-09 13:07:56.576411
8	heart_rate	range	50	59	info	Your resting heart rate is on the lower side — often a sign of good cardiovascular fitness. Keep up the aerobic exercise.	2026-04-09 13:07:56.576411
9	heart_rate	range	60	79	info	Your heart rate is in the healthy range. Regular cardio exercise helps keep it there.	2026-04-09 13:07:56.576411
10	heart_rate	range	80	99	info	Your average heart rate is slightly elevated. Stress, caffeine, or dehydration can raise it. Try some deep breathing or a short walk.	2026-04-09 13:07:56.576411
11	heart_rate	range	100	109	warning	Your heart rate averaged above 100 BPM today. This could be due to stress, illness, or over-exertion. Rest well and stay hydrated.	2026-04-09 13:07:56.576411
12	heart_rate	above	110	\N	critical	Your heart rate was consistently very high today. If you weren't exercising intensely, this warrants attention — consider consulting a doctor.	2026-04-09 13:07:56.576411
13	sleep	below	\N	300	critical	You slept less than 5 hours. Chronic sleep deprivation harms memory, mood, and immune function. Try to get to bed earlier tonight.	2026-04-09 13:07:56.577797
14	sleep	range	300	359	warning	Under 6 hours of sleep isn't enough for most adults. Aim for 7–9 hours — even 30 extra minutes helps.	2026-04-09 13:07:56.577797
15	sleep	range	360	419	info	You're a little short on sleep. A consistent bedtime routine can help you fall asleep faster and sleep deeper.	2026-04-09 13:07:56.577797
16	sleep	range	420	540	info	Great sleep duration! Consistent 7–9 hours supports energy, focus, and physical recovery.	2026-04-09 13:07:56.577797
17	sleep	above	540	\N	info	You slept over 9 hours. Occasionally fine, but regularly sleeping this long can indicate fatigue or illness. Listen to your body.	2026-04-09 13:07:56.577797
18	oxygen	below	\N	90	critical	Your SpO2 dropped below 90%. This is a medical concern — if you feel short of breath or lightheaded, seek medical attention.	2026-04-09 13:07:56.579674
19	oxygen	range	90	94	warning	Your oxygen saturation is below the normal range. Avoid strenuous exercise and monitor how you feel. Consider speaking to a doctor.	2026-04-09 13:07:56.579674
20	oxygen	range	95	96	info	Your SpO2 is acceptable but on the lower side of normal. Deep breathing exercises can help improve oxygen delivery.	2026-04-09 13:07:56.579674
21	oxygen	range	97	100	info	Excellent oxygen saturation! Your respiratory and cardiovascular health looks good.	2026-04-09 13:07:56.579674
22	activity	below	\N	1	warning	No workouts recorded this week. Even one 20-minute session of walking, cycling, or stretching can improve your mood and energy.	2026-04-09 13:07:56.580958
23	activity	range	1	1	info	You got one workout in this week — good start! Try to add one more session to build a habit.	2026-04-09 13:07:56.580958
24	activity	range	2	3	info	You're meeting the minimum recommended exercise frequency. Adding a 4th session or increasing intensity would boost your fitness further.	2026-04-09 13:07:56.580958
25	activity	range	4	5	info	Very active week! Make sure you have at least one full rest day to let your muscles recover.	2026-04-09 13:07:56.580958
26	activity	above	6	\N	info	You've been exercising every day. Rest is part of training — one or two recovery days per week helps prevent injury and overtraining.	2026-04-09 13:07:56.580958
\.


--
-- Data for Name: heart_rate_records; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.heart_rate_records (id, user_id, measured_at, bpm, resting, created_at) FROM stdin;
1	alex.k.kaczmarczyk@gmail.com	2026-04-06 00:00:01	74	t	2026-04-30 12:10:19
80	alex.k.kaczmarczyk@gmail.com	2026-04-06 14:40:02	64	t	2026-04-30 12:10:19
81	alex.k.kaczmarczyk@gmail.com	2026-04-06 14:50:01	64	t	2026-04-30 12:10:19
82	alex.k.kaczmarczyk@gmail.com	2026-04-06 15:00:01	74	f	2026-04-30 12:10:19
83	alex.k.kaczmarczyk@gmail.com	2026-04-06 15:10:02	64	t	2026-04-30 12:10:19
84	alex.k.kaczmarczyk@gmail.com	2026-04-06 15:20:01	66	f	2026-04-30 12:10:19
85	alex.k.kaczmarczyk@gmail.com	2026-04-06 15:30:02	59	t	2026-04-30 12:10:19
86	alex.k.kaczmarczyk@gmail.com	2026-04-06 15:40:02	66	f	2026-04-30 12:10:19
87	alex.k.kaczmarczyk@gmail.com	2026-04-06 15:50:01	60	t	2026-04-30 12:10:19
88	alex.k.kaczmarczyk@gmail.com	2026-04-06 16:00:01	64	t	2026-04-30 12:10:19
89	alex.k.kaczmarczyk@gmail.com	2026-04-06 23:30:01	49	t	2026-04-30 12:10:19
90	alex.k.kaczmarczyk@gmail.com	2026-04-06 23:40:01	50	t	2026-04-30 12:10:19
91	alex.k.kaczmarczyk@gmail.com	2026-04-06 23:50:01	54	t	2026-04-30 12:10:19
92	alex.k.kaczmarczyk@gmail.com	2026-04-07 00:00:02	48	t	2026-04-30 12:10:19
93	alex.k.kaczmarczyk@gmail.com	2026-04-07 00:10:02	45	t	2026-04-30 12:10:19
94	alex.k.kaczmarczyk@gmail.com	2026-04-07 00:20:02	46	t	2026-04-30 12:10:19
95	alex.k.kaczmarczyk@gmail.com	2026-04-07 00:30:21	50	t	2026-04-30 12:10:19
96	alex.k.kaczmarczyk@gmail.com	2026-04-07 00:40:21	52	t	2026-04-30 12:10:19
97	alex.k.kaczmarczyk@gmail.com	2026-04-07 00:50:21	50	t	2026-04-30 12:10:19
98	alex.k.kaczmarczyk@gmail.com	2026-04-07 01:00:22	63	t	2026-04-30 12:10:19
99	alex.k.kaczmarczyk@gmail.com	2026-04-07 01:10:10	54	t	2026-04-30 12:10:19
100	alex.k.kaczmarczyk@gmail.com	2026-04-07 01:20:10	76	t	2026-04-30 12:10:19
101	alex.k.kaczmarczyk@gmail.com	2026-04-07 01:30:22	51	t	2026-04-30 12:10:19
102	alex.k.kaczmarczyk@gmail.com	2026-04-07 01:40:11	67	t	2026-04-30 12:10:19
103	alex.k.kaczmarczyk@gmail.com	2026-04-07 01:50:09	45	t	2026-04-30 12:10:19
104	alex.k.kaczmarczyk@gmail.com	2026-04-07 02:00:20	50	t	2026-04-30 12:10:19
105	alex.k.kaczmarczyk@gmail.com	2026-04-07 02:10:21	49	t	2026-04-30 12:10:19
106	alex.k.kaczmarczyk@gmail.com	2026-04-07 02:20:21	49	t	2026-04-30 12:10:19
107	alex.k.kaczmarczyk@gmail.com	2026-04-07 02:30:21	50	t	2026-04-30 12:10:19
108	alex.k.kaczmarczyk@gmail.com	2026-04-07 02:40:16	53	t	2026-04-30 12:10:19
109	alex.k.kaczmarczyk@gmail.com	2026-04-07 02:50:09	53	t	2026-04-30 12:10:19
110	alex.k.kaczmarczyk@gmail.com	2026-04-07 03:00:09	57	t	2026-04-30 12:10:19
111	alex.k.kaczmarczyk@gmail.com	2026-04-07 03:10:12	52	t	2026-04-30 12:10:19
112	alex.k.kaczmarczyk@gmail.com	2026-04-07 03:20:12	59	t	2026-04-30 12:10:19
113	alex.k.kaczmarczyk@gmail.com	2026-04-07 03:30:15	52	t	2026-04-30 12:10:19
114	alex.k.kaczmarczyk@gmail.com	2026-04-07 03:40:20	52	t	2026-04-30 12:10:19
115	alex.k.kaczmarczyk@gmail.com	2026-04-07 03:50:21	49	t	2026-04-30 12:10:19
116	alex.k.kaczmarczyk@gmail.com	2026-04-07 04:00:21	85	f	2026-04-30 12:10:19
117	alex.k.kaczmarczyk@gmail.com	2026-04-07 04:10:15	51	t	2026-04-30 12:10:19
118	alex.k.kaczmarczyk@gmail.com	2026-04-07 04:20:20	55	t	2026-04-30 12:10:19
119	alex.k.kaczmarczyk@gmail.com	2026-04-07 04:30:21	51	t	2026-04-30 12:10:19
120	alex.k.kaczmarczyk@gmail.com	2026-04-07 04:40:10	52	t	2026-04-30 12:10:19
121	alex.k.kaczmarczyk@gmail.com	2026-04-07 04:50:15	99	f	2026-04-30 12:10:19
122	alex.k.kaczmarczyk@gmail.com	2026-04-07 05:00:19	51	t	2026-04-30 12:10:19
123	alex.k.kaczmarczyk@gmail.com	2026-04-07 05:10:09	56	t	2026-04-30 12:10:19
124	alex.k.kaczmarczyk@gmail.com	2026-04-07 05:20:09	59	t	2026-04-30 12:10:19
125	alex.k.kaczmarczyk@gmail.com	2026-04-07 05:30:09	58	t	2026-04-30 12:10:19
126	alex.k.kaczmarczyk@gmail.com	2026-04-07 05:40:10	52	t	2026-04-30 12:10:19
127	alex.k.kaczmarczyk@gmail.com	2026-04-07 05:50:21	48	t	2026-04-30 12:10:19
128	alex.k.kaczmarczyk@gmail.com	2026-04-07 06:00:10	77	f	2026-04-30 12:10:19
129	alex.k.kaczmarczyk@gmail.com	2026-04-07 06:10:09	53	t	2026-04-30 12:10:19
130	alex.k.kaczmarczyk@gmail.com	2026-04-07 06:20:16	59	t	2026-04-30 12:10:19
131	alex.k.kaczmarczyk@gmail.com	2026-04-07 06:30:21	56	t	2026-04-30 12:10:19
132	alex.k.kaczmarczyk@gmail.com	2026-04-07 06:40:15	51	t	2026-04-30 12:10:19
133	alex.k.kaczmarczyk@gmail.com	2026-04-07 06:50:14	49	t	2026-04-30 12:10:19
134	alex.k.kaczmarczyk@gmail.com	2026-04-07 07:00:22	80	f	2026-04-30 12:10:19
135	alex.k.kaczmarczyk@gmail.com	2026-04-07 07:10:21	86	f	2026-04-30 12:10:19
136	alex.k.kaczmarczyk@gmail.com	2026-04-07 08:00:02	97	f	2026-04-30 12:10:19
137	alex.k.kaczmarczyk@gmail.com	2026-04-07 08:10:01	64	t	2026-04-30 12:10:19
138	alex.k.kaczmarczyk@gmail.com	2026-04-07 08:20:01	105	f	2026-04-30 12:10:19
139	alex.k.kaczmarczyk@gmail.com	2026-04-07 08:30:01	91	f	2026-04-30 12:10:19
140	alex.k.kaczmarczyk@gmail.com	2026-04-07 08:40:01	86	f	2026-04-30 12:10:19
141	alex.k.kaczmarczyk@gmail.com	2026-04-07 08:50:01	90	f	2026-04-30 12:10:19
142	alex.k.kaczmarczyk@gmail.com	2026-04-07 09:00:00	104	f	2026-04-30 12:10:19
143	alex.k.kaczmarczyk@gmail.com	2026-04-07 09:10:01	83	f	2026-04-30 12:10:19
144	alex.k.kaczmarczyk@gmail.com	2026-04-07 09:20:01	102	f	2026-04-30 12:10:19
145	alex.k.kaczmarczyk@gmail.com	2026-04-07 09:30:01	67	f	2026-04-30 12:10:19
146	alex.k.kaczmarczyk@gmail.com	2026-04-07 09:40:01	79	f	2026-04-30 12:10:19
147	alex.k.kaczmarczyk@gmail.com	2026-04-07 09:50:01	75	f	2026-04-30 12:10:19
148	alex.k.kaczmarczyk@gmail.com	2026-04-07 10:00:00	71	f	2026-04-30 12:10:19
149	alex.k.kaczmarczyk@gmail.com	2026-04-07 10:10:00	73	f	2026-04-30 12:10:19
150	alex.k.kaczmarczyk@gmail.com	2026-04-07 10:20:01	87	f	2026-04-30 12:10:19
151	alex.k.kaczmarczyk@gmail.com	2026-04-07 10:30:01	122	f	2026-04-30 12:10:19
152	alex.k.kaczmarczyk@gmail.com	2026-04-07 10:40:02	79	f	2026-04-30 12:10:19
153	alex.k.kaczmarczyk@gmail.com	2026-04-07 10:50:00	74	f	2026-04-30 12:10:19
154	alex.k.kaczmarczyk@gmail.com	2026-04-07 11:00:01	82	f	2026-04-30 12:10:19
155	alex.k.kaczmarczyk@gmail.com	2026-04-07 11:10:00	69	f	2026-04-30 12:10:19
156	alex.k.kaczmarczyk@gmail.com	2026-04-07 11:20:01	81	f	2026-04-30 12:10:19
157	alex.k.kaczmarczyk@gmail.com	2026-04-07 11:30:01	74	f	2026-04-30 12:10:19
158	alex.k.kaczmarczyk@gmail.com	2026-04-07 11:40:01	97	f	2026-04-30 12:10:19
159	alex.k.kaczmarczyk@gmail.com	2026-04-07 11:50:02	99	f	2026-04-30 12:10:19
160	alex.k.kaczmarczyk@gmail.com	2026-04-07 12:00:01	90	f	2026-04-30 12:10:19
161	alex.k.kaczmarczyk@gmail.com	2026-04-07 12:10:01	132	f	2026-04-30 12:10:19
162	alex.k.kaczmarczyk@gmail.com	2026-04-07 12:20:01	89	f	2026-04-30 12:10:19
163	alex.k.kaczmarczyk@gmail.com	2026-04-07 12:30:01	89	f	2026-04-30 12:10:19
164	alex.k.kaczmarczyk@gmail.com	2026-04-07 12:40:00	89	f	2026-04-30 12:10:19
165	alex.k.kaczmarczyk@gmail.com	2026-04-07 12:50:00	86	f	2026-04-30 12:10:19
166	alex.k.kaczmarczyk@gmail.com	2026-04-07 13:00:01	85	f	2026-04-30 12:10:19
2	alex.k.kaczmarczyk@gmail.com	2026-04-06 00:10:01	76	t	2026-04-30 12:10:19
167	alex.k.kaczmarczyk@gmail.com	2026-04-07 13:10:01	85	f	2026-04-30 12:10:19
168	alex.k.kaczmarczyk@gmail.com	2026-04-07 13:20:01	80	f	2026-04-30 12:10:19
169	alex.k.kaczmarczyk@gmail.com	2026-04-07 13:30:01	83	f	2026-04-30 12:10:19
170	alex.k.kaczmarczyk@gmail.com	2026-04-07 13:40:01	81	f	2026-04-30 12:10:19
171	alex.k.kaczmarczyk@gmail.com	2026-04-07 13:50:00	81	f	2026-04-30 12:10:19
172	alex.k.kaczmarczyk@gmail.com	2026-04-07 14:00:00	84	f	2026-04-30 12:10:19
173	alex.k.kaczmarczyk@gmail.com	2026-04-07 14:10:00	70	f	2026-04-30 12:10:19
174	alex.k.kaczmarczyk@gmail.com	2026-04-07 14:20:01	79	f	2026-04-30 12:10:19
175	alex.k.kaczmarczyk@gmail.com	2026-04-07 14:30:01	71	f	2026-04-30 12:10:19
176	alex.k.kaczmarczyk@gmail.com	2026-04-07 14:40:01	112	f	2026-04-30 12:10:19
177	alex.k.kaczmarczyk@gmail.com	2026-04-07 14:50:01	95	f	2026-04-30 12:10:19
178	alex.k.kaczmarczyk@gmail.com	2026-04-07 15:00:00	87	f	2026-04-30 12:10:19
179	alex.k.kaczmarczyk@gmail.com	2026-04-07 15:10:01	103	f	2026-04-30 12:10:19
180	alex.k.kaczmarczyk@gmail.com	2026-04-07 15:20:00	75	f	2026-04-30 12:10:19
181	alex.k.kaczmarczyk@gmail.com	2026-04-07 15:30:01	75	f	2026-04-30 12:10:19
182	alex.k.kaczmarczyk@gmail.com	2026-04-07 15:40:01	78	f	2026-04-30 12:10:19
183	alex.k.kaczmarczyk@gmail.com	2026-04-07 15:50:00	101	f	2026-04-30 12:10:19
184	alex.k.kaczmarczyk@gmail.com	2026-04-07 16:00:00	100	f	2026-04-30 12:10:19
185	alex.k.kaczmarczyk@gmail.com	2026-04-07 16:10:01	84	f	2026-04-30 12:10:19
186	alex.k.kaczmarczyk@gmail.com	2026-04-07 16:20:01	89	f	2026-04-30 12:10:19
187	alex.k.kaczmarczyk@gmail.com	2026-04-07 16:30:01	87	f	2026-04-30 12:10:19
188	alex.k.kaczmarczyk@gmail.com	2026-04-07 16:40:01	77	f	2026-04-30 12:10:19
189	alex.k.kaczmarczyk@gmail.com	2026-04-07 16:50:01	84	f	2026-04-30 12:10:19
190	alex.k.kaczmarczyk@gmail.com	2026-04-07 17:00:00	82	f	2026-04-30 12:10:19
191	alex.k.kaczmarczyk@gmail.com	2026-04-07 17:10:01	62	t	2026-04-30 12:10:19
192	alex.k.kaczmarczyk@gmail.com	2026-04-07 17:20:01	64	t	2026-04-30 12:10:19
193	alex.k.kaczmarczyk@gmail.com	2026-04-07 17:30:01	93	f	2026-04-30 12:10:19
194	alex.k.kaczmarczyk@gmail.com	2026-04-07 17:40:02	70	f	2026-04-30 12:10:19
195	alex.k.kaczmarczyk@gmail.com	2026-04-07 17:50:01	65	f	2026-04-30 12:10:19
196	alex.k.kaczmarczyk@gmail.com	2026-04-07 18:00:01	66	f	2026-04-30 12:10:19
197	alex.k.kaczmarczyk@gmail.com	2026-04-07 18:10:01	72	f	2026-04-30 12:10:19
198	alex.k.kaczmarczyk@gmail.com	2026-04-07 18:20:01	72	f	2026-04-30 12:10:19
199	alex.k.kaczmarczyk@gmail.com	2026-04-07 18:30:01	69	f	2026-04-30 12:10:19
200	alex.k.kaczmarczyk@gmail.com	2026-04-07 18:40:01	62	t	2026-04-30 12:10:19
201	alex.k.kaczmarczyk@gmail.com	2026-04-07 18:50:02	66	f	2026-04-30 12:10:19
202	alex.k.kaczmarczyk@gmail.com	2026-04-07 19:00:01	70	f	2026-04-30 12:10:19
203	alex.k.kaczmarczyk@gmail.com	2026-04-07 19:10:00	101	f	2026-04-30 12:10:19
204	alex.k.kaczmarczyk@gmail.com	2026-04-07 20:10:01	72	f	2026-04-30 12:10:19
205	alex.k.kaczmarczyk@gmail.com	2026-04-07 20:20:01	61	t	2026-04-30 12:10:19
206	alex.k.kaczmarczyk@gmail.com	2026-04-07 20:30:02	63	t	2026-04-30 12:10:19
207	alex.k.kaczmarczyk@gmail.com	2026-04-07 20:40:02	99	f	2026-04-30 12:10:19
208	alex.k.kaczmarczyk@gmail.com	2026-04-07 20:50:01	67	f	2026-04-30 12:10:19
209	alex.k.kaczmarczyk@gmail.com	2026-04-07 21:00:01	87	f	2026-04-30 12:10:19
210	alex.k.kaczmarczyk@gmail.com	2026-04-07 21:10:01	76	f	2026-04-30 12:10:19
211	alex.k.kaczmarczyk@gmail.com	2026-04-08 23:10:01	83	f	2026-04-30 12:10:19
212	alex.k.kaczmarczyk@gmail.com	2026-04-08 23:20:02	57	t	2026-04-30 12:10:19
213	alex.k.kaczmarczyk@gmail.com	2026-04-08 23:30:01	60	t	2026-04-30 12:10:19
214	alex.k.kaczmarczyk@gmail.com	2026-04-08 23:40:08	60	t	2026-04-30 12:10:19
215	alex.k.kaczmarczyk@gmail.com	2026-04-08 23:50:09	57	t	2026-04-30 12:10:19
216	alex.k.kaczmarczyk@gmail.com	2026-04-09 00:00:09	60	t	2026-04-30 12:10:20
217	alex.k.kaczmarczyk@gmail.com	2026-04-09 00:10:09	77	t	2026-04-30 12:10:20
218	alex.k.kaczmarczyk@gmail.com	2026-04-09 00:20:09	68	t	2026-04-30 12:10:20
219	alex.k.kaczmarczyk@gmail.com	2026-04-09 00:30:10	59	t	2026-04-30 12:10:20
220	alex.k.kaczmarczyk@gmail.com	2026-04-09 00:40:10	59	t	2026-04-30 12:10:20
221	alex.k.kaczmarczyk@gmail.com	2026-04-09 00:50:13	56	t	2026-04-30 12:10:20
222	alex.k.kaczmarczyk@gmail.com	2026-04-09 01:00:09	63	t	2026-04-30 12:10:20
223	alex.k.kaczmarczyk@gmail.com	2026-04-09 01:10:13	55	t	2026-04-30 12:10:20
224	alex.k.kaczmarczyk@gmail.com	2026-04-09 01:20:09	56	t	2026-04-30 12:10:20
225	alex.k.kaczmarczyk@gmail.com	2026-04-09 01:30:15	61	t	2026-04-30 12:10:20
226	alex.k.kaczmarczyk@gmail.com	2026-04-09 01:40:21	104	f	2026-04-30 12:10:20
227	alex.k.kaczmarczyk@gmail.com	2026-04-09 01:50:11	70	t	2026-04-30 12:10:20
228	alex.k.kaczmarczyk@gmail.com	2026-04-09 02:00:11	67	t	2026-04-30 12:10:20
229	alex.k.kaczmarczyk@gmail.com	2026-04-09 02:10:09	60	t	2026-04-30 12:10:20
230	alex.k.kaczmarczyk@gmail.com	2026-04-09 02:20:10	53	t	2026-04-30 12:10:20
231	alex.k.kaczmarczyk@gmail.com	2026-04-09 02:30:11	56	t	2026-04-30 12:10:20
232	alex.k.kaczmarczyk@gmail.com	2026-04-09 02:40:21	56	t	2026-04-30 12:10:20
233	alex.k.kaczmarczyk@gmail.com	2026-04-09 02:50:09	56	t	2026-04-30 12:10:20
234	alex.k.kaczmarczyk@gmail.com	2026-04-09 03:00:09	56	t	2026-04-30 12:10:20
235	alex.k.kaczmarczyk@gmail.com	2026-04-09 03:10:09	58	t	2026-04-30 12:10:20
236	alex.k.kaczmarczyk@gmail.com	2026-04-09 03:20:11	57	t	2026-04-30 12:10:20
237	alex.k.kaczmarczyk@gmail.com	2026-04-09 03:30:09	67	t	2026-04-30 12:10:20
238	alex.k.kaczmarczyk@gmail.com	2026-04-09 03:40:09	53	t	2026-04-30 12:10:20
239	alex.k.kaczmarczyk@gmail.com	2026-04-09 03:50:10	59	t	2026-04-30 12:10:20
240	alex.k.kaczmarczyk@gmail.com	2026-04-09 04:00:10	58	t	2026-04-30 12:10:20
241	alex.k.kaczmarczyk@gmail.com	2026-04-09 04:10:10	58	t	2026-04-30 12:10:20
242	alex.k.kaczmarczyk@gmail.com	2026-04-09 04:20:12	56	t	2026-04-30 12:10:20
243	alex.k.kaczmarczyk@gmail.com	2026-04-09 04:30:13	53	t	2026-04-30 12:10:20
244	alex.k.kaczmarczyk@gmail.com	2026-04-09 04:40:22	65	t	2026-04-30 12:10:20
245	alex.k.kaczmarczyk@gmail.com	2026-04-09 04:50:13	52	t	2026-04-30 12:10:20
246	alex.k.kaczmarczyk@gmail.com	2026-04-09 05:00:21	102	f	2026-04-30 12:10:20
247	alex.k.kaczmarczyk@gmail.com	2026-04-09 05:10:09	52	t	2026-04-30 12:10:20
248	alex.k.kaczmarczyk@gmail.com	2026-04-09 05:20:13	53	t	2026-04-30 12:10:20
249	alex.k.kaczmarczyk@gmail.com	2026-04-09 05:30:13	72	t	2026-04-30 12:10:20
250	alex.k.kaczmarczyk@gmail.com	2026-04-09 05:40:17	52	t	2026-04-30 12:10:20
251	alex.k.kaczmarczyk@gmail.com	2026-04-09 06:10:01	53	t	2026-04-30 12:10:20
252	alex.k.kaczmarczyk@gmail.com	2026-04-09 06:20:01	86	f	2026-04-30 12:10:20
253	alex.k.kaczmarczyk@gmail.com	2026-04-09 06:30:02	60	t	2026-04-30 12:10:20
3	alex.k.kaczmarczyk@gmail.com	2026-04-06 00:20:01	73	t	2026-04-30 12:10:19
254	alex.k.kaczmarczyk@gmail.com	2026-04-09 06:40:02	58	t	2026-04-30 12:10:20
255	alex.k.kaczmarczyk@gmail.com	2026-04-09 06:50:01	57	t	2026-04-30 12:10:20
256	alex.k.kaczmarczyk@gmail.com	2026-04-09 07:00:01	78	f	2026-04-30 12:10:20
257	alex.k.kaczmarczyk@gmail.com	2026-04-09 07:10:01	85	f	2026-04-30 12:10:20
258	alex.k.kaczmarczyk@gmail.com	2026-04-09 07:20:01	117	f	2026-04-30 12:10:20
259	alex.k.kaczmarczyk@gmail.com	2026-04-09 07:30:01	82	f	2026-04-30 12:10:20
260	alex.k.kaczmarczyk@gmail.com	2026-04-09 07:40:01	82	f	2026-04-30 12:10:20
261	alex.k.kaczmarczyk@gmail.com	2026-04-09 07:50:01	63	t	2026-04-30 12:10:20
262	alex.k.kaczmarczyk@gmail.com	2026-04-09 08:00:01	88	f	2026-04-30 12:10:20
263	alex.k.kaczmarczyk@gmail.com	2026-04-09 08:10:01	71	f	2026-04-30 12:10:20
264	alex.k.kaczmarczyk@gmail.com	2026-04-09 08:20:01	72	f	2026-04-30 12:10:20
265	alex.k.kaczmarczyk@gmail.com	2026-04-09 08:30:02	68	f	2026-04-30 12:10:20
266	alex.k.kaczmarczyk@gmail.com	2026-04-09 08:40:02	70	f	2026-04-30 12:10:20
267	alex.k.kaczmarczyk@gmail.com	2026-04-09 08:50:02	63	t	2026-04-30 12:10:20
268	alex.k.kaczmarczyk@gmail.com	2026-04-09 09:00:01	65	f	2026-04-30 12:10:20
269	alex.k.kaczmarczyk@gmail.com	2026-04-09 09:10:01	97	f	2026-04-30 12:10:20
270	alex.k.kaczmarczyk@gmail.com	2026-04-09 09:20:01	90	f	2026-04-30 12:10:20
271	alex.k.kaczmarczyk@gmail.com	2026-04-09 09:30:02	91	f	2026-04-30 12:10:20
272	alex.k.kaczmarczyk@gmail.com	2026-04-09 09:40:02	74	f	2026-04-30 12:10:20
273	alex.k.kaczmarczyk@gmail.com	2026-04-09 09:50:01	73	f	2026-04-30 12:10:20
274	alex.k.kaczmarczyk@gmail.com	2026-04-09 10:00:01	79	f	2026-04-30 12:10:20
275	alex.k.kaczmarczyk@gmail.com	2026-04-09 10:10:01	63	t	2026-04-30 12:10:20
276	alex.k.kaczmarczyk@gmail.com	2026-04-09 10:20:02	66	f	2026-04-30 12:10:20
277	alex.k.kaczmarczyk@gmail.com	2026-04-09 10:30:02	80	f	2026-04-30 12:10:20
278	alex.k.kaczmarczyk@gmail.com	2026-04-09 10:40:01	70	f	2026-04-30 12:10:20
279	alex.k.kaczmarczyk@gmail.com	2026-04-09 10:50:01	84	f	2026-04-30 12:10:20
280	alex.k.kaczmarczyk@gmail.com	2026-04-09 11:00:01	75	f	2026-04-30 12:10:20
281	alex.k.kaczmarczyk@gmail.com	2026-04-09 11:10:01	69	f	2026-04-30 12:10:20
282	alex.k.kaczmarczyk@gmail.com	2026-04-09 11:20:02	106	f	2026-04-30 12:10:20
283	alex.k.kaczmarczyk@gmail.com	2026-04-09 11:30:02	70	f	2026-04-30 12:10:20
284	alex.k.kaczmarczyk@gmail.com	2026-04-09 11:40:01	77	f	2026-04-30 12:10:20
285	alex.k.kaczmarczyk@gmail.com	2026-04-09 11:50:01	89	f	2026-04-30 12:10:20
286	alex.k.kaczmarczyk@gmail.com	2026-04-09 12:00:01	87	f	2026-04-30 12:10:20
287	alex.k.kaczmarczyk@gmail.com	2026-04-09 12:10:01	95	f	2026-04-30 12:10:20
288	alex.k.kaczmarczyk@gmail.com	2026-04-09 12:20:02	89	f	2026-04-30 12:10:20
289	alex.k.kaczmarczyk@gmail.com	2026-04-09 12:30:01	72	f	2026-04-30 12:10:20
290	alex.k.kaczmarczyk@gmail.com	2026-04-09 12:40:02	84	f	2026-04-30 12:10:20
291	alex.k.kaczmarczyk@gmail.com	2026-04-09 12:50:02	79	f	2026-04-30 12:10:20
292	alex.k.kaczmarczyk@gmail.com	2026-04-09 13:00:01	95	f	2026-04-30 12:10:20
293	alex.k.kaczmarczyk@gmail.com	2026-04-09 13:10:02	86	f	2026-04-30 12:10:20
294	alex.k.kaczmarczyk@gmail.com	2026-04-09 13:20:02	80	f	2026-04-30 12:10:20
295	alex.k.kaczmarczyk@gmail.com	2026-04-09 13:30:02	77	f	2026-04-30 12:10:20
296	alex.k.kaczmarczyk@gmail.com	2026-04-09 13:40:01	95	f	2026-04-30 12:10:20
297	alex.k.kaczmarczyk@gmail.com	2026-04-09 13:50:01	73	f	2026-04-30 12:10:20
298	alex.k.kaczmarczyk@gmail.com	2026-04-09 14:00:02	68	f	2026-04-30 12:10:20
299	alex.k.kaczmarczyk@gmail.com	2026-04-09 14:10:02	77	f	2026-04-30 12:10:20
300	alex.k.kaczmarczyk@gmail.com	2026-04-09 14:20:01	72	f	2026-04-30 12:10:20
301	alex.k.kaczmarczyk@gmail.com	2026-04-09 14:30:01	72	f	2026-04-30 12:10:20
302	alex.k.kaczmarczyk@gmail.com	2026-04-09 14:40:01	69	f	2026-04-30 12:10:20
303	alex.k.kaczmarczyk@gmail.com	2026-04-09 14:50:01	86	f	2026-04-30 12:10:20
304	alex.k.kaczmarczyk@gmail.com	2026-04-09 15:00:02	89	f	2026-04-30 12:10:20
305	alex.k.kaczmarczyk@gmail.com	2026-04-09 15:10:02	72	f	2026-04-30 12:10:20
306	alex.k.kaczmarczyk@gmail.com	2026-04-09 15:20:01	84	f	2026-04-30 12:10:20
307	alex.k.kaczmarczyk@gmail.com	2026-04-09 15:30:01	70	f	2026-04-30 12:10:20
308	alex.k.kaczmarczyk@gmail.com	2026-04-09 15:40:01	78	f	2026-04-30 12:10:20
309	alex.k.kaczmarczyk@gmail.com	2026-04-09 15:50:02	74	f	2026-04-30 12:10:20
310	alex.k.kaczmarczyk@gmail.com	2026-04-09 16:00:02	66	f	2026-04-30 12:10:20
311	alex.k.kaczmarczyk@gmail.com	2026-04-09 16:10:02	62	t	2026-04-30 12:10:20
312	alex.k.kaczmarczyk@gmail.com	2026-04-09 16:20:02	64	t	2026-04-30 12:10:20
313	alex.k.kaczmarczyk@gmail.com	2026-04-09 16:30:01	92	f	2026-04-30 12:10:20
314	alex.k.kaczmarczyk@gmail.com	2026-04-09 16:40:01	83	f	2026-04-30 12:10:20
315	alex.k.kaczmarczyk@gmail.com	2026-04-09 16:50:01	108	f	2026-04-30 12:10:20
316	alex.k.kaczmarczyk@gmail.com	2026-04-09 17:00:01	122	f	2026-04-30 12:10:20
317	alex.k.kaczmarczyk@gmail.com	2026-04-09 17:10:01	119	f	2026-04-30 12:10:20
318	alex.k.kaczmarczyk@gmail.com	2026-04-09 17:20:01	125	f	2026-04-30 12:10:20
319	alex.k.kaczmarczyk@gmail.com	2026-04-09 17:30:02	133	f	2026-04-30 12:10:20
320	alex.k.kaczmarczyk@gmail.com	2026-04-09 17:40:01	123	f	2026-04-30 12:10:20
321	alex.k.kaczmarczyk@gmail.com	2026-04-09 17:50:01	130	f	2026-04-30 12:10:20
322	alex.k.kaczmarczyk@gmail.com	2026-04-09 18:00:01	106	f	2026-04-30 12:10:20
323	alex.k.kaczmarczyk@gmail.com	2026-04-09 18:10:01	89	f	2026-04-30 12:10:20
324	alex.k.kaczmarczyk@gmail.com	2026-04-09 18:20:01	115	f	2026-04-30 12:10:20
325	alex.k.kaczmarczyk@gmail.com	2026-04-09 18:30:01	90	f	2026-04-30 12:10:20
326	alex.k.kaczmarczyk@gmail.com	2026-04-09 18:40:00	78	f	2026-04-30 12:10:20
327	alex.k.kaczmarczyk@gmail.com	2026-04-09 18:50:01	84	f	2026-04-30 12:10:20
328	alex.k.kaczmarczyk@gmail.com	2026-04-09 19:00:01	104	f	2026-04-30 12:10:20
329	alex.k.kaczmarczyk@gmail.com	2026-04-09 19:10:01	72	f	2026-04-30 12:10:20
330	alex.k.kaczmarczyk@gmail.com	2026-04-09 19:20:01	71	f	2026-04-30 12:10:20
331	alex.k.kaczmarczyk@gmail.com	2026-04-09 19:30:00	75	f	2026-04-30 12:10:20
332	alex.k.kaczmarczyk@gmail.com	2026-04-09 19:40:00	57	t	2026-04-30 12:10:20
333	alex.k.kaczmarczyk@gmail.com	2026-04-09 19:50:00	57	t	2026-04-30 12:10:20
334	alex.k.kaczmarczyk@gmail.com	2026-04-09 20:00:00	59	t	2026-04-30 12:10:20
335	alex.k.kaczmarczyk@gmail.com	2026-04-09 20:10:08	59	t	2026-04-30 12:10:20
336	alex.k.kaczmarczyk@gmail.com	2026-04-09 20:20:19	60	t	2026-04-30 12:10:20
337	alex.k.kaczmarczyk@gmail.com	2026-04-09 20:30:08	55	t	2026-04-30 12:10:20
338	alex.k.kaczmarczyk@gmail.com	2026-04-09 20:40:11	64	t	2026-04-30 12:10:20
339	alex.k.kaczmarczyk@gmail.com	2026-04-09 20:50:16	83	f	2026-04-30 12:10:20
340	alex.k.kaczmarczyk@gmail.com	2026-04-09 21:00:01	93	f	2026-04-30 12:10:20
4	alex.k.kaczmarczyk@gmail.com	2026-04-06 00:30:02	65	t	2026-04-30 12:10:19
341	alex.k.kaczmarczyk@gmail.com	2026-04-10 00:10:01	61	t	2026-04-30 12:10:20
342	alex.k.kaczmarczyk@gmail.com	2026-04-10 00:20:01	60	t	2026-04-30 12:10:20
343	alex.k.kaczmarczyk@gmail.com	2026-04-10 00:30:01	58	t	2026-04-30 12:10:20
344	alex.k.kaczmarczyk@gmail.com	2026-04-10 00:40:00	63	t	2026-04-30 12:10:20
345	alex.k.kaczmarczyk@gmail.com	2026-04-10 00:50:01	51	t	2026-04-30 12:10:20
346	alex.k.kaczmarczyk@gmail.com	2026-04-10 01:00:00	49	t	2026-04-30 12:10:20
347	alex.k.kaczmarczyk@gmail.com	2026-04-10 01:10:00	51	t	2026-04-30 12:10:20
348	alex.k.kaczmarczyk@gmail.com	2026-04-10 01:20:08	52	t	2026-04-30 12:10:20
349	alex.k.kaczmarczyk@gmail.com	2026-04-10 01:30:09	51	t	2026-04-30 12:10:20
350	alex.k.kaczmarczyk@gmail.com	2026-04-10 01:40:18	49	t	2026-04-30 12:10:20
351	alex.k.kaczmarczyk@gmail.com	2026-04-10 01:50:20	52	t	2026-04-30 12:10:20
352	alex.k.kaczmarczyk@gmail.com	2026-04-10 02:00:10	56	t	2026-04-30 12:10:20
353	alex.k.kaczmarczyk@gmail.com	2026-04-10 02:10:09	56	t	2026-04-30 12:10:20
354	alex.k.kaczmarczyk@gmail.com	2026-04-10 02:20:15	49	t	2026-04-30 12:10:20
355	alex.k.kaczmarczyk@gmail.com	2026-04-10 02:30:20	49	t	2026-04-30 12:10:20
356	alex.k.kaczmarczyk@gmail.com	2026-04-10 02:40:21	50	t	2026-04-30 12:10:20
357	alex.k.kaczmarczyk@gmail.com	2026-04-10 02:50:20	52	t	2026-04-30 12:10:20
358	alex.k.kaczmarczyk@gmail.com	2026-04-10 03:00:16	46	t	2026-04-30 12:10:20
359	alex.k.kaczmarczyk@gmail.com	2026-04-10 03:10:12	48	t	2026-04-30 12:10:20
360	alex.k.kaczmarczyk@gmail.com	2026-04-10 03:20:08	94	f	2026-04-30 12:10:20
361	alex.k.kaczmarczyk@gmail.com	2026-04-10 03:30:21	51	t	2026-04-30 12:10:20
362	alex.k.kaczmarczyk@gmail.com	2026-04-10 03:40:09	52	t	2026-04-30 12:10:20
363	alex.k.kaczmarczyk@gmail.com	2026-04-10 03:50:20	61	t	2026-04-30 12:10:20
364	alex.k.kaczmarczyk@gmail.com	2026-04-10 04:00:08	52	t	2026-04-30 12:10:20
365	alex.k.kaczmarczyk@gmail.com	2026-04-10 04:10:09	56	t	2026-04-30 12:10:20
366	alex.k.kaczmarczyk@gmail.com	2026-04-10 04:20:12	53	t	2026-04-30 12:10:20
367	alex.k.kaczmarczyk@gmail.com	2026-04-10 04:30:19	51	t	2026-04-30 12:10:20
368	alex.k.kaczmarczyk@gmail.com	2026-04-10 04:40:19	52	t	2026-04-30 12:10:20
369	alex.k.kaczmarczyk@gmail.com	2026-04-10 04:50:20	53	t	2026-04-30 12:10:20
370	alex.k.kaczmarczyk@gmail.com	2026-04-10 05:00:17	86	f	2026-04-30 12:10:20
371	alex.k.kaczmarczyk@gmail.com	2026-04-10 05:10:09	53	t	2026-04-30 12:10:20
372	alex.k.kaczmarczyk@gmail.com	2026-04-10 05:20:08	56	t	2026-04-30 12:10:20
373	alex.k.kaczmarczyk@gmail.com	2026-04-10 05:30:14	57	t	2026-04-30 12:10:20
374	alex.k.kaczmarczyk@gmail.com	2026-04-10 05:40:11	53	t	2026-04-30 12:10:20
375	alex.k.kaczmarczyk@gmail.com	2026-04-10 05:50:12	52	t	2026-04-30 12:10:20
376	alex.k.kaczmarczyk@gmail.com	2026-04-10 06:00:18	80	f	2026-04-30 12:10:20
377	alex.k.kaczmarczyk@gmail.com	2026-04-10 06:10:12	67	f	2026-04-30 12:10:20
378	alex.k.kaczmarczyk@gmail.com	2026-04-10 06:20:14	51	t	2026-04-30 12:10:20
379	alex.k.kaczmarczyk@gmail.com	2026-04-10 06:30:09	51	t	2026-04-30 12:10:20
380	alex.k.kaczmarczyk@gmail.com	2026-04-10 06:40:10	53	t	2026-04-30 12:10:20
381	alex.k.kaczmarczyk@gmail.com	2026-04-10 06:50:10	57	t	2026-04-30 12:10:20
382	alex.k.kaczmarczyk@gmail.com	2026-04-10 07:00:14	52	t	2026-04-30 12:10:20
383	alex.k.kaczmarczyk@gmail.com	2026-04-10 07:10:20	52	t	2026-04-30 12:10:20
384	alex.k.kaczmarczyk@gmail.com	2026-04-10 07:20:09	71	f	2026-04-30 12:10:20
385	alex.k.kaczmarczyk@gmail.com	2026-04-10 07:30:13	52	t	2026-04-30 12:10:20
386	alex.k.kaczmarczyk@gmail.com	2026-04-10 07:40:09	55	t	2026-04-30 12:10:20
387	alex.k.kaczmarczyk@gmail.com	2026-04-10 07:50:08	57	t	2026-04-30 12:10:20
388	alex.k.kaczmarczyk@gmail.com	2026-04-10 08:00:09	53	t	2026-04-30 12:10:20
389	alex.k.kaczmarczyk@gmail.com	2026-04-10 08:10:08	56	t	2026-04-30 12:10:20
390	alex.k.kaczmarczyk@gmail.com	2026-04-10 08:20:16	57	t	2026-04-30 12:10:20
391	alex.k.kaczmarczyk@gmail.com	2026-04-10 08:30:20	77	f	2026-04-30 12:10:20
392	alex.k.kaczmarczyk@gmail.com	2026-04-10 08:40:10	60	t	2026-04-30 12:10:20
393	alex.k.kaczmarczyk@gmail.com	2026-04-10 08:50:12	59	t	2026-04-30 12:10:20
394	alex.k.kaczmarczyk@gmail.com	2026-04-10 09:00:09	54	t	2026-04-30 12:10:20
395	alex.k.kaczmarczyk@gmail.com	2026-04-10 09:10:11	105	f	2026-04-30 12:10:20
396	alex.k.kaczmarczyk@gmail.com	2026-04-10 09:20:08	60	t	2026-04-30 12:10:20
397	alex.k.kaczmarczyk@gmail.com	2026-04-10 09:30:09	64	t	2026-04-30 12:10:20
398	alex.k.kaczmarczyk@gmail.com	2026-04-10 09:40:10	63	t	2026-04-30 12:10:20
399	alex.k.kaczmarczyk@gmail.com	2026-04-10 09:50:08	60	t	2026-04-30 12:10:20
400	alex.k.kaczmarczyk@gmail.com	2026-04-10 10:00:20	61	t	2026-04-30 12:10:20
401	alex.k.kaczmarczyk@gmail.com	2026-04-10 10:10:09	59	t	2026-04-30 12:10:20
402	alex.k.kaczmarczyk@gmail.com	2026-04-10 10:20:20	82	f	2026-04-30 12:10:20
403	alex.k.kaczmarczyk@gmail.com	2026-04-10 10:30:01	57	t	2026-04-30 12:10:20
404	alex.k.kaczmarczyk@gmail.com	2026-04-10 10:40:01	63	t	2026-04-30 12:10:20
405	alex.k.kaczmarczyk@gmail.com	2026-04-10 10:50:00	62	t	2026-04-30 12:10:20
406	alex.k.kaczmarczyk@gmail.com	2026-04-10 15:20:01	106	f	2026-04-30 12:10:20
407	alex.k.kaczmarczyk@gmail.com	2026-04-10 15:30:02	123	f	2026-04-30 12:10:20
408	alex.k.kaczmarczyk@gmail.com	2026-04-10 15:40:01	82	f	2026-04-30 12:10:20
409	alex.k.kaczmarczyk@gmail.com	2026-04-10 15:50:01	82	f	2026-04-30 12:10:20
410	alex.k.kaczmarczyk@gmail.com	2026-04-10 16:00:01	91	f	2026-04-30 12:10:20
411	alex.k.kaczmarczyk@gmail.com	2026-04-10 16:10:01	81	f	2026-04-30 12:10:20
412	alex.k.kaczmarczyk@gmail.com	2026-04-10 16:20:01	82	f	2026-04-30 12:10:20
413	alex.k.kaczmarczyk@gmail.com	2026-04-10 16:30:02	76	f	2026-04-30 12:10:20
414	alex.k.kaczmarczyk@gmail.com	2026-04-10 16:40:01	80	f	2026-04-30 12:10:20
415	alex.k.kaczmarczyk@gmail.com	2026-04-10 16:50:01	71	f	2026-04-30 12:10:20
416	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:00:01	83	f	2026-04-30 12:10:20
417	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:10:01	95	f	2026-04-30 12:10:20
418	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:19:00	89	f	2026-04-30 12:10:20
419	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:20:00	90	f	2026-04-30 12:10:20
420	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:22:00	101	f	2026-04-30 12:10:20
422	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:23:00	99	f	2026-04-30 12:10:20
423	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:24:00	92	f	2026-04-30 12:10:20
424	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:25:00	100	f	2026-04-30 12:10:20
425	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:26:00	106	f	2026-04-30 12:10:20
426	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:27:00	94	f	2026-04-30 12:10:20
427	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:28:00	90	f	2026-04-30 12:10:20
428	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:30:00	90	f	2026-04-30 12:10:20
5	alex.k.kaczmarczyk@gmail.com	2026-04-06 00:40:02	65	t	2026-04-30 12:10:19
429	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:31:00	109	f	2026-04-30 12:10:20
430	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:32:00	90	f	2026-04-30 12:10:20
431	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:33:00	90	f	2026-04-30 12:10:20
433	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:34:00	107	f	2026-04-30 12:10:20
434	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:35:00	96	f	2026-04-30 12:10:20
435	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:36:00	109	f	2026-04-30 12:10:20
436	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:37:00	127	f	2026-04-30 12:10:20
437	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:38:00	114	f	2026-04-30 12:10:20
438	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:39:00	112	f	2026-04-30 12:10:20
439	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:40:00	109	f	2026-04-30 12:10:20
440	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:41:00	118	f	2026-04-30 12:10:20
441	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:42:00	129	f	2026-04-30 12:10:20
442	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:43:00	113	f	2026-04-30 12:10:20
443	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:45:00	132	f	2026-04-30 12:10:20
445	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:46:00	133	f	2026-04-30 12:10:20
446	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:47:00	138	f	2026-04-30 12:10:20
447	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:48:00	127	f	2026-04-30 12:10:20
448	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:49:00	118	f	2026-04-30 12:10:20
449	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:50:00	146	f	2026-04-30 12:10:20
450	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:51:00	139	f	2026-04-30 12:10:20
451	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:52:00	121	f	2026-04-30 12:10:20
452	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:53:00	120	f	2026-04-30 12:10:20
453	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:55:00	118	f	2026-04-30 12:10:20
455	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:56:00	130	f	2026-04-30 12:10:20
456	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:57:00	125	f	2026-04-30 12:10:20
457	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:58:00	126	f	2026-04-30 12:10:20
458	alex.k.kaczmarczyk@gmail.com	2026-04-10 17:59:00	128	f	2026-04-30 12:10:20
459	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:00:00	115	f	2026-04-30 12:10:20
460	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:01:00	109	f	2026-04-30 12:10:20
461	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:02:00	109	f	2026-04-30 12:10:20
462	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:03:00	123	f	2026-04-30 12:10:20
463	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:05:00	116	f	2026-04-30 12:10:20
465	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:06:00	116	f	2026-04-30 12:10:20
466	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:07:00	113	f	2026-04-30 12:10:20
467	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:08:00	106	f	2026-04-30 12:10:20
468	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:10:00	106	f	2026-04-30 12:10:20
469	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:11:00	95	f	2026-04-30 12:10:20
471	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:12:00	96	f	2026-04-30 12:10:20
472	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:13:00	102	f	2026-04-30 12:10:20
473	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:14:00	103	f	2026-04-30 12:10:20
474	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:15:00	104	f	2026-04-30 12:10:20
475	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:16:00	102	f	2026-04-30 12:10:20
476	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:18:00	98	f	2026-04-30 12:10:20
477	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:19:00	128	f	2026-04-30 12:10:20
479	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:20:00	122	f	2026-04-30 12:10:20
480	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:21:00	115	f	2026-04-30 12:10:20
481	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:22:00	116	f	2026-04-30 12:10:20
482	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:23:00	117	f	2026-04-30 12:10:20
483	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:24:00	126	f	2026-04-30 12:10:20
484	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:26:00	115	f	2026-04-30 12:10:20
486	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:27:00	106	f	2026-04-30 12:10:20
487	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:28:00	120	f	2026-04-30 12:10:20
488	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:29:00	131	f	2026-04-30 12:10:20
489	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:30:00	134	f	2026-04-30 12:10:20
490	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:31:00	114	f	2026-04-30 12:10:20
491	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:32:00	107	f	2026-04-30 12:10:20
492	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:33:00	115	f	2026-04-30 12:10:20
493	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:34:00	117	f	2026-04-30 12:10:20
494	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:35:00	114	f	2026-04-30 12:10:20
495	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:36:00	125	f	2026-04-30 12:10:20
496	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:37:00	118	f	2026-04-30 12:10:20
497	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:38:00	113	f	2026-04-30 12:10:20
498	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:39:00	113	f	2026-04-30 12:10:20
499	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:40:00	104	f	2026-04-30 12:10:20
500	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:41:00	111	f	2026-04-30 12:10:20
502	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:41:51	119	f	2026-04-30 12:10:20
503	alex.k.kaczmarczyk@gmail.com	2026-04-10 18:50:01	104	f	2026-04-30 12:10:20
504	alex.k.kaczmarczyk@gmail.com	2026-04-10 19:00:01	87	f	2026-04-30 12:10:20
505	alex.k.kaczmarczyk@gmail.com	2026-04-10 19:10:01	86	f	2026-04-30 12:10:20
506	alex.k.kaczmarczyk@gmail.com	2026-04-10 19:20:02	78	f	2026-04-30 12:10:20
507	alex.k.kaczmarczyk@gmail.com	2026-04-10 19:30:01	75	f	2026-04-30 12:10:20
508	alex.k.kaczmarczyk@gmail.com	2026-04-10 19:40:01	69	f	2026-04-30 12:10:20
509	alex.k.kaczmarczyk@gmail.com	2026-04-10 19:50:01	71	f	2026-04-30 12:10:20
510	alex.k.kaczmarczyk@gmail.com	2026-04-10 20:00:01	69	f	2026-04-30 12:10:20
511	alex.k.kaczmarczyk@gmail.com	2026-04-10 20:10:00	87	f	2026-04-30 12:10:20
512	alex.k.kaczmarczyk@gmail.com	2026-04-10 20:20:01	93	f	2026-04-30 12:10:20
513	alex.k.kaczmarczyk@gmail.com	2026-04-10 20:30:01	80	f	2026-04-30 12:10:20
514	alex.k.kaczmarczyk@gmail.com	2026-04-10 20:40:01	109	f	2026-04-30 12:10:20
515	alex.k.kaczmarczyk@gmail.com	2026-04-10 20:50:00	67	f	2026-04-30 12:10:20
516	alex.k.kaczmarczyk@gmail.com	2026-04-10 21:00:01	81	f	2026-04-30 12:10:20
517	alex.k.kaczmarczyk@gmail.com	2026-04-10 21:10:00	62	t	2026-04-30 12:10:20
518	alex.k.kaczmarczyk@gmail.com	2026-04-10 21:20:01	66	f	2026-04-30 12:10:20
519	alex.k.kaczmarczyk@gmail.com	2026-04-10 21:30:01	68	f	2026-04-30 12:10:20
520	alex.k.kaczmarczyk@gmail.com	2026-04-10 21:40:00	65	f	2026-04-30 12:10:20
521	alex.k.kaczmarczyk@gmail.com	2026-04-10 21:50:01	67	f	2026-04-30 12:10:20
522	alex.k.kaczmarczyk@gmail.com	2026-04-10 22:00:01	76	f	2026-04-30 12:10:20
523	alex.k.kaczmarczyk@gmail.com	2026-04-10 22:10:01	69	f	2026-04-30 12:10:20
6	alex.k.kaczmarczyk@gmail.com	2026-04-06 01:00:01	67	t	2026-04-30 12:10:19
524	alex.k.kaczmarczyk@gmail.com	2026-04-10 22:20:00	69	f	2026-04-30 12:10:20
525	alex.k.kaczmarczyk@gmail.com	2026-04-10 22:30:01	69	f	2026-04-30 12:10:20
526	alex.k.kaczmarczyk@gmail.com	2026-04-11 03:30:01	82	f	2026-04-30 12:10:20
527	alex.k.kaczmarczyk@gmail.com	2026-04-11 03:40:01	63	t	2026-04-30 12:10:20
528	alex.k.kaczmarczyk@gmail.com	2026-04-11 03:50:01	54	t	2026-04-30 12:10:20
529	alex.k.kaczmarczyk@gmail.com	2026-04-11 04:00:01	54	t	2026-04-30 12:10:20
530	alex.k.kaczmarczyk@gmail.com	2026-04-11 04:10:01	49	t	2026-04-30 12:10:20
531	alex.k.kaczmarczyk@gmail.com	2026-04-11 04:20:01	50	t	2026-04-30 12:10:20
532	alex.k.kaczmarczyk@gmail.com	2026-04-11 04:30:01	49	t	2026-04-30 12:10:20
533	alex.k.kaczmarczyk@gmail.com	2026-04-11 04:40:01	52	t	2026-04-30 12:10:20
534	alex.k.kaczmarczyk@gmail.com	2026-04-11 04:50:01	54	t	2026-04-30 12:10:20
535	alex.k.kaczmarczyk@gmail.com	2026-04-11 05:00:02	53	t	2026-04-30 12:10:20
536	alex.k.kaczmarczyk@gmail.com	2026-04-11 05:10:01	52	t	2026-04-30 12:10:20
537	alex.k.kaczmarczyk@gmail.com	2026-04-11 05:20:01	73	t	2026-04-30 12:10:20
538	alex.k.kaczmarczyk@gmail.com	2026-04-11 05:30:01	50	t	2026-04-30 12:10:20
539	alex.k.kaczmarczyk@gmail.com	2026-04-11 05:40:01	48	t	2026-04-30 12:10:20
540	alex.k.kaczmarczyk@gmail.com	2026-04-11 05:50:01	47	t	2026-04-30 12:10:20
541	alex.k.kaczmarczyk@gmail.com	2026-04-11 06:00:01	48	t	2026-04-30 12:10:20
542	alex.k.kaczmarczyk@gmail.com	2026-04-11 06:10:01	49	t	2026-04-30 12:10:20
543	alex.k.kaczmarczyk@gmail.com	2026-04-11 06:20:01	57	t	2026-04-30 12:10:20
544	alex.k.kaczmarczyk@gmail.com	2026-04-11 06:30:01	58	t	2026-04-30 12:10:20
545	alex.k.kaczmarczyk@gmail.com	2026-04-11 06:40:01	51	t	2026-04-30 12:10:20
546	alex.k.kaczmarczyk@gmail.com	2026-04-11 06:50:01	64	t	2026-04-30 12:10:20
547	alex.k.kaczmarczyk@gmail.com	2026-04-11 07:00:01	59	t	2026-04-30 12:10:20
548	alex.k.kaczmarczyk@gmail.com	2026-04-11 07:10:01	54	t	2026-04-30 12:10:20
549	alex.k.kaczmarczyk@gmail.com	2026-04-11 07:20:01	93	f	2026-04-30 12:10:20
550	alex.k.kaczmarczyk@gmail.com	2026-04-11 07:30:01	78	f	2026-04-30 12:10:20
551	alex.k.kaczmarczyk@gmail.com	2026-04-11 07:40:01	66	f	2026-04-30 12:10:20
552	alex.k.kaczmarczyk@gmail.com	2026-04-11 07:50:01	64	t	2026-04-30 12:10:20
553	alex.k.kaczmarczyk@gmail.com	2026-04-11 08:00:00	57	t	2026-04-30 12:10:20
554	alex.k.kaczmarczyk@gmail.com	2026-04-11 08:10:00	60	t	2026-04-30 12:10:20
555	alex.k.kaczmarczyk@gmail.com	2026-04-11 08:20:01	84	f	2026-04-30 12:10:20
556	alex.k.kaczmarczyk@gmail.com	2026-04-11 08:30:01	63	t	2026-04-30 12:10:20
557	alex.k.kaczmarczyk@gmail.com	2026-04-11 08:40:01	63	t	2026-04-30 12:10:20
558	alex.k.kaczmarczyk@gmail.com	2026-04-11 08:50:01	61	t	2026-04-30 12:10:20
559	alex.k.kaczmarczyk@gmail.com	2026-04-11 09:00:01	57	t	2026-04-30 12:10:20
560	alex.k.kaczmarczyk@gmail.com	2026-04-11 09:10:02	91	f	2026-04-30 12:10:20
561	alex.k.kaczmarczyk@gmail.com	2026-04-11 09:50:01	96	f	2026-04-30 12:10:20
562	alex.k.kaczmarczyk@gmail.com	2026-04-11 10:00:01	79	f	2026-04-30 12:10:20
563	alex.k.kaczmarczyk@gmail.com	2026-04-11 10:10:01	71	f	2026-04-30 12:10:20
564	alex.k.kaczmarczyk@gmail.com	2026-04-11 10:20:01	62	t	2026-04-30 12:10:20
565	alex.k.kaczmarczyk@gmail.com	2026-04-11 10:30:01	88	f	2026-04-30 12:10:20
566	alex.k.kaczmarczyk@gmail.com	2026-04-11 10:40:01	73	f	2026-04-30 12:10:20
567	alex.k.kaczmarczyk@gmail.com	2026-04-11 10:50:01	70	f	2026-04-30 12:10:20
568	alex.k.kaczmarczyk@gmail.com	2026-04-11 11:00:02	62	t	2026-04-30 12:10:20
569	alex.k.kaczmarczyk@gmail.com	2026-04-11 11:10:01	65	f	2026-04-30 12:10:20
570	alex.k.kaczmarczyk@gmail.com	2026-04-11 11:20:02	87	f	2026-04-30 12:10:20
571	alex.k.kaczmarczyk@gmail.com	2026-04-11 11:30:01	76	f	2026-04-30 12:10:20
572	alex.k.kaczmarczyk@gmail.com	2026-04-11 11:40:00	69	f	2026-04-30 12:10:20
573	alex.k.kaczmarczyk@gmail.com	2026-04-11 11:50:01	68	f	2026-04-30 12:10:20
574	alex.k.kaczmarczyk@gmail.com	2026-04-11 12:00:01	59	t	2026-04-30 12:10:20
575	alex.k.kaczmarczyk@gmail.com	2026-04-11 12:10:01	71	f	2026-04-30 12:10:20
576	alex.k.kaczmarczyk@gmail.com	2026-04-11 12:20:01	95	f	2026-04-30 12:10:20
577	alex.k.kaczmarczyk@gmail.com	2026-04-11 12:30:01	97	f	2026-04-30 12:10:20
578	alex.k.kaczmarczyk@gmail.com	2026-04-11 12:40:01	81	f	2026-04-30 12:10:20
579	alex.k.kaczmarczyk@gmail.com	2026-04-11 12:50:01	84	f	2026-04-30 12:10:20
580	alex.k.kaczmarczyk@gmail.com	2026-04-11 13:00:00	77	f	2026-04-30 12:10:20
581	alex.k.kaczmarczyk@gmail.com	2026-04-11 13:10:01	91	f	2026-04-30 12:10:20
582	alex.k.kaczmarczyk@gmail.com	2026-04-11 13:20:01	79	f	2026-04-30 12:10:20
583	alex.k.kaczmarczyk@gmail.com	2026-04-11 13:30:01	71	f	2026-04-30 12:10:20
584	alex.k.kaczmarczyk@gmail.com	2026-04-11 13:40:01	91	f	2026-04-30 12:10:20
585	alex.k.kaczmarczyk@gmail.com	2026-04-11 13:50:01	67	f	2026-04-30 12:10:20
586	alex.k.kaczmarczyk@gmail.com	2026-04-11 14:00:01	62	t	2026-04-30 12:10:20
587	alex.k.kaczmarczyk@gmail.com	2026-04-11 14:10:01	61	t	2026-04-30 12:10:20
588	alex.k.kaczmarczyk@gmail.com	2026-04-11 14:20:01	100	f	2026-04-30 12:10:20
589	alex.k.kaczmarczyk@gmail.com	2026-04-11 14:30:01	85	f	2026-04-30 12:10:20
590	alex.k.kaczmarczyk@gmail.com	2026-04-11 14:40:00	86	f	2026-04-30 12:10:20
591	alex.k.kaczmarczyk@gmail.com	2026-04-11 14:50:01	90	f	2026-04-30 12:10:20
592	alex.k.kaczmarczyk@gmail.com	2026-04-11 15:00:01	78	f	2026-04-30 12:10:20
593	alex.k.kaczmarczyk@gmail.com	2026-04-11 15:10:01	105	f	2026-04-30 12:10:20
594	alex.k.kaczmarczyk@gmail.com	2026-04-11 15:20:01	108	f	2026-04-30 12:10:20
595	alex.k.kaczmarczyk@gmail.com	2026-04-11 15:30:01	95	f	2026-04-30 12:10:20
596	alex.k.kaczmarczyk@gmail.com	2026-04-11 15:40:01	99	f	2026-04-30 12:10:20
597	alex.k.kaczmarczyk@gmail.com	2026-04-11 15:50:02	89	f	2026-04-30 12:10:20
598	alex.k.kaczmarczyk@gmail.com	2026-04-11 16:00:01	145	f	2026-04-30 12:10:20
599	alex.k.kaczmarczyk@gmail.com	2026-04-11 16:10:01	132	f	2026-04-30 12:10:20
600	alex.k.kaczmarczyk@gmail.com	2026-04-11 16:20:01	115	f	2026-04-30 12:10:20
601	alex.k.kaczmarczyk@gmail.com	2026-04-11 16:30:01	106	f	2026-04-30 12:10:20
602	alex.k.kaczmarczyk@gmail.com	2026-04-11 16:40:01	109	f	2026-04-30 12:10:20
603	alex.k.kaczmarczyk@gmail.com	2026-04-11 16:50:01	97	f	2026-04-30 12:10:20
604	alex.k.kaczmarczyk@gmail.com	2026-04-11 17:00:01	118	f	2026-04-30 12:10:20
605	alex.k.kaczmarczyk@gmail.com	2026-04-11 17:10:00	97	f	2026-04-30 12:10:20
606	alex.k.kaczmarczyk@gmail.com	2026-04-11 17:20:00	101	f	2026-04-30 12:10:20
607	alex.k.kaczmarczyk@gmail.com	2026-04-11 17:30:00	99	f	2026-04-30 12:10:20
608	alex.k.kaczmarczyk@gmail.com	2026-04-11 17:40:01	105	f	2026-04-30 12:10:20
609	alex.k.kaczmarczyk@gmail.com	2026-04-11 17:50:01	81	f	2026-04-30 12:10:20
610	alex.k.kaczmarczyk@gmail.com	2026-04-11 18:00:01	96	f	2026-04-30 12:10:20
7	alex.k.kaczmarczyk@gmail.com	2026-04-06 01:10:01	69	t	2026-04-30 12:10:19
611	alex.k.kaczmarczyk@gmail.com	2026-04-11 18:10:01	106	f	2026-04-30 12:10:20
612	alex.k.kaczmarczyk@gmail.com	2026-04-11 18:20:02	103	f	2026-04-30 12:10:20
613	alex.k.kaczmarczyk@gmail.com	2026-04-11 18:30:00	133	f	2026-04-30 12:10:20
614	alex.k.kaczmarczyk@gmail.com	2026-04-11 22:30:00	95	f	2026-04-30 12:10:20
615	alex.k.kaczmarczyk@gmail.com	2026-04-11 22:40:01	65	f	2026-04-30 12:10:20
616	alex.k.kaczmarczyk@gmail.com	2026-04-11 22:50:01	69	f	2026-04-30 12:10:20
617	alex.k.kaczmarczyk@gmail.com	2026-04-11 23:00:01	65	f	2026-04-30 12:10:20
618	alex.k.kaczmarczyk@gmail.com	2026-04-11 23:10:01	69	f	2026-04-30 12:10:20
619	alex.k.kaczmarczyk@gmail.com	2026-04-11 23:20:09	62	t	2026-04-30 12:10:20
620	alex.k.kaczmarczyk@gmail.com	2026-04-11 23:30:08	64	t	2026-04-30 12:10:20
621	alex.k.kaczmarczyk@gmail.com	2026-04-11 23:40:08	69	f	2026-04-30 12:10:20
622	alex.k.kaczmarczyk@gmail.com	2026-04-11 23:50:09	60	t	2026-04-30 12:10:20
623	alex.k.kaczmarczyk@gmail.com	2026-04-12 00:00:21	98	f	2026-04-30 12:10:20
624	alex.k.kaczmarczyk@gmail.com	2026-04-12 00:10:09	70	t	2026-04-30 12:10:20
625	alex.k.kaczmarczyk@gmail.com	2026-04-12 00:20:08	61	t	2026-04-30 12:10:20
626	alex.k.kaczmarczyk@gmail.com	2026-04-12 00:30:20	58	t	2026-04-30 12:10:20
627	alex.k.kaczmarczyk@gmail.com	2026-04-12 00:40:09	60	t	2026-04-30 12:10:20
628	alex.k.kaczmarczyk@gmail.com	2026-04-12 00:50:09	61	t	2026-04-30 12:10:20
629	alex.k.kaczmarczyk@gmail.com	2026-04-12 01:00:09	59	t	2026-04-30 12:10:20
630	alex.k.kaczmarczyk@gmail.com	2026-04-12 01:10:08	60	t	2026-04-30 12:10:20
631	alex.k.kaczmarczyk@gmail.com	2026-04-12 01:20:09	74	t	2026-04-30 12:10:20
632	alex.k.kaczmarczyk@gmail.com	2026-04-12 01:30:08	71	t	2026-04-30 12:10:20
633	alex.k.kaczmarczyk@gmail.com	2026-04-12 01:40:09	83	f	2026-04-30 12:10:20
634	alex.k.kaczmarczyk@gmail.com	2026-04-12 01:50:08	65	t	2026-04-30 12:10:20
635	alex.k.kaczmarczyk@gmail.com	2026-04-12 02:00:09	62	t	2026-04-30 12:10:20
636	alex.k.kaczmarczyk@gmail.com	2026-04-12 02:10:08	59	t	2026-04-30 12:10:20
637	alex.k.kaczmarczyk@gmail.com	2026-04-12 02:20:08	60	t	2026-04-30 12:10:20
638	alex.k.kaczmarczyk@gmail.com	2026-04-12 02:30:14	59	t	2026-04-30 12:10:20
639	alex.k.kaczmarczyk@gmail.com	2026-04-12 02:40:10	56	t	2026-04-30 12:10:20
640	alex.k.kaczmarczyk@gmail.com	2026-04-12 02:50:12	57	t	2026-04-30 12:10:20
641	alex.k.kaczmarczyk@gmail.com	2026-04-12 03:00:08	58	t	2026-04-30 12:10:20
642	alex.k.kaczmarczyk@gmail.com	2026-04-12 03:10:11	56	t	2026-04-30 12:10:20
643	alex.k.kaczmarczyk@gmail.com	2026-04-12 03:20:12	55	t	2026-04-30 12:10:20
644	alex.k.kaczmarczyk@gmail.com	2026-04-12 03:30:12	61	t	2026-04-30 12:10:20
645	alex.k.kaczmarczyk@gmail.com	2026-04-12 03:40:09	57	t	2026-04-30 12:10:20
646	alex.k.kaczmarczyk@gmail.com	2026-04-12 03:50:15	55	t	2026-04-30 12:10:20
647	alex.k.kaczmarczyk@gmail.com	2026-04-12 04:00:10	53	t	2026-04-30 12:10:20
648	alex.k.kaczmarczyk@gmail.com	2026-04-12 04:10:08	51	t	2026-04-30 12:10:20
649	alex.k.kaczmarczyk@gmail.com	2026-04-12 04:20:09	73	t	2026-04-30 12:10:20
650	alex.k.kaczmarczyk@gmail.com	2026-04-12 04:30:18	53	t	2026-04-30 12:10:20
651	alex.k.kaczmarczyk@gmail.com	2026-04-12 04:40:09	55	t	2026-04-30 12:10:20
652	alex.k.kaczmarczyk@gmail.com	2026-04-12 04:50:11	55	t	2026-04-30 12:10:20
653	alex.k.kaczmarczyk@gmail.com	2026-04-12 05:00:09	53	t	2026-04-30 12:10:20
654	alex.k.kaczmarczyk@gmail.com	2026-04-12 05:10:12	54	t	2026-04-30 12:10:20
655	alex.k.kaczmarczyk@gmail.com	2026-04-12 05:20:09	51	t	2026-04-30 12:10:20
656	alex.k.kaczmarczyk@gmail.com	2026-04-12 05:30:08	53	t	2026-04-30 12:10:20
657	alex.k.kaczmarczyk@gmail.com	2026-04-12 05:40:21	96	f	2026-04-30 12:10:20
658	alex.k.kaczmarczyk@gmail.com	2026-04-12 05:50:08	51	t	2026-04-30 12:10:20
659	alex.k.kaczmarczyk@gmail.com	2026-04-12 06:00:21	52	t	2026-04-30 12:10:20
660	alex.k.kaczmarczyk@gmail.com	2026-04-12 06:10:09	53	t	2026-04-30 12:10:20
661	alex.k.kaczmarczyk@gmail.com	2026-04-12 06:20:19	51	t	2026-04-30 12:10:20
662	alex.k.kaczmarczyk@gmail.com	2026-04-12 06:30:20	51	t	2026-04-30 12:10:20
663	alex.k.kaczmarczyk@gmail.com	2026-04-12 06:40:18	51	t	2026-04-30 12:10:20
664	alex.k.kaczmarczyk@gmail.com	2026-04-12 06:50:11	53	t	2026-04-30 12:10:20
665	alex.k.kaczmarczyk@gmail.com	2026-04-12 07:00:09	51	t	2026-04-30 12:10:20
666	alex.k.kaczmarczyk@gmail.com	2026-04-12 07:10:10	53	t	2026-04-30 12:10:20
667	alex.k.kaczmarczyk@gmail.com	2026-04-12 07:20:09	64	t	2026-04-30 12:10:20
668	alex.k.kaczmarczyk@gmail.com	2026-04-12 07:30:10	57	t	2026-04-30 12:10:20
669	alex.k.kaczmarczyk@gmail.com	2026-04-12 07:40:21	56	t	2026-04-30 12:10:20
670	alex.k.kaczmarczyk@gmail.com	2026-04-12 07:50:14	86	f	2026-04-30 12:10:20
671	alex.k.kaczmarczyk@gmail.com	2026-04-12 08:00:01	50	t	2026-04-30 12:10:20
672	alex.k.kaczmarczyk@gmail.com	2026-04-12 08:10:02	59	t	2026-04-30 12:10:20
673	alex.k.kaczmarczyk@gmail.com	2026-04-12 08:20:01	54	t	2026-04-30 12:10:20
674	alex.k.kaczmarczyk@gmail.com	2026-04-12 08:50:02	89	f	2026-04-30 12:10:20
675	alex.k.kaczmarczyk@gmail.com	2026-04-12 09:00:02	85	f	2026-04-30 12:10:20
676	alex.k.kaczmarczyk@gmail.com	2026-04-12 09:10:00	68	f	2026-04-30 12:10:20
677	alex.k.kaczmarczyk@gmail.com	2026-04-12 09:20:00	97	f	2026-04-30 12:10:20
678	alex.k.kaczmarczyk@gmail.com	2026-04-12 09:30:00	65	f	2026-04-30 12:10:20
679	alex.k.kaczmarczyk@gmail.com	2026-04-12 09:40:00	99	f	2026-04-30 12:10:20
680	alex.k.kaczmarczyk@gmail.com	2026-04-12 09:50:01	62	t	2026-04-30 12:10:20
681	alex.k.kaczmarczyk@gmail.com	2026-04-12 10:00:01	58	t	2026-04-30 12:10:20
682	alex.k.kaczmarczyk@gmail.com	2026-04-12 10:10:01	55	t	2026-04-30 12:10:20
683	alex.k.kaczmarczyk@gmail.com	2026-04-12 10:20:01	59	t	2026-04-30 12:10:20
684	alex.k.kaczmarczyk@gmail.com	2026-04-12 10:30:01	61	t	2026-04-30 12:10:20
685	alex.k.kaczmarczyk@gmail.com	2026-04-12 10:40:00	62	t	2026-04-30 12:10:20
686	alex.k.kaczmarczyk@gmail.com	2026-04-12 10:50:00	62	t	2026-04-30 12:10:20
687	alex.k.kaczmarczyk@gmail.com	2026-04-12 11:00:01	62	t	2026-04-30 12:10:20
688	alex.k.kaczmarczyk@gmail.com	2026-04-12 11:10:01	82	f	2026-04-30 12:10:20
689	alex.k.kaczmarczyk@gmail.com	2026-04-12 11:20:01	74	f	2026-04-30 12:10:20
690	alex.k.kaczmarczyk@gmail.com	2026-04-12 11:30:01	63	t	2026-04-30 12:10:20
691	alex.k.kaczmarczyk@gmail.com	2026-04-12 11:40:01	80	f	2026-04-30 12:10:20
692	alex.k.kaczmarczyk@gmail.com	2026-04-12 11:50:01	87	f	2026-04-30 12:10:20
693	alex.k.kaczmarczyk@gmail.com	2026-04-12 12:00:00	105	f	2026-04-30 12:10:20
694	alex.k.kaczmarczyk@gmail.com	2026-04-12 12:10:01	68	f	2026-04-30 12:10:20
695	alex.k.kaczmarczyk@gmail.com	2026-04-12 12:20:01	81	f	2026-04-30 12:10:20
696	alex.k.kaczmarczyk@gmail.com	2026-04-12 12:30:01	82	f	2026-04-30 12:10:20
697	alex.k.kaczmarczyk@gmail.com	2026-04-12 12:40:01	72	f	2026-04-30 12:10:20
8	alex.k.kaczmarczyk@gmail.com	2026-04-06 01:20:01	55	t	2026-04-30 12:10:19
698	alex.k.kaczmarczyk@gmail.com	2026-04-12 12:50:00	65	f	2026-04-30 12:10:20
699	alex.k.kaczmarczyk@gmail.com	2026-04-12 13:00:00	63	t	2026-04-30 12:10:20
700	alex.k.kaczmarczyk@gmail.com	2026-04-12 13:10:01	60	t	2026-04-30 12:10:20
701	alex.k.kaczmarczyk@gmail.com	2026-04-12 13:20:01	66	f	2026-04-30 12:10:20
702	alex.k.kaczmarczyk@gmail.com	2026-04-12 13:30:01	62	t	2026-04-30 12:10:20
703	alex.k.kaczmarczyk@gmail.com	2026-04-12 13:40:02	81	f	2026-04-30 12:10:20
704	alex.k.kaczmarczyk@gmail.com	2026-04-12 13:50:02	62	t	2026-04-30 12:10:20
705	alex.k.kaczmarczyk@gmail.com	2026-04-12 14:00:02	74	f	2026-04-30 12:10:20
706	alex.k.kaczmarczyk@gmail.com	2026-04-12 14:10:00	67	f	2026-04-30 12:10:20
707	alex.k.kaczmarczyk@gmail.com	2026-04-12 14:20:00	67	f	2026-04-30 12:10:20
708	alex.k.kaczmarczyk@gmail.com	2026-04-12 14:30:01	82	f	2026-04-30 12:10:20
709	alex.k.kaczmarczyk@gmail.com	2026-04-12 14:40:01	75	f	2026-04-30 12:10:20
710	alex.k.kaczmarczyk@gmail.com	2026-04-12 14:50:01	67	f	2026-04-30 12:10:20
711	alex.k.kaczmarczyk@gmail.com	2026-04-12 15:00:01	61	t	2026-04-30 12:10:20
712	alex.k.kaczmarczyk@gmail.com	2026-04-12 15:10:01	76	f	2026-04-30 12:10:20
713	alex.k.kaczmarczyk@gmail.com	2026-04-12 15:20:01	59	t	2026-04-30 12:10:20
714	alex.k.kaczmarczyk@gmail.com	2026-04-12 15:30:01	59	t	2026-04-30 12:10:20
715	alex.k.kaczmarczyk@gmail.com	2026-04-12 15:40:01	56	t	2026-04-30 12:10:20
716	alex.k.kaczmarczyk@gmail.com	2026-04-12 15:50:00	84	f	2026-04-30 12:10:20
717	alex.k.kaczmarczyk@gmail.com	2026-04-12 16:00:00	55	t	2026-04-30 12:10:20
718	alex.k.kaczmarczyk@gmail.com	2026-04-12 16:10:00	55	t	2026-04-30 12:10:20
719	alex.k.kaczmarczyk@gmail.com	2026-04-12 16:20:00	58	t	2026-04-30 12:10:20
720	alex.k.kaczmarczyk@gmail.com	2026-04-12 16:30:00	76	f	2026-04-30 12:10:20
721	alex.k.kaczmarczyk@gmail.com	2026-04-12 16:40:00	72	f	2026-04-30 12:10:20
722	alex.k.kaczmarczyk@gmail.com	2026-04-12 16:50:01	75	f	2026-04-30 12:10:20
723	alex.k.kaczmarczyk@gmail.com	2026-04-12 17:00:00	72	f	2026-04-30 12:10:20
724	alex.k.kaczmarczyk@gmail.com	2026-04-12 17:10:00	75	f	2026-04-30 12:10:20
725	alex.k.kaczmarczyk@gmail.com	2026-04-12 17:20:00	73	f	2026-04-30 12:10:20
726	alex.k.kaczmarczyk@gmail.com	2026-04-12 17:30:00	69	f	2026-04-30 12:10:20
727	alex.k.kaczmarczyk@gmail.com	2026-04-12 17:40:02	103	f	2026-04-30 12:10:20
728	alex.k.kaczmarczyk@gmail.com	2026-04-12 17:50:01	93	f	2026-04-30 12:10:20
729	alex.k.kaczmarczyk@gmail.com	2026-04-12 18:00:00	92	f	2026-04-30 12:10:20
730	alex.k.kaczmarczyk@gmail.com	2026-04-12 18:10:00	104	f	2026-04-30 12:10:20
731	alex.k.kaczmarczyk@gmail.com	2026-04-12 23:10:01	84	f	2026-04-30 12:10:20
732	alex.k.kaczmarczyk@gmail.com	2026-04-12 23:20:01	94	f	2026-04-30 12:10:20
733	alex.k.kaczmarczyk@gmail.com	2026-04-12 23:30:01	73	f	2026-04-30 12:10:20
734	alex.k.kaczmarczyk@gmail.com	2026-04-12 23:40:01	53	t	2026-04-30 12:10:20
735	alex.k.kaczmarczyk@gmail.com	2026-04-12 23:50:09	58	t	2026-04-30 12:10:20
736	alex.k.kaczmarczyk@gmail.com	2026-04-13 00:00:09	57	t	2026-04-30 12:10:20
737	alex.k.kaczmarczyk@gmail.com	2026-04-13 00:10:10	61	t	2026-04-30 12:10:20
738	alex.k.kaczmarczyk@gmail.com	2026-04-13 00:20:12	60	t	2026-04-30 12:10:20
739	alex.k.kaczmarczyk@gmail.com	2026-04-13 00:30:09	59	t	2026-04-30 12:10:20
740	alex.k.kaczmarczyk@gmail.com	2026-04-13 00:40:10	63	t	2026-04-30 12:10:20
741	alex.k.kaczmarczyk@gmail.com	2026-04-13 00:50:09	61	t	2026-04-30 12:10:20
742	alex.k.kaczmarczyk@gmail.com	2026-04-13 01:00:10	67	t	2026-04-30 12:10:20
743	alex.k.kaczmarczyk@gmail.com	2026-04-13 01:10:10	64	t	2026-04-30 12:10:20
744	alex.k.kaczmarczyk@gmail.com	2026-04-13 01:20:10	62	t	2026-04-30 12:10:20
745	alex.k.kaczmarczyk@gmail.com	2026-04-13 01:30:12	57	t	2026-04-30 12:10:20
746	alex.k.kaczmarczyk@gmail.com	2026-04-13 01:40:10	60	t	2026-04-30 12:10:20
747	alex.k.kaczmarczyk@gmail.com	2026-04-13 01:50:09	50	t	2026-04-30 12:10:20
748	alex.k.kaczmarczyk@gmail.com	2026-04-13 02:00:10	52	t	2026-04-30 12:10:20
749	alex.k.kaczmarczyk@gmail.com	2026-04-13 02:10:10	58	t	2026-04-30 12:10:20
750	alex.k.kaczmarczyk@gmail.com	2026-04-13 02:20:12	57	t	2026-04-30 12:10:20
751	alex.k.kaczmarczyk@gmail.com	2026-04-13 02:30:09	60	t	2026-04-30 12:10:20
752	alex.k.kaczmarczyk@gmail.com	2026-04-13 02:40:09	69	t	2026-04-30 12:10:20
753	alex.k.kaczmarczyk@gmail.com	2026-04-13 02:50:10	58	t	2026-04-30 12:10:20
754	alex.k.kaczmarczyk@gmail.com	2026-04-13 03:00:20	52	t	2026-04-30 12:10:20
755	alex.k.kaczmarczyk@gmail.com	2026-04-13 03:10:11	54	t	2026-04-30 12:10:20
756	alex.k.kaczmarczyk@gmail.com	2026-04-13 03:20:12	76	t	2026-04-30 12:10:20
757	alex.k.kaczmarczyk@gmail.com	2026-04-13 03:30:10	54	t	2026-04-30 12:10:20
758	alex.k.kaczmarczyk@gmail.com	2026-04-13 03:40:20	53	t	2026-04-30 12:10:20
759	alex.k.kaczmarczyk@gmail.com	2026-04-13 03:50:10	50	t	2026-04-30 12:10:20
760	alex.k.kaczmarczyk@gmail.com	2026-04-13 04:00:20	52	t	2026-04-30 12:10:20
761	alex.k.kaczmarczyk@gmail.com	2026-04-13 04:10:13	53	t	2026-04-30 12:10:20
762	alex.k.kaczmarczyk@gmail.com	2026-04-13 04:20:09	56	t	2026-04-30 12:10:20
763	alex.k.kaczmarczyk@gmail.com	2026-04-13 04:30:11	52	t	2026-04-30 12:10:20
764	alex.k.kaczmarczyk@gmail.com	2026-04-13 04:40:21	54	t	2026-04-30 12:10:20
765	alex.k.kaczmarczyk@gmail.com	2026-04-13 04:50:09	52	t	2026-04-30 12:10:20
766	alex.k.kaczmarczyk@gmail.com	2026-04-13 05:00:12	81	f	2026-04-30 12:10:20
767	alex.k.kaczmarczyk@gmail.com	2026-04-13 05:10:12	58	t	2026-04-30 12:10:20
768	alex.k.kaczmarczyk@gmail.com	2026-04-13 05:20:13	53	t	2026-04-30 12:10:20
769	alex.k.kaczmarczyk@gmail.com	2026-04-13 05:30:15	74	t	2026-04-30 12:10:20
770	alex.k.kaczmarczyk@gmail.com	2026-04-13 05:40:13	72	t	2026-04-30 12:10:20
771	alex.k.kaczmarczyk@gmail.com	2026-04-13 06:10:00	103	f	2026-04-30 12:10:20
772	alex.k.kaczmarczyk@gmail.com	2026-04-13 06:20:01	59	t	2026-04-30 12:10:20
773	alex.k.kaczmarczyk@gmail.com	2026-04-13 06:30:00	60	t	2026-04-30 12:10:20
774	alex.k.kaczmarczyk@gmail.com	2026-04-13 06:40:01	66	f	2026-04-30 12:10:20
775	alex.k.kaczmarczyk@gmail.com	2026-04-13 06:50:01	96	f	2026-04-30 12:10:20
776	alex.k.kaczmarczyk@gmail.com	2026-04-13 07:00:02	58	t	2026-04-30 12:10:20
777	alex.k.kaczmarczyk@gmail.com	2026-04-13 07:10:01	80	f	2026-04-30 12:10:20
778	alex.k.kaczmarczyk@gmail.com	2026-04-13 07:20:01	82	f	2026-04-30 12:10:20
779	alex.k.kaczmarczyk@gmail.com	2026-04-13 07:30:00	79	f	2026-04-30 12:10:20
780	alex.k.kaczmarczyk@gmail.com	2026-04-13 07:40:01	126	f	2026-04-30 12:10:20
781	alex.k.kaczmarczyk@gmail.com	2026-04-13 07:50:01	92	f	2026-04-30 12:10:20
782	alex.k.kaczmarczyk@gmail.com	2026-04-13 08:00:00	67	f	2026-04-30 12:10:20
783	alex.k.kaczmarczyk@gmail.com	2026-04-13 08:10:00	76	f	2026-04-30 12:10:20
784	alex.k.kaczmarczyk@gmail.com	2026-04-13 08:20:01	71	f	2026-04-30 12:10:20
9	alex.k.kaczmarczyk@gmail.com	2026-04-06 01:30:01	54	t	2026-04-30 12:10:19
785	alex.k.kaczmarczyk@gmail.com	2026-04-13 08:30:01	74	f	2026-04-30 12:10:20
786	alex.k.kaczmarczyk@gmail.com	2026-04-13 08:40:01	66	f	2026-04-30 12:10:20
787	alex.k.kaczmarczyk@gmail.com	2026-04-13 08:50:01	70	f	2026-04-30 12:10:20
788	alex.k.kaczmarczyk@gmail.com	2026-04-13 09:00:00	64	t	2026-04-30 12:10:20
789	alex.k.kaczmarczyk@gmail.com	2026-04-13 09:10:02	75	f	2026-04-30 12:10:20
790	alex.k.kaczmarczyk@gmail.com	2026-04-13 09:20:01	72	f	2026-04-30 12:10:20
791	alex.k.kaczmarczyk@gmail.com	2026-04-13 09:30:01	89	f	2026-04-30 12:10:20
792	alex.k.kaczmarczyk@gmail.com	2026-04-13 09:40:01	135	f	2026-04-30 12:10:20
793	alex.k.kaczmarczyk@gmail.com	2026-04-13 09:50:01	68	f	2026-04-30 12:10:20
794	alex.k.kaczmarczyk@gmail.com	2026-04-13 10:00:01	62	t	2026-04-30 12:10:20
795	alex.k.kaczmarczyk@gmail.com	2026-04-13 10:10:01	67	f	2026-04-30 12:10:20
796	alex.k.kaczmarczyk@gmail.com	2026-04-13 10:20:02	78	f	2026-04-30 12:10:20
797	alex.k.kaczmarczyk@gmail.com	2026-04-13 10:30:01	75	f	2026-04-30 12:10:20
798	alex.k.kaczmarczyk@gmail.com	2026-04-13 10:40:01	61	t	2026-04-30 12:10:20
799	alex.k.kaczmarczyk@gmail.com	2026-04-13 10:50:02	64	t	2026-04-30 12:10:20
800	alex.k.kaczmarczyk@gmail.com	2026-04-13 11:00:02	63	t	2026-04-30 12:10:20
801	alex.k.kaczmarczyk@gmail.com	2026-04-13 11:10:01	63	t	2026-04-30 12:10:20
802	alex.k.kaczmarczyk@gmail.com	2026-04-13 11:20:00	97	f	2026-04-30 12:10:20
803	alex.k.kaczmarczyk@gmail.com	2026-04-13 11:30:01	69	f	2026-04-30 12:10:20
804	alex.k.kaczmarczyk@gmail.com	2026-04-13 11:40:01	117	f	2026-04-30 12:10:20
805	alex.k.kaczmarczyk@gmail.com	2026-04-13 11:50:01	84	f	2026-04-30 12:10:20
806	alex.k.kaczmarczyk@gmail.com	2026-04-13 12:00:01	85	f	2026-04-30 12:10:20
807	alex.k.kaczmarczyk@gmail.com	2026-04-13 12:10:01	83	f	2026-04-30 12:10:20
808	alex.k.kaczmarczyk@gmail.com	2026-04-13 12:20:00	77	f	2026-04-30 12:10:20
809	alex.k.kaczmarczyk@gmail.com	2026-04-13 12:30:01	69	f	2026-04-30 12:10:20
810	alex.k.kaczmarczyk@gmail.com	2026-04-13 12:40:02	68	f	2026-04-30 12:10:20
811	alex.k.kaczmarczyk@gmail.com	2026-04-13 12:50:00	64	t	2026-04-30 12:10:20
812	alex.k.kaczmarczyk@gmail.com	2026-04-13 13:00:01	95	f	2026-04-30 12:10:20
813	alex.k.kaczmarczyk@gmail.com	2026-04-13 13:10:01	75	f	2026-04-30 12:10:20
814	alex.k.kaczmarczyk@gmail.com	2026-04-13 13:20:00	72	f	2026-04-30 12:10:20
815	alex.k.kaczmarczyk@gmail.com	2026-04-13 13:30:01	69	f	2026-04-30 12:10:20
816	alex.k.kaczmarczyk@gmail.com	2026-04-13 13:40:01	69	f	2026-04-30 12:10:20
817	alex.k.kaczmarczyk@gmail.com	2026-04-13 13:50:02	69	f	2026-04-30 12:10:20
818	alex.k.kaczmarczyk@gmail.com	2026-04-13 14:00:01	90	f	2026-04-30 12:10:20
819	alex.k.kaczmarczyk@gmail.com	2026-04-13 14:10:01	87	f	2026-04-30 12:10:20
820	alex.k.kaczmarczyk@gmail.com	2026-04-13 14:20:00	64	t	2026-04-30 12:10:20
821	alex.k.kaczmarczyk@gmail.com	2026-04-13 14:30:00	59	t	2026-04-30 12:10:20
822	alex.k.kaczmarczyk@gmail.com	2026-04-13 14:40:01	66	f	2026-04-30 12:10:20
823	alex.k.kaczmarczyk@gmail.com	2026-04-13 14:50:01	95	f	2026-04-30 12:10:20
824	alex.k.kaczmarczyk@gmail.com	2026-04-13 15:00:01	94	f	2026-04-30 12:10:20
825	alex.k.kaczmarczyk@gmail.com	2026-04-13 15:10:01	95	f	2026-04-30 12:10:20
826	alex.k.kaczmarczyk@gmail.com	2026-04-13 15:20:01	73	f	2026-04-30 12:10:20
827	alex.k.kaczmarczyk@gmail.com	2026-04-13 15:30:00	61	t	2026-04-30 12:10:20
828	alex.k.kaczmarczyk@gmail.com	2026-04-13 15:40:01	82	f	2026-04-30 12:10:20
829	alex.k.kaczmarczyk@gmail.com	2026-04-13 15:50:00	62	t	2026-04-30 12:10:20
830	alex.k.kaczmarczyk@gmail.com	2026-04-13 16:00:01	60	t	2026-04-30 12:10:20
831	alex.k.kaczmarczyk@gmail.com	2026-04-13 16:10:01	70	f	2026-04-30 12:10:20
832	alex.k.kaczmarczyk@gmail.com	2026-04-13 16:20:01	64	t	2026-04-30 12:10:20
833	alex.k.kaczmarczyk@gmail.com	2026-04-13 16:30:01	80	f	2026-04-30 12:10:20
834	alex.k.kaczmarczyk@gmail.com	2026-04-13 16:40:01	131	f	2026-04-30 12:10:20
835	alex.k.kaczmarczyk@gmail.com	2026-04-13 16:50:01	93	f	2026-04-30 12:10:20
836	alex.k.kaczmarczyk@gmail.com	2026-04-13 17:00:02	78	f	2026-04-30 12:10:20
837	alex.k.kaczmarczyk@gmail.com	2026-04-13 17:10:01	71	f	2026-04-30 12:10:20
838	alex.k.kaczmarczyk@gmail.com	2026-04-13 17:20:01	66	f	2026-04-30 12:10:20
839	alex.k.kaczmarczyk@gmail.com	2026-04-13 17:30:01	74	f	2026-04-30 12:10:20
840	alex.k.kaczmarczyk@gmail.com	2026-04-13 17:40:01	70	f	2026-04-30 12:10:20
841	alex.k.kaczmarczyk@gmail.com	2026-04-13 17:50:01	118	f	2026-04-30 12:10:20
842	alex.k.kaczmarczyk@gmail.com	2026-04-13 18:00:01	96	f	2026-04-30 12:10:20
843	alex.k.kaczmarczyk@gmail.com	2026-04-13 18:10:01	109	f	2026-04-30 12:10:20
844	alex.k.kaczmarczyk@gmail.com	2026-04-13 18:20:01	89	f	2026-04-30 12:10:20
845	alex.k.kaczmarczyk@gmail.com	2026-04-13 18:30:01	93	f	2026-04-30 12:10:20
846	alex.k.kaczmarczyk@gmail.com	2026-04-13 18:40:01	84	f	2026-04-30 12:10:20
847	alex.k.kaczmarczyk@gmail.com	2026-04-13 18:50:01	70	f	2026-04-30 12:10:20
848	alex.k.kaczmarczyk@gmail.com	2026-04-13 19:00:02	69	f	2026-04-30 12:10:20
849	alex.k.kaczmarczyk@gmail.com	2026-04-13 19:10:01	77	f	2026-04-30 12:10:20
850	alex.k.kaczmarczyk@gmail.com	2026-04-13 19:20:00	92	f	2026-04-30 12:10:20
851	alex.k.kaczmarczyk@gmail.com	2026-04-13 19:30:01	81	f	2026-04-30 12:10:20
852	alex.k.kaczmarczyk@gmail.com	2026-04-13 19:40:01	75	f	2026-04-30 12:10:20
853	alex.k.kaczmarczyk@gmail.com	2026-04-13 19:50:01	89	f	2026-04-30 12:10:20
854	alex.k.kaczmarczyk@gmail.com	2026-04-13 23:00:01	49	t	2026-04-30 12:10:20
855	alex.k.kaczmarczyk@gmail.com	2026-04-13 23:10:01	58	t	2026-04-30 12:10:20
856	alex.k.kaczmarczyk@gmail.com	2026-04-13 23:20:01	47	t	2026-04-30 12:10:20
857	alex.k.kaczmarczyk@gmail.com	2026-04-13 23:30:01	49	t	2026-04-30 12:10:20
858	alex.k.kaczmarczyk@gmail.com	2026-04-13 23:40:09	50	t	2026-04-30 12:10:20
859	alex.k.kaczmarczyk@gmail.com	2026-04-13 23:50:11	51	t	2026-04-30 12:10:20
860	alex.k.kaczmarczyk@gmail.com	2026-04-14 00:00:21	52	t	2026-04-30 12:10:19
861	alex.k.kaczmarczyk@gmail.com	2026-04-14 00:10:10	54	t	2026-04-30 12:10:19
862	alex.k.kaczmarczyk@gmail.com	2026-04-14 00:20:10	53	t	2026-04-30 12:10:19
863	alex.k.kaczmarczyk@gmail.com	2026-04-14 00:30:16	54	t	2026-04-30 12:10:19
864	alex.k.kaczmarczyk@gmail.com	2026-04-14 00:40:10	48	t	2026-04-30 12:10:19
865	alex.k.kaczmarczyk@gmail.com	2026-04-14 00:50:09	49	t	2026-04-30 12:10:19
866	alex.k.kaczmarczyk@gmail.com	2026-04-14 01:00:22	49	t	2026-04-30 12:10:19
867	alex.k.kaczmarczyk@gmail.com	2026-04-14 01:10:12	52	t	2026-04-30 12:10:19
868	alex.k.kaczmarczyk@gmail.com	2026-04-14 01:20:22	51	t	2026-04-30 12:10:19
869	alex.k.kaczmarczyk@gmail.com	2026-04-14 01:30:12	51	t	2026-04-30 12:10:19
870	alex.k.kaczmarczyk@gmail.com	2026-04-14 01:40:22	50	t	2026-04-30 12:10:19
871	alex.k.kaczmarczyk@gmail.com	2026-04-14 01:50:10	56	t	2026-04-30 12:10:19
10	alex.k.kaczmarczyk@gmail.com	2026-04-06 01:40:08	54	t	2026-04-30 12:10:19
872	alex.k.kaczmarczyk@gmail.com	2026-04-14 02:00:10	57	t	2026-04-30 12:10:19
873	alex.k.kaczmarczyk@gmail.com	2026-04-14 02:10:10	80	f	2026-04-30 12:10:19
874	alex.k.kaczmarczyk@gmail.com	2026-04-14 02:20:10	54	t	2026-04-30 12:10:19
875	alex.k.kaczmarczyk@gmail.com	2026-04-14 02:30:09	54	t	2026-04-30 12:10:19
876	alex.k.kaczmarczyk@gmail.com	2026-04-14 02:40:23	50	t	2026-04-30 12:10:19
877	alex.k.kaczmarczyk@gmail.com	2026-04-14 02:50:19	50	t	2026-04-30 12:10:19
878	alex.k.kaczmarczyk@gmail.com	2026-04-14 03:00:22	51	t	2026-04-30 12:10:19
879	alex.k.kaczmarczyk@gmail.com	2026-04-14 03:10:22	92	f	2026-04-30 12:10:19
880	alex.k.kaczmarczyk@gmail.com	2026-04-14 03:20:20	51	t	2026-04-30 12:10:19
881	alex.k.kaczmarczyk@gmail.com	2026-04-14 03:30:22	53	t	2026-04-30 12:10:19
882	alex.k.kaczmarczyk@gmail.com	2026-04-14 03:40:10	52	t	2026-04-30 12:10:19
883	alex.k.kaczmarczyk@gmail.com	2026-04-14 03:50:11	55	t	2026-04-30 12:10:19
884	alex.k.kaczmarczyk@gmail.com	2026-04-14 04:00:09	59	t	2026-04-30 12:10:19
885	alex.k.kaczmarczyk@gmail.com	2026-04-14 04:10:08	57	t	2026-04-30 12:10:19
886	alex.k.kaczmarczyk@gmail.com	2026-04-14 04:20:14	55	t	2026-04-30 12:10:19
887	alex.k.kaczmarczyk@gmail.com	2026-04-14 04:30:14	53	t	2026-04-30 12:10:19
888	alex.k.kaczmarczyk@gmail.com	2026-04-14 04:40:11	52	t	2026-04-30 12:10:19
889	alex.k.kaczmarczyk@gmail.com	2026-04-14 04:50:20	49	t	2026-04-30 12:10:19
890	alex.k.kaczmarczyk@gmail.com	2026-04-14 05:00:09	52	t	2026-04-30 12:10:19
891	alex.k.kaczmarczyk@gmail.com	2026-04-14 05:10:18	50	t	2026-04-30 12:10:19
892	alex.k.kaczmarczyk@gmail.com	2026-04-14 05:20:21	49	t	2026-04-30 12:10:19
893	alex.k.kaczmarczyk@gmail.com	2026-04-14 05:30:15	53	t	2026-04-30 12:10:19
894	alex.k.kaczmarczyk@gmail.com	2026-04-14 05:40:18	49	t	2026-04-30 12:10:19
895	alex.k.kaczmarczyk@gmail.com	2026-04-14 05:50:08	54	t	2026-04-30 12:10:19
896	alex.k.kaczmarczyk@gmail.com	2026-04-14 06:00:11	65	f	2026-04-30 12:10:19
897	alex.k.kaczmarczyk@gmail.com	2026-04-14 06:10:09	56	t	2026-04-30 12:10:19
898	alex.k.kaczmarczyk@gmail.com	2026-04-14 06:20:09	52	t	2026-04-30 12:10:19
899	alex.k.kaczmarczyk@gmail.com	2026-04-14 06:30:20	49	t	2026-04-30 12:10:19
900	alex.k.kaczmarczyk@gmail.com	2026-04-14 06:40:16	55	t	2026-04-30 12:10:19
901	alex.k.kaczmarczyk@gmail.com	2026-04-14 06:50:11	51	t	2026-04-30 12:10:19
902	alex.k.kaczmarczyk@gmail.com	2026-04-14 07:00:11	79	f	2026-04-30 12:10:19
903	alex.k.kaczmarczyk@gmail.com	2026-04-14 07:10:01	59	t	2026-04-30 12:10:19
904	alex.k.kaczmarczyk@gmail.com	2026-04-14 07:50:02	119	f	2026-04-30 12:10:19
905	alex.k.kaczmarczyk@gmail.com	2026-04-14 08:00:01	106	f	2026-04-30 12:10:19
906	alex.k.kaczmarczyk@gmail.com	2026-04-14 08:10:01	79	f	2026-04-30 12:10:19
907	alex.k.kaczmarczyk@gmail.com	2026-04-14 08:20:01	75	f	2026-04-30 12:10:19
908	alex.k.kaczmarczyk@gmail.com	2026-04-14 08:30:01	91	f	2026-04-30 12:10:19
909	alex.k.kaczmarczyk@gmail.com	2026-04-14 08:40:00	94	f	2026-04-30 12:10:19
910	alex.k.kaczmarczyk@gmail.com	2026-04-14 08:50:01	99	f	2026-04-30 12:10:19
911	alex.k.kaczmarczyk@gmail.com	2026-04-14 09:00:01	68	f	2026-04-30 12:10:19
912	alex.k.kaczmarczyk@gmail.com	2026-04-14 09:10:01	81	f	2026-04-30 12:10:19
913	alex.k.kaczmarczyk@gmail.com	2026-04-14 09:20:01	100	f	2026-04-30 12:10:19
914	alex.k.kaczmarczyk@gmail.com	2026-04-14 09:30:01	108	f	2026-04-30 12:10:19
915	alex.k.kaczmarczyk@gmail.com	2026-04-14 09:40:01	78	f	2026-04-30 12:10:19
916	alex.k.kaczmarczyk@gmail.com	2026-04-14 09:50:01	96	f	2026-04-30 12:10:19
917	alex.k.kaczmarczyk@gmail.com	2026-04-14 10:00:01	87	f	2026-04-30 12:10:19
918	alex.k.kaczmarczyk@gmail.com	2026-04-14 10:10:02	80	f	2026-04-30 12:10:19
919	alex.k.kaczmarczyk@gmail.com	2026-04-14 10:20:01	90	f	2026-04-30 12:10:19
920	alex.k.kaczmarczyk@gmail.com	2026-04-14 10:30:01	83	f	2026-04-30 12:10:19
921	alex.k.kaczmarczyk@gmail.com	2026-04-14 10:40:01	69	f	2026-04-30 12:10:19
922	alex.k.kaczmarczyk@gmail.com	2026-04-14 10:50:01	73	f	2026-04-30 12:10:19
923	alex.k.kaczmarczyk@gmail.com	2026-04-14 11:00:01	71	f	2026-04-30 12:10:19
924	alex.k.kaczmarczyk@gmail.com	2026-04-14 11:10:01	79	f	2026-04-30 12:10:19
925	alex.k.kaczmarczyk@gmail.com	2026-04-14 11:20:01	76	f	2026-04-30 12:10:19
926	alex.k.kaczmarczyk@gmail.com	2026-04-14 11:30:01	118	f	2026-04-30 12:10:19
927	alex.k.kaczmarczyk@gmail.com	2026-04-14 11:40:02	99	f	2026-04-30 12:10:19
928	alex.k.kaczmarczyk@gmail.com	2026-04-14 11:50:01	91	f	2026-04-30 12:10:19
929	alex.k.kaczmarczyk@gmail.com	2026-04-14 12:00:01	93	f	2026-04-30 12:10:19
930	alex.k.kaczmarczyk@gmail.com	2026-04-14 12:10:01	87	f	2026-04-30 12:10:19
931	alex.k.kaczmarczyk@gmail.com	2026-04-14 12:20:01	90	f	2026-04-30 12:10:19
932	alex.k.kaczmarczyk@gmail.com	2026-04-14 12:30:01	94	f	2026-04-30 12:10:19
933	alex.k.kaczmarczyk@gmail.com	2026-04-14 12:40:01	87	f	2026-04-30 12:10:19
934	alex.k.kaczmarczyk@gmail.com	2026-04-14 12:50:01	98	f	2026-04-30 12:10:19
935	alex.k.kaczmarczyk@gmail.com	2026-04-14 13:00:01	82	f	2026-04-30 12:10:19
936	alex.k.kaczmarczyk@gmail.com	2026-04-14 13:10:01	88	f	2026-04-30 12:10:19
937	alex.k.kaczmarczyk@gmail.com	2026-04-14 13:20:00	81	f	2026-04-30 12:10:19
938	alex.k.kaczmarczyk@gmail.com	2026-04-14 13:30:01	90	f	2026-04-30 12:10:19
939	alex.k.kaczmarczyk@gmail.com	2026-04-14 13:40:01	78	f	2026-04-30 12:10:19
940	alex.k.kaczmarczyk@gmail.com	2026-04-14 13:50:00	92	f	2026-04-30 12:10:19
941	alex.k.kaczmarczyk@gmail.com	2026-04-14 14:00:01	76	f	2026-04-30 12:10:19
942	alex.k.kaczmarczyk@gmail.com	2026-04-14 14:10:01	81	f	2026-04-30 12:10:19
943	alex.k.kaczmarczyk@gmail.com	2026-04-14 14:20:01	89	f	2026-04-30 12:10:19
944	alex.k.kaczmarczyk@gmail.com	2026-04-14 14:30:02	88	f	2026-04-30 12:10:19
945	alex.k.kaczmarczyk@gmail.com	2026-04-14 14:40:01	82	f	2026-04-30 12:10:19
946	alex.k.kaczmarczyk@gmail.com	2026-04-14 14:50:02	83	f	2026-04-30 12:10:19
947	alex.k.kaczmarczyk@gmail.com	2026-04-14 15:00:01	98	f	2026-04-30 12:10:19
948	alex.k.kaczmarczyk@gmail.com	2026-04-14 15:10:01	106	f	2026-04-30 12:10:19
949	alex.k.kaczmarczyk@gmail.com	2026-04-14 15:20:01	92	f	2026-04-30 12:10:19
950	alex.k.kaczmarczyk@gmail.com	2026-04-14 15:30:01	115	f	2026-04-30 12:10:19
951	alex.k.kaczmarczyk@gmail.com	2026-04-14 15:40:02	140	f	2026-04-30 12:10:19
952	alex.k.kaczmarczyk@gmail.com	2026-04-14 15:50:01	121	f	2026-04-30 12:10:19
953	alex.k.kaczmarczyk@gmail.com	2026-04-14 16:00:02	101	f	2026-04-30 12:10:19
954	alex.k.kaczmarczyk@gmail.com	2026-04-14 16:10:02	103	f	2026-04-30 12:10:19
955	alex.k.kaczmarczyk@gmail.com	2026-04-14 16:20:00	95	f	2026-04-30 12:10:19
956	alex.k.kaczmarczyk@gmail.com	2026-04-14 16:30:01	92	f	2026-04-30 12:10:19
957	alex.k.kaczmarczyk@gmail.com	2026-04-14 16:40:00	103	f	2026-04-30 12:10:19
958	alex.k.kaczmarczyk@gmail.com	2026-04-14 16:50:01	107	f	2026-04-30 12:10:19
11	alex.k.kaczmarczyk@gmail.com	2026-04-06 01:50:09	53	t	2026-04-30 12:10:19
959	alex.k.kaczmarczyk@gmail.com	2026-04-14 17:00:01	107	f	2026-04-30 12:10:19
960	alex.k.kaczmarczyk@gmail.com	2026-04-14 17:10:01	95	f	2026-04-30 12:10:19
961	alex.k.kaczmarczyk@gmail.com	2026-04-14 17:20:01	121	f	2026-04-30 12:10:19
962	alex.k.kaczmarczyk@gmail.com	2026-04-14 17:30:02	116	f	2026-04-30 12:10:19
963	alex.k.kaczmarczyk@gmail.com	2026-04-14 17:40:01	113	f	2026-04-30 12:10:19
964	alex.k.kaczmarczyk@gmail.com	2026-04-14 17:50:00	89	f	2026-04-30 12:10:19
965	alex.k.kaczmarczyk@gmail.com	2026-04-14 18:00:00	75	f	2026-04-30 12:10:19
966	alex.k.kaczmarczyk@gmail.com	2026-04-14 18:10:01	99	f	2026-04-30 12:10:19
967	alex.k.kaczmarczyk@gmail.com	2026-04-14 18:20:01	96	f	2026-04-30 12:10:19
968	alex.k.kaczmarczyk@gmail.com	2026-04-14 18:30:01	71	f	2026-04-30 12:10:19
969	alex.k.kaczmarczyk@gmail.com	2026-04-14 18:40:01	69	f	2026-04-30 12:10:19
970	alex.k.kaczmarczyk@gmail.com	2026-04-14 18:50:01	95	f	2026-04-30 12:10:19
971	alex.k.kaczmarczyk@gmail.com	2026-04-14 19:00:01	98	f	2026-04-30 12:10:19
972	alex.k.kaczmarczyk@gmail.com	2026-04-14 19:10:01	110	f	2026-04-30 12:10:19
973	alex.k.kaczmarczyk@gmail.com	2026-04-14 19:20:00	74	f	2026-04-30 12:10:19
974	alex.k.kaczmarczyk@gmail.com	2026-04-14 19:30:00	110	f	2026-04-30 12:10:19
975	alex.k.kaczmarczyk@gmail.com	2026-04-20 06:10:01	82	f	2026-04-30 12:10:20
976	alex.k.kaczmarczyk@gmail.com	2026-04-20 06:20:00	59	t	2026-04-30 12:10:20
977	alex.k.kaczmarczyk@gmail.com	2026-04-20 06:30:01	67	f	2026-04-30 12:10:20
978	alex.k.kaczmarczyk@gmail.com	2026-04-20 06:40:01	64	t	2026-04-30 12:10:20
979	alex.k.kaczmarczyk@gmail.com	2026-04-20 06:50:00	53	t	2026-04-30 12:10:20
980	alex.k.kaczmarczyk@gmail.com	2026-04-20 07:00:01	84	f	2026-04-30 12:10:20
981	alex.k.kaczmarczyk@gmail.com	2026-04-20 07:10:00	92	f	2026-04-30 12:10:20
982	alex.k.kaczmarczyk@gmail.com	2026-04-20 07:20:02	66	f	2026-04-30 12:10:20
983	alex.k.kaczmarczyk@gmail.com	2026-04-20 07:30:00	85	f	2026-04-30 12:10:20
984	alex.k.kaczmarczyk@gmail.com	2026-04-20 07:40:00	81	f	2026-04-30 12:10:20
985	alex.k.kaczmarczyk@gmail.com	2026-04-20 07:50:00	77	f	2026-04-30 12:10:20
986	alex.k.kaczmarczyk@gmail.com	2026-04-20 08:00:00	71	f	2026-04-30 12:10:20
987	alex.k.kaczmarczyk@gmail.com	2026-04-20 08:10:00	72	f	2026-04-30 12:10:20
988	alex.k.kaczmarczyk@gmail.com	2026-04-20 08:20:01	57	t	2026-04-30 12:10:20
989	alex.k.kaczmarczyk@gmail.com	2026-04-20 08:30:01	64	t	2026-04-30 12:10:20
990	alex.k.kaczmarczyk@gmail.com	2026-04-20 08:40:01	62	t	2026-04-30 12:10:20
991	alex.k.kaczmarczyk@gmail.com	2026-04-20 08:50:01	78	f	2026-04-30 12:10:20
992	alex.k.kaczmarczyk@gmail.com	2026-04-20 09:00:01	65	f	2026-04-30 12:10:20
993	alex.k.kaczmarczyk@gmail.com	2026-04-20 09:10:01	57	t	2026-04-30 12:10:20
994	alex.k.kaczmarczyk@gmail.com	2026-04-20 09:20:01	69	f	2026-04-30 12:10:20
995	alex.k.kaczmarczyk@gmail.com	2026-04-20 09:30:01	76	f	2026-04-30 12:10:20
996	alex.k.kaczmarczyk@gmail.com	2026-04-20 09:40:01	66	f	2026-04-30 12:10:20
997	alex.k.kaczmarczyk@gmail.com	2026-04-20 09:50:01	71	f	2026-04-30 12:10:20
998	alex.k.kaczmarczyk@gmail.com	2026-04-20 10:00:02	62	t	2026-04-30 12:10:20
999	alex.k.kaczmarczyk@gmail.com	2026-04-20 10:10:00	82	f	2026-04-30 12:10:20
1000	alex.k.kaczmarczyk@gmail.com	2026-04-20 10:20:00	75	f	2026-04-30 12:10:20
1001	alex.k.kaczmarczyk@gmail.com	2026-04-20 10:30:00	65	f	2026-04-30 12:10:20
1002	alex.k.kaczmarczyk@gmail.com	2026-04-20 10:40:01	62	t	2026-04-30 12:10:20
1003	alex.k.kaczmarczyk@gmail.com	2026-04-20 10:50:00	62	t	2026-04-30 12:10:20
1004	alex.k.kaczmarczyk@gmail.com	2026-04-20 11:00:00	62	t	2026-04-30 12:10:20
1005	alex.k.kaczmarczyk@gmail.com	2026-04-20 11:10:01	64	t	2026-04-30 12:10:20
1006	alex.k.kaczmarczyk@gmail.com	2026-04-20 11:20:01	96	f	2026-04-30 12:10:20
1007	alex.k.kaczmarczyk@gmail.com	2026-04-20 11:30:01	76	f	2026-04-30 12:10:20
1008	alex.k.kaczmarczyk@gmail.com	2026-04-20 11:40:01	109	f	2026-04-30 12:10:20
1009	alex.k.kaczmarczyk@gmail.com	2026-04-20 11:50:02	74	f	2026-04-30 12:10:20
1010	alex.k.kaczmarczyk@gmail.com	2026-04-20 12:00:01	66	f	2026-04-30 12:10:20
1011	alex.k.kaczmarczyk@gmail.com	2026-04-20 12:10:01	66	f	2026-04-30 12:10:20
1012	alex.k.kaczmarczyk@gmail.com	2026-04-20 12:20:01	90	f	2026-04-30 12:10:20
1013	alex.k.kaczmarczyk@gmail.com	2026-04-20 12:30:00	74	f	2026-04-30 12:10:20
1014	alex.k.kaczmarczyk@gmail.com	2026-04-20 12:40:02	68	f	2026-04-30 12:10:20
1015	alex.k.kaczmarczyk@gmail.com	2026-04-20 12:50:01	68	f	2026-04-30 12:10:20
1016	alex.k.kaczmarczyk@gmail.com	2026-04-20 13:00:00	68	f	2026-04-30 12:10:20
1017	alex.k.kaczmarczyk@gmail.com	2026-04-20 13:10:00	75	f	2026-04-30 12:10:20
1018	alex.k.kaczmarczyk@gmail.com	2026-04-20 13:20:00	65	f	2026-04-30 12:10:20
1019	alex.k.kaczmarczyk@gmail.com	2026-04-20 13:30:00	64	t	2026-04-30 12:10:20
1020	alex.k.kaczmarczyk@gmail.com	2026-04-20 13:40:01	83	f	2026-04-30 12:10:20
1021	alex.k.kaczmarczyk@gmail.com	2026-04-20 13:50:01	91	f	2026-04-30 12:10:20
1022	alex.k.kaczmarczyk@gmail.com	2026-04-20 14:00:01	68	f	2026-04-30 12:10:20
1023	alex.k.kaczmarczyk@gmail.com	2026-04-20 14:10:01	70	f	2026-04-30 12:10:20
1024	alex.k.kaczmarczyk@gmail.com	2026-04-20 14:20:01	80	f	2026-04-30 12:10:20
1025	alex.k.kaczmarczyk@gmail.com	2026-04-20 14:30:00	71	f	2026-04-30 12:10:20
1026	alex.k.kaczmarczyk@gmail.com	2026-04-20 14:40:00	104	f	2026-04-30 12:10:20
1027	alex.k.kaczmarczyk@gmail.com	2026-04-20 14:50:01	100	f	2026-04-30 12:10:20
1028	alex.k.kaczmarczyk@gmail.com	2026-04-20 15:00:00	83	f	2026-04-30 12:10:20
1029	alex.k.kaczmarczyk@gmail.com	2026-04-20 15:10:00	118	f	2026-04-30 12:10:20
1030	alex.k.kaczmarczyk@gmail.com	2026-04-20 15:20:01	73	f	2026-04-30 12:10:20
1031	alex.k.kaczmarczyk@gmail.com	2026-04-20 15:30:00	92	f	2026-04-30 12:10:20
1032	alex.k.kaczmarczyk@gmail.com	2026-04-20 15:40:01	81	f	2026-04-30 12:10:20
1033	alex.k.kaczmarczyk@gmail.com	2026-04-20 15:50:01	97	f	2026-04-30 12:10:20
1034	alex.k.kaczmarczyk@gmail.com	2026-04-20 16:00:01	92	f	2026-04-30 12:10:20
1035	alex.k.kaczmarczyk@gmail.com	2026-04-20 16:10:01	84	f	2026-04-30 12:10:20
1036	alex.k.kaczmarczyk@gmail.com	2026-04-20 16:20:01	84	f	2026-04-30 12:10:20
1037	alex.k.kaczmarczyk@gmail.com	2026-04-20 16:30:01	94	f	2026-04-30 12:10:20
1038	alex.k.kaczmarczyk@gmail.com	2026-04-20 16:40:01	71	f	2026-04-30 12:10:20
1039	alex.k.kaczmarczyk@gmail.com	2026-04-20 16:50:01	109	f	2026-04-30 12:10:20
1040	alex.k.kaczmarczyk@gmail.com	2026-04-20 17:00:00	94	f	2026-04-30 12:10:20
1041	alex.k.kaczmarczyk@gmail.com	2026-04-20 17:10:00	71	f	2026-04-30 12:10:20
1042	alex.k.kaczmarczyk@gmail.com	2026-04-20 17:20:00	68	f	2026-04-30 12:10:20
1043	alex.k.kaczmarczyk@gmail.com	2026-04-20 17:30:01	64	t	2026-04-30 12:10:20
1044	alex.k.kaczmarczyk@gmail.com	2026-04-20 17:40:01	62	t	2026-04-30 12:10:20
1045	alex.k.kaczmarczyk@gmail.com	2026-04-20 17:50:01	102	f	2026-04-30 12:10:20
12	alex.k.kaczmarczyk@gmail.com	2026-04-06 02:00:15	55	t	2026-04-30 12:10:19
1046	alex.k.kaczmarczyk@gmail.com	2026-04-20 18:00:01	77	f	2026-04-30 12:10:20
1047	alex.k.kaczmarczyk@gmail.com	2026-04-20 18:10:01	82	f	2026-04-30 12:10:20
1048	alex.k.kaczmarczyk@gmail.com	2026-04-20 18:20:00	65	f	2026-04-30 12:10:20
1049	alex.k.kaczmarczyk@gmail.com	2026-04-20 18:30:02	76	f	2026-04-30 12:10:20
1050	alex.k.kaczmarczyk@gmail.com	2026-04-20 18:40:01	81	f	2026-04-30 12:10:20
1051	alex.k.kaczmarczyk@gmail.com	2026-04-20 18:50:01	79	f	2026-04-30 12:10:20
1052	alex.k.kaczmarczyk@gmail.com	2026-04-20 23:30:00	85	f	2026-04-30 12:10:20
1053	alex.k.kaczmarczyk@gmail.com	2026-04-20 23:40:01	47	t	2026-04-30 12:10:20
1054	alex.k.kaczmarczyk@gmail.com	2026-04-20 23:50:00	50	t	2026-04-30 12:10:20
1055	alex.k.kaczmarczyk@gmail.com	2026-04-21 00:00:22	49	t	2026-04-30 12:10:20
1056	alex.k.kaczmarczyk@gmail.com	2026-04-21 00:10:20	50	t	2026-04-30 12:10:20
1057	alex.k.kaczmarczyk@gmail.com	2026-04-21 00:20:16	51	t	2026-04-30 12:10:20
1058	alex.k.kaczmarczyk@gmail.com	2026-04-21 00:30:10	56	t	2026-04-30 12:10:20
1059	alex.k.kaczmarczyk@gmail.com	2026-04-21 00:40:11	56	t	2026-04-30 12:10:20
1060	alex.k.kaczmarczyk@gmail.com	2026-04-21 00:50:14	53	t	2026-04-30 12:10:20
1061	alex.k.kaczmarczyk@gmail.com	2026-04-21 01:00:08	60	t	2026-04-30 12:10:20
1062	alex.k.kaczmarczyk@gmail.com	2026-04-21 01:10:09	53	t	2026-04-30 12:10:20
1063	alex.k.kaczmarczyk@gmail.com	2026-04-21 01:20:10	69	t	2026-04-30 12:10:20
1064	alex.k.kaczmarczyk@gmail.com	2026-04-21 01:30:16	51	t	2026-04-30 12:10:20
1065	alex.k.kaczmarczyk@gmail.com	2026-04-21 01:40:09	49	t	2026-04-30 12:10:20
1066	alex.k.kaczmarczyk@gmail.com	2026-04-21 01:50:13	49	t	2026-04-30 12:10:20
1067	alex.k.kaczmarczyk@gmail.com	2026-04-21 02:00:20	49	t	2026-04-30 12:10:20
1068	alex.k.kaczmarczyk@gmail.com	2026-04-21 02:10:15	85	f	2026-04-30 12:10:20
1069	alex.k.kaczmarczyk@gmail.com	2026-04-21 02:20:15	52	t	2026-04-30 12:10:20
1070	alex.k.kaczmarczyk@gmail.com	2026-04-21 02:30:09	57	t	2026-04-30 12:10:20
1071	alex.k.kaczmarczyk@gmail.com	2026-04-21 02:40:21	52	t	2026-04-30 12:10:20
1072	alex.k.kaczmarczyk@gmail.com	2026-04-21 02:50:20	47	t	2026-04-30 12:10:20
1073	alex.k.kaczmarczyk@gmail.com	2026-04-21 03:00:21	79	t	2026-04-30 12:10:20
1074	alex.k.kaczmarczyk@gmail.com	2026-04-21 03:10:14	46	t	2026-04-30 12:10:20
1075	alex.k.kaczmarczyk@gmail.com	2026-04-21 03:20:19	45	t	2026-04-30 12:10:20
1076	alex.k.kaczmarczyk@gmail.com	2026-04-21 03:30:21	49	t	2026-04-30 12:10:20
1077	alex.k.kaczmarczyk@gmail.com	2026-04-21 03:40:21	49	t	2026-04-30 12:10:20
1078	alex.k.kaczmarczyk@gmail.com	2026-04-21 03:50:21	50	t	2026-04-30 12:10:20
1079	alex.k.kaczmarczyk@gmail.com	2026-04-21 04:00:21	51	t	2026-04-30 12:10:20
1080	alex.k.kaczmarczyk@gmail.com	2026-04-21 04:10:20	52	t	2026-04-30 12:10:20
1081	alex.k.kaczmarczyk@gmail.com	2026-04-21 04:20:09	55	t	2026-04-30 12:10:20
1082	alex.k.kaczmarczyk@gmail.com	2026-04-21 04:30:16	51	t	2026-04-30 12:10:20
1083	alex.k.kaczmarczyk@gmail.com	2026-04-21 04:40:09	49	t	2026-04-30 12:10:20
1084	alex.k.kaczmarczyk@gmail.com	2026-04-21 04:50:09	52	t	2026-04-30 12:10:20
1085	alex.k.kaczmarczyk@gmail.com	2026-04-21 05:00:09	53	t	2026-04-30 12:10:20
1086	alex.k.kaczmarczyk@gmail.com	2026-04-21 05:10:21	51	t	2026-04-30 12:10:20
1087	alex.k.kaczmarczyk@gmail.com	2026-04-21 05:20:21	52	t	2026-04-30 12:10:20
1088	alex.k.kaczmarczyk@gmail.com	2026-04-21 05:30:19	45	t	2026-04-30 12:10:20
1089	alex.k.kaczmarczyk@gmail.com	2026-04-21 05:40:18	50	t	2026-04-30 12:10:20
1090	alex.k.kaczmarczyk@gmail.com	2026-04-21 05:50:20	47	t	2026-04-30 12:10:20
1091	alex.k.kaczmarczyk@gmail.com	2026-04-21 06:00:20	93	f	2026-04-30 12:10:20
1092	alex.k.kaczmarczyk@gmail.com	2026-04-21 06:10:08	56	t	2026-04-30 12:10:20
1093	alex.k.kaczmarczyk@gmail.com	2026-04-21 06:20:21	78	f	2026-04-30 12:10:20
1094	alex.k.kaczmarczyk@gmail.com	2026-04-21 06:30:20	84	f	2026-04-30 12:10:20
1095	alex.k.kaczmarczyk@gmail.com	2026-04-21 06:40:12	57	t	2026-04-30 12:10:20
1096	alex.k.kaczmarczyk@gmail.com	2026-04-21 06:50:08	54	t	2026-04-30 12:10:20
1097	alex.k.kaczmarczyk@gmail.com	2026-04-21 07:00:21	59	t	2026-04-30 12:10:20
1098	alex.k.kaczmarczyk@gmail.com	2026-04-21 07:10:20	101	f	2026-04-30 12:10:20
1099	alex.k.kaczmarczyk@gmail.com	2026-04-21 07:40:00	99	f	2026-04-30 12:10:20
1100	alex.k.kaczmarczyk@gmail.com	2026-04-21 07:50:01	90	f	2026-04-30 12:10:20
1101	alex.k.kaczmarczyk@gmail.com	2026-04-21 08:00:01	96	f	2026-04-30 12:10:20
1102	alex.k.kaczmarczyk@gmail.com	2026-04-21 08:10:01	83	f	2026-04-30 12:10:20
1103	alex.k.kaczmarczyk@gmail.com	2026-04-21 08:20:01	93	f	2026-04-30 12:10:20
1104	alex.k.kaczmarczyk@gmail.com	2026-04-21 08:30:02	77	f	2026-04-30 12:10:20
1105	alex.k.kaczmarczyk@gmail.com	2026-04-21 08:40:01	91	f	2026-04-30 12:10:20
1106	alex.k.kaczmarczyk@gmail.com	2026-04-21 08:50:01	82	f	2026-04-30 12:10:20
1107	alex.k.kaczmarczyk@gmail.com	2026-04-21 09:00:01	92	f	2026-04-30 12:10:20
1108	alex.k.kaczmarczyk@gmail.com	2026-04-21 09:10:01	69	f	2026-04-30 12:10:20
1109	alex.k.kaczmarczyk@gmail.com	2026-04-21 09:20:00	100	f	2026-04-30 12:10:20
1110	alex.k.kaczmarczyk@gmail.com	2026-04-21 09:30:00	95	f	2026-04-30 12:10:20
1111	alex.k.kaczmarczyk@gmail.com	2026-04-21 09:40:00	94	f	2026-04-30 12:10:20
1112	alex.k.kaczmarczyk@gmail.com	2026-04-21 09:50:01	90	f	2026-04-30 12:10:20
1113	alex.k.kaczmarczyk@gmail.com	2026-04-21 10:00:01	69	f	2026-04-30 12:10:20
1114	alex.k.kaczmarczyk@gmail.com	2026-04-21 10:10:01	66	f	2026-04-30 12:10:20
1115	alex.k.kaczmarczyk@gmail.com	2026-04-21 10:20:01	59	t	2026-04-30 12:10:20
1116	alex.k.kaczmarczyk@gmail.com	2026-04-21 10:30:01	66	f	2026-04-30 12:10:20
1117	alex.k.kaczmarczyk@gmail.com	2026-04-21 10:40:00	77	f	2026-04-30 12:10:20
1118	alex.k.kaczmarczyk@gmail.com	2026-04-21 10:50:01	62	t	2026-04-30 12:10:20
1119	alex.k.kaczmarczyk@gmail.com	2026-04-21 11:00:01	75	f	2026-04-30 12:10:20
1120	alex.k.kaczmarczyk@gmail.com	2026-04-21 11:10:01	70	f	2026-04-30 12:10:20
1121	alex.k.kaczmarczyk@gmail.com	2026-04-21 11:20:01	88	f	2026-04-30 12:10:20
1122	alex.k.kaczmarczyk@gmail.com	2026-04-21 11:30:00	125	f	2026-04-30 12:10:20
1123	alex.k.kaczmarczyk@gmail.com	2026-04-21 11:40:01	87	f	2026-04-30 12:10:20
1124	alex.k.kaczmarczyk@gmail.com	2026-04-21 11:50:00	98	f	2026-04-30 12:10:20
1125	alex.k.kaczmarczyk@gmail.com	2026-04-21 12:00:01	95	f	2026-04-30 12:10:20
1126	alex.k.kaczmarczyk@gmail.com	2026-04-21 12:10:01	80	f	2026-04-30 12:10:20
1127	alex.k.kaczmarczyk@gmail.com	2026-04-21 12:20:01	78	f	2026-04-30 12:10:20
1128	alex.k.kaczmarczyk@gmail.com	2026-04-21 12:30:01	75	f	2026-04-30 12:10:20
1129	alex.k.kaczmarczyk@gmail.com	2026-04-21 12:40:01	78	f	2026-04-30 12:10:20
1130	alex.k.kaczmarczyk@gmail.com	2026-04-21 12:50:00	93	f	2026-04-30 12:10:20
1131	alex.k.kaczmarczyk@gmail.com	2026-04-21 13:00:00	75	f	2026-04-30 12:10:20
1132	alex.k.kaczmarczyk@gmail.com	2026-04-21 13:10:00	68	f	2026-04-30 12:10:20
13	alex.k.kaczmarczyk@gmail.com	2026-04-06 02:10:10	51	t	2026-04-30 12:10:19
1133	alex.k.kaczmarczyk@gmail.com	2026-04-21 13:20:01	73	f	2026-04-30 12:10:20
1134	alex.k.kaczmarczyk@gmail.com	2026-04-21 13:30:01	68	f	2026-04-30 12:10:20
1135	alex.k.kaczmarczyk@gmail.com	2026-04-21 13:40:00	67	f	2026-04-30 12:10:20
1136	alex.k.kaczmarczyk@gmail.com	2026-04-21 13:50:00	65	f	2026-04-30 12:10:20
1137	alex.k.kaczmarczyk@gmail.com	2026-04-21 14:00:01	66	f	2026-04-30 12:10:20
1138	alex.k.kaczmarczyk@gmail.com	2026-04-21 14:10:00	71	f	2026-04-30 12:10:20
1139	alex.k.kaczmarczyk@gmail.com	2026-04-21 14:20:01	99	f	2026-04-30 12:10:20
1140	alex.k.kaczmarczyk@gmail.com	2026-04-21 14:30:01	62	t	2026-04-30 12:10:20
1141	alex.k.kaczmarczyk@gmail.com	2026-04-21 14:40:01	98	f	2026-04-30 12:10:20
1142	alex.k.kaczmarczyk@gmail.com	2026-04-21 14:50:02	64	t	2026-04-30 12:10:20
1143	alex.k.kaczmarczyk@gmail.com	2026-04-21 15:00:01	72	f	2026-04-30 12:10:20
1144	alex.k.kaczmarczyk@gmail.com	2026-04-21 15:10:02	109	f	2026-04-30 12:10:20
1145	alex.k.kaczmarczyk@gmail.com	2026-04-21 15:20:02	69	f	2026-04-30 12:10:20
1146	alex.k.kaczmarczyk@gmail.com	2026-04-21 15:30:01	69	f	2026-04-30 12:10:20
1147	alex.k.kaczmarczyk@gmail.com	2026-04-21 15:40:02	69	f	2026-04-30 12:10:20
1148	alex.k.kaczmarczyk@gmail.com	2026-04-21 15:50:01	109	f	2026-04-30 12:10:20
1149	alex.k.kaczmarczyk@gmail.com	2026-04-21 16:00:01	87	f	2026-04-30 12:10:20
1150	alex.k.kaczmarczyk@gmail.com	2026-04-21 16:10:01	80	f	2026-04-30 12:10:20
1151	alex.k.kaczmarczyk@gmail.com	2026-04-21 16:20:01	77	f	2026-04-30 12:10:20
1152	alex.k.kaczmarczyk@gmail.com	2026-04-21 16:30:01	79	f	2026-04-30 12:10:20
1153	alex.k.kaczmarczyk@gmail.com	2026-04-21 16:40:01	64	t	2026-04-30 12:10:20
1154	alex.k.kaczmarczyk@gmail.com	2026-04-21 16:50:02	70	f	2026-04-30 12:10:20
1155	alex.k.kaczmarczyk@gmail.com	2026-04-21 17:00:02	68	f	2026-04-30 12:10:20
1156	alex.k.kaczmarczyk@gmail.com	2026-04-21 17:10:01	71	f	2026-04-30 12:10:20
1157	alex.k.kaczmarczyk@gmail.com	2026-04-21 17:20:02	72	f	2026-04-30 12:10:20
1158	alex.k.kaczmarczyk@gmail.com	2026-04-21 17:30:02	66	f	2026-04-30 12:10:20
1159	alex.k.kaczmarczyk@gmail.com	2026-04-21 18:50:08	98	f	2026-04-30 12:10:20
1160	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:00:02	113	f	2026-04-30 12:10:20
1161	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:10:01	101	f	2026-04-30 12:10:20
1162	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:20:02	91	f	2026-04-30 12:10:20
1163	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:24:00	88	f	2026-04-30 12:10:20
1164	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:25:00	82	f	2026-04-30 12:10:20
1165	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:26:00	76	f	2026-04-30 12:10:20
1166	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:27:00	94	f	2026-04-30 12:10:20
1167	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:28:00	96	f	2026-04-30 12:10:20
1168	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:29:00	83	f	2026-04-30 12:10:20
1169	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:31:00	89	f	2026-04-30 12:10:20
1170	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:32:00	116	f	2026-04-30 12:10:20
1171	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:33:00	122	f	2026-04-30 12:10:20
1173	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:34:00	112	f	2026-04-30 12:10:20
1174	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:35:00	105	f	2026-04-30 12:10:20
1175	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:36:00	114	f	2026-04-30 12:10:20
1176	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:37:00	118	f	2026-04-30 12:10:20
1177	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:38:00	104	f	2026-04-30 12:10:20
1178	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:39:00	99	f	2026-04-30 12:10:20
1179	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:41:00	96	f	2026-04-30 12:10:20
1180	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:42:00	111	f	2026-04-30 12:10:20
1182	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:44:00	98	f	2026-04-30 12:10:20
1184	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:45:00	91	f	2026-04-30 12:10:20
1185	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:46:00	98	f	2026-04-30 12:10:20
1186	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:47:00	107	f	2026-04-30 12:10:20
1187	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:48:00	116	f	2026-04-30 12:10:20
1188	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:49:00	117	f	2026-04-30 12:10:20
1189	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:50:00	108	f	2026-04-30 12:10:20
1190	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:51:00	109	f	2026-04-30 12:10:20
1191	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:52:00	117	f	2026-04-30 12:10:20
1192	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:53:00	112	f	2026-04-30 12:10:20
1193	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:54:00	116	f	2026-04-30 12:10:20
1194	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:55:00	113	f	2026-04-30 12:10:20
1195	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:56:00	118	f	2026-04-30 12:10:20
1196	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:57:00	108	f	2026-04-30 12:10:20
1197	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:58:00	98	f	2026-04-30 12:10:20
1198	alex.k.kaczmarczyk@gmail.com	2026-04-21 19:59:00	97	f	2026-04-30 12:10:20
1199	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:00:00	112	f	2026-04-30 12:10:20
1200	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:01:00	108	f	2026-04-30 12:10:20
1201	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:02:00	104	f	2026-04-30 12:10:20
1202	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:03:00	103	f	2026-04-30 12:10:20
1203	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:04:00	100	f	2026-04-30 12:10:20
1204	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:05:00	121	f	2026-04-30 12:10:20
1205	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:06:00	104	f	2026-04-30 12:10:20
1206	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:07:00	104	f	2026-04-30 12:10:20
1207	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:08:00	101	f	2026-04-30 12:10:20
1208	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:09:00	103	f	2026-04-30 12:10:20
1209	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:10:00	107	f	2026-04-30 12:10:20
1210	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:11:00	125	f	2026-04-30 12:10:20
1211	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:12:00	117	f	2026-04-30 12:10:20
1212	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:13:00	113	f	2026-04-30 12:10:20
1213	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:14:00	98	f	2026-04-30 12:10:20
1214	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:15:00	105	f	2026-04-30 12:10:20
1215	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:16:00	98	f	2026-04-30 12:10:20
1216	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:17:00	123	f	2026-04-30 12:10:20
1217	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:18:00	107	f	2026-04-30 12:10:20
1218	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:19:00	101	f	2026-04-30 12:10:20
1219	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:20:00	101	f	2026-04-30 12:10:20
1220	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:21:00	105	f	2026-04-30 12:10:20
1221	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:22:00	107	f	2026-04-30 12:10:20
1222	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:23:00	104	f	2026-04-30 12:10:20
14	alex.k.kaczmarczyk@gmail.com	2026-04-06 02:20:08	58	t	2026-04-30 12:10:19
1223	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:24:00	102	f	2026-04-30 12:10:20
1224	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:25:00	110	f	2026-04-30 12:10:20
1225	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:26:00	117	f	2026-04-30 12:10:20
1226	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:27:00	111	f	2026-04-30 12:10:20
1227	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:28:00	120	f	2026-04-30 12:10:20
1228	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:29:00	125	f	2026-04-30 12:10:20
1229	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:30:00	119	f	2026-04-30 12:10:20
1230	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:31:00	100	f	2026-04-30 12:10:20
1231	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:32:00	95	f	2026-04-30 12:10:20
1232	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:33:00	95	f	2026-04-30 12:10:20
1233	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:34:00	113	f	2026-04-30 12:10:20
1234	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:35:00	120	f	2026-04-30 12:10:20
1235	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:36:00	115	f	2026-04-30 12:10:20
1236	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:37:00	109	f	2026-04-30 12:10:20
1238	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:38:00	102	f	2026-04-30 12:10:20
1239	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:39:00	103	f	2026-04-30 12:10:20
1240	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:41:00	101	f	2026-04-30 12:10:20
1241	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:42:00	93	f	2026-04-30 12:10:20
1242	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:43:00	90	f	2026-04-30 12:10:20
1243	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:44:00	91	f	2026-04-30 12:10:20
1244	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:45:00	92	f	2026-04-30 12:10:20
1245	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:46:00	93	f	2026-04-30 12:10:20
1246	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:47:00	105	f	2026-04-30 12:10:20
1248	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:48:00	106	f	2026-04-30 12:10:20
1249	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:50:00	102	f	2026-04-30 12:10:20
1250	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:51:00	113	f	2026-04-30 12:10:20
1251	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:52:00	98	f	2026-04-30 12:10:20
1252	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:53:00	103	f	2026-04-30 12:10:20
1254	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:55:00	100	f	2026-04-30 12:10:20
1255	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:56:00	97	f	2026-04-30 12:10:20
1257	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:57:00	101	f	2026-04-30 12:10:20
1258	alex.k.kaczmarczyk@gmail.com	2026-04-21 20:59:00	117	f	2026-04-30 12:10:20
1259	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:00:00	120	f	2026-04-30 12:10:20
1261	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:01:00	116	f	2026-04-30 12:10:20
1262	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:02:00	113	f	2026-04-30 12:10:20
1263	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:03:00	108	f	2026-04-30 12:10:20
1264	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:04:00	107	f	2026-04-30 12:10:20
1265	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:05:00	101	f	2026-04-30 12:10:20
1266	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:06:00	97	f	2026-04-30 12:10:20
1267	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:07:00	101	f	2026-04-30 12:10:20
1268	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:08:00	100	f	2026-04-30 12:10:20
1269	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:09:00	97	f	2026-04-30 12:10:20
1270	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:10:00	100	f	2026-04-30 12:10:20
1271	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:12:00	92	f	2026-04-30 12:10:20
1273	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:13:00	81	f	2026-04-30 12:10:20
1274	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:14:00	92	f	2026-04-30 12:10:20
1275	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:15:00	91	f	2026-04-30 12:10:20
1276	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:16:00	103	f	2026-04-30 12:10:20
1277	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:17:00	108	f	2026-04-30 12:10:20
1278	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:19:00	111	f	2026-04-30 12:10:20
1280	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:20:00	86	f	2026-04-30 12:10:20
1281	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:21:00	83	f	2026-04-30 12:10:20
1282	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:22:00	82	f	2026-04-30 12:10:20
1283	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:24:00	86	f	2026-04-30 12:10:20
1284	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:25:00	85	f	2026-04-30 12:10:20
1285	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:26:00	86	f	2026-04-30 12:10:20
1286	alex.k.kaczmarczyk@gmail.com	2026-04-21 21:27:00	86	f	2026-04-30 12:10:20
1287	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:32:00	94	f	2026-04-30 12:10:20
1288	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:33:00	77	f	2026-04-30 12:10:20
1289	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:34:00	88	f	2026-04-30 12:10:20
1290	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:35:00	80	f	2026-04-30 12:10:20
1291	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:36:00	85	f	2026-04-30 12:10:20
1292	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:37:00	93	f	2026-04-30 12:10:20
1293	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:38:00	97	f	2026-04-30 12:10:20
1294	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:39:00	88	f	2026-04-30 12:10:20
1295	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:40:00	73	f	2026-04-30 12:10:20
1296	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:41:00	66	f	2026-04-30 12:10:20
1297	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:42:00	66	f	2026-04-30 12:10:20
1298	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:43:00	62	t	2026-04-30 12:10:20
1299	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:44:00	66	f	2026-04-30 12:10:20
1300	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:45:00	61	t	2026-04-30 12:10:20
1301	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:46:00	64	t	2026-04-30 12:10:20
1302	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:47:00	70	f	2026-04-30 12:10:20
1303	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:48:00	68	f	2026-04-30 12:10:20
1304	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:49:00	71	f	2026-04-30 12:10:20
1305	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:50:00	70	f	2026-04-30 12:10:20
1306	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:51:00	64	t	2026-04-30 12:10:20
1307	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:52:00	64	t	2026-04-30 12:10:20
1308	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:53:00	69	f	2026-04-30 12:10:20
1309	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:54:00	67	f	2026-04-30 12:10:20
1310	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:55:00	65	f	2026-04-30 12:10:20
1311	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:56:00	68	f	2026-04-30 12:10:20
1312	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:57:00	68	f	2026-04-30 12:10:20
1313	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:58:00	67	f	2026-04-30 12:10:20
1314	alex.k.kaczmarczyk@gmail.com	2026-04-22 06:59:00	68	f	2026-04-30 12:10:20
1315	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:00:00	64	t	2026-04-30 12:10:20
1316	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:01:00	66	f	2026-04-30 12:10:20
15	alex.k.kaczmarczyk@gmail.com	2026-04-06 02:30:09	50	t	2026-04-30 12:10:19
1317	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:02:00	65	f	2026-04-30 12:10:20
1318	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:03:00	65	f	2026-04-30 12:10:20
1319	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:04:00	69	f	2026-04-30 12:10:20
1320	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:05:00	68	f	2026-04-30 12:10:20
1321	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:06:00	76	f	2026-04-30 12:10:20
1322	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:07:00	67	f	2026-04-30 12:10:20
1323	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:08:00	62	t	2026-04-30 12:10:20
1324	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:09:00	62	t	2026-04-30 12:10:20
1325	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:10:00	61	t	2026-04-30 12:10:20
1326	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:11:00	61	t	2026-04-30 12:10:20
1327	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:12:00	68	f	2026-04-30 12:10:20
1328	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:13:00	71	f	2026-04-30 12:10:20
1329	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:14:00	75	f	2026-04-30 12:10:20
1330	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:15:00	71	f	2026-04-30 12:10:20
1331	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:16:00	70	f	2026-04-30 12:10:20
1332	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:17:00	63	t	2026-04-30 12:10:20
1333	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:18:00	62	t	2026-04-30 12:10:20
1334	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:19:00	65	f	2026-04-30 12:10:20
1335	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:20:00	69	f	2026-04-30 12:10:20
1336	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:21:00	83	f	2026-04-30 12:10:20
1337	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:22:00	93	f	2026-04-30 12:10:20
1338	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:23:00	69	f	2026-04-30 12:10:20
1339	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:24:00	58	t	2026-04-30 12:10:20
1340	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:25:00	59	t	2026-04-30 12:10:20
1341	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:26:00	57	t	2026-04-30 12:10:20
1342	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:27:00	58	t	2026-04-30 12:10:20
1343	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:28:00	58	t	2026-04-30 12:10:20
1344	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:29:00	57	t	2026-04-30 12:10:20
1345	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:30:00	62	t	2026-04-30 12:10:20
1346	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:31:00	61	t	2026-04-30 12:10:20
1347	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:32:00	61	t	2026-04-30 12:10:20
1348	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:33:00	62	t	2026-04-30 12:10:20
1349	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:34:00	60	t	2026-04-30 12:10:20
1350	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:35:00	63	t	2026-04-30 12:10:20
1351	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:36:00	67	f	2026-04-30 12:10:20
1352	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:37:00	77	f	2026-04-30 12:10:20
1353	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:38:00	64	t	2026-04-30 12:10:20
1354	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:39:00	63	t	2026-04-30 12:10:20
1355	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:40:00	64	t	2026-04-30 12:10:20
1356	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:41:00	80	f	2026-04-30 12:10:20
1357	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:42:00	86	f	2026-04-30 12:10:20
1358	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:43:00	83	f	2026-04-30 12:10:20
1359	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:44:00	77	f	2026-04-30 12:10:20
1360	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:45:00	74	f	2026-04-30 12:10:20
1361	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:46:00	70	f	2026-04-30 12:10:20
1362	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:47:00	72	f	2026-04-30 12:10:20
1363	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:48:00	84	f	2026-04-30 12:10:20
1364	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:49:00	59	t	2026-04-30 12:10:20
1365	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:50:00	57	t	2026-04-30 12:10:20
1366	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:51:00	59	t	2026-04-30 12:10:20
1367	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:52:00	61	t	2026-04-30 12:10:20
1368	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:53:00	69	f	2026-04-30 12:10:20
1369	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:54:00	69	f	2026-04-30 12:10:20
1370	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:55:00	64	t	2026-04-30 12:10:20
1371	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:56:00	64	t	2026-04-30 12:10:20
1372	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:57:00	65	f	2026-04-30 12:10:20
1374	alex.k.kaczmarczyk@gmail.com	2026-04-22 07:58:00	61	t	2026-04-30 12:10:20
1375	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:00:00	66	f	2026-04-30 12:10:20
1377	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:01:00	99	f	2026-04-30 12:10:20
1378	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:03:00	87	f	2026-04-30 12:10:20
1379	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:04:00	85	f	2026-04-30 12:10:20
1380	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:05:00	91	f	2026-04-30 12:10:20
1381	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:06:00	94	f	2026-04-30 12:10:20
1382	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:07:00	94	f	2026-04-30 12:10:20
1383	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:08:00	93	f	2026-04-30 12:10:20
1384	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:09:00	89	f	2026-04-30 12:10:20
1385	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:10:00	89	f	2026-04-30 12:10:20
1386	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:11:00	94	f	2026-04-30 12:10:20
1388	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:13:00	85	f	2026-04-30 12:10:20
1389	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:14:00	91	f	2026-04-30 12:10:20
1390	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:15:00	93	f	2026-04-30 12:10:20
1391	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:16:00	94	f	2026-04-30 12:10:20
1392	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:17:00	93	f	2026-04-30 12:10:20
1394	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:18:00	113	f	2026-04-30 12:10:20
1395	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:19:00	105	f	2026-04-30 12:10:20
1396	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:20:00	102	f	2026-04-30 12:10:20
1397	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:21:00	61	t	2026-04-30 12:10:20
1398	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:22:00	61	t	2026-04-30 12:10:20
1399	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:23:00	66	f	2026-04-30 12:10:20
1400	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:24:00	70	f	2026-04-30 12:10:20
1401	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:25:00	70	f	2026-04-30 12:10:20
1402	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:26:00	72	f	2026-04-30 12:10:20
1403	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:27:00	70	f	2026-04-30 12:10:20
1404	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:28:00	71	f	2026-04-30 12:10:20
1405	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:30:00	72	f	2026-04-30 12:10:20
1406	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:31:00	70	f	2026-04-30 12:10:20
1407	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:32:00	74	f	2026-04-30 12:10:20
16	alex.k.kaczmarczyk@gmail.com	2026-04-06 02:40:09	50	t	2026-04-30 12:10:19
1408	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:33:00	76	f	2026-04-30 12:10:20
1409	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:34:00	78	f	2026-04-30 12:10:20
1411	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:35:00	68	f	2026-04-30 12:10:20
1412	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:36:00	69	f	2026-04-30 12:10:20
1413	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:37:00	74	f	2026-04-30 12:10:20
1414	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:39:00	69	f	2026-04-30 12:10:20
1415	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:40:00	67	f	2026-04-30 12:10:20
1416	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:41:00	65	f	2026-04-30 12:10:20
1417	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:42:00	78	f	2026-04-30 12:10:20
1418	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:43:00	77	f	2026-04-30 12:10:20
1419	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:44:00	86	f	2026-04-30 12:10:20
1421	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:45:00	71	f	2026-04-30 12:10:20
1422	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:47:00	73	f	2026-04-30 12:10:20
1424	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:49:00	79	f	2026-04-30 12:10:20
1425	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:50:00	76	f	2026-04-30 12:10:20
1427	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:51:00	67	f	2026-04-30 12:10:20
1428	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:52:00	66	f	2026-04-30 12:10:20
1429	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:53:00	67	f	2026-04-30 12:10:20
1430	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:54:00	67	f	2026-04-30 12:10:20
1431	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:55:00	68	f	2026-04-30 12:10:20
1432	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:57:00	69	f	2026-04-30 12:10:20
1433	alex.k.kaczmarczyk@gmail.com	2026-04-22 08:58:00	67	f	2026-04-30 12:10:20
1435	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:01:00	60	t	2026-04-30 12:10:20
1437	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:02:00	62	t	2026-04-30 12:10:20
1438	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:03:00	62	t	2026-04-30 12:10:20
1439	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:04:00	62	t	2026-04-30 12:10:20
1440	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:05:00	64	t	2026-04-30 12:10:20
1441	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:06:00	65	f	2026-04-30 12:10:20
1442	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:07:00	66	f	2026-04-30 12:10:20
1443	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:08:00	70	f	2026-04-30 12:10:20
1444	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:10:00	75	f	2026-04-30 12:10:20
1446	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:11:00	71	f	2026-04-30 12:10:20
1447	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:12:00	70	f	2026-04-30 12:10:20
1448	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:13:00	65	f	2026-04-30 12:10:20
1449	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:14:00	72	f	2026-04-30 12:10:20
1450	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:16:00	70	f	2026-04-30 12:10:20
1451	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:17:00	68	f	2026-04-30 12:10:20
1453	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:18:00	66	f	2026-04-30 12:10:20
1454	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:19:00	62	t	2026-04-30 12:10:20
1455	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:20:00	63	t	2026-04-30 12:10:20
1456	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:21:00	65	f	2026-04-30 12:10:20
1457	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:22:00	65	f	2026-04-30 12:10:20
1458	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:23:00	65	f	2026-04-30 12:10:20
1459	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:24:00	63	t	2026-04-30 12:10:20
1460	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:25:00	65	f	2026-04-30 12:10:20
1461	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:26:00	67	f	2026-04-30 12:10:20
1462	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:27:00	62	t	2026-04-30 12:10:20
1463	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:29:00	65	f	2026-04-30 12:10:20
1464	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:30:00	62	t	2026-04-30 12:10:20
1466	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:31:00	66	f	2026-04-30 12:10:20
1467	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:32:00	67	f	2026-04-30 12:10:20
1468	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:34:00	68	f	2026-04-30 12:10:20
1469	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:35:00	83	f	2026-04-30 12:10:20
1470	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:36:00	77	f	2026-04-30 12:10:20
1471	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:37:00	59	t	2026-04-30 12:10:20
1472	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:38:00	60	t	2026-04-30 12:10:20
1473	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:39:00	69	f	2026-04-30 12:10:20
1475	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:41:00	62	t	2026-04-30 12:10:20
1477	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:42:00	61	t	2026-04-30 12:10:20
1478	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:44:00	59	t	2026-04-30 12:10:20
1480	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:46:00	62	t	2026-04-30 12:10:20
1481	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:47:00	60	t	2026-04-30 12:10:20
1482	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:48:00	64	t	2026-04-30 12:10:20
1483	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:49:00	63	t	2026-04-30 12:10:20
1484	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:50:00	61	t	2026-04-30 12:10:20
1486	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:52:00	62	t	2026-04-30 12:10:20
1487	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:53:00	62	t	2026-04-30 12:10:20
1488	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:54:00	64	t	2026-04-30 12:10:20
1489	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:55:00	60	t	2026-04-30 12:10:20
1490	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:56:00	61	t	2026-04-30 12:10:20
1492	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:57:00	64	t	2026-04-30 12:10:20
1493	alex.k.kaczmarczyk@gmail.com	2026-04-22 09:59:00	63	t	2026-04-30 12:10:20
1494	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:00:00	62	t	2026-04-30 12:10:20
1495	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:01:00	62	t	2026-04-30 12:10:20
1496	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:02:00	62	t	2026-04-30 12:10:20
1498	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:03:00	56	t	2026-04-30 12:10:20
1499	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:04:00	58	t	2026-04-30 12:10:20
1500	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:05:00	63	t	2026-04-30 12:10:20
1501	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:07:00	64	t	2026-04-30 12:10:20
1503	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:08:00	61	t	2026-04-30 12:10:20
1504	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:09:00	62	t	2026-04-30 12:10:20
1505	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:10:00	60	t	2026-04-30 12:10:20
1506	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:11:00	60	t	2026-04-30 12:10:20
1507	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:12:00	60	t	2026-04-30 12:10:20
1508	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:13:00	61	t	2026-04-30 12:10:20
1509	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:15:00	61	t	2026-04-30 12:10:20
1511	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:16:00	64	t	2026-04-30 12:10:20
17	alex.k.kaczmarczyk@gmail.com	2026-04-06 02:50:09	55	t	2026-04-30 12:10:19
1512	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:18:00	59	t	2026-04-30 12:10:20
1513	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:19:00	55	t	2026-04-30 12:10:20
1514	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:20:00	56	t	2026-04-30 12:10:20
1515	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:21:00	56	t	2026-04-30 12:10:20
1516	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:22:00	57	t	2026-04-30 12:10:20
1517	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:23:00	56	t	2026-04-30 12:10:20
1519	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:24:00	65	f	2026-04-30 12:10:20
1520	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:25:00	57	t	2026-04-30 12:10:20
1521	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:26:00	52	t	2026-04-30 12:10:20
1522	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:27:00	55	t	2026-04-30 12:10:20
1523	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:28:00	51	t	2026-04-30 12:10:20
1524	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:29:00	58	t	2026-04-30 12:10:20
1525	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:30:00	70	f	2026-04-30 12:10:20
1526	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:31:00	80	f	2026-04-30 12:10:20
1527	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:32:00	79	f	2026-04-30 12:10:20
1528	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:34:00	63	t	2026-04-30 12:10:20
1529	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:35:00	64	t	2026-04-30 12:10:20
1531	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:37:00	60	t	2026-04-30 12:10:20
1532	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:38:00	60	t	2026-04-30 12:10:20
1533	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:39:00	63	t	2026-04-30 12:10:20
1534	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:40:00	61	t	2026-04-30 12:10:20
1535	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:41:00	64	t	2026-04-30 12:10:20
1536	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:42:00	62	t	2026-04-30 12:10:20
1537	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:43:00	61	t	2026-04-30 12:10:20
1538	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:44:00	61	t	2026-04-30 12:10:20
1539	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:45:00	57	t	2026-04-30 12:10:20
1540	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:46:00	60	t	2026-04-30 12:10:20
1541	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:47:00	62	t	2026-04-30 12:10:20
1542	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:48:00	58	t	2026-04-30 12:10:20
1543	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:49:00	61	t	2026-04-30 12:10:20
1544	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:50:00	61	t	2026-04-30 12:10:20
1546	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:51:00	70	f	2026-04-30 12:10:20
1547	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:52:00	57	t	2026-04-30 12:10:20
1548	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:53:00	56	t	2026-04-30 12:10:20
1549	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:54:00	56	t	2026-04-30 12:10:20
1550	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:55:00	56	t	2026-04-30 12:10:20
1551	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:56:00	57	t	2026-04-30 12:10:20
1552	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:57:00	58	t	2026-04-30 12:10:20
1553	alex.k.kaczmarczyk@gmail.com	2026-04-22 10:58:00	59	t	2026-04-30 12:10:20
1554	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:00:00	55	t	2026-04-30 12:10:20
1555	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:02:00	58	t	2026-04-30 12:10:20
1556	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:03:00	57	t	2026-04-30 12:10:20
1558	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:04:00	61	t	2026-04-30 12:10:20
1559	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:05:00	61	t	2026-04-30 12:10:20
1560	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:06:00	62	t	2026-04-30 12:10:20
1561	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:07:00	57	t	2026-04-30 12:10:20
1562	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:08:00	60	t	2026-04-30 12:10:20
1563	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:09:00	62	t	2026-04-30 12:10:20
1564	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:10:00	60	t	2026-04-30 12:10:20
1565	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:11:00	60	t	2026-04-30 12:10:20
1566	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:13:00	59	t	2026-04-30 12:10:20
1567	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:14:00	58	t	2026-04-30 12:10:20
1569	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:16:00	56	t	2026-04-30 12:10:20
1570	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:17:00	55	t	2026-04-30 12:10:20
1571	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:18:00	54	t	2026-04-30 12:10:20
1573	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:19:00	57	t	2026-04-30 12:10:20
1574	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:21:00	65	f	2026-04-30 12:10:20
1575	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:22:00	75	f	2026-04-30 12:10:20
1577	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:23:00	77	f	2026-04-30 12:10:20
1578	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:24:00	77	f	2026-04-30 12:10:20
1579	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:25:00	78	f	2026-04-30 12:10:20
1580	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:26:00	79	f	2026-04-30 12:10:20
1581	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:27:00	75	f	2026-04-30 12:10:20
1582	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:28:00	79	f	2026-04-30 12:10:20
1583	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:29:00	72	f	2026-04-30 12:10:20
1584	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:30:00	83	f	2026-04-30 12:10:20
1585	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:31:00	75	f	2026-04-30 12:10:20
1586	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:32:00	72	f	2026-04-30 12:10:20
1587	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:34:00	76	f	2026-04-30 12:10:20
1588	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:35:00	74	f	2026-04-30 12:10:20
1589	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:36:00	75	f	2026-04-30 12:10:20
1590	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:37:00	68	f	2026-04-30 12:10:20
1591	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:38:00	72	f	2026-04-30 12:10:20
1592	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:39:00	73	f	2026-04-30 12:10:20
1593	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:40:00	69	f	2026-04-30 12:10:20
1594	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:41:00	69	f	2026-04-30 12:10:20
1596	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:42:00	77	f	2026-04-30 12:10:20
1597	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:43:00	76	f	2026-04-30 12:10:20
1598	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:44:00	72	f	2026-04-30 12:10:20
1599	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:45:00	76	f	2026-04-30 12:10:20
1600	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:46:00	77	f	2026-04-30 12:10:20
1601	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:47:00	80	f	2026-04-30 12:10:20
1602	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:48:00	83	f	2026-04-30 12:10:20
1603	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:49:00	92	f	2026-04-30 12:10:20
1604	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:51:00	96	f	2026-04-30 12:10:20
1606	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:53:00	93	f	2026-04-30 12:10:20
1608	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:54:00	87	f	2026-04-30 12:10:20
18	alex.k.kaczmarczyk@gmail.com	2026-04-06 03:00:10	53	t	2026-04-30 12:10:19
1609	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:56:00	85	f	2026-04-30 12:10:20
1611	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:57:00	86	f	2026-04-30 12:10:20
1612	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:58:00	83	f	2026-04-30 12:10:20
1613	alex.k.kaczmarczyk@gmail.com	2026-04-22 11:59:00	81	f	2026-04-30 12:10:20
1614	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:00:00	78	f	2026-04-30 12:10:20
1615	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:01:00	86	f	2026-04-30 12:10:20
1616	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:03:00	86	f	2026-04-30 12:10:20
1617	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:04:00	87	f	2026-04-30 12:10:20
1619	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:05:00	88	f	2026-04-30 12:10:20
1620	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:06:00	82	f	2026-04-30 12:10:20
1621	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:07:00	81	f	2026-04-30 12:10:20
1622	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:09:00	83	f	2026-04-30 12:10:20
1623	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:10:00	86	f	2026-04-30 12:10:20
1624	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:11:00	87	f	2026-04-30 12:10:20
1626	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:12:00	73	f	2026-04-30 12:10:20
1627	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:14:00	67	f	2026-04-30 12:10:20
1629	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:16:00	64	t	2026-04-30 12:10:20
1631	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:17:00	65	f	2026-04-30 12:10:20
1632	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:19:00	72	f	2026-04-30 12:10:20
1634	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:20:00	64	t	2026-04-30 12:10:20
1635	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:21:00	62	t	2026-04-30 12:10:20
1636	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:22:00	69	f	2026-04-30 12:10:20
1637	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:24:00	66	f	2026-04-30 12:10:20
1638	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:25:00	67	f	2026-04-30 12:10:20
1639	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:26:00	67	f	2026-04-30 12:10:20
1640	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:27:00	70	f	2026-04-30 12:10:20
1642	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:28:00	66	f	2026-04-30 12:10:20
1643	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:29:00	63	t	2026-04-30 12:10:20
1644	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:30:00	68	f	2026-04-30 12:10:20
1645	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:32:00	74	f	2026-04-30 12:10:20
1646	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:33:00	67	f	2026-04-30 12:10:20
1648	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:34:00	68	f	2026-04-30 12:10:20
1649	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:35:00	65	f	2026-04-30 12:10:20
1650	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:36:00	63	t	2026-04-30 12:10:20
1651	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:37:00	63	t	2026-04-30 12:10:20
1652	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:38:00	64	t	2026-04-30 12:10:20
1653	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:39:00	64	t	2026-04-30 12:10:20
1654	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:40:00	63	t	2026-04-30 12:10:20
1655	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:41:00	68	f	2026-04-30 12:10:20
1656	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:42:00	68	f	2026-04-30 12:10:20
1657	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:43:00	71	f	2026-04-30 12:10:20
1658	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:44:00	74	f	2026-04-30 12:10:20
1659	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:45:00	69	f	2026-04-30 12:10:20
1660	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:46:00	68	f	2026-04-30 12:10:20
1661	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:47:00	68	f	2026-04-30 12:10:20
1662	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:48:00	69	f	2026-04-30 12:10:20
1663	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:49:00	69	f	2026-04-30 12:10:20
1664	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:50:00	73	f	2026-04-30 12:10:20
1665	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:51:00	80	f	2026-04-30 12:10:20
1666	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:52:00	82	f	2026-04-30 12:10:20
1667	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:53:00	82	f	2026-04-30 12:10:20
1668	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:54:00	75	f	2026-04-30 12:10:20
1669	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:55:00	68	f	2026-04-30 12:10:20
1670	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:56:00	68	f	2026-04-30 12:10:20
1671	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:57:00	63	t	2026-04-30 12:10:20
1672	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:58:00	70	f	2026-04-30 12:10:20
1673	alex.k.kaczmarczyk@gmail.com	2026-04-22 12:59:00	73	f	2026-04-30 12:10:20
1674	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:00:00	75	f	2026-04-30 12:10:20
1675	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:01:00	78	f	2026-04-30 12:10:20
1676	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:02:00	67	f	2026-04-30 12:10:20
1677	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:04:00	70	f	2026-04-30 12:10:20
1679	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:05:00	69	f	2026-04-30 12:10:20
1680	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:06:00	64	t	2026-04-30 12:10:20
1681	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:07:00	67	f	2026-04-30 12:10:20
1682	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:08:00	68	f	2026-04-30 12:10:20
1683	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:09:00	66	f	2026-04-30 12:10:20
1684	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:10:00	66	f	2026-04-30 12:10:20
1685	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:11:00	66	f	2026-04-30 12:10:20
1686	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:12:00	67	f	2026-04-30 12:10:20
1687	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:13:00	67	f	2026-04-30 12:10:20
1688	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:14:00	68	f	2026-04-30 12:10:20
1689	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:15:00	66	f	2026-04-30 12:10:20
1690	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:16:00	67	f	2026-04-30 12:10:20
1691	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:17:00	63	t	2026-04-30 12:10:20
1692	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:18:00	67	f	2026-04-30 12:10:20
1693	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:19:00	71	f	2026-04-30 12:10:20
1694	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:20:00	76	f	2026-04-30 12:10:20
1695	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:21:00	65	f	2026-04-30 12:10:20
1696	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:22:00	63	t	2026-04-30 12:10:20
1697	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:23:00	64	t	2026-04-30 12:10:20
1698	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:24:00	62	t	2026-04-30 12:10:20
1699	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:25:00	67	f	2026-04-30 12:10:20
1700	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:26:00	67	f	2026-04-30 12:10:20
1701	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:27:00	64	t	2026-04-30 12:10:20
1702	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:28:00	66	f	2026-04-30 12:10:20
1703	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:29:00	69	f	2026-04-30 12:10:20
1704	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:30:00	71	f	2026-04-30 12:10:20
19	alex.k.kaczmarczyk@gmail.com	2026-04-06 03:10:20	52	t	2026-04-30 12:10:19
1705	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:31:00	68	f	2026-04-30 12:10:20
1706	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:32:00	81	f	2026-04-30 12:10:20
1707	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:33:00	79	f	2026-04-30 12:10:20
1708	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:34:00	63	t	2026-04-30 12:10:20
1709	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:35:00	61	t	2026-04-30 12:10:20
1710	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:36:00	61	t	2026-04-30 12:10:20
1711	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:37:00	61	t	2026-04-30 12:10:20
1712	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:38:00	60	t	2026-04-30 12:10:20
1713	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:39:00	60	t	2026-04-30 12:10:20
1714	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:40:00	66	f	2026-04-30 12:10:20
1715	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:41:00	73	f	2026-04-30 12:10:20
1716	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:42:00	69	f	2026-04-30 12:10:20
1717	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:43:00	63	t	2026-04-30 12:10:20
1718	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:44:00	79	f	2026-04-30 12:10:20
1719	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:45:00	78	f	2026-04-30 12:10:20
1720	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:46:00	78	f	2026-04-30 12:10:20
1721	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:47:00	86	f	2026-04-30 12:10:20
1722	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:49:00	80	f	2026-04-30 12:10:20
1723	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:50:00	65	f	2026-04-30 12:10:20
1725	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:51:00	66	f	2026-04-30 12:10:20
1726	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:52:00	65	f	2026-04-30 12:10:20
1727	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:53:00	74	f	2026-04-30 12:10:20
1728	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:54:00	69	f	2026-04-30 12:10:20
1729	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:55:00	79	f	2026-04-30 12:10:20
1730	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:56:00	98	f	2026-04-30 12:10:20
1731	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:57:00	66	f	2026-04-30 12:10:20
1732	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:58:00	67	f	2026-04-30 12:10:20
1733	alex.k.kaczmarczyk@gmail.com	2026-04-22 13:59:00	67	f	2026-04-30 12:10:20
1734	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:00:00	65	f	2026-04-30 12:10:20
1736	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:02:00	65	f	2026-04-30 12:10:20
1737	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:03:00	62	t	2026-04-30 12:10:20
1738	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:04:00	74	f	2026-04-30 12:10:20
1739	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:05:00	82	f	2026-04-30 12:10:20
1740	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:06:00	80	f	2026-04-30 12:10:20
1741	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:07:00	65	f	2026-04-30 12:10:20
1742	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:08:00	65	f	2026-04-30 12:10:20
1743	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:09:00	66	f	2026-04-30 12:10:20
1744	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:10:00	66	f	2026-04-30 12:10:20
1745	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:11:00	65	f	2026-04-30 12:10:20
1746	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:12:00	69	f	2026-04-30 12:10:20
1747	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:13:00	70	f	2026-04-30 12:10:20
1748	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:14:00	70	f	2026-04-30 12:10:20
1749	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:15:00	65	f	2026-04-30 12:10:20
1750	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:16:00	68	f	2026-04-30 12:10:20
1751	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:17:00	67	f	2026-04-30 12:10:20
1752	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:18:00	67	f	2026-04-30 12:10:20
1753	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:19:00	67	f	2026-04-30 12:10:20
1755	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:20:00	69	f	2026-04-30 12:10:20
1756	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:22:00	71	f	2026-04-30 12:10:20
1757	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:23:00	68	f	2026-04-30 12:10:20
1758	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:24:00	71	f	2026-04-30 12:10:20
1760	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:26:00	67	f	2026-04-30 12:10:20
1761	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:27:00	63	t	2026-04-30 12:10:20
1762	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:28:00	69	f	2026-04-30 12:10:20
1764	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:29:00	66	f	2026-04-30 12:10:20
1765	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:30:00	70	f	2026-04-30 12:10:20
1766	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:31:00	69	f	2026-04-30 12:10:20
1767	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:32:00	66	f	2026-04-30 12:10:20
1768	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:34:00	74	f	2026-04-30 12:10:20
1770	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:35:00	67	f	2026-04-30 12:10:20
1771	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:36:00	82	f	2026-04-30 12:10:20
1772	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:38:00	91	f	2026-04-30 12:10:20
1774	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:40:00	102	f	2026-04-30 12:10:20
1775	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:41:00	95	f	2026-04-30 12:10:20
1777	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:42:00	108	f	2026-04-30 12:10:20
1778	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:43:00	102	f	2026-04-30 12:10:20
1779	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:45:00	113	f	2026-04-30 12:10:20
1780	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:46:00	105	f	2026-04-30 12:10:20
1781	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:47:00	99	f	2026-04-30 12:10:20
1782	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:48:00	80	f	2026-04-30 12:10:20
1783	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:49:00	71	f	2026-04-30 12:10:20
1784	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:50:00	68	f	2026-04-30 12:10:20
1786	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:51:00	66	f	2026-04-30 12:10:20
1787	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:52:00	66	f	2026-04-30 12:10:20
1788	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:53:00	64	t	2026-04-30 12:10:20
1789	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:54:00	64	t	2026-04-30 12:10:20
1790	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:55:00	60	t	2026-04-30 12:10:20
1791	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:56:00	67	f	2026-04-30 12:10:20
1792	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:58:00	84	f	2026-04-30 12:10:20
1793	alex.k.kaczmarczyk@gmail.com	2026-04-22 14:59:00	87	f	2026-04-30 12:10:20
1794	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:00:00	88	f	2026-04-30 12:10:20
1795	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:01:00	86	f	2026-04-30 12:10:20
1796	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:02:00	83	f	2026-04-30 12:10:20
1798	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:04:00	87	f	2026-04-30 12:10:20
1799	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:05:00	86	f	2026-04-30 12:10:20
1801	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:06:00	67	f	2026-04-30 12:10:20
1802	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:07:00	66	f	2026-04-30 12:10:20
20	alex.k.kaczmarczyk@gmail.com	2026-04-06 03:20:09	53	t	2026-04-30 12:10:19
1803	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:08:00	66	f	2026-04-30 12:10:20
1804	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:10:00	85	f	2026-04-30 12:10:20
1805	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:11:00	109	f	2026-04-30 12:10:20
1806	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:12:00	93	f	2026-04-30 12:10:20
1807	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:13:00	84	f	2026-04-30 12:10:20
1808	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:14:00	87	f	2026-04-30 12:10:20
1809	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:15:00	79	f	2026-04-30 12:10:20
1810	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:16:00	80	f	2026-04-30 12:10:20
1811	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:17:00	72	f	2026-04-30 12:10:20
1812	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:18:00	69	f	2026-04-30 12:10:20
1813	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:19:00	65	f	2026-04-30 12:10:20
1814	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:20:00	65	f	2026-04-30 12:10:20
1815	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:21:00	77	f	2026-04-30 12:10:20
1816	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:22:00	64	t	2026-04-30 12:10:20
1818	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:23:00	65	f	2026-04-30 12:10:20
1819	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:24:00	64	t	2026-04-30 12:10:20
1820	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:25:00	68	f	2026-04-30 12:10:20
1821	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:26:00	67	f	2026-04-30 12:10:20
1822	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:27:00	66	f	2026-04-30 12:10:20
1823	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:28:00	64	t	2026-04-30 12:10:20
1824	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:29:00	64	t	2026-04-30 12:10:20
1825	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:30:00	67	f	2026-04-30 12:10:20
1826	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:31:00	67	f	2026-04-30 12:10:20
1827	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:32:00	72	f	2026-04-30 12:10:20
1828	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:33:00	69	f	2026-04-30 12:10:20
1829	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:34:00	73	f	2026-04-30 12:10:20
1830	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:35:00	72	f	2026-04-30 12:10:20
1831	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:36:00	67	f	2026-04-30 12:10:20
1832	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:37:00	66	f	2026-04-30 12:10:20
1833	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:38:00	66	f	2026-04-30 12:10:20
1834	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:39:00	67	f	2026-04-30 12:10:20
1835	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:40:00	65	f	2026-04-30 12:10:20
1836	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:41:00	66	f	2026-04-30 12:10:20
1837	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:43:00	79	f	2026-04-30 12:10:20
1839	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:44:00	103	f	2026-04-30 12:10:20
1840	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:45:00	106	f	2026-04-30 12:10:20
1841	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:46:00	102	f	2026-04-30 12:10:20
1842	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:47:00	101	f	2026-04-30 12:10:20
1843	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:48:00	99	f	2026-04-30 12:10:20
1844	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:49:00	109	f	2026-04-30 12:10:20
1845	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:50:00	109	f	2026-04-30 12:10:20
1846	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:51:00	106	f	2026-04-30 12:10:20
1847	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:52:00	110	f	2026-04-30 12:10:20
1848	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:53:00	93	f	2026-04-30 12:10:20
1849	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:54:00	101	f	2026-04-30 12:10:20
1850	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:55:00	102	f	2026-04-30 12:10:20
1851	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:56:00	98	f	2026-04-30 12:10:20
1852	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:57:00	94	f	2026-04-30 12:10:20
1853	alex.k.kaczmarczyk@gmail.com	2026-04-22 15:58:00	89	f	2026-04-30 12:10:20
1854	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:01:00	94	f	2026-04-30 12:10:20
1856	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:03:00	97	f	2026-04-30 12:10:20
1858	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:05:00	79	f	2026-04-30 12:10:20
1860	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:06:00	70	f	2026-04-30 12:10:20
1861	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:07:00	76	f	2026-04-30 12:10:20
1862	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:09:00	76	f	2026-04-30 12:10:20
1863	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:10:00	78	f	2026-04-30 12:10:20
1864	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:11:00	82	f	2026-04-30 12:10:20
1865	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:12:00	81	f	2026-04-30 12:10:20
1866	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:13:00	83	f	2026-04-30 12:10:20
1867	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:14:00	83	f	2026-04-30 12:10:20
1868	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:15:00	94	f	2026-04-30 12:10:20
1870	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:16:00	63	t	2026-04-30 12:10:20
1871	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:18:00	61	t	2026-04-30 12:10:20
1873	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:19:00	60	t	2026-04-30 12:10:20
1874	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:20:00	65	f	2026-04-30 12:10:20
1875	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:21:00	60	t	2026-04-30 12:10:20
1876	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:22:00	63	t	2026-04-30 12:10:20
1877	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:23:00	66	f	2026-04-30 12:10:20
1878	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:25:00	64	t	2026-04-30 12:10:20
1880	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:26:00	65	f	2026-04-30 12:10:20
1881	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:27:00	64	t	2026-04-30 12:10:20
1882	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:28:00	62	t	2026-04-30 12:10:20
1883	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:29:00	65	f	2026-04-30 12:10:20
1884	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:30:00	65	f	2026-04-30 12:10:20
1885	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:31:00	63	t	2026-04-30 12:10:20
1886	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:32:00	62	t	2026-04-30 12:10:20
1887	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:33:00	66	f	2026-04-30 12:10:20
1888	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:34:00	65	f	2026-04-30 12:10:20
1889	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:35:00	63	t	2026-04-30 12:10:20
1890	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:36:00	62	t	2026-04-30 12:10:20
1891	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:37:00	62	t	2026-04-30 12:10:20
1892	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:38:00	62	t	2026-04-30 12:10:20
1893	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:39:00	63	t	2026-04-30 12:10:20
1894	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:40:00	63	t	2026-04-30 12:10:20
1895	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:42:00	66	f	2026-04-30 12:10:20
1896	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:43:00	65	f	2026-04-30 12:10:20
1898	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:44:00	68	f	2026-04-30 12:10:20
21	alex.k.kaczmarczyk@gmail.com	2026-04-06 03:30:09	52	t	2026-04-30 12:10:19
1899	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:45:00	62	t	2026-04-30 12:10:20
1900	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:46:00	60	t	2026-04-30 12:10:20
1901	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:47:00	62	t	2026-04-30 12:10:20
1902	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:48:00	62	t	2026-04-30 12:10:20
1903	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:49:00	62	t	2026-04-30 12:10:20
1904	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:50:00	61	t	2026-04-30 12:10:20
1905	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:51:00	61	t	2026-04-30 12:10:20
1906	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:52:00	59	t	2026-04-30 12:10:20
1907	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:53:00	60	t	2026-04-30 12:10:20
1908	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:54:00	60	t	2026-04-30 12:10:20
1909	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:55:00	60	t	2026-04-30 12:10:20
1910	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:56:00	59	t	2026-04-30 12:10:20
1911	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:57:00	60	t	2026-04-30 12:10:20
1912	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:58:00	60	t	2026-04-30 12:10:20
1913	alex.k.kaczmarczyk@gmail.com	2026-04-22 16:59:00	59	t	2026-04-30 12:10:20
1914	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:00:00	58	t	2026-04-30 12:10:20
1915	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:01:00	59	t	2026-04-30 12:10:20
1916	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:02:00	59	t	2026-04-30 12:10:20
1917	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:03:00	58	t	2026-04-30 12:10:20
1918	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:04:00	59	t	2026-04-30 12:10:20
1919	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:05:00	58	t	2026-04-30 12:10:20
1920	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:06:00	59	t	2026-04-30 12:10:20
1921	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:07:00	59	t	2026-04-30 12:10:20
1922	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:08:00	57	t	2026-04-30 12:10:20
1923	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:09:00	58	t	2026-04-30 12:10:20
1924	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:10:00	58	t	2026-04-30 12:10:20
1925	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:11:00	57	t	2026-04-30 12:10:20
1926	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:12:00	58	t	2026-04-30 12:10:20
1927	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:13:00	57	t	2026-04-30 12:10:20
1928	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:14:00	58	t	2026-04-30 12:10:20
1929	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:15:00	58	t	2026-04-30 12:10:20
1930	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:16:00	58	t	2026-04-30 12:10:20
1931	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:17:00	58	t	2026-04-30 12:10:20
1932	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:18:00	57	t	2026-04-30 12:10:20
1933	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:19:00	57	t	2026-04-30 12:10:20
1934	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:20:00	56	t	2026-04-30 12:10:20
1935	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:21:00	53	t	2026-04-30 12:10:20
1936	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:22:00	53	t	2026-04-30 12:10:20
1937	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:23:00	53	t	2026-04-30 12:10:20
1938	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:24:00	54	t	2026-04-30 12:10:20
1939	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:25:00	53	t	2026-04-30 12:10:20
1940	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:26:00	54	t	2026-04-30 12:10:20
1941	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:27:00	54	t	2026-04-30 12:10:20
1942	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:28:00	55	t	2026-04-30 12:10:20
1943	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:29:00	55	t	2026-04-30 12:10:20
1944	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:30:00	56	t	2026-04-30 12:10:20
1945	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:31:00	56	t	2026-04-30 12:10:20
1946	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:32:00	55	t	2026-04-30 12:10:20
1947	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:33:00	55	t	2026-04-30 12:10:20
1948	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:34:00	55	t	2026-04-30 12:10:20
1949	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:35:00	56	t	2026-04-30 12:10:20
1950	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:36:00	57	t	2026-04-30 12:10:20
1951	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:37:00	56	t	2026-04-30 12:10:20
1952	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:38:00	55	t	2026-04-30 12:10:20
1953	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:39:00	55	t	2026-04-30 12:10:20
1954	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:40:00	54	t	2026-04-30 12:10:20
1955	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:41:00	54	t	2026-04-30 12:10:20
1956	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:42:00	55	t	2026-04-30 12:10:20
1957	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:43:00	54	t	2026-04-30 12:10:20
1958	alex.k.kaczmarczyk@gmail.com	2026-04-22 17:44:00	54	t	2026-04-30 12:10:20
1959	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:00:00	55	t	2026-04-30 12:10:20
1960	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:01:00	56	t	2026-04-30 12:10:20
1961	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:02:00	55	t	2026-04-30 12:10:20
1962	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:03:00	57	t	2026-04-30 12:10:20
1963	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:04:00	56	t	2026-04-30 12:10:20
1964	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:05:00	57	t	2026-04-30 12:10:20
1965	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:06:00	56	t	2026-04-30 12:10:20
1966	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:07:00	56	t	2026-04-30 12:10:20
1967	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:08:00	57	t	2026-04-30 12:10:20
1968	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:09:00	55	t	2026-04-30 12:10:20
1969	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:10:00	58	t	2026-04-30 12:10:20
1970	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:11:00	59	t	2026-04-30 12:10:20
1971	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:12:00	57	t	2026-04-30 12:10:20
1972	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:13:00	59	t	2026-04-30 12:10:20
1973	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:14:00	61	t	2026-04-30 12:10:20
1974	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:15:00	52	t	2026-04-30 12:10:20
1975	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:16:00	52	t	2026-04-30 12:10:20
1976	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:17:00	55	t	2026-04-30 12:10:20
1977	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:18:00	54	t	2026-04-30 12:10:20
1978	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:19:00	55	t	2026-04-30 12:10:20
1979	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:20:00	57	t	2026-04-30 12:10:20
1980	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:21:00	56	t	2026-04-30 12:10:20
1981	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:22:00	54	t	2026-04-30 12:10:20
1982	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:23:00	57	t	2026-04-30 12:10:20
1983	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:24:00	56	t	2026-04-30 12:10:20
1984	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:25:00	54	t	2026-04-30 12:10:20
1985	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:26:00	53	t	2026-04-30 12:10:20
22	alex.k.kaczmarczyk@gmail.com	2026-04-06 03:40:15	60	t	2026-04-30 12:10:19
1986	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:27:00	52	t	2026-04-30 12:10:20
1987	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:28:00	51	t	2026-04-30 12:10:20
1988	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:29:00	52	t	2026-04-30 12:10:20
1989	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:30:00	52	t	2026-04-30 12:10:20
1990	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:31:00	53	t	2026-04-30 12:10:20
1991	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:32:00	53	t	2026-04-30 12:10:20
1992	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:33:00	52	t	2026-04-30 12:10:20
1993	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:34:00	52	t	2026-04-30 12:10:20
1994	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:35:00	52	t	2026-04-30 12:10:20
1995	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:36:00	53	t	2026-04-30 12:10:20
1996	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:37:00	60	t	2026-04-30 12:10:20
1997	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:38:00	65	f	2026-04-30 12:10:20
1998	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:39:00	57	t	2026-04-30 12:10:20
1999	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:40:00	54	t	2026-04-30 12:10:20
2000	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:41:00	54	t	2026-04-30 12:10:20
2001	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:42:00	53	t	2026-04-30 12:10:20
2002	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:43:00	50	t	2026-04-30 12:10:20
2003	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:44:00	50	t	2026-04-30 12:10:20
2004	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:45:00	51	t	2026-04-30 12:10:20
2005	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:46:00	52	t	2026-04-30 12:10:20
2006	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:47:00	50	t	2026-04-30 12:10:20
2007	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:48:00	55	t	2026-04-30 12:10:20
2008	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:49:00	51	t	2026-04-30 12:10:20
2009	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:50:00	49	t	2026-04-30 12:10:20
2010	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:51:00	49	t	2026-04-30 12:10:20
2011	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:52:00	49	t	2026-04-30 12:10:20
2012	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:53:00	49	t	2026-04-30 12:10:20
2013	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:54:00	49	t	2026-04-30 12:10:20
2014	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:55:00	49	t	2026-04-30 12:10:20
2015	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:56:00	50	t	2026-04-30 12:10:20
2016	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:57:00	50	t	2026-04-30 12:10:20
2017	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:58:00	50	t	2026-04-30 12:10:20
2018	alex.k.kaczmarczyk@gmail.com	2026-04-22 18:59:00	50	t	2026-04-30 12:10:20
2019	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:00:00	50	t	2026-04-30 12:10:20
2020	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:01:00	49	t	2026-04-30 12:10:20
2021	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:02:00	50	t	2026-04-30 12:10:20
2022	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:03:00	50	t	2026-04-30 12:10:20
2023	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:04:00	52	t	2026-04-30 12:10:20
2024	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:05:00	54	t	2026-04-30 12:10:20
2025	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:06:00	63	t	2026-04-30 12:10:20
2026	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:07:00	58	t	2026-04-30 12:10:20
2027	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:08:00	60	t	2026-04-30 12:10:20
2028	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:09:00	93	f	2026-04-30 12:10:20
2029	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:10:00	85	f	2026-04-30 12:10:20
2030	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:12:00	90	f	2026-04-30 12:10:20
2032	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:13:00	85	f	2026-04-30 12:10:20
2033	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:15:00	84	f	2026-04-30 12:10:20
2035	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:16:00	89	f	2026-04-30 12:10:20
2036	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:17:00	79	f	2026-04-30 12:10:20
2037	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:18:00	78	f	2026-04-30 12:10:20
2038	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:19:00	83	f	2026-04-30 12:10:20
2039	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:20:00	78	f	2026-04-30 12:10:20
2040	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:21:00	85	f	2026-04-30 12:10:20
2041	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:22:00	85	f	2026-04-30 12:10:20
2042	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:23:00	84	f	2026-04-30 12:10:20
2043	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:24:00	60	t	2026-04-30 12:10:20
2044	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:25:00	68	f	2026-04-30 12:10:20
2045	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:26:00	72	f	2026-04-30 12:10:20
2046	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:27:00	74	f	2026-04-30 12:10:20
2047	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:29:00	78	f	2026-04-30 12:10:20
2049	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:30:00	75	f	2026-04-30 12:10:20
2050	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:31:00	74	f	2026-04-30 12:10:20
2051	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:32:00	81	f	2026-04-30 12:10:20
2052	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:33:00	66	f	2026-04-30 12:10:20
2053	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:34:00	60	t	2026-04-30 12:10:20
2055	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:35:00	61	t	2026-04-30 12:10:20
2056	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:36:00	59	t	2026-04-30 12:10:20
2057	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:37:00	59	t	2026-04-30 12:10:20
2058	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:38:00	57	t	2026-04-30 12:10:20
2059	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:39:00	58	t	2026-04-30 12:10:20
2060	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:40:00	60	t	2026-04-30 12:10:20
2061	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:41:00	53	t	2026-04-30 12:10:20
2062	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:42:00	57	t	2026-04-30 12:10:20
2063	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:43:00	56	t	2026-04-30 12:10:20
2064	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:44:00	55	t	2026-04-30 12:10:20
2065	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:45:00	57	t	2026-04-30 12:10:20
2066	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:46:00	55	t	2026-04-30 12:10:20
2067	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:47:00	57	t	2026-04-30 12:10:20
2068	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:48:00	57	t	2026-04-30 12:10:20
2069	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:49:00	59	t	2026-04-30 12:10:20
2070	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:50:00	58	t	2026-04-30 12:10:20
2071	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:51:00	59	t	2026-04-30 12:10:20
2072	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:52:00	61	t	2026-04-30 12:10:20
2073	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:53:00	63	t	2026-04-30 12:10:20
2074	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:54:00	61	t	2026-04-30 12:10:20
2075	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:55:00	61	t	2026-04-30 12:10:20
2076	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:56:00	60	t	2026-04-30 12:10:20
23	alex.k.kaczmarczyk@gmail.com	2026-04-06 03:50:16	54	t	2026-04-30 12:10:19
2077	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:57:00	58	t	2026-04-30 12:10:20
2078	alex.k.kaczmarczyk@gmail.com	2026-04-22 19:58:00	60	t	2026-04-30 12:10:20
2079	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:00:00	59	t	2026-04-30 12:10:20
2080	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:01:00	58	t	2026-04-30 12:10:20
2081	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:02:00	58	t	2026-04-30 12:10:20
2082	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:03:00	63	t	2026-04-30 12:10:20
2083	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:05:00	65	f	2026-04-30 12:10:20
2084	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:06:00	67	f	2026-04-30 12:10:20
2085	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:07:00	62	t	2026-04-30 12:10:20
2086	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:08:00	64	t	2026-04-30 12:10:20
2087	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:09:00	63	t	2026-04-30 12:10:20
2088	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:10:00	62	t	2026-04-30 12:10:20
2089	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:11:00	62	t	2026-04-30 12:10:20
2090	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:12:00	63	t	2026-04-30 12:10:20
2092	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:13:00	72	f	2026-04-30 12:10:20
2093	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:14:00	67	f	2026-04-30 12:10:20
2094	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:15:00	67	f	2026-04-30 12:10:20
2095	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:16:00	65	f	2026-04-30 12:10:20
2096	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:17:00	63	t	2026-04-30 12:10:20
2097	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:18:00	63	t	2026-04-30 12:10:20
2098	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:19:00	60	t	2026-04-30 12:10:20
2099	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:20:00	60	t	2026-04-30 12:10:20
2100	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:21:00	60	t	2026-04-30 12:10:20
2101	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:22:00	62	t	2026-04-30 12:10:20
2102	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:24:00	67	f	2026-04-30 12:10:20
2103	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:25:00	61	t	2026-04-30 12:10:20
2104	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:26:00	60	t	2026-04-30 12:10:20
2105	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:27:00	67	f	2026-04-30 12:10:20
2106	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:28:00	71	f	2026-04-30 12:10:20
2107	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:29:00	66	f	2026-04-30 12:10:20
2108	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:30:00	76	f	2026-04-30 12:10:20
2109	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:31:00	67	f	2026-04-30 12:10:20
2110	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:32:00	68	f	2026-04-30 12:10:20
2111	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:33:00	65	f	2026-04-30 12:10:20
2112	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:34:00	63	t	2026-04-30 12:10:20
2113	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:35:00	65	f	2026-04-30 12:10:20
2114	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:36:00	65	f	2026-04-30 12:10:20
2116	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:37:00	60	t	2026-04-30 12:10:20
2117	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:38:00	60	t	2026-04-30 12:10:20
2118	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:39:00	62	t	2026-04-30 12:10:20
2119	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:41:00	66	f	2026-04-30 12:10:20
2120	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:42:00	62	t	2026-04-30 12:10:20
2121	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:43:00	60	t	2026-04-30 12:10:20
2122	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:44:00	63	t	2026-04-30 12:10:20
2123	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:45:00	63	t	2026-04-30 12:10:20
2124	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:46:00	62	t	2026-04-30 12:10:20
2125	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:47:00	68	f	2026-04-30 12:10:20
2126	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:48:00	70	f	2026-04-30 12:10:20
2128	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:49:00	64	t	2026-04-30 12:10:20
2129	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:50:00	65	f	2026-04-30 12:10:20
2130	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:52:00	83	f	2026-04-30 12:10:20
2131	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:53:00	70	f	2026-04-30 12:10:20
2132	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:54:00	70	f	2026-04-30 12:10:20
2133	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:55:00	69	f	2026-04-30 12:10:20
2135	alex.k.kaczmarczyk@gmail.com	2026-04-22 20:56:00	88	f	2026-04-30 12:10:20
2136	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:44:00	62	t	2026-04-30 12:10:20
2137	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:46:00	64	t	2026-04-30 12:10:20
2139	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:47:00	62	t	2026-04-30 12:10:20
2140	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:49:00	60	t	2026-04-30 12:10:20
2141	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:50:00	60	t	2026-04-30 12:10:20
2142	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:51:00	60	t	2026-04-30 12:10:20
2144	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:52:00	61	t	2026-04-30 12:10:20
2145	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:53:00	60	t	2026-04-30 12:10:20
2146	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:55:00	69	f	2026-04-30 12:10:20
2147	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:56:00	60	t	2026-04-30 12:10:20
2148	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:57:00	58	t	2026-04-30 12:10:20
2149	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:58:00	58	t	2026-04-30 12:10:20
2150	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:59:00	56	t	2026-04-30 12:10:20
2151	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:00:00	57	t	2026-04-30 12:10:20
2153	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:01:00	53	t	2026-04-30 12:10:20
2154	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:02:00	55	t	2026-04-30 12:10:20
2155	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:03:00	57	t	2026-04-30 12:10:20
2156	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:04:00	53	t	2026-04-30 12:10:20
2157	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:05:00	55	t	2026-04-30 12:10:20
2158	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:06:00	57	t	2026-04-30 12:10:20
2159	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:07:00	59	t	2026-04-30 12:10:20
2160	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:08:00	62	t	2026-04-30 12:10:20
2161	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:09:00	58	t	2026-04-30 12:10:20
2162	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:10:00	58	t	2026-04-30 12:10:20
2163	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:11:00	56	t	2026-04-30 12:10:20
2164	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:12:00	55	t	2026-04-30 12:10:20
2165	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:13:00	56	t	2026-04-30 12:10:20
2166	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:14:00	56	t	2026-04-30 12:10:20
2167	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:15:00	56	t	2026-04-30 12:10:20
2168	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:16:00	56	t	2026-04-30 12:10:20
2169	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:17:00	58	t	2026-04-30 12:10:20
2170	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:18:00	57	t	2026-04-30 12:10:20
24	alex.k.kaczmarczyk@gmail.com	2026-04-06 04:00:21	78	t	2026-04-30 12:10:19
2171	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:19:00	56	t	2026-04-30 12:10:20
2172	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:20:00	57	t	2026-04-30 12:10:20
2173	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:21:00	56	t	2026-04-30 12:10:20
2174	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:22:00	57	t	2026-04-30 12:10:20
2175	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:23:00	57	t	2026-04-30 12:10:20
2176	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:24:00	58	t	2026-04-30 12:10:20
2177	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:25:00	56	t	2026-04-30 12:10:20
2178	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:26:00	57	t	2026-04-30 12:10:20
2179	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:27:00	57	t	2026-04-30 12:10:20
2180	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:28:00	56	t	2026-04-30 12:10:20
2181	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:29:00	58	t	2026-04-30 12:10:20
2182	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:30:00	59	t	2026-04-30 12:10:20
2183	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:31:00	58	t	2026-04-30 12:10:20
2184	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:32:00	59	t	2026-04-30 12:10:20
2185	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:33:00	59	t	2026-04-30 12:10:20
2186	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:34:00	59	t	2026-04-30 12:10:20
2187	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:35:00	58	t	2026-04-30 12:10:20
2188	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:36:00	59	t	2026-04-30 12:10:20
2189	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:37:00	59	t	2026-04-30 12:10:20
2190	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:38:00	59	t	2026-04-30 12:10:20
2191	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:39:00	59	t	2026-04-30 12:10:20
2192	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:40:00	59	t	2026-04-30 12:10:20
2193	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:41:00	59	t	2026-04-30 12:10:20
2194	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:42:00	59	t	2026-04-30 12:10:20
2195	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:43:00	58	t	2026-04-30 12:10:20
2196	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:44:00	58	t	2026-04-30 12:10:20
2197	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:45:00	60	t	2026-04-30 12:10:20
2198	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:46:00	60	t	2026-04-30 12:10:20
2199	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:47:00	60	t	2026-04-30 12:10:20
2200	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:48:00	60	t	2026-04-30 12:10:20
2201	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:49:00	60	t	2026-04-30 12:10:20
2202	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:50:00	60	t	2026-04-30 12:10:20
2203	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:51:00	59	t	2026-04-30 12:10:20
2204	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:52:00	59	t	2026-04-30 12:10:20
2205	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:53:00	60	t	2026-04-30 12:10:20
2206	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:54:00	60	t	2026-04-30 12:10:20
2207	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:55:00	60	t	2026-04-30 12:10:20
2208	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:56:00	60	t	2026-04-30 12:10:20
2209	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:57:00	61	t	2026-04-30 12:10:20
2210	alex.k.kaczmarczyk@gmail.com	2026-04-22 23:58:00	60	t	2026-04-30 12:10:20
2211	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:00:00	60	t	2026-04-30 12:10:20
2212	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:01:00	60	t	2026-04-30 12:10:20
2213	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:02:00	60	t	2026-04-30 12:10:20
2214	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:03:00	60	t	2026-04-30 12:10:20
2215	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:04:00	55	t	2026-04-30 12:10:20
2216	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:05:00	58	t	2026-04-30 12:10:20
2217	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:06:00	60	t	2026-04-30 12:10:20
2218	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:07:00	63	t	2026-04-30 12:10:20
2219	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:08:00	62	t	2026-04-30 12:10:20
2221	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:09:00	59	t	2026-04-30 12:10:20
2222	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:10:00	66	t	2026-04-30 12:10:20
2223	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:11:00	71	t	2026-04-30 12:10:20
2224	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:12:00	63	t	2026-04-30 12:10:20
2225	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:13:00	68	t	2026-04-30 12:10:20
2226	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:14:00	68	t	2026-04-30 12:10:20
2227	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:15:00	62	t	2026-04-30 12:10:20
2228	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:16:00	64	t	2026-04-30 12:10:20
2229	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:17:00	69	t	2026-04-30 12:10:20
2230	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:19:00	65	t	2026-04-30 12:10:20
2232	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:20:00	58	t	2026-04-30 12:10:20
2233	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:21:00	56	t	2026-04-30 12:10:20
2234	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:22:00	53	t	2026-04-30 12:10:20
2235	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:23:00	53	t	2026-04-30 12:10:20
2236	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:24:00	55	t	2026-04-30 12:10:20
2237	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:25:00	56	t	2026-04-30 12:10:20
2238	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:26:00	53	t	2026-04-30 12:10:20
2239	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:27:00	55	t	2026-04-30 12:10:20
2240	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:28:00	56	t	2026-04-30 12:10:20
2241	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:29:00	56	t	2026-04-30 12:10:20
2242	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:30:00	57	t	2026-04-30 12:10:20
2243	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:31:00	55	t	2026-04-30 12:10:20
2244	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:32:00	55	t	2026-04-30 12:10:20
2245	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:33:00	55	t	2026-04-30 12:10:20
2246	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:34:00	54	t	2026-04-30 12:10:20
2247	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:35:00	55	t	2026-04-30 12:10:20
2248	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:36:00	54	t	2026-04-30 12:10:20
2249	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:37:00	53	t	2026-04-30 12:10:20
2250	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:38:00	54	t	2026-04-30 12:10:20
2251	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:39:00	54	t	2026-04-30 12:10:20
2252	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:41:00	54	t	2026-04-30 12:10:20
2253	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:42:00	54	t	2026-04-30 12:10:20
2254	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:43:00	53	t	2026-04-30 12:10:20
2256	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:44:00	52	t	2026-04-30 12:10:20
2257	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:45:00	52	t	2026-04-30 12:10:20
2258	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:46:00	56	t	2026-04-30 12:10:20
2259	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:47:00	55	t	2026-04-30 12:10:20
2260	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:48:00	56	t	2026-04-30 12:10:20
25	alex.k.kaczmarczyk@gmail.com	2026-04-06 04:10:14	48	t	2026-04-30 12:10:19
2261	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:49:00	54	t	2026-04-30 12:10:20
2262	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:50:00	54	t	2026-04-30 12:10:20
2263	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:51:00	53	t	2026-04-30 12:10:20
2264	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:52:00	53	t	2026-04-30 12:10:20
2265	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:53:00	52	t	2026-04-30 12:10:20
2266	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:54:00	53	t	2026-04-30 12:10:20
2267	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:55:00	53	t	2026-04-30 12:10:20
2268	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:56:00	54	t	2026-04-30 12:10:20
2269	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:57:00	54	t	2026-04-30 12:10:20
2270	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:58:00	54	t	2026-04-30 12:10:20
2271	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:00:00	54	t	2026-04-30 12:10:20
2272	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:01:00	54	t	2026-04-30 12:10:20
2273	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:02:00	54	t	2026-04-30 12:10:20
2274	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:03:00	55	t	2026-04-30 12:10:20
2275	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:04:00	53	t	2026-04-30 12:10:20
2276	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:05:00	54	t	2026-04-30 12:10:20
2277	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:06:00	49	t	2026-04-30 12:10:20
2278	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:07:00	48	t	2026-04-30 12:10:20
2279	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:08:00	50	t	2026-04-30 12:10:20
2280	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:09:00	50	t	2026-04-30 12:10:20
2281	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:10:00	50	t	2026-04-30 12:10:20
2282	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:11:00	50	t	2026-04-30 12:10:20
2283	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:12:00	51	t	2026-04-30 12:10:20
2284	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:13:00	50	t	2026-04-30 12:10:20
2285	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:14:00	51	t	2026-04-30 12:10:20
2286	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:15:00	51	t	2026-04-30 12:10:20
2287	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:16:00	51	t	2026-04-30 12:10:20
2288	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:17:00	51	t	2026-04-30 12:10:20
2289	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:18:00	51	t	2026-04-30 12:10:20
2290	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:19:00	51	t	2026-04-30 12:10:20
2291	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:20:00	51	t	2026-04-30 12:10:20
2292	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:21:00	51	t	2026-04-30 12:10:20
2293	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:22:00	50	t	2026-04-30 12:10:20
2294	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:23:00	52	t	2026-04-30 12:10:20
2295	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:24:00	51	t	2026-04-30 12:10:20
2296	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:25:00	51	t	2026-04-30 12:10:20
2297	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:26:00	51	t	2026-04-30 12:10:20
2298	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:27:00	52	t	2026-04-30 12:10:20
2299	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:28:00	51	t	2026-04-30 12:10:20
2300	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:29:00	51	t	2026-04-30 12:10:20
2301	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:30:00	53	t	2026-04-30 12:10:20
2302	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:31:00	50	t	2026-04-30 12:10:20
2303	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:32:00	50	t	2026-04-30 12:10:20
2304	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:33:00	52	t	2026-04-30 12:10:20
2305	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:34:00	51	t	2026-04-30 12:10:20
2306	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:35:00	52	t	2026-04-30 12:10:20
2307	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:36:00	51	t	2026-04-30 12:10:20
2308	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:37:00	52	t	2026-04-30 12:10:20
2309	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:38:00	52	t	2026-04-30 12:10:20
2310	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:39:00	51	t	2026-04-30 12:10:20
2311	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:40:00	51	t	2026-04-30 12:10:20
2312	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:41:00	51	t	2026-04-30 12:10:20
2313	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:42:00	50	t	2026-04-30 12:10:20
2314	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:43:00	50	t	2026-04-30 12:10:20
2315	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:44:00	51	t	2026-04-30 12:10:20
2316	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:45:00	50	t	2026-04-30 12:10:20
2317	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:46:00	51	t	2026-04-30 12:10:20
2318	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:47:00	50	t	2026-04-30 12:10:20
2319	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:48:00	52	t	2026-04-30 12:10:20
2320	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:49:00	52	t	2026-04-30 12:10:20
2321	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:51:00	48	t	2026-04-30 12:10:20
2322	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:52:00	48	t	2026-04-30 12:10:20
2323	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:53:00	47	t	2026-04-30 12:10:20
2324	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:54:00	46	t	2026-04-30 12:10:20
2326	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:55:00	48	t	2026-04-30 12:10:20
2327	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:56:00	48	t	2026-04-30 12:10:20
2328	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:57:00	56	t	2026-04-30 12:10:20
2329	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:58:00	69	t	2026-04-30 12:10:20
2330	alex.k.kaczmarczyk@gmail.com	2026-04-23 01:59:00	102	f	2026-04-30 12:10:20
2331	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:00:00	72	t	2026-04-30 12:10:20
2332	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:01:00	67	t	2026-04-30 12:10:20
2333	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:02:00	52	t	2026-04-30 12:10:20
2334	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:03:00	50	t	2026-04-30 12:10:20
2335	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:04:00	50	t	2026-04-30 12:10:20
2336	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:05:00	51	t	2026-04-30 12:10:20
2337	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:06:00	49	t	2026-04-30 12:10:20
2338	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:07:00	51	t	2026-04-30 12:10:20
2339	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:08:00	52	t	2026-04-30 12:10:20
2340	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:09:00	52	t	2026-04-30 12:10:20
2341	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:10:00	57	t	2026-04-30 12:10:20
2342	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:11:00	57	t	2026-04-30 12:10:20
2343	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:12:00	56	t	2026-04-30 12:10:20
2344	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:13:00	56	t	2026-04-30 12:10:20
2345	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:14:00	55	t	2026-04-30 12:10:20
2346	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:15:00	54	t	2026-04-30 12:10:20
2347	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:16:00	56	t	2026-04-30 12:10:20
2348	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:17:00	57	t	2026-04-30 12:10:20
26	alex.k.kaczmarczyk@gmail.com	2026-04-06 04:20:21	51	t	2026-04-30 12:10:19
2349	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:18:00	57	t	2026-04-30 12:10:20
2350	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:19:00	60	t	2026-04-30 12:10:20
2351	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:20:00	59	t	2026-04-30 12:10:20
2352	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:21:00	57	t	2026-04-30 12:10:20
2353	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:22:00	56	t	2026-04-30 12:10:20
2354	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:23:00	60	t	2026-04-30 12:10:20
2355	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:24:00	57	t	2026-04-30 12:10:20
2356	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:26:00	59	t	2026-04-30 12:10:20
2357	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:27:00	57	t	2026-04-30 12:10:20
2358	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:28:00	56	t	2026-04-30 12:10:20
2359	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:29:00	60	t	2026-04-30 12:10:20
2360	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:30:00	60	t	2026-04-30 12:10:20
2361	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:31:00	61	t	2026-04-30 12:10:20
2363	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:32:00	55	t	2026-04-30 12:10:20
2364	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:33:00	54	t	2026-04-30 12:10:20
2365	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:34:00	55	t	2026-04-30 12:10:20
2366	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:35:00	56	t	2026-04-30 12:10:20
2367	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:36:00	54	t	2026-04-30 12:10:20
2368	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:37:00	54	t	2026-04-30 12:10:20
2369	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:38:00	55	t	2026-04-30 12:10:20
2370	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:39:00	51	t	2026-04-30 12:10:20
2371	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:40:00	50	t	2026-04-30 12:10:20
2372	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:41:00	51	t	2026-04-30 12:10:20
2373	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:42:00	51	t	2026-04-30 12:10:20
2374	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:43:00	51	t	2026-04-30 12:10:20
2375	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:44:00	49	t	2026-04-30 12:10:20
2376	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:45:00	50	t	2026-04-30 12:10:20
2377	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:46:00	51	t	2026-04-30 12:10:20
2378	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:47:00	51	t	2026-04-30 12:10:20
2379	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:48:00	52	t	2026-04-30 12:10:20
2380	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:49:00	51	t	2026-04-30 12:10:20
2381	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:50:00	51	t	2026-04-30 12:10:20
2382	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:51:00	52	t	2026-04-30 12:10:20
2383	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:52:00	51	t	2026-04-30 12:10:20
2384	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:53:00	51	t	2026-04-30 12:10:20
2385	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:54:00	51	t	2026-04-30 12:10:20
2386	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:55:00	51	t	2026-04-30 12:10:20
2387	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:56:00	49	t	2026-04-30 12:10:20
2388	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:57:00	49	t	2026-04-30 12:10:20
2389	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:58:00	50	t	2026-04-30 12:10:20
2390	alex.k.kaczmarczyk@gmail.com	2026-04-23 02:59:00	50	t	2026-04-30 12:10:20
2391	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:00:00	51	t	2026-04-30 12:10:20
2392	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:01:00	49	t	2026-04-30 12:10:20
2393	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:02:00	50	t	2026-04-30 12:10:20
2394	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:03:00	51	t	2026-04-30 12:10:20
2395	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:04:00	50	t	2026-04-30 12:10:20
2396	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:05:00	50	t	2026-04-30 12:10:20
2397	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:06:00	51	t	2026-04-30 12:10:20
2398	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:07:00	51	t	2026-04-30 12:10:20
2399	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:08:00	51	t	2026-04-30 12:10:20
2400	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:09:00	52	t	2026-04-30 12:10:20
2401	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:10:00	52	t	2026-04-30 12:10:20
2402	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:11:00	51	t	2026-04-30 12:10:20
2403	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:12:00	51	t	2026-04-30 12:10:20
2404	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:13:00	51	t	2026-04-30 12:10:20
2405	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:14:00	50	t	2026-04-30 12:10:20
2406	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:15:00	51	t	2026-04-30 12:10:20
2407	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:16:00	51	t	2026-04-30 12:10:20
2408	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:17:00	51	t	2026-04-30 12:10:20
2409	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:18:00	51	t	2026-04-30 12:10:20
2410	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:19:00	51	t	2026-04-30 12:10:20
2411	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:20:00	51	t	2026-04-30 12:10:20
2412	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:21:00	51	t	2026-04-30 12:10:20
2413	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:22:00	52	t	2026-04-30 12:10:20
2414	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:23:00	51	t	2026-04-30 12:10:20
2415	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:24:00	51	t	2026-04-30 12:10:20
2416	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:25:00	51	t	2026-04-30 12:10:20
2417	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:26:00	51	t	2026-04-30 12:10:20
2418	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:27:00	51	t	2026-04-30 12:10:20
2419	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:28:00	51	t	2026-04-30 12:10:20
2420	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:29:00	51	t	2026-04-30 12:10:20
2421	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:30:00	51	t	2026-04-30 12:10:20
2422	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:31:00	51	t	2026-04-30 12:10:20
2423	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:32:00	51	t	2026-04-30 12:10:20
2424	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:33:00	52	t	2026-04-30 12:10:20
2425	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:34:00	68	t	2026-04-30 12:10:20
2427	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:35:00	53	t	2026-04-30 12:10:20
2428	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:36:00	55	t	2026-04-30 12:10:20
2429	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:37:00	53	t	2026-04-30 12:10:20
2430	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:38:00	53	t	2026-04-30 12:10:20
2431	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:39:00	53	t	2026-04-30 12:10:20
2432	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:40:00	59	t	2026-04-30 12:10:20
2433	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:41:00	58	t	2026-04-30 12:10:20
2434	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:42:00	57	t	2026-04-30 12:10:20
2435	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:43:00	57	t	2026-04-30 12:10:20
2436	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:45:00	56	t	2026-04-30 12:10:20
2437	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:46:00	59	t	2026-04-30 12:10:20
27	alex.k.kaczmarczyk@gmail.com	2026-04-06 04:30:18	53	t	2026-04-30 12:10:19
2439	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:47:00	54	t	2026-04-30 12:10:20
2440	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:48:00	55	t	2026-04-30 12:10:20
2441	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:49:00	54	t	2026-04-30 12:10:20
2442	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:50:00	54	t	2026-04-30 12:10:20
2443	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:51:00	55	t	2026-04-30 12:10:20
2444	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:52:00	54	t	2026-04-30 12:10:20
2445	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:53:00	52	t	2026-04-30 12:10:20
2446	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:54:00	54	t	2026-04-30 12:10:20
2447	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:55:00	60	t	2026-04-30 12:10:20
2448	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:57:00	55	t	2026-04-30 12:10:20
2449	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:58:00	56	t	2026-04-30 12:10:20
2450	alex.k.kaczmarczyk@gmail.com	2026-04-23 03:59:00	56	t	2026-04-30 12:10:20
2451	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:00:00	57	t	2026-04-30 12:10:20
2452	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:01:00	57	t	2026-04-30 12:10:20
2454	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:02:00	50	t	2026-04-30 12:10:20
2455	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:03:00	51	t	2026-04-30 12:10:20
2456	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:04:00	52	t	2026-04-30 12:10:20
2457	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:05:00	53	t	2026-04-30 12:10:20
2458	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:06:00	52	t	2026-04-30 12:10:20
2459	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:07:00	51	t	2026-04-30 12:10:20
2460	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:08:00	51	t	2026-04-30 12:10:20
2461	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:09:00	52	t	2026-04-30 12:10:20
2462	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:10:00	51	t	2026-04-30 12:10:20
2463	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:11:00	52	t	2026-04-30 12:10:20
2464	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:12:00	53	t	2026-04-30 12:10:20
2465	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:13:00	51	t	2026-04-30 12:10:20
2466	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:14:00	51	t	2026-04-30 12:10:20
2467	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:15:00	52	t	2026-04-30 12:10:20
2468	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:16:00	51	t	2026-04-30 12:10:20
2469	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:17:00	51	t	2026-04-30 12:10:20
2470	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:18:00	50	t	2026-04-30 12:10:20
2471	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:20:00	50	t	2026-04-30 12:10:20
2472	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:21:00	48	t	2026-04-30 12:10:20
2473	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:22:00	52	t	2026-04-30 12:10:20
2474	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:23:00	51	t	2026-04-30 12:10:20
2475	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:24:00	51	t	2026-04-30 12:10:20
2477	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:25:00	51	t	2026-04-30 12:10:20
2478	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:26:00	50	t	2026-04-30 12:10:20
2479	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:27:00	49	t	2026-04-30 12:10:20
2480	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:28:00	49	t	2026-04-30 12:10:20
2481	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:29:00	50	t	2026-04-30 12:10:20
2482	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:30:00	50	t	2026-04-30 12:10:20
2483	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:31:00	51	t	2026-04-30 12:10:20
2484	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:32:00	51	t	2026-04-30 12:10:20
2485	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:33:00	52	t	2026-04-30 12:10:20
2486	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:34:00	51	t	2026-04-30 12:10:20
2487	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:35:00	49	t	2026-04-30 12:10:20
2488	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:36:00	50	t	2026-04-30 12:10:20
2489	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:37:00	50	t	2026-04-30 12:10:20
2490	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:38:00	49	t	2026-04-30 12:10:20
2491	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:39:00	50	t	2026-04-30 12:10:20
2492	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:40:00	49	t	2026-04-30 12:10:20
2493	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:41:00	50	t	2026-04-30 12:10:20
2494	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:42:00	50	t	2026-04-30 12:10:20
2495	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:43:00	50	t	2026-04-30 12:10:20
2496	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:44:00	49	t	2026-04-30 12:10:20
2497	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:45:00	47	t	2026-04-30 12:10:20
2498	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:46:00	47	t	2026-04-30 12:10:20
2499	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:47:00	46	t	2026-04-30 12:10:20
2500	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:48:00	46	t	2026-04-30 12:10:20
2501	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:49:00	47	t	2026-04-30 12:10:20
2502	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:50:00	47	t	2026-04-30 12:10:20
2503	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:51:00	47	t	2026-04-30 12:10:20
2504	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:52:00	47	t	2026-04-30 12:10:20
2505	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:53:00	48	t	2026-04-30 12:10:20
2506	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:54:00	48	t	2026-04-30 12:10:20
2507	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:56:00	52	t	2026-04-30 12:10:20
2508	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:57:00	48	t	2026-04-30 12:10:20
2509	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:58:00	48	t	2026-04-30 12:10:20
2510	alex.k.kaczmarczyk@gmail.com	2026-04-23 04:59:00	47	t	2026-04-30 12:10:20
2511	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:00:00	47	t	2026-04-30 12:10:20
2513	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:01:00	48	t	2026-04-30 12:10:20
2514	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:02:00	47	t	2026-04-30 12:10:20
2515	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:03:00	49	t	2026-04-30 12:10:20
2516	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:04:00	50	t	2026-04-30 12:10:20
2517	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:05:00	53	t	2026-04-30 12:10:20
2518	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:06:00	51	t	2026-04-30 12:10:20
2519	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:07:00	51	t	2026-04-30 12:10:20
2520	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:08:00	51	t	2026-04-30 12:10:20
2521	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:09:00	52	t	2026-04-30 12:10:20
2522	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:11:00	51	t	2026-04-30 12:10:20
2523	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:12:00	51	t	2026-04-30 12:10:20
2524	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:13:00	52	t	2026-04-30 12:10:20
2525	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:14:00	51	t	2026-04-30 12:10:20
2526	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:15:00	55	t	2026-04-30 12:10:20
2528	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:16:00	49	t	2026-04-30 12:10:20
2529	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:17:00	50	t	2026-04-30 12:10:20
28	alex.k.kaczmarczyk@gmail.com	2026-04-06 04:40:21	51	t	2026-04-30 12:10:19
2530	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:18:00	51	t	2026-04-30 12:10:20
2531	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:19:00	51	t	2026-04-30 12:10:20
2532	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:20:00	49	t	2026-04-30 12:10:20
2533	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:21:00	49	t	2026-04-30 12:10:20
2534	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:22:00	49	t	2026-04-30 12:10:20
2535	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:23:00	50	t	2026-04-30 12:10:20
2536	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:24:00	50	t	2026-04-30 12:10:20
2537	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:26:00	49	t	2026-04-30 12:10:20
2538	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:27:00	51	t	2026-04-30 12:10:20
2539	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:28:00	47	t	2026-04-30 12:10:20
2540	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:29:00	47	t	2026-04-30 12:10:20
2541	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:30:00	47	t	2026-04-30 12:10:20
2543	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:32:00	52	t	2026-04-30 12:10:20
2545	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:33:00	55	t	2026-04-30 12:10:20
2546	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:34:00	61	t	2026-04-30 12:10:20
2547	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:35:00	55	t	2026-04-30 12:10:20
2548	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:36:00	52	t	2026-04-30 12:10:20
2549	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:37:00	50	t	2026-04-30 12:10:20
2550	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:38:00	49	t	2026-04-30 12:10:20
2551	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:39:00	49	t	2026-04-30 12:10:20
2552	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:40:00	49	t	2026-04-30 12:10:20
2553	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:41:00	49	t	2026-04-30 12:10:20
2554	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:42:00	49	t	2026-04-30 12:10:20
2555	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:43:00	52	t	2026-04-30 12:10:20
2556	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:44:00	49	t	2026-04-30 12:10:20
2557	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:45:00	47	t	2026-04-30 12:10:20
2558	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:46:00	47	t	2026-04-30 12:10:20
2559	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:47:00	47	t	2026-04-30 12:10:20
2560	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:48:00	47	t	2026-04-30 12:10:20
2561	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:49:00	46	t	2026-04-30 12:10:20
2562	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:50:00	49	t	2026-04-30 12:10:20
2563	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:51:00	48	t	2026-04-30 12:10:20
2564	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:53:00	49	t	2026-04-30 12:10:20
2565	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:54:00	48	t	2026-04-30 12:10:20
2566	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:55:00	48	t	2026-04-30 12:10:20
2567	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:56:00	48	t	2026-04-30 12:10:20
2569	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:57:00	53	t	2026-04-30 12:10:20
2570	alex.k.kaczmarczyk@gmail.com	2026-04-23 05:58:00	52	t	2026-04-30 12:10:20
2571	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:00:00	50	t	2026-04-30 12:10:20
2572	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:01:00	49	t	2026-04-30 12:10:20
2573	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:02:00	51	t	2026-04-30 12:10:20
2574	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:03:00	49	t	2026-04-30 12:10:20
2575	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:04:00	49	t	2026-04-30 12:10:20
2576	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:05:00	49	t	2026-04-30 12:10:20
2577	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:06:00	50	t	2026-04-30 12:10:20
2578	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:07:00	51	t	2026-04-30 12:10:20
2579	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:08:00	57	t	2026-04-30 12:10:20
2580	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:09:00	49	t	2026-04-30 12:10:20
2581	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:10:00	48	t	2026-04-30 12:10:20
2582	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:11:00	48	t	2026-04-30 12:10:20
2583	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:12:00	48	t	2026-04-30 12:10:20
2584	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:13:00	48	t	2026-04-30 12:10:20
2585	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:14:00	49	t	2026-04-30 12:10:20
2586	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:15:00	50	t	2026-04-30 12:10:20
2587	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:16:00	51	t	2026-04-30 12:10:20
2588	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:17:00	51	t	2026-04-30 12:10:20
2589	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:18:00	54	t	2026-04-30 12:10:20
2590	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:19:00	56	t	2026-04-30 12:10:20
2591	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:20:00	57	t	2026-04-30 12:10:20
2592	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:21:00	54	t	2026-04-30 12:10:20
2593	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:22:00	53	t	2026-04-30 12:10:20
2594	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:23:00	56	t	2026-04-30 12:10:20
2595	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:24:00	58	t	2026-04-30 12:10:20
2596	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:25:00	59	t	2026-04-30 12:10:20
2597	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:26:00	59	t	2026-04-30 12:10:20
2598	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:27:00	56	t	2026-04-30 12:10:20
2599	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:29:00	54	t	2026-04-30 12:10:20
2600	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:30:00	53	t	2026-04-30 12:10:20
2601	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:31:00	53	t	2026-04-30 12:10:20
2602	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:32:00	55	t	2026-04-30 12:10:20
2603	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:33:00	55	t	2026-04-30 12:10:20
2604	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:34:00	53	t	2026-04-30 12:10:20
2605	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:35:00	55	t	2026-04-30 12:10:20
2607	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:36:00	62	t	2026-04-30 12:10:20
2608	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:37:00	53	t	2026-04-30 12:10:20
2609	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:38:00	55	t	2026-04-30 12:10:20
2610	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:39:00	53	t	2026-04-30 12:10:20
2611	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:40:00	51	t	2026-04-30 12:10:20
2612	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:41:00	51	t	2026-04-30 12:10:20
2613	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:42:00	51	t	2026-04-30 12:10:20
2614	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:43:00	52	t	2026-04-30 12:10:20
2615	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:44:00	50	t	2026-04-30 12:10:20
2616	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:45:00	54	t	2026-04-30 12:10:20
2617	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:46:00	51	t	2026-04-30 12:10:20
2618	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:47:00	53	t	2026-04-30 12:10:20
2619	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:48:00	51	t	2026-04-30 12:10:20
2620	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:49:00	52	t	2026-04-30 12:10:20
29	alex.k.kaczmarczyk@gmail.com	2026-04-06 04:50:21	50	t	2026-04-30 12:10:19
2621	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:50:00	53	t	2026-04-30 12:10:20
2622	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:51:00	53	t	2026-04-30 12:10:20
2623	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:52:00	54	t	2026-04-30 12:10:20
2624	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:53:00	55	t	2026-04-30 12:10:20
2625	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:54:00	64	t	2026-04-30 12:10:20
2626	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:55:00	62	t	2026-04-30 12:10:20
2627	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:56:00	58	t	2026-04-30 12:10:20
2628	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:57:00	58	t	2026-04-30 12:10:20
2629	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:58:00	60	t	2026-04-30 12:10:20
2630	alex.k.kaczmarczyk@gmail.com	2026-04-23 06:59:00	58	t	2026-04-30 12:10:20
2631	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:00:00	58	t	2026-04-30 12:10:20
2632	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:01:00	53	t	2026-04-30 12:10:20
2633	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:02:00	53	t	2026-04-30 12:10:20
2634	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:03:00	55	t	2026-04-30 12:10:20
2635	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:04:00	52	t	2026-04-30 12:10:20
2636	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:05:00	52	t	2026-04-30 12:10:20
2637	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:06:00	55	t	2026-04-30 12:10:20
2638	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:07:00	55	t	2026-04-30 12:10:20
2639	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:08:00	50	t	2026-04-30 12:10:20
2640	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:09:00	50	t	2026-04-30 12:10:20
2641	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:10:00	48	t	2026-04-30 12:10:20
2642	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:11:00	66	f	2026-04-30 12:10:20
2643	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:12:00	64	t	2026-04-30 12:10:20
2644	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:13:00	66	f	2026-04-30 12:10:20
2645	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:14:00	56	t	2026-04-30 12:10:20
2646	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:15:00	53	t	2026-04-30 12:10:20
2647	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:16:00	51	t	2026-04-30 12:10:20
2648	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:17:00	51	t	2026-04-30 12:10:20
2649	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:18:00	51	t	2026-04-30 12:10:20
2650	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:19:00	51	t	2026-04-30 12:10:20
2651	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:20:00	51	t	2026-04-30 12:10:20
2652	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:21:00	52	t	2026-04-30 12:10:20
2653	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:22:00	51	t	2026-04-30 12:10:20
2654	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:23:00	52	t	2026-04-30 12:10:20
2655	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:24:00	53	t	2026-04-30 12:10:20
2656	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:25:00	53	t	2026-04-30 12:10:20
2657	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:26:00	49	t	2026-04-30 12:10:20
2658	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:27:00	48	t	2026-04-30 12:10:20
2659	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:28:00	48	t	2026-04-30 12:10:20
2660	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:29:00	47	t	2026-04-30 12:10:20
2661	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:30:00	48	t	2026-04-30 12:10:20
2662	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:31:00	47	t	2026-04-30 12:10:20
2663	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:32:00	48	t	2026-04-30 12:10:20
2664	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:33:00	50	t	2026-04-30 12:10:20
2665	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:34:00	49	t	2026-04-30 12:10:20
2666	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:35:00	49	t	2026-04-30 12:10:20
2667	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:36:00	50	t	2026-04-30 12:10:20
2668	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:38:00	49	t	2026-04-30 12:10:20
2669	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:39:00	49	t	2026-04-30 12:10:20
2670	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:40:00	50	t	2026-04-30 12:10:20
2671	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:41:00	50	t	2026-04-30 12:10:20
2672	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:42:00	49	t	2026-04-30 12:10:20
2673	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:43:00	50	t	2026-04-30 12:10:20
2674	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:44:00	49	t	2026-04-30 12:10:20
2676	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:45:00	52	t	2026-04-30 12:10:20
2677	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:46:00	51	t	2026-04-30 12:10:20
2678	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:47:00	51	t	2026-04-30 12:10:20
2679	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:48:00	51	t	2026-04-30 12:10:20
2680	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:49:00	53	t	2026-04-30 12:10:20
2681	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:50:00	52	t	2026-04-30 12:10:20
2682	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:51:00	51	t	2026-04-30 12:10:20
2683	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:52:00	51	t	2026-04-30 12:10:20
2684	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:53:00	53	t	2026-04-30 12:10:20
2685	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:54:00	51	t	2026-04-30 12:10:20
2686	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:55:00	51	t	2026-04-30 12:10:20
2687	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:56:00	52	t	2026-04-30 12:10:20
2688	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:58:00	54	t	2026-04-30 12:10:20
2689	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:59:00	51	t	2026-04-30 12:10:20
2690	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:00:00	50	t	2026-04-30 12:10:20
2692	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:01:00	53	t	2026-04-30 12:10:20
2693	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:02:00	55	t	2026-04-30 12:10:20
2694	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:03:00	53	t	2026-04-30 12:10:20
2695	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:04:00	53	t	2026-04-30 12:10:20
2696	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:05:00	51	t	2026-04-30 12:10:20
2697	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:06:00	52	t	2026-04-30 12:10:20
2698	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:07:00	52	t	2026-04-30 12:10:20
2699	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:08:00	53	t	2026-04-30 12:10:20
2700	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:09:00	56	t	2026-04-30 12:10:20
2701	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:10:00	57	t	2026-04-30 12:10:20
2702	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:11:00	59	t	2026-04-30 12:10:20
2703	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:12:00	61	t	2026-04-30 12:10:20
2704	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:13:00	65	f	2026-04-30 12:10:20
2705	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:14:00	63	t	2026-04-30 12:10:20
2706	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:15:00	59	t	2026-04-30 12:10:20
2707	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:16:00	58	t	2026-04-30 12:10:20
2708	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:17:00	58	t	2026-04-30 12:10:20
2709	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:18:00	61	t	2026-04-30 12:10:20
30	alex.k.kaczmarczyk@gmail.com	2026-04-06 05:00:09	55	t	2026-04-30 12:10:19
2710	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:19:00	60	t	2026-04-30 12:10:20
2711	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:20:00	56	t	2026-04-30 12:10:20
2712	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:21:00	57	t	2026-04-30 12:10:20
2713	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:22:00	57	t	2026-04-30 12:10:20
2714	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:23:00	62	t	2026-04-30 12:10:20
2715	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:24:00	61	t	2026-04-30 12:10:20
2716	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:25:00	53	t	2026-04-30 12:10:20
2717	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:26:00	53	t	2026-04-30 12:10:20
2718	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:27:00	53	t	2026-04-30 12:10:20
2719	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:28:00	52	t	2026-04-30 12:10:20
2720	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:29:00	51	t	2026-04-30 12:10:20
2721	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:30:00	50	t	2026-04-30 12:10:20
2722	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:31:00	52	t	2026-04-30 12:10:20
2723	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:32:00	57	t	2026-04-30 12:10:20
2724	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:33:00	51	t	2026-04-30 12:10:20
2725	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:34:00	51	t	2026-04-30 12:10:20
2726	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:35:00	50	t	2026-04-30 12:10:20
2727	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:36:00	50	t	2026-04-30 12:10:20
2728	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:37:00	50	t	2026-04-30 12:10:20
2729	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:38:00	49	t	2026-04-30 12:10:20
2730	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:39:00	51	t	2026-04-30 12:10:20
2731	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:40:00	48	t	2026-04-30 12:10:20
2732	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:41:00	48	t	2026-04-30 12:10:20
2733	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:42:00	50	t	2026-04-30 12:10:20
2734	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:43:00	50	t	2026-04-30 12:10:20
2735	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:44:00	51	t	2026-04-30 12:10:20
2736	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:45:00	51	t	2026-04-30 12:10:20
2737	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:46:00	53	t	2026-04-30 12:10:20
2738	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:47:00	50	t	2026-04-30 12:10:20
2739	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:48:00	50	t	2026-04-30 12:10:20
2740	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:49:00	49	t	2026-04-30 12:10:20
2741	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:50:00	50	t	2026-04-30 12:10:20
2742	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:51:00	75	f	2026-04-30 12:10:20
2743	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:52:00	59	t	2026-04-30 12:10:20
2744	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:53:00	51	t	2026-04-30 12:10:20
2745	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:54:00	41	t	2026-04-30 12:10:20
2746	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:55:00	40	t	2026-04-30 12:10:20
2747	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:56:00	40	t	2026-04-30 12:10:20
2748	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:57:00	47	t	2026-04-30 12:10:20
2749	alex.k.kaczmarczyk@gmail.com	2026-04-23 08:58:00	60	t	2026-04-30 12:10:20
2750	alex.k.kaczmarczyk@gmail.com	2026-04-23 09:00:00	56	t	2026-04-30 12:10:20
2751	alex.k.kaczmarczyk@gmail.com	2026-04-23 09:01:00	59	t	2026-04-30 12:10:20
2752	alex.k.kaczmarczyk@gmail.com	2026-04-23 09:02:00	56	t	2026-04-30 12:10:20
2753	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:12:00	56	t	2026-04-30 12:10:20
2754	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:13:00	56	t	2026-04-30 12:10:20
2755	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:14:00	58	t	2026-04-30 12:10:20
2756	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:15:00	95	f	2026-04-30 12:10:20
2757	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:16:00	98	f	2026-04-30 12:10:20
2758	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:17:00	101	f	2026-04-30 12:10:20
2760	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:18:00	94	f	2026-04-30 12:10:20
2761	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:19:00	85	f	2026-04-30 12:10:20
2762	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:21:00	88	f	2026-04-30 12:10:20
2763	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:22:00	87	f	2026-04-30 12:10:20
2764	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:23:00	78	f	2026-04-30 12:10:20
2765	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:24:00	81	f	2026-04-30 12:10:20
2766	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:25:00	86	f	2026-04-30 12:10:20
2767	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:26:00	90	f	2026-04-30 12:10:20
2768	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:27:00	84	f	2026-04-30 12:10:20
2769	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:28:00	92	f	2026-04-30 12:10:20
2770	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:29:00	103	f	2026-04-30 12:10:20
2771	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:30:00	105	f	2026-04-30 12:10:20
2772	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:31:00	102	f	2026-04-30 12:10:20
2773	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:32:00	102	f	2026-04-30 12:10:20
2774	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:33:00	96	f	2026-04-30 12:10:20
2775	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:34:00	97	f	2026-04-30 12:10:20
2776	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:35:00	101	f	2026-04-30 12:10:20
2777	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:36:00	97	f	2026-04-30 12:10:20
2778	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:37:00	98	f	2026-04-30 12:10:20
2779	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:38:00	94	f	2026-04-30 12:10:20
2780	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:39:00	95	f	2026-04-30 12:10:20
2781	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:40:00	91	f	2026-04-30 12:10:20
2782	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:41:00	93	f	2026-04-30 12:10:20
2783	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:42:00	84	f	2026-04-30 12:10:20
2784	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:43:00	82	f	2026-04-30 12:10:20
2785	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:44:00	90	f	2026-04-30 12:10:20
2787	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:46:00	87	f	2026-04-30 12:10:20
2788	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:47:00	83	f	2026-04-30 12:10:20
2789	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:48:00	81	f	2026-04-30 12:10:20
2791	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:50:00	85	f	2026-04-30 12:10:20
2792	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:51:00	86	f	2026-04-30 12:10:20
2793	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:52:00	86	f	2026-04-30 12:10:20
2794	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:53:00	78	f	2026-04-30 12:10:20
2795	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:54:00	71	f	2026-04-30 12:10:20
2796	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:55:00	75	f	2026-04-30 12:10:20
2797	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:56:00	76	f	2026-04-30 12:10:20
2798	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:57:00	68	f	2026-04-30 12:10:20
2799	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:58:00	68	f	2026-04-30 12:10:20
31	alex.k.kaczmarczyk@gmail.com	2026-04-06 05:10:19	50	t	2026-04-30 12:10:19
2800	alex.k.kaczmarczyk@gmail.com	2026-04-23 18:59:00	74	f	2026-04-30 12:10:20
2801	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:00:00	68	f	2026-04-30 12:10:20
2802	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:01:00	73	f	2026-04-30 12:10:20
2803	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:02:00	70	f	2026-04-30 12:10:20
2804	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:03:00	68	f	2026-04-30 12:10:20
2805	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:04:00	63	t	2026-04-30 12:10:20
2806	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:05:00	62	t	2026-04-30 12:10:20
2808	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:06:00	62	t	2026-04-30 12:10:20
2809	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:07:00	60	t	2026-04-30 12:10:20
2810	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:08:00	60	t	2026-04-30 12:10:20
2811	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:10:00	59	t	2026-04-30 12:10:20
2812	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:11:00	62	t	2026-04-30 12:10:20
2814	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:13:00	60	t	2026-04-30 12:10:20
2815	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:14:00	60	t	2026-04-30 12:10:20
2816	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:15:00	60	t	2026-04-30 12:10:20
2817	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:16:00	60	t	2026-04-30 12:10:20
2818	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:17:00	60	t	2026-04-30 12:10:20
2819	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:18:00	61	t	2026-04-30 12:10:20
2820	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:19:00	61	t	2026-04-30 12:10:20
2821	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:20:00	60	t	2026-04-30 12:10:20
2822	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:21:00	61	t	2026-04-30 12:10:20
2823	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:22:00	61	t	2026-04-30 12:10:20
2824	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:23:00	63	t	2026-04-30 12:10:20
2826	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:24:00	73	f	2026-04-30 12:10:20
2827	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:25:00	69	f	2026-04-30 12:10:20
2828	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:26:00	71	f	2026-04-30 12:10:20
2829	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:28:00	80	f	2026-04-30 12:10:20
2831	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:29:00	63	t	2026-04-30 12:10:20
2832	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:30:00	60	t	2026-04-30 12:10:20
2833	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:31:00	63	t	2026-04-30 12:10:20
2834	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:32:00	62	t	2026-04-30 12:10:20
2835	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:33:00	61	t	2026-04-30 12:10:20
2836	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:34:00	64	t	2026-04-30 12:10:20
2837	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:35:00	62	t	2026-04-30 12:10:20
2838	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:36:00	63	t	2026-04-30 12:10:20
2839	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:37:00	64	t	2026-04-30 12:10:20
2840	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:39:00	62	t	2026-04-30 12:10:20
2841	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:40:00	63	t	2026-04-30 12:10:20
2843	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:41:00	64	t	2026-04-30 12:10:20
2844	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:42:00	64	t	2026-04-30 12:10:20
2845	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:43:00	64	t	2026-04-30 12:10:20
2846	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:44:00	64	t	2026-04-30 12:10:20
2847	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:46:00	66	f	2026-04-30 12:10:20
2848	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:47:00	65	f	2026-04-30 12:10:20
2849	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:48:00	65	f	2026-04-30 12:10:20
2850	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:49:00	63	t	2026-04-30 12:10:20
2852	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:51:00	63	t	2026-04-30 12:10:20
2853	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:52:00	62	t	2026-04-30 12:10:20
2855	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:53:00	61	t	2026-04-30 12:10:20
2856	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:54:00	63	t	2026-04-30 12:10:20
2857	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:55:00	61	t	2026-04-30 12:10:20
2858	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:56:00	63	t	2026-04-30 12:10:20
2859	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:57:00	63	t	2026-04-30 12:10:20
2860	alex.k.kaczmarczyk@gmail.com	2026-04-23 19:58:00	63	t	2026-04-30 12:10:20
2861	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:00:00	68	f	2026-04-30 12:10:20
2862	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:01:00	67	f	2026-04-30 12:10:20
2863	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:02:00	66	f	2026-04-30 12:10:20
2864	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:03:00	64	t	2026-04-30 12:10:20
2865	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:05:00	64	t	2026-04-30 12:10:20
2866	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:06:00	66	f	2026-04-30 12:10:20
2867	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:07:00	62	t	2026-04-30 12:10:20
2868	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:08:00	66	f	2026-04-30 12:10:20
2869	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:09:00	60	t	2026-04-30 12:10:20
2870	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:10:00	63	t	2026-04-30 12:10:20
2871	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:11:00	63	t	2026-04-30 12:10:20
2873	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:12:00	62	t	2026-04-30 12:10:20
2874	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:13:00	64	t	2026-04-30 12:10:20
2875	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:15:00	64	t	2026-04-30 12:10:20
2876	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:16:00	62	t	2026-04-30 12:10:20
2878	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:18:00	61	t	2026-04-30 12:10:20
2879	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:19:00	60	t	2026-04-30 12:10:20
2880	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:20:00	62	t	2026-04-30 12:10:20
2882	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:22:00	63	t	2026-04-30 12:10:20
2883	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:23:00	63	t	2026-04-30 12:10:20
2884	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:24:00	66	f	2026-04-30 12:10:20
2885	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:25:00	67	f	2026-04-30 12:10:20
2886	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:26:00	63	t	2026-04-30 12:10:20
2887	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:27:00	64	t	2026-04-30 12:10:20
2889	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:28:00	77	f	2026-04-30 12:10:20
2890	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:29:00	86	f	2026-04-30 12:10:20
2891	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:31:00	87	f	2026-04-30 12:10:20
2893	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:32:00	79	f	2026-04-30 12:10:20
2894	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:34:00	83	f	2026-04-30 12:10:20
2895	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:35:00	84	f	2026-04-30 12:10:20
2896	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:36:00	83	f	2026-04-30 12:10:20
2897	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:37:00	86	f	2026-04-30 12:10:20
2899	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:38:00	90	f	2026-04-30 12:10:20
32	alex.k.kaczmarczyk@gmail.com	2026-04-06 05:20:11	59	t	2026-04-30 12:10:19
2900	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:39:00	96	f	2026-04-30 12:10:20
2901	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:40:00	91	f	2026-04-30 12:10:20
2902	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:41:00	91	f	2026-04-30 12:10:20
2903	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:42:00	115	f	2026-04-30 12:10:20
2904	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:43:00	109	f	2026-04-30 12:10:20
2905	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:44:00	108	f	2026-04-30 12:10:20
2906	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:45:00	97	f	2026-04-30 12:10:20
2907	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:46:00	85	f	2026-04-30 12:10:20
2908	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:47:00	86	f	2026-04-30 12:10:20
2909	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:49:00	88	f	2026-04-30 12:10:20
2911	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:50:00	92	f	2026-04-30 12:10:20
2912	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:51:00	93	f	2026-04-30 12:10:20
2913	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:52:00	95	f	2026-04-30 12:10:20
2914	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:53:00	96	f	2026-04-30 12:10:20
2915	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:54:00	79	f	2026-04-30 12:10:20
2916	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:55:00	88	f	2026-04-30 12:10:20
2917	alex.k.kaczmarczyk@gmail.com	2026-04-23 20:56:00	91	f	2026-04-30 12:10:20
2918	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:01:00	80	f	2026-04-30 12:10:20
2919	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:02:00	59	t	2026-04-30 12:10:20
2920	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:03:00	56	t	2026-04-30 12:10:20
2921	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:04:00	55	t	2026-04-30 12:10:20
2922	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:05:00	54	t	2026-04-30 12:10:20
2923	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:06:00	54	t	2026-04-30 12:10:20
2924	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:07:00	53	t	2026-04-30 12:10:20
2925	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:08:00	53	t	2026-04-30 12:10:20
2926	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:09:00	53	t	2026-04-30 12:10:20
2927	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:10:00	51	t	2026-04-30 12:10:20
2928	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:11:00	52	t	2026-04-30 12:10:20
2929	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:12:00	52	t	2026-04-30 12:10:20
2930	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:13:00	53	t	2026-04-30 12:10:20
2931	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:14:00	52	t	2026-04-30 12:10:20
2932	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:15:00	52	t	2026-04-30 12:10:20
2933	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:16:00	52	t	2026-04-30 12:10:20
2934	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:17:00	52	t	2026-04-30 12:10:20
2935	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:18:00	52	t	2026-04-30 12:10:20
2936	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:19:00	52	t	2026-04-30 12:10:20
2937	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:20:00	52	t	2026-04-30 12:10:20
2938	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:21:00	50	t	2026-04-30 12:10:20
2939	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:22:00	51	t	2026-04-30 12:10:20
2940	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:24:00	52	t	2026-04-30 12:10:20
2941	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:25:00	51	t	2026-04-30 12:10:20
2942	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:26:00	54	t	2026-04-30 12:10:20
2943	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:27:00	48	t	2026-04-30 12:10:20
2944	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:28:00	49	t	2026-04-30 12:10:20
2945	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:29:00	48	t	2026-04-30 12:10:20
2946	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:30:00	49	t	2026-04-30 12:10:20
2948	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:31:00	55	t	2026-04-30 12:10:20
2949	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:32:00	49	t	2026-04-30 12:10:20
2950	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:33:00	48	t	2026-04-30 12:10:20
2951	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:34:00	48	t	2026-04-30 12:10:20
2952	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:35:00	48	t	2026-04-30 12:10:20
2953	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:36:00	48	t	2026-04-30 12:10:20
2954	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:37:00	47	t	2026-04-30 12:10:20
2955	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:38:00	48	t	2026-04-30 12:10:20
2956	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:39:00	48	t	2026-04-30 12:10:20
2957	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:41:00	48	t	2026-04-30 12:10:20
2958	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:42:00	50	t	2026-04-30 12:10:20
2959	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:43:00	50	t	2026-04-30 12:10:20
2960	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:44:00	48	t	2026-04-30 12:10:20
2961	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:45:00	49	t	2026-04-30 12:10:20
2963	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:46:00	59	t	2026-04-30 12:10:20
2964	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:47:00	59	t	2026-04-30 12:10:20
2965	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:48:00	80	f	2026-04-30 12:10:20
2966	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:49:00	95	f	2026-04-30 12:10:20
2967	alex.k.kaczmarczyk@gmail.com	2026-04-24 05:51:00	97	f	2026-04-30 12:10:20
2968	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:10:00	91	f	2026-04-30 12:10:20
2969	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:11:00	93	f	2026-04-30 12:10:20
2970	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:12:00	88	f	2026-04-30 12:10:20
2971	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:13:00	86	f	2026-04-30 12:10:20
2972	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:14:00	81	f	2026-04-30 12:10:20
2973	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:15:00	84	f	2026-04-30 12:10:20
2974	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:16:00	86	f	2026-04-30 12:10:20
2975	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:17:00	86	f	2026-04-30 12:10:20
2976	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:19:00	85	f	2026-04-30 12:10:20
2978	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:20:00	85	f	2026-04-30 12:10:20
2979	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:21:00	81	f	2026-04-30 12:10:20
2980	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:22:00	83	f	2026-04-30 12:10:20
2981	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:23:00	77	f	2026-04-30 12:10:20
2982	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:24:00	69	f	2026-04-30 12:10:20
2983	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:25:00	69	f	2026-04-30 12:10:20
2984	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:26:00	74	f	2026-04-30 12:10:20
2985	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:27:00	65	f	2026-04-30 12:10:20
2986	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:28:00	65	f	2026-04-30 12:10:20
2987	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:29:00	65	f	2026-04-30 12:10:20
2988	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:30:00	68	f	2026-04-30 12:10:20
2989	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:31:00	65	f	2026-04-30 12:10:20
2990	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:32:00	65	f	2026-04-30 12:10:20
33	alex.k.kaczmarczyk@gmail.com	2026-04-06 05:30:09	52	t	2026-04-30 12:10:19
2991	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:33:00	66	f	2026-04-30 12:10:20
2992	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:34:00	64	t	2026-04-30 12:10:20
2993	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:35:00	64	t	2026-04-30 12:10:20
2994	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:36:00	64	t	2026-04-30 12:10:20
2995	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:37:00	70	f	2026-04-30 12:10:20
2996	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:38:00	65	f	2026-04-30 12:10:20
2997	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:39:00	63	t	2026-04-30 12:10:20
2998	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:40:00	67	f	2026-04-30 12:10:20
2999	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:41:00	67	f	2026-04-30 12:10:20
3000	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:42:00	68	f	2026-04-30 12:10:20
3001	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:43:00	68	f	2026-04-30 12:10:20
3002	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:44:00	60	t	2026-04-30 12:10:20
3003	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:45:00	62	t	2026-04-30 12:10:20
3004	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:46:00	62	t	2026-04-30 12:10:20
3005	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:47:00	61	t	2026-04-30 12:10:20
3006	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:48:00	63	t	2026-04-30 12:10:20
3007	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:49:00	57	t	2026-04-30 12:10:20
3008	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:50:00	57	t	2026-04-30 12:10:20
3009	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:51:00	63	t	2026-04-30 12:10:20
3010	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:52:00	69	f	2026-04-30 12:10:20
3011	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:53:00	67	f	2026-04-30 12:10:20
3012	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:54:00	60	t	2026-04-30 12:10:20
3013	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:55:00	69	f	2026-04-30 12:10:20
3014	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:56:00	69	f	2026-04-30 12:10:20
3015	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:57:00	63	t	2026-04-30 12:10:20
3017	alex.k.kaczmarczyk@gmail.com	2026-04-24 06:58:00	85	f	2026-04-30 12:10:20
3018	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:00:00	90	f	2026-04-30 12:10:20
3019	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:01:00	90	f	2026-04-30 12:10:20
3020	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:02:00	74	f	2026-04-30 12:10:20
3021	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:03:00	71	f	2026-04-30 12:10:20
3022	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:04:00	70	f	2026-04-30 12:10:20
3023	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:05:00	73	f	2026-04-30 12:10:20
3024	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:06:00	77	f	2026-04-30 12:10:20
3025	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:07:00	76	f	2026-04-30 12:10:20
3026	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:08:00	78	f	2026-04-30 12:10:20
3028	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:09:00	91	f	2026-04-30 12:10:20
3029	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:10:00	90	f	2026-04-30 12:10:20
3030	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:11:00	90	f	2026-04-30 12:10:20
3031	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:12:00	86	f	2026-04-30 12:10:20
3032	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:13:00	66	f	2026-04-30 12:10:20
3033	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:14:00	64	t	2026-04-30 12:10:20
3034	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:15:00	61	t	2026-04-30 12:10:20
3035	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:16:00	66	f	2026-04-30 12:10:20
3036	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:17:00	72	f	2026-04-30 12:10:20
3037	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:18:00	66	f	2026-04-30 12:10:20
3038	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:20:00	74	f	2026-04-30 12:10:20
3039	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:21:00	97	f	2026-04-30 12:10:20
3040	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:22:00	93	f	2026-04-30 12:10:20
3041	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:23:00	94	f	2026-04-30 12:10:20
3042	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:24:00	112	f	2026-04-30 12:10:20
3044	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:25:00	111	f	2026-04-30 12:10:20
3045	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:27:00	91	f	2026-04-30 12:10:20
3046	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:28:00	87	f	2026-04-30 12:10:20
3047	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:29:00	61	t	2026-04-30 12:10:20
3048	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:30:00	62	t	2026-04-30 12:10:20
3049	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:31:00	61	t	2026-04-30 12:10:20
3050	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:32:00	62	t	2026-04-30 12:10:20
3051	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:33:00	62	t	2026-04-30 12:10:20
3052	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:34:00	61	t	2026-04-30 12:10:20
3054	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:36:00	68	f	2026-04-30 12:10:20
3055	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:37:00	69	f	2026-04-30 12:10:20
3056	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:38:00	71	f	2026-04-30 12:10:20
3057	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:39:00	68	f	2026-04-30 12:10:20
3058	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:40:00	67	f	2026-04-30 12:10:20
3059	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:41:00	71	f	2026-04-30 12:10:20
3060	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:42:00	71	f	2026-04-30 12:10:20
3061	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:43:00	88	f	2026-04-30 12:10:20
3063	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:45:00	83	f	2026-04-30 12:10:20
3064	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:46:00	82	f	2026-04-30 12:10:20
3066	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:47:00	82	f	2026-04-30 12:10:20
3067	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:48:00	79	f	2026-04-30 12:10:20
3068	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:50:00	82	f	2026-04-30 12:10:20
3070	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:51:00	70	f	2026-04-30 12:10:20
3071	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:53:00	69	f	2026-04-30 12:10:20
3072	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:54:00	66	f	2026-04-30 12:10:20
3073	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:55:00	71	f	2026-04-30 12:10:20
3074	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:56:00	64	t	2026-04-30 12:10:20
3075	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:57:00	63	t	2026-04-30 12:10:20
3076	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:58:00	66	f	2026-04-30 12:10:20
3077	alex.k.kaczmarczyk@gmail.com	2026-04-24 07:59:00	60	t	2026-04-30 12:10:20
3078	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:00:00	72	f	2026-04-30 12:10:20
3080	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:02:00	67	f	2026-04-30 12:10:20
3081	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:03:00	61	t	2026-04-30 12:10:20
3082	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:04:00	61	t	2026-04-30 12:10:20
3083	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:05:00	65	f	2026-04-30 12:10:20
3084	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:06:00	62	t	2026-04-30 12:10:20
3085	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:07:00	71	f	2026-04-30 12:10:20
34	alex.k.kaczmarczyk@gmail.com	2026-04-06 05:40:09	52	t	2026-04-30 12:10:19
3086	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:08:00	69	f	2026-04-30 12:10:20
3087	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:09:00	61	t	2026-04-30 12:10:20
3088	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:10:00	63	t	2026-04-30 12:10:20
3089	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:11:00	71	f	2026-04-30 12:10:20
3090	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:12:00	73	f	2026-04-30 12:10:20
3091	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:13:00	67	f	2026-04-30 12:10:20
3092	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:14:00	68	f	2026-04-30 12:10:20
3093	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:15:00	65	f	2026-04-30 12:10:20
3095	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:16:00	69	f	2026-04-30 12:10:20
3096	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:18:00	86	f	2026-04-30 12:10:20
3097	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:19:00	68	f	2026-04-30 12:10:20
3098	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:20:00	65	f	2026-04-30 12:10:20
3099	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:21:00	67	f	2026-04-30 12:10:20
3100	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:22:00	73	f	2026-04-30 12:10:20
3101	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:23:00	76	f	2026-04-30 12:10:20
3102	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:24:00	75	f	2026-04-30 12:10:20
3103	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:25:00	79	f	2026-04-30 12:10:20
3105	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:27:00	68	f	2026-04-30 12:10:20
3106	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:28:00	64	t	2026-04-30 12:10:20
3107	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:29:00	63	t	2026-04-30 12:10:20
3108	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:30:00	59	t	2026-04-30 12:10:20
3109	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:31:00	64	t	2026-04-30 12:10:20
3110	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:32:00	62	t	2026-04-30 12:10:20
3111	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:33:00	63	t	2026-04-30 12:10:20
3112	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:34:00	62	t	2026-04-30 12:10:20
3113	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:35:00	60	t	2026-04-30 12:10:20
3114	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:36:00	62	t	2026-04-30 12:10:20
3115	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:37:00	63	t	2026-04-30 12:10:20
3116	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:38:00	66	f	2026-04-30 12:10:20
3117	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:39:00	66	f	2026-04-30 12:10:20
3118	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:40:00	67	f	2026-04-30 12:10:20
3119	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:41:00	65	f	2026-04-30 12:10:20
3120	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:42:00	69	f	2026-04-30 12:10:20
3121	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:43:00	68	f	2026-04-30 12:10:20
3123	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:44:00	98	f	2026-04-30 12:10:20
3124	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:46:00	86	f	2026-04-30 12:10:20
3125	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:47:00	74	f	2026-04-30 12:10:20
3127	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:49:00	68	f	2026-04-30 12:10:20
3128	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:50:00	66	f	2026-04-30 12:10:20
3129	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:51:00	68	f	2026-04-30 12:10:20
3130	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:52:00	69	f	2026-04-30 12:10:20
3131	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:53:00	68	f	2026-04-30 12:10:20
3133	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:55:00	70	f	2026-04-30 12:10:20
3134	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:56:00	71	f	2026-04-30 12:10:20
3135	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:57:00	69	f	2026-04-30 12:10:20
3137	alex.k.kaczmarczyk@gmail.com	2026-04-24 08:59:00	65	f	2026-04-30 12:10:20
3138	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:00:00	66	f	2026-04-30 12:10:20
3139	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:01:00	65	f	2026-04-30 12:10:20
3140	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:02:00	63	t	2026-04-30 12:10:20
3141	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:03:00	69	f	2026-04-30 12:10:20
3142	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:04:00	67	f	2026-04-30 12:10:20
3143	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:05:00	68	f	2026-04-30 12:10:20
3144	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:06:00	62	t	2026-04-30 12:10:20
3146	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:07:00	69	f	2026-04-30 12:10:20
3147	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:08:00	73	f	2026-04-30 12:10:20
3148	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:10:00	72	f	2026-04-30 12:10:20
3150	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:11:00	71	f	2026-04-30 12:10:20
3151	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:12:00	68	f	2026-04-30 12:10:20
3152	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:13:00	68	f	2026-04-30 12:10:20
3153	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:14:00	71	f	2026-04-30 12:10:20
3154	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:15:00	66	f	2026-04-30 12:10:20
3155	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:16:00	66	f	2026-04-30 12:10:20
3156	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:17:00	69	f	2026-04-30 12:10:20
3157	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:18:00	67	f	2026-04-30 12:10:20
3158	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:20:00	64	t	2026-04-30 12:10:20
3160	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:22:00	68	f	2026-04-30 12:10:20
3161	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:23:00	69	f	2026-04-30 12:10:20
3162	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:24:00	64	t	2026-04-30 12:10:20
3163	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:25:00	65	f	2026-04-30 12:10:20
3164	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:26:00	77	f	2026-04-30 12:10:20
3165	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:27:00	76	f	2026-04-30 12:10:20
3166	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:28:00	62	t	2026-04-30 12:10:20
3167	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:29:00	67	f	2026-04-30 12:10:20
3168	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:30:00	65	f	2026-04-30 12:10:20
3169	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:31:00	68	f	2026-04-30 12:10:20
3170	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:32:00	67	f	2026-04-30 12:10:20
3171	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:33:00	66	f	2026-04-30 12:10:20
3172	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:34:00	64	t	2026-04-30 12:10:20
3174	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:35:00	66	f	2026-04-30 12:10:20
3175	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:36:00	71	f	2026-04-30 12:10:20
3176	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:37:00	75	f	2026-04-30 12:10:20
3177	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:38:00	69	f	2026-04-30 12:10:20
3178	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:39:00	63	t	2026-04-30 12:10:20
3179	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:40:00	65	f	2026-04-30 12:10:20
3180	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:41:00	64	t	2026-04-30 12:10:20
3181	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:42:00	64	t	2026-04-30 12:10:20
3182	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:43:00	66	f	2026-04-30 12:10:20
35	alex.k.kaczmarczyk@gmail.com	2026-04-06 05:50:09	51	t	2026-04-30 12:10:19
3183	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:44:00	64	t	2026-04-30 12:10:20
3184	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:45:00	66	f	2026-04-30 12:10:20
3185	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:46:00	76	f	2026-04-30 12:10:20
3186	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:48:00	62	t	2026-04-30 12:10:20
3187	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:49:00	62	t	2026-04-30 12:10:20
3188	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:50:00	61	t	2026-04-30 12:10:20
3189	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:51:00	67	f	2026-04-30 12:10:20
3190	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:52:00	62	t	2026-04-30 12:10:20
3191	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:53:00	60	t	2026-04-30 12:10:20
3192	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:54:00	60	t	2026-04-30 12:10:20
3193	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:55:00	61	t	2026-04-30 12:10:20
3195	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:56:00	62	t	2026-04-30 12:10:20
3196	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:57:00	61	t	2026-04-30 12:10:20
3197	alex.k.kaczmarczyk@gmail.com	2026-04-24 09:58:00	62	t	2026-04-30 12:10:20
3198	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:00:00	62	t	2026-04-30 12:10:20
3199	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:01:00	61	t	2026-04-30 12:10:20
3200	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:02:00	61	t	2026-04-30 12:10:20
3201	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:03:00	67	f	2026-04-30 12:10:20
3202	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:04:00	62	t	2026-04-30 12:10:20
3204	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:06:00	76	f	2026-04-30 12:10:20
3205	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:07:00	90	f	2026-04-30 12:10:20
3207	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:08:00	81	f	2026-04-30 12:10:20
3208	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:09:00	89	f	2026-04-30 12:10:20
3209	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:11:00	110	f	2026-04-30 12:10:20
3211	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:13:00	69	f	2026-04-30 12:10:20
3212	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:14:00	55	t	2026-04-30 12:10:20
3213	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:15:00	55	t	2026-04-30 12:10:20
3214	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:16:00	58	t	2026-04-30 12:10:20
3215	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:17:00	57	t	2026-04-30 12:10:20
3216	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:18:00	55	t	2026-04-30 12:10:20
3217	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:19:00	58	t	2026-04-30 12:10:20
3218	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:20:00	60	t	2026-04-30 12:10:20
3220	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:21:00	62	t	2026-04-30 12:10:20
3221	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:22:00	74	f	2026-04-30 12:10:20
3222	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:23:00	59	t	2026-04-30 12:10:20
3223	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:25:00	56	t	2026-04-30 12:10:20
3225	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:27:00	65	f	2026-04-30 12:10:20
3227	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:29:00	66	f	2026-04-30 12:10:20
3228	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:30:00	60	t	2026-04-30 12:10:20
3229	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:31:00	59	t	2026-04-30 12:10:20
3230	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:32:00	59	t	2026-04-30 12:10:20
3231	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:33:00	56	t	2026-04-30 12:10:20
3232	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:34:00	59	t	2026-04-30 12:10:20
3233	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:35:00	61	t	2026-04-30 12:10:20
3234	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:36:00	59	t	2026-04-30 12:10:20
3235	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:37:00	76	f	2026-04-30 12:10:20
3236	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:38:00	79	f	2026-04-30 12:10:20
3237	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:39:00	64	t	2026-04-30 12:10:20
3238	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:40:00	69	f	2026-04-30 12:10:20
3239	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:41:00	73	f	2026-04-30 12:10:20
3240	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:42:00	72	f	2026-04-30 12:10:20
3241	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:43:00	67	f	2026-04-30 12:10:20
3242	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:44:00	74	f	2026-04-30 12:10:20
3244	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:45:00	70	f	2026-04-30 12:10:20
3245	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:46:00	70	f	2026-04-30 12:10:20
3246	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:47:00	70	f	2026-04-30 12:10:20
3247	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:48:00	74	f	2026-04-30 12:10:20
3248	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:49:00	73	f	2026-04-30 12:10:20
3249	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:50:00	78	f	2026-04-30 12:10:20
3250	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:51:00	79	f	2026-04-30 12:10:20
3251	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:52:00	79	f	2026-04-30 12:10:20
3252	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:53:00	84	f	2026-04-30 12:10:20
3253	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:54:00	69	f	2026-04-30 12:10:20
3254	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:55:00	63	t	2026-04-30 12:10:20
3255	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:56:00	60	t	2026-04-30 12:10:20
3256	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:57:00	63	t	2026-04-30 12:10:20
3257	alex.k.kaczmarczyk@gmail.com	2026-04-24 10:58:00	64	t	2026-04-30 12:10:20
3258	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:00:00	64	t	2026-04-30 12:10:20
3259	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:01:00	63	t	2026-04-30 12:10:20
3260	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:02:00	64	t	2026-04-30 12:10:20
3261	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:03:00	64	t	2026-04-30 12:10:20
3262	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:04:00	65	f	2026-04-30 12:10:20
3263	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:05:00	66	f	2026-04-30 12:10:20
3264	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:06:00	64	t	2026-04-30 12:10:20
3265	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:08:00	67	f	2026-04-30 12:10:20
3266	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:09:00	67	f	2026-04-30 12:10:20
3268	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:10:00	63	t	2026-04-30 12:10:20
3269	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:11:00	60	t	2026-04-30 12:10:20
3270	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:13:00	60	t	2026-04-30 12:10:20
3271	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:14:00	62	t	2026-04-30 12:10:20
3272	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:15:00	57	t	2026-04-30 12:10:20
3273	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:16:00	68	f	2026-04-30 12:10:20
3274	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:17:00	64	t	2026-04-30 12:10:20
3275	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:18:00	60	t	2026-04-30 12:10:20
3276	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:19:00	59	t	2026-04-30 12:10:20
3278	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:20:00	80	f	2026-04-30 12:10:20
3279	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:22:00	102	f	2026-04-30 12:10:20
36	alex.k.kaczmarczyk@gmail.com	2026-04-06 06:00:14	53	t	2026-04-30 12:10:19
3280	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:23:00	84	f	2026-04-30 12:10:20
3281	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:24:00	75	f	2026-04-30 12:10:20
3282	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:25:00	80	f	2026-04-30 12:10:20
3284	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:26:00	79	f	2026-04-30 12:10:20
3285	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:28:00	67	f	2026-04-30 12:10:20
3286	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:29:00	61	t	2026-04-30 12:10:20
3287	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:30:00	63	t	2026-04-30 12:10:20
3289	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:31:00	66	f	2026-04-30 12:10:20
3290	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:33:00	68	f	2026-04-30 12:10:20
3291	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:34:00	67	f	2026-04-30 12:10:20
3292	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:35:00	71	f	2026-04-30 12:10:20
3293	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:36:00	63	t	2026-04-30 12:10:20
3294	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:37:00	66	f	2026-04-30 12:10:20
3295	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:38:00	65	f	2026-04-30 12:10:20
3296	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:39:00	63	t	2026-04-30 12:10:20
3297	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:40:00	64	t	2026-04-30 12:10:20
3298	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:41:00	65	f	2026-04-30 12:10:20
3299	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:42:00	68	f	2026-04-30 12:10:20
3300	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:43:00	66	f	2026-04-30 12:10:20
3301	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:44:00	63	t	2026-04-30 12:10:20
3303	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:45:00	72	f	2026-04-30 12:10:20
3304	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:46:00	71	f	2026-04-30 12:10:20
3305	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:47:00	67	f	2026-04-30 12:10:20
3306	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:48:00	68	f	2026-04-30 12:10:20
3307	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:50:00	67	f	2026-04-30 12:10:20
3308	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:51:00	68	f	2026-04-30 12:10:20
3309	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:52:00	69	f	2026-04-30 12:10:20
3310	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:53:00	68	f	2026-04-30 12:10:20
3311	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:54:00	66	f	2026-04-30 12:10:20
3312	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:55:00	66	f	2026-04-30 12:10:20
3313	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:56:00	67	f	2026-04-30 12:10:20
3314	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:57:00	65	f	2026-04-30 12:10:20
3315	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:58:00	70	f	2026-04-30 12:10:20
3316	alex.k.kaczmarczyk@gmail.com	2026-04-24 11:59:00	67	f	2026-04-30 12:10:20
3317	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:00:00	68	f	2026-04-30 12:10:20
3318	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:01:00	70	f	2026-04-30 12:10:20
3319	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:02:00	69	f	2026-04-30 12:10:20
3320	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:03:00	67	f	2026-04-30 12:10:20
3321	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:04:00	69	f	2026-04-30 12:10:20
3322	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:05:00	62	t	2026-04-30 12:10:20
3323	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:06:00	63	t	2026-04-30 12:10:20
3324	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:07:00	65	f	2026-04-30 12:10:20
3325	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:08:00	66	f	2026-04-30 12:10:20
3326	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:09:00	68	f	2026-04-30 12:10:20
3327	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:10:00	66	f	2026-04-30 12:10:20
3328	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:11:00	66	f	2026-04-30 12:10:20
3329	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:12:00	69	f	2026-04-30 12:10:20
3330	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:13:00	65	f	2026-04-30 12:10:20
3331	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:14:00	62	t	2026-04-30 12:10:20
3332	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:15:00	65	f	2026-04-30 12:10:20
3333	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:16:00	65	f	2026-04-30 12:10:20
3334	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:17:00	64	t	2026-04-30 12:10:20
3335	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:18:00	59	t	2026-04-30 12:10:20
3336	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:19:00	60	t	2026-04-30 12:10:20
3337	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:20:00	62	t	2026-04-30 12:10:20
3339	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:22:00	73	f	2026-04-30 12:10:20
3341	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:24:00	62	t	2026-04-30 12:10:20
3343	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:25:00	61	t	2026-04-30 12:10:20
3344	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:26:00	61	t	2026-04-30 12:10:20
3345	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:28:00	60	t	2026-04-30 12:10:20
3346	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:29:00	61	t	2026-04-30 12:10:20
3347	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:30:00	61	t	2026-04-30 12:10:20
3349	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:32:00	64	t	2026-04-30 12:10:20
3351	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:33:00	62	t	2026-04-30 12:10:20
3352	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:35:00	86	f	2026-04-30 12:10:20
3353	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:36:00	98	f	2026-04-30 12:10:20
3354	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:37:00	79	f	2026-04-30 12:10:20
3355	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:38:00	82	f	2026-04-30 12:10:20
3356	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:39:00	81	f	2026-04-30 12:10:20
3357	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:40:00	84	f	2026-04-30 12:10:20
3359	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:41:00	82	f	2026-04-30 12:10:20
3360	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:43:00	92	f	2026-04-30 12:10:20
3362	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:44:00	89	f	2026-04-30 12:10:20
3363	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:45:00	93	f	2026-04-30 12:10:20
3364	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:46:00	120	f	2026-04-30 12:10:20
3365	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:47:00	111	f	2026-04-30 12:10:20
3366	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:48:00	91	f	2026-04-30 12:10:20
3367	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:49:00	88	f	2026-04-30 12:10:20
3368	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:51:00	83	f	2026-04-30 12:10:20
3370	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:53:00	70	f	2026-04-30 12:10:20
3371	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:54:00	63	t	2026-04-30 12:10:20
3372	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:55:00	78	f	2026-04-30 12:10:20
3374	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:56:00	78	f	2026-04-30 12:10:20
3375	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:57:00	74	f	2026-04-30 12:10:20
3376	alex.k.kaczmarczyk@gmail.com	2026-04-24 12:58:00	72	f	2026-04-30 12:10:20
3377	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:00:00	93	f	2026-04-30 12:10:20
3378	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:01:00	83	f	2026-04-30 12:10:20
37	alex.k.kaczmarczyk@gmail.com	2026-04-06 06:10:09	49	t	2026-04-30 12:10:19
3379	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:02:00	79	f	2026-04-30 12:10:20
3380	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:04:00	73	f	2026-04-30 12:10:20
3382	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:05:00	76	f	2026-04-30 12:10:20
3383	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:06:00	71	f	2026-04-30 12:10:20
3384	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:07:00	72	f	2026-04-30 12:10:20
3385	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:08:00	94	f	2026-04-30 12:10:20
3386	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:09:00	113	f	2026-04-30 12:10:20
3387	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:10:00	94	f	2026-04-30 12:10:20
3388	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:12:00	92	f	2026-04-30 12:10:20
3389	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:13:00	76	f	2026-04-30 12:10:20
3390	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:14:00	70	f	2026-04-30 12:10:20
3392	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:15:00	69	f	2026-04-30 12:10:20
3393	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:16:00	69	f	2026-04-30 12:10:20
3394	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:17:00	79	f	2026-04-30 12:10:20
3395	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:18:00	75	f	2026-04-30 12:10:20
3396	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:19:00	71	f	2026-04-30 12:10:20
3397	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:20:00	74	f	2026-04-30 12:10:20
3398	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:21:00	74	f	2026-04-30 12:10:20
3399	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:22:00	69	f	2026-04-30 12:10:20
3400	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:23:00	70	f	2026-04-30 12:10:20
3401	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:24:00	73	f	2026-04-30 12:10:20
3402	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:25:00	71	f	2026-04-30 12:10:20
3403	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:26:00	70	f	2026-04-30 12:10:20
3404	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:27:00	73	f	2026-04-30 12:10:20
3405	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:28:00	70	f	2026-04-30 12:10:20
3406	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:29:00	67	f	2026-04-30 12:10:20
3407	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:30:00	79	f	2026-04-30 12:10:20
3408	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:31:00	85	f	2026-04-30 12:10:20
3409	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:32:00	77	f	2026-04-30 12:10:20
3410	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:33:00	84	f	2026-04-30 12:10:20
3411	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:34:00	76	f	2026-04-30 12:10:20
3412	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:35:00	76	f	2026-04-30 12:10:20
3413	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:37:00	74	f	2026-04-30 12:10:20
3414	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:38:00	77	f	2026-04-30 12:10:20
3415	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:39:00	75	f	2026-04-30 12:10:20
3416	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:40:00	78	f	2026-04-30 12:10:20
3417	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:41:00	79	f	2026-04-30 12:10:20
3418	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:42:00	72	f	2026-04-30 12:10:20
3420	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:43:00	96	f	2026-04-30 12:10:20
3421	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:44:00	109	f	2026-04-30 12:10:20
3422	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:45:00	109	f	2026-04-30 12:10:20
3423	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:46:00	110	f	2026-04-30 12:10:20
3424	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:47:00	106	f	2026-04-30 12:10:20
3425	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:48:00	108	f	2026-04-30 12:10:20
3426	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:49:00	108	f	2026-04-30 12:10:20
3427	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:50:00	114	f	2026-04-30 12:10:20
3428	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:51:00	117	f	2026-04-30 12:10:20
3429	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:53:00	119	f	2026-04-30 12:10:20
3431	alex.k.kaczmarczyk@gmail.com	2026-04-24 13:54:00	103	f	2026-04-30 12:10:20
3432	alex.k.kaczmarczyk@gmail.com	2026-04-24 15:52:00	90	f	2026-04-30 12:10:20
3433	alex.k.kaczmarczyk@gmail.com	2026-04-24 15:53:00	98	f	2026-04-30 12:10:20
3434	alex.k.kaczmarczyk@gmail.com	2026-04-24 15:55:00	98	f	2026-04-30 12:10:20
3436	alex.k.kaczmarczyk@gmail.com	2026-04-24 15:56:00	94	f	2026-04-30 12:10:20
3437	alex.k.kaczmarczyk@gmail.com	2026-04-24 15:57:00	96	f	2026-04-30 12:10:20
3438	alex.k.kaczmarczyk@gmail.com	2026-04-24 15:58:00	99	f	2026-04-30 12:10:20
3439	alex.k.kaczmarczyk@gmail.com	2026-04-24 15:59:00	93	f	2026-04-30 12:10:20
3440	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:00:00	92	f	2026-04-30 12:10:20
3441	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:01:00	88	f	2026-04-30 12:10:20
3442	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:02:00	78	f	2026-04-30 12:10:20
3443	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:03:00	79	f	2026-04-30 12:10:20
3444	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:04:00	76	f	2026-04-30 12:10:20
3445	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:05:00	80	f	2026-04-30 12:10:20
3446	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:06:00	75	f	2026-04-30 12:10:20
3447	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:07:00	80	f	2026-04-30 12:10:20
3448	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:08:00	79	f	2026-04-30 12:10:20
3449	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:09:00	80	f	2026-04-30 12:10:20
3450	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:10:00	98	f	2026-04-30 12:10:20
3451	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:11:00	89	f	2026-04-30 12:10:20
3452	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:12:00	76	f	2026-04-30 12:10:20
3453	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:13:00	74	f	2026-04-30 12:10:20
3454	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:14:00	69	f	2026-04-30 12:10:20
3455	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:15:00	77	f	2026-04-30 12:10:20
3456	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:16:00	111	f	2026-04-30 12:10:20
3457	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:17:00	91	f	2026-04-30 12:10:20
3458	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:18:00	86	f	2026-04-30 12:10:20
3459	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:19:00	80	f	2026-04-30 12:10:20
3460	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:20:00	78	f	2026-04-30 12:10:20
3461	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:21:00	79	f	2026-04-30 12:10:20
3462	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:22:00	81	f	2026-04-30 12:10:20
3463	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:23:00	88	f	2026-04-30 12:10:20
3464	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:24:00	100	f	2026-04-30 12:10:20
3465	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:25:00	96	f	2026-04-30 12:10:20
3466	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:26:00	90	f	2026-04-30 12:10:20
3467	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:27:00	88	f	2026-04-30 12:10:20
3468	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:28:00	94	f	2026-04-30 12:10:20
3469	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:29:00	95	f	2026-04-30 12:10:20
3470	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:30:00	93	f	2026-04-30 12:10:20
38	alex.k.kaczmarczyk@gmail.com	2026-04-06 06:20:16	52	t	2026-04-30 12:10:19
3471	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:31:00	93	f	2026-04-30 12:10:20
3472	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:32:00	99	f	2026-04-30 12:10:20
3473	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:33:00	90	f	2026-04-30 12:10:20
3474	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:34:00	93	f	2026-04-30 12:10:20
3475	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:35:00	92	f	2026-04-30 12:10:20
3476	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:36:00	98	f	2026-04-30 12:10:20
3477	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:37:00	96	f	2026-04-30 12:10:20
3478	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:38:00	91	f	2026-04-30 12:10:20
3480	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:39:00	101	f	2026-04-30 12:10:20
3481	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:40:00	123	f	2026-04-30 12:10:20
3482	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:41:00	101	f	2026-04-30 12:10:20
3483	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:43:00	135	f	2026-04-30 12:10:20
3484	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:44:00	98	f	2026-04-30 12:10:20
3486	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:45:00	124	f	2026-04-30 12:10:20
3487	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:46:00	125	f	2026-04-30 12:10:20
3488	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:47:00	118	f	2026-04-30 12:10:20
3489	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:48:00	103	f	2026-04-30 12:10:20
3490	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:50:00	101	f	2026-04-30 12:10:20
3491	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:51:00	100	f	2026-04-30 12:10:20
3493	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:52:00	110	f	2026-04-30 12:10:20
3494	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:54:00	111	f	2026-04-30 12:10:20
3496	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:56:00	138	f	2026-04-30 12:10:20
3497	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:57:00	130	f	2026-04-30 12:10:20
3498	alex.k.kaczmarczyk@gmail.com	2026-04-24 16:58:00	133	f	2026-04-30 12:10:20
3500	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:01:00	116	f	2026-04-30 12:10:20
3501	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:02:00	104	f	2026-04-30 12:10:20
3502	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:03:00	103	f	2026-04-30 12:10:20
3503	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:04:00	101	f	2026-04-30 12:10:20
3504	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:05:00	93	f	2026-04-30 12:10:20
3505	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:06:00	91	f	2026-04-30 12:10:20
3507	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:07:00	89	f	2026-04-30 12:10:20
3508	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:08:00	93	f	2026-04-30 12:10:20
3509	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:09:00	97	f	2026-04-30 12:10:20
3510	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:10:00	95	f	2026-04-30 12:10:20
3511	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:11:00	95	f	2026-04-30 12:10:20
3512	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:12:00	93	f	2026-04-30 12:10:20
3513	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:14:00	92	f	2026-04-30 12:10:20
3514	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:15:00	94	f	2026-04-30 12:10:20
3515	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:16:00	93	f	2026-04-30 12:10:20
3516	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:17:00	93	f	2026-04-30 12:10:20
3517	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:18:00	96	f	2026-04-30 12:10:20
3519	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:19:00	93	f	2026-04-30 12:10:20
3520	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:20:00	84	f	2026-04-30 12:10:20
3521	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:22:00	88	f	2026-04-30 12:10:20
3522	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:23:00	89	f	2026-04-30 12:10:20
3523	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:24:00	89	f	2026-04-30 12:10:20
3524	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:25:00	90	f	2026-04-30 12:10:20
3525	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:26:00	89	f	2026-04-30 12:10:20
3526	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:27:00	83	f	2026-04-30 12:10:20
3527	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:28:00	88	f	2026-04-30 12:10:20
3528	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:29:00	80	f	2026-04-30 12:10:20
3530	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:31:00	90	f	2026-04-30 12:10:20
3532	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:33:00	86	f	2026-04-30 12:10:20
3533	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:34:00	86	f	2026-04-30 12:10:20
3534	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:35:00	83	f	2026-04-30 12:10:20
3535	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:36:00	84	f	2026-04-30 12:10:20
3536	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:37:00	85	f	2026-04-30 12:10:20
3537	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:38:00	78	f	2026-04-30 12:10:20
3538	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:39:00	88	f	2026-04-30 12:10:20
3539	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:40:00	86	f	2026-04-30 12:10:20
3540	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:41:00	86	f	2026-04-30 12:10:20
3541	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:42:00	84	f	2026-04-30 12:10:20
3542	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:43:00	87	f	2026-04-30 12:10:20
3543	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:44:00	110	f	2026-04-30 12:10:20
3544	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:45:00	81	f	2026-04-30 12:10:20
3546	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:46:00	85	f	2026-04-30 12:10:20
3547	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:48:00	86	f	2026-04-30 12:10:20
3548	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:49:00	85	f	2026-04-30 12:10:20
3550	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:51:00	87	f	2026-04-30 12:10:20
3551	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:52:00	85	f	2026-04-30 12:10:20
3552	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:53:00	84	f	2026-04-30 12:10:20
3554	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:55:00	85	f	2026-04-30 12:10:20
3555	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:56:00	88	f	2026-04-30 12:10:20
3556	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:57:00	85	f	2026-04-30 12:10:20
3557	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:58:00	81	f	2026-04-30 12:10:20
3558	alex.k.kaczmarczyk@gmail.com	2026-04-24 17:59:00	87	f	2026-04-30 12:10:20
3560	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:00:00	111	f	2026-04-30 12:10:20
3561	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:01:00	94	f	2026-04-30 12:10:20
3562	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:03:00	92	f	2026-04-30 12:10:20
3563	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:04:00	75	f	2026-04-30 12:10:20
3564	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:05:00	74	f	2026-04-30 12:10:20
3565	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:06:00	79	f	2026-04-30 12:10:20
3566	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:07:00	80	f	2026-04-30 12:10:20
3567	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:08:00	80	f	2026-04-30 12:10:20
3568	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:09:00	78	f	2026-04-30 12:10:20
3569	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:10:00	82	f	2026-04-30 12:10:20
3570	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:11:00	85	f	2026-04-30 12:10:20
39	alex.k.kaczmarczyk@gmail.com	2026-04-06 06:30:09	53	t	2026-04-30 12:10:19
3571	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:12:00	84	f	2026-04-30 12:10:20
3572	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:13:00	87	f	2026-04-30 12:10:20
3573	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:14:00	87	f	2026-04-30 12:10:20
3574	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:15:00	81	f	2026-04-30 12:10:20
3575	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:16:00	84	f	2026-04-30 12:10:20
3576	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:17:00	83	f	2026-04-30 12:10:20
3577	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:18:00	84	f	2026-04-30 12:10:20
3579	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:19:00	83	f	2026-04-30 12:10:20
3580	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:20:00	85	f	2026-04-30 12:10:20
3581	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:22:00	82	f	2026-04-30 12:10:20
3582	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:23:00	78	f	2026-04-30 12:10:20
3583	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:24:00	78	f	2026-04-30 12:10:20
3584	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:25:00	80	f	2026-04-30 12:10:20
3585	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:26:00	80	f	2026-04-30 12:10:20
3586	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:27:00	87	f	2026-04-30 12:10:20
3587	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:28:00	84	f	2026-04-30 12:10:20
3589	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:29:00	110	f	2026-04-30 12:10:20
3590	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:30:00	105	f	2026-04-30 12:10:20
3591	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:31:00	105	f	2026-04-30 12:10:20
3592	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:32:00	105	f	2026-04-30 12:10:20
3593	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:33:00	114	f	2026-04-30 12:10:20
3594	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:35:00	109	f	2026-04-30 12:10:20
3596	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:37:00	102	f	2026-04-30 12:10:20
3598	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:39:00	98	f	2026-04-30 12:10:20
3599	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:40:00	98	f	2026-04-30 12:10:20
3600	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:41:00	77	f	2026-04-30 12:10:20
3601	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:42:00	75	f	2026-04-30 12:10:20
3602	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:43:00	69	f	2026-04-30 12:10:20
3604	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:44:00	71	f	2026-04-30 12:10:20
3605	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:45:00	69	f	2026-04-30 12:10:20
3606	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:46:00	69	f	2026-04-30 12:10:20
3607	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:48:00	78	f	2026-04-30 12:10:20
3609	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:49:00	69	f	2026-04-30 12:10:20
3610	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:51:00	71	f	2026-04-30 12:10:20
3611	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:52:00	71	f	2026-04-30 12:10:20
3613	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:53:00	71	f	2026-04-30 12:10:20
3614	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:54:00	70	f	2026-04-30 12:10:20
3615	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:55:00	69	f	2026-04-30 12:10:20
3616	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:56:00	67	f	2026-04-30 12:10:20
3617	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:57:00	66	f	2026-04-30 12:10:20
3618	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:58:00	68	f	2026-04-30 12:10:20
3619	alex.k.kaczmarczyk@gmail.com	2026-04-24 18:59:00	74	f	2026-04-30 12:10:20
3620	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:01:00	77	f	2026-04-30 12:10:20
3622	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:02:00	78	f	2026-04-30 12:10:20
3623	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:04:00	75	f	2026-04-30 12:10:20
3624	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:05:00	73	f	2026-04-30 12:10:20
3625	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:06:00	76	f	2026-04-30 12:10:20
3627	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:08:00	69	f	2026-04-30 12:10:20
3628	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:09:00	71	f	2026-04-30 12:10:20
3629	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:10:00	86	f	2026-04-30 12:10:20
3631	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:11:00	86	f	2026-04-30 12:10:20
3632	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:12:00	86	f	2026-04-30 12:10:20
3633	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:13:00	86	f	2026-04-30 12:10:20
3634	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:15:00	84	f	2026-04-30 12:10:20
3636	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:17:00	85	f	2026-04-30 12:10:20
3638	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:18:00	85	f	2026-04-30 12:10:20
3639	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:19:00	85	f	2026-04-30 12:10:20
3640	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:20:00	81	f	2026-04-30 12:10:20
3641	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:22:00	81	f	2026-04-30 12:10:20
3643	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:24:00	90	f	2026-04-30 12:10:20
3644	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:25:00	83	f	2026-04-30 12:10:20
3645	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:26:00	77	f	2026-04-30 12:10:20
3646	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:27:00	67	f	2026-04-30 12:10:20
3648	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:29:00	78	f	2026-04-30 12:10:20
3649	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:30:00	67	f	2026-04-30 12:10:20
3651	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:31:00	66	f	2026-04-30 12:10:20
3652	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:32:00	66	f	2026-04-30 12:10:20
3653	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:33:00	66	f	2026-04-30 12:10:20
3654	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:34:00	66	f	2026-04-30 12:10:20
3655	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:36:00	68	f	2026-04-30 12:10:20
3656	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:37:00	68	f	2026-04-30 12:10:20
3658	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:38:00	89	f	2026-04-30 12:10:20
3659	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:39:00	94	f	2026-04-30 12:10:20
3660	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:40:00	91	f	2026-04-30 12:10:20
3661	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:41:00	96	f	2026-04-30 12:10:20
3662	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:42:00	84	f	2026-04-30 12:10:20
3663	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:43:00	79	f	2026-04-30 12:10:20
3664	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:44:00	71	f	2026-04-30 12:10:20
3665	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:45:00	69	f	2026-04-30 12:10:20
3666	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:46:00	73	f	2026-04-30 12:10:20
3667	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:47:00	72	f	2026-04-30 12:10:20
3668	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:48:00	82	f	2026-04-30 12:10:20
3669	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:49:00	77	f	2026-04-30 12:10:20
3670	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:50:00	81	f	2026-04-30 12:10:20
3671	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:51:00	73	f	2026-04-30 12:10:20
3672	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:52:00	70	f	2026-04-30 12:10:20
3673	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:53:00	71	f	2026-04-30 12:10:20
40	alex.k.kaczmarczyk@gmail.com	2026-04-06 06:40:20	95	f	2026-04-30 12:10:19
3674	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:54:00	72	f	2026-04-30 12:10:20
3675	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:55:00	88	f	2026-04-30 12:10:20
3676	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:56:00	84	f	2026-04-30 12:10:20
3677	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:57:00	74	f	2026-04-30 12:10:20
3678	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:58:00	75	f	2026-04-30 12:10:20
3679	alex.k.kaczmarczyk@gmail.com	2026-04-24 19:59:00	73	f	2026-04-30 12:10:20
3680	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:00:00	69	f	2026-04-30 12:10:20
3681	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:01:00	71	f	2026-04-30 12:10:20
3682	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:02:00	73	f	2026-04-30 12:10:20
3683	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:03:00	75	f	2026-04-30 12:10:20
3684	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:04:00	81	f	2026-04-30 12:10:20
3685	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:05:00	83	f	2026-04-30 12:10:20
3686	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:06:00	75	f	2026-04-30 12:10:20
3687	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:07:00	86	f	2026-04-30 12:10:20
3688	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:08:00	86	f	2026-04-30 12:10:20
3689	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:09:00	83	f	2026-04-30 12:10:20
3690	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:10:00	81	f	2026-04-30 12:10:20
3691	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:11:00	77	f	2026-04-30 12:10:20
3692	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:12:00	83	f	2026-04-30 12:10:20
3693	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:13:00	86	f	2026-04-30 12:10:20
3694	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:14:00	92	f	2026-04-30 12:10:20
3695	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:15:00	97	f	2026-04-30 12:10:20
3696	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:16:00	81	f	2026-04-30 12:10:20
3697	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:18:00	86	f	2026-04-30 12:10:20
3699	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:19:00	91	f	2026-04-30 12:10:20
3700	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:20:00	87	f	2026-04-30 12:10:20
3701	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:21:00	85	f	2026-04-30 12:10:20
3702	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:22:00	66	f	2026-04-30 12:10:20
3703	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:23:00	65	f	2026-04-30 12:10:20
3704	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:24:00	68	f	2026-04-30 12:10:20
3705	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:25:00	69	f	2026-04-30 12:10:20
3706	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:26:00	72	f	2026-04-30 12:10:20
3707	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:27:00	72	f	2026-04-30 12:10:20
3708	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:28:00	73	f	2026-04-30 12:10:20
3709	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:29:00	74	f	2026-04-30 12:10:20
3710	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:30:00	75	f	2026-04-30 12:10:20
3711	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:31:00	74	f	2026-04-30 12:10:20
3713	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:32:00	74	f	2026-04-30 12:10:20
3714	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:33:00	76	f	2026-04-30 12:10:20
3715	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:34:00	77	f	2026-04-30 12:10:20
3716	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:35:00	75	f	2026-04-30 12:10:20
3717	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:36:00	76	f	2026-04-30 12:10:20
3718	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:37:00	75	f	2026-04-30 12:10:20
3719	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:38:00	76	f	2026-04-30 12:10:20
3720	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:39:00	76	f	2026-04-30 12:10:20
3721	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:40:00	75	f	2026-04-30 12:10:20
3722	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:42:00	76	f	2026-04-30 12:10:20
3723	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:43:00	78	f	2026-04-30 12:10:20
3724	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:44:00	71	f	2026-04-30 12:10:20
3725	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:45:00	73	f	2026-04-30 12:10:20
3726	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:46:00	78	f	2026-04-30 12:10:20
3727	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:47:00	76	f	2026-04-30 12:10:20
3728	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:48:00	68	f	2026-04-30 12:10:20
3729	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:49:00	64	t	2026-04-30 12:10:20
3730	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:50:00	64	t	2026-04-30 12:10:20
3732	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:51:00	63	t	2026-04-30 12:10:20
3733	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:52:00	62	t	2026-04-30 12:10:20
3734	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:53:00	62	t	2026-04-30 12:10:20
3735	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:54:00	62	t	2026-04-30 12:10:20
3736	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:55:00	63	t	2026-04-30 12:10:20
3737	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:56:00	61	t	2026-04-30 12:10:20
3738	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:57:00	62	t	2026-04-30 12:10:20
3739	alex.k.kaczmarczyk@gmail.com	2026-04-24 20:58:00	61	t	2026-04-30 12:10:20
3740	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:00:00	61	t	2026-04-30 12:10:20
3741	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:01:00	66	f	2026-04-30 12:10:20
3742	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:02:00	67	f	2026-04-30 12:10:20
3743	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:03:00	67	f	2026-04-30 12:10:20
3744	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:04:00	67	f	2026-04-30 12:10:20
3745	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:05:00	66	f	2026-04-30 12:10:20
3746	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:06:00	66	f	2026-04-30 12:10:20
3747	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:07:00	67	f	2026-04-30 12:10:20
3748	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:08:00	70	f	2026-04-30 12:10:20
3749	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:09:00	100	f	2026-04-30 12:10:20
3750	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:11:00	110	f	2026-04-30 12:10:20
3752	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:12:00	103	f	2026-04-30 12:10:20
3753	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:14:00	100	f	2026-04-30 12:10:20
3754	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:15:00	62	t	2026-04-30 12:10:20
3756	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:17:00	64	t	2026-04-30 12:10:20
3757	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:18:00	59	t	2026-04-30 12:10:20
3759	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:19:00	60	t	2026-04-30 12:10:20
3760	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:20:00	59	t	2026-04-30 12:10:20
3761	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:21:00	59	t	2026-04-30 12:10:20
3762	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:22:00	58	t	2026-04-30 12:10:20
3763	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:23:00	60	t	2026-04-30 12:10:20
3764	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:25:00	59	t	2026-04-30 12:10:20
3765	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:26:00	58	t	2026-04-30 12:10:20
3766	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:27:00	60	t	2026-04-30 12:10:20
41	alex.k.kaczmarczyk@gmail.com	2026-04-06 06:50:08	49	t	2026-04-30 12:10:19
3767	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:28:00	57	t	2026-04-30 12:10:20
3768	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:29:00	57	t	2026-04-30 12:10:20
3769	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:30:00	57	t	2026-04-30 12:10:20
3770	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:31:00	60	t	2026-04-30 12:10:20
3771	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:32:00	58	t	2026-04-30 12:10:20
3773	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:33:00	60	t	2026-04-30 12:10:20
3774	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:35:00	57	t	2026-04-30 12:10:20
3775	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:36:00	57	t	2026-04-30 12:10:20
3777	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:38:00	61	t	2026-04-30 12:10:20
3779	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:39:00	61	t	2026-04-30 12:10:20
3780	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:40:00	68	f	2026-04-30 12:10:20
3781	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:42:00	60	t	2026-04-30 12:10:20
3782	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:43:00	57	t	2026-04-30 12:10:20
3783	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:44:00	55	t	2026-04-30 12:10:20
3785	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:46:00	60	t	2026-04-30 12:10:20
3786	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:47:00	57	t	2026-04-30 12:10:20
3787	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:48:00	57	t	2026-04-30 12:10:20
3788	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:49:00	60	t	2026-04-30 12:10:20
3789	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:50:00	56	t	2026-04-30 12:10:20
3790	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:51:00	61	t	2026-04-30 12:10:20
3791	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:52:00	57	t	2026-04-30 12:10:20
3792	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:53:00	57	t	2026-04-30 12:10:20
3793	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:54:00	62	t	2026-04-30 12:10:20
3795	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:55:00	61	t	2026-04-30 12:10:20
3796	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:56:00	58	t	2026-04-30 12:10:20
3797	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:57:00	55	t	2026-04-30 12:10:20
3798	alex.k.kaczmarczyk@gmail.com	2026-04-24 21:59:00	55	t	2026-04-30 12:10:20
3799	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:00:00	60	t	2026-04-30 12:10:20
3800	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:01:00	59	t	2026-04-30 12:10:20
3801	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:02:00	56	t	2026-04-30 12:10:20
3802	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:03:00	59	t	2026-04-30 12:10:20
3803	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:04:00	57	t	2026-04-30 12:10:20
3804	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:05:00	58	t	2026-04-30 12:10:20
3805	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:06:00	62	t	2026-04-30 12:10:20
3807	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:07:00	59	t	2026-04-30 12:10:20
3808	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:09:00	56	t	2026-04-30 12:10:20
3809	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:10:00	56	t	2026-04-30 12:10:20
3810	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:11:00	56	t	2026-04-30 12:10:20
3811	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:12:00	55	t	2026-04-30 12:10:20
3812	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:13:00	57	t	2026-04-30 12:10:20
3813	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:14:00	58	t	2026-04-30 12:10:20
3814	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:15:00	60	t	2026-04-30 12:10:20
3815	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:16:00	56	t	2026-04-30 12:10:20
3817	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:17:00	55	t	2026-04-30 12:10:20
3818	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:19:00	52	t	2026-04-30 12:10:20
3819	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:20:00	58	t	2026-04-30 12:10:20
3821	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:22:00	61	t	2026-04-30 12:10:20
3822	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:23:00	58	t	2026-04-30 12:10:20
3824	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:25:00	53	t	2026-04-30 12:10:20
3825	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:26:00	40	t	2026-04-30 12:10:20
3826	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:27:00	52	t	2026-04-30 12:10:20
3827	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:28:00	58	t	2026-04-30 12:10:20
3829	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:29:00	55	t	2026-04-30 12:10:20
3830	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:30:00	57	t	2026-04-30 12:10:20
3831	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:31:00	58	t	2026-04-30 12:10:20
3832	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:32:00	55	t	2026-04-30 12:10:20
3833	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:33:00	53	t	2026-04-30 12:10:20
3834	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:34:00	63	t	2026-04-30 12:10:20
3835	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:35:00	64	t	2026-04-30 12:10:20
3836	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:36:00	58	t	2026-04-30 12:10:20
3837	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:37:00	57	t	2026-04-30 12:10:20
3838	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:38:00	56	t	2026-04-30 12:10:20
3839	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:39:00	58	t	2026-04-30 12:10:20
3840	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:41:00	56	t	2026-04-30 12:10:20
3842	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:42:00	55	t	2026-04-30 12:10:20
3843	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:43:00	56	t	2026-04-30 12:10:20
3844	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:44:00	64	t	2026-04-30 12:10:20
3845	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:45:00	61	t	2026-04-30 12:10:20
3846	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:46:00	60	t	2026-04-30 12:10:20
3847	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:48:00	59	t	2026-04-30 12:10:20
3849	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:49:00	57	t	2026-04-30 12:10:20
3850	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:50:00	56	t	2026-04-30 12:10:20
3851	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:51:00	55	t	2026-04-30 12:10:20
3852	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:52:00	55	t	2026-04-30 12:10:20
3853	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:53:00	55	t	2026-04-30 12:10:20
3854	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:54:00	54	t	2026-04-30 12:10:20
3855	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:55:00	56	t	2026-04-30 12:10:20
3856	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:56:00	54	t	2026-04-30 12:10:20
3857	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:57:00	54	t	2026-04-30 12:10:20
3858	alex.k.kaczmarczyk@gmail.com	2026-04-24 22:58:00	55	t	2026-04-30 12:10:20
3859	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:00:00	55	t	2026-04-30 12:10:20
3860	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:01:00	56	t	2026-04-30 12:10:20
3861	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:02:00	54	t	2026-04-30 12:10:20
3862	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:03:00	55	t	2026-04-30 12:10:20
3863	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:04:00	58	t	2026-04-30 12:10:20
3864	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:05:00	58	t	2026-04-30 12:10:20
3865	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:06:00	56	t	2026-04-30 12:10:20
42	alex.k.kaczmarczyk@gmail.com	2026-04-06 07:00:18	60	t	2026-04-30 12:10:19
3866	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:07:00	58	t	2026-04-30 12:10:20
3867	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:08:00	58	t	2026-04-30 12:10:20
3868	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:10:00	58	t	2026-04-30 12:10:20
3870	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:12:00	58	t	2026-04-30 12:10:20
3872	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:14:00	56	t	2026-04-30 12:10:20
3873	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:15:00	57	t	2026-04-30 12:10:20
3874	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:16:00	58	t	2026-04-30 12:10:20
3875	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:17:00	55	t	2026-04-30 12:10:20
3876	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:18:00	58	t	2026-04-30 12:10:20
3877	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:19:00	56	t	2026-04-30 12:10:20
3879	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:20:00	55	t	2026-04-30 12:10:20
3880	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:21:00	57	t	2026-04-30 12:10:20
3881	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:23:00	59	t	2026-04-30 12:10:20
3882	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:24:00	56	t	2026-04-30 12:10:20
3883	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:25:00	57	t	2026-04-30 12:10:20
3884	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:26:00	57	t	2026-04-30 12:10:20
3885	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:27:00	54	t	2026-04-30 12:10:20
3887	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:28:00	54	t	2026-04-30 12:10:20
3888	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:29:00	53	t	2026-04-30 12:10:20
3889	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:30:00	56	t	2026-04-30 12:10:20
3890	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:32:00	55	t	2026-04-30 12:10:20
3891	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:33:00	55	t	2026-04-30 12:10:20
3892	alex.k.kaczmarczyk@gmail.com	2026-04-24 23:34:00	57	t	2026-04-30 12:10:20
3893	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:36:00	91	f	2026-04-30 12:10:20
3894	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:37:00	101	f	2026-04-30 12:10:20
3895	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:38:00	90	f	2026-04-30 12:10:20
3896	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:40:00	96	f	2026-04-30 12:10:20
3898	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:42:00	88	f	2026-04-30 12:10:20
3899	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:43:00	84	f	2026-04-30 12:10:20
3900	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:44:00	72	f	2026-04-30 12:10:20
3902	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:45:00	88	f	2026-04-30 12:10:20
3903	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:46:00	87	f	2026-04-30 12:10:20
3904	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:47:00	83	f	2026-04-30 12:10:20
3905	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:48:00	91	f	2026-04-30 12:10:20
3906	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:49:00	96	f	2026-04-30 12:10:20
3907	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:50:00	96	f	2026-04-30 12:10:20
3908	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:51:00	99	f	2026-04-30 12:10:20
3909	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:52:00	100	f	2026-04-30 12:10:20
3910	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:53:00	99	f	2026-04-30 12:10:20
3911	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:54:00	99	f	2026-04-30 12:10:20
3912	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:55:00	105	f	2026-04-30 12:10:20
3913	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:56:00	106	f	2026-04-30 12:10:20
3914	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:57:00	99	f	2026-04-30 12:10:20
3915	alex.k.kaczmarczyk@gmail.com	2026-04-25 15:58:00	91	f	2026-04-30 12:10:20
3916	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:00:00	103	f	2026-04-30 12:10:20
3918	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:01:00	96	f	2026-04-30 12:10:20
3919	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:02:00	100	f	2026-04-30 12:10:20
3920	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:03:00	109	f	2026-04-30 12:10:20
3921	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:04:00	95	f	2026-04-30 12:10:20
3922	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:05:00	98	f	2026-04-30 12:10:20
3923	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:06:00	96	f	2026-04-30 12:10:20
3924	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:07:00	93	f	2026-04-30 12:10:20
3925	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:08:00	98	f	2026-04-30 12:10:20
3926	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:09:00	89	f	2026-04-30 12:10:20
3927	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:10:00	95	f	2026-04-30 12:10:20
3928	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:11:00	93	f	2026-04-30 12:10:20
3929	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:12:00	99	f	2026-04-30 12:10:20
3930	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:13:00	92	f	2026-04-30 12:10:20
3931	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:14:00	89	f	2026-04-30 12:10:20
3932	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:15:00	99	f	2026-04-30 12:10:20
3933	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:17:00	107	f	2026-04-30 12:10:20
3935	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:19:00	111	f	2026-04-30 12:10:20
3937	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:20:00	93	f	2026-04-30 12:10:20
3938	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:21:00	106	f	2026-04-30 12:10:20
3939	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:22:00	108	f	2026-04-30 12:10:20
3940	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:24:00	109	f	2026-04-30 12:10:20
3941	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:25:00	101	f	2026-04-30 12:10:20
3943	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:27:00	106	f	2026-04-30 12:10:20
3944	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:28:00	101	f	2026-04-30 12:10:20
3946	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:29:00	100	f	2026-04-30 12:10:20
3947	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:30:00	70	f	2026-04-30 12:10:20
3948	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:31:00	69	f	2026-04-30 12:10:20
3949	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:32:00	67	f	2026-04-30 12:10:20
3950	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:33:00	67	f	2026-04-30 12:10:20
3951	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:34:00	68	f	2026-04-30 12:10:20
3952	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:35:00	70	f	2026-04-30 12:10:20
3953	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:36:00	69	f	2026-04-30 12:10:20
3954	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:37:00	69	f	2026-04-30 12:10:20
3955	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:38:00	73	f	2026-04-30 12:10:20
3956	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:39:00	70	f	2026-04-30 12:10:20
3957	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:41:00	73	f	2026-04-30 12:10:20
3959	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:42:00	65	f	2026-04-30 12:10:20
3960	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:43:00	70	f	2026-04-30 12:10:20
3961	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:44:00	70	f	2026-04-30 12:10:20
3962	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:45:00	72	f	2026-04-30 12:10:20
3963	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:46:00	71	f	2026-04-30 12:10:20
3964	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:47:00	93	f	2026-04-30 12:10:20
43	alex.k.kaczmarczyk@gmail.com	2026-04-06 08:10:01	52	t	2026-04-30 12:10:19
3965	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:48:00	105	f	2026-04-30 12:10:20
3966	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:49:00	93	f	2026-04-30 12:10:20
3967	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:50:00	103	f	2026-04-30 12:10:20
3968	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:51:00	65	f	2026-04-30 12:10:20
3969	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:52:00	93	f	2026-04-30 12:10:20
3970	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:54:00	104	f	2026-04-30 12:10:20
3971	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:55:00	92	f	2026-04-30 12:10:20
3973	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:57:00	91	f	2026-04-30 12:10:20
3974	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:58:00	89	f	2026-04-30 12:10:20
3975	alex.k.kaczmarczyk@gmail.com	2026-04-25 16:59:00	88	f	2026-04-30 12:10:20
3976	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:00:00	88	f	2026-04-30 12:10:20
3977	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:01:00	90	f	2026-04-30 12:10:20
3978	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:02:00	98	f	2026-04-30 12:10:20
3979	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:03:00	86	f	2026-04-30 12:10:20
3980	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:04:00	94	f	2026-04-30 12:10:20
3981	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:05:00	119	f	2026-04-30 12:10:20
3982	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:06:00	91	f	2026-04-30 12:10:20
3983	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:07:00	67	f	2026-04-30 12:10:20
3984	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:08:00	66	f	2026-04-30 12:10:20
3985	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:09:00	63	t	2026-04-30 12:10:20
3986	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:10:00	62	t	2026-04-30 12:10:20
3987	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:11:00	62	t	2026-04-30 12:10:20
3988	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:12:00	62	t	2026-04-30 12:10:20
3989	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:14:00	62	t	2026-04-30 12:10:20
3990	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:15:00	63	t	2026-04-30 12:10:20
3991	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:16:00	63	t	2026-04-30 12:10:20
3993	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:17:00	65	f	2026-04-30 12:10:20
3994	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:18:00	63	t	2026-04-30 12:10:20
3995	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:19:00	63	t	2026-04-30 12:10:20
3996	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:20:00	68	f	2026-04-30 12:10:20
3997	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:21:00	63	t	2026-04-30 12:10:20
3998	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:22:00	64	t	2026-04-30 12:10:20
3999	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:23:00	61	t	2026-04-30 12:10:20
4000	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:24:00	63	t	2026-04-30 12:10:20
4001	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:25:00	65	f	2026-04-30 12:10:20
4002	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:26:00	64	t	2026-04-30 12:10:20
4003	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:27:00	71	f	2026-04-30 12:10:20
4004	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:28:00	78	f	2026-04-30 12:10:20
4005	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:29:00	64	t	2026-04-30 12:10:20
4006	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:31:00	60	t	2026-04-30 12:10:20
4007	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:32:00	59	t	2026-04-30 12:10:20
4008	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:33:00	62	t	2026-04-30 12:10:20
4009	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:34:00	59	t	2026-04-30 12:10:20
4010	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:35:00	60	t	2026-04-30 12:10:20
4011	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:36:00	61	t	2026-04-30 12:10:20
4012	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:37:00	61	t	2026-04-30 12:10:20
4013	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:38:00	61	t	2026-04-30 12:10:20
4014	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:39:00	61	t	2026-04-30 12:10:20
4016	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:40:00	66	f	2026-04-30 12:10:20
4017	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:41:00	63	t	2026-04-30 12:10:20
4018	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:42:00	62	t	2026-04-30 12:10:20
4019	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:43:00	62	t	2026-04-30 12:10:20
4020	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:44:00	61	t	2026-04-30 12:10:20
4021	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:45:00	61	t	2026-04-30 12:10:20
4022	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:46:00	62	t	2026-04-30 12:10:20
4023	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:47:00	62	t	2026-04-30 12:10:20
4024	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:48:00	63	t	2026-04-30 12:10:20
4025	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:49:00	63	t	2026-04-30 12:10:20
4026	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:50:00	63	t	2026-04-30 12:10:20
4027	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:51:00	63	t	2026-04-30 12:10:20
4028	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:52:00	64	t	2026-04-30 12:10:20
4029	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:53:00	64	t	2026-04-30 12:10:20
4030	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:54:00	62	t	2026-04-30 12:10:20
4031	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:55:00	78	f	2026-04-30 12:10:20
4032	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:56:00	59	t	2026-04-30 12:10:20
4033	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:57:00	59	t	2026-04-30 12:10:20
4034	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:58:00	63	t	2026-04-30 12:10:20
4035	alex.k.kaczmarczyk@gmail.com	2026-04-25 17:59:00	60	t	2026-04-30 12:10:20
4036	alex.k.kaczmarczyk@gmail.com	2026-04-25 18:00:00	60	t	2026-04-30 12:10:20
4037	alex.k.kaczmarczyk@gmail.com	2026-04-25 18:01:00	63	t	2026-04-30 12:10:20
4038	alex.k.kaczmarczyk@gmail.com	2026-04-25 18:02:00	63	t	2026-04-30 12:10:20
4039	alex.k.kaczmarczyk@gmail.com	2026-04-25 18:03:00	63	t	2026-04-30 12:10:20
4040	alex.k.kaczmarczyk@gmail.com	2026-04-25 18:04:00	64	t	2026-04-30 12:10:20
4041	alex.k.kaczmarczyk@gmail.com	2026-04-25 18:05:00	62	t	2026-04-30 12:10:20
4042	alex.k.kaczmarczyk@gmail.com	2026-04-25 18:06:00	62	t	2026-04-30 12:10:20
4043	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:16:00	62	t	2026-04-30 12:10:20
4044	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:17:00	65	f	2026-04-30 12:10:20
4045	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:20:01	97	f	2026-04-30 12:10:20
4046	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:30:02	103	f	2026-04-30 12:10:20
4047	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:40:01	111	f	2026-04-30 12:10:20
4048	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:43:00	92	f	2026-04-30 12:10:20
4049	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:44:00	87	f	2026-04-30 12:10:20
4050	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:45:00	86	f	2026-04-30 12:10:20
4051	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:46:00	93	f	2026-04-30 12:10:20
4052	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:47:00	88	f	2026-04-30 12:10:20
4053	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:48:00	87	f	2026-04-30 12:10:20
4054	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:49:00	83	f	2026-04-30 12:10:20
44	alex.k.kaczmarczyk@gmail.com	2026-04-06 08:20:01	54	t	2026-04-30 12:10:19
4055	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:50:00	86	f	2026-04-30 12:10:20
4056	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:51:00	89	f	2026-04-30 12:10:20
4057	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:52:00	74	f	2026-04-30 12:10:20
4058	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:53:00	73	f	2026-04-30 12:10:20
4059	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:54:00	75	f	2026-04-30 12:10:20
4060	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:55:00	82	f	2026-04-30 12:10:20
4061	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:56:00	94	f	2026-04-30 12:10:20
4062	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:57:00	107	f	2026-04-30 12:10:20
4063	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:58:00	102	f	2026-04-30 12:10:20
4064	alex.k.kaczmarczyk@gmail.com	2026-04-25 19:59:00	108	f	2026-04-30 12:10:20
4065	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:00:00	118	f	2026-04-30 12:10:20
4066	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:01:00	122	f	2026-04-30 12:10:20
4067	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:02:00	131	f	2026-04-30 12:10:20
4068	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:03:00	135	f	2026-04-30 12:10:20
4069	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:04:00	138	f	2026-04-30 12:10:20
4070	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:05:00	136	f	2026-04-30 12:10:20
4071	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:06:00	130	f	2026-04-30 12:10:20
4072	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:07:00	122	f	2026-04-30 12:10:20
4073	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:08:00	107	f	2026-04-30 12:10:20
4074	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:09:00	110	f	2026-04-30 12:10:20
4075	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:10:00	113	f	2026-04-30 12:10:20
4076	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:11:00	118	f	2026-04-30 12:10:20
4077	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:12:00	131	f	2026-04-30 12:10:20
4078	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:13:00	120	f	2026-04-30 12:10:20
4079	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:14:00	120	f	2026-04-30 12:10:20
4080	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:15:00	103	f	2026-04-30 12:10:20
4081	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:16:00	98	f	2026-04-30 12:10:20
4082	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:17:00	106	f	2026-04-30 12:10:20
4083	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:18:00	119	f	2026-04-30 12:10:20
4084	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:19:00	121	f	2026-04-30 12:10:20
4085	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:20:00	102	f	2026-04-30 12:10:20
4086	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:21:00	100	f	2026-04-30 12:10:20
4087	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:22:00	108	f	2026-04-30 12:10:20
4089	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:24:00	102	f	2026-04-30 12:10:20
4090	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:25:00	117	f	2026-04-30 12:10:20
4091	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:26:00	113	f	2026-04-30 12:10:20
4092	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:27:00	116	f	2026-04-30 12:10:20
4094	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:28:00	115	f	2026-04-30 12:10:20
4095	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:30:00	102	f	2026-04-30 12:10:20
4096	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:31:00	121	f	2026-04-30 12:10:20
4097	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:32:00	108	f	2026-04-30 12:10:20
4098	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:33:00	106	f	2026-04-30 12:10:20
4099	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:34:00	109	f	2026-04-30 12:10:20
4101	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:36:00	105	f	2026-04-30 12:10:20
4102	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:37:00	106	f	2026-04-30 12:10:20
4104	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:39:00	96	f	2026-04-30 12:10:20
4105	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:40:00	101	f	2026-04-30 12:10:20
4107	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:42:00	115	f	2026-04-30 12:10:20
4109	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:43:00	111	f	2026-04-30 12:10:20
4110	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:44:00	107	f	2026-04-30 12:10:20
4111	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:46:00	106	f	2026-04-30 12:10:20
4112	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:47:00	111	f	2026-04-30 12:10:20
4114	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:48:00	119	f	2026-04-30 12:10:20
4115	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:49:00	137	f	2026-04-30 12:10:20
4116	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:50:00	124	f	2026-04-30 12:10:20
4117	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:51:00	114	f	2026-04-30 12:10:20
4118	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:52:00	110	f	2026-04-30 12:10:20
4119	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:53:00	112	f	2026-04-30 12:10:20
4120	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:55:00	119	f	2026-04-30 12:10:20
4121	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:56:00	111	f	2026-04-30 12:10:20
4122	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:57:00	107	f	2026-04-30 12:10:20
4124	alex.k.kaczmarczyk@gmail.com	2026-04-25 20:59:00	114	f	2026-04-30 12:10:20
4125	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:01:00	104	f	2026-04-30 12:10:20
4127	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:03:00	121	f	2026-04-30 12:10:20
4128	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:04:00	121	f	2026-04-30 12:10:20
4129	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:05:00	107	f	2026-04-30 12:10:20
4130	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:06:00	96	f	2026-04-30 12:10:20
4132	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:08:00	91	f	2026-04-30 12:10:20
4133	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:09:00	86	f	2026-04-30 12:10:20
4134	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:10:00	90	f	2026-04-30 12:10:20
4136	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:11:00	107	f	2026-04-30 12:10:20
4137	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:12:00	119	f	2026-04-30 12:10:20
4138	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:13:00	124	f	2026-04-30 12:10:20
4139	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:14:00	105	f	2026-04-30 12:10:20
4140	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:14:35	105	f	2026-04-30 12:10:20
4141	alex.k.kaczmarczyk@gmail.com	2026-04-25 21:20:01	123	f	2026-04-30 12:10:20
4142	alex.k.kaczmarczyk@gmail.com	2026-04-27 06:10:00	101	f	2026-04-30 12:10:20
4143	alex.k.kaczmarczyk@gmail.com	2026-04-27 06:20:01	65	f	2026-04-30 12:10:20
4144	alex.k.kaczmarczyk@gmail.com	2026-04-27 06:30:00	74	f	2026-04-30 12:10:20
4145	alex.k.kaczmarczyk@gmail.com	2026-04-27 06:40:01	73	f	2026-04-30 12:10:20
4146	alex.k.kaczmarczyk@gmail.com	2026-04-27 06:50:01	67	f	2026-04-30 12:10:20
4147	alex.k.kaczmarczyk@gmail.com	2026-04-27 07:00:01	63	t	2026-04-30 12:10:20
4148	alex.k.kaczmarczyk@gmail.com	2026-04-27 07:10:00	92	f	2026-04-30 12:10:20
4149	alex.k.kaczmarczyk@gmail.com	2026-04-27 07:20:01	87	f	2026-04-30 12:10:20
4150	alex.k.kaczmarczyk@gmail.com	2026-04-27 07:30:01	67	f	2026-04-30 12:10:20
4151	alex.k.kaczmarczyk@gmail.com	2026-04-27 07:40:01	100	f	2026-04-30 12:10:20
4152	alex.k.kaczmarczyk@gmail.com	2026-04-27 07:50:00	80	f	2026-04-30 12:10:20
45	alex.k.kaczmarczyk@gmail.com	2026-04-06 08:30:19	88	f	2026-04-30 12:10:19
4153	alex.k.kaczmarczyk@gmail.com	2026-04-27 08:00:00	89	f	2026-04-30 12:10:20
4154	alex.k.kaczmarczyk@gmail.com	2026-04-27 08:10:01	70	f	2026-04-30 12:10:20
4155	alex.k.kaczmarczyk@gmail.com	2026-04-27 08:20:01	85	f	2026-04-30 12:10:20
4156	alex.k.kaczmarczyk@gmail.com	2026-04-27 08:30:01	86	f	2026-04-30 12:10:20
4157	alex.k.kaczmarczyk@gmail.com	2026-04-27 08:40:01	70	f	2026-04-30 12:10:20
4158	alex.k.kaczmarczyk@gmail.com	2026-04-27 08:50:01	72	f	2026-04-30 12:10:20
4159	alex.k.kaczmarczyk@gmail.com	2026-04-27 09:00:00	83	f	2026-04-30 12:10:20
4160	alex.k.kaczmarczyk@gmail.com	2026-04-27 09:10:01	70	f	2026-04-30 12:10:20
4161	alex.k.kaczmarczyk@gmail.com	2026-04-27 09:20:00	67	f	2026-04-30 12:10:20
4162	alex.k.kaczmarczyk@gmail.com	2026-04-27 09:30:00	75	f	2026-04-30 12:10:20
4163	alex.k.kaczmarczyk@gmail.com	2026-04-27 09:40:00	71	f	2026-04-30 12:10:20
4164	alex.k.kaczmarczyk@gmail.com	2026-04-27 09:50:00	86	f	2026-04-30 12:10:20
4165	alex.k.kaczmarczyk@gmail.com	2026-04-27 10:00:00	83	f	2026-04-30 12:10:20
4166	alex.k.kaczmarczyk@gmail.com	2026-04-27 10:10:01	68	f	2026-04-30 12:10:20
4167	alex.k.kaczmarczyk@gmail.com	2026-04-27 10:20:00	71	f	2026-04-30 12:10:20
4168	alex.k.kaczmarczyk@gmail.com	2026-04-27 10:30:01	70	f	2026-04-30 12:10:20
4169	alex.k.kaczmarczyk@gmail.com	2026-04-27 10:40:00	74	f	2026-04-30 12:10:20
4170	alex.k.kaczmarczyk@gmail.com	2026-04-27 10:50:01	70	f	2026-04-30 12:10:20
4171	alex.k.kaczmarczyk@gmail.com	2026-04-27 11:00:01	73	f	2026-04-30 12:10:20
4172	alex.k.kaczmarczyk@gmail.com	2026-04-27 11:10:01	89	f	2026-04-30 12:10:20
4173	alex.k.kaczmarczyk@gmail.com	2026-04-27 11:20:01	97	f	2026-04-30 12:10:20
4174	alex.k.kaczmarczyk@gmail.com	2026-04-27 11:30:01	77	f	2026-04-30 12:10:20
4175	alex.k.kaczmarczyk@gmail.com	2026-04-27 11:40:01	81	f	2026-04-30 12:10:20
4176	alex.k.kaczmarczyk@gmail.com	2026-04-27 11:50:01	100	f	2026-04-30 12:10:20
4177	alex.k.kaczmarczyk@gmail.com	2026-04-27 12:00:00	94	f	2026-04-30 12:10:20
4178	alex.k.kaczmarczyk@gmail.com	2026-04-27 12:10:00	101	f	2026-04-30 12:10:20
4179	alex.k.kaczmarczyk@gmail.com	2026-04-27 12:20:01	94	f	2026-04-30 12:10:20
4180	alex.k.kaczmarczyk@gmail.com	2026-04-27 12:30:01	95	f	2026-04-30 12:10:20
4181	alex.k.kaczmarczyk@gmail.com	2026-04-27 12:40:01	98	f	2026-04-30 12:10:20
4182	alex.k.kaczmarczyk@gmail.com	2026-04-27 12:50:00	109	f	2026-04-30 12:10:20
4183	alex.k.kaczmarczyk@gmail.com	2026-04-27 13:00:01	109	f	2026-04-30 12:10:20
4184	alex.k.kaczmarczyk@gmail.com	2026-04-27 13:10:01	108	f	2026-04-30 12:10:20
4185	alex.k.kaczmarczyk@gmail.com	2026-04-27 13:20:00	106	f	2026-04-30 12:10:20
4186	alex.k.kaczmarczyk@gmail.com	2026-04-27 13:30:01	117	f	2026-04-30 12:10:20
4187	alex.k.kaczmarczyk@gmail.com	2026-04-27 13:40:02	124	f	2026-04-30 12:10:20
4188	alex.k.kaczmarczyk@gmail.com	2026-04-27 13:50:02	115	f	2026-04-30 12:10:20
4189	alex.k.kaczmarczyk@gmail.com	2026-04-27 14:00:01	95	f	2026-04-30 12:10:20
4190	alex.k.kaczmarczyk@gmail.com	2026-04-27 14:10:02	94	f	2026-04-30 12:10:20
4191	alex.k.kaczmarczyk@gmail.com	2026-04-27 14:20:00	88	f	2026-04-30 12:10:20
4192	alex.k.kaczmarczyk@gmail.com	2026-04-27 14:30:01	109	f	2026-04-30 12:10:20
4193	alex.k.kaczmarczyk@gmail.com	2026-04-27 14:40:01	97	f	2026-04-30 12:10:20
4194	alex.k.kaczmarczyk@gmail.com	2026-04-27 14:50:01	82	f	2026-04-30 12:10:20
4195	alex.k.kaczmarczyk@gmail.com	2026-04-27 15:00:01	95	f	2026-04-30 12:10:20
4196	alex.k.kaczmarczyk@gmail.com	2026-04-27 15:10:01	88	f	2026-04-30 12:10:20
4197	alex.k.kaczmarczyk@gmail.com	2026-04-27 15:20:01	79	f	2026-04-30 12:10:20
4198	alex.k.kaczmarczyk@gmail.com	2026-04-27 15:30:02	85	f	2026-04-30 12:10:20
4199	alex.k.kaczmarczyk@gmail.com	2026-04-27 15:40:01	74	f	2026-04-30 12:10:20
4200	alex.k.kaczmarczyk@gmail.com	2026-04-27 15:50:02	71	f	2026-04-30 12:10:20
4201	alex.k.kaczmarczyk@gmail.com	2026-04-27 16:00:02	74	f	2026-04-30 12:10:20
4202	alex.k.kaczmarczyk@gmail.com	2026-04-27 16:10:01	71	f	2026-04-30 12:10:20
4203	alex.k.kaczmarczyk@gmail.com	2026-04-27 16:20:02	77	f	2026-04-30 12:10:20
4204	alex.k.kaczmarczyk@gmail.com	2026-04-27 16:30:01	97	f	2026-04-30 12:10:20
4205	alex.k.kaczmarczyk@gmail.com	2026-04-27 16:40:01	79	f	2026-04-30 12:10:20
4206	alex.k.kaczmarczyk@gmail.com	2026-04-27 16:50:01	93	f	2026-04-30 12:10:20
4207	alex.k.kaczmarczyk@gmail.com	2026-04-27 17:00:01	74	f	2026-04-30 12:10:20
4208	alex.k.kaczmarczyk@gmail.com	2026-04-27 17:10:01	69	f	2026-04-30 12:10:20
4209	alex.k.kaczmarczyk@gmail.com	2026-04-27 17:20:01	73	f	2026-04-30 12:10:20
4210	alex.k.kaczmarczyk@gmail.com	2026-04-27 17:30:02	68	f	2026-04-30 12:10:20
4211	alex.k.kaczmarczyk@gmail.com	2026-04-27 17:40:02	71	f	2026-04-30 12:10:20
4212	alex.k.kaczmarczyk@gmail.com	2026-04-27 17:50:02	103	f	2026-04-30 12:10:20
4213	alex.k.kaczmarczyk@gmail.com	2026-04-27 18:00:02	82	f	2026-04-30 12:10:20
4214	alex.k.kaczmarczyk@gmail.com	2026-04-27 18:10:01	65	f	2026-04-30 12:10:20
4215	alex.k.kaczmarczyk@gmail.com	2026-04-27 18:20:01	78	f	2026-04-30 12:10:20
4216	alex.k.kaczmarczyk@gmail.com	2026-04-27 18:30:01	73	f	2026-04-30 12:10:20
4217	alex.k.kaczmarczyk@gmail.com	2026-04-27 18:40:01	71	f	2026-04-30 12:10:20
4218	alex.k.kaczmarczyk@gmail.com	2026-04-27 18:50:01	64	t	2026-04-30 12:10:20
4219	alex.k.kaczmarczyk@gmail.com	2026-04-28 08:20:00	107	f	2026-04-30 12:10:20
4220	alex.k.kaczmarczyk@gmail.com	2026-04-28 08:30:01	82	f	2026-04-30 12:10:20
4221	alex.k.kaczmarczyk@gmail.com	2026-04-28 08:40:00	93	f	2026-04-30 12:10:20
4222	alex.k.kaczmarczyk@gmail.com	2026-04-28 08:50:00	92	f	2026-04-30 12:10:20
4223	alex.k.kaczmarczyk@gmail.com	2026-04-28 09:00:00	93	f	2026-04-30 12:10:20
4224	alex.k.kaczmarczyk@gmail.com	2026-04-28 09:10:00	99	f	2026-04-30 12:10:20
4225	alex.k.kaczmarczyk@gmail.com	2026-04-28 09:20:00	102	f	2026-04-30 12:10:20
4226	alex.k.kaczmarczyk@gmail.com	2026-04-28 09:30:00	75	f	2026-04-30 12:10:20
4227	alex.k.kaczmarczyk@gmail.com	2026-04-28 09:40:01	89	f	2026-04-30 12:10:20
4228	alex.k.kaczmarczyk@gmail.com	2026-04-28 09:50:01	78	f	2026-04-30 12:10:20
4229	alex.k.kaczmarczyk@gmail.com	2026-04-28 10:00:01	78	f	2026-04-30 12:10:20
4230	alex.k.kaczmarczyk@gmail.com	2026-04-28 10:10:01	68	f	2026-04-30 12:10:20
4231	alex.k.kaczmarczyk@gmail.com	2026-04-28 10:20:00	70	f	2026-04-30 12:10:20
4232	alex.k.kaczmarczyk@gmail.com	2026-04-28 10:30:00	64	t	2026-04-30 12:10:20
4233	alex.k.kaczmarczyk@gmail.com	2026-04-28 10:40:01	70	f	2026-04-30 12:10:20
4234	alex.k.kaczmarczyk@gmail.com	2026-04-28 10:50:00	66	f	2026-04-30 12:10:20
4235	alex.k.kaczmarczyk@gmail.com	2026-04-28 11:00:01	81	f	2026-04-30 12:10:20
4236	alex.k.kaczmarczyk@gmail.com	2026-04-28 11:10:00	69	f	2026-04-30 12:10:20
4237	alex.k.kaczmarczyk@gmail.com	2026-04-28 11:20:01	61	t	2026-04-30 12:10:20
4238	alex.k.kaczmarczyk@gmail.com	2026-04-28 11:30:01	116	f	2026-04-30 12:10:20
4239	alex.k.kaczmarczyk@gmail.com	2026-04-28 11:40:01	82	f	2026-04-30 12:10:20
46	alex.k.kaczmarczyk@gmail.com	2026-04-06 08:40:21	78	f	2026-04-30 12:10:19
4240	alex.k.kaczmarczyk@gmail.com	2026-04-28 11:50:01	98	f	2026-04-30 12:10:20
4241	alex.k.kaczmarczyk@gmail.com	2026-04-28 12:00:01	72	f	2026-04-30 12:10:20
4242	alex.k.kaczmarczyk@gmail.com	2026-04-28 12:10:00	62	t	2026-04-30 12:10:20
4243	alex.k.kaczmarczyk@gmail.com	2026-04-28 12:20:00	69	f	2026-04-30 12:10:20
4244	alex.k.kaczmarczyk@gmail.com	2026-04-28 12:30:00	62	t	2026-04-30 12:10:20
4245	alex.k.kaczmarczyk@gmail.com	2026-04-28 12:40:00	70	f	2026-04-30 12:10:20
4246	alex.k.kaczmarczyk@gmail.com	2026-04-28 12:50:01	63	t	2026-04-30 12:10:20
4247	alex.k.kaczmarczyk@gmail.com	2026-04-28 13:00:00	77	f	2026-04-30 12:10:20
4248	alex.k.kaczmarczyk@gmail.com	2026-04-28 13:10:01	75	f	2026-04-30 12:10:20
4249	alex.k.kaczmarczyk@gmail.com	2026-04-28 13:20:00	78	f	2026-04-30 12:10:20
4250	alex.k.kaczmarczyk@gmail.com	2026-04-28 13:30:01	88	f	2026-04-30 12:10:20
4251	alex.k.kaczmarczyk@gmail.com	2026-04-28 13:40:01	67	f	2026-04-30 12:10:20
4252	alex.k.kaczmarczyk@gmail.com	2026-04-28 13:50:02	74	f	2026-04-30 12:10:20
4253	alex.k.kaczmarczyk@gmail.com	2026-04-28 14:00:02	62	t	2026-04-30 12:10:20
4254	alex.k.kaczmarczyk@gmail.com	2026-04-28 14:10:02	68	f	2026-04-30 12:10:20
4255	alex.k.kaczmarczyk@gmail.com	2026-04-28 14:20:01	78	f	2026-04-30 12:10:20
4256	alex.k.kaczmarczyk@gmail.com	2026-04-28 14:30:01	63	t	2026-04-30 12:10:20
4257	alex.k.kaczmarczyk@gmail.com	2026-04-28 14:40:01	79	f	2026-04-30 12:10:20
4258	alex.k.kaczmarczyk@gmail.com	2026-04-28 14:50:02	90	f	2026-04-30 12:10:20
4259	alex.k.kaczmarczyk@gmail.com	2026-04-28 15:00:01	101	f	2026-04-30 12:10:20
4260	alex.k.kaczmarczyk@gmail.com	2026-04-28 15:10:01	94	f	2026-04-30 12:10:20
4261	alex.k.kaczmarczyk@gmail.com	2026-04-28 15:20:01	71	f	2026-04-30 12:10:20
4262	alex.k.kaczmarczyk@gmail.com	2026-04-28 15:30:01	67	f	2026-04-30 12:10:20
4263	alex.k.kaczmarczyk@gmail.com	2026-04-28 15:40:01	64	t	2026-04-30 12:10:20
4264	alex.k.kaczmarczyk@gmail.com	2026-04-28 15:50:01	115	f	2026-04-30 12:10:20
4265	alex.k.kaczmarczyk@gmail.com	2026-04-28 16:00:00	90	f	2026-04-30 12:10:20
4266	alex.k.kaczmarczyk@gmail.com	2026-04-28 16:10:01	88	f	2026-04-30 12:10:20
4267	alex.k.kaczmarczyk@gmail.com	2026-04-28 16:20:01	67	f	2026-04-30 12:10:20
4268	alex.k.kaczmarczyk@gmail.com	2026-04-28 16:30:01	69	f	2026-04-30 12:10:20
4269	alex.k.kaczmarczyk@gmail.com	2026-04-28 16:40:01	80	f	2026-04-30 12:10:20
4270	alex.k.kaczmarczyk@gmail.com	2026-04-29 07:40:01	92	f	2026-04-30 12:10:20
4271	alex.k.kaczmarczyk@gmail.com	2026-04-29 07:50:01	68	f	2026-04-30 12:10:20
4272	alex.k.kaczmarczyk@gmail.com	2026-04-29 08:00:02	99	f	2026-04-30 12:10:20
4273	alex.k.kaczmarczyk@gmail.com	2026-04-29 08:10:01	105	f	2026-04-30 12:10:20
4274	alex.k.kaczmarczyk@gmail.com	2026-04-29 08:20:00	73	f	2026-04-30 12:10:20
4275	alex.k.kaczmarczyk@gmail.com	2026-04-29 08:30:01	87	f	2026-04-30 12:10:20
4276	alex.k.kaczmarczyk@gmail.com	2026-04-29 08:40:01	114	f	2026-04-30 12:10:20
4277	alex.k.kaczmarczyk@gmail.com	2026-04-29 08:50:01	114	f	2026-04-30 12:10:20
4278	alex.k.kaczmarczyk@gmail.com	2026-04-29 09:00:01	83	f	2026-04-30 12:10:20
4279	alex.k.kaczmarczyk@gmail.com	2026-04-29 09:10:02	95	f	2026-04-30 12:10:20
4280	alex.k.kaczmarczyk@gmail.com	2026-04-29 09:20:02	83	f	2026-04-30 12:10:20
4281	alex.k.kaczmarczyk@gmail.com	2026-04-29 09:30:02	83	f	2026-04-30 12:10:20
4282	alex.k.kaczmarczyk@gmail.com	2026-04-29 09:40:01	91	f	2026-04-30 12:10:20
4283	alex.k.kaczmarczyk@gmail.com	2026-04-29 09:50:01	84	f	2026-04-30 12:10:20
4284	alex.k.kaczmarczyk@gmail.com	2026-04-29 10:00:02	79	f	2026-04-30 12:10:20
4285	alex.k.kaczmarczyk@gmail.com	2026-04-29 10:10:01	87	f	2026-04-30 12:10:20
4286	alex.k.kaczmarczyk@gmail.com	2026-04-29 10:20:02	86	f	2026-04-30 12:10:20
4287	alex.k.kaczmarczyk@gmail.com	2026-04-29 10:30:01	78	f	2026-04-30 12:10:20
4288	alex.k.kaczmarczyk@gmail.com	2026-04-29 10:40:01	77	f	2026-04-30 12:10:20
4289	alex.k.kaczmarczyk@gmail.com	2026-04-29 10:50:01	98	f	2026-04-30 12:10:20
4290	alex.k.kaczmarczyk@gmail.com	2026-04-29 11:00:01	84	f	2026-04-30 12:10:20
4291	alex.k.kaczmarczyk@gmail.com	2026-04-29 11:10:01	88	f	2026-04-30 12:10:20
4292	alex.k.kaczmarczyk@gmail.com	2026-04-29 11:20:01	92	f	2026-04-30 12:10:20
4293	alex.k.kaczmarczyk@gmail.com	2026-04-29 11:30:02	92	f	2026-04-30 12:10:20
4294	alex.k.kaczmarczyk@gmail.com	2026-04-29 11:40:02	95	f	2026-04-30 12:10:20
4295	alex.k.kaczmarczyk@gmail.com	2026-04-29 11:50:01	95	f	2026-04-30 12:10:20
4296	alex.k.kaczmarczyk@gmail.com	2026-04-29 12:00:01	88	f	2026-04-30 12:10:20
4297	alex.k.kaczmarczyk@gmail.com	2026-04-29 12:10:01	86	f	2026-04-30 12:10:20
4298	alex.k.kaczmarczyk@gmail.com	2026-04-29 12:20:01	101	f	2026-04-30 12:10:20
4299	alex.k.kaczmarczyk@gmail.com	2026-04-29 12:30:02	91	f	2026-04-30 12:10:20
4300	alex.k.kaczmarczyk@gmail.com	2026-04-29 12:40:01	82	f	2026-04-30 12:10:20
4301	alex.k.kaczmarczyk@gmail.com	2026-04-29 12:50:00	84	f	2026-04-30 12:10:20
4302	alex.k.kaczmarczyk@gmail.com	2026-04-29 13:00:01	87	f	2026-04-30 12:10:20
4303	alex.k.kaczmarczyk@gmail.com	2026-04-29 13:10:02	91	f	2026-04-30 12:10:20
4304	alex.k.kaczmarczyk@gmail.com	2026-04-29 13:20:01	74	f	2026-04-30 12:10:20
4305	alex.k.kaczmarczyk@gmail.com	2026-04-29 13:30:01	82	f	2026-04-30 12:10:20
4306	alex.k.kaczmarczyk@gmail.com	2026-04-29 13:40:01	86	f	2026-04-30 12:10:20
4307	alex.k.kaczmarczyk@gmail.com	2026-04-29 13:50:01	101	f	2026-04-30 12:10:20
4308	alex.k.kaczmarczyk@gmail.com	2026-04-29 14:00:00	91	f	2026-04-30 12:10:20
4309	alex.k.kaczmarczyk@gmail.com	2026-04-29 14:10:00	102	f	2026-04-30 12:10:20
4310	alex.k.kaczmarczyk@gmail.com	2026-04-29 14:20:00	98	f	2026-04-30 12:10:20
4311	alex.k.kaczmarczyk@gmail.com	2026-04-29 14:30:00	96	f	2026-04-30 12:10:20
4312	alex.k.kaczmarczyk@gmail.com	2026-04-29 14:40:00	91	f	2026-04-30 12:10:20
4313	alex.k.kaczmarczyk@gmail.com	2026-04-29 14:50:01	114	f	2026-04-30 12:10:20
4314	alex.k.kaczmarczyk@gmail.com	2026-04-29 15:00:01	75	f	2026-04-30 12:10:20
4315	alex.k.kaczmarczyk@gmail.com	2026-04-29 15:10:00	77	f	2026-04-30 12:10:20
4316	alex.k.kaczmarczyk@gmail.com	2026-04-29 15:20:00	81	f	2026-04-30 12:10:20
4317	alex.k.kaczmarczyk@gmail.com	2026-04-29 15:30:01	93	f	2026-04-30 12:10:20
4318	alex.k.kaczmarczyk@gmail.com	2026-04-29 16:50:00	101	f	2026-04-30 12:10:20
4319	alex.k.kaczmarczyk@gmail.com	2026-04-29 17:00:00	139	f	2026-04-30 12:10:20
4320	alex.k.kaczmarczyk@gmail.com	2026-04-29 17:10:01	87	f	2026-04-30 12:10:20
4321	alex.k.kaczmarczyk@gmail.com	2026-04-29 17:20:01	79	f	2026-04-30 12:10:20
4322	alex.k.kaczmarczyk@gmail.com	2026-04-29 17:30:01	80	f	2026-04-30 12:10:20
4323	alex.k.kaczmarczyk@gmail.com	2026-04-29 17:40:00	79	f	2026-04-30 12:10:20
4360	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:14:00	101	f	2026-04-30 12:10:20
4361	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:15:00	99	f	2026-04-30 12:10:20
4363	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:16:00	80	f	2026-04-30 12:10:20
47	alex.k.kaczmarczyk@gmail.com	2026-04-06 09:10:01	72	f	2026-04-30 12:10:19
4364	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:17:00	79	f	2026-04-30 12:10:20
4365	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:18:00	101	f	2026-04-30 12:10:20
4366	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:19:00	110	f	2026-04-30 12:10:20
4367	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:21:00	108	f	2026-04-30 12:10:20
4368	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:22:00	106	f	2026-04-30 12:10:20
4369	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:23:00	109	f	2026-04-30 12:10:20
4370	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:24:00	91	f	2026-04-30 12:10:20
4372	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:25:00	102	f	2026-04-30 12:10:20
4373	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:26:00	110	f	2026-04-30 12:10:20
4374	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:28:00	115	f	2026-04-30 12:10:20
4375	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:29:00	112	f	2026-04-30 12:10:20
4377	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:31:00	116	f	2026-04-30 12:10:20
4379	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:32:00	121	f	2026-04-30 12:10:20
4380	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:33:00	127	f	2026-04-30 12:10:20
4381	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:34:00	114	f	2026-04-30 12:10:20
4382	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:35:00	93	f	2026-04-30 12:10:20
4383	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:36:00	95	f	2026-04-30 12:10:20
4384	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:37:00	89	f	2026-04-30 12:10:20
4385	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:38:00	91	f	2026-04-30 12:10:20
4386	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:39:00	99	f	2026-04-30 12:10:20
4387	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:41:00	95	f	2026-04-30 12:10:20
4388	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:42:00	104	f	2026-04-30 12:10:20
4390	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:44:00	132	f	2026-04-30 12:10:20
4392	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:45:00	111	f	2026-04-30 12:10:20
4393	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:47:00	138	f	2026-04-30 12:10:20
4395	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:48:00	113	f	2026-04-30 12:10:20
4396	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:49:00	110	f	2026-04-30 12:10:20
4397	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:51:00	141	f	2026-04-30 12:10:20
4398	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:52:00	127	f	2026-04-30 12:10:20
4400	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:53:00	114	f	2026-04-30 12:10:20
4401	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:55:00	105	f	2026-04-30 12:10:20
4403	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:56:00	111	f	2026-04-30 12:10:20
4404	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:57:00	110	f	2026-04-30 12:10:20
4405	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:58:00	101	f	2026-04-30 12:10:20
4406	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:00:00	111	f	2026-04-30 12:10:20
4407	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:02:00	97	f	2026-04-30 12:10:20
4409	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:03:00	99	f	2026-04-30 12:10:20
4410	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:04:00	102	f	2026-04-30 12:10:20
4411	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:06:00	108	f	2026-04-30 12:10:20
4413	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:07:00	114	f	2026-04-30 12:10:20
4414	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:09:00	118	f	2026-04-30 12:10:20
4415	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:10:00	116	f	2026-04-30 12:10:20
4416	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:11:00	116	f	2026-04-30 12:10:20
4418	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:12:00	116	f	2026-04-30 12:10:20
4420	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:12:59	118	f	2026-04-30 12:10:20
4421	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:20:00	107	f	2026-04-30 12:10:20
4422	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:30:01	104	f	2026-04-30 12:10:20
4423	alex.k.kaczmarczyk@gmail.com	2026-04-29 20:40:01	104	f	2026-04-30 12:10:20
4424	alex.k.kaczmarczyk@gmail.com	2026-04-29 22:30:00	59	t	2026-04-30 12:10:20
4425	alex.k.kaczmarczyk@gmail.com	2026-04-29 22:40:00	64	t	2026-04-30 12:10:20
4426	alex.k.kaczmarczyk@gmail.com	2026-04-29 22:50:09	65	f	2026-04-30 12:10:20
4427	alex.k.kaczmarczyk@gmail.com	2026-04-29 23:00:08	70	f	2026-04-30 12:10:20
4428	alex.k.kaczmarczyk@gmail.com	2026-04-29 23:10:08	61	t	2026-04-30 12:10:20
4429	alex.k.kaczmarczyk@gmail.com	2026-04-29 23:20:08	63	t	2026-04-30 12:10:20
4430	alex.k.kaczmarczyk@gmail.com	2026-04-29 23:30:14	96	f	2026-04-30 12:10:20
4431	alex.k.kaczmarczyk@gmail.com	2026-04-29 23:40:08	70	f	2026-04-30 12:10:20
4432	alex.k.kaczmarczyk@gmail.com	2026-04-29 23:50:08	70	f	2026-04-30 12:10:20
17729	alex.k.kaczmarczyk@gmail.com	2026-04-02 13:50:01	89	f	2026-05-06 23:11:15
17730	alex.k.kaczmarczyk@gmail.com	2026-04-02 14:00:00	99	f	2026-05-06 23:11:15
17731	alex.k.kaczmarczyk@gmail.com	2026-04-02 14:10:01	87	f	2026-05-06 23:11:15
17732	alex.k.kaczmarczyk@gmail.com	2026-04-02 14:20:01	95	f	2026-05-06 23:11:15
17733	alex.k.kaczmarczyk@gmail.com	2026-04-02 14:30:01	85	f	2026-05-06 23:11:15
17734	alex.k.kaczmarczyk@gmail.com	2026-04-02 14:40:02	70	f	2026-05-06 23:11:15
17735	alex.k.kaczmarczyk@gmail.com	2026-04-02 14:50:01	61	t	2026-05-06 23:11:15
17736	alex.k.kaczmarczyk@gmail.com	2026-04-02 15:00:01	58	t	2026-05-06 23:11:15
17737	alex.k.kaczmarczyk@gmail.com	2026-04-02 15:10:01	62	t	2026-05-06 23:11:15
17738	alex.k.kaczmarczyk@gmail.com	2026-04-02 15:20:01	61	t	2026-05-06 23:11:15
17739	alex.k.kaczmarczyk@gmail.com	2026-04-02 15:30:01	61	t	2026-05-06 23:11:15
17740	alex.k.kaczmarczyk@gmail.com	2026-04-02 15:40:01	77	f	2026-05-06 23:11:15
17741	alex.k.kaczmarczyk@gmail.com	2026-04-02 15:50:01	99	f	2026-05-06 23:11:15
17742	alex.k.kaczmarczyk@gmail.com	2026-04-02 16:00:01	65	f	2026-05-06 23:11:15
17743	alex.k.kaczmarczyk@gmail.com	2026-04-02 16:10:01	70	f	2026-05-06 23:11:15
17744	alex.k.kaczmarczyk@gmail.com	2026-04-02 16:20:01	56	t	2026-05-06 23:11:15
17745	alex.k.kaczmarczyk@gmail.com	2026-04-02 16:30:01	86	f	2026-05-06 23:11:15
17746	alex.k.kaczmarczyk@gmail.com	2026-04-02 16:40:01	61	t	2026-05-06 23:11:15
17747	alex.k.kaczmarczyk@gmail.com	2026-04-02 16:50:01	68	f	2026-05-06 23:11:15
17748	alex.k.kaczmarczyk@gmail.com	2026-04-02 17:00:01	99	f	2026-05-06 23:11:15
17749	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:00:01	82	f	2026-05-06 23:11:15
17750	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:10:01	77	f	2026-05-06 23:11:15
17751	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:20:01	85	f	2026-05-06 23:11:15
17752	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:30:01	114	f	2026-05-06 23:11:15
17753	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:40:01	106	f	2026-05-06 23:11:15
17754	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:46:00	95	f	2026-05-06 23:11:15
17755	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:47:00	107	f	2026-05-06 23:11:15
17756	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:48:00	108	f	2026-05-06 23:11:15
17757	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:49:00	95	f	2026-05-06 23:11:15
17758	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:50:00	81	f	2026-05-06 23:11:15
48	alex.k.kaczmarczyk@gmail.com	2026-04-06 09:20:01	73	f	2026-04-30 12:10:19
49	alex.k.kaczmarczyk@gmail.com	2026-04-06 09:30:02	68	f	2026-04-30 12:10:19
50	alex.k.kaczmarczyk@gmail.com	2026-04-06 09:40:01	101	f	2026-04-30 12:10:19
51	alex.k.kaczmarczyk@gmail.com	2026-04-06 09:50:00	96	f	2026-04-30 12:10:19
52	alex.k.kaczmarczyk@gmail.com	2026-04-06 10:00:01	92	f	2026-04-30 12:10:19
53	alex.k.kaczmarczyk@gmail.com	2026-04-06 10:10:01	85	f	2026-04-30 12:10:19
54	alex.k.kaczmarczyk@gmail.com	2026-04-06 10:20:01	81	f	2026-04-30 12:10:19
55	alex.k.kaczmarczyk@gmail.com	2026-04-06 10:30:02	56	t	2026-04-30 12:10:19
56	alex.k.kaczmarczyk@gmail.com	2026-04-06 10:40:02	52	t	2026-04-30 12:10:19
57	alex.k.kaczmarczyk@gmail.com	2026-04-06 10:50:01	77	f	2026-04-30 12:10:19
58	alex.k.kaczmarczyk@gmail.com	2026-04-06 11:00:01	72	f	2026-04-30 12:10:19
59	alex.k.kaczmarczyk@gmail.com	2026-04-06 11:10:02	61	t	2026-04-30 12:10:19
60	alex.k.kaczmarczyk@gmail.com	2026-04-06 11:20:01	64	t	2026-04-30 12:10:19
61	alex.k.kaczmarczyk@gmail.com	2026-04-06 11:30:02	56	t	2026-04-30 12:10:19
62	alex.k.kaczmarczyk@gmail.com	2026-04-06 11:40:02	58	t	2026-04-30 12:10:19
63	alex.k.kaczmarczyk@gmail.com	2026-04-06 11:50:01	62	t	2026-04-30 12:10:19
64	alex.k.kaczmarczyk@gmail.com	2026-04-06 12:00:01	63	t	2026-04-30 12:10:19
65	alex.k.kaczmarczyk@gmail.com	2026-04-06 12:10:01	66	f	2026-04-30 12:10:19
66	alex.k.kaczmarczyk@gmail.com	2026-04-06 12:20:01	59	t	2026-04-30 12:10:19
67	alex.k.kaczmarczyk@gmail.com	2026-04-06 12:30:02	71	f	2026-04-30 12:10:19
68	alex.k.kaczmarczyk@gmail.com	2026-04-06 12:40:01	87	f	2026-04-30 12:10:19
69	alex.k.kaczmarczyk@gmail.com	2026-04-06 12:50:01	65	f	2026-04-30 12:10:19
70	alex.k.kaczmarczyk@gmail.com	2026-04-06 13:00:02	86	f	2026-04-30 12:10:19
71	alex.k.kaczmarczyk@gmail.com	2026-04-06 13:10:02	78	f	2026-04-30 12:10:19
72	alex.k.kaczmarczyk@gmail.com	2026-04-06 13:20:02	82	f	2026-04-30 12:10:19
73	alex.k.kaczmarczyk@gmail.com	2026-04-06 13:30:01	86	f	2026-04-30 12:10:19
74	alex.k.kaczmarczyk@gmail.com	2026-04-06 13:40:01	68	f	2026-04-30 12:10:19
75	alex.k.kaczmarczyk@gmail.com	2026-04-06 13:50:03	84	f	2026-04-30 12:10:19
76	alex.k.kaczmarczyk@gmail.com	2026-04-06 14:00:01	72	f	2026-04-30 12:10:19
77	alex.k.kaczmarczyk@gmail.com	2026-04-06 14:10:01	66	f	2026-04-30 12:10:19
78	alex.k.kaczmarczyk@gmail.com	2026-04-06 14:20:01	77	f	2026-04-30 12:10:19
79	alex.k.kaczmarczyk@gmail.com	2026-04-06 14:30:02	63	t	2026-04-30 12:10:19
17759	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:51:00	88	f	2026-05-06 23:11:15
17760	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:52:00	97	f	2026-05-06 23:11:15
17761	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:53:00	95	f	2026-05-06 23:11:15
17762	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:54:00	93	f	2026-05-06 23:11:15
17763	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:55:00	101	f	2026-05-06 23:11:15
17764	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:56:00	124	f	2026-05-06 23:11:15
17765	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:57:00	112	f	2026-05-06 23:11:15
17766	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:58:00	106	f	2026-05-06 23:11:15
17767	alex.k.kaczmarczyk@gmail.com	2026-04-02 19:59:00	93	f	2026-05-06 23:11:15
17768	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:00:00	100	f	2026-05-06 23:11:15
17769	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:01:00	112	f	2026-05-06 23:11:15
17770	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:02:00	101	f	2026-05-06 23:11:15
17771	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:03:00	117	f	2026-05-06 23:11:15
17772	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:04:00	114	f	2026-05-06 23:11:15
17773	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:05:00	101	f	2026-05-06 23:11:15
17774	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:06:00	108	f	2026-05-06 23:11:15
17775	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:07:00	117	f	2026-05-06 23:11:15
17776	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:08:00	108	f	2026-05-06 23:11:15
17777	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:09:00	107	f	2026-05-06 23:11:15
17778	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:10:00	123	f	2026-05-06 23:11:15
17779	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:11:00	111	f	2026-05-06 23:11:15
17780	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:12:00	98	f	2026-05-06 23:11:15
17781	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:13:00	96	f	2026-05-06 23:11:15
17782	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:14:00	101	f	2026-05-06 23:11:15
17783	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:15:00	102	f	2026-05-06 23:11:15
17784	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:16:00	107	f	2026-05-06 23:11:15
17785	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:17:00	106	f	2026-05-06 23:11:15
17786	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:18:00	90	f	2026-05-06 23:11:15
17787	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:19:00	87	f	2026-05-06 23:11:15
17788	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:21:00	99	f	2026-05-06 23:11:15
17790	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:22:00	87	f	2026-05-06 23:11:15
17791	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:23:00	90	f	2026-05-06 23:11:15
17792	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:24:00	107	f	2026-05-06 23:11:15
17793	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:25:00	109	f	2026-05-06 23:11:15
17794	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:26:00	102	f	2026-05-06 23:11:15
17795	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:27:00	117	f	2026-05-06 23:11:15
17796	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:28:00	100	f	2026-05-06 23:11:15
17797	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:29:00	97	f	2026-05-06 23:11:15
17798	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:31:00	98	f	2026-05-06 23:11:15
17800	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:32:00	121	f	2026-05-06 23:11:15
17801	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:33:00	103	f	2026-05-06 23:11:15
17802	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:34:00	95	f	2026-05-06 23:11:15
17803	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:35:00	88	f	2026-05-06 23:11:15
17804	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:36:00	102	f	2026-05-06 23:11:15
17805	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:37:00	95	f	2026-05-06 23:11:15
17806	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:38:00	91	f	2026-05-06 23:11:15
17807	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:39:00	89	f	2026-05-06 23:11:15
17808	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:40:00	99	f	2026-05-06 23:11:15
17809	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:41:00	103	f	2026-05-06 23:11:15
17810	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:42:00	95	f	2026-05-06 23:11:15
17811	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:43:00	97	f	2026-05-06 23:11:15
17812	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:44:00	101	f	2026-05-06 23:11:15
17813	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:45:00	104	f	2026-05-06 23:11:15
17814	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:46:00	113	f	2026-05-06 23:11:15
17815	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:47:00	108	f	2026-05-06 23:11:15
17816	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:48:00	128	f	2026-05-06 23:11:15
17817	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:49:00	104	f	2026-05-06 23:11:15
17818	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:50:00	104	f	2026-05-06 23:11:15
17819	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:51:00	85	f	2026-05-06 23:11:15
17820	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:52:00	80	f	2026-05-06 23:11:15
17822	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:54:00	101	f	2026-05-06 23:11:15
17824	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:55:00	110	f	2026-05-06 23:11:15
17825	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:57:00	91	f	2026-05-06 23:11:15
17826	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:58:00	92	f	2026-05-06 23:11:15
17827	alex.k.kaczmarczyk@gmail.com	2026-04-02 20:59:00	120	f	2026-05-06 23:11:15
17828	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:01:00	100	f	2026-05-06 23:11:15
17829	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:02:00	109	f	2026-05-06 23:11:15
17831	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:03:00	101	f	2026-05-06 23:11:15
17832	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:05:00	118	f	2026-05-06 23:11:15
17833	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:06:00	113	f	2026-05-06 23:11:15
17835	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:08:00	99	f	2026-05-06 23:11:15
17836	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:09:00	106	f	2026-05-06 23:11:15
17837	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:10:00	99	f	2026-05-06 23:11:15
17838	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:11:00	101	f	2026-05-06 23:11:15
17839	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:12:00	114	f	2026-05-06 23:11:15
17840	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:13:00	126	f	2026-05-06 23:11:15
17841	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:14:00	115	f	2026-05-06 23:11:15
17842	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:15:00	118	f	2026-05-06 23:11:15
17843	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:16:00	120	f	2026-05-06 23:11:15
17844	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:17:00	94	f	2026-05-06 23:11:15
17845	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:18:00	89	f	2026-05-06 23:11:15
17846	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:19:00	104	f	2026-05-06 23:11:15
17847	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:20:00	103	f	2026-05-06 23:11:15
17848	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:21:00	135	f	2026-05-06 23:11:15
17849	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:22:00	103	f	2026-05-06 23:11:15
17850	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:23:00	96	f	2026-05-06 23:11:15
17851	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:24:00	93	f	2026-05-06 23:11:15
17852	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:25:00	96	f	2026-05-06 23:11:15
17853	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:26:00	112	f	2026-05-06 23:11:15
17855	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:28:00	114	f	2026-05-06 23:11:15
17856	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:29:00	103	f	2026-05-06 23:11:15
17857	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:30:00	106	f	2026-05-06 23:11:15
17859	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:31:00	108	f	2026-05-06 23:11:15
17860	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:32:00	104	f	2026-05-06 23:11:15
17861	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:34:00	109	f	2026-05-06 23:11:15
17862	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:35:00	108	f	2026-05-06 23:11:15
17863	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:36:00	107	f	2026-05-06 23:11:15
17864	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:37:00	102	f	2026-05-06 23:11:15
17866	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:38:00	104	f	2026-05-06 23:11:15
17867	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:39:00	100	f	2026-05-06 23:11:15
17868	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:40:00	106	f	2026-05-06 23:11:15
17869	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:42:00	100	f	2026-05-06 23:11:15
17870	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:43:00	100	f	2026-05-06 23:11:15
17871	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:44:00	101	f	2026-05-06 23:11:15
17872	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:45:00	101	f	2026-05-06 23:11:15
17874	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:47:00	98	f	2026-05-06 23:11:15
17875	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:48:00	88	f	2026-05-06 23:11:15
17876	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:49:00	78	f	2026-05-06 23:11:15
17878	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:51:00	95	f	2026-05-06 23:11:15
17880	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:53:00	94	f	2026-05-06 23:11:15
17882	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:54:00	96	f	2026-05-06 23:11:15
17883	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:56:00	92	f	2026-05-06 23:11:15
17884	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:57:00	94	f	2026-05-06 23:11:15
17886	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:58:00	91	f	2026-05-06 23:11:15
17887	alex.k.kaczmarczyk@gmail.com	2026-04-02 21:59:00	94	f	2026-05-06 23:11:15
17888	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:00:00	103	f	2026-05-06 23:11:15
17889	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:02:00	96	f	2026-05-06 23:11:15
17890	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:03:00	79	f	2026-05-06 23:11:15
17891	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:04:00	75	f	2026-05-06 23:11:15
17892	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:05:00	76	f	2026-05-06 23:11:15
17893	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:06:00	79	f	2026-05-06 23:11:15
17895	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:08:00	75	f	2026-05-06 23:11:15
17896	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:09:00	81	f	2026-05-06 23:11:15
17897	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:10:00	71	f	2026-05-06 23:11:15
17898	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:11:00	74	f	2026-05-06 23:11:15
17899	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:12:00	71	f	2026-05-06 23:11:15
17900	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:13:00	71	f	2026-05-06 23:11:15
17901	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:14:00	70	f	2026-05-06 23:11:15
17902	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:15:00	69	f	2026-05-06 23:11:15
17904	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:15:19	77	f	2026-05-06 23:11:15
17905	alex.k.kaczmarczyk@gmail.com	2026-04-02 22:20:01	81	f	2026-05-06 23:11:15
17906	alex.k.kaczmarczyk@gmail.com	2026-04-03 12:00:01	90	f	2026-05-06 23:11:15
17907	alex.k.kaczmarczyk@gmail.com	2026-04-03 12:10:01	96	f	2026-05-06 23:11:15
17908	alex.k.kaczmarczyk@gmail.com	2026-04-03 12:20:01	110	f	2026-05-06 23:11:15
17909	alex.k.kaczmarczyk@gmail.com	2026-04-03 12:30:01	94	f	2026-05-06 23:11:15
17910	alex.k.kaczmarczyk@gmail.com	2026-04-03 12:40:01	103	f	2026-05-06 23:11:15
17911	alex.k.kaczmarczyk@gmail.com	2026-04-03 12:50:01	122	f	2026-05-06 23:11:15
17912	alex.k.kaczmarczyk@gmail.com	2026-04-03 13:00:01	106	f	2026-05-06 23:11:15
17913	alex.k.kaczmarczyk@gmail.com	2026-04-03 13:10:01	113	f	2026-05-06 23:11:15
17914	alex.k.kaczmarczyk@gmail.com	2026-04-03 13:20:02	121	f	2026-05-06 23:11:15
17915	alex.k.kaczmarczyk@gmail.com	2026-04-03 13:30:01	82	f	2026-05-06 23:11:15
17916	alex.k.kaczmarczyk@gmail.com	2026-04-03 13:40:01	95	f	2026-05-06 23:11:15
17917	alex.k.kaczmarczyk@gmail.com	2026-04-03 13:50:01	98	f	2026-05-06 23:11:15
17918	alex.k.kaczmarczyk@gmail.com	2026-04-03 14:00:01	111	f	2026-05-06 23:11:15
17919	alex.k.kaczmarczyk@gmail.com	2026-04-03 14:10:02	108	f	2026-05-06 23:11:15
17920	alex.k.kaczmarczyk@gmail.com	2026-04-03 14:20:00	96	f	2026-05-06 23:11:15
17921	alex.k.kaczmarczyk@gmail.com	2026-04-03 14:30:00	103	f	2026-05-06 23:11:15
17922	alex.k.kaczmarczyk@gmail.com	2026-04-03 14:40:00	92	f	2026-05-06 23:11:15
17923	alex.k.kaczmarczyk@gmail.com	2026-04-03 14:50:01	87	f	2026-05-06 23:11:15
17924	alex.k.kaczmarczyk@gmail.com	2026-04-03 15:00:01	80	f	2026-05-06 23:11:15
17925	alex.k.kaczmarczyk@gmail.com	2026-04-03 15:10:01	79	f	2026-05-06 23:11:15
17926	alex.k.kaczmarczyk@gmail.com	2026-04-03 15:20:00	89	f	2026-05-06 23:11:15
17927	alex.k.kaczmarczyk@gmail.com	2026-04-03 15:30:01	73	f	2026-05-06 23:11:15
17928	alex.k.kaczmarczyk@gmail.com	2026-04-03 15:40:01	67	f	2026-05-06 23:11:15
17929	alex.k.kaczmarczyk@gmail.com	2026-04-03 15:50:01	69	f	2026-05-06 23:11:15
17930	alex.k.kaczmarczyk@gmail.com	2026-04-03 16:00:01	66	f	2026-05-06 23:11:15
17931	alex.k.kaczmarczyk@gmail.com	2026-04-03 16:10:02	61	t	2026-05-06 23:11:15
17932	alex.k.kaczmarczyk@gmail.com	2026-04-03 19:40:01	92	f	2026-05-06 23:11:15
17933	alex.k.kaczmarczyk@gmail.com	2026-04-03 19:50:01	93	f	2026-05-06 23:11:15
17934	alex.k.kaczmarczyk@gmail.com	2026-04-03 20:00:01	112	f	2026-05-06 23:11:15
17935	alex.k.kaczmarczyk@gmail.com	2026-04-03 20:10:00	109	f	2026-05-06 23:11:15
17936	alex.k.kaczmarczyk@gmail.com	2026-04-03 20:20:00	90	f	2026-05-06 23:11:15
17937	alex.k.kaczmarczyk@gmail.com	2026-04-03 20:30:01	97	f	2026-05-06 23:11:15
17938	alex.k.kaczmarczyk@gmail.com	2026-04-03 20:40:01	101	f	2026-05-06 23:11:15
17939	alex.k.kaczmarczyk@gmail.com	2026-04-03 20:50:01	65	f	2026-05-06 23:11:15
17940	alex.k.kaczmarczyk@gmail.com	2026-04-03 21:00:02	77	f	2026-05-06 23:11:15
17941	alex.k.kaczmarczyk@gmail.com	2026-04-03 21:10:00	79	f	2026-05-06 23:11:15
17942	alex.k.kaczmarczyk@gmail.com	2026-04-03 21:20:01	70	f	2026-05-06 23:11:15
17943	alex.k.kaczmarczyk@gmail.com	2026-04-03 21:30:00	70	f	2026-05-06 23:11:15
17944	alex.k.kaczmarczyk@gmail.com	2026-04-03 21:40:01	77	f	2026-05-06 23:11:15
17945	alex.k.kaczmarczyk@gmail.com	2026-04-03 21:50:01	92	f	2026-05-06 23:11:15
17946	alex.k.kaczmarczyk@gmail.com	2026-04-04 00:30:01	73	t	2026-05-06 23:11:15
17947	alex.k.kaczmarczyk@gmail.com	2026-04-04 00:40:01	60	t	2026-05-06 23:11:15
17948	alex.k.kaczmarczyk@gmail.com	2026-04-04 00:50:08	55	t	2026-05-06 23:11:15
17949	alex.k.kaczmarczyk@gmail.com	2026-04-04 01:00:09	55	t	2026-05-06 23:11:15
17950	alex.k.kaczmarczyk@gmail.com	2026-04-04 01:10:11	54	t	2026-05-06 23:11:15
17951	alex.k.kaczmarczyk@gmail.com	2026-04-04 01:20:08	52	t	2026-05-06 23:11:15
17952	alex.k.kaczmarczyk@gmail.com	2026-04-04 01:30:08	62	t	2026-05-06 23:11:15
17953	alex.k.kaczmarczyk@gmail.com	2026-04-04 01:40:08	58	t	2026-05-06 23:11:15
17954	alex.k.kaczmarczyk@gmail.com	2026-04-04 01:50:09	56	t	2026-05-06 23:11:15
17955	alex.k.kaczmarczyk@gmail.com	2026-04-04 02:00:09	55	t	2026-05-06 23:11:15
17956	alex.k.kaczmarczyk@gmail.com	2026-04-04 02:10:12	59	t	2026-05-06 23:11:15
17957	alex.k.kaczmarczyk@gmail.com	2026-04-04 02:20:12	64	t	2026-05-06 23:11:15
17958	alex.k.kaczmarczyk@gmail.com	2026-04-04 02:30:10	58	t	2026-05-06 23:11:15
17959	alex.k.kaczmarczyk@gmail.com	2026-04-04 02:40:10	53	t	2026-05-06 23:11:15
17960	alex.k.kaczmarczyk@gmail.com	2026-04-04 02:50:09	57	t	2026-05-06 23:11:15
17961	alex.k.kaczmarczyk@gmail.com	2026-04-04 03:00:11	60	t	2026-05-06 23:11:15
17962	alex.k.kaczmarczyk@gmail.com	2026-04-04 03:10:21	68	t	2026-05-06 23:11:15
17963	alex.k.kaczmarczyk@gmail.com	2026-04-04 03:20:09	64	t	2026-05-06 23:11:15
17964	alex.k.kaczmarczyk@gmail.com	2026-04-04 03:30:09	67	t	2026-05-06 23:11:15
17965	alex.k.kaczmarczyk@gmail.com	2026-04-04 03:40:13	55	t	2026-05-06 23:11:15
17966	alex.k.kaczmarczyk@gmail.com	2026-04-04 03:50:10	53	t	2026-05-06 23:11:15
17967	alex.k.kaczmarczyk@gmail.com	2026-04-04 04:00:10	52	t	2026-05-06 23:11:15
17968	alex.k.kaczmarczyk@gmail.com	2026-04-04 04:10:09	52	t	2026-05-06 23:11:15
17969	alex.k.kaczmarczyk@gmail.com	2026-04-04 04:20:09	52	t	2026-05-06 23:11:15
17970	alex.k.kaczmarczyk@gmail.com	2026-04-04 04:30:09	53	t	2026-05-06 23:11:15
17971	alex.k.kaczmarczyk@gmail.com	2026-04-04 04:40:21	51	t	2026-05-06 23:11:15
17972	alex.k.kaczmarczyk@gmail.com	2026-04-04 04:50:09	54	t	2026-05-06 23:11:15
17973	alex.k.kaczmarczyk@gmail.com	2026-04-04 05:00:21	88	f	2026-05-06 23:11:15
17974	alex.k.kaczmarczyk@gmail.com	2026-04-04 05:10:09	56	t	2026-05-06 23:11:15
17975	alex.k.kaczmarczyk@gmail.com	2026-04-04 05:20:21	48	t	2026-05-06 23:11:15
17976	alex.k.kaczmarczyk@gmail.com	2026-04-04 05:30:17	51	t	2026-05-06 23:11:15
17977	alex.k.kaczmarczyk@gmail.com	2026-04-04 05:40:19	51	t	2026-05-06 23:11:15
17978	alex.k.kaczmarczyk@gmail.com	2026-04-04 05:50:20	62	t	2026-05-06 23:11:15
17979	alex.k.kaczmarczyk@gmail.com	2026-04-04 06:00:22	75	f	2026-05-06 23:11:15
17980	alex.k.kaczmarczyk@gmail.com	2026-04-04 06:30:00	55	t	2026-05-06 23:11:15
17981	alex.k.kaczmarczyk@gmail.com	2026-04-04 06:40:01	66	f	2026-05-06 23:11:15
17982	alex.k.kaczmarczyk@gmail.com	2026-04-04 06:50:01	64	t	2026-05-06 23:11:15
17983	alex.k.kaczmarczyk@gmail.com	2026-04-04 07:00:01	101	f	2026-05-06 23:11:15
17984	alex.k.kaczmarczyk@gmail.com	2026-04-04 07:10:01	64	t	2026-05-06 23:11:15
17985	alex.k.kaczmarczyk@gmail.com	2026-04-04 07:20:01	60	t	2026-05-06 23:11:15
17986	alex.k.kaczmarczyk@gmail.com	2026-04-04 07:30:01	84	f	2026-05-06 23:11:15
17987	alex.k.kaczmarczyk@gmail.com	2026-04-04 07:40:01	99	f	2026-05-06 23:11:15
17988	alex.k.kaczmarczyk@gmail.com	2026-04-04 07:50:01	76	f	2026-05-06 23:11:15
17989	alex.k.kaczmarczyk@gmail.com	2026-04-04 08:00:01	85	f	2026-05-06 23:11:15
17990	alex.k.kaczmarczyk@gmail.com	2026-04-04 08:10:00	98	f	2026-05-06 23:11:15
17991	alex.k.kaczmarczyk@gmail.com	2026-04-04 08:20:01	78	f	2026-05-06 23:11:15
17992	alex.k.kaczmarczyk@gmail.com	2026-04-04 08:30:01	105	f	2026-05-06 23:11:15
17993	alex.k.kaczmarczyk@gmail.com	2026-04-04 08:40:01	84	f	2026-05-06 23:11:15
17994	alex.k.kaczmarczyk@gmail.com	2026-04-04 08:50:01	67	f	2026-05-06 23:11:15
17995	alex.k.kaczmarczyk@gmail.com	2026-04-04 09:00:01	88	f	2026-05-06 23:11:15
17996	alex.k.kaczmarczyk@gmail.com	2026-04-04 09:10:02	90	f	2026-05-06 23:11:15
17997	alex.k.kaczmarczyk@gmail.com	2026-04-04 09:20:00	89	f	2026-05-06 23:11:15
17998	alex.k.kaczmarczyk@gmail.com	2026-04-04 09:30:01	92	f	2026-05-06 23:11:15
17999	alex.k.kaczmarczyk@gmail.com	2026-04-04 09:40:01	88	f	2026-05-06 23:11:15
18000	alex.k.kaczmarczyk@gmail.com	2026-04-04 09:50:01	86	f	2026-05-06 23:11:15
18001	alex.k.kaczmarczyk@gmail.com	2026-04-04 10:00:02	82	f	2026-05-06 23:11:15
18002	alex.k.kaczmarczyk@gmail.com	2026-04-04 10:10:02	97	f	2026-05-06 23:11:15
18003	alex.k.kaczmarczyk@gmail.com	2026-04-04 10:20:01	86	f	2026-05-06 23:11:15
18004	alex.k.kaczmarczyk@gmail.com	2026-04-04 10:30:01	85	f	2026-05-06 23:11:15
18005	alex.k.kaczmarczyk@gmail.com	2026-04-04 10:40:02	85	f	2026-05-06 23:11:15
18006	alex.k.kaczmarczyk@gmail.com	2026-04-04 10:50:02	83	f	2026-05-06 23:11:15
18007	alex.k.kaczmarczyk@gmail.com	2026-04-04 11:00:01	92	f	2026-05-06 23:11:15
18008	alex.k.kaczmarczyk@gmail.com	2026-04-04 11:10:01	86	f	2026-05-06 23:11:15
18009	alex.k.kaczmarczyk@gmail.com	2026-04-04 11:20:01	90	f	2026-05-06 23:11:15
18010	alex.k.kaczmarczyk@gmail.com	2026-04-04 11:30:01	83	f	2026-05-06 23:11:15
18011	alex.k.kaczmarczyk@gmail.com	2026-04-04 11:40:01	81	f	2026-05-06 23:11:15
18012	alex.k.kaczmarczyk@gmail.com	2026-04-04 11:50:01	93	f	2026-05-06 23:11:15
18013	alex.k.kaczmarczyk@gmail.com	2026-04-04 12:00:01	108	f	2026-05-06 23:11:15
18014	alex.k.kaczmarczyk@gmail.com	2026-04-04 12:10:01	93	f	2026-05-06 23:11:15
18015	alex.k.kaczmarczyk@gmail.com	2026-04-04 12:20:00	92	f	2026-05-06 23:11:15
18016	alex.k.kaczmarczyk@gmail.com	2026-04-04 12:30:01	95	f	2026-05-06 23:11:15
18017	alex.k.kaczmarczyk@gmail.com	2026-04-04 12:40:01	87	f	2026-05-06 23:11:15
18018	alex.k.kaczmarczyk@gmail.com	2026-04-04 12:50:01	91	f	2026-05-06 23:11:15
18019	alex.k.kaczmarczyk@gmail.com	2026-04-04 13:00:00	85	f	2026-05-06 23:11:15
18020	alex.k.kaczmarczyk@gmail.com	2026-04-04 13:10:01	101	f	2026-05-06 23:11:15
18021	alex.k.kaczmarczyk@gmail.com	2026-04-04 13:20:01	89	f	2026-05-06 23:11:15
18022	alex.k.kaczmarczyk@gmail.com	2026-04-04 13:30:01	91	f	2026-05-06 23:11:15
18023	alex.k.kaczmarczyk@gmail.com	2026-04-04 13:40:01	70	f	2026-05-06 23:11:15
18024	alex.k.kaczmarczyk@gmail.com	2026-04-04 13:50:01	83	f	2026-05-06 23:11:15
18025	alex.k.kaczmarczyk@gmail.com	2026-04-04 14:00:01	88	f	2026-05-06 23:11:15
18026	alex.k.kaczmarczyk@gmail.com	2026-04-04 14:10:01	83	f	2026-05-06 23:11:15
18027	alex.k.kaczmarczyk@gmail.com	2026-04-04 14:20:01	94	f	2026-05-06 23:11:15
18028	alex.k.kaczmarczyk@gmail.com	2026-04-04 14:30:01	71	f	2026-05-06 23:11:15
18029	alex.k.kaczmarczyk@gmail.com	2026-04-04 14:40:01	76	f	2026-05-06 23:11:15
18030	alex.k.kaczmarczyk@gmail.com	2026-04-04 14:50:01	87	f	2026-05-06 23:11:15
18031	alex.k.kaczmarczyk@gmail.com	2026-04-04 15:00:02	87	f	2026-05-06 23:11:15
18032	alex.k.kaczmarczyk@gmail.com	2026-04-04 15:10:00	101	f	2026-05-06 23:11:15
18033	alex.k.kaczmarczyk@gmail.com	2026-04-04 15:20:01	71	f	2026-05-06 23:11:15
18034	alex.k.kaczmarczyk@gmail.com	2026-04-04 15:30:01	89	f	2026-05-06 23:11:15
18035	alex.k.kaczmarczyk@gmail.com	2026-04-04 15:40:01	72	f	2026-05-06 23:11:15
18036	alex.k.kaczmarczyk@gmail.com	2026-04-04 15:50:02	77	f	2026-05-06 23:11:15
18037	alex.k.kaczmarczyk@gmail.com	2026-04-04 16:00:01	80	f	2026-05-06 23:11:15
18038	alex.k.kaczmarczyk@gmail.com	2026-04-04 16:10:01	81	f	2026-05-06 23:11:15
18039	alex.k.kaczmarczyk@gmail.com	2026-04-04 16:20:01	89	f	2026-05-06 23:11:15
18040	alex.k.kaczmarczyk@gmail.com	2026-04-04 16:30:01	88	f	2026-05-06 23:11:15
18041	alex.k.kaczmarczyk@gmail.com	2026-04-04 16:40:01	68	f	2026-05-06 23:11:15
18042	alex.k.kaczmarczyk@gmail.com	2026-04-04 16:50:01	83	f	2026-05-06 23:11:15
18043	alex.k.kaczmarczyk@gmail.com	2026-04-04 17:00:02	88	f	2026-05-06 23:11:15
18044	alex.k.kaczmarczyk@gmail.com	2026-04-04 17:10:00	90	f	2026-05-06 23:11:15
18045	alex.k.kaczmarczyk@gmail.com	2026-04-04 17:20:00	80	f	2026-05-06 23:11:15
18046	alex.k.kaczmarczyk@gmail.com	2026-04-04 17:30:01	89	f	2026-05-06 23:11:15
18047	alex.k.kaczmarczyk@gmail.com	2026-04-04 17:40:01	91	f	2026-05-06 23:11:15
18048	alex.k.kaczmarczyk@gmail.com	2026-04-04 17:50:02	84	f	2026-05-06 23:11:15
18049	alex.k.kaczmarczyk@gmail.com	2026-04-04 18:00:01	72	f	2026-05-06 23:11:15
18050	alex.k.kaczmarczyk@gmail.com	2026-04-04 18:10:00	67	f	2026-05-06 23:11:15
18051	alex.k.kaczmarczyk@gmail.com	2026-04-04 18:20:01	79	f	2026-05-06 23:11:15
18052	alex.k.kaczmarczyk@gmail.com	2026-04-04 18:30:01	70	f	2026-05-06 23:11:15
18053	alex.k.kaczmarczyk@gmail.com	2026-04-04 18:40:01	68	f	2026-05-06 23:11:15
18054	alex.k.kaczmarczyk@gmail.com	2026-04-04 18:50:02	81	f	2026-05-06 23:11:15
18055	alex.k.kaczmarczyk@gmail.com	2026-04-04 19:00:02	90	f	2026-05-06 23:11:15
18056	alex.k.kaczmarczyk@gmail.com	2026-04-04 19:10:01	78	f	2026-05-06 23:11:15
18057	alex.k.kaczmarczyk@gmail.com	2026-04-04 19:20:01	95	f	2026-05-06 23:11:15
18058	alex.k.kaczmarczyk@gmail.com	2026-04-04 19:30:01	78	f	2026-05-06 23:11:15
18059	alex.k.kaczmarczyk@gmail.com	2026-04-04 19:40:01	97	f	2026-05-06 23:11:15
18060	alex.k.kaczmarczyk@gmail.com	2026-04-04 19:50:01	85	f	2026-05-06 23:11:15
18061	alex.k.kaczmarczyk@gmail.com	2026-04-04 20:00:01	85	f	2026-05-06 23:11:15
18062	alex.k.kaczmarczyk@gmail.com	2026-04-04 20:10:00	85	f	2026-05-06 23:11:15
18063	alex.k.kaczmarczyk@gmail.com	2026-04-04 20:20:01	82	f	2026-05-06 23:11:15
18064	alex.k.kaczmarczyk@gmail.com	2026-04-04 20:30:02	76	f	2026-05-06 23:11:15
18065	alex.k.kaczmarczyk@gmail.com	2026-04-04 20:40:01	83	f	2026-05-06 23:11:15
18066	alex.k.kaczmarczyk@gmail.com	2026-04-04 20:50:01	84	f	2026-05-06 23:11:15
18067	alex.k.kaczmarczyk@gmail.com	2026-04-04 21:00:01	94	f	2026-05-06 23:11:15
18068	alex.k.kaczmarczyk@gmail.com	2026-04-04 21:10:01	82	f	2026-05-06 23:11:15
18069	alex.k.kaczmarczyk@gmail.com	2026-04-04 21:20:01	85	f	2026-05-06 23:11:15
18070	alex.k.kaczmarczyk@gmail.com	2026-04-04 21:30:01	97	f	2026-05-06 23:11:15
18071	alex.k.kaczmarczyk@gmail.com	2026-04-04 21:40:02	104	f	2026-05-06 23:11:15
18072	alex.k.kaczmarczyk@gmail.com	2026-04-04 21:50:00	83	f	2026-05-06 23:11:15
18073	alex.k.kaczmarczyk@gmail.com	2026-04-04 22:00:01	66	f	2026-05-06 23:11:15
18074	alex.k.kaczmarczyk@gmail.com	2026-04-04 22:10:01	83	f	2026-05-06 23:11:15
18075	alex.k.kaczmarczyk@gmail.com	2026-04-04 22:20:02	66	f	2026-05-06 23:11:15
18076	alex.k.kaczmarczyk@gmail.com	2026-04-04 22:30:02	66	f	2026-05-06 23:11:15
18077	alex.k.kaczmarczyk@gmail.com	2026-04-04 22:40:01	75	f	2026-05-06 23:11:15
18078	alex.k.kaczmarczyk@gmail.com	2026-04-04 22:50:01	84	f	2026-05-06 23:11:15
18079	alex.k.kaczmarczyk@gmail.com	2026-04-04 23:00:00	83	f	2026-05-06 23:11:15
18080	alex.k.kaczmarczyk@gmail.com	2026-04-04 23:10:01	86	f	2026-05-06 23:11:15
18081	alex.k.kaczmarczyk@gmail.com	2026-04-04 23:20:01	68	f	2026-05-06 23:11:15
18082	alex.k.kaczmarczyk@gmail.com	2026-04-04 23:30:01	65	f	2026-05-06 23:11:15
18083	alex.k.kaczmarczyk@gmail.com	2026-04-04 23:40:01	69	f	2026-05-06 23:11:15
18084	alex.k.kaczmarczyk@gmail.com	2026-04-04 23:50:01	79	f	2026-05-06 23:11:15
18085	alex.k.kaczmarczyk@gmail.com	2026-04-05 00:00:01	75	t	2026-05-06 23:11:15
18086	alex.k.kaczmarczyk@gmail.com	2026-04-05 00:10:02	83	f	2026-05-06 23:11:15
18087	alex.k.kaczmarczyk@gmail.com	2026-04-05 00:20:02	70	t	2026-05-06 23:11:15
18088	alex.k.kaczmarczyk@gmail.com	2026-04-05 00:30:01	62	t	2026-05-06 23:11:15
18089	alex.k.kaczmarczyk@gmail.com	2026-04-05 00:40:01	60	t	2026-05-06 23:11:15
18090	alex.k.kaczmarczyk@gmail.com	2026-04-05 00:50:10	62	t	2026-05-06 23:11:15
18091	alex.k.kaczmarczyk@gmail.com	2026-04-05 01:00:09	62	t	2026-05-06 23:11:15
18092	alex.k.kaczmarczyk@gmail.com	2026-04-05 01:10:09	61	t	2026-05-06 23:11:15
18093	alex.k.kaczmarczyk@gmail.com	2026-04-05 01:20:09	60	t	2026-05-06 23:11:15
18094	alex.k.kaczmarczyk@gmail.com	2026-04-05 01:30:09	58	t	2026-05-06 23:11:15
18095	alex.k.kaczmarczyk@gmail.com	2026-04-05 01:40:09	71	t	2026-05-06 23:11:15
18096	alex.k.kaczmarczyk@gmail.com	2026-04-05 01:50:09	64	t	2026-05-06 23:11:15
18097	alex.k.kaczmarczyk@gmail.com	2026-04-05 02:00:10	58	t	2026-05-06 23:11:15
18098	alex.k.kaczmarczyk@gmail.com	2026-04-05 02:10:09	55	t	2026-05-06 23:11:15
18099	alex.k.kaczmarczyk@gmail.com	2026-04-05 02:20:21	82	f	2026-05-06 23:11:15
18100	alex.k.kaczmarczyk@gmail.com	2026-04-05 02:30:22	56	t	2026-05-06 23:11:15
18101	alex.k.kaczmarczyk@gmail.com	2026-04-05 02:40:09	57	t	2026-05-06 23:11:15
18102	alex.k.kaczmarczyk@gmail.com	2026-04-05 02:50:13	57	t	2026-05-06 23:11:15
18103	alex.k.kaczmarczyk@gmail.com	2026-04-05 03:00:09	59	t	2026-05-06 23:11:15
18104	alex.k.kaczmarczyk@gmail.com	2026-04-05 03:10:09	59	t	2026-05-06 23:11:15
18105	alex.k.kaczmarczyk@gmail.com	2026-04-05 03:20:09	62	t	2026-05-06 23:11:15
18106	alex.k.kaczmarczyk@gmail.com	2026-04-05 03:30:09	65	t	2026-05-06 23:11:15
18107	alex.k.kaczmarczyk@gmail.com	2026-04-05 03:40:09	63	t	2026-05-06 23:11:15
18108	alex.k.kaczmarczyk@gmail.com	2026-04-05 03:50:09	59	t	2026-05-06 23:11:15
18109	alex.k.kaczmarczyk@gmail.com	2026-04-05 04:00:09	54	t	2026-05-06 23:11:15
18110	alex.k.kaczmarczyk@gmail.com	2026-04-05 04:10:09	74	t	2026-05-06 23:11:15
18111	alex.k.kaczmarczyk@gmail.com	2026-04-05 04:20:09	55	t	2026-05-06 23:11:15
18112	alex.k.kaczmarczyk@gmail.com	2026-04-05 04:30:09	54	t	2026-05-06 23:11:15
18113	alex.k.kaczmarczyk@gmail.com	2026-04-05 04:40:10	54	t	2026-05-06 23:11:15
18114	alex.k.kaczmarczyk@gmail.com	2026-04-05 04:50:09	53	t	2026-05-06 23:11:15
18115	alex.k.kaczmarczyk@gmail.com	2026-04-05 05:00:17	75	t	2026-05-06 23:11:15
18116	alex.k.kaczmarczyk@gmail.com	2026-04-05 05:10:10	52	t	2026-05-06 23:11:15
18117	alex.k.kaczmarczyk@gmail.com	2026-04-05 05:20:10	59	t	2026-05-06 23:11:15
18118	alex.k.kaczmarczyk@gmail.com	2026-04-05 05:30:16	58	t	2026-05-06 23:11:15
18119	alex.k.kaczmarczyk@gmail.com	2026-04-05 05:40:09	57	t	2026-05-06 23:11:15
18120	alex.k.kaczmarczyk@gmail.com	2026-04-05 05:50:13	53	t	2026-05-06 23:11:15
18121	alex.k.kaczmarczyk@gmail.com	2026-04-05 06:00:10	54	t	2026-05-06 23:11:15
18122	alex.k.kaczmarczyk@gmail.com	2026-04-05 06:10:18	53	t	2026-05-06 23:11:15
18123	alex.k.kaczmarczyk@gmail.com	2026-04-05 06:20:09	51	t	2026-05-06 23:11:15
18124	alex.k.kaczmarczyk@gmail.com	2026-04-05 06:30:20	51	t	2026-05-06 23:11:15
18125	alex.k.kaczmarczyk@gmail.com	2026-04-05 06:40:11	54	t	2026-05-06 23:11:15
18126	alex.k.kaczmarczyk@gmail.com	2026-04-05 06:50:10	48	t	2026-05-06 23:11:15
18127	alex.k.kaczmarczyk@gmail.com	2026-04-05 07:00:21	54	t	2026-05-06 23:11:15
18128	alex.k.kaczmarczyk@gmail.com	2026-04-05 07:10:10	52	t	2026-05-06 23:11:15
18129	alex.k.kaczmarczyk@gmail.com	2026-04-05 07:20:09	51	t	2026-05-06 23:11:15
18130	alex.k.kaczmarczyk@gmail.com	2026-04-05 07:30:10	57	t	2026-05-06 23:11:15
18131	alex.k.kaczmarczyk@gmail.com	2026-04-05 07:40:09	52	t	2026-05-06 23:11:15
18132	alex.k.kaczmarczyk@gmail.com	2026-04-05 07:50:10	54	t	2026-05-06 23:11:15
18133	alex.k.kaczmarczyk@gmail.com	2026-04-05 08:00:18	69	f	2026-05-06 23:11:15
18134	alex.k.kaczmarczyk@gmail.com	2026-04-05 08:10:13	52	t	2026-05-06 23:11:15
18135	alex.k.kaczmarczyk@gmail.com	2026-04-05 08:20:17	53	t	2026-05-06 23:11:15
18136	alex.k.kaczmarczyk@gmail.com	2026-04-05 08:30:12	53	t	2026-05-06 23:11:15
18137	alex.k.kaczmarczyk@gmail.com	2026-04-05 08:40:09	53	t	2026-05-06 23:11:15
18138	alex.k.kaczmarczyk@gmail.com	2026-04-05 08:50:13	56	t	2026-05-06 23:11:15
18139	alex.k.kaczmarczyk@gmail.com	2026-04-05 09:00:17	57	t	2026-05-06 23:11:15
18140	alex.k.kaczmarczyk@gmail.com	2026-04-05 09:10:10	50	t	2026-05-06 23:11:15
18141	alex.k.kaczmarczyk@gmail.com	2026-04-05 09:20:21	74	f	2026-05-06 23:11:15
18142	alex.k.kaczmarczyk@gmail.com	2026-04-05 09:30:22	99	f	2026-05-06 23:11:15
18143	alex.k.kaczmarczyk@gmail.com	2026-04-05 10:00:01	102	f	2026-05-06 23:11:15
18144	alex.k.kaczmarczyk@gmail.com	2026-04-05 10:10:02	86	f	2026-05-06 23:11:15
18145	alex.k.kaczmarczyk@gmail.com	2026-04-05 10:20:01	66	f	2026-05-06 23:11:15
18146	alex.k.kaczmarczyk@gmail.com	2026-04-05 10:30:02	69	f	2026-05-06 23:11:15
18147	alex.k.kaczmarczyk@gmail.com	2026-04-05 10:40:01	63	t	2026-05-06 23:11:15
18148	alex.k.kaczmarczyk@gmail.com	2026-04-05 10:50:02	93	f	2026-05-06 23:11:15
18149	alex.k.kaczmarczyk@gmail.com	2026-04-05 11:00:01	67	f	2026-05-06 23:11:15
18150	alex.k.kaczmarczyk@gmail.com	2026-04-05 11:10:02	81	f	2026-05-06 23:11:15
18151	alex.k.kaczmarczyk@gmail.com	2026-04-05 11:20:01	77	f	2026-05-06 23:11:15
18152	alex.k.kaczmarczyk@gmail.com	2026-04-05 11:30:01	76	f	2026-05-06 23:11:15
18153	alex.k.kaczmarczyk@gmail.com	2026-04-05 11:40:01	75	f	2026-05-06 23:11:15
18154	alex.k.kaczmarczyk@gmail.com	2026-04-05 11:50:01	84	f	2026-05-06 23:11:15
18155	alex.k.kaczmarczyk@gmail.com	2026-04-05 12:00:01	73	f	2026-05-06 23:11:15
18156	alex.k.kaczmarczyk@gmail.com	2026-04-05 12:10:02	108	f	2026-05-06 23:11:15
18157	alex.k.kaczmarczyk@gmail.com	2026-04-05 12:20:01	84	f	2026-05-06 23:11:15
18158	alex.k.kaczmarczyk@gmail.com	2026-04-05 12:30:02	78	f	2026-05-06 23:11:15
18159	alex.k.kaczmarczyk@gmail.com	2026-04-05 12:40:01	73	f	2026-05-06 23:11:15
18160	alex.k.kaczmarczyk@gmail.com	2026-04-05 12:50:01	68	f	2026-05-06 23:11:15
18161	alex.k.kaczmarczyk@gmail.com	2026-04-05 13:00:02	97	f	2026-05-06 23:11:15
18162	alex.k.kaczmarczyk@gmail.com	2026-04-05 13:10:01	102	f	2026-05-06 23:11:15
18163	alex.k.kaczmarczyk@gmail.com	2026-04-05 13:20:02	74	f	2026-05-06 23:11:15
18164	alex.k.kaczmarczyk@gmail.com	2026-04-05 13:30:01	100	f	2026-05-06 23:11:15
18165	alex.k.kaczmarczyk@gmail.com	2026-04-05 13:40:01	98	f	2026-05-06 23:11:15
18166	alex.k.kaczmarczyk@gmail.com	2026-04-05 13:50:01	91	f	2026-05-06 23:11:15
18167	alex.k.kaczmarczyk@gmail.com	2026-04-05 14:00:01	90	f	2026-05-06 23:11:15
18168	alex.k.kaczmarczyk@gmail.com	2026-04-05 14:10:02	92	f	2026-05-06 23:11:15
18169	alex.k.kaczmarczyk@gmail.com	2026-04-05 14:20:01	69	f	2026-05-06 23:11:15
18170	alex.k.kaczmarczyk@gmail.com	2026-04-05 14:30:02	64	t	2026-05-06 23:11:15
18171	alex.k.kaczmarczyk@gmail.com	2026-04-05 14:40:02	66	f	2026-05-06 23:11:15
18172	alex.k.kaczmarczyk@gmail.com	2026-04-05 14:50:01	92	f	2026-05-06 23:11:15
18173	alex.k.kaczmarczyk@gmail.com	2026-04-05 15:00:01	67	f	2026-05-06 23:11:15
18174	alex.k.kaczmarczyk@gmail.com	2026-04-05 15:10:01	95	f	2026-05-06 23:11:15
18175	alex.k.kaczmarczyk@gmail.com	2026-04-05 15:20:02	91	f	2026-05-06 23:11:15
18176	alex.k.kaczmarczyk@gmail.com	2026-04-05 15:30:01	91	f	2026-05-06 23:11:15
18177	alex.k.kaczmarczyk@gmail.com	2026-04-05 15:40:01	74	f	2026-05-06 23:11:15
18178	alex.k.kaczmarczyk@gmail.com	2026-04-05 15:50:00	77	f	2026-05-06 23:11:15
18179	alex.k.kaczmarczyk@gmail.com	2026-04-05 16:00:01	74	f	2026-05-06 23:11:15
18180	alex.k.kaczmarczyk@gmail.com	2026-04-05 16:10:00	77	f	2026-05-06 23:11:15
18181	alex.k.kaczmarczyk@gmail.com	2026-04-05 16:20:01	88	f	2026-05-06 23:11:15
18182	alex.k.kaczmarczyk@gmail.com	2026-04-05 16:30:01	84	f	2026-05-06 23:11:15
18183	alex.k.kaczmarczyk@gmail.com	2026-04-05 16:40:01	77	f	2026-05-06 23:11:15
18184	alex.k.kaczmarczyk@gmail.com	2026-04-05 16:50:01	71	f	2026-05-06 23:11:15
18185	alex.k.kaczmarczyk@gmail.com	2026-04-05 17:00:01	89	f	2026-05-06 23:11:15
18186	alex.k.kaczmarczyk@gmail.com	2026-04-05 17:10:01	91	f	2026-05-06 23:11:15
18187	alex.k.kaczmarczyk@gmail.com	2026-04-05 17:20:01	65	f	2026-05-06 23:11:15
18188	alex.k.kaczmarczyk@gmail.com	2026-04-05 17:30:01	69	f	2026-05-06 23:11:15
18189	alex.k.kaczmarczyk@gmail.com	2026-04-05 17:40:00	70	f	2026-05-06 23:11:15
18190	alex.k.kaczmarczyk@gmail.com	2026-04-05 17:50:00	79	f	2026-05-06 23:11:15
18191	alex.k.kaczmarczyk@gmail.com	2026-04-05 18:00:01	77	f	2026-05-06 23:11:15
18192	alex.k.kaczmarczyk@gmail.com	2026-04-05 18:10:01	77	f	2026-05-06 23:11:15
18193	alex.k.kaczmarczyk@gmail.com	2026-04-05 18:20:00	81	f	2026-05-06 23:11:15
18194	alex.k.kaczmarczyk@gmail.com	2026-04-05 18:30:01	65	f	2026-05-06 23:11:15
18195	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:30:00	89	f	2026-05-06 23:11:15
18196	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:33:00	97	f	2026-05-06 23:11:15
18198	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:35:00	139	f	2026-05-06 23:11:15
18199	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:36:00	163	f	2026-05-06 23:11:15
18201	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:38:00	119	f	2026-05-06 23:11:15
18202	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:39:00	99	f	2026-05-06 23:11:15
18203	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:40:00	90	f	2026-05-06 23:11:15
18204	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:41:00	86	f	2026-05-06 23:11:15
18205	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:42:00	117	f	2026-05-06 23:11:15
18208	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:42:22	120	f	2026-05-06 23:11:15
18209	alex.k.kaczmarczyk@gmail.com	2026-04-05 19:50:01	146	f	2026-05-06 23:11:15
18210	alex.k.kaczmarczyk@gmail.com	2026-04-05 20:00:01	154	f	2026-05-06 23:11:15
18211	alex.k.kaczmarczyk@gmail.com	2026-04-05 20:10:01	115	f	2026-05-06 23:11:15
18212	alex.k.kaczmarczyk@gmail.com	2026-04-05 20:20:01	125	f	2026-05-06 23:11:15
18213	alex.k.kaczmarczyk@gmail.com	2026-04-05 20:30:01	109	f	2026-05-06 23:11:15
18214	alex.k.kaczmarczyk@gmail.com	2026-04-05 20:40:01	125	f	2026-05-06 23:11:15
18215	alex.k.kaczmarczyk@gmail.com	2026-04-05 20:50:02	99	f	2026-05-06 23:11:15
18216	alex.k.kaczmarczyk@gmail.com	2026-04-05 21:00:01	65	f	2026-05-06 23:11:15
18217	alex.k.kaczmarczyk@gmail.com	2026-04-05 21:10:00	63	t	2026-05-06 23:11:15
18218	alex.k.kaczmarczyk@gmail.com	2026-04-05 21:20:00	66	f	2026-05-06 23:11:15
18219	alex.k.kaczmarczyk@gmail.com	2026-04-05 21:30:01	67	f	2026-05-06 23:11:15
18220	alex.k.kaczmarczyk@gmail.com	2026-04-05 21:40:01	73	f	2026-05-06 23:11:15
18221	alex.k.kaczmarczyk@gmail.com	2026-04-05 21:50:00	73	f	2026-05-06 23:11:15
18222	alex.k.kaczmarczyk@gmail.com	2026-04-05 22:00:00	74	f	2026-05-06 23:11:15
18223	alex.k.kaczmarczyk@gmail.com	2026-04-05 22:10:00	67	f	2026-05-06 23:11:15
18224	alex.k.kaczmarczyk@gmail.com	2026-04-05 22:20:01	81	f	2026-05-06 23:11:15
18225	alex.k.kaczmarczyk@gmail.com	2026-04-05 22:30:01	95	f	2026-05-06 23:11:15
18226	alex.k.kaczmarczyk@gmail.com	2026-04-05 22:40:01	73	f	2026-05-06 23:11:15
18227	alex.k.kaczmarczyk@gmail.com	2026-04-05 22:50:00	77	f	2026-05-06 23:11:15
18228	alex.k.kaczmarczyk@gmail.com	2026-04-05 23:00:01	74	f	2026-05-06 23:11:15
18229	alex.k.kaczmarczyk@gmail.com	2026-04-05 23:10:01	63	t	2026-05-06 23:11:15
18230	alex.k.kaczmarczyk@gmail.com	2026-04-05 23:20:01	67	f	2026-05-06 23:11:15
18231	alex.k.kaczmarczyk@gmail.com	2026-04-05 23:30:00	93	f	2026-05-06 23:11:15
18232	alex.k.kaczmarczyk@gmail.com	2026-04-05 23:40:00	91	f	2026-05-06 23:11:15
18233	alex.k.kaczmarczyk@gmail.com	2026-04-05 23:50:00	65	f	2026-05-06 23:11:15
22666	alex.k.kaczmarczyk@gmail.com	2026-04-30 00:00:09	61	t	2026-05-06 23:11:16
22667	alex.k.kaczmarczyk@gmail.com	2026-04-30 00:10:18	59	t	2026-05-06 23:11:16
22668	alex.k.kaczmarczyk@gmail.com	2026-04-30 00:20:09	57	t	2026-05-06 23:11:16
22669	alex.k.kaczmarczyk@gmail.com	2026-04-30 00:30:09	58	t	2026-05-06 23:11:16
22670	alex.k.kaczmarczyk@gmail.com	2026-04-30 00:40:13	58	t	2026-05-06 23:11:16
22671	alex.k.kaczmarczyk@gmail.com	2026-04-30 00:50:14	55	t	2026-05-06 23:11:16
22672	alex.k.kaczmarczyk@gmail.com	2026-04-30 01:00:09	57	t	2026-05-06 23:11:16
22673	alex.k.kaczmarczyk@gmail.com	2026-04-30 01:10:13	56	t	2026-05-06 23:11:16
22674	alex.k.kaczmarczyk@gmail.com	2026-04-30 01:20:11	52	t	2026-05-06 23:11:16
22675	alex.k.kaczmarczyk@gmail.com	2026-04-30 01:30:12	58	t	2026-05-06 23:11:16
22676	alex.k.kaczmarczyk@gmail.com	2026-04-30 01:40:09	62	t	2026-05-06 23:11:16
22677	alex.k.kaczmarczyk@gmail.com	2026-04-30 01:50:08	55	t	2026-05-06 23:11:16
22678	alex.k.kaczmarczyk@gmail.com	2026-04-30 02:00:08	73	t	2026-05-06 23:11:16
22679	alex.k.kaczmarczyk@gmail.com	2026-04-30 02:10:12	62	t	2026-05-06 23:11:16
22680	alex.k.kaczmarczyk@gmail.com	2026-04-30 02:20:08	54	t	2026-05-06 23:11:16
22681	alex.k.kaczmarczyk@gmail.com	2026-04-30 02:30:08	58	t	2026-05-06 23:11:16
22682	alex.k.kaczmarczyk@gmail.com	2026-04-30 02:40:08	58	t	2026-05-06 23:11:16
22683	alex.k.kaczmarczyk@gmail.com	2026-04-30 02:50:09	58	t	2026-05-06 23:11:16
22684	alex.k.kaczmarczyk@gmail.com	2026-04-30 03:00:08	54	t	2026-05-06 23:11:16
22685	alex.k.kaczmarczyk@gmail.com	2026-04-30 03:10:20	51	t	2026-05-06 23:11:16
22686	alex.k.kaczmarczyk@gmail.com	2026-04-30 03:20:08	55	t	2026-05-06 23:11:16
22687	alex.k.kaczmarczyk@gmail.com	2026-04-30 03:30:10	56	t	2026-05-06 23:11:16
22688	alex.k.kaczmarczyk@gmail.com	2026-04-30 03:40:08	56	t	2026-05-06 23:11:16
22689	alex.k.kaczmarczyk@gmail.com	2026-04-30 03:50:16	53	t	2026-05-06 23:11:16
22690	alex.k.kaczmarczyk@gmail.com	2026-04-30 04:00:09	54	t	2026-05-06 23:11:16
22691	alex.k.kaczmarczyk@gmail.com	2026-04-30 04:10:18	51	t	2026-05-06 23:11:16
22692	alex.k.kaczmarczyk@gmail.com	2026-04-30 04:20:19	51	t	2026-05-06 23:11:16
22693	alex.k.kaczmarczyk@gmail.com	2026-04-30 04:30:19	53	t	2026-05-06 23:11:16
22694	alex.k.kaczmarczyk@gmail.com	2026-04-30 04:40:09	52	t	2026-05-06 23:11:16
22695	alex.k.kaczmarczyk@gmail.com	2026-04-30 04:50:09	51	t	2026-05-06 23:11:16
22696	alex.k.kaczmarczyk@gmail.com	2026-04-30 05:00:19	62	t	2026-05-06 23:11:16
22697	alex.k.kaczmarczyk@gmail.com	2026-04-30 05:10:11	54	t	2026-05-06 23:11:16
22698	alex.k.kaczmarczyk@gmail.com	2026-04-30 05:20:09	57	t	2026-05-06 23:11:16
22699	alex.k.kaczmarczyk@gmail.com	2026-04-30 05:30:21	93	f	2026-05-06 23:11:16
22700	alex.k.kaczmarczyk@gmail.com	2026-04-30 05:40:17	87	f	2026-05-06 23:11:16
22701	alex.k.kaczmarczyk@gmail.com	2026-04-30 06:10:01	94	f	2026-05-06 23:11:16
22702	alex.k.kaczmarczyk@gmail.com	2026-04-30 06:20:01	77	f	2026-05-06 23:11:16
22703	alex.k.kaczmarczyk@gmail.com	2026-04-30 06:30:00	86	f	2026-05-06 23:11:16
22704	alex.k.kaczmarczyk@gmail.com	2026-04-30 06:40:01	81	f	2026-05-06 23:11:16
22705	alex.k.kaczmarczyk@gmail.com	2026-04-30 06:50:01	81	f	2026-05-06 23:11:16
22706	alex.k.kaczmarczyk@gmail.com	2026-04-30 07:00:00	74	f	2026-05-06 23:11:16
22707	alex.k.kaczmarczyk@gmail.com	2026-04-30 07:10:01	88	f	2026-05-06 23:11:16
22708	alex.k.kaczmarczyk@gmail.com	2026-04-30 07:20:01	95	f	2026-05-06 23:11:16
22709	alex.k.kaczmarczyk@gmail.com	2026-04-30 07:30:01	109	f	2026-05-06 23:11:16
22710	alex.k.kaczmarczyk@gmail.com	2026-04-30 07:40:01	84	f	2026-05-06 23:11:16
22711	alex.k.kaczmarczyk@gmail.com	2026-04-30 07:50:02	77	f	2026-05-06 23:11:16
22712	alex.k.kaczmarczyk@gmail.com	2026-04-30 08:00:01	78	f	2026-05-06 23:11:16
22713	alex.k.kaczmarczyk@gmail.com	2026-04-30 08:10:01	64	t	2026-05-06 23:11:16
22714	alex.k.kaczmarczyk@gmail.com	2026-04-30 08:20:01	88	f	2026-05-06 23:11:16
22715	alex.k.kaczmarczyk@gmail.com	2026-04-30 08:30:01	61	t	2026-05-06 23:11:16
22716	alex.k.kaczmarczyk@gmail.com	2026-04-30 08:40:01	65	f	2026-05-06 23:11:16
22717	alex.k.kaczmarczyk@gmail.com	2026-04-30 08:50:01	67	f	2026-05-06 23:11:16
22718	alex.k.kaczmarczyk@gmail.com	2026-04-30 09:00:01	71	f	2026-05-06 23:11:16
22719	alex.k.kaczmarczyk@gmail.com	2026-04-30 09:10:01	94	f	2026-05-06 23:11:16
22720	alex.k.kaczmarczyk@gmail.com	2026-04-30 09:20:01	61	t	2026-05-06 23:11:16
22721	alex.k.kaczmarczyk@gmail.com	2026-04-30 09:30:01	79	f	2026-05-06 23:11:16
22722	alex.k.kaczmarczyk@gmail.com	2026-04-30 09:40:01	59	t	2026-05-06 23:11:16
22723	alex.k.kaczmarczyk@gmail.com	2026-04-30 09:50:00	59	t	2026-05-06 23:11:16
22724	alex.k.kaczmarczyk@gmail.com	2026-04-30 10:00:02	59	t	2026-05-06 23:11:16
22725	alex.k.kaczmarczyk@gmail.com	2026-04-30 10:10:00	67	f	2026-05-06 23:11:16
22726	alex.k.kaczmarczyk@gmail.com	2026-04-30 10:20:01	72	f	2026-05-06 23:11:16
22727	alex.k.kaczmarczyk@gmail.com	2026-04-30 10:30:00	72	f	2026-05-06 23:11:16
22728	alex.k.kaczmarczyk@gmail.com	2026-04-30 10:40:01	58	t	2026-05-06 23:11:16
22729	alex.k.kaczmarczyk@gmail.com	2026-04-30 10:50:01	62	t	2026-05-06 23:11:16
22730	alex.k.kaczmarczyk@gmail.com	2026-04-30 11:00:01	69	f	2026-05-06 23:11:16
22731	alex.k.kaczmarczyk@gmail.com	2026-04-30 11:10:01	58	t	2026-05-06 23:11:16
22732	alex.k.kaczmarczyk@gmail.com	2026-04-30 11:20:01	100	f	2026-05-06 23:11:16
22733	alex.k.kaczmarczyk@gmail.com	2026-04-30 11:30:00	104	f	2026-05-06 23:11:16
22734	alex.k.kaczmarczyk@gmail.com	2026-04-30 11:40:00	108	f	2026-05-06 23:11:16
22735	alex.k.kaczmarczyk@gmail.com	2026-04-30 11:50:00	134	f	2026-05-06 23:11:16
22736	alex.k.kaczmarczyk@gmail.com	2026-04-30 12:00:01	86	f	2026-05-06 23:11:16
22737	alex.k.kaczmarczyk@gmail.com	2026-04-30 12:10:01	98	f	2026-05-06 23:11:16
22738	alex.k.kaczmarczyk@gmail.com	2026-04-30 12:20:01	90	f	2026-05-06 23:11:16
22739	alex.k.kaczmarczyk@gmail.com	2026-04-30 12:30:01	88	f	2026-05-06 23:11:16
22740	alex.k.kaczmarczyk@gmail.com	2026-04-30 12:40:01	69	f	2026-05-06 23:11:16
22741	alex.k.kaczmarczyk@gmail.com	2026-04-30 12:50:02	72	f	2026-05-06 23:11:16
22742	alex.k.kaczmarczyk@gmail.com	2026-04-30 13:00:02	82	f	2026-05-06 23:11:16
22743	alex.k.kaczmarczyk@gmail.com	2026-04-30 13:10:01	82	f	2026-05-06 23:11:16
22744	alex.k.kaczmarczyk@gmail.com	2026-04-30 13:20:01	76	f	2026-05-06 23:11:16
22745	alex.k.kaczmarczyk@gmail.com	2026-04-30 13:30:01	84	f	2026-05-06 23:11:16
22746	alex.k.kaczmarczyk@gmail.com	2026-04-30 13:40:01	72	f	2026-05-06 23:11:16
22747	alex.k.kaczmarczyk@gmail.com	2026-04-30 13:50:01	77	f	2026-05-06 23:11:16
22748	alex.k.kaczmarczyk@gmail.com	2026-04-30 14:00:02	80	f	2026-05-06 23:11:16
22749	alex.k.kaczmarczyk@gmail.com	2026-04-30 14:10:01	72	f	2026-05-06 23:11:16
22750	alex.k.kaczmarczyk@gmail.com	2026-04-30 14:20:02	71	f	2026-05-06 23:11:16
22751	alex.k.kaczmarczyk@gmail.com	2026-04-30 14:30:01	83	f	2026-05-06 23:11:16
22752	alex.k.kaczmarczyk@gmail.com	2026-04-30 14:37:44	72	f	2026-05-06 23:11:16
22753	alex.k.kaczmarczyk@gmail.com	2026-04-30 14:40:01	67	f	2026-05-06 23:11:16
22754	alex.k.kaczmarczyk@gmail.com	2026-04-30 14:50:01	94	f	2026-05-06 23:11:16
22755	alex.k.kaczmarczyk@gmail.com	2026-04-30 15:00:02	68	f	2026-05-06 23:11:16
22756	alex.k.kaczmarczyk@gmail.com	2026-04-30 15:10:01	72	f	2026-05-06 23:11:16
22757	alex.k.kaczmarczyk@gmail.com	2026-04-30 15:18:34	71	f	2026-05-06 23:11:16
22758	alex.k.kaczmarczyk@gmail.com	2026-04-30 15:20:01	79	f	2026-05-06 23:11:16
22759	alex.k.kaczmarczyk@gmail.com	2026-04-30 15:30:01	68	f	2026-05-06 23:11:16
22760	alex.k.kaczmarczyk@gmail.com	2026-04-30 15:40:01	63	t	2026-05-06 23:11:16
22761	alex.k.kaczmarczyk@gmail.com	2026-04-30 15:50:01	70	f	2026-05-06 23:11:16
22762	alex.k.kaczmarczyk@gmail.com	2026-04-30 16:00:02	74	f	2026-05-06 23:11:16
22763	alex.k.kaczmarczyk@gmail.com	2026-04-30 16:10:00	61	t	2026-05-06 23:11:16
22764	alex.k.kaczmarczyk@gmail.com	2026-04-30 16:20:01	71	f	2026-05-06 23:11:16
22765	alex.k.kaczmarczyk@gmail.com	2026-04-30 16:30:01	92	f	2026-05-06 23:11:16
22766	alex.k.kaczmarczyk@gmail.com	2026-04-30 16:40:00	101	f	2026-05-06 23:11:16
22767	alex.k.kaczmarczyk@gmail.com	2026-04-30 16:50:01	83	f	2026-05-06 23:11:16
22768	alex.k.kaczmarczyk@gmail.com	2026-04-30 17:00:01	121	f	2026-05-06 23:11:16
22769	alex.k.kaczmarczyk@gmail.com	2026-04-30 17:10:01	93	f	2026-05-06 23:11:16
22770	alex.k.kaczmarczyk@gmail.com	2026-04-30 17:20:01	107	f	2026-05-06 23:11:16
22771	alex.k.kaczmarczyk@gmail.com	2026-04-30 17:30:01	119	f	2026-05-06 23:11:16
22772	alex.k.kaczmarczyk@gmail.com	2026-04-30 17:40:02	105	f	2026-05-06 23:11:16
22773	alex.k.kaczmarczyk@gmail.com	2026-04-30 17:50:01	97	f	2026-05-06 23:11:16
22774	alex.k.kaczmarczyk@gmail.com	2026-04-30 18:00:02	74	f	2026-05-06 23:11:16
22775	alex.k.kaczmarczyk@gmail.com	2026-04-30 18:10:00	79	f	2026-05-06 23:11:16
22776	alex.k.kaczmarczyk@gmail.com	2026-04-30 18:20:01	105	f	2026-05-06 23:11:16
22777	alex.k.kaczmarczyk@gmail.com	2026-04-30 18:30:00	81	f	2026-05-06 23:11:16
22778	alex.k.kaczmarczyk@gmail.com	2026-04-30 18:40:01	74	f	2026-05-06 23:11:16
22779	alex.k.kaczmarczyk@gmail.com	2026-04-30 18:50:01	67	f	2026-05-06 23:11:16
22780	alex.k.kaczmarczyk@gmail.com	2026-04-30 19:00:01	70	f	2026-05-06 23:11:16
22781	alex.k.kaczmarczyk@gmail.com	2026-04-30 19:10:01	85	f	2026-05-06 23:11:16
22782	alex.k.kaczmarczyk@gmail.com	2026-04-30 19:20:01	92	f	2026-05-06 23:11:16
22783	alex.k.kaczmarczyk@gmail.com	2026-04-30 19:30:02	74	f	2026-05-06 23:11:16
22784	alex.k.kaczmarczyk@gmail.com	2026-04-30 19:40:02	81	f	2026-05-06 23:11:16
22785	alex.k.kaczmarczyk@gmail.com	2026-04-30 19:50:01	90	f	2026-05-06 23:11:16
22786	alex.k.kaczmarczyk@gmail.com	2026-04-30 20:00:01	92	f	2026-05-06 23:11:16
22787	alex.k.kaczmarczyk@gmail.com	2026-04-30 20:10:00	82	f	2026-05-06 23:11:16
22788	alex.k.kaczmarczyk@gmail.com	2026-04-30 20:20:01	99	f	2026-05-06 23:11:16
22789	alex.k.kaczmarczyk@gmail.com	2026-04-30 20:30:00	100	f	2026-05-06 23:11:16
22790	alex.k.kaczmarczyk@gmail.com	2026-04-30 20:40:01	111	f	2026-05-06 23:11:16
22791	alex.k.kaczmarczyk@gmail.com	2026-04-30 20:50:01	95	f	2026-05-06 23:11:16
22792	alex.k.kaczmarczyk@gmail.com	2026-04-30 21:00:01	95	f	2026-05-06 23:11:16
22793	alex.k.kaczmarczyk@gmail.com	2026-04-30 21:10:01	97	f	2026-05-06 23:11:16
22794	alex.k.kaczmarczyk@gmail.com	2026-04-30 21:20:01	80	f	2026-05-06 23:11:16
22795	alex.k.kaczmarczyk@gmail.com	2026-04-30 21:30:01	113	f	2026-05-06 23:11:16
22796	alex.k.kaczmarczyk@gmail.com	2026-04-30 21:40:01	84	f	2026-05-06 23:11:16
22797	alex.k.kaczmarczyk@gmail.com	2026-04-30 21:50:01	88	f	2026-05-06 23:11:16
22798	alex.k.kaczmarczyk@gmail.com	2026-04-30 22:00:01	74	f	2026-05-06 23:11:16
22799	alex.k.kaczmarczyk@gmail.com	2026-04-30 22:10:01	79	f	2026-05-06 23:11:16
22800	alex.k.kaczmarczyk@gmail.com	2026-04-30 22:20:01	88	f	2026-05-06 23:11:16
22801	alex.k.kaczmarczyk@gmail.com	2026-04-30 22:30:01	94	f	2026-05-06 23:11:16
22802	alex.k.kaczmarczyk@gmail.com	2026-04-30 22:40:02	72	f	2026-05-06 23:11:16
22803	alex.k.kaczmarczyk@gmail.com	2026-04-30 22:50:01	70	f	2026-05-06 23:11:16
22804	alex.k.kaczmarczyk@gmail.com	2026-04-30 23:00:02	68	f	2026-05-06 23:11:16
22805	alex.k.kaczmarczyk@gmail.com	2026-04-30 23:10:01	71	f	2026-05-06 23:11:16
22806	alex.k.kaczmarczyk@gmail.com	2026-04-30 23:20:01	65	f	2026-05-06 23:11:16
22807	alex.k.kaczmarczyk@gmail.com	2026-04-30 23:30:01	66	f	2026-05-06 23:11:16
22808	alex.k.kaczmarczyk@gmail.com	2026-04-30 23:40:01	70	f	2026-05-06 23:11:16
22809	alex.k.kaczmarczyk@gmail.com	2026-04-30 23:50:01	95	f	2026-05-06 23:11:16
22810	alex.k.kaczmarczyk@gmail.com	2026-05-01 00:00:01	57	t	2026-05-06 23:11:15
22811	alex.k.kaczmarczyk@gmail.com	2026-05-01 00:10:01	59	t	2026-05-06 23:11:15
22812	alex.k.kaczmarczyk@gmail.com	2026-05-03 23:10:01	72	f	2026-05-06 23:11:15
22813	alex.k.kaczmarczyk@gmail.com	2026-05-03 23:20:02	61	t	2026-05-06 23:11:15
22814	alex.k.kaczmarczyk@gmail.com	2026-05-03 23:30:00	60	t	2026-05-06 23:11:15
22815	alex.k.kaczmarczyk@gmail.com	2026-05-03 23:40:08	60	t	2026-05-06 23:11:15
22816	alex.k.kaczmarczyk@gmail.com	2026-05-03 23:50:08	60	t	2026-05-06 23:11:15
32993	alex.k.kaczmarczyk@gmail.com	2026-05-06 18:30:00	104	f	2026-05-07 11:15:34
32994	alex.k.kaczmarczyk@gmail.com	2026-05-06 18:40:00	100	f	2026-05-07 11:15:34
32995	alex.k.kaczmarczyk@gmail.com	2026-05-06 18:50:01	101	f	2026-05-07 11:15:34
32996	alex.k.kaczmarczyk@gmail.com	2026-05-06 19:00:00	91	f	2026-05-07 11:15:34
32997	alex.k.kaczmarczyk@gmail.com	2026-05-06 19:10:01	87	f	2026-05-07 11:15:34
32998	alex.k.kaczmarczyk@gmail.com	2026-05-06 19:20:01	94	f	2026-05-07 11:15:34
32999	alex.k.kaczmarczyk@gmail.com	2026-05-06 19:30:01	99	f	2026-05-07 11:15:34
33000	alex.k.kaczmarczyk@gmail.com	2026-05-06 19:40:01	109	f	2026-05-07 11:15:34
33001	alex.k.kaczmarczyk@gmail.com	2026-05-06 19:50:00	97	f	2026-05-07 11:15:34
33002	alex.k.kaczmarczyk@gmail.com	2026-05-06 20:00:01	101	f	2026-05-07 11:15:34
33003	alex.k.kaczmarczyk@gmail.com	2026-05-06 20:10:00	98	f	2026-05-07 11:15:34
33004	alex.k.kaczmarczyk@gmail.com	2026-05-06 20:20:00	96	f	2026-05-07 11:15:34
33005	alex.k.kaczmarczyk@gmail.com	2026-05-06 20:30:01	76	f	2026-05-07 11:15:34
33006	alex.k.kaczmarczyk@gmail.com	2026-05-06 20:40:00	90	f	2026-05-07 11:15:34
33007	alex.k.kaczmarczyk@gmail.com	2026-05-06 20:50:01	96	f	2026-05-07 11:15:34
33008	alex.k.kaczmarczyk@gmail.com	2026-05-06 21:00:00	80	f	2026-05-07 11:15:34
33009	alex.k.kaczmarczyk@gmail.com	2026-05-06 21:10:01	76	f	2026-05-07 11:15:34
33010	alex.k.kaczmarczyk@gmail.com	2026-05-06 21:20:01	100	f	2026-05-07 11:15:34
33011	alex.k.kaczmarczyk@gmail.com	2026-05-06 21:30:01	74	f	2026-05-07 11:15:34
33012	alex.k.kaczmarczyk@gmail.com	2026-05-06 21:40:00	75	f	2026-05-07 11:15:34
33013	alex.k.kaczmarczyk@gmail.com	2026-05-06 22:30:00	88	f	2026-05-07 11:15:34
33014	alex.k.kaczmarczyk@gmail.com	2026-05-06 22:40:01	75	f	2026-05-07 11:15:34
33015	alex.k.kaczmarczyk@gmail.com	2026-05-06 22:50:00	75	f	2026-05-07 11:15:34
33016	alex.k.kaczmarczyk@gmail.com	2026-05-06 23:00:00	70	f	2026-05-07 11:15:34
33017	alex.k.kaczmarczyk@gmail.com	2026-05-06 23:10:01	61	t	2026-05-07 11:15:34
33018	alex.k.kaczmarczyk@gmail.com	2026-05-06 23:20:01	59	t	2026-05-07 11:15:34
33019	alex.k.kaczmarczyk@gmail.com	2026-05-06 23:30:09	59	t	2026-05-07 11:15:34
33020	alex.k.kaczmarczyk@gmail.com	2026-05-06 23:40:09	63	t	2026-05-07 11:15:34
33021	alex.k.kaczmarczyk@gmail.com	2026-05-06 23:50:09	58	t	2026-05-07 11:15:34
4324	alex.k.kaczmarczyk@gmail.com	2026-04-29 17:50:00	76	f	2026-04-30 12:10:20
4325	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:00:00	82	f	2026-04-30 12:10:20
4326	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:10:01	75	f	2026-04-30 12:10:20
4327	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:20:01	88	f	2026-04-30 12:10:20
4328	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:30:01	98	f	2026-04-30 12:10:20
4329	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:40:01	99	f	2026-04-30 12:10:20
4330	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:44:00	96	f	2026-04-30 12:10:20
4331	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:45:00	92	f	2026-04-30 12:10:20
4332	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:46:00	92	f	2026-04-30 12:10:20
4334	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:48:00	103	f	2026-04-30 12:10:20
4336	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:50:00	86	f	2026-04-30 12:10:20
4337	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:51:00	92	f	2026-04-30 12:10:20
4338	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:52:00	102	f	2026-04-30 12:10:20
4339	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:53:00	86	f	2026-04-30 12:10:20
4341	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:54:00	129	f	2026-04-30 12:10:20
4342	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:56:00	115	f	2026-04-30 12:10:20
4343	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:57:00	121	f	2026-04-30 12:10:20
4344	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:58:00	126	f	2026-04-30 12:10:20
4345	alex.k.kaczmarczyk@gmail.com	2026-04-29 18:59:00	100	f	2026-04-30 12:10:20
4346	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:00:00	101	f	2026-04-30 12:10:20
4347	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:01:00	117	f	2026-04-30 12:10:20
4348	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:02:00	102	f	2026-04-30 12:10:20
4349	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:03:00	103	f	2026-04-30 12:10:20
4350	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:04:00	115	f	2026-04-30 12:10:20
4351	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:05:00	109	f	2026-04-30 12:10:20
4353	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:06:00	103	f	2026-04-30 12:10:20
4354	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:08:00	101	f	2026-04-30 12:10:20
4356	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:10:00	102	f	2026-04-30 12:10:20
4357	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:11:00	111	f	2026-04-30 12:10:20
4358	alex.k.kaczmarczyk@gmail.com	2026-04-29 19:12:00	123	f	2026-04-30 12:10:20
\.


--
-- Data for Name: oxygen_saturation; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.oxygen_saturation (id, user_id, measured_at, spo2_percent, created_at) FROM stdin;
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.password_reset_tokens (id, user_id, token, expires_at, used, created_at) FROM stdin;
\.


--
-- Data for Name: processed_drive_files; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.processed_drive_files (drive_file_id, user_id, file_name, processed_at) FROM stdin;
1gRE1Z-AmsC3wKRfrCNUjwNQweR312_1L	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.29 Samsung Health.csv	2026-04-30 13:07:25.649236
11KF2xiEB6WTFW_qS2EkoM4aNbmwnF5Nd	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.28 Samsung Health.csv	2026-04-30 13:07:25.65214
1oRqts8mI6iZOQqZAAO3JIBVTgYYKBmJA	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.27 Samsung Health.csv	2026-04-30 13:07:25.653473
1gL2pdtyuT2BDOrHsrHoNXjzutlNQu8JW	alex.k.kaczmarczyk@gmail.com	Schritte 17-2026 Samsung Health.csv	2026-04-30 13:07:25.654935
1yGpdSMY-U8dme_DY2jxYA47yeCK0LlB2	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.26 Samsung Health.csv	2026-04-30 13:07:25.656412
1nhYuc8-deQPGvU6gF7GN_QnB0Bgiyspx	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.25 Samsung Health.csv	2026-04-30 13:07:25.657758
1_sALunG5DUXZKSGUo_ZwS64nVE2evLb2	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.24 Samsung Health.csv	2026-04-30 13:07:25.659498
1SM9F5d3Z4woEvb_FXQXTCG4E-m8VE1aW	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.23 Samsung Health.csv	2026-04-30 13:07:25.661214
1DulZm24GjUCUfbUukw2tpP8h9nKGCysD	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.22 Samsung Health.csv	2026-04-30 13:07:25.662685
1MJYSfdFi6RwIKuc5XZCEkGD-Zk_P6vxM	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.21 Samsung Health.csv	2026-04-30 13:07:25.66379
10LbUZPbLoM396gtFQe_zejxvrFJyit5k	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.20 Samsung Health.csv	2026-04-30 13:07:25.66478
1PkK8Y_s-a7NaGuPoR3r53V3Phu-szS9q	alex.k.kaczmarczyk@gmail.com	Schritte 16-2026 Samsung Health.csv	2026-04-30 13:07:25.665846
1ARhLTN0G8_EN_D9nE9bVM67kJujQW0jM	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.19 Samsung Health.csv	2026-04-30 13:07:25.666797
188dKre8pQZDPDoLW3p_4LgCLuzZtssG7	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.18 Samsung Health.csv	2026-04-30 13:07:25.667788
11qItYFzvXRSGORuGgAOsv9LhgTGwmi7t	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.17 Samsung Health.csv	2026-04-30 13:07:25.66911
1WismjKLc_5KQoUuGfGDx5HvKhMS6bNp7	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.16 Samsung Health.csv	2026-04-30 13:07:25.670205
1tJnP-_-_FhGQKaqcbuJM4TsanVlQU1bg	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.15 Samsung Health.csv	2026-04-30 13:07:25.671547
1euTrE51Iczbrzeq8b4hBtF0hiBttUWLw	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.14 Samsung Health.csv	2026-04-30 13:07:25.672729
1uBM9pZMsynB_BWDHOJ6CbQY3wiRZuTbl	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.13 Samsung Health.csv	2026-04-30 13:07:25.673692
1wHalJJLwAqeVWlhZjzB6M9DyPcuIM5d_	alex.k.kaczmarczyk@gmail.com	Schritte 15-2026 Samsung Health.csv	2026-04-30 13:07:25.674826
1toKZ33W82JwkseLBuCmbeN31ZorW0JCb	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.12 Samsung Health.csv	2026-04-30 13:07:25.676093
1hCnCVzUOSWs0OwZtIjocOmSQr-KAyI2d	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.11 Samsung Health.csv	2026-04-30 13:07:25.677179
125eEZEcVpQsEUS4CR8XpmjsWbk4HIPd4	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.10 Samsung Health.csv	2026-04-30 13:07:25.678627
1DT0bStPmn4P8YssggzztOk6HUqRk4AUL	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.09 Samsung Health.csv	2026-04-30 13:07:25.679754
1L5_OUJw-8HeqmiNSv9KqklV9HqIE1LG9	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.29 22:35:26 Samsung Health.csv	2026-04-30 13:07:25.680709
1RjNon3BlLgVuDddVzt4RuEQT9-GoMRF6	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.23 07:16:58 Samsung Health.csv	2026-04-30 13:07:25.681809
1XA8yxWHe-K6_YyQQcxkDG_R7JTa2Hevt	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.22 22:56:34 Samsung Health.csv	2026-04-30 13:07:25.682945
1_b--YXoseH-QRVq_14ImtttnJL4MiVMG	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.22 17:14:45 Samsung Health.csv	2026-04-30 13:07:25.683905
1fva2rOSLwOHfFhumGnZJQ0tfQREzZwrc	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.20 23:38:43 Samsung Health.csv	2026-04-30 13:07:25.685148
1viyoDi2E2KejOQonLFeaRoML-X5p6Ulr	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.13 23:19:36 Samsung Health.csv	2026-04-30 13:07:25.686389
19b-FHCXMvSTz1QOy0OsFv9IFl-qxF2hB	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.12 23:32:20 Samsung Health.csv	2026-04-30 13:07:25.687511
1rDn1ucaX6sL7OqenGQgnE4MGb6CMaQa8	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.11 22:56:15 Samsung Health.csv	2026-04-30 13:07:25.688699
10Bl58FpiXJEtjxclwqI2b_0nZHDEtrVS	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.04.10 00:56:35 Samsung Health.csv	2026-04-30 13:07:25.689805
103mjfCG2XppIb7TFDHNMGVSqxC9mC8Y3	alex.k.kaczmarczyk@gmail.com	TRAINING 2026.04.29 18.42 Samsung Health.csv	2026-04-30 13:07:25.690728
1X3Y0iEAnvlO3ckOLPecNDlI_UBhelSTB	alex.k.kaczmarczyk@gmail.com	TRAINING 2026.04.25 19.43 Samsung Health.csv	2026-04-30 13:07:25.691801
1RARkkOfZnwcN1H39f1PpreIJVvxZ6cXJ	alex.k.kaczmarczyk@gmail.com	WALKING 2026.04.17 20.12 Samsung Health.csv	2026-04-30 13:07:25.693135
1hRtnBP8-A2nS3mKk555OD1E2WAH1qOJp	alex.k.kaczmarczyk@gmail.com	WALKING 2026.04.17 19.28 Samsung Health.csv	2026-04-30 13:07:25.694212
1THjNqXYqyoaGA1JdZgcYFu1h_a74V5IG	alex.k.kaczmarczyk@gmail.com	WALKING 2026.04.17 17.02 Samsung Health.csv	2026-04-30 13:07:25.695486
1hfy37l0LmGJzWKj_noJ3AsJezHCl25lz	alex.k.kaczmarczyk@gmail.com	WALKING 2026.04.16 17.42 Samsung Health.csv	2026-04-30 13:07:25.696616
1ckEcwAFG8fw_y5il5Jw8A5qZ__b5J5QL	alex.k.kaczmarczyk@gmail.com	WALKING 2026.04.15 20.04 Samsung Health.csv	2026-04-30 13:07:25.697651
1y6mnHQNWtaZTBEa9fLmAtX8MzZwjCgAd	alex.k.kaczmarczyk@gmail.com	WALKING 2026.04.15 18.10 Samsung Health.csv	2026-04-30 13:07:25.698703
16LvxC0w32qqx9SGagOiIIx6YfaDZOWAu	alex.k.kaczmarczyk@gmail.com	TRAINING 2026.04.10 17.19 Samsung Health.csv	2026-04-30 13:07:25.6997
1ySA7YeMRcVQAmNNjjPn59QbSKA6OEw7F	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.29 Samsung Health.csv	2026-04-30 13:07:25.700705
16iEH_6Jse-JEyr-MckttStzJlWHzGELZ	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.28 Samsung Health.csv	2026-04-30 13:07:25.701865
1rWlsOMHpa1pKBvVFmLSpU0GgPct-gEiL	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.27 Samsung Health.csv	2026-04-30 13:07:25.703117
1YNI3kOOGZFUtd5lL5J_cMQ9Q_AgD63i0	alex.k.kaczmarczyk@gmail.com	Puls 17-2026 Samsung Health.csv	2026-04-30 13:07:25.704216
1CLLjapwtLtuhjWPPK2mxOFdtIHcHPfv8	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.24 Samsung Health.csv	2026-04-30 13:07:25.705363
1RF1g0XcTkVQPnkml8Hs0iOneVpSZeMbe	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.23 Samsung Health.csv	2026-04-30 13:07:25.706463
13i-cMAjIGMlKJiEkhBGNksuhxnPQ1mjr	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.22 Samsung Health.csv	2026-04-30 13:07:25.707511
1ykJWlWH5EaHdjWEAGLLJw9Q6u-r3IDVx	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.21 Samsung Health.csv	2026-04-30 13:07:25.708524
1QnIi-3kZby6uwav6SnO8F-QZWpNpVvmq	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.20 Samsung Health.csv	2026-04-30 13:07:25.709754
1HRyQRpe5k4BXArvK5cLljl4aLlTBOQlI	alex.k.kaczmarczyk@gmail.com	Puls 16-2026 Samsung Health.csv	2026-04-30 13:07:25.710962
1rwEK5EC1bxZWKnrw7AKoio-SUUSU_IeN	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.13 Samsung Health.csv	2026-04-30 13:07:25.712092
1bmkXWlF6TouwUN2OCax59Zmr97GTV6Of	alex.k.kaczmarczyk@gmail.com	Puls 15-2026 Samsung Health.csv	2026-04-30 13:07:25.714308
1bU12Mm_4fpMwxK2WiPl-CVDXHNkEMYIf	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.12 Samsung Health.csv	2026-04-30 13:07:25.7157
1vDrL_7Memwbfkc4O28eFskztv18h1hPU	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.11 Samsung Health.csv	2026-04-30 13:07:25.716848
1JfD4KYZM0KPFpfTKFZ_1IBV_hPZ-_nh7	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.10 Samsung Health.csv	2026-04-30 13:07:25.718073
11qvfL1LXcWcVsiHeQqDnDr2iKzsD6_PY	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.09 Samsung Health.csv	2026-04-30 13:07:25.719822
1auh_r_sMRPLNinyycCObqnJVvECUdACm	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.06 Samsung Health.csv	2026-05-07 11:28:53.42937
1E6yP-xj9nYyKBsTASdUfwIS2x8oRKXXc	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.05 Samsung Health.csv	2026-05-07 11:28:53.432644
1QCWnhKHrnJchYwC9hvvMbDyfeS_RmzG-	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.04 Samsung Health.csv	2026-05-07 11:28:53.434271
1AFiEFxko_ANsOKjLnJ3EMH9WDdyRE_br	alex.k.kaczmarczyk@gmail.com	Schritte 18-2026 Samsung Health.csv	2026-05-07 11:28:53.435959
1aVE0Edh48FRvPwAfcWnzUgqsSy3UNi8W	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.03 Samsung Health.csv	2026-05-07 11:28:53.437782
11lj72bYyPTuwn0WbuN9NTxxDRDtep2w4	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.02 Samsung Health.csv	2026-05-07 11:28:53.439928
1smPrWgxItfLguiS_TDrxuSh4TMrcm0JM	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.01 Samsung Health.csv	2026-05-07 11:28:53.441278
1azfeXvWYZpuSafiBorHNCkMNpYy6D6Bo	alex.k.kaczmarczyk@gmail.com	Schritte April 2026 Samsung Health.csv	2026-05-07 11:28:53.442621
1az9ipg0EravjUObWBL2q7Ppc-qG7Nf5P	alex.k.kaczmarczyk@gmail.com	Schritte 2026.04.30 Samsung Health.csv	2026-05-07 11:28:53.443888
1piWtMDmbIElkS8VqLhrYIV3gYduqM8BC	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.05.07 05:43:39 Samsung Health.csv	2026-05-07 11:28:53.445133
13d8QXIP9yWPIFqa8jt0As1q4vcUhAf9Y	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.05.06 23:06:58 Samsung Health.csv	2026-05-07 11:28:53.446501
1lUKPkcop_jqIb5f5xTZwYzk-OvzXt1FP	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.05.03 23:21:49 Samsung Health.csv	2026-05-07 11:28:53.447744
1ey0AxQ3OuuwKk8wZx_PZDBxzQnYXd5-8	alex.k.kaczmarczyk@gmail.com	TRAINING 2026.05.04 20.05 Samsung Health.csv	2026-05-07 11:28:53.448998
19DdZObFuXQwAvOpuzId0zDjo8ErUfoa1	alex.k.kaczmarczyk@gmail.com	Puls 2026.05.06 Samsung Health.csv	2026-05-07 11:28:53.450365
1YYVODK8rSRzvdOlEYAYgjHDI_1NZ0wxa	alex.k.kaczmarczyk@gmail.com	Puls 18-2026 Samsung Health.csv	2026-05-07 11:28:53.451473
1nD9LN-6ZYu73knAzy7hNQUiPMiTkfCBP	alex.k.kaczmarczyk@gmail.com	Puls 2026.05.03 Samsung Health.csv	2026-05-07 11:28:53.452892
1_WPM4X2b5ZMTFcRh9Y_wf4RX20QhL_Oa	alex.k.kaczmarczyk@gmail.com	Puls April 2026 Samsung Health.csv	2026-05-07 11:28:53.454318
1BAEaYEPYHrrvCkjiKAiDZV9OxhS-f5mP	alex.k.kaczmarczyk@gmail.com	Puls 2026.04.30 Samsung Health.csv	2026-05-07 11:28:53.455659
163Xv_i_K78mEeSO6vlawhZwBDR6bEch8	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.06 Samsung Health.csv	2026-05-07 12:34:22.221775
1nWzS9Lsk4eAwsan1tsp6sdvdF3Y4JIrw	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.03 Samsung Health.csv	2026-05-07 12:34:22.223707
1w6srR3e2H9IZIzGRNBcpT3wiBW0O06s-	alex.k.kaczmarczyk@gmail.com	Schritte April 2026 Samsung Health.csv	2026-05-07 12:34:22.22509
1k_efXr10YtIsNIGCMvS4dNrt7tR-xIJx	alex.k.kaczmarczyk@gmail.com	Schritte 2026.05.01 Samsung Health.csv	2026-05-07 12:34:22.226634
1o9bfmLroghxO0EorrlzvTi9xUshcMq8G	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.05.06 00:00:00 Samsung Health.csv	2026-05-07 12:34:22.228059
1_os9D_Iezhh1OHGb9oYZY0z5QnX6UNsD	alex.k.kaczmarczyk@gmail.com	Schlaf 2026.05.03 00:00:00 Samsung Health.csv	2026-05-07 12:34:22.229534
1mEIl9izHogez5g1bPty3dfgrX3sjN6Zu	alex.k.kaczmarczyk@gmail.com	Puls 2026.05.06 Samsung Health.csv	2026-05-07 12:34:22.230902
1fjhO4Ck_CdbIzyXVW0KKMHE7o8u3MEQh	alex.k.kaczmarczyk@gmail.com	Puls 2026.05.03 Samsung Health.csv	2026-05-07 12:34:22.232397
1JEJTXRQuUO8B14-yxk3FZAHOx5fY_9yK	alex.k.kaczmarczyk@gmail.com	Puls April 2026 Samsung Health.csv	2026-05-07 12:34:22.233611
1lRssh9RCkPUta-ZAYpNPYOnSemKZ0hel	alex.k.kaczmarczyk@gmail.com	Puls 2026.05.01 Samsung Health.csv	2026-05-07 12:34:22.234781
\.


--
-- Data for Name: sleep_sessions; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.sleep_sessions (id, user_id, start_time, end_time, total_sleep_minutes, deep_minutes, light_minutes, rem_minutes, awake_minutes, sleep_quality_score, created_at, updated_at) FROM stdin;
1	alex.k.kaczmarczyk@gmail.com	2026-04-10 00:56:35	2026-04-10 09:03:35	437	18	412	7	50	45	2026-04-30 12:10:20	2026-04-30 12:10:20
2	alex.k.kaczmarczyk@gmail.com	2026-04-11 22:56:15	2026-04-12 06:50:15	434	60	325	49	40	70	2026-04-30 12:10:20	2026-04-30 12:10:20
3	alex.k.kaczmarczyk@gmail.com	2026-04-12 23:32:20	2026-04-13 05:43:20	334	16	299	19	37	35	2026-04-30 12:10:20	2026-04-30 12:10:20
4	alex.k.kaczmarczyk@gmail.com	2026-04-13 23:19:36	2026-04-14 06:55:36	413	39	326	48	43	55	2026-04-30 12:10:20	2026-04-30 12:10:20
5	alex.k.kaczmarczyk@gmail.com	2026-04-20 23:38:43	2026-04-21 06:41:43	369	11	345	13	54	35	2026-04-30 12:10:20	2026-04-30 12:10:20
6	alex.k.kaczmarczyk@gmail.com	2026-04-22 22:56:34	2026-04-23 06:55:34	429	54	301	74	50	70	2026-04-30 12:10:20	2026-04-30 12:10:20
7	alex.k.kaczmarczyk@gmail.com	2026-04-23 07:16:58	2026-04-23 08:39:58	72	0	46	26	11	25	2026-04-30 12:10:20	2026-04-30 12:10:20
8	alex.k.kaczmarczyk@gmail.com	2026-04-29 22:35:26	2026-04-30 05:19:26	365	30	298	37	39	55	2026-04-30 12:10:20	2026-04-30 12:10:20
41	alex.k.kaczmarczyk@gmail.com	2026-05-03 23:21:49	2026-05-04 05:42:49	354	12	322	20	27	35	2026-05-06 22:55:52	2026-05-06 22:55:52
69	alex.k.kaczmarczyk@gmail.com	2026-05-06 23:06:58	2026-05-07 05:33:58	360	31	326	3	27	50	2026-05-07 11:15:34	2026-05-07 11:15:34
70	alex.k.kaczmarczyk@gmail.com	2026-05-07 05:43:39	2026-05-07 07:18:39	88	0	88	0	7	20	2026-05-07 11:15:34	2026-05-07 11:15:34
\.


--
-- Data for Name: step_records; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.step_records (id, user_id, recorded_at, steps, distance_meters, calories, walking_speed, created_at) FROM stdin;
1	alex.k.kaczmarczyk@gmail.com	2026-04-06 00:00:00	2997	\N	\N	\N	2026-04-30 12:10:20
2	alex.k.kaczmarczyk@gmail.com	2026-04-07 00:00:00	11369	\N	\N	\N	2026-04-30 12:10:20
3	alex.k.kaczmarczyk@gmail.com	2026-04-08 00:00:00	9503	\N	\N	\N	2026-04-30 12:10:20
4	alex.k.kaczmarczyk@gmail.com	2026-04-09 00:00:00	11304	\N	\N	\N	2026-04-30 12:10:21
5	alex.k.kaczmarczyk@gmail.com	2026-04-10 00:00:00	8538	\N	\N	\N	2026-04-30 12:10:21
6	alex.k.kaczmarczyk@gmail.com	2026-04-11 00:00:00	13094	\N	\N	\N	2026-04-30 12:10:21
7	alex.k.kaczmarczyk@gmail.com	2026-04-12 00:00:00	5695	\N	\N	\N	2026-04-30 12:10:21
8	alex.k.kaczmarczyk@gmail.com	2026-04-13 00:00:00	10102	\N	\N	\N	2026-04-30 12:10:21
9	alex.k.kaczmarczyk@gmail.com	2026-04-14 00:00:00	12079	\N	\N	\N	2026-04-30 12:10:21
10	alex.k.kaczmarczyk@gmail.com	2026-04-15 00:00:00	5866	\N	\N	\N	2026-04-30 12:10:21
11	alex.k.kaczmarczyk@gmail.com	2026-04-16 00:00:00	8014	\N	\N	\N	2026-04-30 12:10:21
12	alex.k.kaczmarczyk@gmail.com	2026-04-17 00:00:00	9863	\N	\N	\N	2026-04-30 12:10:21
13	alex.k.kaczmarczyk@gmail.com	2026-04-18 00:00:00	9476	\N	\N	\N	2026-04-30 12:10:21
14	alex.k.kaczmarczyk@gmail.com	2026-04-19 00:00:00	4282	\N	\N	\N	2026-04-30 12:10:21
15	alex.k.kaczmarczyk@gmail.com	2026-04-20 00:00:00	8963	\N	\N	\N	2026-04-30 12:10:21
16	alex.k.kaczmarczyk@gmail.com	2026-04-21 00:00:00	12985	\N	\N	\N	2026-04-30 12:10:21
17	alex.k.kaczmarczyk@gmail.com	2026-04-22 00:00:00	7502	\N	\N	\N	2026-04-30 12:10:21
18	alex.k.kaczmarczyk@gmail.com	2026-04-23 00:00:00	5291	\N	\N	\N	2026-04-30 12:10:21
19	alex.k.kaczmarczyk@gmail.com	2026-04-24 00:00:00	8984	\N	\N	\N	2026-04-30 12:10:21
20	alex.k.kaczmarczyk@gmail.com	2026-04-25 00:00:00	11057	\N	\N	\N	2026-04-30 12:10:21
21	alex.k.kaczmarczyk@gmail.com	2026-04-26 00:00:00	8604	\N	\N	\N	2026-04-30 12:10:21
22	alex.k.kaczmarczyk@gmail.com	2026-04-27 00:00:00	10248	\N	\N	\N	2026-04-30 12:10:21
23	alex.k.kaczmarczyk@gmail.com	2026-04-28 00:00:00	8481	\N	\N	\N	2026-04-30 12:10:21
24	alex.k.kaczmarczyk@gmail.com	2026-04-29 00:00:00	12557	\N	\N	\N	2026-04-30 12:10:21
97	alex.k.kaczmarczyk@gmail.com	2026-04-01 00:00:00	6276	\N	\N	\N	2026-05-06 22:55:52
122	alex.k.kaczmarczyk@gmail.com	2026-04-30 00:00:00	18278	\N	\N	\N	2026-05-06 22:55:52
123	alex.k.kaczmarczyk@gmail.com	2026-05-01 00:00:00	6068	\N	\N	\N	2026-05-06 22:55:52
124	alex.k.kaczmarczyk@gmail.com	2026-05-02 00:00:00	8636	\N	\N	\N	2026-05-06 22:55:52
125	alex.k.kaczmarczyk@gmail.com	2026-05-03 00:00:00	3519	\N	\N	\N	2026-05-06 22:55:52
126	alex.k.kaczmarczyk@gmail.com	2026-05-04 00:00:00	13946	\N	\N	\N	2026-05-06 22:55:52
127	alex.k.kaczmarczyk@gmail.com	2026-05-05 00:00:00	4732	\N	\N	\N	2026-05-06 22:55:52
221	alex.k.kaczmarczyk@gmail.com	2026-05-06 00:00:00	7752	\N	\N	\N	2026-05-07 11:15:35
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: healthsync_user
--

COPY public.users (uid, first_name, last_name, email, password_hash, created_at) FROM stdin;
1	Alex	Kaczmarczyk	alex.k.kaczmarczyk@gmail.com	$2b$12$rCeelTl0/C.wXhqc2gh5v.hzdRq27epV8BT1Wzmw4Qp9US88nVD62	2026-05-06 22:50:14.300727
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.activities_id_seq', 179, true);


--
-- Name: health_tips_id_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.health_tips_id_seq', 26, true);


--
-- Name: heart_rate_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.heart_rate_records_id_seq', 140478, true);


--
-- Name: oxygen_saturation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.oxygen_saturation_id_seq', 1, false);


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.password_reset_tokens_id_seq', 1, false);


--
-- Name: sleep_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.sleep_sessions_id_seq', 284, true);


--
-- Name: step_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.step_records_id_seq', 844, true);


--
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: healthsync_user
--

SELECT pg_catalog.setval('public.users_uid_seq', 1, true);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: activities activities_user_id_start_time_key; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_user_id_start_time_key UNIQUE NULLS NOT DISTINCT (user_id, start_time);


--
-- Name: health_tips health_tips_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.health_tips
    ADD CONSTRAINT health_tips_pkey PRIMARY KEY (id);


--
-- Name: heart_rate_records heart_rate_records_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.heart_rate_records
    ADD CONSTRAINT heart_rate_records_pkey PRIMARY KEY (id);


--
-- Name: heart_rate_records heart_rate_records_user_id_measured_at_key; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.heart_rate_records
    ADD CONSTRAINT heart_rate_records_user_id_measured_at_key UNIQUE (user_id, measured_at);


--
-- Name: oxygen_saturation oxygen_saturation_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.oxygen_saturation
    ADD CONSTRAINT oxygen_saturation_pkey PRIMARY KEY (id);


--
-- Name: oxygen_saturation oxygen_saturation_user_id_measured_at_key; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.oxygen_saturation
    ADD CONSTRAINT oxygen_saturation_user_id_measured_at_key UNIQUE (user_id, measured_at);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_token_key UNIQUE (token);


--
-- Name: processed_drive_files processed_drive_files_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.processed_drive_files
    ADD CONSTRAINT processed_drive_files_pkey PRIMARY KEY (drive_file_id);


--
-- Name: sleep_sessions sleep_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.sleep_sessions
    ADD CONSTRAINT sleep_sessions_pkey PRIMARY KEY (id);


--
-- Name: sleep_sessions sleep_sessions_user_id_start_time_key; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.sleep_sessions
    ADD CONSTRAINT sleep_sessions_user_id_start_time_key UNIQUE (user_id, start_time);


--
-- Name: step_records step_records_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.step_records
    ADD CONSTRAINT step_records_pkey PRIMARY KEY (id);


--
-- Name: step_records step_records_user_id_recorded_at_key; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.step_records
    ADD CONSTRAINT step_records_user_id_recorded_at_key UNIQUE NULLS NOT DISTINCT (user_id, recorded_at);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: healthsync_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO healthsync_user;


--
-- PostgreSQL database dump complete
--

\unrestrict t30EeIcC8P5U1A22HVTD26iTOWbNMPgfp52IDZ6H5se6gl4sMbNavxrCJ0Aweqh

