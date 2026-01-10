# OpenCog WebVM User Guide

Welcome to OpenCog WebVM! This guide will help you get started with OpenCog running in your browser.

## Table of Contents
1. [What is OpenCog WebVM?](#what-is-opencog-webvm)
2. [Getting Started](#getting-started)
3. [Using CogServer](#using-cogserver)
4. [Writing Atomese](#writing-atomese)
5. [Using Claude AI](#using-claude-ai)
6. [Examples](#examples)
7. [Troubleshooting](#troubleshooting)
8. [Resources](#resources)

## What is OpenCog WebVM?

OpenCog WebVM is a browser-based implementation of OpenCog, allowing you to:
- Run OpenCog's CogServer entirely in your browser
- Work with the AtomSpace hypergraph database
- Write and execute Atomese (OpenCog's knowledge representation language)
- Use Claude AI to translate natural language into Atomese commands
- Learn and experiment with AGI concepts

**Important**: This runs via WebAssembly virtualization, so it's slower than native execution but requires no installation!

## Getting Started

### First Steps

When you first open OpenCog WebVM, you'll see a terminal. Try these commands:

```bash
# Check installation
~/opencog-examples/verify-installation.sh

# View the quick start menu
~/opencog-examples/opencog-start.sh
```

### Starting CogServer

CogServer is the network server that provides access to OpenCog's AtomSpace:

```bash
cogserver
```

You'll see output like:
```
Listening on port 17001
Listening for websocket on port 18080
```

**Note**: Leave this terminal running with CogServer active.

### Connecting to CogServer

You have two options:

#### Option 1: Using Telnet (Traditional)

Open a new terminal in WebVM and type:
```bash
telnet localhost 17001
```

Or with command history support:
```bash
rlwrap telnet localhost 17001
```

Once connected, you'll see:
```
opencog>
```

Type `scm` to enter the Scheme shell:
```
opencog> scm
Entering scheme shell; use ^D or a single . on a line by itself to exit.
guile>
```

#### Option 2: Using Claude AI (Recommended)

Click the robot icon in the WebVM interface to open the Claude AI panel. You can then interact with OpenCog using natural language!

## Using CogServer

### Basic Commands

In the CogServer prompt (`opencog>`):
- `scm` - Enter Scheme shell for Atomese
- `py` - Enter Python shell (if available)
- `help` - Show available commands
- `shutdown` - Stop the server (or Ctrl+C)

### Scheme Shell Commands

Once in the Scheme shell (`guile>`):

```scheme
; Load OpenCog modules
(use-modules (opencog))
(use-modules (opencog query))

; Create nodes
(ConceptNode "dog")
(ConceptNode "animal")

; Create links
(InheritanceLink
    (ConceptNode "dog")
    (ConceptNode "animal"))

; Query the atomspace
(cog-prt-atomspace)

; Count atoms
(cog-count-atoms)

; Exit Scheme shell
.
```

## Writing Atomese

Atomese is OpenCog's knowledge representation language based on hypergraphs.

### Basic Concepts

**Nodes** represent entities:
```scheme
(ConceptNode "cat")      ; A concept
(PredicateNode "likes")  ; A predicate/relationship
(NumberNode "42")        ; A number
```

**Links** connect nodes:
```scheme
; Inheritance: "cat" is a "mammal"
(InheritanceLink
    (ConceptNode "cat")
    (ConceptNode "mammal"))

; Evaluation: "John" "likes" "cats"
(EvaluationLink
    (PredicateNode "likes")
    (ListLink
        (ConceptNode "John")
        (ConceptNode "cats")))

; Member: "Fluffy" is a member of "cat" class
(MemberLink
    (ConceptNode "Fluffy")
    (ConceptNode "cat"))
```

### Pattern Matching

Find atoms matching patterns:

```scheme
(use-modules (opencog query))

; Find all X that inherit from "mammal"
(cog-execute!
    (Get
        (Variable "$X")
        (InheritanceLink
            (Variable "$X")
            (ConceptNode "mammal"))))
```

### Loading Example Scripts

```bash
# From bash shell
guile -l ~/opencog-examples/basic_atoms.scm

# Or from Guile shell
(load "~/opencog-examples/basic_atoms.scm")
```

## Using Claude AI

The Claude AI integration makes OpenCog accessible through natural language.

### Setup

1. Click the robot icon in WebVM
2. Enter your Claude API key (get one from [Anthropic Console](https://console.anthropic.com/))
3. Start interacting!

### Example Conversations

**Creating Knowledge:**
```
You: Create a concept node for "dog" and another for "animal", then create an inheritance link between them.

Claude: I'll create those nodes and link them using Atomese...
[Executes the appropriate Scheme commands]
```

**Querying Knowledge:**
```
You: What concepts are in the atomspace?

Claude: Let me query the atomspace for all concepts...
[Executes query and shows results]
```

**Learning:**
```
You: Explain what an InheritanceLink does

Claude: An InheritanceLink represents an "is-a" relationship...
```

### Tips for Working with Claude

- Be specific about what you want to do
- Ask Claude to explain commands before executing them
- Use Claude to learn Atomese syntax
- Claude knows OpenCog documentation and best practices

## Examples

All examples are in `~/opencog-examples/`:

### 1. Basic Atoms (`basic_atoms.scm`)

Creates simple nodes and links, demonstrates querying:
```bash
guile -l ~/opencog-examples/basic_atoms.scm
```

**What it shows:**
- Creating ConceptNodes
- Creating InheritanceLinks
- Querying the atomspace

### 2. Pattern Matching (`pattern_matching.scm`)

Demonstrates pattern matching and queries:
```bash
guile -l ~/opencog-examples/pattern_matching.scm
```

**What it shows:**
- Get queries with variables
- Two-hop queries
- Bind links for transformations

### 3. Simple Knowledge Base (`simple_kb.scm`)

A family relationships example:
```bash
guile -l ~/opencog-examples/simple_kb.scm
```

**What it shows:**
- Building a knowledge base
- Querying relationships
- Practical use case

### Running Your Own Code

Create a file `my-code.scm`:
```scheme
(use-modules (opencog))

(ConceptNode "my-concept")
(display "Created my concept!\n")
```

Run it:
```bash
guile -l my-code.scm
```

## Troubleshooting

### CogServer Won't Start

**Problem**: `cogserver: command not found`
**Solution**: Run verification script:
```bash
~/opencog-examples/verify-installation.sh
```

**Problem**: Port already in use
**Solution**: Kill existing cogserver:
```bash
pkill cogserver
# Then restart
cogserver
```

### Can't Connect via Telnet

**Problem**: Connection refused
**Solution**: 
1. Make sure cogserver is running in another terminal
2. Try: `netstat -an | grep 17001` to verify it's listening
3. Restart cogserver if needed

### Guile Module Errors

**Problem**: `no code for module (opencog)`
**Solution**: Check guile paths:
```bash
guile -c "(display %load-path)"
```

Should include `/usr/local/share/guile/site/3.0`

### Slow Performance

**Remember**: WebVM runs in your browser via WebAssembly. It's expected to be slower than native execution.

**Tips**:
- Keep queries simple when testing
- Use Chrome/Firefox for best performance
- Be patient with startup times

### Claude AI Issues

**Problem**: Claude doesn't understand OpenCog commands
**Solution**: 
- Make sure you're using clear, specific language
- Try asking Claude to explain what it's doing
- Break complex requests into smaller steps

## Resources

### Documentation
- [OpenCog Wiki](https://wiki.opencog.org/) - Official documentation
- [AtomSpace Guide](https://wiki.opencog.org/w/AtomSpace) - Core concepts
- [Scheme Shell Tutorial](https://wiki.opencog.org/w/Getting_Started_with_Atoms_and_the_Scheme_Shell)

### Examples
- Check `~/opencog-examples/README.md` for detailed explanations
- Each `.scm` file has inline comments

### Community
- [OpenCog Discord](https://discord.gg/opencog)
- [OpenCog GitHub](https://github.com/opencog)
- [OpenCog Forum](https://groups.google.com/g/opencog)

### Learning Path

1. **Start with basics**: Run the example scripts
2. **Learn Atomese**: Create simple nodes and links
3. **Try pattern matching**: Query your knowledge
4. **Build something**: Create a small knowledge base
5. **Explore**: Check out the OpenCog wiki for advanced topics

## Next Steps

Now that you understand the basics:

1. ✅ Run through all three example scripts
2. ✅ Create your own simple knowledge base
3. ✅ Experiment with pattern matching
4. ✅ Try using Claude AI to interact with OpenCog
5. ✅ Read the OpenCog wiki for advanced concepts
6. ✅ Join the OpenCog community

## Performance Notes

WebVM runs x86 code in your browser using WebAssembly:

- **Startup**: CogServer may take 10-30 seconds to start
- **Queries**: Simple queries are instant, complex ones may take longer
- **Building**: Creating knowledge structures is reasonably fast
- **Overall**: Suitable for learning and experimentation

## Limitations

This browser-based version has some limitations:

- **No persistence**: AtomSpace is in-memory only (clears on refresh)
- **No external connections**: Limited networking capabilities
- **Performance**: Slower than native installation
- **Memory**: Limited by browser constraints
- **Modules**: Only core OpenCog modules included

For production use or advanced features, consider a native installation.

## Getting Help

If you need help:

1. **Check examples**: `~/opencog-examples/`
2. **Run verification**: `~/opencog-examples/verify-installation.sh`
3. **Read documentation**: See Resources section
4. **Ask Claude AI**: Use the integrated AI assistant
5. **Community support**: OpenCog Discord/Forum

---

**Happy experimenting with OpenCog!** 🧠🤖
