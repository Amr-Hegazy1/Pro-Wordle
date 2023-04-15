is_category(C) :- word(_,C).


categories(L) :- setof(C,is_category(C),LL),list_to_set(LL,L).


available_length(L) :- word(W,_),atom_length(W,L).

pick_word(W,L,C) :-

    word(W,C),
    atom_length(W,L).

correct_letters([],_,[]).
correct_letters([H|T],L2,[H|CT]) :-

    member(H,L2),
    delete(L2,H,L3),
    correct_letters(T,L3,CT).

correct_letters([H|T],L2,CL) :-

    \+ member(H,L2),
    
    correct_letters(T,L2,CL).


correct_positions([],_,[]).

correct_positions([H|T1],[H|T2],[H|PT]) :-

    correct_positions(T1,T2,PT).

correct_positions([H1|T1],[H2|T2],PL) :-
    H1 \= H2,
    correct_positions(T1,T2,PL).


build_kb() :-

    write("Please enter a word and its category on separate lines:"),
    nl,
    read(W),
    (
        (W \= done,
        read(C),
        assert(word(W,C)),
        build_kb()) ;
        (
            W = done
        )
    ).





play() :-

    categories(L),
    write("The available categories are: "),
    write(L),
    nl,
    play_category(C),
    play_length(LL),
    N is LL + 1,
    write("Game started. You have "),
    write(N),
    write(" guesses."),
    nl,
    pick_word(W,LL,C),
    play_until_no(N,LL,C,W).





play_category(C1) :- 

    write("Choose a category:"),
    nl,
    read(C),
    (
        (
        \+ is_category(C),
        write("This category does not exist."),nl,
        play_category(C1)) ;
        (
            is_category(C),
            C1 = C
        )
    ).
    




play_length(L1) :-

    write("Choose a length:"),
    nl,
    read(L),
    (
        (
            \+ available_length(L),
            write("There are no words of this length."),nl,
            play_length(L1)
        ) ;
        (
            available_length(L),
            L1 = L
        )
    ).
    



    

play_until_no(0,_,_,_) :- write("You lost!").




play_until_no(N,L,C,W) :-
    N > 0,
    write("Enter a word composed of 5 letters:"),
    nl,
    read(W1),
    (
        (atom_length(W1,L),
        atom_chars(W1,WL1),
        atom_chars(W,WL),
        correct_letters(WL,WL1,CL),
        correct_positions(WL,WL1,PL),
        W \= W1,
        write("Correct letters are: "),
        write(CL),
        nl,
        write("Correct letters in correct positions are: "),
        write(PL),
        nl,
        write("Remaining Guesses are "),
        
        N1 is N - 1,
        write(N1),
        nl,
        play_until_no(N1,L,C,W)) ;
        (
            W1 = W,
            write("You won!"),
            nl
        );
        (
            \+ atom_length(W1,L),
            write("Word is not composed of 5 letters. Try again."),
            nl,
            write("Remaining Guesses are "),
            write(N),
            nl,
            play_until_no(N,L,C,W)
        )
    ).





main() :-

    build_kb,
    write("Done building the words database..."),
    nl,
    play.
