module ServiceActorArguments
  FORBID_NIL_VALUES =  {
    is: false,
    message: ->(input_key:, **) { "The value \"#{input_key}\" cannot be empty" }
  }
  MUST_BE_A_NUMBER = {
    is: [ Integer ],
    message: ->(input_key:, **) { "The value \"#{input_key}\" must be a number" }
  }

  MUST_BE_A_POSITIVE_NUMBER = {
    is: ->(value) { value.positive? },
    message: ->(input_key:, **) { "The value \"#{input_key}\" must be positive" }
  }

  MUST_BE_A_NUMBER_OR_FLOAT = {
    is: [ Integer, Float ],
    message: ->(input_key:, **) { "The value \"#{input_key}\" must be a number" }
  }
end
