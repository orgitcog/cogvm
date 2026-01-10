#!/bin/bash
# OpenCog Quick Start Script

echo "================================================"
echo "  OpenCog WebVM - Quick Start"
echo "================================================"
echo ""
echo "This script will help you get started with OpenCog."
echo ""
echo "Options:"
echo "  1) Start CogServer"
echo "  2) View Examples"
echo "  3) Test Installation"
echo "  4) Show Usage Guide"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "Starting OpenCog CogServer..."
        echo "The server will listen on:"
        echo "  - Telnet: localhost:17001"
        echo "  - WebSocket: localhost:18080"
        echo ""
        echo "To connect from another terminal:"
        echo "  telnet localhost 17001"
        echo "or with command history:"
        echo "  rlwrap telnet localhost 17001"
        echo ""
        echo "Once connected, type 'scm' to enter Scheme shell"
        echo "Press Ctrl+C to stop the server"
        echo ""
        cogserver
        ;;
    2)
        echo ""
        echo "OpenCog Examples are located in:"
        echo "  ~/opencog-examples/"
        echo ""
        echo "Available files:"
        ls -1 ~/opencog-examples/
        echo ""
        echo "To run an example in Guile:"
        echo "  guile -l ~/opencog-examples/basic_atoms.scm"
        echo ""
        read -p "Press Enter to continue..."
        ;;
    3)
        echo ""
        echo "Testing OpenCog installation..."
        echo ""
        
        # Test guile
        echo "Testing Guile..."
        guile --version | head -1
        
        # Test cogserver binary
        echo ""
        echo "Testing CogServer binary..."
        which cogserver
        
        # Test atomspace library
        echo ""
        echo "Testing AtomSpace library..."
        guile -c "(use-modules (opencog)) (display \"AtomSpace module loaded successfully\n\")"
        
        echo ""
        echo "Installation test complete!"
        echo ""
        read -p "Press Enter to continue..."
        ;;
    4)
        cat << 'EOF'

OpenCog Usage Guide
===================

1. Starting CogServer:
   $ cogserver
   
   The server will start and listen on ports 17001 (telnet) and 18080 (websocket).

2. Connecting to CogServer:
   In a new terminal:
   $ telnet localhost 17001
   
   Or with command history:
   $ rlwrap telnet localhost 17001

3. Using the Scheme Shell:
   Once connected to CogServer, type:
   opencog> scm
   
   This enters the Scheme (Guile) REPL where you can write Atomese.

4. Basic Atomese Commands:

   ; Load modules
   (use-modules (opencog))
   (use-modules (opencog query))
   
   ; Create nodes
   (ConceptNode "dog")
   (ConceptNode "animal")
   
   ; Create links
   (InheritanceLink
       (ConceptNode "dog")
       (ConceptNode "animal"))
   
   ; Query the AtomSpace
   (cog-prt-atomspace)

5. Loading Example Files:
   In Guile:
   (load "~/opencog-examples/basic_atoms.scm")

6. Using Claude AI:
   You can use the Claude AI integration in WebVM to interact with OpenCog
   using natural language. Claude will translate your requests into
   Atomese/Scheme commands.
   
   Examples:
   - "Create a concept node for 'cat'"
   - "Add an inheritance link between dog and mammal"
   - "Query all concepts in the atomspace"

For more information:
- OpenCog Wiki: https://wiki.opencog.org/
- Examples: ~/opencog-examples/README.md

EOF
        read -p "Press Enter to continue..."
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac
