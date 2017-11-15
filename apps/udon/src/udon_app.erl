-module(udon_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    case udon_sup:start_link() of
        {ok, Pid} ->
            ok = riak_core:register([{vnode_module, udon_vnode}]),
            ok = riak_core_node_watcher:service_up(udon, self()),

            Dispatch = cowboy_router:compile([
		{'_', [
			{"/ping", udon_http_ping, []}%,
                        %{'_', udon_http_api, []}
		      ]
                }
	    ]),

            %% TODO: make the port configurable (its already
            %% in the cuttlefish settings
	    {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	    }),

            {ok, Pid};
        {error, Reason} ->
            {error, Reason}
    end.

stop(_State) ->
    ok.
