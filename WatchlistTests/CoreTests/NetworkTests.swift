import XCTest
@testable import Watchlist

final class NetworkTests: XCTestCase {
    func test_requestEncodesQueryAndJSONBody() throws {
        let request = try AuthRequest.newAuthSessionId(requestToken: "test-token").request()
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.url?.scheme, "https")
        let body = try XCTUnwrap(request.httpBody)
        let json = try JSONSerialization.jsonObject(with: body) as? [String: String]
        XCTAssertEqual(json?["request_token"], "test-token")
    }

    func test_strategiesPreservePageAndEndpoint() throws {
        let strategies: [(MediaListFetchStrategy, String)] = [
            (PopularMoviesFetchStrategy(), "/movie/popular"),
            (UpcomingMoviesFetchStrategy(), "/movie/upcoming"),
            (NowPlayingMoviesFetchStrategy(), "/movie/now_playing"),
            (AiringTodaySeriesFetchStrategy(), "/tv/airing_today"),
            (OnTheAirSeriesFetchStrategy(), "/tv/on_the_air"),
            (PopularSeriesFetchStrategy(), "/tv/popular")
        ]
        for (strategy, path) in strategies {
            let request = strategy.fetch(page: 7)
            XCTAssertEqual(request.path, path)
            let url = try XCTUnwrap(request.request().url)
            let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
            XCTAssertEqual(components.queryItems?.first { $0.name == "page" }?.value, "7")
        }
    }

    func test_parserDecodesAndRejectsMalformedPayloads() throws {
        struct Payload: Decodable { let count: Int }
        let parser = DefaultDataParser()
        let payload: Payload = try parser.parse(data: Data(#"{"count":3}"#.utf8))
        XCTAssertEqual(payload.count, 3)
        XCTAssertThrowsError(try parser.parse(data: Data("invalid".utf8)) as Payload)
    }

    func test_requestManagerUsesInjectedTransport() async throws {
        let manager = DefaultRequestManager(apiManager: APIManagerStub())
        let value: [String: Int] = try await manager.initRequest(with: MovieRequest.getPopularMovies(page: 1))
        XCTAssertEqual(value["count"], 3)
    }

    func test_errorAdapterSupportsOrdinaryErrors() {
        XCTAssertNil(LocalizedAlertError(error: nil))
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Offline"])
        XCTAssertEqual(LocalizedAlertError(error: error)?.errorDescription, "Offline")
    }

    func test_fetcherRetriesFailedPageAndDeduplicatesCumulativeResults() async throws {
        let service = MediaServiceMock()
        let strategy = PageRecordingStrategy()
        let fetcher = MediaFetcher(strategy: strategy, service: service)
        service.error = NetworkError.invalidServerResponse
        do {
            _ = try await fetcher.fetchWithNextPage()
            XCTFail("Expected failure")
        } catch { }
        service.error = nil
        service.fetchMediaCallStub = [Movie.mock]
        let first = try await fetcher.fetchWithNextPage()
        let second = try await fetcher.fetchWithNextPage()
        XCTAssertEqual(first.count, 1)
        XCTAssertEqual(second.count, 1)
        XCTAssertEqual(strategy.pages, [1, 1, 2])
    }
}

private struct APIManagerStub: APIManager {
    func initRequest(with data: NetworkRequest) async throws -> Data {
        Data(#"{"count":3}"#.utf8)
    }
}

private final class PageRecordingStrategy: MediaListFetchStrategy {
    var pages: [Int] = []
    func fetch(page: Int) -> NetworkRequest {
        pages.append(page)
        return MovieRequest.getPopularMovies(page: page)
    }
}

extension NetworkTests {
    func test_transportAcceptsEverySuccessfulHTTPStatusAndRejectsFailures() async throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [HTTPStatusURLProtocol.self]
        let session = URLSession(configuration: configuration)
        defer { session.invalidateAndCancel() }
        let sut = DefaultAPIManager(urlSession: session)
        for status in [200, 201, 204, 299] {
            let data = try await sut.initRequest(with: HTTPStatusRequest(status: status))
            XCTAssertEqual(data, Data("response".utf8))
        }
        for status in [199, 300, 401, 404, 500] {
            do {
                _ = try await sut.initRequest(with: HTTPStatusRequest(status: status))
                XCTFail("Expected HTTP \(status) to fail")
            } catch {
                XCTAssertTrue(error is NetworkError)
            }
        }
    }
}

private struct HTTPStatusRequest: NetworkRequest {
    let status: Int
    var host: String { "watchlist.test" }
    var hostPath: String { "" }
    var path: String { "/\(status)" }
    var requestType: RequestType { .GET }
}

private final class HTTPStatusURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url,
              let status = Int(url.lastPathComponent),
              let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data("response".utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
