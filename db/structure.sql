--
-- PostgreSQL database dump
--

-- Dumped from database version 14.6 (Homebrew)
-- Dumped by pg_dump version 14.6 (Homebrew)

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
-- Name: migration_versions; Type: TABLE; Schema: public; Owner: crystal
--

CREATE TABLE public.migration_versions (
    version character varying(17) NOT NULL
);


ALTER TABLE public.migration_versions OWNER TO crystal;

--
-- Name: records; Type: TABLE; Schema: public; Owner: crystal
--

CREATE TABLE public.records (
    id bigint NOT NULL,
    game_id character varying(254) NOT NULL,
    context jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.records OWNER TO crystal;

--
-- Name: records_id_seq; Type: SEQUENCE; Schema: public; Owner: crystal
--

CREATE SEQUENCE public.records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.records_id_seq OWNER TO crystal;

--
-- Name: records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crystal
--

ALTER SEQUENCE public.records_id_seq OWNED BY public.records.id;


--
-- Name: records id; Type: DEFAULT; Schema: public; Owner: crystal
--

ALTER TABLE ONLY public.records ALTER COLUMN id SET DEFAULT nextval('public.records_id_seq'::regclass);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: public; Owner: crystal
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (id);


--
-- Name: records_game_id_idx; Type: INDEX; Schema: public; Owner: crystal
--

CREATE INDEX records_game_id_idx ON public.records USING btree (game_id);


--
-- PostgreSQL database dump complete
--

