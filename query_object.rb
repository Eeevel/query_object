module Params
  def self.included(host_class)
    host_class.extend(ClassMethods)
  end

  def initialize(params)
    params.each do |k, v|
      next eval("set_#{k}('#{v}')") if v.instance_of?(String)
      eval("set_#{k}(#{v})")
    end
  end

  module ClassMethods
    def available_params(*params)
      params.each do |parameter|
        define_method(parameter) do
          instance_variable_get("@#{parameter}") || (eval("default_#{parameter}") if respond_to?("default_#{parameter}"))
        end

        define_method("set_#{parameter}") do |value|
          instance_variable_set("@#{parameter}", value)
        end
      end
    end

    def default_value(*params)
      define_method("default_#{params.first}") do
        params.last
      end
    end
  end
end

class UsersQuery
  include Params

  available_params :active, :client_id, :name
  default_value :active, 1
  default_value :name, 'test'

  def call
    "Select with active: #{active}, client_id: #{client_id}, name: #{name}"
  end
end

params = {
  name: 'Name',
  client_id: 200
}

puts UsersQuery.new(params).call
