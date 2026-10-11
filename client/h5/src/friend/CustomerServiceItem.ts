///@描述:item
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-09-13 15:20
import { BaseItem1 } from "../common/BaseItem1"
import { SetLocalPosition, SetLocalPositionY } from "../util/Util"

export class CustomerServiceItem extends BaseItem1 {
    /*----这里定义变量-----*/
    SetData
    /*---------------------*/
    public constructor(parent) {
        super(parent)
        this.base_file = "friend"
        this.layout_file = "CustomerServiceItem"
        this.Load()

        this.SetData = (data?)=> {
            SetLocalPositionY(this.lable_content, 4)
            this.lable_content.text = data
            this.lable_content.fontSize = 26
            this.lable_content.color = "#663915"
        }
    }
    
    public DeleteMe() {
        super.DeleteMe()
    }
    

    lable_content: Laya.Label
    public GetComponents() {
        [
           this.lable_content
        ]

        = this.GetChildrenByNames([
           "lable_content"
        ])
    }
}
window["CustomerServiceItem"] = CustomerServiceItem