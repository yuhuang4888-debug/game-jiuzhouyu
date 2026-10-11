import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { DemonData } from "../commonModel/DemonData";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { FriendModel } from "../commonModel/FriendModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { SkillVo } from "../skill/SkillVo";
import { Message } from "../sysinfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { SetAnchoredPositionY, HtmlColorTxt, Trim, Util, PlayBigEffect } from "../util/Util";

export class PlayerMessageDemonSkillTipsView extends BaseView1 {
	_Image1: Laya.Image
	_img_bg: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_img_icon: Laya.Image
	_lb_name: Laya.Label
	_desc1: Laya.HTMLDivElement
	_desc2: Laya.HTMLDivElement
	_gp_up: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	_img_up_red: Laya.Image
	_gp_effect: Laya.Box


	data
	demon_model: DemonModel
	equip_item
	goods_model
	material_data
	state
	res_mgr: ResManager
    friend_model
	public constructor() {
		super()

		this.base_file = "demon"
		this.layout_file = "DemonSkillTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
        this.friend_model = FriendModel.GetInstance()
		this.demon_model = DemonModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.equip_item = null
		this.material_data = null
		this.data = null
		this.preload_client_config = {
			"ConfigDemon": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}
	public LoadSuccess() {
		// this.res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIcon("fieldBoss", "uity_016bb"))
		// Util.SetCircleMask(this._img_icon)
		// this.AddUIEffect("ui_Pokemon_rotateline", this._gp_effect, null, null, true)
		this.UpdateView()
		this.InitEvent()
	}

	public UpdateView() {
		let demons_id = this.data.demons_id
		let skill_id = this.data.skill_id
        for(let key in this.friend_model.other_demon_info){
            if(this.friend_model.other_demon_info[key].id == demons_id){
                this._gp_up.visible = false
                this.display_obj.height = 560
                this._Image1.height = 560
            }
        }
		let demon_data: DemonData = this.demon_model.GetDemonData(demons_id)

		let desc1 = ""

		let demons_cfgs = this.res_mgr.GetGameConfigFromCache(this, "ConfigDemon", true)
		if (demons_cfgs.LifeSkillDesc[demons_id]) {
			desc1 = desc1 + demons_cfgs.LifeSkillDesc[demons_id]
		}

		desc1 = desc1 + "<br/>"

		let demons_skill_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill", false)
		let max_value = this.demon_model.GetLifeSkillMaxProgress(demons_id, skill_id, demons_skill_cfgs)
		let value = 0
		let life_skill_data
		if (demon_data) {
			life_skill_data = demon_data.GetLifeSkillData(demons_skill_cfgs)
			if (life_skill_data) {
				value = life_skill_data.process
			}
		}

		desc1 = desc1 + "当前进度:" + HtmlColorTxt(max_value, "'#0a953e'") + "/" + max_value
		this._desc1.width=350
		this._desc1.innerHTML = Util.StrToHTML(desc1)

		let skill_cfg
		let demons_skill_map_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_map", false)
		if (demons_skill_map_cfgs) {
			skill_cfg = demons_skill_map_cfgs[skill_id]
		}
		if (skill_cfg) {
			let follow_skill_vo = new SkillVo(skill_cfg.skill_follow)
			this._lb_name.text = follow_skill_vo.getName()
			ResManager.GetInstance().SetTexture(this, this._img_icon, GameResPath.GetSkillIconPath(follow_skill_vo.GetIcon()))
			this._desc2.width=350
			this._desc2.innerHTML = "完成进度后即可激活特殊能力:<br/>" + follow_skill_vo.getDesc()
		}


		if (demon_data) {
			if (life_skill_data && life_skill_data.is_active == 1) {
				this.state = 2
			} else {
				this.state = 1
			}
		} else {
			this.state = 0
		}

		Util.SetImageGray(this._Image4, this.state == 0 || this.state == 2)
		this._Label1.text = this.state == 2 ? "已激活" : "激活"

		this._img_up_red.visible = life_skill_data && life_skill_data.is_active == 0 && value >= max_value && value != 0

	}

	public InitEvent() {

		Util.AddClickEvent(this._gp_up, () => {
			if (this.state == 2) {
				Message.show("已激活")
				return
			}

			if (this.state == 0) {
				Message.show("请先激活妖灵")
				return
			}

			if (this.data) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18316, this.data.demons_id)
			}
		}, this, true)

		this.BindEvent(this.demon_model, DemonEvent.UPDATE_SKILL_DATA, (demons_id?, skill_id?) => {
			if (this.data.demons_id == demons_id && this.data.skill_id == skill_id) {
				this.UpdateView()
			}
		})

		this.BindEvent(this.demon_model, DemonEvent.ACTIVE_DEMON_SKILL, (demons_id?, skill_id?) => {
			if (this.data.demons_id == demons_id && this.data.skill_id == skill_id) {
				//this.AddUIEffect("ui_ZiTi_Jihuo", this._gp_effect,{x:0,y:0},2,false)//激活成功
			}
		})
	}

	public Remove() {
		if (this.equip_item) {
			this.equip_item.DeleteMe()
			this.equip_item = null
		}
		this.ClearUIEffect(this._gp_effect)
	}
	public Open(...parms) {
		this.data = {
			demons_id: parms[0],
			skill_id: parms[1],
		}
		super.Open()
	}

	public GetComponents() {
		[
			this._Image1,
			this._img_bg,
			this._Image2,
			this._Image3,
			this._img_icon,
			this._lb_name,
			this._desc1,
			this._desc2,
			this._gp_up,
			this._Image4,
			this._Label1,
			this._img_up_red,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_bg",
				"_Image2",
				"_Image3",
				"_img_icon",
				"_lb_name",
				"_desc1",
				"_desc2",
				"_gp_up",
				"_Image4",
				"_Label1",
				"_img_up_red",
				"_gp_effect",
			])
		this._desc1.style.fontSize=24
		this._desc1.style.color="#663915"
		this._desc2.style.fontSize=24
		this._desc2.style.color="#663915"
	}
}
window["PlayerMessageDemonSkillTipsView"]=PlayerMessageDemonSkillTipsView