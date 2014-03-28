:- module(classify, [classify_isbn/5, classify_title/5]).

:- use_module(library(http/http_open)).
:- use_module(library(sgml)).
:- use_module(library(xpath)).
:- use_module(library(url)).

% classify(ISBN, DDC) is semidet.
%    Unifies DDC with the most recent Dewey Decimal Classification
%    code for the given ISBN number.
request_isbn(ISBN, DOM) :-
    atomic_list_concat(['http://classify.oclc.org/classify2/Classify?isbn=', ISBN, '&summary=true'], URL),
    http_open(URL, Reply, []),
    load_xml(stream(Reply), DOM, []),
    close(Reply).

request_title(Title, DOM) :-
    parse_url(URL, [protocol(http), host('classify.oclc.org'), path('/classify2/Classify'), search([title=Title,summary=true])]),
    http_open(URL, Reply, []),
    load_xml(stream(Reply), DOM, []),
    close(Reply).

% Latest classifications:
%   LatestSubfieldA - classification number from the subfield $a of 082/092 or 050/090, or 060/096
%   LatestSubfield2 - subfield $2 of 082/092
% Popular classifications:
%   PopularSubfieldA - same as LatestSubfieldA, but the most popular entry rather than most recent
%   PopularNormalizedSubfieldA - normalized classification number from the subfield $a of 082/092 or 050/090, or 060/096
classify_isbn(ISBN, LatestSubfieldA, LatestSubfield2, PopularSubfieldA, PopularNormalizedSubfieldA) :-
    request_isbn(ISBN, DOM),
    xpath(DOM, //ddc/latestEdition(@sfa), LatestSubfieldA),
    xpath(DOM, //ddc/latestEdition(@sf2), LatestSubfield2),
    xpath(DOM, //ddc/mostPopular(@sfa), PopularSubfieldA),
    xpath(DOM, //ddc/mostPopular(@nsfa), PopularNormalizedSubfieldA).

classify_title(Title, LatestSubfieldA, LatestSubfield2, PopularSubfieldA, PopularNormalizedSubfieldA) :-
    request_title(Title, DOM),
    xpath(DOM, //ddc/latestEdition(@sfa), LatestSubfieldA),
    xpath(DOM, //ddc/latestEdition(@sf2), LatestSubfield2),
    xpath(DOM, //ddc/mostPopular(@sfa), PopularSubfieldA),
    xpath(DOM, //ddc/mostPopular(@nsfa), PopularNormalizedSubfieldA).
