:- use_module(database).
:- use_module(classify).

main :-
    parse_csv('/Users/fusion/Desktop/BookBuddy.csv', Books),
    maplist(classify_and_show, Books).

classify_and_show(book(_Title, _Author, ISBN)) :-
    (classify(ISBN, DDC) -> (write(book(ISBN, DDC)), nl)
    ; true).
