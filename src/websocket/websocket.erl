-module(websocket).
-compile(export_all).

useless_hash(WSKey) ->
    base64:encode(crypto:hash(sha, 
        [WSKey, <<"258EAFA5-E914-47DA-95CA-C5AB0DC85B11">>])
    ).



%TODO: This could get expensive, need benchmark
xor_payload(Payload, Mask) -> xor_payload(Payload, Mask, <<>>).

xor_payload(<<>>, Mask, Acc) -> Acc;
xor_payload(<<Chunk:32, Rest/binary>>, M= <<Mask:32>>, Acc) ->
    XorChunk = Chunk bxor Mask,
    xor_payload(Rest, M, <<Acc/binary, XorChunk:32>>);
xor_payload(<<Chunk:24, Rest/binary>>, M= <<Mask:24, _/binary>>, Acc) ->
    XorChunk = Chunk bxor Mask,
    xor_payload(Rest, M, <<Acc/binary, XorChunk:24>>);
xor_payload(<<Chunk:16, Rest/binary>>, M= <<Mask:16, _/binary>>, Acc) ->
    XorChunk = Chunk bxor Mask,
    xor_payload(Rest, M, <<Acc/binary, XorChunk:16>>);
xor_payload(<<Chunk:8, Rest/binary>>, M= <<Mask:8, _/binary>>, Acc) ->
    XorChunk = Chunk bxor Mask,
    xor_payload(Rest, M, <<Acc/binary, XorChunk:8>>).


