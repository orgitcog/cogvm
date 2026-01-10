; pattern_matching.scm
; Examples of pattern matching and queries in OpenCog

(use-modules (opencog))
(use-modules (opencog query))
(use-modules (opencog exec))

; ============================================================================
; SETUP: Create a small knowledge base
; ============================================================================

; Animals and their properties
(InheritanceLink (ConceptNode "dog") (ConceptNode "mammal"))
(InheritanceLink (ConceptNode "cat") (ConceptNode "mammal"))
(InheritanceLink (ConceptNode "bird") (ConceptNode "animal"))
(InheritanceLink (ConceptNode "mammal") (ConceptNode "animal"))

; Specific instances
(MemberLink (ConceptNode "Fido") (ConceptNode "dog"))
(MemberLink (ConceptNode "Whiskers") (ConceptNode "cat"))
(MemberLink (ConceptNode "Tweety") (ConceptNode "bird"))

; ============================================================================
; PATTERN MATCHING QUERIES
; ============================================================================

; Query 1: Find all things that inherit from "mammal"
(display "Query 1: Find all mammals\n")
(define find-mammals
    (Get
        (TypedVariable
            (Variable "$X")
            (Type 'ConceptNode))
        (InheritanceLink
            (Variable "$X")
            (ConceptNode "mammal"))))

(define mammals-result (cog-execute! find-mammals))
(display mammals-result)
(newline)

; Query 2: Find all instances (members) of dogs
(display "\nQuery 2: Find all dog instances\n")
(define find-dogs
    (Get
        (Variable "$X")
        (MemberLink
            (Variable "$X")
            (ConceptNode "dog"))))

(define dogs-result (cog-execute! find-dogs))
(display dogs-result)
(newline)

; Query 3: Two-hop query - find instances of mammals
(display "\nQuery 3: Find instances of mammals (two-hop)\n")
(define find-mammal-instances
    (Get
        (VariableList
            (Variable "$instance")
            (Variable "$type"))
        (And
            (MemberLink
                (Variable "$instance")
                (Variable "$type"))
            (InheritanceLink
                (Variable "$type")
                (ConceptNode "mammal")))))

(define mammal-instances (cog-execute! find-mammal-instances))
(display mammal-instances)
(newline)

; ============================================================================
; BIND LINK - More complex pattern matching with transformations
; ============================================================================

; This finds all X that inherit from Y and creates a new link
(display "\nBind example: Create 'is-a' links\n")
(define create-is-a
    (Bind
        (VariableList
            (Variable "$X")
            (Variable "$Y"))
        (InheritanceLink
            (Variable "$X")
            (Variable "$Y"))
        (EvaluationLink
            (PredicateNode "is-a")
            (ListLink
                (Variable "$X")
                (Variable "$Y")))))

(define is-a-result (cog-execute! create-is-a))
(display "Created is-a relationships:\n")
(display is-a-result)
(newline)
