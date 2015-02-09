-module(couch_query_server2_client).
%
%
% handle_show_req(Req) ->
%     RequestBody = get_body(Req),
%     RequestHeaders = get_headers(Req),
%     {ResultHeaders, ResultBody} = qs2_show(Headers, Body),
%     send(Req, ResultHeaders, ResultBody).
%
% send(Req, Headers, Body) ->
%     io:format("~nHeaders: ~p Body:~p ~n", [Headers, Body]).
%
%
% get_body(Req) ->
%     proplists:get_value(body).
%
% get_headers(Req) ->
%     proplists:get_value(headers).
%
%
% make_req() ->
%     {
%         headers, [
%             'Content-Type': "application/json"
%         ],
%         body, {[{<<"a">>, 1}]}
%     }.
%
%
% qs2_show(Headers, Body) ->
%     Data = "{\"a\":1}\n",
%     couch_query_server2 ! {self(), {}}
%