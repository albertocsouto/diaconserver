%% Author: beto79
%% Created: 09/08/2010
%% Description: TODO: Add description to diaconserver_db
-module(diaconserver_db).

-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").

-include("records.hrl").


%%
%% Include files
%%

%%
%% Exported Functions
%%
%%-export([reset/0]).

%%
%% API Functions
%%
reset() ->
	mnesia:stop(),
	mnesia:delete_schema([node()]),
	mnesia:create_schema([node()]),
	mnesia:start(),

	mnesia:create_table(counter, [{disc_copies, [node()]}, {attributes, record_info(fields, counter)}]),
	mnesia:create_table(user, [{disc_copies, [node()]}, {attributes, record_info(fields, user)}]),
	mnesia:create_table(diary, [{disc_copies, [node()]}, {attributes, record_info(fields, diary)}]),
	mnesia:add_table_index(diary, date).

find(Q) ->
	F = fun() ->
			qlc:e(Q)
	end,
	transaction(F).

transaction(F) ->
	case mnesia:transaction(F) of
		{atomic, Result} ->
			Result;
		{aborted, _Reason} ->
			[]
	end.	

new_id(Key) ->
	mnesia:dirty_update_counter({counter, Key}, 1).

read(Oid) ->
	F = fun() ->
			mnesia:read(Oid)
	end,
	transaction(F).

read_all(Table) ->
	Q = qlc:q([X || X <- mnesia:table(Table)]),
	find(Q). 

write(Rec) ->
	F = fun() ->
			mnesia:write(Rec)
	end,
	mnesia:transaction(F).

delete(Oid) ->
	F = fun() ->
			mnesia:delete(Oid)
	end,
	mnesia:transaction(F).

find(Email, Pwd) ->
	
	Query = 
        fun() ->
            mnesia:match_object({user, '_', Email, Pwd, '_'})
        end,
    {atomic, Results} = mnesia:transaction(Query),
	Results.

read_day(Date) ->
	
	Query = 
		fun() ->	
			mnesia:dirty_index_read(diary, Date, #diary.date)
		end,
	{atomic, Results} = mnesia:transaction(Query),
	Results.

%%
%% Local Functions
%%

