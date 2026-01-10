; basic_atoms.scm
; Basic examples of creating and manipulating atoms in OpenCog

; Load the OpenCog module
(use-modules (opencog))

; ============================================================================
; NODES - The basic building blocks
; ============================================================================

; Create some concept nodes
(ConceptNode "dog")
(ConceptNode "cat")
(ConceptNode "animal")
(ConceptNode "mammal")

; Create predicate nodes
(PredicateNode "has-color")
(PredicateNode "likes")

; ============================================================================
; LINKS - Connecting nodes together
; ============================================================================

; Inheritance relationships
(InheritanceLink
    (ConceptNode "dog")
    (ConceptNode "mammal"))

(InheritanceLink
    (ConceptNode "cat")
    (ConceptNode "mammal"))

(InheritanceLink
    (ConceptNode "mammal")
    (ConceptNode "animal"))

; Evaluation links for predicates
(EvaluationLink
    (PredicateNode "has-color")
    (ListLink
        (ConceptNode "dog")
        (ConceptNode "brown")))

; Member links
(MemberLink
    (ConceptNode "Fido")
    (ConceptNode "dog"))

; ============================================================================
; QUERYING THE ATOMSPACE
; ============================================================================

; Display all atoms
(display "All atoms in the AtomSpace:\n")
(cog-prt-atomspace)

; Get the incoming set (atoms that point TO this atom)
(display "\nIncoming set for 'mammal':\n")
(cog-incoming-set (ConceptNode "mammal"))

; Get the outgoing set (atoms that this atom points to)
(display "\nOutgoing set for dog->mammal link:\n")
(cog-outgoing-set 
    (InheritanceLink
        (ConceptNode "dog")
        (ConceptNode "mammal")))

; Count atoms in the atomspace
(display "\nTotal atom count: ")
(display (cog-count-atoms))
(newline)
