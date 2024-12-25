# app/commands/base_command.rb

class BaseCommand
  include ActiveModel::Model

  attr_accessor :errors

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  def success?
    errors.empty?
  end
end
