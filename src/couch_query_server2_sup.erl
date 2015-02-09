-module(couch_query_server2_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================


%  couch_query_server2_app:start(null, []).

init([]) ->
    io:format("~nstarted~n", []),
    % launch query server
    Command = "/Users/jan/Work/qs2/node_query_server/bin/qs2",
    Settings = [
      {line, 4096},
      binary,
      stream,
      hide % on windows
    ],
    QueryServer = open_port({spawn_executable, Command}, Settings),
    Receiver = spawn(fun receive_loop/0),
    Sender = spawn(fun() ->
        sender(QueryServer, Receiver)
    end),

    port_connect(QueryServer, Receiver),
    register(qs_sender, Sender),

    % send_line(QueryServer, Receiver, <<"{\"a\":1}">>),
    % send_line(QueryServer, Receiver, <<"{\"a\":2}">>),
    % send_line(QueryServer, Receiver, <<"{\"a\":3}">>),
    % send_line(QueryServer, Receiver, <<"{\"a\":4}">>),
    % send_line(QueryServer, Receiver, <<"{\"a\":5}">>),

    {ok, { {one_for_one, 5, 10}, []} }.

sender(QueryServer, Receiver) ->
    receive
        {data, Data} ->
            send_line(QueryServer, Receiver, Data),
            sender(QueryServer, Receiver)
    end.

% couch_query_server2_app:start(null, []).
% couch_query_server2_sup:client().

send_line(QueryServer, Receiver, Line) ->
    % io:format("~nSent Line: ~p~n", [Line]),
    QueryServer ! {Receiver, {command, [Line, $\n]}}.

receive_loop() ->
    Line = receive_line(),
    % io:format("~nReceived Line: ~p~n", [Line]),
    %% dispatch line back to caller
    {struct, JLine} = mochijson2:decode(Line),
    % io:format("~nDecoded Line: ~p~n", [JLine]),
    % list_to_pid considered safe-ish:
    % http://stackoverflow.com/questions/17001544/how-to-decouple-and-then-reconstruct-an-erlang-process-pid-a-b-c
    Sender = list_to_pid(binary_to_list(proplists:get_value(<<"sender">>, JLine))),
    % io:format("~nSend back to: ~p~n", [Sender]),
    Sender ! {result, JLine},
    receive_loop().

receive_line() ->
    iolist_to_binary(receive_line([])).

receive_line(Acc) ->
    receive
        {_QueryServer, {data, {noeol, Data}}} ->
            io:format("~nData: ~p~n", [Data]),
            receive_line([Data|Acc]);
        {_QueryServer, {data, {eol, Data}}} ->
            lists:reverse(Acc, Data)
    end.





% TODO:
%  - test parallel requests
%  - don’t augment data, but use line proto [pid, command, data]
%    - steal from exising line protocol and prepend pid.