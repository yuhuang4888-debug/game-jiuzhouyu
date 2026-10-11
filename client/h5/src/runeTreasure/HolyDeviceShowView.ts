import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"

export class HolyDeviceShowView extends BaseView1 {
    /**显示的宝箱type_id*/
    itemGp

    InitView
    LoadSuccess
    public constructor() {
        super()
        this.base_file = "holyDeviceShow"
        this.layout_file = "HolyDeviceShowView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.is_center = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        let local_gmodel = GoodsModel.GetInstance(),
            typeId_,
            // Giftcfg_,
            itemList_ = []
        this.preload_server_config = {
            // "config_optional_gift": false
        }
        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.destroy_callback = function () {
            if (itemList_) {
                for (let vo of itemList_) {
                    vo.DeleteMe()
                }
                itemList_.length = 0
            }
        }

        this.Open = (parms?) => {
            if (parms) {
                typeId_ = parms[0]
            }
            this.InitView()
            super.Open()
        }

        this.LoadSuccess = () => {
            // Giftcfg_ = this.preload_server_config.config_optional_gift //await Util.LoadServerConfig("config_optional_gift")
            this.InitView()
        }

        this.InitView = () => {
            if (typeId_ ) {//&& Giftcfg_
                let cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(typeId_, 0)
                if (!cfg) {
                    cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(typeId_, RoleManager.GetInstance().GetMainRoleCareer())
                }
                if (cfg) {
                    let list = JSON.parse(cfg.list)
                    for (let vo of list) {
                        let item = new BaseAwardItem(this.itemGp)
                        item.Load()
                        item.SetScale(0.7)
                        let [type_id, lock] = local_gmodel.GetMappingTypeId(vo[1][0], vo[1][1])
                        let goods_vo = local_gmodel.GetGoodsBasicByTypeId(type_id)
                        if (goods_vo) {
                            item.SetData(goods_vo.type_id, vo[1][2])
                        }
                        itemList_.push(item)
                    }
                }
            }
        }
    }
}

window["HolyDeviceShowView"] = HolyDeviceShowView
