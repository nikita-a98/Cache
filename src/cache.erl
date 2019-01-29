%%%-------------------------------------------------------------------
%%% @author nikita
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Янв. 2019 14:54
%%%-------------------------------------------------------------------
-module(cache).
-author("nikita").

-include_lib("cache/include/cache.hrl").


%% API
-export([
  setup/0,
  set/2,
  set/3,
  get/1,
  delete/1
]).

%%====================================================================
%% API functions
%%====================================================================

%% Создание схемы, запуск mnesia, создание таблицы с именем record и полями key, value
setup() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  mnesia:create_table(record,
    [{disc_copies, [node()]},
     {attributes, record_info(fields, record)}]).

%% Функция добавления записи с временем жизни 60 секунд в таблицу
-spec set(Key :: term(), Val :: term()) -> ok.
set(Key, Val) ->
  Insert =
    fun() ->
      mnesia:write(
        #record{
          key = Key,
          value = Val
        })
    end,
  {atomic, _} = mnesia:transaction(Insert),
  timer:apply_interval(60*1000, ?MODULE, delete, [Key]),
  ok.

%% Функция добавления записи с бесконечным/определенным временем жизни в таблицу
-spec set(Key :: term(), Val :: term(), Opts :: [{ttl, Seconds :: infinity | non_neg_integer()}]) -> ok.
set(Key, Val, [{ttl, Interval}]) ->
  Insert =
    fun() ->
      mnesia:write(
        #record{
          key = Key,
          value = Val
        })
    end,
  {atomic, _} = mnesia:transaction(Insert),
  if
    (Interval == infinity) or (Interval == 0) ->
      ok;
    Interval > 0 ->
      timer:apply_interval(Interval*1000, ?MODULE, delete, [Key]),
      ok
  end.

%% Функция поиска по ключу записи в таблице
-spec get(Key :: term) -> {ok, Val :: term()}|{error, not_found}.
get(Key) ->
  F =
    fun() ->
      mnesia:read({record, Key})
    end,
  {atomic, Results} = mnesia:transaction(F),
  case Results of
    [{record, _, Val}] -> {ok, Val};
    [] -> {error, not_found}
  end.

%% Функция удаления записи с таблицы
delete(Key) ->
  F =
    fun() ->
      mnesia:delete({record, Key})
    end,
  {atomic, _} = mnesia:transaction(F).

%%====================================================================
%% Internal function
%%====================================================================
