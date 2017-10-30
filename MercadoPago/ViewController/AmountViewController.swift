//
//  ViewController.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import UIKit
import SCLAlertView

extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
struct Formatter {
    static let decimal = NumberFormatter(numberStyle: .decimal)
}
extension UITextField {
    var string: String { return text ?? "" }
}

extension String {
    private static var digitsPattern = UnicodeScalar("0")..."9"
    var digits: String {
        return unicodeScalars.filter { String.digitsPattern ~= $0 }.string
    }
    var integer: Int { return Int(self) ?? 0 }
}

extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String { return String(String.UnicodeScalarView(self)) }
}

class AmountViewController: UIViewController {

    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var button: UIButton!
    var order: Order?
    var amount: Int { return amountInput.string.digits.integer }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAmountInput()
        button.layer.cornerRadius = 5
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _order = order {
            amountInput.text = getFormattedAmount(amount: 0)
            showApprovedOrderAlert(_order: _order)
            order = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        textField.text = getFormattedAmount(amount: amount)
    }
    
    func setupAmountInput() {
        amountInput.textAlignment = .right
        amountInput.keyboardType = .numberPad
        amountInput.text = getFormattedAmount(amount: amount)
        amountInput.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }

    @IBAction func buttonClicked(_ sender: Any) {
        let paymentMethodVC = PaymentMethodViewController()
        navigationController?.pushViewController(paymentMethodVC, animated: true)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if amount > 0 {
            goToPaymentMethodViewController()
        }
        else {
            showAmountWarning()
        }
    }
    
    func getFormattedAmount(amount: Int) -> String {
        return "$ \(Formatter.decimal.string(from: amount as NSNumber)!)"
    }
    
    func goToPaymentMethodViewController() {
        let paymentMethodVC = PaymentMethodViewController()
        let order = Order()
        order.amount = amount
        paymentMethodVC.order = order
        navigationController?.pushViewController(paymentMethodVC, animated: true)
    }
    
    func showAmountWarning() {
        let alert = UIAlertController(title: NSLocalizedString("order_amount_title", comment: ""), message: NSLocalizedString("amount_zero_warning", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showApprovedOrderAlert(_order: Order) {
        var text = ""
        if let paymentMethod = _order.paymentMethod{
            text += "\(paymentTypes[paymentMethod.paymentTypeId!]!): \(paymentMethod.name!)"
        }
        
        if let cardIssuer = _order.cardIssuer{
            text += "\nBanco: \(cardIssuer.name!)"
        }
        
        if let installment = _order.installment{
            text += "\n\(installment.message!)"
        }
        else {
            text += "\nMonto: \(getFormattedAmount(amount: (order?.amount!)!))"
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
            
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.showSuccess(NSLocalizedString("order_approved_title", comment: ""), subTitle: text, closeButtonTitle: NSLocalizedString("ok_button", comment: ""))
    }
}

