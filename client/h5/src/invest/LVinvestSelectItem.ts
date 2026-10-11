import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { investType, KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { GameResPath } from "../util/GameResPath"

export class LVinvestSelectItem extends BaseItemRenderer {
    _gp: Laya.Box
    _bg: Laya.Image
    _Group1: Laya.HBox
    _Label1: Laya.Label
    _Image1: Laya.Image
    _lb_in: Laya.Label
    _Group2: Laya.HBox
    _Label2: Laya.Label
    _Image2: Laya.Image
    _lb_out: Laya.Label
    _img: Laya.Image
    _gp_effect: Laya.Box
    _model
    _select
    _url
    max_lv

    public static width = 360
    public static height = 175
    public WIDTH = 250
	public HEIGT = 101
    public constructor(parent) {
        super()

        this._url = ""
        this.max_lv = null
        this._select = null
        this.base_file = "invest"
        this.layout_file = "LVinvestSelectItem"
        this._model = KaifuActivityModel.GetInstance()
        
        this.load_callback = () => {

            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._Label1.size  = 18
            // 	this._Label2.size  = 18
            // }
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
            // 	this._Label1.size  = 18
            // 	this._lb_in.size  = 18
            // 	this._Label2.size  = 18
            // 	this._lb_out.size  = 18
            // 	LayoutRebuilder(this._Group1)
            // 	LayoutRebuilder(this._Group2)
            // }
            //this.dataChanged()
        }
        this.Load()
    }

    public DeleteMe() {

        this.cleanEffect()
        super.DeleteMe()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.is_loaded) {
                let data = this._model.menuConfList(investType.level)
                this.max_lv = this.data.level == data[data.length - 1].level
                if (this.max_lv) {
                    this._url = "uidftz_0010"
                } else {
                    this._url = "uidftz_009"
                }
                if (!this._select || this.selected != this._select) {
                    this.SetSelected(this.selected)
                }
                this._img.visible = this.max_lv
                // this._gp_effect.visible = this.max_lv
                // if (this._gp_effect.visible) {
                //     //this.AddUIEffect("ui_recommend", Enum_UILayer.UI, this._gp_effect, null, null, true)
                // } else {
                //     this.cleanEffect()
                // }
                this._lb_in.text = this.data.price + ""
                this._lb_out.text = this._model.allPrice(this.data.level, false)
                // LayoutRebuilder(this._Group1)
                // LayoutRebuilder(this._Group2)
            }
        }
    }

    // public selected() {

    //     return this._select
    // }

    public SetSelected(value?) {

        if (this._select == value) {
            return
        }
        this._select = value
        if (this.data && this._url != "") {
            if (this._select) {
                ResManager.GetInstance().SetImageSprite(this, this._bg, "invest_asset",this._url + "a", true)
                this._model.Fire(KaifuActivityModelEvent.SELECT_LVINVEST_LEVEL, investType.level, this.data.level)
            } else {
                ResManager.GetInstance().SetImageSprite(this, this._bg, "invest_asset",this._url, true)
            }
        }
    }

    public cleanEffect() {

        //  this.ClearUIEffect(this._gp_effect)
    }



    public GetComponents() {
        [
            this._gp,
            this._bg,
            this._Group1,
            this._Label1,
            this._Image1,
            this._lb_in,
            this._Group2,
            this._Label2,
            this._Image2,
            this._lb_out,
            this._img,
            this._gp_effect,
        ]
            = this.GetChildrenByNames([

                "_gp",
                "_bg",
                "_Group1",
                "_Label1",
                "_Image1",
                "_lb_in",
                "_Group2",
                "_Label2",
                "_Image2",
                "_lb_out",
                "_img",
                "_gp_effect",
            ])
    }
}
window["LVinvestSelectItem"] = LVinvestSelectItem