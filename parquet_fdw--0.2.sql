-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION parquet_fdw" to load this file. \quit

CREATE FUNCTION parquet_fdw_handler()
RETURNS fdw_handler
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FUNCTION parquet_fdw_validator(text[], oid)
RETURNS void
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

CREATE FOREIGN DATA WRAPPER parquet_fdw
  HANDLER parquet_fdw_handler
  VALIDATOR parquet_fdw_validator;

CREATE FUNCTION import_parquet(
    tablename  text,
    schemaname text,
    servername text,
    func       regproc,
    arg        jsonb,
    options    jsonb default NULL)
RETURNS VOID
AS 'MODULE_PATHNAME'
LANGUAGE C;

CREATE FUNCTION import_parquet_explicit(
    tablename  text,
    schemaname text,
    servername text,
    attnames   text[],
    atttypes   regtype[],
    func       regproc,
    arg        jsonb,
    options    jsonb default NULL)
RETURNS VOID
AS 'MODULE_PATHNAME', 'import_parquet_with_attrs'
LANGUAGE C;
