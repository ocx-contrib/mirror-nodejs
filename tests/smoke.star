# tests/smoke.star — stable across upstream Node.js releases.
# Asserts behavior/contract (exit codes, version digits, computed output),
# never upstream-controlled prose. See testing-practices.md.
NODE = "node.exe" if ocx.target_platform.os == ocx.os.Windows else "node"

# Tier 1 + 2: liveness on the composed PATH + version shape.
r_version = ocx.run(NODE, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional behavior on hermetic input — assert the computed result.
# Inline evaluation exercises the V8 runtime, not a help short-circuit.
r_eval = ocx.run(NODE, "-e", "console.log(40 + 2)")
expect.ok(r_eval)
expect.contains(r_eval.stdout, "42")

# Tier 3: execute a script file and assert structured output (JSON round-trip).
ocx.write_file("hello.js", "console.log(JSON.stringify({ok: true, n: 7}))\n")
r_run = ocx.run(NODE, "hello.js")
expect.ok(r_run)
expect.contains(r_run.stdout, "\"ok\":true")

# No Tier 4: metadata.json declares only PATH (proven by Tier-1 liveness).
