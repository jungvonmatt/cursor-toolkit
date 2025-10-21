# AI-Powered Workflows

This guide contains workflows that leverage AI assistance for more efficient and reliable development. Each workflow combines best practices with AI capabilities to enhance your development process.

## TDD Red Green Refactor Workflow

Test-Driven Development (TDD) with AI assistance helps ensure your features are built correctly from the start. This workflow uses tests as the source of truth for feature implementation.

### Prerequisites

- Know exactly what you want your feature to do
- Have a clear understanding of the expected behavior

### Workflow Steps

1. **Use the TDD Red Green Refactor prompt**

   Use the [TDD Red Green Refactor prompt](../prompts/prompt_tdd-red-green-refactor.md) to guide the AI through the process

   _Drag the prompt into the Cursor chat._

2. **Review and refine the tests**

   - Carefully check all generated tests
   - Ensure tests accurately reflect your feature requirements
   - The AI will use these tests as the source of truth for implementation
   - Make any necessary adjustments before proceeding

3. **Let AI implement based on tests**

   - Once tests are correct, the AI will code to make them pass
   - The implementation will match exactly what your tests expect

### Why This Works

By reviewing tests before implementation, you ensure the AI understands your requirements perfectly. The tests become a contract that guides the entire development process, resulting in features that work exactly as intended.
