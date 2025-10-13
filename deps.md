# Ballerina jballerina-tools Dependencies

This document lists all the modules required to build `jballerina-tools:createDistribution` based on the Gradle dry-run analysis and module-info.java dependency analysis.

## Core Modules (in build order with dependencies)

1. **ballerina-tools-api** - Tools API definitions
   - Dependencies: None (base module)

2. **identifier-util** - Identifier utilities
   - Dependencies: None (external: org.apache.commons.text)

3. **toml-parser** - TOML configuration parser
   - Dependencies: io.ballerina.tools.api, io.ballerina.identifier
   - External: com.google.gson, org.apache.commons.text

4. **ballerina-runtime** - Ballerina runtime
   - Dependencies: io.ballerina.toml, io.ballerina.tools.api, io.ballerina.identifier
   - External: java.xml, org.apache.commons.text, axiom.api, java.logging, java.management, io.opentelemetry.api, etc.

5. **central-client** - Central client for package management
   - Dependencies: io.ballerina.runtime
   - External: com.google.gson, jsr305, java.net.http, progressbar, jdk.httpserver, java.semver, etc.

6. **maven-resolver** - Maven dependency resolver
   - Dependencies: None (no module-info.java)

7. **semtypes** - Semantic types
   - Dependencies: None

8. **ballerina-lang** - Core Ballerina language implementation
   - Dependencies: io.ballerina.runtime, io.ballerina.parser, io.ballerina.tools.api, io.ballerina.toml, io.ballerina.central.client, io.ballerina.semtype, io.ballerina.identifier
   - External: java.compiler, com.google.gson, java.xml, org.objectweb.asm, io.netty.buffer, etc.

## Language Library Modules

All langlib modules depend on **io.ballerina.runtime** and export their respective packages.

9. **ballerina-lang:annotations** - Annotations langlib
    - Dependencies: io.ballerina.runtime

10. **ballerina-lang:array** - Array langlib
    - Dependencies: io.ballerina.runtime

11. **ballerina-lang:bool** - Boolean langlib
    - Dependencies: io.ballerina.runtime

12. **ballerina-lang:decimal** - Decimal langlib
    - Dependencies: io.ballerina.runtime

13. **ballerina-lang:error** - Error langlib
    - Dependencies: io.ballerina.runtime

14. **ballerina-lang:floatingpoint** - Floating point langlib
    - Dependencies: io.ballerina.runtime

15. **ballerina-lang:function** - Function langlib
    - Dependencies: io.ballerina.runtime

16. **ballerina-lang:future** - Future langlib
    - Dependencies: io.ballerina.runtime

17. **ballerina-lang:integer** - Integer langlib
    - Dependencies: io.ballerina.runtime

18. **ballerina-lang:internal** - Internal langlib
    - Dependencies: io.ballerina.runtime

19. **ballerina-lang:jballerina.java** - Java interop langlib
    - Dependencies: io.ballerina.runtime

20. **ballerina-lang:map** - Map langlib
    - Dependencies: io.ballerina.runtime

21. **ballerina-lang:natural** - Natural langlib
    - Dependencies: io.ballerina.runtime

22. **ballerina-lang:object** - Object langlib
    - Dependencies: io.ballerina.runtime

23. **ballerina-lang:query** - Query langlib
    - Dependencies: io.ballerina.runtime

24. **ballerina-lang:regexp** - Regular expression langlib
    - Dependencies: io.ballerina.runtime

25. **ballerina-lang:runtime** - Runtime langlib
    - Dependencies: io.ballerina.runtime

26. **ballerina-lang:stream** - Stream langlib
    - Dependencies: io.ballerina.runtime

27. **ballerina-lang:string** - String langlib
    - Dependencies: io.ballerina.runtime

28. **ballerina-lang:table** - Table langlib
    - Dependencies: io.ballerina.runtime

29. **ballerina-lang:transaction** - Transaction langlib
    - Dependencies: io.ballerina.runtime

30. **ballerina-lang:typedesc** - Type descriptor langlib
    - Dependencies: io.ballerina.runtime

31. **ballerina-lang:value** - Value langlib
    - Dependencies: io.ballerina.runtime

32. **ballerina-lang:xml** - XML langlib
    - Dependencies: io.ballerina.runtime

## Tools and Utilities

34. **docerina** - Documentation generator
35. **ballerina-shell:shell-rt** - Ballerina shell runtime
36. **ballerina-shell:shell-core** - Ballerina shell core
37. **ballerina-shell:shell-cli** - Ballerina shell CLI
38. **testerina:testerina-core** - Testerina core
39. **testerina:testerina-compiler-plugin** - Testerina compiler plugin
40. **testerina:testerina-runtime** - Testerina runtime
41. **ballerina-cli** - Ballerina CLI
42. **formatter:formatter-core** - Code formatter core
43. **ballerina-bindgen** - Java bindings generator
44. **ballerina-io-internal** - Internal I/O utilities
45. **ballerina-linter** - Ballerina linter
46. **ballerina-profiler** - Ballerina profiler
47. **ballerina-rt** - Ballerina runtime
48. **lib-creator** - Library creator utility

## Language Server and Extensions

49. **language-server:language-server-commons** - Language server commons
50. **language-server:language-server-stdlib** - Language server stdlib
51. **language-server:language-server-core** - Language server core
52. **language-server:language-server-stdio-launcher** - Language server stdio launcher
53. **language-server:language-server-cli** - Language server CLI
54. **diagram-util** - Diagram utilities
55. **syntax-api-calls-gen** - Syntax API calls generator
56. **formatter:formatter-cli** - Code formatter CLI
57. **ballerinalang-data-mapper** - Data mapper
58. **docerina-gradle-plugin** - Docerina Gradle plugin

## Debug and Development Tools

59. **debug-adapter:debug-adapter-runtime** - Debug adapter runtime
60. **debug-adapter:debug-adapter-core** - Debug adapter core
61. **debug-adapter:debug-adapter-cli** - Debug adapter CLI
62. **metrics-extensions:ballerina-metrics-extension** - Metrics extension

## Language Server Extensions

63. **ls-extensions:bal-shell-service** - Ballerina shell service
64. **ls-extensions:json-to-record-converter** - JSON to record converter
65. **ls-extensions:partial-parser** - Partial parser
66. **ls-extensions:performance-analyzer-services** - Performance analyzer services
67. **ls-extensions:trigger-service** - Trigger service
68. **json-mapper** - JSON mapper
69. **xml-to-record-converter** - XML to record converter

## Compiler Plugins

70. **compiler-plugins:configurable-schema-generator** - Configurable schema generator
71. **compiler-plugins:package-semantic-analyzer** - Package semantic analyzer

## Version Management

72. **semver-checker:semver-checker-core** - Semantic version checker core
73. **semver-checker:semver-checker-cli** - Semantic version checker CLI

## Final Target

74. **jballerina-tools** - Main Ballerina tools distribution

## Total Modules: 74

This represents all the modules that need to be built in order to create the jballerina-tools distribution.

## Key Dependency Relationships

### Core Dependency Chain:
1. **io.ballerina.tools.api** (base)
2. **io.ballerina.identifier** (base)
3. **io.ballerina.toml** → requires tools.api, identifier
4. **io.ballerina.runtime** → requires toml, tools.api, identifier
5. **io.ballerina.central.client** → requires runtime
6. **io.ballerina.parser** → requires tools.api
7. **io.ballerina.lang** → requires runtime, parser, tools.api, toml, central.client, semtype, identifier

### Langlib Dependencies:
- All langlib modules depend on **io.ballerina.runtime**
- No inter-langlib dependencies (all are independent)

### Tools Dependencies:
- Most tools depend on **io.ballerina.lang** and **io.ballerina.parser**
- CLI tools depend on **io.ballerina.cli**
- Language server modules have their own dependency chain

### External Dependencies:
- **com.google.gson** - Used by many modules for JSON processing
- **org.apache.commons.text** - Used by identifier-util and toml-parser
- **org.slf4j** - Logging framework used by several modules
- **java.* modules** - Standard Java modules (xml, logging, management, etc.)
