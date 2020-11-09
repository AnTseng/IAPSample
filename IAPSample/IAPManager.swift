//
//  IAPManager.swift
//  IAPSample
//
//  Created by Ann on 2020/11/9.
//

// 開發 IAP 功能須 import StoreKit
import StoreKit

protocol IAPManagerDelegate: class {
    func getItems()
}

// 繼承 NSObject，因為 SKProductsRequestDelegate 繼承 NSObjectProtocol，繼承 NSObject 可幫我們定義 NSObjectProtocol 的相關 function
class IAPManager: NSObject {
    
    static let shared = IAPManager()
    var products = [SKProduct]()
    weak var delegate: IAPManagerDelegate?
    fileprivate var productRequest: SKProductsRequest!
    
    func getProductIDs() -> [String] {
        return ["CMoney.PurchaseSample.ConsumableTest",
                "CMoney.PurchaseSample.NonConsumableTest",
                "CMoney.PurchaseSample.AutoRenewableSubTest",
                "CMoney.PurchaseSample.NonRenewableSubTest"]
    }
    
    func getProducts() {
        let productIds = getProductIDs()
        let productIdsSet = Set(productIds)
        // 利用 SKProductsRequest 連到 Apple 後台詢問商品資訊，將 IAPManager 自己設為 request 的 delegate
        productRequest = SKProductsRequest(productIdentifiers: productIdsSet)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func buy(product: SKProduct) {
        //  iPhone 有可能 IAP 功能被限制，比方父母將小孩 iPhone 的購買功能關閉
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            // show error
        }
    }
    
}

extension IAPManager: SKProductsRequestDelegate {
    // response 的 products 取得商品的 array
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.products.forEach {
            print($0.localizedTitle, $0.price, $0.localizedDescription)
        }
        self.products = response.products
        delegate?.getItems()
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    // 交易狀態改變時觸發的 function paymentQueue(_:updatedTransactions:)
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        transactions.forEach {
            // SKPaymentTransaction 的 payment.productIdentifier 知道購買的商品，
            // 從 transactionState 知道交易的狀態
            print($0.payment.productIdentifier, $0.transactionState.rawValue)
            switch $0.transactionState {
            case .purchased:
                // 要呼叫 finishTransaction 完成交易，
                // 否則 iOS 會以為交易還未完成，下次打開 App 時會再觸發 paymentQueue(_:updatedTransactions:)
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print($0.error ?? "")
                if ($0.error as? SKError)?.code != .paymentCancelled {
                    // show error
                }
                
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                SKPaymentQueue.default().finishTransaction($0)
            case .purchasing, .deferred:
                break
            @unknown default:
                break
            }
        }
    }
}

// Apple 將依據使用者帳號所在的國家回傳正確的金額
extension SKProduct {
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}


