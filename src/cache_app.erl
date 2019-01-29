%%%-------------------------------------------------------------------
%%% @author nikita
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Янв. 2019 14:54
%%%-------------------------------------------------------------------
-module(cache_app).
-author("nikita").

-behaviour(application).

%% API
-export([start/2]).
-export([stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	cache:setup(),
	cache_sup:start_link().

stop(_State) ->
	mnesia:stop(),
	ok.
