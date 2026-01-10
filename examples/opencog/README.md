# OpenCog Examples for WebVM

This directory contains examples for using OpenCog's AtomSpace and CogServer.

## Getting Started

### Starting the CogServer

```bash
cogserver
```

The server will start on port 17001 (telnet) and 18080 (websocket).

### Connecting to CogServer

In another terminal or using the Claude AI integration:

```bash
telnet localhost 17001
```

Or with command history:

```bash
rlwrap telnet localhost 17001
```

Once connected, type `scm` to enter the Scheme (Guile) shell.

## Basic Atomese Examples

### Creating Nodes and Links

```scheme
; Create concept nodes
(ConceptNode "dog")
(ConceptNode "animal")

; Create an inheritance link
(InheritanceLink
    (ConceptNode "dog")
    (ConceptNode "animal"))
```

### Querying the AtomSpace

```scheme
; Get all atoms in the atomspace
(cog-get-all-atoms)

; Get incoming set of an atom
(cog-incoming-set (ConceptNode "animal"))

; Get outgoing set of a link
(cog-outgoing-set (InheritanceLink (ConceptNode "dog") (ConceptNode "animal")))
```

### Pattern Matching

```scheme
; Define a simple pattern matcher
(use-modules (opencog query))

; Find all things that inherit from "animal"
(define find-animals
    (Get
        (TypedVariable
            (Variable "$X")
            (Type 'ConceptNode))
        (InheritanceLink
            (Variable "$X")
            (ConceptNode "animal"))))

; Execute the query
(cog-execute! find-animals)
```

## Using Claude AI with OpenCog

When interacting through the Claude AI integration in WebVM, you can ask Claude to:

1. **Create knowledge structures**: "Create an inheritance relationship between cat and mammal"
2. **Query knowledge**: "Find all concepts that inherit from animal"
3. **Run Atomese code**: "Execute this Scheme code in the cogserver: (ConceptNode 'test')"
4. **Explain concepts**: "What is an AtomSpace?"

Claude will translate your natural language requests into appropriate Guile/Scheme commands for the cogserver.

## Example Session

```scheme
; Start with loading modules
(use-modules (opencog))
(use-modules (opencog query))

; Create a simple knowledge base
(ConceptNode "Socrates")
(ConceptNode "human")
(ConceptNode "mortal")

(InheritanceLink (ConceptNode "Socrates") (ConceptNode "human"))
(InheritanceLink (ConceptNode "human") (ConceptNode "mortal"))

; Query: Is Socrates mortal?
; This requires PLN (Probabilistic Logic Networks) for full inference,
; but we can check the direct relationships:

(cog-incoming-set (ConceptNode "human"))
```

## Resources

- OpenCog Wiki: https://wiki.opencog.org/
- AtomSpace Guide: https://wiki.opencog.org/w/AtomSpace
- Scheme Shell Tutorial: https://wiki.opencog.org/w/Getting_Started_with_Atoms_and_the_Scheme_Shell
- CogServer Documentation: https://github.com/opencog/cogserver

## Files

- `basic_atoms.scm` - Basic node and link creation
- `pattern_matching.scm` - Pattern matching examples
- `simple_kb.scm` - Simple knowledge base example
