//
//  BasePickerViewController.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import Kingfisher

class BasePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    init() {
        super.init(nibName: Constants.basePickerViewController, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerButton: UIButton!
    
    var pickerData: [String] = [];
    
    var order: Order? = Order()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerButton?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        pickerData = []
        
        pickerButton.layer.cornerRadius = 5
        pickerButton.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
    
    @objc func buttonClicked(_ sender: AnyObject?){}
    
    func pushViewController(vc: BasePickerViewController, order: Order){
        vc.order = order
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getPickerData(uri: String, parameters: [String : String]){
        SVProgressHUD.show()
        Service.executeGetRequest(baseURL: Constants.mercadoPagoBaseURL, Uri: uri, parameters: parameters) {
            response in
            
            if response.result.isSuccess {
                self.handleSuccessfulResponse(jsonResponse: JSON(response.result.value!))
            } else {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.showErrorAlert()
                }
            }
        }
    }
    
    func buildRequestParams() -> [String : String]{
        let parameters : [String : String ] = ["public_key" : Constants.mercadoPagoPublicKey]
        return parameters
    }
    
    func handleObjectFromJSON(json: JSON){}
    
    func selectDefaultPickerRow(){
        if pickerData.count > 0 {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func handleSuccessfulResponse(jsonResponse: JSON){
        if let responseJSONArray = jsonResponse.array{
            let array : [JSON] = self.searchDataArray(array: responseJSONArray)
            if array.count != 0 {
                for element in array{
                    self.handleObjectFromJSON(json: element)
                }
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.pickerView.reloadAllComponents()
                    self.selectDefaultPickerRow()
                }
            }
            else {
                SVProgressHUD.dismiss()
                handleEmptyResponseArray()
            }
        }
        else {
            SVProgressHUD.dismiss()
            handleEmptyResponseArray()
        }
        
    }
    
    func searchDataArray(array: [JSON]) -> [JSON]{
        return array
    }
    
    func handleEmptyResponseArray(){}
    
    func buildPickerViewRowWith(text: String, imageUrl: String) -> UIView{
        let _view = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width*0.9,height: 50))
        label.text = text
        
        let image = UIImageView(frame: CGRect(x: label.frame.width + 1, y: 0, width: pickerView.frame.width*0.1, height: 50))
        image.center = CGPoint(x: image.center.x, y: _view.center.y)
        image.contentMode = .scaleAspectFit

        let resource = ImageResource(downloadURL: URL(string: imageUrl)!, cacheKey: text)
        image.kf.setImage(with: resource)
        
        _view.addSubview(label)
        _view.addSubview(image)
        
        return _view
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Ups! Ocurrió un error.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {
            alert in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
