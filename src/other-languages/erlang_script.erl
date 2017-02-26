#!/usr/local/bin/escript

main(Args) -> main("World", Args).  % invoked first, sets Name="World"

main(_, ["-h" | _Args]) ->
    io:format("Help! Help!~n");  % print message, exit.

main(_, ["-n", Name | Args]) ->  % ignore old name, pop new one off Args.
    main(Name, Args);            % recurse to next arg with new Name.

main(Name, []) ->
    io:format("Hello, ~s!~n", [Name]).  % print message, exit.
