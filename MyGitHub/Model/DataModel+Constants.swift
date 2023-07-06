//
//  DataModel+Constants.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import Foundation

//MARK: Data Model
struct SearchResult: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct User: Codable {
    let login: String
    let avatarURL: String
    let userURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case userURL = "url"
    }
}

struct UserDetails: Codable {
    let name: String
    let reposURL: String
    let publicRepos: String

    enum CodingKeys: String, CodingKey {
        case name
        case reposURL = "repos_url"
        case publicRepos = "public_repos"
    }
}

struct UserRepos: Codable {
        let name: String
        let repoPrivate: Bool
        let htmlURL: String
        let stargazersCount, watchersCount: Int
        let language: String?
        let forksCount: Int

    enum CodingKeys: String, CodingKey {
        case name
        case repoPrivate = "private"
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
    }
}

//MARK: Constants
enum Constants {
    static var total_page: Int = 1
    static var page: Int = 1
    static var per_page: Int = 10
    static var search_query: String = ""
    static let baseURL = "https://api.github.com/"
    static func getURL() -> String { "\(baseURL)search/users?q=\(search_query)&order=asc" }
    static func getURLwithPaginatedResult() -> String { "\(baseURL)search/users?q=\(search_query)&order=asc&per_page=\(per_page)&page=\(page)" }
    
}

//MARK: JSON Helpers
func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
