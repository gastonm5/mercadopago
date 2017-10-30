//
//  InstallmentsViewController.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import UIKit
import SwiftyJSON

class InstallmentsViewController: BasePickerViewController {

    var installmentsArray : [Installment] = [Installment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerLabel.text = NSLocalizedString("installments_label", comment: "")
        pickerButton.setTitle(NSLocalizedString("choose_button", comment: ""), for: .normal)
        getPickerData(uri: Constants.mercadoPagoInstallmentsURI, parameters: buildRequestParams())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func buttonClicked(_ sender: AnyObject?) {
        goToRootViewController()
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return installmentsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 30))
        
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width,height: 30))
        text.text = installmentsArray[row].message
        view.addSubview(text)
        text.textAlignment = .center
        return view
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        order?.installment = installmentsArray[row]
    }
    
    
    override func buildRequestParams() -> [String : String] {
        var parameters = super.buildRequestParams()
        parameters["payment_method_id"] = order?.paymentMethod?.id
        parameters["amount"] = String(describing:order?.amount! ?? 0)
        
        if let cardIssuer = order?.cardIssuer {
            parameters["issuer.id"] = cardIssuer.id
        }
        return parameters
    }
    
    override func handleObjectFromJSON(json: JSON) {
         let installment = Installment(quantity: json["installments"].intValue, message: json["recommended_message"].stringValue)
         installmentsArray.append(installment)
    }
    
    override func selectDefaultPickerRow(){
        let index = installmentsArray.count/2
        order?.installment = installmentsArray[index]
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    override func searchDataArray(array: [JSON]) -> [JSON] {
        var arr : [JSON] = [JSON]()
        if array.count != 0 {
            arr = array[0]["payer_costs"].array!
        }
        return arr
    }
    
    override func handleEmptyResponseArray(){
        goToRootViewController()
    }
    
    func goToRootViewController(){
        let vc = navigationController?.viewControllers[0] as! AmountViewController!
        vc?.order = order
        navigationController?.popToRootViewController(animated: true)
    }
}
