import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { GoodsModel } from "../commonModel/GoodsModel";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { PetProptityView } from "../pet/PetProptityView";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { Vector2 } from "../util/Vector2";
import { PartnerDetailsView } from "./PartnerDetailsView";
import { PartnerModel } from "../commonModel/PartnerModel";
import { PartnerNucleusItem } from "./PartnerNucleusItem";
import { Partnerstar } from "./Partnerstar";
import { GiftPushIcon } from './../mainUI/GiftPushIcon';
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";


export class PartnerBaseView extends BaseItem1 {
	private giftItem: GiftPushIcon;
	fight_item
	auto_status
	color_shape
	curr_sorting_order
	data
	details_view
	model: PartnerModel
	model_name_
	proptity_view
	round_item
	select_id
	select_stage
	star_item

	/**是否切换到传记的页面 */
	is_switch =false

	public constructor(parent?) {
		super(parent)

		this.base_file = "partner"
		this.layout_file = "PartnerBaseView"
		this.star_item = []
		this.layer_value = Enum_UILayer.UI
		this.model = PartnerModel.GetInstance()
		// this.ReOpen_callback = () => {
		// 	this.ShowModel(true)
		// }
		this.preload_client_config = {
			"ClientOutWardModel": false,
			"ClientOutWardPos": false
		}
		this.preload_server_config = {
			"config_companion_stage": false,
			"config_companion_skill": false
		}
		this.load_callback = () => {
			this.Load_callback()
		}
	}

	public Load_callback() {
		this.fight_item = new FightingShowSmallItem(this._gp_fight)
		this.fight_item.Load()
		this.fight_item.IsCenter(true, false)
		
		this.InitEvent()
		this.InitView()
		this.select_stage = this.data && this.data.stage
		this.UpdateView()
		this.ShowGiftIcon();

		this._box_biog.visible =false

		this._box_biog_eff.visible=false
		this.AddUIEffect("effect_ui_shuxing",this._box_biog_eff,null,5,true)
		this.AddUIEffect("effect_ui_zhuanji",this._box_att_eff,null,5,true)
	}

	//升级培养红点
	private RefRed() {
		let red = this.model.GetRed()
		return red && !PartnerModel.Is_Requeste
	}

	//传记红点
	private UpdateBiogRed(){
		if(this.is_switch){
			this.btnred.visible = this.RefRed()	
		}else{
			this.btnred.visible = this.data?this.model.CheckCompanionRed(this.data.id):false
		}
		 
	}

	public InitEvent() {

		this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
			this.ShowGiftIcon();
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_BIOG_RED, () => {
			this.UpdateBiogRed()
		})

		Util.AddClickEvent(this._btn_switch,()=>{
			if(this.details_view)this.details_view.SwitchView()
			this.is_switch = !this.is_switch
			this._box_att.visible=!this.is_switch
			this._box_biog.visible = this.is_switch
			this.UpdateBiogRed()


			this._box_biog_eff.visible = this.is_switch
			this._box_att_eff.visible = !this.is_switch
			// let res = this.is_switch?"ui_witch_19":"ui_witch_18"
			// ResManager.GetInstance().SetImageSprite(this,this._img_switch,"partner",res)
		},this,true)

		Util.AddClickEvent(this.attr_tips, () => {
			if (!this.proptity_view) {
				this.proptity_view = new PetProptityView()
			}
			this.proptity_view.Open()
			if (this.data) {
				let info = this.model.GetInfo() // 整体信息
				if (!Util.IsTableEmpty(info.sum_attr)) {
					this.proptity_view.SetData(info.sum_attr)
				}

			}
		}, this)

		Util.AddClickEvent(this.gp_follow, () => {
			if (this.data) {
				this.model.Fire(PartnerModel.REQUSET_SCMD, 14203, this.data.id)
			}
		}, this)

		Util.AddClickEvent(this.gp_auto, () => {
			let bool = !this.auto_status
			if (bool) {
				Message.show("自动释放技能")
			} else {
				Message.show("手动释放技能")
			}
			this.RefAuto(bool)
		}, this)

		this.BindEvent(this.model, PartnerModel.UPDATE_FOLLOW, () => {
			this.RefFollow()
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_VIEW, () => {
			this.UpdateView()
		})

		this.BindEvent(this.model, PartnerModel.SELECTE_ID, (data?) => {
			if (this.data != data) {
				this.data = data
				this.UpdateView()
			}
		})

		let change_bag = (list?) => {
			if (list) {
				for (let k in list) {
					let v = list[k]
					let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(v.type_id)
					if (basic && basic.type == 22 && basic.subtype == 1) {
						this.RefRound()
						return
					}
				}
			}
		}
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_BAG_LIST, change_bag)

		/*运营需求
		let show = false
		let show_green_fun = (is_green?) => {
			show = !show
			if (this.color_shape) {
				destroy(this.color_shape)
				this.color_shape = null
			}
			if (show) {
				if (!this.color_shape) {
					this.color_shape = SetGreenOrBlackBg(this.form, is_green)
				}
			}
			this.detail.visible = !show
			this._gp_star.visible = !show
		}
		this.BindEvent(GlobalEventSystem, EventName.SHOW_GREEN_OR_BLACK_BG, show_green_fun)
		*/

		//激活，设置自动释放技能
		this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.OPEN_VIEW, (view?, data?) => {
			if (view == "OutwardChangedView" && data && data.id && data._type && data._type == 142 && this.data && data.id == this.data.id) {
				this.RefAuto(true)
			}
		})

		//升级特效
		this.BindEvent(this.model, PartnerModel.UP_LV_ANIMATION, (scmd?, old_info?) => {
			if (this.use_delete_method || !scmd || !old_info) { return }
			if (scmd.stage != old_info.stage) {
				//this.AddUIEffect("UI_1102_shengjiechenggong", this.layer_value, this.up_effect, null, null, false)
			}
		})
	}

	public InitView() {
		// this.bg.mask = new Laya.Rectangle(0, 0, 720, 992)
		ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetBigBgPath("ui_witch_bg.jpg"))

		if (!this.details_view) {
			this.details_view = new PartnerDetailsView(this.detail)
			this.details_view.SetData(this.select_id)
			this.details_view.Load()
		}

	}

	public UpdateView() {
		if (this.data) {
			this.RefStar()
			this.ShowModel()
			this.RefFollow()
			this.RefFight()
			this.RefRound()
			this.RefAuto()
			this.UpdateBiogRed()
			let info = this.model.GetInfoByID(this.data.id)
			// let stage = info.is_active == 1 ? info.stage + "阶" : "未激活"

			//提前加载好
			this.Round.visible = info.is_active == 1
			ResManager.GetInstance().SetOutsideImageSprite(this,this._img_biog,GameResPath.GetIconOtherPath("partner",this.data.figure_id),true)
			this.res_name.text = this.data.name
			this.res_stage.text = `${info.stage}阶`
		}
	}

	public RefRound() {
		if (!this.round_item) {
			this.round_item = new PartnerNucleusItem(this.Round)
			this.round_item.Load()
		}
		this.round_item.ExcuteCallback(() => {
			this.round_item.SetData(this.data)
		})
	}

	public ShowModel(bool?) {
		if (!this.data) { return }
		let cfg = this.data
		if (cfg) {
			let model_res = cfg.figure_id
			if (this.model_name_ == model_res && !bool) {
				return
			}
			this.model_name_ = model_res
			let action_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOutWardModel", true)
			let pos_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOutWardPos", true)
			let act_cfg = action_cfgs[model_res]
			let action_list = act_cfg && act_cfg.action_list
			let pos_cfg = pos_cfgs[model_res]
			let data = {
				clothe_res_id: model_res,
				type: UI_MODEL_TYPE.PARTNER,
				can_rotate: true,
				layer_value: this.layer_value,
				scale: pos_cfg && pos_cfg.scale,
				position: pos_cfg && pos_cfg.position,
				rotate: pos_cfg && pos_cfg.rotate,
				texture_size: new Vector2(507, 415),
				action_name_list: Util.DeepCopy(action_list),
				custom_sorting_order: this.curr_sorting_order,
			}
			ResManager.GetInstance().SetRoleModel(this, this.gp_model, data)
		}
	}

	//出战
	public RefFollow() {
		if (!this.data) { return }
		let one_info = this.model.GetInfoByID(this.data.id)
		
		this.gp_follow.visible = one_info && one_info.is_active == 1

		let res
		if (this.data && one_info.is_fight == 1) {
			// res = "uity_045c"
			this.follow_yes.visible = true
		} else {
			// res = "uity_045d"
			this.follow_yes.visible = false
		}
		// this.follow.skin = GameResPath.GetIcon("partner", `${res}`)// `partner_json.${res}_png`
	}

	//自动释放技能
	public RefAuto(bool?) {
		if (!this.data) { return }
		let one_info = this.model.GetInfoByID(this.data.id)
		this.gp_auto.visible = one_info && one_info.is_active == 1
		let res
		if (bool == undefined || bool == null) {
			bool = this.model.GetAutoStatus(this.data.id)
		}
		if (bool) {
			// res = "uity_045c"
			this.auto_yes.visible = true
			this.auto_status = true
		} else {
			// res = "uity_045d"
			this.auto_yes.visible = false
			this.auto_status = false
		}
		this.model.SetAutoStatus(this.data.id, this.auto_status)
		// this.auto.skin = GameResPath.GetIcon("partner", `${res}`) //`partner_json.${res}_png`
	}

	public RefFight() {
		if (!this.data) { return }
		let info = this.model.GetInfoByID(this.data.id)
		this.fight_item.Updatefighting(info && info.combat||0)
	}

	public RefStar(is_up?, stage?) {
		if (!this.data) { return }
		let data = this.data
		if (!data) { return }
		let info = this.model.GetInfoByID(this.data.id)
		let len = this.model.cfg_kv[7].value
		for (let i = 0; i < len; i++) {
			let item = this.star_item[i]
			if (!item) {
				item = new Partnerstar(this._gp_star)
				item.Load()
				this.star_item.push(item)
			}
			item.ExcuteCallback(() => {
				item.SetDate(i + 1, info)
			})
		}
	}


	public SetVisible(status?) {
		if (PartnerModel.Is_Requeste) {
			PartnerModel.Is_Requeste = false
			this.details_view.RefBtnText()
		}
		super.SetVisible(status)
	}

	public DeleteMe() {

		this.ClearUIEffect(this._box_biog_eff)
		this.ClearUIEffect(this._box_att_eff)

		if(this.fight_item){
			this.fight_item.DeleteMe()
			this.fight_item = null
		}
		if (this.proptity_view) {
			this.proptity_view.DeleteMe()
			this.proptity_view = undefined
		}
		if (this.details_view) {
			this.details_view.DeleteMe()
			this.details_view = undefined
		}
		if (this.round_item) {
			this.round_item.DeleteMe()
			this.round_item = undefined
		}
		if (!Util.IsTableEmpty(this.star_item)) {
			for (let k in this.star_item) {
				let v = this.star_item[k]
				v.DeleteMe()
			}
			this.star_item = []
		}
		/*运营需求
		if (this.color_shape) {
			destroy(this.color_shape)
			this.color_shape = null
		}
		*/
		if (this.giftItem) {
			this.giftItem.DeleteMe();
			this.giftItem = null;
		}

		super.DeleteMe()
	}

	private ShowGiftIcon() {
		let pushGiftModel: PushGiftModel = PushGiftModel.GetInstance();
		let type: EnumPushGiftType = pushGiftModel.GetGiftList(EnumPushGiftType.eShenWu) ? EnumPushGiftType.eShenWu : EnumPushGiftType.eShenWuShengJi;
		let bool: boolean = Boolean(pushGiftModel.GetGiftList(type));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, type);
			});

		}
		this.giftIcon.visible = bool;
	}

	public CustomMehod(index?, args?) {
		if (!Util.IsTableEmpty(args)) {
			this.select_id = args[0]
		}
	}


bg:Laya.Image
image1:Laya.Image
_box_att:Laya.Box
gp_model:Laya.Box
giftIcon:Laya.Box
up_effect:Laya.Box
Round:Laya.Box
proview:Laya.Image
gp_auto:Laya.Box
auto:Laya.Image
auto_yes:Laya.Image
_lb_auto:Laya.Label
gp_follow:Laya.Box
follow:Laya.Image
follow_yes:Laya.Image
_lb_follow:Laya.Label
illusion:Laya.Box
_gp_fight:Laya.Box
_box_biog:Laya.Box
_img_biog:Laya.Image
_Group5:Laya.Box
_Image1:Laya.Image
_Group4:Laya.HBox
res_name:Laya.Label
res_stage:Laya.Label
_gp_star:Laya.HBox
left:Laya.Box
right:Laya.Box
detail:Laya.Box
attr_tips:Laya.Image
_btn_switch:Laya.Box
_box_biog_eff:Laya.Box
_box_att_eff:Laya.Box
btnred:Laya.Image
public GetComponents() {
[
this.bg,
this.image1,
this._box_att,
this.gp_model,
this.giftIcon,
this.up_effect,
this.Round,
this.proview,
this.gp_auto,
this.auto,
this.auto_yes,
this._lb_auto,
this.gp_follow,
this.follow,
this.follow_yes,
this._lb_follow,
this.illusion,
this._gp_fight,
this._box_biog,
this._img_biog,
this._Group5,
this._Image1,
this._Group4,
this.res_name,
this.res_stage,
this._gp_star,
this.left,
this.right,
this.detail,
this.attr_tips,
this._btn_switch,
this._box_biog_eff,
this._box_att_eff,
this.btnred,
]
 = this.GetChildrenByNames([

"bg",
"image1",
"_box_att",
"gp_model",
"giftIcon",
"up_effect",
"Round",
"proview",
"gp_auto",
"auto",
"auto_yes",
"_lb_auto",
"gp_follow",
"follow",
"follow_yes",
"_lb_follow",
"illusion",
"_gp_fight",
"_box_biog",
"_img_biog",
"_Group5",
"_Image1",
"_Group4",
"res_name",
"res_stage",
"_gp_star",
"left",
"right",
"detail",
"attr_tips",
"_btn_switch",
"_box_biog_eff",
"_box_att_eff",
"btnred",
])
}
}
 window["PartnerBaseView"]= PartnerBaseView