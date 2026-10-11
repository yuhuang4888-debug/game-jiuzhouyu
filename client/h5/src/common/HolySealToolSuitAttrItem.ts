import { EquipModel } from "../commonModel/EquipModel";
import { ColorType, ColorUtil } from "../util/ColorUtil";
import { Util } from "../util/Util";
import { BaseItem1 } from "./BaseItem1";
import { WordManager } from "./WordManager";

export class HolySealToolSuitAttrItem extends BaseItem1 {
    default_height = 20; //包括了一行label

    model = EquipModel.GetInstance();
    item_list = new Array<Laya.HTMLDivElement>();
    data
    cur_num
    need_refresh_data
    // private dynamic;
    // private suit_lv;

    public constructor(parent) {
        super(parent);
        this.base_file = "common"
        this.layout_file = "HolySealToolSuitAttrItem"
        this.is_load_res = false
        this.is_delay_callback = false
        this.load_callback = function () {
            this.LoadSuccess()
        }
    }

    LoadSuccess() {
        if (this.need_refresh_data) {
            this.UpdateItem()
            this.need_refresh_data = false
        }
    }

    SetData(data, cur_num) {
        this.data = data
        this.cur_num = cur_num
        if (this.is_loaded) {
            this.UpdateItem()
        } else {
            this.need_refresh_data = true
        }

    }

    UpdateItem() {
        let data = this.data
        let cur_num = this.cur_num

        // let color = cur_num >= data[0] ? ColorUtil.GetColorDark(ColorType.GREEN) : "'#8a8a8a'"
        let color = cur_num >= data[0] ? "'#0a953e'" : "'#8a8a8a'"
        this._lb_num.text = `【${data[0]}件】`
        // this._lb_num.color = cur_num >= data[0] ? ColorUtil.GetColorDark(ColorType.GREEN, false) : "#8a8a8a"
        this._lb_num.color = cur_num >= data[0] ? "#0a953e" : "#8a8a8a"
        for (let i = 0; i < data[1].length; i++) {
            let attr = data[1][i]
            let label = this.item_list[i]
            if (!label) {
                label = new Laya.HTMLDivElement()
                label.style.fontSize = 20
                label.y = i * 25
                this._gp_attr.addChild(label)
                this.item_list[i] = label
            }
            let name = WordManager.GetProperties(attr[0])
            let value = WordManager.ConvertToPercentValue(attr[0], attr[1])
            label.innerHTML = Util.HtmlColorTxt(`${name} +${value}`, color)
            label.visible = true
        }
        for (let i = data[1].length; i < this.item_list.length; i++) {
            this.item_list[i].visible = false
        }
		let height = data[1].length * this.default_height
		this.display_obj.height = height

        // let content_height = (data[1].length - 1) * 25 //24+5
        // this.display_obj.height = this.default_height + content_height
    }

    GetHeight() {
        if(this.data){
            let len = this.data[1].length
            return len * 25 + 5
        }
        else{
            return 0
        }
    }

    public DeleteMe() {
        this.item_list.length = 0
        super.DeleteMe()
    }


    _lb_num: Laya.Label
    _gp_attr: Laya.Box
    public GetComponents() {
        [
            this._lb_num,
            this._gp_attr,
        ]
            = this.GetChildrenByNames([

                "_lb_num",
                "_gp_attr",
            ])
    }
}
window["HolySealToolSuitAttrItem"] = HolySealToolSuitAttrItem