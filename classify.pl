:- module(classify, [classify/2]).

:- use_module(library(http/http_open)).
:- use_module(library(sgml)).
:- use_module(library(xpath)).

% classify(ISBN, DDC) is semidet.
%    Unifies DDC with the most recent Dewey Decimal Classification
%    code for the given ISBN number.
classify(ISBN, DDC) :-
    atomic_list_concat(['http://classify.oclc.org/classify2/Classify?isbn=', ISBN, '&summary=true'], URL),
    http_open(URL, Reply, []),
    load_xml(stream(Reply), DOM, []),
    xpath(DOM, //ddc/latestEdition(@sfa), DDC),
    close(Reply).
