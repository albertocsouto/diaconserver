%% Author: beto79
%% Created: 11/08/2010
%% Description: TODO: Add description to diaconactions
-module(diaconactions).

%%
%% Include files
%%
-include("records.hrl").

%%
%% Exported Functions
%%
-export([login/1, register/1]).
-export([createDiaryEntry/1, removeDiaryEntry/1, getDiaryEntries/1]).

%%
%% API Functions
%%
	
login(User) ->
	%% We have to match our User with a database item
	Email = struct:get_value(<<"email">>, User),
	Pwd = struct:get_value(<<"pwd">>, User),
	Results = diaconserver_db:find(Email, Pwd),
	case Results of
		[] ->
			S1 = struct:set_value(<<"result">>, false, User);
		_ ->
			S1 = struct:set_value(<<"result">>, true, User)					  
	end,
	S1.


register(User) ->
	Email = struct:get_value(<<"email">>, User),
	Pwd = struct:get_value(<<"pwd">>, User),
	Name = struct:get_value(<<"name">>, User),
	Id = diaconserver_db:new_id(user),
	{atomic, ok} = diaconserver_db:write({user, Id, Email, Pwd, Name}),
	S1 = struct:set_value(<<"id">>, Id, User),
	S1.

createDiaryEntry(Diary) ->
	Entry = struct:get_value(<<"entry">>, Diary),
	Data = struct:get_value(<<"data">>, Entry),
	Date = struct:get_value(<<"date">>, Entry),
	Time = struct:get_value(<<"time">>, Entry),
	Type = struct:get_value(<<"type">>, Entry),
	Id = diaconserver_db:new_id(diary),
	
	{atomic, ok} = diaconserver_db:write({diary, Id, Date, Time, Type, Data}),

	{struct, [{<<"result">>, Id}]}.

removeDiaryEntry(Diary) ->
	Ids = struct:get_value(<<"id">>, Diary),
	io:format("~nIds : ~p~n", [Ids]),
	remove(Ids).
	
remove(List) ->
	case List of
		[] ->
			{struct, [{<<"result">>, <<"ok">>}]};
		[H|T] ->						  
			{atomic, ok} = diaconserver_db:delete({diary, H}),
			remove(T)
	end.

getDiaryEntries(Diary) ->
	Date = struct:get_value(<<"date">>, Diary),
	Entries = diaconserver_db:read_day(Date),
	case Entries of
		[] ->
			{struct, [{<<"result">>, <<"ok">>}]};
		_ ->
			lists:map(fun(F) -> 
							  {struct, [{<<"date">>, Date},
										{<<"time">>, F#diary.time},
										{<<"id">>, F#diary.id}, 				 		
										{<<"type">>, F#diary.type},
										{<<"data">>, F#diary.data}]} end, Entries)
	end.
%%
%% Local Functions
%%

