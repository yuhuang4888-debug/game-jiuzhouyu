import { BaseView1 } from "../common/BaseView1";
import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { LuaSoundManager } from "../common/SoundManager";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel";
import { StoryModel } from "../commonModel/StoryModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { Vector2 } from "../util/Vector2";

export class PartnerAwakeShowView extends BaseView1 {
	bg: Laya.Image
	closeBtn: Laya.Image
	role_con: Laya.Box
	title_img: Laya.Image
	fight_conta: Laya.Box
	Text: Laya.Label
	fight: Laya.Label
	skill_conta: Laya.Box
	image: Laya.Image
	skill_icon: Laya.Image
	skill_name: Laya.Label
	scroll: Laya.Panel
	Content: Laya.Box
	skill_desc: Laya.HTMLDivElement
	tip_conta: Laya.Box
	image1: Laya.Image
	image2: Laya.Image
	goBtn: Laya.Box
	image11: Laya.Image
	goBtnText: Laya.Label


	data
	model

	public constructor() {
		super()

		this.base_file = "partnerAwake"
		this.layout_file = "PartnerAwakeShowView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = false
		this.data = null
		this.model = PartnerAwakeModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			//打开界面时不显示引导
			StoryModel.ShowFingerLock[this.hashCode] = true
			this.OpenCallback()
		}
		this.close_callback = () => {
			// GlobalEventSystem.Fire(EventName.CLOSE_MOUNTPET_VIEW)
			if (this.goBtn) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.goBtn)
			}
			//打开界面时不显示引导
			delete StoryModel.ShowFingerLock[this.hashCode]
		}

	}

	public LoadSuccess() {
		ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetIcon("partnerAwake", "uiqlhx_000"))
	}

	public InitEvent() {
		let close_fun = () => {
			this.Close()
			if (this.model.show_return_finger) {
				OpenFun.OpenFunHandler(16)
			}
		}
		Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)


		let goBtn_fun = () => {
			OpenFun.OpenFunHandler(16)
			this.Close()
		}
		Util.AddClickEvent(this.goBtn, goBtn_fun, this, true)
	}

	public OpenCallback(...new_args) {
		if (!Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake) return
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.Partner
		if (cfg) {
			this.fight.text = cfg.fight
			this.skill_name.text = cfg.skill_name
			this.skill_desc.innerHTML = Util.StrToHTML(cfg.skill_desc)
			ResManager.GetInstance().SetTexture(this, this.skill_icon, GameResPath.GetSkillIconPath(cfg.skill_id))

			let func = () => {
				if (!this.use_delete_method) {
					this.SetModel()
				}
			}
			setTimeout(func, 500)
		}
	}


	public SetModel() {
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.Partner
		if (cfg) {
			let data = {
				res_id: Number(cfg.model_id),
				clothe_res_id: Number(cfg.model_id),
				type: UI_MODEL_TYPE.PARTNER,
				layer_value: this.layer_value,
				rotate: 0,
				position: new Vector2(0, -1),
				can_rotate: true,
				action_name_list: Util.DeepCopy(cfg.action),
				scale: cfg.scale,
				skill_id: cfg.skill_id
			}
			ResManager.GetInstance().SetRoleModel(this, this.role_con, data)

			if (this.model.show_return_finger) {
				let step_cfg = { direction: 8, text: "点击这里可以查看唤醒神巫所需要满足的条件哦~~", effect_scaleX: 0.7, effect_scaleY: 0.9 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.goBtn, this.layer_value, null, null, false, false, step_cfg, true)
			}
		}
	}


	public Open(...new_args) {
		let params = new_args
		super.Open()
	}



	public GetComponents() {
		[
			this.bg,
			this.closeBtn,
			this.role_con,
			this.title_img,
			this.fight_conta,
			this.Text,
			this.fight,
			this.skill_conta,
			this.image,
			this.skill_icon,
			this.skill_name,
			this.scroll,
			this.Content,
			this.skill_desc,
			this.tip_conta,
			this.image1,
			this.image2,
			this.goBtn,
			this.image11,
			this.goBtnText,
		]
			= this.GetChildrenByNames([

				"bg",
				"closeBtn",
				"role_con",
				"title_img",
				"fight_conta",
				"Text",
				"fight",
				"skill_conta",
				"image",
				"skill_icon",
				"skill_name",
				"scroll",
				"Content",
				"skill_desc",
				"tip_conta",
				"image1",
				"image2",
				"goBtn",
				"image11",
				"goBtnText",
			])
		this.skill_desc.style.fontSize = 20
		this.skill_desc.style.color = "#ffffff"
		this.skill_desc.width = 220
		this.skill_desc.style.leading = 5
		this.scroll.vScrollBar.visible = false
	}
}
window["PartnerAwakeShowView"] = PartnerAwakeShowView