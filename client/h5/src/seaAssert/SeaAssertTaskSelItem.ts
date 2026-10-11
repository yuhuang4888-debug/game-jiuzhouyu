import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"

export class SeaAssertTaskSelItem extends BaseItemRenderer {
    _model

    WIDTH = 420
    HEIGT = 136

    public constructor() {
        super()

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertTaskSelItem"

        this.load_callback = () => {

            this.InitEvent()
        }

        this.Load();
    }

    public InitEvent() {

        this._model = SeaHegemonyModel.GetInstance()
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    public dataChanged() {
        if (super.dataChanged()) {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIconOtherPath('seaAssert', "ui_bright_21"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._img, GameResPath.GetIcon('seaAssert', "uitc_img" + this.data.id))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon('seaAssert', 'uisdbz_00' + (8 - this.data.id)))

            let y = (RoleManager.GetInstance().GetMainRoleVo().level - 150) / 50
            let n1 = Mathf.Pow(1.2, y)
            let exp = n1 * 180000000 * this.data.exp_ratio / 10000
            // this._lb_exp.textFlow = Util.StrToHTML("经验：" + HtmlColorTxt(CalUnitNum2(exp), "#3e2412"))
            this._lb_exp.text = WordManager.ConvertNum(exp);
            let money = JSON.parse(this.data.reward)[0]
            this._lb_coin.text = money[2];
            let brick_num = 0
            let brick_num_list = JSON.parse(this.data.snatch_ratio)
            for (let key in brick_num_list) {
                let cfg = brick_num_list[key]
                if (Number(cfg[0]) == this.data.brick_lv) {
                    brick_num = Number(cfg[1])
                    break;
                }
            }
            this._lb_num.text = brick_num + '';
            let viewData = this._model.getAssertViewData(this._model.assertSceneData.sea_id)
            this._select.visible = this.data.id == viewData.brick_color
        }
    }





    _Group1: Laya.Box
    _Image1: Laya.Image
    _img_title: Laya.Image
    _lb_exp: Laya.Label
    _lb_coin: Laya.Label
    _lb_num: Laya.Label
    _img: Laya.Image
    _select: Laya.Image
    public GetComponents() {
        [
            this._Group1,
            this._Image1,
            this._img_title,
            this._lb_exp,
            this._lb_coin,
            this._lb_num,
            this._img,
            this._select,
        ]
            = this.GetChildrenByNames([

                "_Group1",
                "_Image1",
                "_img_title",
                "_lb_exp",
                "_lb_coin",
                "_lb_num",
                "_img",
                "_select",
            ])
    }
}
window["SeaAssertTaskSelItem"] = SeaAssertTaskSelItem