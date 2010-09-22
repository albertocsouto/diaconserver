%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(diaconserver).
-author('author <author@example.com>').
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start() -> ok
%% @doc Start the diaconserver server.
start() ->
    diaconserver_deps:ensure(),
    ensure_started(crypto),
	ensure_started(mnesia),
    application:start(diaconserver).

%% @spec stop() -> ok
%% @doc Stop the diaconserver server.
stop() ->
    Res = application:stop(diaconserver),
    application:stop(mnesia),
	application:stop(crypto),
    Res.
