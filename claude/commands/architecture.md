Start by listing the projects in the CWD (current working directory) as a guideline, projects typically reside in the `packages`, `root`, `apps`, `pkg` directories.

Extract the architecture of each project in the CWD into an AF (architecture file) named `architecture.md` at the project's root.

The architecture file should be structured as follows:

```
# <PROJECT_NAME>

<description of the project>

## Structure

<diagram of the project's structure>


\`\`\` (This is an example of a structure diagram for a project)
.
├── e2e                       # test end to end
│   ├── util                  # shared code between tests
│   └── {model}.test.ts       # test files
├── fixtures                  # Data added for development and for testing
├── prisma
│   ├── migrations            # generated migrations by prisma
│   └── schema.prisma         # database schema
├── src                       # Source files of the server
│   ├── adapters              # Adapters for clients of different systems (sentry, redis, postgres) most likely if you need to do a network call to a system the client must be wrapped in an adapter
│   ├── helpers               # Utility functions that are shared across services, don't contain business logic
│   ├── metrics               # Prometheus metrics setup
│   ├── operations            # Endpoint handlers for the api
│   ├── servers               # Definition of http application servers each file is a different server
│   ├── services              # Services are the business logic of the application, they contain the business logic and are used by the operations. The services are the only place where the database is accessed.
│   ├── config.ts             # Configuration schema and parsing of the server environment variables
│   ├── const.ts              # Global constants used by the server
│   ├── errors.ts             # Error handling logic of the server
│   ├── index.ts              # Entrypoint of the server
│   ├── mappings.ts           # Mappings between the api models and the database models
│   └── resolvers.ts          # Definition of the resolvers which is the operation handlers
├── api.ts                    # Definitions of the api this can be imported by other projects to extend the api or generate clients
├── build.ts                  # Build script for the server
├── generator.ts              # Generator script for the operations that uses the api definition
├── vite.config.ts            # e2e tests configuration
└── package.json              # package.json for the project
\`\`\`

## Guidelines

<General guidelines that are followed by the project>

For example: (This is an example DON'T USE THIS EXAMPLE IN THE FILE)

- This project is tested using e2e tests & unit tests. There are no integration tests and no mocking. Mocking often causes higher coupling with the implementation and makes the tests less reliable and slows down development because changes in the internal implementation require changes in the tests. [Mocking is a code smell](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a)

- Use `index.ts` as modules to export the content of a folder. This makes the folder structure more predictable and easier to navigate. It also makes it easier to refactor the codebase. All the services are exported in the `index.ts` of the `services` folder. All the operations are exported in the `index.ts` of the `operations` folder.

- The use of `classes` in the project should be minimal and only used when necessary. The pattern used is usually closures or singletons to encapsulate the state of the application. This makes the codebase more predictable and easier to reason about. The `Batch` class helper is a really good example of when to use a class where the state of the application is encapsulated and requires a state machine.

## Patterns

<Patterns that are followed by the project>

For example: (This is an example DON'T USE THIS EXAMPLE IN THE FILE)

This project uses different coding patterns to make the codebase more maintainable and readable. He's some of the patterns used:

- [`Bouncer` Pattern](https://wiki.c2.com/?BouncerPattern) instead of using a lot of if statements to check if something is valid, we use a function starting with the prefix `validate` that throws an error if the input is invalid.
- [`Return Early` Pattern](https://medium.com/swlh/return-early-pattern-3d18a41bba8) the positive result is returned at the end of the function, and the negative result is returned as soon as possible.

## Namings

<Naming conventions that are followed by the project>

For example: (This is an example DON'T USE THIS EXAMPLE IN THE FILE)

The naming convention followed in this project is:

- The `validate` function throws an error if the input is invalid
- The `is` function prefix is a type guard that returns a boolean
- The `Operation` variable suffix is used for the operation definitions

```
