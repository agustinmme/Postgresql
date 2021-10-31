--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-10-31 20:18:30

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
-- TOC entry 210 (class 1255 OID 16472)
-- Name: lend_book(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lend_book() RETURNS integer
    LANGUAGE sql
    AS $$SELECT COUNT(*) FROM lend$$;


ALTER FUNCTION public.lend_book() OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 16463)
-- Name: return_book(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.return_book(dni_usuario character varying, id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN
delete 
from lend 
where dni = dni_usuario and id_book = id;
END;

$$;


ALTER FUNCTION public.return_book(dni_usuario character varying, id integer) OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 16470)
-- Name: update_triggers_lend(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_triggers_lend() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO lend_log(dni,id_book,_date)
VALUES(OLD.dni,OLD.id_book,NOW());
RETURN OLD;
END;
$$;


ALTER FUNCTION public.update_triggers_lend() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 16400)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id_book integer NOT NULL,
    name character varying(60) NOT NULL,
    author character varying(60) NOT NULL,
    publisher character varying(100) NOT NULL,
    year_published date NOT NULL,
    isbn integer NOT NULL
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16398)
-- Name: books_id_book_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_book_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_id_book_seq OWNER TO postgres;

--
-- TOC entry 3030 (class 0 OID 0)
-- Dependencies: 200
-- Name: books_id_book_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_book_seq OWNED BY public.books.id_book;


--
-- TOC entry 205 (class 1259 OID 16440)
-- Name: lend; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lend (
    id_lend integer NOT NULL,
    dni character varying(30) NOT NULL,
    id_book integer NOT NULL
);


ALTER TABLE public.lend OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16438)
-- Name: lend_id_book_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lend_id_book_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lend_id_book_seq OWNER TO postgres;

--
-- TOC entry 3031 (class 0 OID 0)
-- Dependencies: 204
-- Name: lend_id_book_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lend_id_book_seq OWNED BY public.lend.id_book;


--
-- TOC entry 203 (class 1259 OID 16436)
-- Name: lend_id_lend_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lend_id_lend_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lend_id_lend_seq OWNER TO postgres;

--
-- TOC entry 3032 (class 0 OID 0)
-- Dependencies: 203
-- Name: lend_id_lend_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lend_id_lend_seq OWNED BY public.lend.id_lend;


--
-- TOC entry 207 (class 1259 OID 16464)
-- Name: lend_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lend_log (
    dni character varying(30),
    id_book integer,
    _date timestamp without time zone
);


ALTER TABLE public.lend_log OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16406)
-- Name: readers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.readers (
    dni character varying(30) NOT NULL,
    name character varying(30) NOT NULL,
    surname character varying(30) NOT NULL,
    email character varying(60) NOT NULL,
    date_birth character varying(30) NOT NULL
);


ALTER TABLE public.readers OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16457)
-- Name: view_user_alonso; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_user_alonso AS
 SELECT r.name AS name_reader,
    b.name AS name_book,
    b.publisher,
    b.isbn
   FROM ((public.readers r
     JOIN public.lend l ON (((r.dni)::text = (l.dni)::text)))
     JOIN public.books b ON ((l.id_book = b.id_book)))
  WHERE (((r.name)::text = 'Pedro'::text) AND ((r.surname)::text = 'Alonso'::text));


ALTER TABLE public.view_user_alonso OWNER TO postgres;

--
-- TOC entry 2873 (class 2604 OID 16403)
-- Name: books id_book; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id_book SET DEFAULT nextval('public.books_id_book_seq'::regclass);


--
-- TOC entry 2874 (class 2604 OID 16443)
-- Name: lend id_lend; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lend ALTER COLUMN id_lend SET DEFAULT nextval('public.lend_id_lend_seq'::regclass);


--
-- TOC entry 2875 (class 2604 OID 16444)
-- Name: lend id_book; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lend ALTER COLUMN id_book SET DEFAULT nextval('public.lend_id_book_seq'::regclass);


--
-- TOC entry 3019 (class 0 OID 16400)
-- Dependencies: 201
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (id_book, name, author, publisher, year_published, isbn) FROM stdin;
10	Cementerio de animales	Stephen King	Ediciones de Mente	1975-08-24	4568874
1	En el nombre de la rosa	Umberto Eco	Editorial España	1975-08-24	44558877
2	Cien años de soledad	Gabriel García Márquez	Sudamericana	1975-08-24	7788845
3	El diario de Ellen Rimbauer	Stephen King	Editorial Maine	1975-08-24	45699874
4	La hojarasca	Gabriel García Márquez	Sudamericana	1975-08-24	7787898
5	El amor en los tiempos del cólera	Gabriel García Márquez	Sudamericana	1975-08-24	2564111
6	La casa de los espíritus	Isabel Allende	Ediciones Chile	1975-08-24	5544781
7	Paula	Isabel Allende	Ediciones chile	1975-08-24	22545447
8	La tregua	Mario Benedetti	Alfa	1975-08-24	2225412
9	Gracias por el fuego	Mario Benedetti	Alfa	1975-08-24	88541254
\.


--
-- TOC entry 3023 (class 0 OID 16440)
-- Dependencies: 205
-- Data for Name: lend; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lend (id_lend, dni, id_book) FROM stdin;
6	41651423	1
11	4342313	1
12	4342313	2
13	4342313	3
14	4342313	4
15	4342313	5
17	43422132	2
18	43422132	3
19	43422132	4
20	43422132	5
21	43422111	5
22	43422111	6
23	43422111	7
24	43422122	8
25	43422122	1
26	43422122	2
27	42121122	3
28	42121122	4
29	42121122	5
30	42442122	6
31	43332132	8
\.


--
-- TOC entry 3024 (class 0 OID 16464)
-- Dependencies: 207
-- Data for Name: lend_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lend_log (dni, id_book, _date) FROM stdin;
40145625	2	2021-09-21 12:04:44.705754
40145625	4	2021-09-21 12:09:56.334002
43422132	1	2021-09-21 12:09:56.334002
\.


--
-- TOC entry 3020 (class 0 OID 16406)
-- Dependencies: 202
-- Data for Name: readers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.readers (dni, name, surname, email, date_birth) FROM stdin;
40145625	Juan Alberto	Cortéz	juancortez@gmail.com	20/06/1983
41651423	Antonia	de los Ríos	antoniarios_23@yahoo.com	24/11/1978
4342313	Nicolás	Martin	nico_martin23@gmail.com	11/07/1986
43422132	Néstor	Casco	nestor_casco2331@hotmmail.com	11/02/1981
43422111	Lisa	Pérez	lisperez@hotmail.com	11/08/1994
43422122	Ana Rosa	Estagnolli	anros@abcdatos.com	15/10/1974
42121122	Milagros	Pastoruti	mili_2231@gmail.com	22/01/2001
42442122	Pedro	Alonso	alonso.pedro@impermebilizantesrosario.com	05/09/1983
43332132	Arturo Ezequiel	Ramírez	artu.rama@outlook.com	29/03/1998
4341132	Juan Ignacio	Altarez	juanaltarez.223@yahoo.com	24/08/1975
\.


--
-- TOC entry 3033 (class 0 OID 0)
-- Dependencies: 200
-- Name: books_id_book_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_book_seq', 9, true);


--
-- TOC entry 3034 (class 0 OID 0)
-- Dependencies: 204
-- Name: lend_id_book_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lend_id_book_seq', 1, false);


--
-- TOC entry 3035 (class 0 OID 0)
-- Dependencies: 203
-- Name: lend_id_lend_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lend_id_lend_seq', 31, true);


--
-- TOC entry 2877 (class 2606 OID 16405)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id_book);


--
-- TOC entry 2883 (class 2606 OID 16446)
-- Name: lend lend_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lend
    ADD CONSTRAINT lend_pkey PRIMARY KEY (id_lend);


--
-- TOC entry 2879 (class 2606 OID 16414)
-- Name: readers readers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.readers
    ADD CONSTRAINT readers_email_key UNIQUE (email);


--
-- TOC entry 2881 (class 2606 OID 16410)
-- Name: readers readers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.readers
    ADD CONSTRAINT readers_pkey PRIMARY KEY (dni);


--
-- TOC entry 2886 (class 2620 OID 16471)
-- Name: lend update_triggers_lend; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_triggers_lend AFTER DELETE ON public.lend FOR EACH ROW EXECUTE FUNCTION public.update_triggers_lend();


--
-- TOC entry 2884 (class 2606 OID 16447)
-- Name: lend lend_dni_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lend
    ADD CONSTRAINT lend_dni_fkey FOREIGN KEY (dni) REFERENCES public.readers(dni);


--
-- TOC entry 2885 (class 2606 OID 16452)
-- Name: lend lend_id_book_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lend
    ADD CONSTRAINT lend_id_book_fkey FOREIGN KEY (id_book) REFERENCES public.books(id_book);


-- Completed on 2021-10-31 20:18:31

--
-- PostgreSQL database dump complete
--

