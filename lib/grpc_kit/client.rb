# frozen_string_literal: false

require 'socket'
require 'grpc_kit/grpc_time'
require 'grpc_kit/streams/client_stream'
require 'grpc_kit/sessions/client_session'
require 'grpc_kit/session/io'
require 'grpc_kit/rpcs'
require 'grpc_kit/transports/client_transport'

module GrpcKit
  class Client
    def initialize(host, port, interceptors: [], timeout: nil)
      @host = host
      @port = port
      @authority = "#{host}:#{port}"
      @interceptors = interceptors
      @timeout = timeout && GrpcKit::GrpcTime.new(timeout)
    end

    def request_response(rpc, request, opts = {})
      GrpcKit.logger.debug('Calling request_respose')

      rpc.config.interceptor.interceptors = @interceptors
      do_request(rpc, request, opts)
    end

    def client_streamer(rpc, opts = {})
      GrpcKit.logger.debug('Calling client_streamer')
      rpc.config.interceptor.interceptors = @interceptors
      do_request(rpc, nil, opts)
    end

    def server_streamer(rpc, request, opts = {})
      GrpcKit.logger.debug('Calling server_streamer')
      rpc.config.interceptor.interceptors = @interceptors
      do_request(rpc, request, opts)
    end

    def bidi_streamer(rpc, requests, opts = {})
      rpc.config.interceptor.interceptors = @interceptors
      GrpcKit.logger.debug('Calling bidi_streamer')
    end

    private

    def do_request(rpc, request, **opts)
      sock = TCPSocket.new(@host, @port) # XXX
      session = GrpcKit::Sessions::ClientSession.new(GrpcKit::Session::IO.new(sock))
      session.submit_settings([])

      t = GrpcKit::Transports::ClientTransport.new(session)
      cs = GrpcKit::Streams::ClientStream.new(t, rpc.config, authority: @authority, timeout: @timeout)
      rpc.invoke(cs, request, opts.merge(timeout: @timeout))
    end
  end
end
