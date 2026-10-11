import { BaseItem1 } from "../common/BaseItem1";
import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { GameSettingManager } from "../common/GameSettingManager";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { DemonTalentItem } from "../demon/DemonTalentItem";
import { SkillVo } from "../skill/SkillVo";
import { GameResPath } from "../util/GameResPath";
import { Trim, Util } from "../util/Util";

export class PlayerMessageDemonTalentSelectView extends BaseView1 {
    info
    data
    demon_model: DemonModel
    has_activated
    has_learned
    is_max_level
    is_preview
    is_select_data
    lv
    need_refresh_data
    skill_id
    skill_lv
    slot
    talent_item: DemonTalentItem
    fight_item

    public constructor() {
        super()

        this.base_file = "demon"
        this.layout_file = "DemonTalentSelectShow"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.demon_model = DemonModel.GetInstance()
        this.is_select_data = false
        this.has_activated = false

        this.load_callback = () => {
            this.fight_item = new FightingShowSmallItem(this._gp_fight)
            this.fight_item.Load()
            this.fight_item.IsCenter(true, false)
            this.LoadSuccess()

        }
        this.close_callback = () => {
            if(this.fight_item){
                this.fight_item.DeleteMe()
                this.fight_item = null
            }
            if (this.talent_item) {
                this.talent_item.DeleteMe()
                this.talent_item = null
            }
            this.skill_id = null
            this.info = null
            this.slot = null
        }
    }
    public LoadSuccess() {

        this.UpdateView()

        this.InitEvent()
    }

    public InitEvent() {

    }

    public Open(...parms) {
        if (parms) {
            this.info = parms[0]
            this.slot = parms[1]
            this.skill_id = parms[2]
            this.data = parms[3]
        }
        super.Open()
    }


    public UpdateView() {
        if (!this.info) {
            return
        }
        this._Group1.visible = false
        this.fight_item.SetVisible(false)
        // this._lb_fight.visible = false
        // this.lb_fightn_name.visible = false
        // this._gp_item.pos(25, 25)
        // this._lb_name.pos(125, 60)
        let talent_data = this.demon_model.GetTalentData(this.slot, this.data)

        let skill_vo = new SkillVo(this.skill_id)

        this.has_learned = talent_data && talent_data.sk_id == this.skill_id

        if (talent_data) {
            this.has_activated = true
        } else {
            this.has_activated = false
        }

        let now_level, next_level
        if (this.has_learned) {
            now_level = talent_data.sk_lv
            this.lv = talent_data.sk_lv
        } else {
            now_level = 0
        }
        if (this.is_preview) {
            now_level = now_level + 1
        }
        this.lv = now_level


        this.skill_lv = now_level

        this.is_max_level = skill_vo.GetTotalLevel() == now_level

        let lv_data = skill_vo.getLevelVo(now_level)

		if (lv_data) {
			this._lb_desc.width = 300
			this._lb_desc.innerHTML = skill_vo.getDesc(now_level, false)
		}


        let str = ""

        if (this.is_preview) {
            str = "预览"
            this._Group1.visible = false
        } else {
            if (this.has_activated) {
                if (this.has_learned) {
                    if (this.is_max_level) {
                        str = "已满级"
                    } else {
                        str = "已激活"
                    }
                }
            }
        }

        this._lb_state.text = str
        this._lb_name.text = "LV" + now_level + "." + skill_vo.getName()
        if (!this.talent_item) {
            this.talent_item = new DemonTalentItem(this._gp_item)
            this.talent_item.Load()
        }
        let demons_skill_add_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_demons_skill_add", false)
        let cfg = demons_skill_add_cfgs[this.skill_id]
        this.talent_item.SetData(this.info, this.slot, cfg.goods_id)
        this.UpdateFight()
    }

    public UpdateFight() {
        //目测无法获取别人使魔的真实战力
        // let demons_skill_add_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_demons_skill_add", false)
        // let slot = this.has_learned ? 1 : 0
        // let cfg = demons_skill_add_cfgs[this.skill_id]
        // let fight_data = this.demon_model.GetTalentFight(this.info.demons_id, slot, this.skill_id, this.lv, cfg.goods_id)
        // if (fight_data) {
        //     this.fight_item.Updatefighting(fight_data.power)
        //     // this._lb_fight.text = "z" + fight_data.power
        // }
    }
    _Image1: Laya.Image
    _gp_item: Laya.Box
    _Image2: Laya.Image
    _lb_name: Laya.Label
    _gp_fight: Laya.Box
    _Image3: Laya.Image
    _Group1: Laya.Box
    _img_bg: Laya.Image
    _lb_state: Laya.Label
    _Scroller1: Laya.Panel
    Content: Laya.VBox
    _lb_desc: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._Image1,
            this._gp_item,
            this._Image2,
            this._lb_name,
            this._gp_fight,
            this._Image3,
            this._Group1,
            this._img_bg,
            this._lb_state,
            this._Scroller1,
            this.Content,
            this._lb_desc,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_gp_item",
                "_Image2",
                "_lb_name",
                "_gp_fight",
                "_Image3",
                "_Group1",
                "_img_bg",
                "_lb_state",
                "_Scroller1",
                "Content",
                "_lb_desc",
            ])
        this._lb_desc.style.fontSize = 18
        this._lb_desc.style.color = "#90745b"
        this._Scroller1.vScrollBar.visible = false
    }

}
window["PlayerMessageDemonTalentSelectView"] = PlayerMessageDemonTalentSelectView