%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the diaconserver application.

-module(diaconserver_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2, stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for diaconserver.
start(_Type, _StartArgs) ->
    diaconserver_deps:ensure(),
    diaconserver_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for diaconserver.
stop(_State) ->
    ok.


%%
%% Tests
%%
-include_lib("eunit/include/eunit.hrl").
-ifdef(TEST).
-endif.
