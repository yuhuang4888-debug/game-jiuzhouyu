import { BaseAwardItem } from "./BaseAwardItem"
import { EquipModel } from "../commonModel/EquipModel"
import { GodBeastModel } from "../commonModel/GodBeastModel"
import { GodBefallDefine, GodBefallModel } from "../commonModel/GodBefallModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { LungModel } from "../commonModel/LungModel"
import { PetEquipDefine } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { ColorUtil } from "../util/ColorUtil"
import { SetLocalScale, SetAnchoredPosition, SetAnchoredPositionY, AtlasUrl, SetSizeDeltaY } from "../util/Util"
import { Config } from "./Config"
import { ResManager } from "./ResManager"
import { RevelationModel } from "../commonModel/RevelationModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { longlangModel } from "../commonModel/longlangModel"
import { EnumSubType, EnumSuitType, SuitModel } from "../commonModel/SuitModel"
import { PlatformManager } from "../PlatformManager"


export class EquipmentItem extends BaseAwardItem {
	grade_out_line
	stren_txt_y_cahe
	show_count
	starEquipCache
	goods_id
	_grade
	_god_icon
	height_value
	cache_select_state
	grade_out_line_color_cache
	grade_cache
	grade_force
	grade_extension_cache
	show_getIcon
	stren_cache
	width_vlaue
	equip_attr
	star_cache
	starTex_cache
	grade_color_cache
	show_tips
	save_by_batch
	star_list
	show_grade
	show_name_cache
	is_refresh_gray
	cache_gray

	private _isSuitAni: boolean;

	// function EquipmentItem.Constructor(parent,show_tips)
	public constructor(parent?, prefab_asset?, layer_value?, show_tips?, save_by_batch?, isSuitAni: boolean = false) {
		super(parent)
		this.star_list = []
		this.show_tips = true
		this.show_count = true
		this.show_getIcon = false
		this.width_vlaue = 0
		this.height_value = 0
		this.base_file = "common"
		this.layout_file = "EquipmentItem"
		this.cache_gray = false
		this.save_by_batch = save_by_batch
		if (show_tips == null) {
			show_tips = true
		}
		this.show_tips = show_tips
		this._isSuitAni = isSuitAni
	}

	private get suitModel() {
		return SuitModel.GetInstance();
	}

	public LoadSuccess() {
		// this.GetComponents()

		this.num_text.style.height = 30
		this.num_text.style.fontSize = 24
		this.num_text.style.color = "#ffffff"
		this.num_text.style.strokeColor = "#000000"
		this.num_text.style.stroke = 1
		this.num_text.style.valign = "bottom"
		this.num_text.style.bold = true

		this.stren_txt_y_cahe = this.stren.y

		this._god_icon = this.god_icon

		this.star_list = []
		let i = 0
		do {
			this.star_list[i] = this.star_group.getChildAt(i)
			i = i + 1
		} while ((i < 4))

		if (this.is_refresh_gray) {
			this.SetGary(this.cache_gray)
			this.is_refresh_gray = null
		}

		super.LoadSuccess()
	}

	public Clear() {
		this.SetGrade(0)
		this.SetStar(0)
		this.SetStrengthen(0)
		// this.ClearUIEffect(this.effBox);
		// this.ClearUIEffect(this.effBox1);
		// this.ClearUIEffect(this.effBox2);
		super.Clear()
	}

	public SetData(type_id?, goods_num?, is_lock?, select?, show_getIcon?, not_show_effect?, rating?, equip_extra_attr?, goods_id?, lv?, god_lv?, effect_callback?, show_name?, show_grade = true) {
		
		this.ChangeCountVisible(true)
		super.SetData(type_id, goods_num, is_lock, select, show_getIcon, not_show_effect, rating, equip_extra_attr, goods_id, lv, god_lv, effect_callback, show_name)
		this.SetPetEquipGroupVisible(false)
		this.SetLungConVisible(false)
		this.SetGodIconVisible(false)
		this.SetBadIconVisible(false)
		if (this.goods_basic) {
			if (this.goods_basic.type == 10) {
				this.ResConfig()
			} else if (this.goods_basic.type == 39) {
				let god_beast_model = GodBeastModel.GetInstance()
				ResManager.GetInstance().LoadGameConfig(this, "config_eudemons_equip_attr", false, undefined, (cfgs?) => {
					if (!this.use_delete_method) {
						let data = god_beast_model.GetEquipData(this.goods_basic.type_id, cfgs)
						let star = (data && (data.star) || (0))
						this.SetStar(star)
					}
					ResManager.GetInstance().DestoryGameConfig(this, "config_eudemons_equip_attr", false)
				})
			} else if (this.goods_basic.type == UnrealModel.goods_type) {
				this.ResUnrealConfig()
			} else if (this.goods_basic.type == HolySealModel.GOODS_TYPE) {
				let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_equip", false)
				let equip_data = HolySealModel.GetInstance().GetHolySealData(this.goods_basic.type_id, config_seal_equip)
				if (equip_data) {
					this.SetGrade(equip_data.stage)
				}
				this.ChangeCountVisible(false)
			} else if (this.goods_basic.subtype <= PetEquipDefine.EQUIP_POS_COUNT && (this.goods_basic.type == PetEquipDefine.HORSE_TYPE_ID || this.goods_basic.type == PetEquipDefine.PARTNER_TYPE_ID)) {
				this.AddPetEquipComponent()
			} else if (this.goods_basic.type == GodBefallDefine.EQUIP_TYPE) {
				let data = EquipModel.GetInstance().GetEquipData(this.goods_basic.type_id)
				let star = (data && (data.star) || (0))
				this.SetStar(star)
				this.AddGodComponent(this.goods_basic.type_id)
				this.SetGodIconVisible(true)
			} else if (this.goods_basic.type == RevelationModel.GOODS_TYPE) {
				this.SetRevelationModelStar(type_id)
			} else if (this.goods_basic.type == longlangModel.GOODS_TYPE) {
				this.SetLonglangStage(type_id)
			} else if (this.goods_basic.type == GodCourtModel.GoodsType && this.goods_basic.subtype < 17) {
				if (this.goods_basic.subtype < 9) {
					this.SetStar(0)
				} else {
					this.SetStar(Math.min(this.goods_basic.type_id % 10, 5))
				}
			}

			// 圣衣换星星UI
			if (this.goods_basic.type == 79) {
				this.ChangeStarTex()
			}

			// 共鸣特效
			let googdsId: number = this.suitModel.GetWearGoogdsIdByTypeId(this.goods_basic.type_id);
			let bool: boolean = this._isSuitAni && googdsId > 0 && (googdsId == (this.goods_id || 0));

			let clearSuitEff = () => {
				if (this.is_loaded && this?.effBox && this?.effBox1 && this?.effBox2) {
					this.effBox.visible = false;
					this.effBox1.visible = false;
					this.effBox2.visible = false;
					this.ClearUIEffect(this.effBox);
					this.ClearUIEffect(this.effBox1);
					this.ClearUIEffect(this.effBox2);
				}
			}

			if (bool && this.goods_basic?.equip_type) {
				let effName: string = this.suitModel.GetPosEquipShowSuitAni(this.goods_basic.equip_type, googdsId);
				if (effName) {
					this.SetSuitEffAni(effName);
				} else {
					clearSuitEff();
				}
			} else {
				clearSuitEff();
			}



		}
		if (this.show_name) {
			this.ShowName(this.show_name)
		}
		if (show_grade) {
			this.show_grade = show_grade
		}
		if (this.stren_cache) {
			this.SetStrengthen(this.stren_cache)
			this.stren_cache = null
		}
		if (this.grade_cache) {
			this.SetGrade(this.grade_cache, this.grade_extension_cache, this.grade_force)
			this.grade_force = null
			this.grade_extension_cache = null
			this.grade_cache = null
		}
		if (this.star_cache != null) {
			this.SetStar(this.star_cache)
			this.star_cache = null
		}
		if (this.starTex_cache) {
			this.ChangeStarTex()
			this.starTex_cache = null
		}
		if (this.cache_select_state != null) {
			this.setSelectState(this.cache_select_state)
		}
		if (this.starEquipCache) {
			this.SetStarEquipStar(this.starEquipCache[0], this.starEquipCache[1])
			// } else if (this.goods_basic && this.goods_basic.type == starEquipModel.GOODS_TYPE && this.goods_basic.subtype < 11) {
			// 	this.SetStarEquipStar(this.goods_basic.color, starEquipModel.GetInstance().GetEquipStar(type_id))
		}



	}

	public ShowName(is_show?) {
		if (this.is_loaded) {
			if (is_show && this.goods_basic) {
				this._lb_name.visible = true
				this._lb_name.fontSize = 26
				this._lb_name.color = "#ffffff"//ColorUtil.GetColorDark(this.goods_basic.color,false)
				this._lb_name.stroke = 2
				this._lb_name.strokeColor = ColorUtil.GetColorDark(this.goods_basic.color, false)
				this._lb_name.text = this.goods_basic.goods_name
			}
		}
		else {
			this.show_name_cache = is_show
		}
	}

	public ChangeStarTex() {
		if (!this.is_loaded) {
			this.starTex_cache = true
			return
		}
		for (let i = 0; i < 4; i++) {
			let star_img = this["starE" + i]
			if (star_img) {
				ResManager.GetInstance().SetImageSprite(this, star_img, "starEquip", "uixzsy_star2")
			}
		}
	}

	public SetRevelationModelStar(type_id?) {
		let star = 0
		ResManager.GetInstance().GetGameConfigWithAutoDestory("config_revelation_equip_attr", (cfg) => {
			if (!cfg) {
				return
			}

			let cur_cfg = cfg[Number(type_id)]
			if (cur_cfg) {
				star = cur_cfg.star
			}
			if (this.use_delete_method) {
				return
			}
			this.SetStar(star)
		}, false)
	}

	public SetLonglangStage(type_id?) {
		let stage = 0
		let GetStage = () => {
			let cur_cfg = Config.PRELOAD_SERVER_CONFIG.config_draconic_equip[type_id]
			if (cur_cfg) {
				stage = cur_cfg.stage
			}
		}
		GetStage()
		if (this.use_delete_method) {
			return
		}
		this.SetGrade(stage)
	}

	public ResConfig() {


		this.equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
		if (this.equip_attr && this.type_id) {

			let equip_attr = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.type_id, false, this.equip_attr)
			if (equip_attr) {
				this.SetGrade(equip_attr.stage)
				this.SetStar(equip_attr.star)
				this.SetBadIconVisible(equip_attr.class_type == 1)
			}
		}
	}

	public ResUnrealConfig() {
		ResManager.GetInstance().LoadGameConfig(this, "config_decoration_attr", false, undefined, (cfgs?) => {
			if (!this.use_delete_method) {
				if (cfgs && this.type_id) {
					let equip_attr = cfgs[this.type_id]
					if (equip_attr) {
						this.SetGrade(equip_attr.stage)
						this.SetStar(equip_attr.star)
					}
				}
			}
			ResManager.GetInstance().DestoryGameConfig(this, "config_eudemons_equip_attr", false)
		})
	}

	public SetStar(num?) {
		if (this.is_loaded) {
			for (let i = 0; i < 4; i++) {
				if (this.star_list[i]) {
					this.star_list[i].visible = i < num
				}
			}
		} else {
			this.star_cache = num
		}
	}

	public SetStrengthen(stren?, force_show?) {

		//设置位置因为布局不同 功能需要用到在设置
		if (this.is_loaded) {
			if (stren && stren > 0 || force_show) {
				if (this.goods_basic) {
					if (this.goods_basic.type == 26 && this.goods_basic.sub_type != 99) {
						// this.stren.verticalAlign = "bottom"
						// this.stren.textAlign = "left"
						// this.stren.text = "Lv." + stren

						this.stren.align = "left"
						this.stren.text = `Lv.${stren}`
						this.stren.y = this.display_obj.height - this.stren.height - this.stren_txt_y_cahe
					} else if (this.goods_basic.type == 28 && this.goods_basic.sub_type != 99) {
						// this.stren.verticalAlign = "top"
						// this.stren.textAlign = "left"
						// this.stren.text = "Lv." + stren
						this.stren.align = "left"
						this.stren.text = `Lv.${stren}`
						this.stren.y = this.display_obj.height - this.stren.height - this.stren_txt_y_cahe
					} else if (this.goods_basic.type == 39 && this.goods_basic.sub_type != 99) {
						// this.grade.verticalAlign = "top"
						// this.grade.textAlign = "right"
						// this.grade.text = "Lv." + stren
						this.grade.align = "right"
						this.grade.text = `Lv.${stren}`
						// this.grade.y = this.display_obj.height - this.stren.height - this.stren_txt_y_cahe

					} else if (this.goods_basic.type == PetEquipDefine.HORSE_TYPE_ID
						|| this.goods_basic.type == PetEquipDefine.PARTNER_TYPE_ID) {
						this.stren.fontSize = 20
						this.stren.text = "+" + stren
					} else {
						// this.stren.align = "right"
						// this.stren.text = `+${stren}`
						this.stren.y = this.stren_txt_y_cahe || 0

						this.stren.valign = "top"
						this.stren.align = "right"
						this.stren.text = "+" + stren
					}
				}
			} else {
				this.stren.text = ""
			}
		} else {
			this.stren_cache = stren
		}
	}

	public SetGrade(grade?, extension_name = "阶", force = false) {
		// if (!this.show_grade) return
		if (this.is_loaded) {
			if (this.goods_basic && (this.goods_basic.type == HolySealModel.GOODS_TYPE || this.goods_basic.type == longlangModel.GOODS_TYPE)) {
				this.grade.bottom = 16
				// SetAnchoredPositionY(this._grade, 16)
				let color = HolySealModel.GetInstance().GetStage2StrokeColor(this.color)
				this.grade_out_line_color_cache = ColorUtil.TryParseHtmlString(color)
				let source = HolySealModel.GetInstance().GetStage2BgSource(this.color)
				ResManager.GetInstance().SetImageSprite(this, this._img_grade_bg, "common_asset", source, true)

				//this._img_grade_bg.source =
				this._img_grade_bg.visible = true
			} else {
				SetAnchoredPositionY(this._grade, 9)
				this._img_grade_bg.visible = false
				this.grade_out_line_color_cache = ColorUtil.TryParseHtmlString("000000")
			}
			this.SetGradeColor()
			if ((grade && grade > 0) || force) {
				if (PlatformManager.IsEyouEnPlatform()) {
					this.grade.text = "G" + grade
				} else if (PlatformManager.IsEyouThPlatform()) {
					this.grade.text = "ขั้น" + grade
				} else {
					this.grade.text = grade + extension_name
				}
			} else {
				this.grade.text = ""
			}
		} else {
			this.grade_cache = grade
			this.grade_extension_cache = extension_name
			this.grade_force = force
		}

	}

	public SetGradeColor() {

		// if (this.is_gary) {
		// 	this._img_grade_bg.GetComponent("Image").gray = true
		// 	//this.grade.color = ColorUtil.TryParseHtmlString(ColorUtil.GRAY)
		// 	this.grade_out_line.effectColor = ColorUtil.TryParseHtmlString(ColorUtil.GRAY)
		// } else {
		// 	this._img_grade_bg.GetComponent("Image").gray = false
		// 	//this.grade.color = this.grade_color_cache
		// 	this.grade_out_line.effectColor = this.grade_out_line_color_cache
		// }

	}

	public SetRedDot(bool?) {

		if (this.red_dot) {
			this.red_dot.visible = bool
		}
	}

	public SetUpMark(visible?: boolean): void {
		if (this.up_image) {
			this.up_image.visible = false
			if(visible){
				this.up_image.visible = true
				this.ClearItemEffect()
				this.AddUIEffect("ui_goods_orange_plus", this.effect_con, null, 14, true)
			}
		}
		
	}

	public SetGary(bool?) {
		this.cache_gray = bool
		if (this.is_loaded) {
			this.is_refresh_gray = false
			super.SetGary(bool)
			this.SetGradeColor()
		} else {
			this.is_refresh_gray = true
		}
	}

	public AddPetEquipComponent() {
		if (!this.is_loaded) {
			return
		}
		if (!this.goods_basic) {
			this.UpdatePetEquipGroup(0, 0)
			return
		}
		let pemodel = PetEquipModel.GetInstance()
		let type = pemodel.GetTypeByGoodType(this.goods_basic.type)
		let bdata = pemodel.GetPetEquipGoodOne(type, this.goods_id)
		if (bdata) {
			let sdata = pemodel.GetStageData(type, bdata.equip_type, bdata.equipStage)
			let color = sdata ? sdata.color : (0)
			this.UpdatePetEquipGroup(color, bdata.equipStar)
			this.SetGrade(bdata.equipStage)
		} else {
			let gdata = pemodel.GetGoodsData(Number(this.type_id))
			let sdata = pemodel.GetStageData(type, gdata.pos, gdata.stage)
			let color = sdata ? sdata.color : (0)
			let star = gdata ? gdata.star : (0)
			this.UpdatePetEquipGroup(color, star)
			this.SetGrade(gdata.stage)
		}
		this.SetPetEquipGroupVisible(true)
		this.goods_id = null
	}

	public UpdatePetEquipGroup(color?, star?) {
		this.petEquipstage.text = star
		if (color >= 0) {
			ResManager.GetInstance().SetImageSprite(this, this.petEquip, "common_asset", "uiwg_color_" + color)
			ResManager.GetInstance().SetImageSprite(this, this.item_bg, "common_asset", "com_goods_plate_" + color)
		}
	}

	public SetPetEquipGroupVisible(visible?) {


		if (this._pet_equip_gp) {
			this._pet_equip_gp.visible = visible
		}
	}

	public SetLungConVisible(bool?) {

		if (this.is_loaded && this.lung_con) {
			this.lung_con.visible = bool
		}
	}

	public SetBadIconVisible(bool?) {

		if (this.is_loaded && this._bad_icon) {
			this._bad_icon.visible = bool
		}
	}

	public SetLungStyle() {
		if ((this.is_loaded && this.goods_basic) && this.goods_basic.lv) {
			let [lv, star_num] = LungModel.GetInstance().GetLungRealLvAndStar(this.goods_basic.lv)
			this.lung_con.visible = star_num > 0
			this.lung_star_num.text = star_num
			if (this.goods_basic) {
				this.star_bg.skin = AtlasUrl("common", "uiwg_color_" + this.goods_basic.color)
			}
		}
	}

	public AddGodComponent(type_id?) {

		if (!this.is_loaded) {
			return
		}
		let data = GodBefallModel.GetInstance().GetEquipData(type_id)
		if (!data) {
			return
		}
		this._god_icon.visible = true
		SetLocalScale(this._god_icon.transform, this.display_obj.scaleX, this.display_obj.scaleX, 1)
		let sp_name = "gbl_" + data.limit
		ResManager.GetInstance().SetImageSprite(this, this._god_icon, "common_asset", sp_name, true)
	}

	public SetGodIconVisible(visible?) {

		if (this._god_icon) {
			this._god_icon.visible = visible
		}
	}

	public SetSkillImg(visible?) {

		if (this.skillImg) {
			this.skillImg.visible = visible
		}
	}

	public SetAwake(bool?) {

		if (this._img_awaken) {
			this._img_awaken.visible = bool
		}
	}

	public setTipsImg(res?, abName?) {

		if (!this._img_tips) {
			return
		}
		if (!res) {
			this._img_tips.visible = false
			return
		}
		this._img_tips.visible = true
		if (abName) {
			ResManager.GetInstance().SetImageSprite(this, this._img_tips, abName, res, true)
			//this._img_tips.source = res
		} else {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tips, res, true)
			//lua_resM:SetTexture(this, this._img_tips, res)
		}

		// this.CoverEffect(this._img_tips.transform, this.layer_value || "UI", this.cache_order)
	}
	public setTipsImgPos(x?, y?) {

		if (!this._img_tips) {
			return
		}
		let x_ = x && x || this._img_tips.x
		let y_ = y && y || this._img_tips.y
		SetAnchoredPosition(this._img_tips, x_, y_)
	}
	public setTipsImgSize(x?, y?) {

		if (!this._img_tips) {
			return
		}
		let x_ = x && x || 1
		let y_ = y && y || 1
		SetLocalScale(this._img_tips, x_, y_, 1)
	}

	public setTipsImgBySource(res?) {

		if (this._img_tips) {
			this._img_tips.source = res
		}
	}

	public setTagImgState(bool?) {

		if (this._img_tips) {
			this._img_tips.visible = bool
		}
	}

	public setSelectState(bool?) {
		if (this.is_loaded) {
			this.select_image.visible = bool
		} else {
			this.cache_select_state = bool
		}
	}

	public SetStarEquipStar(color?, star?) {
		if (!this.is_loaded) {
			this.starEquipCache = [color, star]
		} else {
			if (star && star > 4) {
				for (let i = 0; i <= 3; i++) {
					this["starE" + i].visible = i == 1
				}
				this.starEquipNum.visible = true
				this.starEquipGp.visible = true
				ResManager.GetInstance().SetImageSprite(this, this.starEquipStarBg, "common_asset", "flag" + color)
				SetSizeDeltaY(this.starEquipStarBg, 63)
			} else if (star && star > 0) {
				for (let i = 0; i <= 3; i++) {
					this["starE" + i].visible = i < star
				}
				this.starEquipNum.visible = false
				this.starEquipGp.visible = true
				ResManager.GetInstance().SetImageSprite(this, this.starEquipStarBg, "common_asset", "flag" + color)
				SetSizeDeltaY(this.starEquipStarBg, star * 20 + 23)
			} else if (this.starEquipGp) {
				this.starEquipGp.visible = false
			}
			this.starEquipCache = null
		}
	}



	/**
	 * 设置共鸣特效
	 */
	public SetSuitEffAni(aniName: string) {
		if (this.is_loaded && this?.effBox && this?.effBox1 && this?.effBox2 && aniName) {
			let pos: { x: number, y: number } = { x: 0, y: 0 };
			let subType: number = this.suitModel.GetSubTypeByEffName(aniName)

			this.effBox.visible = subType == EnumSubType.eOne;
			this.effBox1.visible = subType == EnumSubType.eTwo;
			this.effBox2.visible = subType == EnumSubType.eThree;
			let box: Laya.Box;
			switch (subType) {
				case EnumSubType.eOne:
					this.effBox.scaleX = 1;
					this.effBox.scaleY = 1;
					box = this.effBox;
					break;
				case EnumSubType.eTwo:
					this.effBox1.scaleX = 1.3;
					this.effBox1.scaleY = 1;
					box = this.effBox1;
					pos.x = 0.5;
					break;
				case EnumSubType.eThree:
					this.effBox2.scaleX = 1.3;
					this.effBox2.scaleY = 1.3;
					box = this.effBox2;
					break;
			}
			this.AddUIEffect(aniName, box, pos, 10, true);
		}
	}


	click_group: Laya.Box
	item_bg: Laya.Image
	icon: Laya.Image
	lock: Laya.Image
	select_image: Laya.Image
	stren: Laya.Label
	_img_grade_bg: Laya.Image
	grade: Laya.Label
	num_text: Laya.HTMLDivElement
	red_dot: Laya.Image
up_image:Laya.Image
	lung_con: Laya.Box
	star_bg: Laya.Image
	_Group1: Laya.HBox
	lung_star_num: Laya.Label
	_Image1: Laya.Image
	skillImg: Laya.Image
	_bad_icon: Laya.Image
	_img_awaken: Laya.Image
	_img_tips: Laya.Image
	starEquipGp: Laya.Box
	starEquipStarBg: Laya.Image
	starE0: Laya.Image
	starE1: Laya.Image
	starE2: Laya.Image
	starE3: Laya.Image
	starEquipNum: Laya.Image
	_pet_equip_gp: Laya.Box
	petEquip: Laya.Image
	petEquipstage: Laya.Label
	Image: Laya.Image
	god_icon: Laya.Image
star_group:Laya.Box
star_0:Laya.Image
star_1:Laya.Image
star_2:Laya.Image
star_3:Laya.Image
	effect_con: Laya.Box
	_lb_name: Laya.Label
	effBox: Laya.Box
	effBox1: Laya.Box
	effBox2: Laya.Box
time_limit:Laya.Image
	public GetComponents() {
		[
			this.click_group,
			this.item_bg,
			this.icon,
			this.lock,
			this.select_image,
			this.stren,
			this._img_grade_bg,
			this.grade,
			this.num_text,
			this.red_dot,
this.up_image,
			this.lung_con,
			this.star_bg,
			this._Group1,
			this.lung_star_num,
			this._Image1,
			this.skillImg,
			this._bad_icon,
			this._img_awaken,
			this._img_tips,
			this.starEquipGp,
			this.starEquipStarBg,
			this.starE0,
			this.starE1,
			this.starE2,
			this.starE3,
			this.starEquipNum,
			this._pet_equip_gp,
			this.petEquip,
			this.petEquipstage,
			this.Image,
			this.god_icon,
this.star_group,
this.star_0,
this.star_1,
this.star_2,
this.star_3,
			this.effect_con,
			this._lb_name,
			this.effBox,
			this.effBox1,
			this.effBox2,
this.time_limit,
		]
			= this.GetChildrenByNames([
				"click_group",
				"item_bg",
				"icon",
				"lock",
				"select_image",
				"stren",
				"_img_grade_bg",
				"grade",
				"num_text",
				"red_dot",
"up_image",
				"lung_con",
				"star_bg",
				"_Group1",
				"lung_star_num",
				"_Image1",
				"skillImg",
				"_bad_icon",
				"_img_awaken",
				"_img_tips",
				"starEquipGp",
				"starEquipStarBg",
				"starE0",
				"starE1",
				"starE2",
				"starE3",
				"starEquipNum",
				"_pet_equip_gp",
				"petEquip",
				"petEquipstage",
				"Image",
				"god_icon",
"star_group",
"star_0",
"star_1",
"star_2",
"star_3",
				"effect_con",
				"_lb_name",
				"effBox",
				"effBox1",
				"effBox2",
"time_limit",
			])
	}
}
window["EquipmentItem"] = EquipmentItem