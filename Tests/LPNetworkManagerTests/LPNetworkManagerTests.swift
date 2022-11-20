//
//  LPNetworkManagerTests.swift
//
//
//  Created by Lukas Pistrol on 05.11.22.
//

import XCTest
@testable import LPNetworkManager

#if !os(watchOS)

/// This is a test setup which shows how to implement the `MockURLProtocol`
/// for unit tests.
///
/// The function `setRequestHandler(with:statusCode:)` sets up the response
/// you expect from the simulated API call.
///
/// You can pass in a data object and a status code for the response.
final class LPNetworkManagerTests: XCTestCase {

    var networkManager: LPNetworkManager!
    let url = URL(string: "https://reddit.com/r/programming.json")!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Setup our mock session configuration and set
        // The `MockURLProtocol` as the only protocol class.
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [MockURLProtocol.self]

        // Instantiate a new `URLSession` with the mock config.
        let urlSession = URLSession(configuration: sessionConfig)

        // Now setup the network manager with the custom `URLSession`.
        self.networkManager = .init(urlSession: urlSession)
    }

    func testNetworkManager() async throws {
        // Set the request handler to whatever you want your mock
        // server to respond.
        //
        // In this case we test for a unsuccessful server response
        // so we won't return any data.
        MockURLProtocol.setRequestHandler(with: nil, statusCode: 504)

        // Make the api call and test the response.
        do {
            _ = try await networkManager.data(from: url)
            XCTFail("This should not succeed")
        } catch {
            XCTAssertEqual((error as! URLError).code, .badServerResponse)
        }
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.networkManager = nil
    }
}

#endif
