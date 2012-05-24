-module(poster).
-export([start/1, put/2, get/1, out/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

start(_) ->
    liset:start(poster_hash, [limited_lifetime,{lifetime,300}]).

put(Key, Value) ->
    liset:put(poster_hash, Key, Value).

get(Key) ->
    liset:get(poster_hash, Key).

out(Arg) ->
    case (Arg#arg.req)#http_request.method of
        'POST' ->
            %io:format("~w~n",[(Arg#arg.headers)#headers.content_length]),
            poster:put(Arg#arg.pathinfo, list_to_integer((Arg#arg.headers)#headers.content_length)),
            {html, ""};
        'GET' ->
            case poster:get(Arg#arg.pathinfo) of
                {found, Length} ->
                    {html, io_lib:format("~B",[Length])};
                {not_found} ->
                    {html, "-1"}
            end;
        _ ->
            {html, ""}
    end.
