SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: auctions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auctions (
    id bigint NOT NULL,
    virtual_footballer_id integer NOT NULL,
    virtual_round_id integer NOT NULL,
    processed boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: auctions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auctions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auctions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auctions_id_seq OWNED BY auctions.id;


--
-- Name: bids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bids (
    id bigint NOT NULL,
    auction_id integer NOT NULL,
    bidder_virtual_club_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    amount double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    dropped_virtual_footballer_id integer
);


--
-- Name: bids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bids_id_seq OWNED BY bids.id;


--
-- Name: chats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE chats (
    id integer NOT NULL,
    content text NOT NULL,
    league_id integer NOT NULL,
    virtual_club_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: chats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chats_id_seq OWNED BY chats.id;


--
-- Name: clubs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clubs (
    id integer NOT NULL,
    u_id integer NOT NULL,
    original_u_id character varying NOT NULL,
    city character varying,
    name character varying NOT NULL,
    short_club_name character varying NOT NULL,
    abbreviation character varying,
    region_name character varying,
    street character varying,
    web_address character varying,
    postal_code character varying,
    founded integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    official_club_name character varying
);


--
-- Name: clubs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clubs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clubs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clubs_id_seq OWNED BY clubs.id;


--
-- Name: clubs_seasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clubs_seasons (
    id integer NOT NULL,
    club_id integer NOT NULL,
    season_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: clubs_seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clubs_seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clubs_seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clubs_seasons_id_seq OWNED BY clubs_seasons.id;


--
-- Name: crest_patterns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE crest_patterns (
    id integer NOT NULL,
    name character varying,
    crest_shape_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    svg_uid character varying NOT NULL
);


--
-- Name: crest_patterns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE crest_patterns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crest_patterns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE crest_patterns_id_seq OWNED BY crest_patterns.id;


--
-- Name: crest_shapes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE crest_shapes (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    svg_uid character varying NOT NULL
);


--
-- Name: crest_shapes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE crest_shapes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crest_shapes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE crest_shapes_id_seq OWNED BY crest_shapes.id;


--
-- Name: draft_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE draft_histories (
    id integer NOT NULL,
    iteration integer NOT NULL,
    step integer NOT NULL,
    league_id integer NOT NULL,
    virtual_club_id integer NOT NULL,
    virtual_footballer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    job_id character varying
);


--
-- Name: draft_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE draft_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draft_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE draft_histories_id_seq OWNED BY draft_histories.id;


--
-- Name: draft_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE draft_orders (
    id integer NOT NULL,
    current_iteration integer NOT NULL,
    current_step integer NOT NULL,
    league_id integer NOT NULL,
    queue jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: draft_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE draft_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draft_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE draft_orders_id_seq OWNED BY draft_orders.id;


--
-- Name: engagements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE engagements (
    id integer NOT NULL,
    footballer_id integer NOT NULL,
    club_id integer NOT NULL,
    season_id integer NOT NULL,
    join_date timestamp without time zone,
    leave_date timestamp without time zone,
    real_position character varying NOT NULL,
    real_position_side character varying NOT NULL,
    jersey_num integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    loan boolean DEFAULT false
);


--
-- Name: engagements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE engagements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: engagements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE engagements_id_seq OWNED BY engagements.id;


--
-- Name: fixtures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fixtures (
    id integer NOT NULL,
    u_id integer NOT NULL,
    original_u_id character varying NOT NULL,
    season_id integer NOT NULL,
    last_modified timestamp without time zone NOT NULL,
    detail_id integer NOT NULL,
    match_day timestamp without time zone,
    match_type character varying NOT NULL,
    period character varying NOT NULL,
    venue_id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    home_club_id integer NOT NULL,
    away_club_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    round_id integer,
    postponed character varying
);


--
-- Name: fixtures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fixtures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fixtures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fixtures_id_seq OWNED BY fixtures.id;


--
-- Name: fixtures_match_officials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fixtures_match_officials (
    id integer NOT NULL,
    fixture_id integer NOT NULL,
    match_official_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    o_type character varying
);


--
-- Name: fixtures_match_officials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fixtures_match_officials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fixtures_match_officials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fixtures_match_officials_id_seq OWNED BY fixtures_match_officials.id;


--
-- Name: footballers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE footballers (
    id integer NOT NULL,
    u_id integer NOT NULL,
    original_u_id character varying NOT NULL,
    first_name character varying NOT NULL,
    middle_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying NOT NULL,
    name character varying NOT NULL,
    known_name character varying,
    display_name character varying,
    birth_date timestamp without time zone,
    birth_place character varying,
    first_nationality character varying,
    preferred_foot character varying,
    weight integer NOT NULL,
    height integer NOT NULL,
    country character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" character varying,
    rank integer DEFAULT 2048,
    rating numeric DEFAULT 10,
    current_club_id integer,
    "left" boolean DEFAULT false,
    running_fixture_id integer
);


--
-- Name: footballers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE footballers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footballers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE footballers_id_seq OWNED BY footballers.id;


--
-- Name: formations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE formations (
    id integer NOT NULL,
    league_id integer NOT NULL,
    name character varying NOT NULL,
    allowed boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_formation CHECK (((name)::text = ANY (ARRAY[('f442'::character varying)::text, ('f433'::character varying)::text, ('f451'::character varying)::text, ('f352'::character varying)::text, ('f343'::character varying)::text, ('f541'::character varying)::text, ('f532'::character varying)::text])))
);


--
-- Name: formations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE formations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: formations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE formations_id_seq OWNED BY formations.id;


--
-- Name: game_weeks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE game_weeks (
    id integer NOT NULL,
    virtual_club_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    virtual_round_id integer,
    formation_id integer,
    parent_id integer,
    auto_sub_on boolean DEFAULT false
);


--
-- Name: game_weeks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE game_weeks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_weeks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE game_weeks_id_seq OWNED BY game_weeks.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invitations (
    id integer NOT NULL,
    league_id integer NOT NULL,
    email character varying NOT NULL,
    status character varying DEFAULT 'waiting'::character varying NOT NULL,
    reminder_time timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_status CHECK (((status)::text = ANY (ARRAY[('waiting'::character varying)::text, ('accepted'::character varying)::text, ('rejected'::character varying)::text])))
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: leagues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE leagues (
    id integer NOT NULL,
    starting_round integer NOT NULL,
    required_teams integer NOT NULL,
    match_numbers integer NOT NULL,
    season_id integer NOT NULL,
    user_id integer NOT NULL,
    waiver_auction_day timestamp without time zone,
    invite_code character varying NOT NULL,
    title character varying NOT NULL,
    bonus_per_draw integer DEFAULT 1,
    bonus_per_win integer DEFAULT 2,
    transfer_budget integer DEFAULT 25,
    chairman_veto boolean DEFAULT true,
    scoring_type character varying DEFAULT 'category'::character varying NOT NULL,
    double_gameweeks boolean DEFAULT false,
    category_scoring_settings jsonb DEFAULT '{"goal": 2, "saves": 1, "assists": 1, "take_ons": 1, "turnovers": 1, "discipline": 1, "key_passes": 1, "net_passes": 1, "possession": 1, "tackles_won": 1, "clean_sheets": 1, "goal_enabled": true, "pass_percent": 1, "interceptions": 1, "saves_enabled": false, "saves_percent": 1, "goals_conceded": 1, "minutes_played": 1, "pass_completed": 0, "assists_enabled": false, "shots_on_target": 1, "take_ons_enabled": false, "turnovers_enabled": false, "discipline_enabled": true, "key_passes_enabled": true, "net_passes_enabled": true, "possession_enabled": false, "tackle_interception": 1, "tackles_won_enabled": true, "clean_sheets_enabled": true, "pass_percent_enabled": false, "goals_conceded_points": 1, "interceptions_enabled": false, "minutes_played_points": 1, "saves_percent_enabled": true, "goals_conceded_enabled": true, "minutes_played_enabled": false, "pass_completed_enabled": true, "shots_on_target_enabled": false, "tackle_interception_enabled": false, "goals_conceded_points_enabled": false, "minutes_played_points_enabled": true}'::jsonb NOT NULL,
    point_scoring_settings jsonb DEFAULT '{"forward": {"goal": 5, "save": 0.0, "cross": 0.0, "assist": 3.0, "key_pass": 1.0, "net_pass": 1.0, "own_goal": -2.0, "take_ons": 0, "passes_40": 1, "passes_50": 2, "passes_60": 3, "red_cards": -5.0, "turn_over": 0.0, "tackle_won": 0.5, "clean_sheet": 0, "manager_win": 0.0, "penalty_won": 0.0, "interception": 0.0, "yellow_cards": -2.0, "goal_conceded": 0, "penalty_saved": 0.0, "played_30_min": 1.0, "played_50_min": 2.0, "played_90_min": 3.0, "chance_created": 0.0, "pass_completed": 0.0, "penalty_missed": -2.0, "shot_on_target": 0, "corner_kick_won": 0.0, "defensive_error": -1.0, "penalty_conceded": -1.0, "big_chance_missed": 0.0}, "defender": {"goal": 6.0, "save": 0.0, "cross": 0.0, "assist": 3.0, "key_pass": 1.0, "net_pass": 1.0, "own_goal": -2.0, "take_ons": 0, "passes_40": 1, "passes_50": 2, "passes_60": 3, "red_cards": -5.0, "turn_over": 0.0, "tackle_won": 0.5, "clean_sheet": 5.0, "manager_win": 0.0, "penalty_won": 0.0, "interception": 0.0, "yellow_cards": -2.0, "goal_conceded": -1.0, "penalty_saved": 0.0, "played_30_min": 1.0, "played_50_min": 2.0, "played_90_min": 3.0, "chance_created": 0.0, "pass_completed": 0.0, "penalty_missed": -2.0, "shot_on_target": 0, "corner_kick_won": 0.0, "defensive_error": -1.0, "penalty_conceded": -1.0, "big_chance_missed": 0.0}, "goalkeeper": {"goal": 6.0, "save": 0.5, "cross": 0.0, "assist": 3.0, "key_pass": 1.0, "net_pass": 1.0, "own_goal": -2.0, "take_ons": 0, "passes_40": 1, "passes_50": 2, "passes_60": 3, "red_cards": -5.0, "turn_over": 0.0, "tackle_won": 0.5, "clean_sheet": 5.0, "manager_win": 0.0, "penalty_won": 0.0, "interception": 0.0, "yellow_cards": -2.0, "goal_conceded": -1.0, "penalty_saved": 2, "played_30_min": 1.0, "played_50_min": 2.0, "played_90_min": 3.0, "chance_created": 0.0, "pass_completed": 0.0, "penalty_missed": -2.0, "shot_on_target": 0, "corner_kick_won": 0.0, "defensive_error": -1.0, "penalty_conceded": -1.0, "big_chance_missed": 0.0}, "midfielder": {"goal": 5, "save": 0.0, "cross": 0.0, "assist": 3.0, "key_pass": 1.0, "net_pass": 1.0, "own_goal": -2.0, "take_ons": 0, "passes_40": 1, "passes_50": 2, "passes_60": 3, "red_cards": -5.0, "turn_over": 0.0, "tackle_won": 0.5, "clean_sheet": 1, "manager_win": 0.0, "penalty_won": 0.0, "interception": 0.0, "yellow_cards": -2.0, "goal_conceded": -0.5, "penalty_saved": 0.0, "played_30_min": 1.0, "played_50_min": 2.0, "played_90_min": 3.0, "chance_created": 0.0, "pass_completed": 0.0, "penalty_missed": -2.0, "shot_on_target": 0, "corner_kick_won": 0.0, "defensive_error": -1.0, "penalty_conceded": -1.0, "big_chance_missed": 0.0}}'::jsonb NOT NULL,
    waiver_auction_process_date timestamp without time zone,
    auto_sub_enabled boolean DEFAULT true,
    min_fee_per_addition integer DEFAULT 1,
    draft_status character varying DEFAULT 'pending'::character varying NOT NULL,
    draft_time timestamp without time zone,
    custom_draft_order boolean DEFAULT false,
    time_per_pick_unit character varying DEFAULT 'seconds'::character varying,
    time_per_pick integer DEFAULT 60,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    transfer_deadline_round_number integer DEFAULT 30,
    league_type character varying DEFAULT 'private'::character varying NOT NULL,
    description character varying,
    customized_scoring boolean DEFAULT false,
    squad_size integer DEFAULT 16,
    fantasy_assist boolean DEFAULT true,
    weight_goals_category boolean DEFAULT false,
    parent_league_id integer,
    CONSTRAINT check_draft_status CHECK (((draft_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('running'::character varying)::text, ('completed'::character varying)::text, ('processing'::character varying)::text]))),
    CONSTRAINT check_scoring_type CHECK (((scoring_type)::text = ANY (ARRAY[('point'::character varying)::text, ('category'::character varying)::text])))
);


--
-- Name: leagues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE leagues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leagues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE leagues_id_seq OWNED BY leagues.id;


--
-- Name: managers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE managers (
    id integer NOT NULL,
    u_id integer NOT NULL,
    original_u_id character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    country character varying NOT NULL,
    birth_day timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: managers_clubs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE managers_clubs (
    id integer NOT NULL,
    club_id integer NOT NULL,
    manager_id integer NOT NULL,
    season_id integer NOT NULL,
    type character varying NOT NULL,
    join_date timestamp without time zone NOT NULL,
    leave_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: managers_clubs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE managers_clubs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: managers_clubs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE managers_clubs_id_seq OWNED BY managers_clubs.id;


--
-- Name: managers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE managers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: managers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE managers_id_seq OWNED BY managers.id;


--
-- Name: match_officials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE match_officials (
    id integer NOT NULL,
    u_id integer NOT NULL,
    original_u_id character varying NOT NULL,
    last_name character varying,
    country character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying
);


--
-- Name: match_officials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE match_officials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: match_officials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE match_officials_id_seq OWNED BY match_officials.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE messages (
    id integer NOT NULL,
    subject character varying NOT NULL,
    body character varying NOT NULL,
    user_id integer NOT NULL,
    league_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
    id bigint NOT NULL,
    league_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    sender_id bigint NOT NULL,
    activity_type character varying NOT NULL,
    object_type character varying NOT NULL,
    object_id character varying NOT NULL,
    content text NOT NULL,
    time_sent timestamp without time zone NOT NULL,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE positions (
    id integer NOT NULL,
    footballer_id integer,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE positions_id_seq OWNED BY positions.id;


--
-- Name: preferred_footballers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE preferred_footballers (
    id integer NOT NULL,
    virtual_club_id integer NOT NULL,
    virtual_footballer_id integer NOT NULL,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: preferred_footballers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE preferred_footballers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: preferred_footballers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE preferred_footballers_id_seq OWNED BY preferred_footballers.id;


--
-- Name: rounds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rounds (
    id integer NOT NULL,
    number integer,
    season_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status integer DEFAULT 0,
    parent_id integer
);


--
-- Name: rounds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rounds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rounds_id_seq OWNED BY rounds.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sdps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sdps (
    id integer NOT NULL,
    amount integer DEFAULT 0,
    footballer_id integer NOT NULL,
    season_id integer NOT NULL
);


--
-- Name: sdps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sdps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sdps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sdps_id_seq OWNED BY sdps.id;


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE seasons (
    id integer NOT NULL,
    u_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    draft_count integer DEFAULT 0
);


--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seasons_id_seq OWNED BY seasons.id;


--
-- Name: stadia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stadia (
    id integer NOT NULL,
    u_id integer NOT NULL,
    original_u_id character varying NOT NULL,
    capacity integer,
    name character varying NOT NULL,
    city character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stadia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stadia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stadia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stadia_id_seq OWNED BY stadia.id;


--
-- Name: statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statistics (
    id integer NOT NULL,
    fixture_id integer NOT NULL,
    footballer_id integer NOT NULL,
    accurate_pass integer DEFAULT 0 NOT NULL,
    total_final_third_passes integer DEFAULT 0 NOT NULL,
    attempts_conceded_ibox integer DEFAULT 0 NOT NULL,
    touches integer DEFAULT 0 NOT NULL,
    total_fwd_zone_pass integer DEFAULT 0 NOT NULL,
    accurate_fwd_zone_pass integer DEFAULT 0 NOT NULL,
    ontarget_scoring_att integer DEFAULT 0 NOT NULL,
    lost_corners integer DEFAULT 0 NOT NULL,
    goals_conceded integer DEFAULT 0 NOT NULL,
    goals integer DEFAULT 0 NOT NULL,
    own_goals integer DEFAULT 0 NOT NULL,
    mins_played integer DEFAULT 0 NOT NULL,
    ontarget_att_assist integer DEFAULT 0 NOT NULL,
    goal_assist integer DEFAULT 0 NOT NULL,
    total_pass integer DEFAULT 0 NOT NULL,
    won_contest integer DEFAULT 0 NOT NULL,
    interception integer DEFAULT 0 NOT NULL,
    turnover integer DEFAULT 0 NOT NULL,
    clean_sheet integer DEFAULT 0 NOT NULL,
    saves integer DEFAULT 0 NOT NULL,
    yellow_card integer DEFAULT 0 NOT NULL,
    red_card integer DEFAULT 0 NOT NULL,
    won_corners integer DEFAULT 0 NOT NULL,
    big_chance_missed integer DEFAULT 0 NOT NULL,
    penalty_save integer DEFAULT 0 NOT NULL,
    penalty_miss integer DEFAULT 0 NOT NULL,
    penalty_conceded integer DEFAULT 0 NOT NULL,
    penalty_won integer DEFAULT 0 NOT NULL,
    error_lead_to_goal integer DEFAULT 0 NOT NULL,
    assist_own_goal integer DEFAULT 0 NOT NULL,
    assist_handball_won integer DEFAULT 0 NOT NULL,
    assist_penalty_won integer DEFAULT 0 NOT NULL,
    assist_post integer DEFAULT 0 NOT NULL,
    assist_attempt_saved integer DEFAULT 0 NOT NULL,
    assist_blocked_shot integer DEFAULT 0 NOT NULL,
    assist_pass_lost integer DEFAULT 0 NOT NULL,
    won_tackle integer DEFAULT 0 NOT NULL,
    full_stat jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sub_on boolean DEFAULT false,
    sub_off boolean DEFAULT false,
    second_yellow integer DEFAULT 0
);


--
-- Name: statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statistics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statistics_id_seq OWNED BY statistics.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    sub_type integer DEFAULT 0 NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: transfer_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transfer_activities (
    id bigint NOT NULL,
    league_id bigint NOT NULL,
    virtual_round_id bigint NOT NULL,
    from_virtual_club_id integer,
    to_virtual_club_id integer,
    virtual_footballer_id bigint NOT NULL,
    auction boolean DEFAULT false,
    amount numeric DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transfer_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfer_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfer_activities_id_seq OWNED BY transfer_activities.id;


--
-- Name: transfer_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transfer_offers (
    id bigint NOT NULL,
    sender_virtual_club_id integer NOT NULL,
    receiver_virtual_club_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    message character varying,
    amount double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transfer_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfer_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfer_offers_id_seq OWNED BY transfer_offers.id;


--
-- Name: transfer_offers_offered_virtual_footballers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transfer_offers_offered_virtual_footballers (
    id bigint NOT NULL,
    transfer_offer_id integer NOT NULL,
    virtual_footballer_id integer NOT NULL
);


--
-- Name: transfer_offers_offered_virtual_footballers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfer_offers_offered_virtual_footballers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_offers_offered_virtual_footballers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfer_offers_offered_virtual_footballers_id_seq OWNED BY transfer_offers_offered_virtual_footballers.id;


--
-- Name: transfer_offers_requested_virtual_footballers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transfer_offers_requested_virtual_footballers (
    id bigint NOT NULL,
    transfer_offer_id integer NOT NULL,
    virtual_footballer_id integer NOT NULL
);


--
-- Name: transfer_offers_requested_virtual_footballers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfer_offers_requested_virtual_footballers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_offers_requested_virtual_footballers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfer_offers_requested_virtual_footballers_id_seq OWNED BY transfer_offers_requested_virtual_footballers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    fname character varying NOT NULL,
    lname character varying NOT NULL,
    full_name character varying,
    provider character varying,
    timeshift integer,
    deleted boolean DEFAULT false,
    prepaid boolean DEFAULT false,
    authentication_token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    braintree_subscription_id character varying,
    braintree_customer_id bigint,
    is_online boolean,
    admin integer DEFAULT 0 NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: virtual_clubs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE virtual_clubs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    league_id integer,
    crest_pattern_id integer NOT NULL,
    name character varying NOT NULL,
    color1 character varying NOT NULL,
    color2 character varying NOT NULL,
    color3 character varying NOT NULL,
    auto_pick boolean DEFAULT false,
    motto character varying,
    abbr character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stadium character varying,
    budget integer DEFAULT 10,
    rank integer DEFAULT 0,
    total_pts integer DEFAULT 0,
    form character varying[] DEFAULT '{}'::character varying[],
    total_win integer DEFAULT 0,
    total_loss integer DEFAULT 0,
    total_draw integer DEFAULT 0,
    total_score integer DEFAULT 0,
    total_gd integer DEFAULT 0
);


--
-- Name: virtual_clubs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE virtual_clubs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_clubs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE virtual_clubs_id_seq OWNED BY virtual_clubs.id;


--
-- Name: virtual_engagements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE virtual_engagements (
    id integer NOT NULL,
    game_week_id integer NOT NULL,
    virtual_footballer_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer DEFAULT 0,
    subbed_id integer
);


--
-- Name: virtual_engagements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE virtual_engagements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_engagements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE virtual_engagements_id_seq OWNED BY virtual_engagements.id;


--
-- Name: virtual_fixtures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE virtual_fixtures (
    id integer NOT NULL,
    virtual_round_id integer NOT NULL,
    home_virtual_club_id integer NOT NULL,
    away_virtual_club_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: virtual_fixtures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE virtual_fixtures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_fixtures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE virtual_fixtures_id_seq OWNED BY virtual_fixtures.id;


--
-- Name: virtual_footballers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE virtual_footballers (
    id integer NOT NULL,
    footballer_id integer NOT NULL,
    league_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    virtual_club_id integer,
    waiver boolean DEFAULT false NOT NULL,
    transferred boolean DEFAULT false,
    total_points numeric(5,1) DEFAULT 0.0
);


--
-- Name: virtual_footballers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE virtual_footballers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_footballers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE virtual_footballers_id_seq OWNED BY virtual_footballers.id;


--
-- Name: virtual_rounds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE virtual_rounds (
    id integer NOT NULL,
    league_id integer NOT NULL,
    round_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: virtual_rounds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE virtual_rounds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_rounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE virtual_rounds_id_seq OWNED BY virtual_rounds.id;


--
-- Name: virtual_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE virtual_scores (
    id bigint NOT NULL,
    virtual_fixture_id bigint NOT NULL,
    home_score double precision,
    away_score double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: virtual_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE virtual_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE virtual_scores_id_seq OWNED BY virtual_scores.id;


--
-- Name: xml_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE xml_files (
    id integer NOT NULL,
    file_uid character varying,
    file_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: xml_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE xml_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xml_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE xml_files_id_seq OWNED BY xml_files.id;


--
-- Name: auctions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auctions ALTER COLUMN id SET DEFAULT nextval('auctions_id_seq'::regclass);


--
-- Name: bids id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bids ALTER COLUMN id SET DEFAULT nextval('bids_id_seq'::regclass);


--
-- Name: chats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chats ALTER COLUMN id SET DEFAULT nextval('chats_id_seq'::regclass);


--
-- Name: clubs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clubs ALTER COLUMN id SET DEFAULT nextval('clubs_id_seq'::regclass);


--
-- Name: clubs_seasons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clubs_seasons ALTER COLUMN id SET DEFAULT nextval('clubs_seasons_id_seq'::regclass);


--
-- Name: crest_patterns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY crest_patterns ALTER COLUMN id SET DEFAULT nextval('crest_patterns_id_seq'::regclass);


--
-- Name: crest_shapes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY crest_shapes ALTER COLUMN id SET DEFAULT nextval('crest_shapes_id_seq'::regclass);


--
-- Name: draft_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_histories ALTER COLUMN id SET DEFAULT nextval('draft_histories_id_seq'::regclass);


--
-- Name: draft_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_orders ALTER COLUMN id SET DEFAULT nextval('draft_orders_id_seq'::regclass);


--
-- Name: engagements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY engagements ALTER COLUMN id SET DEFAULT nextval('engagements_id_seq'::regclass);


--
-- Name: fixtures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures ALTER COLUMN id SET DEFAULT nextval('fixtures_id_seq'::regclass);


--
-- Name: fixtures_match_officials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures_match_officials ALTER COLUMN id SET DEFAULT nextval('fixtures_match_officials_id_seq'::regclass);


--
-- Name: footballers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY footballers ALTER COLUMN id SET DEFAULT nextval('footballers_id_seq'::regclass);


--
-- Name: formations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY formations ALTER COLUMN id SET DEFAULT nextval('formations_id_seq'::regclass);


--
-- Name: game_weeks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_weeks ALTER COLUMN id SET DEFAULT nextval('game_weeks_id_seq'::regclass);


--
-- Name: invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: leagues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues ALTER COLUMN id SET DEFAULT nextval('leagues_id_seq'::regclass);


--
-- Name: managers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers ALTER COLUMN id SET DEFAULT nextval('managers_id_seq'::regclass);


--
-- Name: managers_clubs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers_clubs ALTER COLUMN id SET DEFAULT nextval('managers_clubs_id_seq'::regclass);


--
-- Name: match_officials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY match_officials ALTER COLUMN id SET DEFAULT nextval('match_officials_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY positions ALTER COLUMN id SET DEFAULT nextval('positions_id_seq'::regclass);


--
-- Name: preferred_footballers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY preferred_footballers ALTER COLUMN id SET DEFAULT nextval('preferred_footballers_id_seq'::regclass);


--
-- Name: rounds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rounds ALTER COLUMN id SET DEFAULT nextval('rounds_id_seq'::regclass);


--
-- Name: sdps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sdps ALTER COLUMN id SET DEFAULT nextval('sdps_id_seq'::regclass);


--
-- Name: seasons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons ALTER COLUMN id SET DEFAULT nextval('seasons_id_seq'::regclass);


--
-- Name: stadia id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stadia ALTER COLUMN id SET DEFAULT nextval('stadia_id_seq'::regclass);


--
-- Name: statistics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistics ALTER COLUMN id SET DEFAULT nextval('statistics_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: transfer_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_activities ALTER COLUMN id SET DEFAULT nextval('transfer_activities_id_seq'::regclass);


--
-- Name: transfer_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_offers ALTER COLUMN id SET DEFAULT nextval('transfer_offers_id_seq'::regclass);


--
-- Name: transfer_offers_offered_virtual_footballers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_offers_offered_virtual_footballers ALTER COLUMN id SET DEFAULT nextval('transfer_offers_offered_virtual_footballers_id_seq'::regclass);


--
-- Name: transfer_offers_requested_virtual_footballers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_offers_requested_virtual_footballers ALTER COLUMN id SET DEFAULT nextval('transfer_offers_requested_virtual_footballers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: virtual_clubs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_clubs ALTER COLUMN id SET DEFAULT nextval('virtual_clubs_id_seq'::regclass);


--
-- Name: virtual_engagements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_engagements ALTER COLUMN id SET DEFAULT nextval('virtual_engagements_id_seq'::regclass);


--
-- Name: virtual_fixtures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_fixtures ALTER COLUMN id SET DEFAULT nextval('virtual_fixtures_id_seq'::regclass);


--
-- Name: virtual_footballers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_footballers ALTER COLUMN id SET DEFAULT nextval('virtual_footballers_id_seq'::regclass);


--
-- Name: virtual_rounds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_rounds ALTER COLUMN id SET DEFAULT nextval('virtual_rounds_id_seq'::regclass);


--
-- Name: virtual_scores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_scores ALTER COLUMN id SET DEFAULT nextval('virtual_scores_id_seq'::regclass);


--
-- Name: xml_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY xml_files ALTER COLUMN id SET DEFAULT nextval('xml_files_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: auctions auctions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auctions
    ADD CONSTRAINT auctions_pkey PRIMARY KEY (id);


--
-- Name: bids bids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bids
    ADD CONSTRAINT bids_pkey PRIMARY KEY (id);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: clubs clubs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clubs
    ADD CONSTRAINT clubs_pkey PRIMARY KEY (id);


--
-- Name: clubs_seasons clubs_seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clubs_seasons
    ADD CONSTRAINT clubs_seasons_pkey PRIMARY KEY (id);


--
-- Name: crest_patterns crest_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crest_patterns
    ADD CONSTRAINT crest_patterns_pkey PRIMARY KEY (id);


--
-- Name: crest_shapes crest_shapes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crest_shapes
    ADD CONSTRAINT crest_shapes_pkey PRIMARY KEY (id);


--
-- Name: draft_histories draft_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_histories
    ADD CONSTRAINT draft_histories_pkey PRIMARY KEY (id);


--
-- Name: draft_orders draft_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_orders
    ADD CONSTRAINT draft_orders_pkey PRIMARY KEY (id);


--
-- Name: engagements engagements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY engagements
    ADD CONSTRAINT engagements_pkey PRIMARY KEY (id);


--
-- Name: fixtures_match_officials fixtures_match_officials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures_match_officials
    ADD CONSTRAINT fixtures_match_officials_pkey PRIMARY KEY (id);


--
-- Name: fixtures fixtures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fixtures_pkey PRIMARY KEY (id);


--
-- Name: footballers footballers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY footballers
    ADD CONSTRAINT footballers_pkey PRIMARY KEY (id);


--
-- Name: formations formations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY formations
    ADD CONSTRAINT formations_pkey PRIMARY KEY (id);


--
-- Name: game_weeks game_weeks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_weeks
    ADD CONSTRAINT game_weeks_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: leagues leagues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues
    ADD CONSTRAINT leagues_pkey PRIMARY KEY (id);


--
-- Name: managers_clubs managers_clubs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers_clubs
    ADD CONSTRAINT managers_clubs_pkey PRIMARY KEY (id);


--
-- Name: managers managers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (id);


--
-- Name: match_officials match_officials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY match_officials
    ADD CONSTRAINT match_officials_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: preferred_footballers preferred_footballers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY preferred_footballers
    ADD CONSTRAINT preferred_footballers_pkey PRIMARY KEY (id);


--
-- Name: rounds rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT rounds_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sdps sdps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sdps
    ADD CONSTRAINT sdps_pkey PRIMARY KEY (id);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: stadia stadia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stadia
    ADD CONSTRAINT stadia_pkey PRIMARY KEY (id);


--
-- Name: statistics statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistics
    ADD CONSTRAINT statistics_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: transfer_activities transfer_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_activities
    ADD CONSTRAINT transfer_activities_pkey PRIMARY KEY (id);


--
-- Name: transfer_offers_offered_virtual_footballers transfer_offers_offered_virtual_footballers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_offers_offered_virtual_footballers
    ADD CONSTRAINT transfer_offers_offered_virtual_footballers_pkey PRIMARY KEY (id);


--
-- Name: transfer_offers transfer_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_offers
    ADD CONSTRAINT transfer_offers_pkey PRIMARY KEY (id);


--
-- Name: transfer_offers_requested_virtual_footballers transfer_offers_requested_virtual_footballers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_offers_requested_virtual_footballers
    ADD CONSTRAINT transfer_offers_requested_virtual_footballers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: virtual_clubs virtual_clubs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_clubs
    ADD CONSTRAINT virtual_clubs_pkey PRIMARY KEY (id);


--
-- Name: virtual_engagements virtual_engagements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_engagements
    ADD CONSTRAINT virtual_engagements_pkey PRIMARY KEY (id);


--
-- Name: virtual_fixtures virtual_fixtures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_fixtures
    ADD CONSTRAINT virtual_fixtures_pkey PRIMARY KEY (id);


--
-- Name: virtual_footballers virtual_footballers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_footballers
    ADD CONSTRAINT virtual_footballers_pkey PRIMARY KEY (id);


--
-- Name: virtual_rounds virtual_rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_rounds
    ADD CONSTRAINT virtual_rounds_pkey PRIMARY KEY (id);


--
-- Name: virtual_scores virtual_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_scores
    ADD CONSTRAINT virtual_scores_pkey PRIMARY KEY (id);


--
-- Name: xml_files xml_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY xml_files
    ADD CONSTRAINT xml_files_pkey PRIMARY KEY (id);


--
-- Name: index_auctions_on_virtual_footballer_id_and_virtual_round_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auctions_on_virtual_footballer_id_and_virtual_round_id ON auctions USING btree (virtual_footballer_id, virtual_round_id);


--
-- Name: index_chats_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chats_on_league_id ON chats USING btree (league_id);


--
-- Name: index_chats_on_virtual_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chats_on_virtual_club_id ON chats USING btree (virtual_club_id);


--
-- Name: index_clubs_on_original_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clubs_on_original_u_id ON clubs USING btree (original_u_id);


--
-- Name: index_clubs_on_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clubs_on_u_id ON clubs USING btree (u_id);


--
-- Name: index_clubs_seasons_on_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clubs_seasons_on_club_id ON clubs_seasons USING btree (club_id);


--
-- Name: index_clubs_seasons_on_club_id_and_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clubs_seasons_on_club_id_and_season_id ON clubs_seasons USING btree (club_id, season_id);


--
-- Name: index_clubs_seasons_on_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clubs_seasons_on_season_id ON clubs_seasons USING btree (season_id);


--
-- Name: index_crest_patterns_on_crest_shape_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_crest_patterns_on_crest_shape_id ON crest_patterns USING btree (crest_shape_id);


--
-- Name: index_draft_histories_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_histories_on_league_id ON draft_histories USING btree (league_id);


--
-- Name: index_draft_histories_on_virtual_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_histories_on_virtual_club_id ON draft_histories USING btree (virtual_club_id);


--
-- Name: index_draft_histories_on_virtual_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_histories_on_virtual_footballer_id ON draft_histories USING btree (virtual_footballer_id);


--
-- Name: index_draft_orders_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_orders_on_league_id ON draft_orders USING btree (league_id);


--
-- Name: index_engagements_on_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_engagements_on_club_id ON engagements USING btree (club_id);


--
-- Name: index_engagements_on_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_engagements_on_footballer_id ON engagements USING btree (footballer_id);


--
-- Name: index_engagements_on_footballer_id_and_club_id_and_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_engagements_on_footballer_id_and_club_id_and_season_id ON engagements USING btree (footballer_id, club_id, season_id);


--
-- Name: index_engagements_on_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_engagements_on_season_id ON engagements USING btree (season_id);


--
-- Name: index_fixtures_match_officials_on_fixture_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_match_officials_on_fixture_id ON fixtures_match_officials USING btree (fixture_id);


--
-- Name: index_fixtures_match_officials_on_match_official_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_match_officials_on_match_official_id ON fixtures_match_officials USING btree (match_official_id);


--
-- Name: index_fixtures_on_away_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_on_away_club_id ON fixtures USING btree (away_club_id);


--
-- Name: index_fixtures_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_on_date ON fixtures USING btree (date);


--
-- Name: index_fixtures_on_home_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_on_home_club_id ON fixtures USING btree (home_club_id);


--
-- Name: index_fixtures_on_original_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_on_original_u_id ON fixtures USING btree (original_u_id);


--
-- Name: index_fixtures_on_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_on_season_id ON fixtures USING btree (season_id);


--
-- Name: index_fixtures_on_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fixtures_on_u_id ON fixtures USING btree (u_id);


--
-- Name: index_fixtures_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fixtures_on_venue_id ON fixtures USING btree (venue_id);


--
-- Name: index_footballers_on_original_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_footballers_on_original_u_id ON footballers USING btree (original_u_id);


--
-- Name: index_footballers_on_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_footballers_on_u_id ON footballers USING btree (u_id);


--
-- Name: index_formations_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_formations_on_league_id ON formations USING btree (league_id);


--
-- Name: index_game_weeks_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_weeks_on_parent_id ON game_weeks USING btree (parent_id);


--
-- Name: index_game_weeks_on_virtual_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_weeks_on_virtual_club_id ON game_weeks USING btree (virtual_club_id);


--
-- Name: index_game_weeks_on_virtual_round_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_weeks_on_virtual_round_id ON game_weeks USING btree (virtual_round_id);


--
-- Name: index_invitations_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_league_id ON invitations USING btree (league_id);


--
-- Name: index_leagues_on_invite_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_leagues_on_invite_code ON leagues USING btree (invite_code);


--
-- Name: index_leagues_on_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leagues_on_season_id ON leagues USING btree (season_id);


--
-- Name: index_leagues_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leagues_on_user_id ON leagues USING btree (user_id);


--
-- Name: index_managers_clubs_on_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managers_clubs_on_club_id ON managers_clubs USING btree (club_id);


--
-- Name: index_managers_clubs_on_manager_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managers_clubs_on_manager_id ON managers_clubs USING btree (manager_id);


--
-- Name: index_managers_clubs_on_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managers_clubs_on_season_id ON managers_clubs USING btree (season_id);


--
-- Name: index_managers_on_original_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managers_on_original_u_id ON managers USING btree (original_u_id);


--
-- Name: index_managers_on_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managers_on_u_id ON managers USING btree (u_id);


--
-- Name: index_match_officials_on_original_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_officials_on_original_u_id ON match_officials USING btree (original_u_id);


--
-- Name: index_match_officials_on_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_officials_on_u_id ON match_officials USING btree (u_id);


--
-- Name: index_messages_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_league_id ON messages USING btree (league_id);


--
-- Name: index_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_user_id ON messages USING btree (user_id);


--
-- Name: index_notifications_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_league_id ON notifications USING btree (league_id);


--
-- Name: index_notifications_on_object_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_object_id ON notifications USING btree (object_id);


--
-- Name: index_notifications_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_recipient_id ON notifications USING btree (recipient_id);


--
-- Name: index_notifications_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_sender_id ON notifications USING btree (sender_id);


--
-- Name: index_on_to_ovf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_on_to_ovf ON transfer_offers_offered_virtual_footballers USING btree (transfer_offer_id, virtual_footballer_id);


--
-- Name: index_on_to_rvf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_on_to_rvf ON transfer_offers_requested_virtual_footballers USING btree (transfer_offer_id, virtual_footballer_id);


--
-- Name: index_preferred_footballers_on_virtual_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_preferred_footballers_on_virtual_club_id ON preferred_footballers USING btree (virtual_club_id);


--
-- Name: index_preferred_footballers_on_virtual_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_preferred_footballers_on_virtual_footballer_id ON preferred_footballers USING btree (virtual_footballer_id);


--
-- Name: index_rounds_on_number_and_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_rounds_on_number_and_season_id ON rounds USING btree (number, season_id);


--
-- Name: index_rounds_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rounds_on_parent_id ON rounds USING btree (parent_id);


--
-- Name: index_rounds_on_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rounds_on_season_id ON rounds USING btree (season_id);


--
-- Name: index_sdps_on_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sdps_on_footballer_id ON sdps USING btree (footballer_id);


--
-- Name: index_sdps_on_footballer_id_and_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sdps_on_footballer_id_and_season_id ON sdps USING btree (footballer_id, season_id);


--
-- Name: index_sdps_on_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sdps_on_season_id ON sdps USING btree (season_id);


--
-- Name: index_seasons_on_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_seasons_on_u_id ON seasons USING btree (u_id);


--
-- Name: index_stadia_on_original_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stadia_on_original_u_id ON stadia USING btree (original_u_id);


--
-- Name: index_stadia_on_u_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stadia_on_u_id ON stadia USING btree (u_id);


--
-- Name: index_statistics_on_fixture_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistics_on_fixture_id ON statistics USING btree (fixture_id);


--
-- Name: index_statistics_on_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistics_on_footballer_id ON statistics USING btree (footballer_id);


--
-- Name: index_statistics_on_footballer_id_and_fixture_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistics_on_footballer_id_and_fixture_id ON statistics USING btree (footballer_id, fixture_id);


--
-- Name: index_subscriptions_on_sub_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_sub_type ON subscriptions USING btree (sub_type);


--
-- Name: index_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_user_id ON subscriptions USING btree (user_id);


--
-- Name: index_transfer_activities_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfer_activities_on_league_id ON transfer_activities USING btree (league_id);


--
-- Name: index_transfer_activities_on_virtual_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfer_activities_on_virtual_footballer_id ON transfer_activities USING btree (virtual_footballer_id);


--
-- Name: index_transfer_activities_on_virtual_round_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfer_activities_on_virtual_round_id ON transfer_activities USING btree (virtual_round_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_v_footballers_on_virtual_club_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_v_footballers_on_virtual_club_id ON draft_histories USING btree (virtual_club_id, virtual_footballer_id);


--
-- Name: index_virtual_clubs_on_crest_pattern_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_clubs_on_crest_pattern_id ON virtual_clubs USING btree (crest_pattern_id);


--
-- Name: index_virtual_clubs_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_clubs_on_league_id ON virtual_clubs USING btree (league_id);


--
-- Name: index_virtual_clubs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_clubs_on_user_id ON virtual_clubs USING btree (user_id);


--
-- Name: index_virtual_clubs_on_user_id_and_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_virtual_clubs_on_user_id_and_league_id ON virtual_clubs USING btree (user_id, league_id);


--
-- Name: index_virtual_engagements_on_game_week_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_engagements_on_game_week_id ON virtual_engagements USING btree (game_week_id);


--
-- Name: index_virtual_engagements_on_virtual_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_engagements_on_virtual_footballer_id ON virtual_engagements USING btree (virtual_footballer_id);


--
-- Name: index_virtual_fixtures_on_virtual_round_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_fixtures_on_virtual_round_id ON virtual_fixtures USING btree (virtual_round_id);


--
-- Name: index_virtual_footballers_on_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_footballers_on_footballer_id ON virtual_footballers USING btree (footballer_id);


--
-- Name: index_virtual_footballers_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_footballers_on_league_id ON virtual_footballers USING btree (league_id);


--
-- Name: index_virtual_footballers_on_league_id_and_footballer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_virtual_footballers_on_league_id_and_footballer_id ON virtual_footballers USING btree (league_id, footballer_id);


--
-- Name: index_virtual_rounds_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_rounds_on_league_id ON virtual_rounds USING btree (league_id);


--
-- Name: index_virtual_rounds_on_round_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_rounds_on_round_id ON virtual_rounds USING btree (round_id);


--
-- Name: index_virtual_scores_on_virtual_fixture_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_virtual_scores_on_virtual_fixture_id ON virtual_scores USING btree (virtual_fixture_id);


--
-- Name: statistics fk_rails_05840bda3b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistics
    ADD CONSTRAINT fk_rails_05840bda3b FOREIGN KEY (footballer_id) REFERENCES footballers(id);


--
-- Name: fixtures fk_rails_09c69164fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fk_rails_09c69164fc FOREIGN KEY (venue_id) REFERENCES stadia(id);


--
-- Name: statistics fk_rails_0a50b0d4bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistics
    ADD CONSTRAINT fk_rails_0a50b0d4bc FOREIGN KEY (fixture_id) REFERENCES fixtures(id);


--
-- Name: invitations fk_rails_0ceafa8f96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT fk_rails_0ceafa8f96 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: fixtures fk_rails_140b10c8ba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fk_rails_140b10c8ba FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: engagements fk_rails_1425ea9322; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY engagements
    ADD CONSTRAINT fk_rails_1425ea9322 FOREIGN KEY (footballer_id) REFERENCES footballers(id);


--
-- Name: draft_orders fk_rails_18dc3673e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_orders
    ADD CONSTRAINT fk_rails_18dc3673e8 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: fixtures_match_officials fk_rails_1bfb39b2d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures_match_officials
    ADD CONSTRAINT fk_rails_1bfb39b2d6 FOREIGN KEY (match_official_id) REFERENCES match_officials(id);


--
-- Name: draft_histories fk_rails_1f54331c23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_histories
    ADD CONSTRAINT fk_rails_1f54331c23 FOREIGN KEY (virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: clubs_seasons fk_rails_201fa212c2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clubs_seasons
    ADD CONSTRAINT fk_rails_201fa212c2 FOREIGN KEY (club_id) REFERENCES clubs(id);


--
-- Name: clubs_seasons fk_rails_240ea8beea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clubs_seasons
    ADD CONSTRAINT fk_rails_240ea8beea FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: virtual_engagements fk_rails_2478065375; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_engagements
    ADD CONSTRAINT fk_rails_2478065375 FOREIGN KEY (game_week_id) REFERENCES game_weeks(id);


--
-- Name: messages fk_rails_273a25a7a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_273a25a7a6 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: managers_clubs fk_rails_2769bd6c48; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers_clubs
    ADD CONSTRAINT fk_rails_2769bd6c48 FOREIGN KEY (manager_id) REFERENCES managers(id);


--
-- Name: virtual_footballers fk_rails_28d57bb076; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_footballers
    ADD CONSTRAINT fk_rails_28d57bb076 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: leagues fk_rails_3329798437; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues
    ADD CONSTRAINT fk_rails_3329798437 FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: transfer_activities fk_rails_3741f82e90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_activities
    ADD CONSTRAINT fk_rails_3741f82e90 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: messages fk_rails_4020cc2913; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_4020cc2913 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: virtual_footballers fk_rails_405a1f188a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_footballers
    ADD CONSTRAINT fk_rails_405a1f188a FOREIGN KEY (footballer_id) REFERENCES footballers(id);


--
-- Name: notifications fk_rails_4aea6afa11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_rails_4aea6afa11 FOREIGN KEY (recipient_id) REFERENCES users(id);


--
-- Name: virtual_clubs fk_rails_4bc5cacb54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_clubs
    ADD CONSTRAINT fk_rails_4bc5cacb54 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: virtual_fixtures fk_rails_54a11208f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_fixtures
    ADD CONSTRAINT fk_rails_54a11208f5 FOREIGN KEY (home_virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: rounds fk_rails_55f5c88ed0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT fk_rails_55f5c88ed0 FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: crest_patterns fk_rails_5b055347f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crest_patterns
    ADD CONSTRAINT fk_rails_5b055347f1 FOREIGN KEY (crest_shape_id) REFERENCES crest_shapes(id);


--
-- Name: engagements fk_rails_5bacb7abdc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY engagements
    ADD CONSTRAINT fk_rails_5bacb7abdc FOREIGN KEY (club_id) REFERENCES clubs(id);


--
-- Name: draft_histories fk_rails_5df62f6882; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_histories
    ADD CONSTRAINT fk_rails_5df62f6882 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: engagements fk_rails_64b159f6dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY engagements
    ADD CONSTRAINT fk_rails_64b159f6dd FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: virtual_clubs fk_rails_65c4062c30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_clubs
    ADD CONSTRAINT fk_rails_65c4062c30 FOREIGN KEY (crest_pattern_id) REFERENCES crest_patterns(id);


--
-- Name: transfer_activities fk_rails_664de92913; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_activities
    ADD CONSTRAINT fk_rails_664de92913 FOREIGN KEY (virtual_round_id) REFERENCES virtual_rounds(id);


--
-- Name: sdps fk_rails_66c8172284; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sdps
    ADD CONSTRAINT fk_rails_66c8172284 FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: fixtures fk_rails_7369f6b739; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fk_rails_7369f6b739 FOREIGN KEY (away_club_id) REFERENCES clubs(id);


--
-- Name: leagues fk_rails_7897c307a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues
    ADD CONSTRAINT fk_rails_7897c307a5 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: draft_histories fk_rails_7b8fae9d95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY draft_histories
    ADD CONSTRAINT fk_rails_7b8fae9d95 FOREIGN KEY (virtual_footballer_id) REFERENCES virtual_footballers(id);


--
-- Name: game_weeks fk_rails_7e3e4f9c6b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_weeks
    ADD CONSTRAINT fk_rails_7e3e4f9c6b FOREIGN KEY (virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: sdps fk_rails_81cd9a82da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sdps
    ADD CONSTRAINT fk_rails_81cd9a82da FOREIGN KEY (footballer_id) REFERENCES footballers(id);


--
-- Name: chats fk_rails_851a7228b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chats
    ADD CONSTRAINT fk_rails_851a7228b4 FOREIGN KEY (virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: notifications fk_rails_8780923399; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_rails_8780923399 FOREIGN KEY (sender_id) REFERENCES users(id);


--
-- Name: virtual_rounds fk_rails_8c6f87f272; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_rounds
    ADD CONSTRAINT fk_rails_8c6f87f272 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: subscriptions fk_rails_933bdff476; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_rails_933bdff476 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: game_weeks fk_rails_935fb79de0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_weeks
    ADD CONSTRAINT fk_rails_935fb79de0 FOREIGN KEY (parent_id) REFERENCES game_weeks(id);


--
-- Name: virtual_fixtures fk_rails_95f5e8aa92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_fixtures
    ADD CONSTRAINT fk_rails_95f5e8aa92 FOREIGN KEY (away_virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: managers_clubs fk_rails_97261cc5da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers_clubs
    ADD CONSTRAINT fk_rails_97261cc5da FOREIGN KEY (club_id) REFERENCES clubs(id);


--
-- Name: chats fk_rails_9726828553; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chats
    ADD CONSTRAINT fk_rails_9726828553 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: transfer_activities fk_rails_97c71615dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_activities
    ADD CONSTRAINT fk_rails_97c71615dc FOREIGN KEY (to_virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: virtual_fixtures fk_rails_9d98c11ffc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_fixtures
    ADD CONSTRAINT fk_rails_9d98c11ffc FOREIGN KEY (virtual_round_id) REFERENCES virtual_rounds(id);


--
-- Name: fixtures_match_officials fk_rails_aafff45398; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures_match_officials
    ADD CONSTRAINT fk_rails_aafff45398 FOREIGN KEY (fixture_id) REFERENCES fixtures(id);


--
-- Name: managers_clubs fk_rails_baa5a0bd39; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers_clubs
    ADD CONSTRAINT fk_rails_baa5a0bd39 FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- Name: transfer_activities fk_rails_bb6f001054; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_activities
    ADD CONSTRAINT fk_rails_bb6f001054 FOREIGN KEY (virtual_footballer_id) REFERENCES virtual_footballers(id);


--
-- Name: virtual_engagements fk_rails_c2257fc25c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_engagements
    ADD CONSTRAINT fk_rails_c2257fc25c FOREIGN KEY (virtual_footballer_id) REFERENCES virtual_footballers(id);


--
-- Name: virtual_scores fk_rails_c7f4995d39; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_scores
    ADD CONSTRAINT fk_rails_c7f4995d39 FOREIGN KEY (virtual_fixture_id) REFERENCES virtual_fixtures(id);


--
-- Name: formations fk_rails_cbada7d12a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY formations
    ADD CONSTRAINT fk_rails_cbada7d12a FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: game_weeks fk_rails_d7a50bffbe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_weeks
    ADD CONSTRAINT fk_rails_d7a50bffbe FOREIGN KEY (virtual_round_id) REFERENCES virtual_rounds(id);


--
-- Name: preferred_footballers fk_rails_e1768a49cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY preferred_footballers
    ADD CONSTRAINT fk_rails_e1768a49cb FOREIGN KEY (virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: preferred_footballers fk_rails_e23ea470b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY preferred_footballers
    ADD CONSTRAINT fk_rails_e23ea470b4 FOREIGN KEY (virtual_footballer_id) REFERENCES virtual_footballers(id);


--
-- Name: virtual_rounds fk_rails_eb865e771f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_rounds
    ADD CONSTRAINT fk_rails_eb865e771f FOREIGN KEY (round_id) REFERENCES rounds(id);


--
-- Name: notifications fk_rails_eb9845f189; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_rails_eb9845f189 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: rounds fk_rails_f5b80507cd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT fk_rails_f5b80507cd FOREIGN KEY (parent_id) REFERENCES rounds(id);


--
-- Name: transfer_activities fk_rails_faaf374520; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer_activities
    ADD CONSTRAINT fk_rails_faaf374520 FOREIGN KEY (from_virtual_club_id) REFERENCES virtual_clubs(id);


--
-- Name: fixtures fk_rails_fc5a274112; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixtures
    ADD CONSTRAINT fk_rails_fc5a274112 FOREIGN KEY (home_club_id) REFERENCES clubs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170403072236'),
('20170403074358'),
('20170403075549'),
('20170403080759'),
('20170403104454'),
('20170403105201'),
('20170403122058'),
('20170403124043'),
('20170403130907'),
('20170403131955'),
('20170403132720'),
('20170403134536'),
('20170410090759'),
('20170410121259'),
('20170410122347'),
('20170410122555'),
('20170410125553'),
('20170410144822'),
('20170411052112'),
('20170411054343'),
('20170411055336'),
('20170411055543'),
('20170411062225'),
('20170411070359'),
('20170411091508'),
('20170412064325'),
('20170412121228'),
('20170413062534'),
('20170413063641'),
('20170413074234'),
('20170413080537'),
('20170413094944'),
('20170413100132'),
('20170413101234'),
('20170413102232'),
('20170413102608'),
('20170413103029'),
('20170418131828'),
('20170419102750'),
('20170419123720'),
('20170419133435'),
('20170420080458'),
('20170421070619'),
('20170421081835'),
('20170425062242'),
('20170426050748'),
('20170427102828'),
('20170428092647'),
('20170428094354'),
('20170504125337'),
('20170511060212'),
('20170511104922'),
('20170511105052'),
('20170516065835'),
('20170517034802'),
('20170517095345'),
('20170518042911'),
('20170523082252'),
('20170523103842'),
('20170525060504'),
('20170601091124'),
('20170605085658'),
('20170605094800'),
('20170605095136'),
('20170605100942'),
('20170605101013'),
('20170605103556'),
('20170608094305'),
('20170609064255'),
('20170613081939'),
('20170613082812'),
('20170614061658'),
('20170614064050'),
('20170614064437'),
('20170614070533'),
('20170614070859'),
('20170614071204'),
('20170614071645'),
('20170614072026'),
('20170614094715'),
('20170614095431'),
('20170622104902'),
('20170623104652'),
('20170704091527'),
('20170705104414'),
('20170706113341'),
('20170707104248'),
('20170710071159'),
('20170710071712'),
('20170712095752'),
('20170712113628'),
('20170712115357'),
('20170712120252'),
('20170713053821'),
('20170717090221'),
('20170718070216'),
('20170718072218'),
('20170720110202'),
('20170720115533'),
('20170720134849'),
('20170721070647'),
('20170721122035'),
('20170721122912'),
('20170724072425'),
('20170726103845'),
('20170726112956'),
('20170727102505'),
('20170728091612'),
('20170801122853'),
('20170802050625'),
('20170802051351'),
('20170802052558'),
('20170802060819'),
('20170802061415'),
('20170802062906'),
('20170802084601'),
('20170802085726'),
('20170808111712'),
('20170810124405'),
('20170811062225'),
('20170813054120'),
('20170815115231'),
('20170816045649'),
('20170817124727'),
('20170817125241'),
('20170817125505'),
('20170823061900'),
('20170823080115'),
('20170825050937'),
('20170926052926'),
('20171006052141'),
('20171011051018'),
('20171113224147'),
('20171118230504'),
('20171127113752'),
('20181025133500');


