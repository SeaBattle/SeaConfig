%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Oct 2016 18:15
%%%-------------------------------------------------------------------
-module(sc_backend_etcd).
-author("tihon").

-behavior(sc_backend).

%% API
-export([get_service/2, get_services/1, register/4, get_value/2, set_value/3]).


get_service(_Host, _Name) ->
  erlang:error(not_implemented).

get_services(_Host) ->
  erlang:error(not_implemented).

register(_Host, _Service, _Address, _Port) ->
  erlang:error(not_implemented).

get_value(_Host, _Key) ->
  erlang:error(not_implemented).

set_value(_Host, _Key, _Value) ->
  erlang:error(not_implemented).