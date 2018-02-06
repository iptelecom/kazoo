%%%-------------------------------------------------------------------
%%% @copyright (C) 2011-2018, 2600Hz INC
%%% @doc
%%%
%%% Created : 17 Jul 2016
%%%
%%% @author SIPLABS, LLC (Vorontsov Nikita)
%%% @end
%%%-------------------------------------------------------------------
-module(edr_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-include("edr.hrl").

-define(CHILDREN, [?SUPER('edr_backend_sup')]).

%% ===================================================================
%% API functions
%% ===================================================================

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Starts the supervisor
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> kz_types:startlink_ret().
start_link() ->
    supervisor:start_link({'local', ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%% @end
%%--------------------------------------------------------------------
-spec init([]) -> kz_types:sup_init_ret().
init([]) ->
    kz_util:set_startup(),
    RestartStrategy = 'one_for_one',
    MaxRestarts = 5,
    MaxSecondsBetweenRestarts = 10,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    {'ok', {SupFlags, ?CHILDREN}}.
