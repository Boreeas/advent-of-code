has_duplicate_char([A,A|_]).
has_duplicate_char([_,B|Rest]) :- has_duplicate_char([B|Rest]).

is_vowel(a).
is_vowel(e).
is_vowel(i).
is_vowel(o).
is_vowel(u).

count_vowels([], 0).
count_vowels([C|Rest], I) :- is_vowel(C), count_vowels(Rest, I1), I is I1 + 1.
count_vowels([C|Rest], I) :- count_vowels(Rest, I), \+ is_vowel(C).

has_enough_vowels(Str) :- count_vowels(Str, X), X >= 3.

contains_bad_sequence([a,b|_]).
contains_bad_sequence([c,d|_]).
contains_bad_sequence([p,q|_]).
contains_bad_sequence([x,y|_]).
contains_bad_sequence([_|Rest]) :- contains_bad_sequence(Rest).

is_nice_word(Str) :-
    has_duplicate_char(Str),
    has_enough_vowels(Str),
    \+ contains_bad_sequence(Str).

count_nice_words([], 0).
count_nice_words([Word|Rest], I) :- 
    is_nice_word(Word), 
    count_nice_words(Rest, I1),
    I is I1 + 1.
count_nice_words([Word|Rest], I) :-
    count_nice_words(Rest, I),
    \+ is_nice_word(Word).




has_mirrored_letter([A,_,A|_]).
has_mirrored_letter([_|Rest]) :- has_mirrored_letter(Rest).

has_repeated_pair([A,B|Rest]) :- contains_pair(Rest, [A,B]).
has_repeated_pair([_|Rest]) :- has_repeated_pair(Rest).

contains_pair([A,B|_], [A,B]).
contains_pair([_|Rest], Pair) :- contains_pair(Rest, Pair).

is_nicer_word(Str) :-
    has_repeated_pair(Str),
    has_mirrored_letter(Str).

count_nicer_words([], 0).
count_nicer_words([Word|Rest], I) :-
    is_nicer_word(Word),
    count_nicer_words(Rest, I1),
    I is I1 + 1.
count_nicer_words([Word|Rest], I) :-
    count_nicer_words(Rest, I),
    \+ is_nicer_word(Word).



get_words(Stream, []) :- at_end_of_stream(Stream).
get_words(Stream, [Word|Rest]) :-
    \+ at_end_of_stream(Stream),
    read_string(Stream, "\n", "\r\t", _, Str),
    string_chars(Str, Word),
    get_words(Stream, Rest).

main(_) :- 
    open("input.txt", read, Input),
    get_words(Input, Words),
    count_nicer_words(Words, Count),
    print(Count).