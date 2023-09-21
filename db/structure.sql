--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4 (Debian 15.4-2.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Homebrew)

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
-- Name: turns; Type: TABLE; Schema: public; Owner: crystal
--

CREATE TABLE public.turns (
    id bigint NOT NULL,
    game_id character varying(254) NOT NULL,
    snake_id character varying(254) NOT NULL,
    context text NOT NULL,
    path character varying(254) NOT NULL,
    dead boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.turns OWNER TO crystal;

--
-- Name: turns_id_seq; Type: SEQUENCE; Schema: public; Owner: crystal
--

CREATE SEQUENCE public.turns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.turns_id_seq OWNER TO crystal;

--
-- Name: turns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: crystal
--

ALTER SEQUENCE public.turns_id_seq OWNED BY public.turns.id;


--
-- Name: turns id; Type: DEFAULT; Schema: public; Owner: crystal
--

ALTER TABLE ONLY public.turns ALTER COLUMN id SET DEFAULT nextval('public.turns_id_seq'::regclass);


--
-- Name: turns turns_pkey; Type: CONSTRAINT; Schema: public; Owner: crystal
--

ALTER TABLE ONLY public.turns
    ADD CONSTRAINT turns_pkey PRIMARY KEY (id);


--
-- Name: turns_game_id_idx; Type: INDEX; Schema: public; Owner: crystal
--

CREATE INDEX turns_game_id_idx ON public.turns USING btree (game_id);


--
-- Name: turns_path_idx; Type: INDEX; Schema: public; Owner: crystal
--

CREATE INDEX turns_path_idx ON public.turns USING btree (path);


--
-- PostgreSQL database dump complete
--

