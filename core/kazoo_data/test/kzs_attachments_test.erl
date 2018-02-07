-module(kzs_attachments_test).

-include_lib("eunit/include/eunit.hrl").

%% =======================================================================================
%% Generators
%% =======================================================================================
error_response_test_() ->
    InvalidCode = kzs_attachments:error_response("200", <<>>),
    InvalidBody = kzs_attachments:error_response(200, #{<<"unencoded">> => <<"map">>}),
    NotErrorResponse = #{<<"some">> => <<"supposed">>, <<"error">> => <<"response">>},
    ValidErrorResponse = kzs_attachments:error_response(200, <<>>),

    [{"Invalid `error_code` value type"
     ,?_assertNot(kzs_attachments:is_error_response(InvalidCode))
     }
    ,{"Invalid `error_body` value type"
     ,?_assertNot(kzs_attachments:is_error_response(InvalidBody))
     }
    ,{"Invalid error_response object"
     ,?_assertNot(kzs_attachments:is_error_response(NotErrorResponse))
     }
    ,{"Valid error response"
     ,?_assert(kzs_attachments:is_error_response(ValidErrorResponse))
     }
    ].
