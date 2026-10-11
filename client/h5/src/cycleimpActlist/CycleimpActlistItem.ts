import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { HtmlColorTxt, Util } from "../util/Util"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { OpenFun } from "../common/OpenFun"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { ErlangParser } from "../util/ErlangParser"
import { TeamHallItem } from "../team/TeamHallItem"


export class CycleimpActlistItem extends BaseItemRenderer {
    _img_bg: Laya.Image
    _Scroller1: Laya.Panel
    _gp_reward: Laya.HBox
    lb_name: Laya.Label
    img_rank: Laya.Image
    lb_rank: Laya.Label
    score: Laya.HTMLDivElement
    stage_info: Laya.HTMLDivElement
    VHS_Scroller1
    _Viewport1
    _canGet
    _enough
    _item_list
    _model
    parent_wnd
    WIDTH = 679
    HEIGT = 94

    public constructor(parent) {
        super()

        this._item_list = []
        this.base_file = "cycleimpActlist"
        this.layout_file = "CycleimpActlistItem"

        this._model = CycleimpActlistModel.GetInstance()

        this.load_callback = () => {

            this.LoadSuccess()
        }
        this.Load()
    }

    public LoadSuccess() {
        this._Scroller1.hScrollBar.visible = false
    }

    public DeleteMe() {

        for (let _tmpi in this._item_list) {
            var item = this._item_list[_tmpi]
            item.DeleteMe()
        }
        this._item_list = null
        super.DeleteMe()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data.role_id) {
                ResManager.GetInstance().LoadGameConfig(this.base_item, "config_cycle_rank_reward", false, null, (cfg) => {
                    for (let key in cfg) {
                        let v = cfg[key]
                        if (this.data.type == v.type && this.data.subtype == v.sub_type && v.rank_min <= this.data.rank && v.rank_max >= this.data.rank) {
                            let list = v.rewards
                            list = ErlangParser.GetInstance().Parse(list)
                            this.UpdateItems(list)
                            break
                        }
                    }

                })
                this.lb_name.visible = true
                this.lb_name.y = 10
                this.lb_name.text = "S" + this.data.server_id + "." + this.data.role_name
                this.score.visible = true
                this.score.innerHTML = "积分：<font color='#d15e00'>" + this.data.role_score + "</font>"
                this.score.x = 246 / 2 - this.score.contextWidth / 2
                this.stage_info.visible = false
            } else {
                ResManager.GetInstance().LoadGameConfig(this.base_item, "config_cycle_rank_reward", false, null, (cfg?) => {
                    for (let key in cfg) {
                        let v = cfg[key]
                        if (v.type == this.data.type && v.sub_type == this.data.subtype && v.rank_min <= this.data.rank && v.rank_max >= this.data.rank) {
                            this.stage_info.style.width = 247
                            this.stage_info.innerHTML = v.reward
                            let list = v.rewards
                            list = ErlangParser.GetInstance().Parse(list)
                            this.UpdateItems(list)
                            break
                        }
                    }
                })
                this.stage_info.visible = true
                this.stage_info.x = 247 / 2 - this.stage_info.contextWidth / 2
                this.stage_info.y = 51 / 2 - this.stage_info.contextHeight / 2
                this.lb_name.visible = false
                this.lb_name.y = 20
                this.score.visible = false
            }
            if (this.data.rank <= 3) {
                ResManager.GetInstance().SetImageSprite(this.base_item, this.img_rank, "cycleimpActlist", "rank_icon_" + this.data.rank)
                this.lb_rank.visible = false
            } else {
                ResManager.GetInstance().SetImageSprite(this.base_item, this.img_rank, "cycleimpActlist", "rank_icon_4")
                this.lb_rank.visible = true
                this.lb_rank.text = this.data.rank
            }
        }
    }

    public UpdateItems(list?) {
        for (let i = 0; i < list.length; i++) {
            let info = list[i]
            let item = this._item_list[i]
            if (!item) {
                item = new EquipmentItem(this._gp_reward)
                item.SetItemSize(68, 68)
                item.Load()
                this._item_list[i] = item
            }
            let [type_id, _] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            item.SetData(type_id, info[2])
            item.SetVisible(true)
        }

        for (let i = list.length; i < this._item_list.length; i++) {
            this._item_list[i].SetVisible(false)
        }
    }

    public GetComponents() {
        [
            this._img_bg,
            this._Scroller1,
            this._gp_reward,
            this.lb_name,
            this.img_rank,
            this.lb_rank,
            this.score,
            this.stage_info
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_Scroller1",
                "_gp_reward",
                "lb_name",
                "img_rank",
                "lb_rank",
                "score",
                "stage_info"
            ])
        this.score.style.fontSize = 20
        this.score.style.color = "#663915"
        this.score.style.wordWrap = false
        this.stage_info.style.fontSize = 20
        this.stage_info.style.color = "#663915"
        this.stage_info.style.align = "center"
        this.stage_info.style.valign = "middle"
    }
}
window["CycleimpActlistItem"] = CycleimpActlistItem