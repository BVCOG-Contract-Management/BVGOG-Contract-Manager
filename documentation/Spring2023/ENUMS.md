# How to create new Enums

## Requirements
`gem 'enumerate_it', '~> 3.2.4'`

## Create Enum
`rails g enumerate_it:enum <enum_name> <enum_value_1> <enum_value_2> ... <enum_value_n>`

```
example:
rails g enumerate_it:enum status active inactive
```
This will create two files:
```
- app/enumerations/<enum_name>.rb --> Enum class
- config/locales/<enum_name>.yml --> Enum translations to English
```