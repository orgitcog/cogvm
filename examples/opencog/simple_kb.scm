; simple_kb.scm
; A simple knowledge base example

(use-modules (opencog))
(use-modules (opencog query))

; ============================================================================
; FAMILY RELATIONSHIPS KNOWLEDGE BASE
; ============================================================================

(display "Building a family relationships knowledge base...\n")

; Define people
(ConceptNode "John")
(ConceptNode "Mary")
(ConceptNode "Bob")
(ConceptNode "Alice")
(ConceptNode "Charlie")

; Define relationship types
(PredicateNode "parent-of")
(PredicateNode "spouse-of")
(PredicateNode "sibling-of")

; Define the relationships
; John and Mary are spouses
(EvaluationLink
    (PredicateNode "spouse-of")
    (ListLink
        (ConceptNode "John")
        (ConceptNode "Mary")))

; John is parent of Bob and Alice
(EvaluationLink
    (PredicateNode "parent-of")
    (ListLink
        (ConceptNode "John")
        (ConceptNode "Bob")))

(EvaluationLink
    (PredicateNode "parent-of")
    (ListLink
        (ConceptNode "John")
        (ConceptNode "Alice")))

; Mary is parent of Bob and Alice
(EvaluationLink
    (PredicateNode "parent-of")
    (ListLink
        (ConceptNode "Mary")
        (ConceptNode "Bob")))

(EvaluationLink
    (PredicateNode "parent-of")
    (ListLink
        (ConceptNode "Mary")
        (ConceptNode "Alice")))

; Bob and Alice are siblings
(EvaluationLink
    (PredicateNode "sibling-of")
    (ListLink
        (ConceptNode "Bob")
        (ConceptNode "Alice")))

(EvaluationLink
    (PredicateNode "sibling-of")
    (ListLink
        (ConceptNode "Alice")
        (ConceptNode "Bob")))

(display "Knowledge base created!\n\n")

; ============================================================================
; QUERIES ON THE KNOWLEDGE BASE
; ============================================================================

; Query: Who are John's children?
(display "Query: Who are John's children?\n")
(define johns-children
    (Get
        (Variable "$child")
        (EvaluationLink
            (PredicateNode "parent-of")
            (ListLink
                (ConceptNode "John")
                (Variable "$child")))))

(display (cog-execute! johns-children))
(newline)

; Query: Who are the parents in the family?
(display "\nQuery: Who are the parents?\n")
(define find-parents
    (Get
        (Variable "$parent")
        (EvaluationLink
            (PredicateNode "parent-of")
            (ListLink
                (Variable "$parent")
                (Variable "$anyone")))))

(display (cog-execute! find-parents))
(newline)

; Query: Who are Bob's siblings?
(display "\nQuery: Who are Bob's siblings?\n")
(define bobs-siblings
    (Get
        (Variable "$sibling")
        (EvaluationLink
            (PredicateNode "sibling-of")
            (ListLink
                (ConceptNode "Bob")
                (Variable "$sibling")))))

(display (cog-execute! bobs-siblings))
(newline)

(display "\n=== Knowledge Base Summary ===\n")
(display "Total atoms: ")
(display (cog-count-atoms))
(newline)
