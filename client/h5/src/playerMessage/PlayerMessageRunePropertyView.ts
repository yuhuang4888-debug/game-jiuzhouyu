import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager";
import { RuneModel } from "../commonModel/RuneModel";
import { RunePropertyItem } from "../rune/RunePropertyItem";
import { Util } from "../util/Util";


export class PlayerMessageRunePropertyView extends BaseView1 {

    InitEvent
    LoadSuccess
    OpenCallback
    data
    public constructor() {
        super()

        this.base_file = "rune"
        this.layout_file = "RunePropertyView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        let model = RuneModel.GetInstance()

        let item_list_ = null
        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            this.OpenCallback()
        }

        this.destroy_callback = () => {
            if (item_list_) {
                for (let _tmpi in item_list_) {
                    var obj = item_list_[_tmpi]
                    obj.DeleteMe()
                }
                item_list_ = null
            }
        }

        this.LoadSuccess = () => {
            this.scroll.vScrollBar.visible = false
            // ResManager.GetInstance().SetOutsideImageSprite(this, this.property_bg, GameResPath.GetIcon("common", "com_bg_1"))
            // this.property_bg.scale9Grid = new Laya.Rectangle(200,200,20,20)
            item_list_ = []
        }

        this.InitEvent = () => {

        }

        this.OpenCallback = () => {

            let all_fight = 0
            let all_pao = []
            let is_same = false
            let tmp = null
            if (this.data && this.data.rune_list) {
                for (let _tmpi in this.data.rune_list) {
                    var obj = this.data.rune_list[_tmpi]
                    for (let _tmpi in obj.attr_list) {
                        var pro = obj.attr_list[_tmpi]
                        is_same = false
                        for (let _tmpi in all_pao) {
                            var val = all_pao[_tmpi]
                            if (val[0] == pro.attr_id) {
                                is_same = true
                                val[1] = val[1] + pro.attr_num
                                break
                            }
                        }
                        if (!is_same) {
                            tmp = []
                            tmp[0] = pro.attr_id
                            tmp[1] = pro.attr_num
                            all_pao.push(tmp)
                        }
                    }
                }
            }
            all_fight = Util.CalAttrPower(all_pao, false)
            let list = []
            list = [all_fight, all_pao]
            if (list && list[1].length > 0) {
                this.none_conta.visible = false
                this.scroll.visible = true
                let all_pro = model.GetAllProShow(list)
                let awakeList = []
                let runeList = this.data.rune_list; // model.rune_info.rune_list
                let wake_cfg = model.GetWakeUpCfg()
                for (let _tmpi in runeList) {
                    var vo = runeList[_tmpi]
                    if (vo.color > 3 && vo.attr_list.length > 0) {
                        for (let _tmpi in vo.attr_list) {
                            var awakeInfo = vo.attr_list[_tmpi]
                            let cfg = wake_cfg[vo.color + "@" + awakeInfo.attr_id + "@" + awakeInfo.awake_lv]
                            if (cfg) {
                                let add = JSON.parse(cfg.attr)
                                if (add.length > 0) {
                                    add = add[0]
                                    if (!awakeList[add[0]]) {
                                        awakeList[add[0]] = add[1]
                                    } else {
                                        awakeList[add[0]] = awakeList[add[0]] + add[1]
                                    }
                                }
                            }
                        }
                    }
                }
                for (let _tmpi in all_pro) {
                    var vo = all_pro[_tmpi]
                    if (awakeList[vo[0]]) {
                        vo[1] = vo[1] + awakeList[vo[0]]
                    }
                }
                if (all_pro) {
                    let item = null
                    let count = 0
                    let i = 0
                    do {
                        if (all_pro[i] && all_pro[i][1] > 0) {
                            item = item_list_[count]
                            if (!item) {
                                item = new RunePropertyItem(this.Content)
                                item_list_[count] = item
                                item.Load()
                            }
                            item.SetData(all_pro[i])
                            count = count + 1
                        }
                        i = i + 1
                    } while ((i < all_pro.length))
                }
            } else {
                this.none_conta.visible = true
                this.scroll.visible = false
            }
        }

    }

    public Open(...parms) {
        if (parms) {
            this.data = parms[0]
        }
        super.Open()
    }


    property_bg: Laya.Image
    property_title: Laya.Label
    _Image1: Laya.Image
    scroll: Laya.Panel
    Content: Laya.VBox
    none_conta: Laya.Box
    tips: Laya.Label
    tips_icon: Laya.Image
    public GetComponents() {
        [
            this.property_bg,
            this.property_title,
            this._Image1,
            this.scroll,
            this.Content,
            this.none_conta,
            this.tips,
            this.tips_icon,
        ]
            = this.GetChildrenByNames([

                "property_bg",
                "property_title",
                "_Image1",
                "scroll",
                "Content",
                "none_conta",
                "tips",
                "tips_icon",
            ])
    }
}
window["PlayerMessageRunePropertyView"] = PlayerMessageRunePropertyView