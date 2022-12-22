module ParamsMethods
  def self.included(host_class)
    host_class.extend(ClassMethods)
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

  def default_value
    self.class.default_value
  end

  def value_for(parameter)
    params[parameter] || default_value[parameter]
  end

  module ClassMethods
    def available_params(*available_params)
      @available_params = available_params unless defined? @available_params
      @available_params
    end

    def default_value(*default_params)
      @default_value = {} unless defined? @default_value
      @default_value[default_params.first] = default_params.last unless default_params.empty?
      @default_value
    end
  end
end

class UsersQuery
  include ParamsMethods

  available_params :active, :client_id, :name
  default_value :active, 1
  default_value :name, 'test'

  def call
    query
  end
end

params = {
  name: 'Name',
  client_id: 200
}

puts UsersQuery.new(params).call
