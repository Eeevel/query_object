module Query
  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(params)
    @params = params
  end

  def query
    params_for_query = available_params.map do |p|
      "#{p}: #{value_for(p)}" if value_for(p)
    end.compact
    "Select with: #{params_for_query}"
  end

  def params
    @params
  end

  def available_params
    self.class.available_params
  end

  def default_values
    self.class.default_values
  end

  def value_for(parameter)
    params[parameter] || default_values[parameter]
  end

  module ClassMethods
    def available_params(*available_params)
      @available_params ||= available_params
    end

    def default_values(*default_params)
      @default_values ||= {}
      @default_values[default_params.first] = default_params.last unless default_params.empty?
      @default_values
    end
  end
end

class UsersQuery
  include Query

  available_params :active, :client_id, :name
  default_values :active, 1
  default_values :name, 'test'

  def call
    query
  end
end

params = {
  name: 'Name',
  client_id: 200
}

puts UsersQuery.new(params).call
