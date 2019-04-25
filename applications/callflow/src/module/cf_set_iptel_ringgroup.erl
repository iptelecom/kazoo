%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2013-2019, 2600Hz
%%% @doc Set a Custom RingGroup Channel variable.
%%%
%%% <h4>Data options:</h4>
%%% <dl>
%%%   <dt>`value'</dt>
%%%   <dd>Value to set.</dd>
%%%
%%%   <dt>`channel'</dt>
%%%   <dd>On which call channel variable should be set, channel (leg) `a',
%%%   `both', ... . Default is `a'.</dd>
%%% </dl>
%%%
%%%
%%% @author Arjan Vos - IPTelecom
%%% @end
%%%-----------------------------------------------------------------------------
-module(cf_set_iptel_ringgroup).

-behaviour(gen_cf_action).

-include("callflow.hrl").

-export([handle/2]).

%%------------------------------------------------------------------------------
%% @doc Entry point for this module
%% @end
%%------------------------------------------------------------------------------
-spec handle(kz_json:object(), kapps_call:call()) -> 'ok'.
handle(Data, Call) ->
    Value = kz_json:get_ne_binary_value(<<"value">>, Data),
    Name = <<"RingGroup">>,
    Channel = kz_json:get_ne_binary_value(<<"channel">>, Data, <<"a">>),
    set_variable(Name, Value, Channel, Call),
    Call1 = kapps_call:insert_custom_channel_var(Name, Value, Call),
    cf_exe:set_call(Call1),
    cf_exe:continue(Call1).

-spec set_variable(kz_term:api_binary(), kz_term:api_binary(), kz_term:ne_binary(), kapps_call:call()) -> 'ok'.
set_variable(_Name, 'undefined', _Channel, _Call) ->
    lager:warning("can not set variable without value!");
set_variable(Name, Value, Channel, Call) ->
    lager:debug("set ~s/~s pair on ~s-leg", [Name, Value, Channel]),
    Var = kz_json:from_list([{Name, Value}]),
    execute_set_var(Var, Channel, Call).

-spec execute_set_var(kz_json:object(), kz_term:ne_binary(), kapps_call:call()) -> 'ok'.
execute_set_var(Var, <<"a">>, Call) ->
    kapps_call_command:set(Var, 'undefined', Call);
execute_set_var(Var, <<"both">>, Call) ->
    kapps_call_command:set('undefined', Var, Call).
