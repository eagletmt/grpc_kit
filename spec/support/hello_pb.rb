# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: hello.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "hello.Request" do
    optional :msg, :string, 1
  end
  add_message "hello.Response" do
    optional :msg, :string, 1
  end
end

module Hello
  Request = Google::Protobuf::DescriptorPool.generated_pool.lookup("hello.Request").msgclass
  Response = Google::Protobuf::DescriptorPool.generated_pool.lookup("hello.Response").msgclass
end