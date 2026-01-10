#!/bin/bash
# OpenCog Installation Verification Script

echo "================================================"
echo "  OpenCog Installation Verification"
echo "================================================"
echo ""

ALL_PASS=true

# Check 1: Guile
echo -n "Checking Guile installation... "
if command -v guile &> /dev/null; then
    GUILE_VERSION=$(guile --version | head -n1)
    echo "✓ PASS ($GUILE_VERSION)"
else
    echo "✗ FAIL (guile not found)"
    ALL_PASS=false
fi

# Check 2: CogServer binary
echo -n "Checking CogServer binary... "
if command -v cogserver &> /dev/null; then
    COGSERVER_PATH=$(which cogserver)
    echo "✓ PASS ($COGSERVER_PATH)"
else
    echo "✗ FAIL (cogserver not found)"
    ALL_PASS=false
fi

# Check 3: AtomSpace Guile module
echo -n "Checking AtomSpace Guile module... "
if guile -c "(use-modules (opencog))" &> /dev/null; then
    echo "✓ PASS"
else
    echo "✗ FAIL (opencog module not loadable)"
    ALL_PASS=false
fi

# Check 4: Query module
echo -n "Checking Query Guile module... "
if guile -c "(use-modules (opencog query))" &> /dev/null; then
    echo "✓ PASS"
else
    echo "✗ FAIL (opencog query module not loadable)"
    ALL_PASS=false
fi

# Check 5: Examples directory
echo -n "Checking examples directory... "
if [ -d "$HOME/opencog-examples" ]; then
    EXAMPLE_COUNT=$(ls -1 "$HOME/opencog-examples" | wc -l)
    echo "✓ PASS ($EXAMPLE_COUNT files)"
else
    echo "✗ FAIL (examples directory not found)"
    ALL_PASS=false
fi

# Check 6: Start script
echo -n "Checking start script... "
if [ -x "$HOME/opencog-examples/opencog-start.sh" ]; then
    echo "✓ PASS"
else
    echo "✗ FAIL (start script not found or not executable)"
    ALL_PASS=false
fi

# Check 7: Library dependencies
echo -n "Checking CogServer dependencies... "
if ldd $(which cogserver) &> /dev/null; then
    MISSING_LIBS=$(ldd $(which cogserver) | grep "not found" | wc -l)
    if [ $MISSING_LIBS -eq 0 ]; then
        echo "✓ PASS"
    else
        echo "✗ FAIL ($MISSING_LIBS missing libraries)"
        ldd $(which cogserver) | grep "not found"
        ALL_PASS=false
    fi
else
    echo "✗ FAIL (cannot check dependencies)"
    ALL_PASS=false
fi

# Check 8: Basic AtomSpace functionality
echo -n "Checking basic AtomSpace operations... "
TEST_OUTPUT=$(guile -c "(use-modules (opencog)) (ConceptNode \"test\") (display \"OK\")" 2>/dev/null)
if [ "$TEST_OUTPUT" = "OK" ]; then
    echo "✓ PASS"
else
    echo "✗ FAIL (cannot create atoms)"
    ALL_PASS=false
fi

echo ""
echo "================================================"
if [ "$ALL_PASS" = true ]; then
    echo "  ✓ All checks passed!"
    echo "  OpenCog is properly installed."
    echo ""
    echo "  Next steps:"
    echo "    1. Run: cogserver"
    echo "    2. In another terminal: telnet localhost 17001"
    echo "    3. Type 'scm' to enter Scheme shell"
    echo ""
    echo "  Or use the quick start script:"
    echo "    ~/opencog-examples/opencog-start.sh"
else
    echo "  ✗ Some checks failed."
    echo "  Please review the errors above."
    echo ""
    echo "  Common issues:"
    echo "    - Missing dependencies: reinstall packages"
    echo "    - Path issues: check LD_LIBRARY_PATH"
    echo "    - Module issues: verify guile load paths"
fi
echo "================================================"

exit $([[ "$ALL_PASS" = true ]] && echo 0 || echo 1)
