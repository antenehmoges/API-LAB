# Lab Equipment API

A Rails API for tracking lab equipment, categories, and maintenance records.

## Requirements

- Ruby 3.2+
- Rails 7.1+
- SQLite3

## Setup

```bash
# 1. Install dependencies
bundle install

# 2. Create and migrate the database
bin/rails db:create db:migrate

# 3. Verify schema (check all columns, indexes, foreign keys)
# Open db/schema.rb and review

# 4. Seed the database
bin/rails db:seed

# 5. Verify seed data in console
bin/rails console
> Category.count      # => 4
> Equipment.count     # => 8
> MaintenanceRecord.count  # => 5

# 6. Run the server
bin/rails server
```

## Validation Tests in Console

```ruby
bin/rails console

# Should be false (blank name, invalid status)
Equipment.new(name: "", status: "broken").valid?
# => false

# Should be false (future date, blank description)
MaintenanceRecord.new(description: "", performed_at: 1.week.from_now).valid?
# => false

# Serial number format
Equipment.new(name: "Test", serial_number: "lap-001", status: "available", category_id: 1).valid?
# => false (lowercase not allowed)

Equipment.new(name: "Test", serial_number: "LAP-001", status: "available", category_id: 1).valid?
# => true (if category 1 exists and serial not taken)

# Category name minimum length
Category.new(name: "AB").valid?
# => false

Category.new(name: "ABC").valid?
# => true (if name not taken)
```

## API Endpoints

### Categories
| Method | Path              | Description                        |
|--------|-------------------|------------------------------------|
| GET    | /categories       | List all, ordered by name          |
| GET    | /categories/:id   | Show one with equipment count      |
| POST   | /categories       | Create                             |
| PATCH  | /categories/:id   | Update                             |
| DELETE | /categories/:id   | Delete (409 if equipment exists)   |

### Equipment
| Method | Path            | Description                                      |
|--------|-----------------|--------------------------------------------------|
| GET    | /equipment      | List all (supports ?status= filter), with category |
| GET    | /equipment/:id  | Show one with category + maintenance records     |
| POST   | /equipment      | Create                                           |
| PATCH  | /equipment/:id  | Update                                           |
| DELETE | /equipment/:id  | Delete (cascades maintenance records)            |

### Maintenance Records
| Method | Path                     | Description                               |
|--------|--------------------------|-------------------------------------------|
| GET    | /maintenance_records     | List all (supports ?equipment_id= filter) |
| GET    | /maintenance_records/:id | Show one with equipment name              |
| POST   | /maintenance_records     | Create                                    |
| PATCH  | /maintenance_records/:id | Update                                    |
| DELETE | /maintenance_records/:id | Delete                                    |

## Status Codes

| Situation                          | Code |
|------------------------------------|------|
| Created                            | 201  |
| Read / Updated                     | 200  |
| Deleted                            | 204  |
| Not found                          | 404  |
| Validation failed                  | 422  |
| Cannot delete (has equipment)      | 409  |

## Business Rules

1. **Serial number format**: Must be XXX-NNN (3 uppercase letters, dash, 3 digits). Valid: `LAP-001`, `MIC-042`.
2. **Maintenance date**: `performed_at` cannot be in the future.
3. **Category name**: Minimum 3 characters.
4. **Equipment name**: Minimum 3 characters AND must contain at least one letter.

## Error Formats

Validation errors:
```json
{"errors": ["Name can't be blank", "Serial number has already been taken"]}
```

Not found:
```json
{"error": "Category not found"}
```

Conflict:
```json
{"error": "Cannot delete category. 4 equipment items still belong to it."}
```

## Curl Commands

See `curl_commands_and_responses.txt` for the full list of curl commands
and expected responses for all endpoints and all 10 edge cases.
