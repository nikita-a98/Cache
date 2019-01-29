%%%-------------------------------------------------------------------
%%% @author nikita
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Янв. 2019 14:54
%%%-------------------------------------------------------------------
-module(cache_sup).
-author("nikita").

-behaviour(supervisor).

%% API
-export([start_link/0]).
-export([init/1]).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [],
	{ok, {{one_for_one, 0, 1}, Procs}}.
