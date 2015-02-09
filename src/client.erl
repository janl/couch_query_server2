-module(client).
-export([client/1, test/0, test/1]).

client(Int) ->
    % list_to_pid considered safe-ish:
    % http://stackoverflow.com/questions/17001544/how-to-decouple-and-then-reconstruct-an-erlang-process-pid-a-b-c
    Data = {[{<<"a">>, Int},{<<"sender">>, list_to_binary(pid_to_list(self()))}]},
    JSON = mochijson2:encode(Data),
    qs_sender ! {data, JSON},
    receive
        {result, Result} ->
            % io:format("~nFull Circle!: ~p~n", [Result]),
            ResInt = proplists:get_value(<<"a">>, Result),
            ResInt = Int
    end.


test() ->
    Max = 1000,
    run(Max).

test(N) ->
    run(N).

run(0) ->
    ok;
run(N) ->
    spawn_link(fun() ->
        client(N)
        end),
    run(N-1).
