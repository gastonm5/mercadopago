//
//  PaymentMethodViewController.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaymentMethodViewController: BasePickerViewController {
    
    var paymentMethodsArray : [PaymentMethod] = [PaymentMethod]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerLabel?.text = NSLocalizedString("payment_method_label", comment: "")
        pickerButton?.setTitle(NSLocalizedString("choose_button", comment: ""), for: .normal)
        getPickerData(uri: Constants.mercadoPagoPaymentMethodsURI, parameters: buildRequestParams())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        order?.cardIssuer = nil
        order?.installment = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func buttonClicked(_ sender: AnyObject?) {
        if let amount = order?.amount, amount > (order?.paymentMethod?.maxAllowedAmount)! {
            showExceededAmountWarning()
        } else {
            goToNextViewController()
        }
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return paymentMethodsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return buildPickerViewRowWith(text: paymentMethodsArray[row].name!, imageUrl: paymentMethodsArray[row].image!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        order?.paymentMethod = paymentMethodsArray[row]
    }
    
    //Tengo en cuenta el monto maximo permitido por el medio de pago
    override func handleObjectFromJSON(json: JSON) {
        let paymentMethod = PaymentMethod(id: json["id"].stringValue, name: json["name"].stringValue, image: json["secure_thumbnail"].stringValue, paymentTypeId: json["payment_type_id"].stringValue, maxAllowedAmount: json["max_allowed_amount"].intValue)
        paymentMethodsArray.append(paymentMethod)
    }
    
    
    override func selectDefaultPickerRow(){
        let index = paymentMethodsArray.count/2
        order?.paymentMethod = paymentMethodsArray[index]
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    //Muestro alerta indicando que se esta excendiendo del monto permitido
    func showExceededAmountWarning() {
        let alert = UIAlertController(title: NSLocalizedString("message_title", comment: ""), message: NSLocalizedString("amount_exceeded_warning", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //Si el metodo de pago es de tipo Tarjeta de Credito, muestro los bancos asociados, sino avanzo directamente a pantalla de seleccion cuotas
    func goToNextViewController() {
        var vc : BasePickerViewController? = nil
        if order?.paymentMethod?.paymentTypeId == "credit_card"{
            vc = CardIssuerViewController()
        }
        else{
            vc = InstallmentsViewController()
        }
        vc?.order = order
        pushViewController(vc: vc!, order: order!)
    }
}
