//
//  PaymentMethodsPresenter.swift
//  FakeNFT
//
//  Created by Anton Vikhlyaev on 14.07.2023.
//

import Foundation
import SafariServices

protocol PaymentMethodsPresenterProtocol {
    var numberOfItemsInSection: Int { get }
    func viewIsReady()
    func getCurrency(at indexPath: IndexPath) -> Currency
    func didSelectItem(at indexPath: IndexPath)
    func didTapAgreementLinkLabel()
    func didTapPaymentButton()
}

final class PaymentMethodsPresenter {
    
    // MARK: - Properties
    
    weak var view: PaymentMethodsViewProtocol?
    
    private let networkService: CartNetworkServiceProtocol
    
    private let screenAssembly: ScreenAssemblyProtocol
    
    private let alertAssembly: AlertAssemblyProtocol
    
    private var selectedCurrency: Currency?
    
    // MARK: - Data Store
    
    private lazy var currencies: [Currency] = []
    
    // MARK: - Life Cycle
    
    init(
        networkService: CartNetworkServiceProtocol,
        screenAssembly: ScreenAssemblyProtocol,
        alertAssembly: AlertAssemblyProtocol
    ) {
        self.networkService = networkService
        self.screenAssembly = screenAssembly
        self.alertAssembly = alertAssembly
    }
}

// MARK: - PaymentMethodsPresenterProtocol

extension PaymentMethodsPresenter: PaymentMethodsPresenterProtocol {
    var numberOfItemsInSection: Int {
        currencies.count
    }
    
    func viewIsReady() {
        UIBlockingProgressHUD.show()
        networkService.getCurrencies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currencies):
                UIBlockingProgressHUD.dismiss()
                self.currencies = currencies
                self.view?.updateUI()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                let alert = self.alertAssembly.makeErrorAlert(with: error.localizedDescription)
                self.view?.showViewController(alert)
            }
        }
    }
    
    func getCurrency(at indexPath: IndexPath) -> Currency {
        currencies[indexPath.item]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedCurrency = currencies[indexPath.item]
    }
    
    func didTapAgreementLinkLabel() {
        guard let url = URL(string: Config.userAgreementUrl) else { return }
        let safariViewController = SFSafariViewController(url: url)
        view?.showViewController(safariViewController)
    }
    
    func didTapPaymentButton() {
        guard let selectedCurrency else { return }
        networkService.paymentWithIdCurrency(
            id: selectedCurrency.id
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let paymentStatus):
                let isSuccess = paymentStatus.success
                let paymentResultViewController = self.screenAssembly.makePaymentResultScreen(isSuccess: isSuccess, delegate: self)
                paymentResultViewController.modalPresentationStyle = .fullScreen
                view?.showViewController(paymentResultViewController)
            case .failure(let error):
                let alert = self.alertAssembly.makeErrorAlert(with: error.localizedDescription)
                self.view?.showViewController(alert)
            }
        }
    }
}

// MARK: - PaymentResultDelegate

extension PaymentMethodsPresenter: PaymentResultDelegate {
    func didTapTryAgain() {
        let alert = alertAssembly.makeRepaymentAlert(with: "Your payment did not go through") { [weak self] in
            self?.didTapPaymentButton()
        }
        view?.showViewController(alert)
    }
}