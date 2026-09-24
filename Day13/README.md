# Day 13 - Flutter Floor

This project demonstrates how to use **Floor** as an ORM for SQLite in Flutter.

## Packages

- `floor`
- `floor_generator`
- `build_runner`

## Features

- Floor database setup
- Entity classes
- DAO
- CRUD operations
- Search
- SQLite persistence
- Relationships
- Database migration
- Future and Stream queries

## Database Structure

The application contains:

- **Notes**
- **Categories**

Notes are related to Categories using `categoryId`.

## Entity

The `Note` and `Category` classes are defined as Floor entities using annotations such as:

- `@Entity`
- `@PrimaryKey`

## DAO

The `NoteDao` handles database operations using:

- `@Query`
- `@Insert`
- `@Update`
- `@Delete`

## Build Runner

After changing database entities or DAOs, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates the Floor database implementation.

## Migration

The database uses versioning to support schema changes.

**Migration 1 to 2** adds the `Categories` table and `categoryId` to `Notes`.

## CRUD

The application supports:

- Create notes
- Read notes
- Update notes
- Delete notes
- Search notes

## Persistence

Data is stored locally using SQLite and remains available after restarting the application.

## sqflite vs Floor

| sqflite | Floor |
|---------|-------|
| Direct SQLite access | ORM-based approach |
| Manual queries and mapping | Structured using Entities and DAOs |## sqflite vs Floor

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