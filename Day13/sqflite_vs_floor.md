## sqflite vs Floor

### sqflite

sqflite provides direct access to SQLite and gives developers more control over SQL queries and database operations.

**Advantages**

- Direct SQLite access
- Flexible SQL queries
- Simple for small applications
- Lightweight approach

**Disadvantages**

- More manual database code
- No built-in Entity/DAO structure
- More responsibility for mapping data

### Floor

Floor is an ORM for SQLite in Flutter. It provides Entities, DAOs, annotations, and generated database code.

**Advantages**

- Type-safe database operations
- Structured Entity and DAO pattern
- Less repetitive database code
- Easier to organize complex databases
- Supports migrations

**Disadvantages**

- Requires code generation
- More setup than direct sqflite
- Generated files must be rebuilt after changes

### When to use each

**Use sqflite when:**

- The application is simple.
- Direct SQL control is preferred.
- The database structure is small.

**Use Floor when:**

- The application has multiple entities.
- A structured database architecture is needed.
- Type safety and Entities/DAOs are preferred.

### Performance

Both Floor and sqflite use SQLite underneath, so performance is generally similar. The main difference is the development approach and abstraction level.