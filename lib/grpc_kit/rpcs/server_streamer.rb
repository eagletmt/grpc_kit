# frozen_string_literal: true

require 'grpc_kit/rpcs/base'
require 'grpc_kit/calls/server_server_streamer'
require 'grpc_kit/calls/client_server_streamer'

module GrpcKit
  module Rpcs
    module Client
      class ServerStreamer < Base
        def invoke(session, request, authority:, metadata: {}, timeout: nil, **opts)
          cs = GrpcKit::Streams::Client.new(config: @config, session: session, authority: authority)
          call = GrpcKit::Calls::Client::ServerStreamer.new(metadata: metadata, config: @config, timeout: timeout, stream: cs)

          @config.interceptor.intercept(call, metadata) do |c, m|
            c.send_msg(request, metadata: m, last: true)
            c
          end
        end
      end
    end

    module Server
      class ServerStreamer < Base
        def invoke(stream, session)
          ss = GrpcKit::Streams::Server.new(stream: stream, session: session, config: @config)
          call = GrpcKit::Calls::Server::ServerStreamer.new(metadata: stream.headers.metadata, config: @config, stream: ss)

          if @config.interceptor
            @config.interceptor.intercept(call) do |c|
              request = c.recv(last: true)
              @handler.send(@config.ruby_style_method_name, request, c)
            end
          else
            request = call.recv(last: true)
            @handler.send(@config.ruby_style_method_name, request, call)
          end

          ss.send_trailer
        end
      end
    end
  end
end
