has_duplicate_char(List) :- once(nextto(X,X,List)).

is_vowel(a).
is_vowel(e).
is_vowel(i).
is_vowel(o).
is_vowel(u).

vowel_sum(In, Acc, Out) :- is_vowel(In), succ(Acc, Out).
vowel_sum(In, X, X) :- \+ is_vowel(In).

has_enough_vowels(Str) :- foldl(vowel_sum, Str, 0, Result), Result >= 3.

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
    succ(I1, I).
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
    count_nice_words(Words, NiceCount),
    count_nicer_words(Words, NicerCount),
    %print(NiceCount),
    print(NicerCount).