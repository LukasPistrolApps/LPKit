//
//  LPNetworkManager.swift
//
//
//  Created by Lukas Pistrol on 05.11.22.
//

import Foundation

/// A small, lightweight wrapper class for async/await fetching on `URLSession`.
///
/// By default it gets instantiated with `URLSession.shared`. But upon testing a
/// custom `URLSession` can be passed to the initializer.
///
/// This package also provides a mocked `URLProtocol` class, which can be used
/// to setup a `URLSession` for unit testing purposes.
final public class LPNetworkManager {

    private var urlSession: URLSession

    /// Instantiates a new ``LPNetworkManager`` with a given `URLSession`.
    /// - Parameter urlSession: A `URLSession` which is
    /// `URLSession.default` by default.
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// Downloads the contents of a URL based on the specified URL request and delivers the data asynchronously.
    ///
    /// Use this method to wait until the session finishes transferring data and receive it in a single Data instance.
    /// To process the bytes as the session receives them, use bytes(for:delegate:).
    ///
    /// - Parameters:
    ///   - request: A URL request object that provides request-specific information such as the URL, cache
    ///   policy, request type, and body data or body stream.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as the transfer
    ///   progresses.
    /// - Returns: An asynchronously-delivered tuple that contains the URL contents as a Data instance, and
    /// a URLResponse.
    public func data(for request: URLRequest,
                     delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return try await urlSession.data(for: request, delegate: delegate)
    }

    /// Retrieves the contents of a URL and delivers the data asynchronously.
    ///
    /// Use this method to wait until the session finishes transferring data and receive it in a single Data instance.
    /// To process the bytes as the session receives them, use bytes(from:delegate:).
    ///
    /// - Parameters:
    ///   - url:The URL to retrieve.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as the
    ///   transfer progresses.
    /// - Returns:An asynchronously-delivered tuple that contains the URL contents as a Data instance, and a
    /// URLResponse.
    public func data(from url: URL,
                     delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return try await urlSession.data(from: url, delegate: nil)
    }

    /// Retrieves the contents of a URL based on the specified URL request and delivers an asynchronous
    /// sequence of bytes.
    ///
    /// Use this method when you want to process the bytes while the transfer is underway. You can use a
    /// for-await-in loop to handle each byte. For textual data, use the URLSession.AsyncBytes properties
    /// characters, unicodeScalars, or lines to receive the content as asynchronous sequences of those types.
    ///
    /// To wait until the session finishes transferring data and receive it in a single Data instance, use
    /// data(for:delegate:).
    ///
    /// - Parameters:
    ///   - request: A URL request object that provides request-specific information such as the URL,
    ///   cache policy, request type, and body data or body stream.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as the
    ///   transfer progresses.
    /// - Returns: An asynchronously-delivered tuple that contains a URLSession.AsyncBytes sequence
    /// to iterate over, and a URLResponse.
    public func bytes(for request: URLRequest,
                      delegate: URLSessionTaskDelegate? = nil) async throws -> (URLSession.AsyncBytes, URLResponse) {
        return try await urlSession.bytes(for: request, delegate: delegate)
    }

    /// Retrieves the contents of a given URL and delivers an asynchronous sequence of bytes.
    ///
    /// Use this method when you want to process the bytes while the transfer is underway. You
    /// can use a for-await-in loop to handle each byte. For textual data, use the URLSession.AsyncBytes
    /// properties characters, unicodeScalars, or lines to receive the content as asynchronous sequences of those types.
    ///
    /// To wait until the session finishes transferring data and receive it in a single Data instance, use
    /// data(from:delegate:).
    ///
    /// - Parameters:
    ///   - url: The URL to retrieve.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as the
    ///   transfer progresses.
    /// - Returns: An asynchronously-delivered tuple that contains a URLSession.AsyncBytes sequence to
    /// iterate over, and a URLResponse.
    public func bytes(from url: URL,
                      delegate: URLSessionTaskDelegate? = nil) async throws -> (URLSession.AsyncBytes, URLResponse) {
        return try await urlSession.bytes(from: url, delegate: delegate)
    }

    /// Retrieves the contents of a URL based on the specified URL request and delivers the URL of
    /// the saved file asynchronously.
    ///
    /// - Parameters:
    ///   - request: A URL request object that provides request-specific information such as the URL,
    ///   cache policy, request type, and body data or body stream.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as the
    ///   transfer progresses.
    /// - Returns: An asynchronously-delivered tuple that contains the location of the downloaded file
    /// as a URL, and a URLResponse.
    public func download(for request: URLRequest,
                         delegate: URLSessionTaskDelegate? = nil) async throws -> (URL, URLResponse) {
        return try await urlSession.download(for: request, delegate: delegate)
    }

    /// Retrieves the contents of a URL and delivers the data asynchronously.
    ///
    /// Use this method to wait until the session finishes transferring data and receive it in a single Data
    /// instance. To process the bytes as the session receives them, use bytes(from:delegate:).
    ///
    /// - Parameters:
    ///   - url: The URL to retrieve.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as the
    ///   transfer progresses.
    /// - Returns: An asynchronously-delivered tuple that contains the URL contents as a Data instance,
    /// and a URLResponse.
    public func download(from url: URL,
                         delegate: URLSessionTaskDelegate? = nil) async throws -> (URL, URLResponse) {
        return try await urlSession.download(from: url, delegate: delegate)
    }

    /// Resumes a previously-paused download and delivers the URL of the saved file asynchronously.
    ///
    /// Your app can obtain a resumeData object in two ways:
    /// - If your app cancels an existing transfer by calling cancel(byProducingResumeData:), the session
    /// object passes a resumeData object to the completion handler that you provided in that call.
    /// - If a transfer fails, the session object provides an NSError object either to its delegate or to the task’s
    /// completion handler. In that object, the NSURLSessionDownloadTaskResumeData key in the userInfo
    /// dictionary contains a resumeData object.
    ///
    /// - Parameters:
    ///   - resumeData: A data object that provides the data necessary to resume a download.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as
    ///   the transfer progresses.
    /// - Returns: An asynchronously-delivered tuple that contains the location of the downloaded
    /// file as a URL, and a URLResponse.
    public func download(resumeFrom resumeData: Data,
                         delegate: URLSessionTaskDelegate? = nil) async throws -> (URL, URLResponse) {
        return try await urlSession.download(resumeFrom: resumeData, delegate: delegate)
    }

    /// Uploads data to a URL based on the specified URL request and delivers the result asynchronously.
    ///
    /// - Parameters:
    ///   - request: A URL request object that provides request-specific information such as the URL,
    ///   cache policy, request type, and body data or body stream.
    ///   - bodyData: The body data for the request.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as
    ///   the transfer progresses.
    /// - Returns: An asynchronously-delivered tuple that contains any data returned by the server
    /// as a Data instance, and a URLResponse.
    public func upload(for request: URLRequest,
                       from bodyData: Data,
                       delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return try await urlSession.upload(for: request, from: bodyData, delegate: delegate)
    }

    /// Uploads data to a URL and delivers the result asynchronously.
    ///
    /// - Parameters:
    ///   - request: A URL request object that provides request-specific information such as the URL,
    ///   cache policy, request type, and body data or body stream.
    ///   - fileURL: A file URL containing the data to upload.
    ///   - delegate: A delegate that receives life cycle and authentication challenge callbacks as the
    ///   transfer progresses.
    /// - Returns: An asynchronously-delivered tuple that contains any data returned by the server as
    /// a Data instance, and a URLResponse.
    public func upload(for request: URLRequest,
                       fromFile fileURL: URL,
                       delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return try await urlSession.upload(for: request, fromFile: fileURL, delegate: delegate)
    }
}
