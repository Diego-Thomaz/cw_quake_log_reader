# Quake Log Reader

A parser that reads quake log and return 3 different reports: Grouped Information Per Match, Player Rank and Death Causes Per Match

## Requirements

Ruby 3.2.2

## Instalation

First, clone the project.

And then execute:

`bundle install`

## Usage

The parser is really simple to use. You just need to run

`ruby run.rb`

This command will print all 3 reports at once. It might be useful to print them in separate. The following parameters can be passed to be able to get the specific reports

`ruby run.rb gi` -> Will print Grouped Information Per Match Report Only

`ruby run.rb pr` -> Will print Player Rank Only

`ruby run.rb dr` -> Will print Death Reasons Report Only

## Architecture

This is a simple Ruby app. Log reader uses an efficient way to read files.
The way it's implemented it won't blow up the memory, because `each_line` read up until the next newline, return, and pause reading.
When all lines are read, a printer function is called to show the results.

## Tests

To run the whole test suite, you can execute:
`bundle exec rspec`

Current test coverage is: 100%

## Linter

`bundle exec rubocop`
