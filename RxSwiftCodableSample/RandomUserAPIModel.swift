//
//  RandomUserAPIModel.swift
//  RxSwiftCodableSample
//
//  Created by cano on 2018/06/20.
//  Copyright © 2018年 sample. All rights reserved.
//

import APIKit
import RxSwift

// https://codezine.jp/article/detail/10532?p=2
// RandomUser APIのレスポンスを受けとるオブジェクト
// resultsを格納する構造体
struct ResultListModel:Codable{
    let results : [Person]
}

// ユーザー情報を格納する構造体
struct Person: Codable  {
    let gender: String

    let name: Name
    struct Name: Codable  {
        let title: String
        let first: String
        let last: String
    }

    let location: Location
    struct Location: Codable  {
        let street: String
        let city: String
        let state: String
        let postcode: String

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            street   = try container.decode(String.self, forKey: .street)
            city     = try container.decode(String.self, forKey: .city)
            state    = try container.decode(String.self, forKey: .state)
            // postcodeはSting/Intのどちらかでくる Expected to decode Int but found a string/data instead. 対策
            if let value = try? container.decode(Int.self, forKey: .postcode) {
                postcode = String(value)
            } else {
                postcode = try container.decode(String.self, forKey: .postcode)
            }
        }
    }

    let email: String

}

// RandomUser APIへのリクエスト定義
// リクエストの定義 Request プロトコルに適合させ、最低5つの項目を実装する
// ・associatedtype Response
// ・var baseURL: URL { get }
// ・var method: HTTPMethod { get }
// ・var path: String { get }
// ・func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response
protocol RandomUserRequest: Request {
    
}

extension RandomUserRequest {
    var baseURL: URL {
        return URL(string: "https://randomuser.me/api/")!
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}

struct FetchRandomUserRequest: RandomUserRequest {
    typealias Response = ResultListModel

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return ""
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> ResultListModel {
        let decoder = JSONDecoder()
        return try decoder.decode(ResultListModel.self, from: object as! Data)
    }

    // Codable用
    var dataParser: DataParser {
        return JSONDataParser()
    }

    // RxSwift の Observable を実装したインターフェース
    public func asObservable() -> Observable<Response> {
        return Session.sendRandomUserRequest(self)
    }
}

// Codable用パーサークラス
class JSONDataParser: APIKit.DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        // ここではデコードせずにそのまま返す
        return data
    }
}
