


element_at([H|_], 1, H):-
    !.

element_at([_|Tail], I, Result):-
    I > 0,
    NewI is I - 1,
    element_at(Tail, NewI, Result).



%base case: when we reach the n'th element, replace it 
replace([_|Tail], 1, Element, [Element|Tail]):-
    !.

%scrolling through the list until our Place becomes 1
replace([Head|Tail], Place, Element, [Head|Result]):- 
    Place > 0, 
    NextPlace is Place-1, 
    replace(Tail, NextPlace, Element, Result).



puzzle([[1,3,6],
        [8,o,3],
        [2,4,5]]).



isTaken(X/Y):-
    puzzle(Puzzle),
    element_at(Puzzle, Y, Result),
    element_at(Result, X, Space),
    Space \= o.

isFree(X/Y):-
    puzzle(Puzzle),
    element_at(Puzzle, Y, Result),
    element_at(Result, X, Space),
    Space = o.

%move a piece up
move(X/Y, NextState):-
    NewY is Y - 1,
    isTaken(X/NewY),
    NextState = X/NewY.

%move a piece down
move(X/Y, NextState):-
    NewY is Y + 1,
    isTaken(X/NewY),
    NextState = X/NewY.

%move a piece right
move(X/Y, NextState):-
    NewX is X + 1,
    isTaken(NewX/Y),
    NextState = NewX/Y.

%move a piece left
move(X/Y, NextState):-
    NewX is X - 1,
    isTaken(NewX/Y),
    NextState = NewX/Y.

goal(X/Y):-
    isFree(X/Y),
    puzzle(Puzzle),
    Puzzle = [[1,3,6], [3,5,4], [8,2,o]].


move_cyclefree(Visited, Node, NextNode) :-
    move(Node, NextNode),
    \+ member(NextNode, Visited).
    
    depthfirst_cyclefree(Visited, Node, Visited):-
    goal(Node).
    
    depthfirst_cyclefree(Visited, Node, Path) :-
    move_cyclefree(Visited, Node, NextNode),
    depthfirst_cyclefree([NextNode|Visited], NextNode, Path).
    
    solve_depthfirst_cyclefree(Node, Path) :-
    depthfirst_cyclefree([Node], Node, RevPath),
    reverse(RevPath, Path).