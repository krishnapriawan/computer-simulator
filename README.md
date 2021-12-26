# Computer Simulator
This project is to demonstrate how computer executes set of instructions with program counter (PC) and instruction register

## Prequisities
- Ruby 
- Bundler `>= 1.16.6`

## Installation
```
bundle install --path .bundle
```

## Testing
```
bundle exec rspec .
```

## Assumptions
- Size of stack is fixed during `insert()` operation (before `execute()` starts). Thus, we are not able to insert instructions at out of bounds address.
- Size of stack might increase dynamically during execution as the number of data that we push to stack might be more than the initial size of stack.
- Execution will stop when the data in the address is `STOP` or `nil`
- Each address will be only executed once during execution