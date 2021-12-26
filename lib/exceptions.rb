class InvalidValueError < StandardError; end
class InvalidNumberError < InvalidValueError; end
class StackOutOfBoundError < InvalidValueError; end
class EmptyDataStackError < RuntimeError; end
class InfiniteExecutionError < RuntimeError; end
