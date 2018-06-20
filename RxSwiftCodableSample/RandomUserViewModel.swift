//
//  RandomUserViewModel.swift
//  RxSwiftCodableSample
//
//  Created by cano on 2018/06/20.
//  Copyright © 2018年 sample. All rights reserved.
//

import APIKit
import RxSwift
import RxCocoa
import NSObject_Rx

struct RandomUserViewModel {

    // MARK: - Model
    //let model: RandomUserViewModel

    // MARK: - rx

    /// ローディング中ならtrue
    var isLoading: Variable<Bool> = Variable(false)

    /// APIで取得したResultListModel
    var item: Variable<ResultListModel?> = Variable(nil)
    
    init() {
    }

    /// RandomUser APIのレスポンス取得
    func fetch() -> Observable<ResultListModel> {
        // RXSwift + APIKit を利用してAPIをコール
        return FetchRandomUserRequest().asObservable().do(onNext: { responseData in
            self.item.value = responseData
        }, onError : { error in
            print(error)
            self.isLoading.value = false
        }, onCompleted: {
            self.isLoading.value = false
        }, onSubscribed: {
            self.isLoading.value = true
        })
    }
}
