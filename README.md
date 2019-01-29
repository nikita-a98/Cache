cache это erlang приложение для кеширования данных в Mnesia.

Запуск приложения:
make run

API приложения:
cache:get(Key :: term()) -> {ok, Val :: term()} | {error, not_found}.
cache:set(Key :: term(), Val :: term()) -> ok.
cache:set(Key :: term(), Val :: term(), Opts :: [{ttl, Seconds :: infinity | non_neg_integer()}]) -> ok.

Примеры использования:
cache:set(foo, bar).
cache:set(foo, bar, [{ttl, 120}]).
cache:set(foo, bar, [{ttl, infinity}]).
