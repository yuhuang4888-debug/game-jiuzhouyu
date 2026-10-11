import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { WordManager } from "../common/WordManager";
import { GodBeastModel } from "../commonModel/GodBeastModel";
import { ColorUtil, Enum_ColorUtil_Light } from "../util/ColorUtil";
import { Util } from "../util/Util";

export class GodBeastAttrItem extends BaseItemRenderer {
    public WIDTH = 234
	public HEIGT = 41


    private _model = GodBeastModel.GetInstance();
    public constructor() {
        super()
        this.base_file = "godBeast"
		this.layout_file = "GodBeastAttrItem"
        this._model = GodBeastModel.GetInstance()
        this.Load()
    }

    public load_callback(){
		
	}

    public createChildren() {
        super.createChildren()
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        this._lb_name.text = `${WordManager.GetProperties(data.key)}:`
        let value = data.value + data.add
        let value_str = WordManager.ConvertToPercentValue(data.key, value)
        // this._lb_num.color = ColorUtil.GetColorLight(1, false)
        this._lb_num.text = value_str
        // let value_str = WordManager.ConvertToPercentValue(data.key, data.value)
        // let add_str = ""
        // if (data.add) {
        //     add_str = WordManager.ConvertToPercentValue(data.key, data.add)
        //     add_str = Util.HtmlColorTxt(` +${add_str}`, Enum_ColorUtil_Light.GREEN)
        // }
        // this._lb_num.textFlow = Util.StrToHTML(`${value_str}${add_str}`)
    }

    _Group1: Laya.HBox
    _lb_name: Laya.Label
    _lb_num: Laya.Label
    _Image1: Laya.Image
    public GetComponents() {
        [
            this._Group1,
            this._lb_name,
            this._lb_num,
            this._Image1,
        ]
            = this.GetChildrenByNames([

                "_Group1",
                "_lb_name",
                "_lb_num",
                "_Image1",
            ])
    }
}

window["GodBeastAttrItem"] = GodBeastAttrItem