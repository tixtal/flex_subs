module FlexSubs
  class Error < StandardError; end
  class CannotConsumeError < Error; end
  class DoubleSuppressError < Error; end
  class DoubleCancelError < Error; end
  class DoublePlanError < Error; end
  class NoActiveSubscriptionError < Error; end
  class NotRenewablePlanError < Error; end
  class InvalidConsumptionAmountError < Error; end
end