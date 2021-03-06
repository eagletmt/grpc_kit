# frozen_string_literal: true

module GrpcKit
  module Calls
    class Call
      Name = Struct.new(:name, :receiver)
      Reciver = Struct.new(:class)
      Klass = Struct.new(:service_name)

      # @return [GrpcKit::Calls::Call::Name] gRPC method object
      attr_reader :method

      # @return [Symbol] gRPC method name
      attr_reader :method_name

      # @return [String] gRPC service name
      attr_reader :service_name

      # @return [Hash<String, String>] gRPC metadata
      attr_reader :metadata

      # @param stream [GrpcKit::Stream::ServerStream|GrpcKit::Stream::ClientStream]
      # @param config [GrpcKit::MethodConfig]
      # @param metadata [Hash<String,String>]
      def initialize(stream:, config:, metadata:, timeout: nil)
        @config = config
        @metadata = metadata
        @method_name = @config.method_name
        @service_name = @config.service_name
        @protobuf = @config.protobuf
        @timeout = timeout
        @stream = stream

        # for compatible
        klass = Klass.new(@service_name)
        @method ||= Name.new(@method_name, Reciver.new(klass))
        @restrict = false
      end

      # @return [void]
      def restrict_mode
        @restrict = true
      end

      # @return [void]
      def normal_mode
        @restrict = false
      end

      # @return [Time] deadline of this rpc call
      def deadline
        return @deadline if instance_variable_defined?(:@deadline)

        @deadline = @timeout && @timeout.to_absolute_time
      end
    end
  end
end
