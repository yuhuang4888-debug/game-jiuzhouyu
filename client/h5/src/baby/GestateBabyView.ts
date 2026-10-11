import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { ResManager } from "../common/ResManager"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { GoodsModel, GoodsType } from "../commonModel/GoodsModel"
import { Util } from "../util/Util"

/**孕育宝宝界面*/
export class GestateBabyView extends BaseView1 {

    public item: BaseAwardItem
    public model = BabyModel.GetInstance()
    cost = 200
    InitView
    DesFunc
    public constructor() {
        super()
        this.base_file = "baby"
        this.layout_file = "GestateBabyView"
        this.is_center = true
        this.destroy_imm = true
        this.click_bg_toClose = true
        this.use_background = true
        let res_mgr = ResManager.GetInstance()
        let goods_model = GoodsModel.GetInstance()
        let local_Util = Util
        this.preload_server_config = {
            "config_baby_value": false
        }
        this.load_callback = function () {
            this.InitView()
        }
        this.destroy_callback = function () {
            this.DesFunc()
        }
        this.InitView = () => {
            let baby_cfg = res_mgr.GetGameConfigFromCache(this, "config_baby_value", false)
            let cfg = baby_cfg[2].value
            if (cfg) {
                let cost = JSON.parse(cfg)
                if (cost.length > 0) {
                    if (!this.item) {
                        this.item = new BaseAwardItem(this.itemGp)
                        this.item.Load()
                        this.item.SetItemSize(85, 85)
                    }
                    let goodsInfo = goods_model.GetMappingTypeId(cost[0][0], cost[0][1])
                    let goodsBasic = goods_model.GetGoodsBasicByTypeId(goodsInfo[0])
                    if (goodsBasic) {
                        this.item.SetData(goodsBasic.type_id, cost[0][2])
                    }
                    this.cost = cost[0][2]
                }
            }

            local_Util.AddClickEvent(this.closeBtn, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this.gestateBtn, () => {
                let func = () => {
                    this.model.Fire(BabyEvent.REQUEST_PROTO, 18210)
                    this.Close()
                }
                // if (local_Util.CheckMoney(this.cost, func, true, true, true)) {
                //     func()
                // }
                GoodsModel.GetInstance().CheckCoinEnough(GoodsType.bind_diamond, this.cost, true, func)
            }, this, true)

            // res_mgr.SetTexture(this, this.bg1, "resource/game/baby/texture/uisy_023.png")
            res_mgr.SetTexture(this, this.bg2, "resource/game/baby/texture/Uibaobao_004.png")
            // res_mgr.SetTexture(this, this.bg3, "resource/game/baby/texture/Uibaobao_003.png")
        }

        this.DesFunc = () => {
            if (this.item) {
                this.item.DeleteMe()
                this.item = null
            }
        }
    }


    bg1: Laya.Image
    bg2: Laya.Image
    bg3: Laya.Image
    _Image11: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    closeBtn: Laya.Image
    _Label1: Laya.Label
    itemGp: Laya.Box
    gestateBtn: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    public GetComponents() {
        [
            this.bg1,
            this.bg2,
            this.bg3,
            this._Image11,
            this._Image2,
            this._Image3,
            this._Image4,
            this.closeBtn,
            this._Label1,
            this.itemGp,
            this.gestateBtn,
            this._Image1,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "bg1",
                "bg2",
                "bg3",
                "_Image11",
                "_Image2",
                "_Image3",
                "_Image4",
                "closeBtn",
                "_Label1",
                "itemGp",
                "gestateBtn",
                "_Image1",
                "labelDisplay",
            ])
    }
}
window["GestateBabyView"] = GestateBabyView