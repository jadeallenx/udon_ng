-module(udon_http_ping).

%% Standard callbacks.
-export([init/2]).
-export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([to_json/2]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

allowed_methods(Req, State) ->
    {[<<"GET">>], Req, State}.

content_types_provided(Req, State) ->
    {[
        {{<<"application">>, <<"json">>, []}, to_json}
     ], Req, State}.

to_json(Req, State) ->
    {pong, Partition} = udon:ping(),
    Response = jsone:encode(#{pong => integer_to_binary(Partition)}),
    {Response, Req, State}.
