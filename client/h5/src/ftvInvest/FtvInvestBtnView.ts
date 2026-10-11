import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class FtvInvestBtnView extends BaseItemRenderer {
    WIDTH = 336
    HEIGT = 108
    _gp_click: Laya.Box
    _img_type: Laya.Image
    _img_select: Laya.Image
    _img_invest: Laya.Image
    _img_red: Laya.Image
    model
    public constructor() {
        super();
        this.base_file = 'ftvInvest';
        this.layout_file = 'FtvInvestBtnView';
        this.model = CustomActivityModel.GetInstance(),
            this.load_callback = () => {
                Util.AddClickEvent(this._gp_click, () => {
                    this.model.Fire(CustomActivityDefine.EVENT.FTV_INVEST_TAB_SELECT, this.data, this.index)
                }, this, true)
            }
        this.Load()
    }
    public createChildren() {
        super.createChildren()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (!this.data) return
            let cond = this.model.GetActCondition(this.data.b, this.data.s, "data", this.data.grade)
            let res = `resource/game/ftvInvest/texture/${cond.show_tab}.png`
            ResManager.GetInstance().SetTexture(this, this._img_type, res, undefined, undefined, true)
            this._img_select.visible = this.selected
            this._img_invest.visible = this.data.status && this.data.status > 0
            this._img_red.visible = this.data.bool
        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._gp_click,
            this._img_type,
            this._img_select,
            this._img_invest,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_gp_click",
                "_img_type",
                "_img_select",
                "_img_invest",
                "_img_red",
            ])
    }
}
window["FtvInvestBtnView"] = FtvInvestBtnView