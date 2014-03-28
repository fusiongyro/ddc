:- module(classify_all, [main/0]).

:- use_module(library(odbc)).
:- use_module(classify).

%main :-
%    odbc_connect(library, _, [alias(library)]),
    %repeat,
%    odbc_query(library, 'SELECT isbn FROM books WHERE ddc_popular1 IS NULL', row(ISBN)),
%    write('Querying for ISBN '), write(ISBN), write('...'),
%    classify:classify_isbn(ISBN, LSFA, LSF2, PSFA, PNSFA),
%    write(LSFA), write('.'), nl,
%    atomic_list_concat(['UPDATE books SET ddc_popular1 = \'', PSFA, '\', ddc_popular2 = \'', PNSFA, '\', ddc_recent1 = \'', LSFA, '\', ddc_recent2 = \'', LSF2, '\' WHERE isbn = \'', ISBN, '\''], SQL),
%    odbc_query(library, SQL),
%    fail.
main :-
    odbc_connect(library, _, [alias(library)]),
    odbc_query(library, 'SELECT title, isbn FROM books WHERE ddc_popular1 IS NULL AND isbn IS NOT NULL', row(Title, ISBN)),
    write('Querying for: '), write(Title), write('...'),
    classify:classify_title(Title, LSFA, LSF2, PSFA, PNSFA),
    write(LSFA), write('.'), nl,
    atomic_list_concat(['UPDATE books SET ddc_popular1 = \'', PSFA, '\', ddc_popular2 = \'', PNSFA, '\', ddc_recent1 = \'', LSFA, '\', ddc_recent2 = \'', LSF2, '\' WHERE isbn = \'', ISBN, '\''], SQL),
    odbc_query(library, SQL),
    fail.
main :- true.

