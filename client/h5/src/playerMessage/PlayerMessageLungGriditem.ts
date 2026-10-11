import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { ModuleType } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungDotSubType, LungEvent, LungModel } from "../commonModel/LungModel";
import { Message } from "../sysinfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";

export class PlayerMessageLungGriditem extends BaseItem1 {


    public model: LungModel
    public data
    public needRefresh
    state = 0 						 //状态  0 未解锁  1 未镶嵌  2 已经镶嵌
    item: BaseAwardItem
    select_cache
    init_pos
    not_show_red_dot = false
    lung_all_info
    scmd_info
    public constructor(parent) {
        super(parent)
        this.base_file = "lung"
        this.layout_file = "LungGridItem"
        this.model = LungModel.GetInstance()
        this.load_callback = function () {
            this.LoadSuccess()
            this.InitEvents()
        }
    }
    public DeleteMe() {
        if (this.insert_group)
            Laya.Tween.clearAll(this.insert_group)
        this.not_show_red_dot = false
        this.ClearUIEffect(this.effect_con)
        if (this.item) {
            this.item.DeleteMe()
            this.item = null
        }
        super.DeleteMe()

    }
    public LoadSuccess() {
        this.init_pos = this.insert_group.y
        if(this.needRefresh){
            this.SetData(this.data,this.scmd_info)
            this.needRefresh = false
        }
    }

    public InitEvents() {

    }

    public SetData(data, scmd?) {
        this.data = data
        this.scmd_info = scmd
        if (this.is_loaded) {
            if (!data) return
            let star = 0
            this.ClearUIEffect(this.effect_con)
            let is_activity = false
            let info = null
            for(let key  in scmd.dragon_equip_list){
                if(this.data.pos == scmd.dragon_equip_list[key].pos){
                    is_activity = true
                    info = scmd.dragon_equip_list[key]
                }
            }
            if (!is_activity) {	//未开放
                this.state = 0
                this.lv_limit.text = `${this.data.need_lv}级解锁`
            } else {
                let wear = GoodsModel.GetInstance().GetGoodsBasicByTypeId(info.goods_id)
                this.state = wear != undefined ? 2 : 1
                if (wear) {
                    if (!this.item) {
                        this.item = new BaseAwardItem(this.item_con)
                        this.item.Load()
                        this.item.SetItembgVisible(false)
                        this.item.SetItemSize(93, 93)
                        this.item.SetShowTips(false)
                    }
                    this.item.SetData(wear.type_id)
                    let star_num = info.awake_lv
                    let lv =  info.stren_lv
                    star = star_num
                    this.lv_label.text = `Lv.${lv}`
                    this.star_con.visible = star_num > 0
                    this.star_bg.visible = star_num > 0
                    this.star_num.text = String(star_num)
                    if (star_num > 0) {
                        let source = this.model.GetStarBgSource(wear.color)
                        if (source) {
                            this.star_bg.skin = AtlasUrl("lung", `${source}`)
                        }
                    }
                    // let effect = "ui_longwen_glow1"
                    // if (wear.color >= 5) {
                    //     effect = "ui_longwen_glow2"
                    // }
                    // this.AddUIEffect(effect, this.effect_con, null, null, true)
                }
            }

            if (this.select_cache != undefined) {
                this.select_cache = null
            }

            this.lv_limit.visible = this.state == 0
            this.lock_tag.visible = this.state == 0
            this.lv_label.visible = this.state == 2
            this.star_con.visible = this.state == 2 && star > 0
            this.star_bg.visible = this.state == 2 && star > 0
            this.item_con.visible = this.state == 2
            if (!this.not_show_red_dot) {
            }
        } else {
            this.needRefresh = true
        }
    }

    public ShowAnimation() {
        Laya.Tween.to(this.insert_group, { y: this.init_pos - 20 }, 800, undefined, Laya.Handler.create(this, () => {
            this.ShowAnimation2()
        }))
    }

    public ShowAnimation2() {
        Laya.Tween.to(this.insert_group, { y: this.init_pos }, 800, undefined, Laya.Handler.create(this, () => {
            this.ShowAnimation()
        }))

    }


    effect_gp: Laya.Box
    con: Laya.Box
    _Image1: Laya.Image
    goods: Laya.Box
    select_bg: Laya.Image
    lock_tag: Laya.Image
    effect_con: Laya.Box
    item_con: Laya.Box
    star_bg: Laya.Image
    star_con: Laya.HBox
    star_num: Laya.Label
    _Image2: Laya.Image
    lv_label: Laya.Label
    lv_limit: Laya.Label
    red_dot: Laya.Image
    insert_group: Laya.Box
    _Label1: Laya.Label
    public GetComponents() {
        [
            this.effect_gp,
            this.con,
            this._Image1,
            this.goods,
            this.select_bg,
            this.lock_tag,
            this.effect_con,
            this.item_con,
            this.star_bg,
            this.star_con,
            this.star_num,
            this._Image2,
            this.lv_label,
            this.lv_limit,
            this.red_dot,
            this.insert_group,
            this._Label1,
        ]
            = this.GetChildrenByNames([

                "effect_gp",
                "con",
                "_Image1",
                "goods",
                "select_bg",
                "lock_tag",
                "effect_con",
                "item_con",
                "star_bg",
                "star_con",
                "star_num",
                "_Image2",
                "lv_label",
                "lv_limit",
                "red_dot",
                "insert_group",
                "_Label1",
            ])
    }
}
window["PlayerMessageLungGriditem"] = PlayerMessageLungGriditem