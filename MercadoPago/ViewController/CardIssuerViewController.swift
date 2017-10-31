//
//  CardIssuerViewController.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import UIKit
import SwiftyJSON

class CardIssuerViewController: BasePickerViewController {

    var cardIssuersArray : [CardIssuer] = [CardIssuer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerLabel.text = NSLocalizedString("card_issuer_label", comment: "")
        pickerButton.setTitle(NSLocalizedString("choose_button", comment: ""), for: .normal)
        getPickerData(uri: Constants.mercadoPagoCardIssuersURI, parameters: buildRequestParams())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        order?.installment = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func buttonClicked(_ sender: AnyObject?) {
        goToInstallmentsViewController(dismiss: false)
    }

    override func buildRequestParams() -> [String : String] {
        var parameters = super.buildRequestParams()
        parameters["payment_method_id"] = order?.paymentMethod?.id
        return parameters
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return cardIssuersArray.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return buildPickerViewRowWith(text: cardIssuersArray[row].name!, imageUrl: cardIssuersArray[row].image!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        order?.cardIssuer = cardIssuersArray[row]
    }
    
    override func handleObjectFromJSON(json: JSON) {
        let cardIssuer = CardIssuer(id: json["id"].stringValue, name: json["name"].stringValue, image: json["secure_thumbnail"].stringValue)
        cardIssuersArray.append(cardIssuer)
    }
    
    override func selectDefaultPickerRow(){
        let index = cardIssuersArray.count/2
        order?.cardIssuer = cardIssuersArray[index]
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func goToInstallmentsViewController(dismiss: Bool){
        let vc = InstallmentsViewController()
        if dismiss {
            navigationController?.popViewController(animated: false)
        }
        pushViewController(vc: vc, order: order!)
    }
    
    override func handleEmptyResponseArray() {
        //Si el medio de pago no tiene bancos asociados, avanzo directamente a la pantalla de seleccion de cuotas
        goToInstallmentsViewController(dismiss: true)
    }
}
