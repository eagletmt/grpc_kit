# frozen_string_literal: true

require 'grpc_kit/grpc_time'

module GrpcKit
  module Session
    class Headers
      # = Struct.new(
      #   :metadata,
      #   :path,
      #   :grpc_encoding,
      #   :grpc_status,
      #   :status_message,
      #   :timeout,
      #   :method,
      #   :http_status,
      # ) do

      RESERVED_HEADERS = [
        'content-type',
        'user-agent',
        'grpc-message-type',
        'grpc-encoding',
        'grpc-message',
        'grpc-status',
        'grpc-status-details-bin',
        'grpc-accept-encoding',
        'te'
      ].freeze

      IGNORE_HEADERS = [':method', ':scheme'].freeze

      PATH = ':path'
      STATUS = ':status'
      CONTENT_TYPE = 'content-type'
      GRPC_ENCODING = 'grpc-encoding'
      GRPC_STATUS = 'grpc-status'
      GRPC_TIMEOUT = 'grpc-timeout'

      METADATA_ACCEPTABLE_HEADER = %w[:authority user-agent].freeze
      def initialize
        @opts = {}
        @metadata = nil
      end

      def metadata
        @metadata ||=
          begin
            m = {}
            @opts.each do |key, val|
              if IGNORE_HEADERS.include?(key)
                next
              end

              if RESERVED_HEADERS.include?(key) && !METADATA_ACCEPTABLE_HEADER.include?(key)
                next
              end

              m[key] = val
            end

            m
          end
      end

      def path
        @opts[PATH]
      end

      def grpc_encoding
        @opts[GRPC_ENCODING]
      end

      def grpc_status
        @opts[GRPC_STATUS]
      end

      def status_message
        @opts['grpc-message']
      end

      def timeout
        @timeout ||= GrpcTime.new(@opts[GRPC_TIMEOUT])
      end

      # def method
      #   @timeout ||= GrpcTime.new(@opts[GRPC_TIMEOUT])
      # end

      def http_status
        Integer(@opts[STATUS])
      end

      def add(key, val)
        @opts[key] = val

        # if key == PATH
        #   self.path = val
        # elsif key == STATUS
        #   self.http_status = Integer(val)
        # elsif key == CONTENT_TYPE
        # #
        # elsif key == GRPC_ENCODING
        #   self.grpc_encoding = val
        # elsif key == GRPC_STATUS
        #   self.grpc_status = val
        # elsif key == GRPC_ENCODING
        #   self.grpc_encoding = val
        # elsif key == GRPC_STATUS
        #   self.grpc_status = val
        # elsif key == GRPC_TIMEOUT
        #   self.timeout = GrpcTime.new(val)
        # elsif key == 'grpc-message'
        #   self.status_message = val
        # elsif key == 'grpc-status-details-bin'
        #   GrpcKit.logger.warn('grpc-status-details-bin is unsupported header now')

        #   # self.status_message = val
        # else
        #   if IGNORE_HEADERS.include?(key)
        #     return
        #   end

        #   if RESERVED_HEADERS.include?(key) && !METADATA_ACCEPTABLE_HEADER.include?(key)
        #     return
        #   end

        #   metadata[key] = val
        # end

        # case key
        # when PATH
        # when STATUS
        #   self.http_status = Integer(val)
        # when CONTENT_TYPE
        # # self.grpc_encoding = val
        # when GRPC_ENCODING
        #   self.grpc_encoding = val
        # when GRPC_STATUS
        #   self.grpc_status = val
        # when GRPC_TIMEOUT
        #   self.timeout = GrpcTime.new(val)
        # when 'grpc-message'
        #   self.status_message = val
        # when 'grpc-status-details-bin'
        #   # TODO
        #   GrpcKit.logger.warn('grpc-status-details-bin is unsupported header now')
        # else
        # end
      end
    end
  end
end
