# TDD Red-Green-Refactor Prompt

I want you to implement a new feature using strict Test-Driven Development (TDD) methodology. Follow the red-green-refactor cycle precisely:

## TDD Rules:

1. **Write tests BEFORE implementation** - No production code without a failing test
2. **One test at a time** - Focus on the smallest possible unit of functionality
3. **Minimal implementation** - Write only enough code to make the test pass
4. **Refactor after green** - Clean up only when tests are passing

## Process to follow:

### 🔴 RED Phase (Write Failing Test)

1. Identify the smallest testable behavior
2. Write a test that describes this behavior
3. Run the test and confirm it fails
4. The test should fail because the functionality doesn't exist yet

### 🟢 GREEN Phase (Make Test Pass)

1. Write the minimal code to make the test pass
2. Don't worry about elegance or optimization
3. Focus only on making the test green
4. Run the test and confirm it passes

### 🔵 REFACTOR Phase (Improve Code)

1. Clean up the implementation while keeping tests green
2. Remove duplication
3. Improve naming and structure
4. Run tests after each change to ensure they still pass

## Implementation Steps:

For each piece of functionality:

1. **Describe the requirement** in plain language
2. **Write the test first** showing expected behavior
3. **Show the test failing** with actual error message
4. **Implement minimal solution** to pass the test
5. **Show the test passing**
6. **Refactor if needed** while keeping tests green
7. **Move to next requirement**

## Example Format:

````
📋 Requirement: [Description of what we're building]

🔴 RED: Writing failing test
```[language]
// Test code here
````

Running test... ❌ FAILED
Error: [Actual error message]

🟢 GREEN: Minimal implementation

```[language]
// Implementation code here
```

Running test... ✅ PASSED

🔵 REFACTOR: Improving code

```[language]
// Refactored code here
```

Running test... ✅ STILL PASSING

```

## Additional Guidelines:
- Each test should test ONE thing
- Test names should describe the expected behavior
- Use AAA pattern: Arrange, Act, Assert
- Keep tests independent and isolated
- Mock external dependencies
- Focus on behavior, not implementation details

## Feature to implement:
[Describe your feature here]

---

Now begin the TDD cycle with the first small piece of functionality.
```
