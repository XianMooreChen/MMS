--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.9
-- Dumped by pg_dump version 9.5.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: get_hex_ascii(character varying); Type: FUNCTION; Schema: public; Owner: swbatch
--

CREATE FUNCTION get_hex_ascii(parsing_field character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
declare result_str varchar(200);
  temp_str varchar(200);
  ii integer;
begin
  FOR ii IN 1..length(parsing_field) LOOP
  	temp_str = to_hex(ASCII(substr(parsing_field, ii, 1)));
  	result_str = concat(result_str, temp_str);
  end loop;
  return lower(result_str);
end;
$$;


ALTER FUNCTION public.get_hex_ascii(parsing_field character varying) OWNER TO swbatch;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bank_host; Type: TABLE; Schema: public; Owner: swbatch
--

CREATE TABLE bank_host (
    bank_id text NOT NULL,
    host_ip text NOT NULL,
    host_port text NOT NULL,
    host_ip_sed text,
    host_port_sed text,
    bank_name character varying(20),
    conn_status_ip character varying(10),
    conn_status_port character varying(10)
);


ALTER TABLE bank_host OWNER TO swbatch;

--
-- Name: bank_info_setting; Type: TABLE; Schema: public; Owner: swbatch
--

CREATE TABLE bank_info_setting (
    id character varying(50) NOT NULL,
    bank_id character varying(50),
    activate character varying(1),
    criteria character varying(100),
    conditions character varying(10),
    condition_count character varying(10),
    action_des character varying(200),
    bank_name character varying(20),
    show_time_start character varying(10),
    show_time_end character varying(10)
);


ALTER TABLE bank_info_setting OWNER TO swbatch;

--
-- Name: bank_iso_setting; Type: TABLE; Schema: public; Owner: swbatch
--

CREATE TABLE bank_iso_setting (
    id character varying(50) NOT NULL,
    field_name character varying(10) NOT NULL,
    field_length integer NOT NULL,
    length_type character varying(50) NOT NULL,
    data_type character varying(50) NOT NULL,
    fill_type character varying(50) NOT NULL,
    align_type character varying(50) NOT NULL,
    is_to_ascii character(1)
);


ALTER TABLE bank_iso_setting OWNER TO swbatch;

--
-- Name: COLUMN bank_iso_setting.id; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN bank_iso_setting.id IS 'bank info id';


--
-- Name: COLUMN bank_iso_setting.field_name; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN bank_iso_setting.field_name IS 'iso8583 field example:F1 F2...';


--
-- Name: COLUMN bank_iso_setting.field_length; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN bank_iso_setting.field_length IS 'iso8583 field length example:64 19...';


--
-- Name: COLUMN bank_iso_setting.length_type; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN bank_iso_setting.length_type IS 'iso8583 field length type limit ISOLFIX ISOLV2 ISOLV3';


--
-- Name: COLUMN bank_iso_setting.data_type; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN bank_iso_setting.data_type IS 'iso8583 field data type limit ISODEBC ISODBIN ISODBCD ISODC_D ISODASC';


--
-- Name: COLUMN bank_iso_setting.fill_type; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN bank_iso_setting.fill_type IS 'iso8583 field align type limit ISORJUST ISOLJUST';


--
-- Name: COLUMN bank_iso_setting.is_to_ascii; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN bank_iso_setting.is_to_ascii IS 'Y means yes and the other means No';


--
-- Name: message_data; Type: TABLE; Schema: public; Owner: swbatch
--

CREATE TABLE message_data (
    id uuid NOT NULL,
    create_time timestamp with time zone NOT NULL,
    request_data text,
    origin_addr text,
    request8583 bytea,
    response8583 bytea,
    response_data text,
    request_data_byte text,
    response_data_byte text,
    stage integer,
    update_time timestamp without time zone
);


ALTER TABLE message_data OWNER TO swbatch;

--
-- Name: mms_transaction_history; Type: TABLE; Schema: public; Owner: swbatch
--

CREATE TABLE mms_transaction_history (
    id character varying(48) NOT NULL,
    tpdu_nii_1 character varying(8),
    tpdu_nii_2 character varying(8),
    fm_message_id character varying(8),
    f3_processing_code character varying(12),
    f4_amount numeric(18,0),
    f11_stan character varying(12),
    f22_pos_entry_mode character varying(8),
    f24_nii character varying(8),
    f25_pos_cond_code character varying(4),
    f41_tid character varying(16),
    f42_mid character varying(30),
    request_date timestamp without time zone,
    response_date timestamp without time zone,
    parent_id character varying(48) DEFAULT NULL::character varying,
    fm_response_message_id character varying(8),
    bank_id character varying(8),
    f2_card_number character varying(20),
    f3_response_pc character varying(12),
    f39_response_code character varying(4),
    f63_bit_63 character varying(100),
    f63_sale_num numeric(5,0),
    f63_sale_amount numeric(18,0),
    f63_refund_num numeric(5,0),
    f63_refund_amount numeric(18,0),
    f35_card_number character varying(100),
    f35_track_2_data character varying(100),
    tpdu_message_id character varying(4),
    f52_pin character varying(40),
    f55_bit_55 character varying(1000),
    f62_bit_62 character varying(1000),
    f37_rrn character varying(24),
    f38_auth_id_response character varying(12),
    f60_batch character varying(1000),
    f12_time character varying(12),
    f13_date character varying(8),
    f14_card_expiry_date character varying(8),
    f57_encryp_data character varying(1000),
    f58_signature_data character varying(1000),
    f64_mac character varying(40),
    f48_inquiry_data character varying(1000),
    f23_pan_seq_num character varying(8)
);


ALTER TABLE mms_transaction_history OWNER TO swbatch;

--
-- Name: parsing_request_data; Type: TABLE; Schema: public; Owner: swbatch
--

CREATE TABLE parsing_request_data (
    id character varying(48) NOT NULL,
    tpdu_message_id character varying(4),
    tpdu_nii_1 character varying(8),
    tpdu_nii_2 character varying(8),
    fm_message_id character varying(8),
    f2 character varying(38),
    f3 character varying(12),
    f4 character varying(24),
    f5 character varying(24),
    f6 character varying(24),
    f7 character varying(20),
    f8 character varying(16),
    f9 character varying(16),
    f10 character varying(16),
    f11 character varying(12),
    f12 character varying(12),
    f13 character varying(8),
    f14 character varying(8),
    f15 character varying(8),
    f16 character varying(8),
    f17 character varying(8),
    f18 character varying(8),
    f19 character varying(6),
    f20 character varying(6),
    f21 character varying(6),
    f22 character varying(8),
    f23 character varying(8),
    f24 character varying(8),
    f25 character varying(4),
    f26 character varying(4),
    f27 character varying(2),
    f28 character varying(16),
    f29 character varying(16),
    f30 character varying(16),
    f31 character varying(16),
    f32 character varying(200),
    f33 character varying(200),
    f34 character varying(200),
    f35 character varying(200),
    f36 character varying(2000),
    f37 character varying(24),
    f38 character varying(12),
    f39 character varying(4),
    f40 character varying(6),
    f41 character varying(16),
    f42 character varying(30),
    f43 character varying(80),
    f44 character varying(200),
    f45 character varying(200),
    f46 character varying(2000),
    f47 character varying(2000),
    f48 character varying(2000),
    f49 character varying(6),
    f50 character varying(6),
    f51 character varying(6),
    f52 character varying(128),
    f53 character varying(32),
    f54 character varying(200),
    f55 character varying(2000),
    f56 character varying(2000),
    f57 character varying(2000),
    f58 character varying(2000),
    f59 character varying(2000),
    f60 character varying(2000),
    f61 character varying(2000),
    f62 character varying(2000),
    f63 character varying(2000),
    f64 character varying(128),
    request_date timestamp without time zone,
    parsing_flag integer
);


ALTER TABLE parsing_request_data OWNER TO swbatch;

--
-- Name: COLUMN parsing_request_data.parsing_flag; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN parsing_request_data.parsing_flag IS '0 parsing failure, 1 parsing success, 2 iso undefined, 3 save failure';


--
-- Name: parsing_response_data; Type: TABLE; Schema: public; Owner: swbatch
--

CREATE TABLE parsing_response_data (
    id character varying(48) NOT NULL,
    tpdu_message_id character varying(4),
    tpdu_nii_1 character varying(8),
    tpdu_nii_2 character varying(8),
    fm_message_id character varying(8),
    f2 character varying(38),
    f3 character varying(12),
    f4 character varying(24),
    f5 character varying(24),
    f6 character varying(24),
    f7 character varying(20),
    f8 character varying(16),
    f9 character varying(16),
    f10 character varying(16),
    f11 character varying(12),
    f12 character varying(12),
    f13 character varying(8),
    f14 character varying(8),
    f15 character varying(8),
    f16 character varying(8),
    f17 character varying(8),
    f18 character varying(8),
    f19 character varying(6),
    f20 character varying(6),
    f21 character varying(6),
    f22 character varying(8),
    f23 character varying(8),
    f24 character varying(8),
    f25 character varying(4),
    f26 character varying(4),
    f27 character varying(2),
    f28 character varying(16),
    f29 character varying(16),
    f30 character varying(16),
    f31 character varying(16),
    f32 character varying(200),
    f33 character varying(200),
    f34 character varying(200),
    f35 character varying(200),
    f36 character varying(2000),
    f37 character varying(24),
    f38 character varying(12),
    f39 character varying(4),
    f40 character varying(6),
    f41 character varying(16),
    f42 character varying(30),
    f43 character varying(80),
    f44 character varying(200),
    f45 character varying(200),
    f46 character varying(2000),
    f47 character varying(2000),
    f48 character varying(2000),
    f49 character varying(6),
    f50 character varying(6),
    f51 character varying(6),
    f52 character varying(128),
    f53 character varying(32),
    f54 character varying(200),
    f55 character varying(2000),
    f56 character varying(2000),
    f57 character varying(2000),
    f58 character varying(2000),
    f59 character varying(2000),
    f60 character varying(2000),
    f61 character varying(2000),
    f62 character varying(2000),
    f63 character varying(2000),
    f64 character varying(128),
    response_date timestamp without time zone,
    parsing_flag integer
);


ALTER TABLE parsing_response_data OWNER TO swbatch;

--
-- Name: COLUMN parsing_response_data.parsing_flag; Type: COMMENT; Schema: public; Owner: swbatch
--

COMMENT ON COLUMN parsing_response_data.parsing_flag IS '0 parsing failure, 1 parsing success, 2 iso undefined, 3 save failure';


--
-- Data for Name: bank_host; Type: TABLE DATA; Schema: public; Owner: swbatch
--

COPY bank_host (bank_id, host_ip, host_port, host_ip_sed, host_port_sed, bank_name, conn_status_ip, conn_status_port) FROM stdin;
\.


--
-- Data for Name: bank_info_setting; Type: TABLE DATA; Schema: public; Owner: swbatch
--

COPY bank_info_setting (id, bank_id, activate, criteria, conditions, condition_count, action_des, bank_name, show_time_start, show_time_end) FROM stdin;
\.


--
-- Data for Name: bank_iso_setting; Type: TABLE DATA; Schema: public; Owner: swbatch
--

COPY bank_iso_setting (id, field_name, field_length, length_type, data_type, fill_type, align_type, is_to_ascii) FROM stdin;
\.


--
-- Data for Name: message_data; Type: TABLE DATA; Schema: public; Owner: swbatch
--

COPY message_data (id, create_time, request_data, origin_addr, request8583, response8583, response_data, request_data_byte, response_data_byte, stage, update_time) FROM stdin;
\.


--
-- Data for Name: mms_transaction_history; Type: TABLE DATA; Schema: public; Owner: swbatch
--

COPY mms_transaction_history (id, tpdu_nii_1, tpdu_nii_2, fm_message_id, f3_processing_code, f4_amount, f11_stan, f22_pos_entry_mode, f24_nii, f25_pos_cond_code, f41_tid, f42_mid, request_date, response_date, parent_id, fm_response_message_id, bank_id, f2_card_number, f3_response_pc, f39_response_code, f63_bit_63, f63_sale_num, f63_sale_amount, f63_refund_num, f63_refund_amount, f35_card_number, f35_track_2_data, tpdu_message_id, f52_pin, f55_bit_55, f62_bit_62, f37_rrn, f38_auth_id_response, f60_batch, f12_time, f13_date, f14_card_expiry_date, f57_encryp_data, f58_signature_data, f64_mac, f48_inquiry_data, f23_pan_seq_num) FROM stdin;
\.


--
-- Data for Name: parsing_request_data; Type: TABLE DATA; Schema: public; Owner: swbatch
--

COPY parsing_request_data (id, tpdu_message_id, tpdu_nii_1, tpdu_nii_2, fm_message_id, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21, f22, f23, f24, f25, f26, f27, f28, f29, f30, f31, f32, f33, f34, f35, f36, f37, f38, f39, f40, f41, f42, f43, f44, f45, f46, f47, f48, f49, f50, f51, f52, f53, f54, f55, f56, f57, f58, f59, f60, f61, f62, f63, f64, request_date, parsing_flag) FROM stdin;
\.


--
-- Data for Name: parsing_response_data; Type: TABLE DATA; Schema: public; Owner: swbatch
--

COPY parsing_response_data (id, tpdu_message_id, tpdu_nii_1, tpdu_nii_2, fm_message_id, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21, f22, f23, f24, f25, f26, f27, f28, f29, f30, f31, f32, f33, f34, f35, f36, f37, f38, f39, f40, f41, f42, f43, f44, f45, f46, f47, f48, f49, f50, f51, f52, f53, f54, f55, f56, f57, f58, f59, f60, f61, f62, f63, f64, response_date, parsing_flag) FROM stdin;
\.


--
-- Name: bank_host_pkey; Type: CONSTRAINT; Schema: public; Owner: swbatch
--

ALTER TABLE ONLY bank_host
    ADD CONSTRAINT bank_host_pkey PRIMARY KEY (bank_id);


--
-- Name: bank_info_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: swbatch
--

ALTER TABLE ONLY bank_info_setting
    ADD CONSTRAINT bank_info_setting_pkey PRIMARY KEY (id);


--
-- Name: bank_iso_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: swbatch
--

ALTER TABLE ONLY bank_iso_setting
    ADD CONSTRAINT bank_iso_setting_pkey PRIMARY KEY (id, field_name);


--
-- Name: message_data_pkey; Type: CONSTRAINT; Schema: public; Owner: swbatch
--

ALTER TABLE ONLY message_data
    ADD CONSTRAINT message_data_pkey PRIMARY KEY (id);


--
-- Name: pk_mms_transaction_history; Type: CONSTRAINT; Schema: public; Owner: swbatch
--

ALTER TABLE ONLY mms_transaction_history
    ADD CONSTRAINT pk_mms_transaction_history PRIMARY KEY (id);


--
-- Name: pk_parsing_request_data; Type: CONSTRAINT; Schema: public; Owner: swbatch
--

ALTER TABLE ONLY parsing_request_data
    ADD CONSTRAINT pk_parsing_request_data PRIMARY KEY (id);


--
-- Name: pk_parsing_response_data; Type: CONSTRAINT; Schema: public; Owner: swbatch
--

ALTER TABLE ONLY parsing_response_data
    ADD CONSTRAINT pk_parsing_response_data PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

