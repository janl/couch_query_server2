-module(couch_query_server2).
% %%-author('').
%
% -behaviour(gen_server).
%
% -export([start_link/0]).
% -export([init/1, handle_call/3, handle_cast/2, handle_info/2]).
% -export([code_change/3]).
% -export([stop/0, terminate/2]).
%
% -define(SERVER, ?MODULE).
%
% -spec start_link() -> {ok, Pid} | ignore | {error, Error}
%   when
%       Pid :: pid(),
%       Error :: {already_started, Pid} | term().
% start_link() ->
%   gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
%
% -spec stop() -> ok.
% stop() ->
%   gen_server:cast(?SERVER, stop).
%
% -record(qs2, {port}).
%
% init(State) ->
%     Command = "/Users/jan/Work/qs2/node_query_server/bin/qs2",
%     Settings = [
%       {line, 1},
%       use_stdio,
%       hide % on windows
%     ],
%     QueryServer = open_port({spawn_executable, Command}, Settings),
%     port_connect(QueryServer, self()),
%
%   {ok, #qs2{port=QueryServer}}.
%
% send_line(Origin, Data) ->
%     self() ! {self(), {command, Data}},
%     Response = receive_line(),
%     Origin ! {response, Response}.
%
% receive_line() ->
%     receive_line([]).
%
% receive_line(Acc) ->
%     receive
%         {_QueryServer, {data, {noeol, Data}}} ->
%             receive_line([Data|Acc]);
%         {_QueryServer, {data, {eol, Data}}} ->
%             lists:reverse(Acc, Data)
%     end.
%
%
% handle_call({send, Data}, From, #qs2{port=QueryServer}=State) ->
%     port_command(QueryServer, Data)
%     {reply, State}.
%
% handle_cast(stop, State) ->
%   {stop, normal, State};
% handle_cast(_Req, State) ->
%   {noreply, State}.
%
% handle_info(_Info, State) ->
%   {noreply, State}.
%
% code_change(_OldVsn, State, _Extra) ->
%   {ok, State}.
%
% terminate(normal, _State) ->
%   ok;
% terminate(shutdown, _State) ->
%   ok;
% terminate({shutdown, _Reason}, _State) ->
%   ok;
% terminate(_Reason, _State) ->
%   ok.
%
%
