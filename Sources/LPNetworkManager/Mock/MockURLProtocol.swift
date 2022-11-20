//
//  MockURLProtocol.swift
//
//
//  Created by Lukas Pistrol on 05.11.22.
//

import Foundation

/// A subclass of `URLProtocol` which mocks a `HTTPURLResponse` for a given `URLRequest`.
///
/// - Note: This should only be used for testing purposes in unit test classes. A sample of how to use this
/// can be found in this package's tests folder.
@available(watchOS, unavailable)
final public class MockURLProtocol: URLProtocol {

    private struct MockConfiguration {
        var response: HTTPURLResponse
        var data: Data?
    }

    private static var requestHandler: ((URLRequest) throws -> MockConfiguration)?

    public static func setRequestHandler(with data: Data?,
                                         statusCode: Int = 200,
                                         httpVersion: String? = nil,
                                         headerFields: [String: String]? = nil) {
        requestHandler = { request in
            guard let url = request.url else { throw URLError(.badURL) }

            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: httpVersion,
                headerFields: headerFields
            )!

            return MockConfiguration(response: response, data: data)
        }
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        guard let requestHandler = MockURLProtocol.requestHandler else { return }

        do {
            let config = try requestHandler(request)

            client?.urlProtocol(
                self,
                didReceive: config.response,
                cacheStoragePolicy: .notAllowed
            )

            if let data = config.data {
                client?.urlProtocol(self, didLoad: data)
            } else {
                client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            }

            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    public override func stopLoading() {}
}
