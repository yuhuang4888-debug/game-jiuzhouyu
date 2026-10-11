import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { PrayModel } from "../commonModel/PrayModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetSizeDelta, SetAnchoredPosition, SetSizeDeltaX, Util, GetSizeDeltaX } from "../util/Util"
import { PrayItemView } from "./PrayItemView"

export class PrayMainView extends BaseItem1 {
	ExpAnim
	InitEvent
	InitView
	RefreshExp
	_Group1
	_Group2
	_Group3
	_Image1
	_Image2
	_Image3
	_Label1
	_Label2
	_bit_lv
	_exp_up_id
	_gp_dec
	_gp_effect
	_gp_pray_item
	_img_bg
	_img_mask
	_img_mask_bg
	_lb_dec_1
	_lb_exp
	destiny_gp
	effect_tween_id
	exp_pray
	gold_pray
	mask_tween_id
	level_box
	money_baoji
	exp_baoji

	public constructor(parent?) {
		super(parent)


		this.base_file = "pray"
		this.layout_file = "PrayMainView"
		let model = PrayModel.GetInstance()
		let local_PrayModel = PrayModel
		let role_mgr = RoleManager.GetInstance()
		let _last_exp = 0
		let _last_lv = 0
		let _exp_mask = null
		let _is_getExp = 0
		this.preload_server_config = { "config_pray_reward": false,"config_reincarnation_cfg":false}
		this.load_callback = () => {

			// if (PlatformManager.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label1.size  = 20
			// 	this._Label2.size  = 22
			// } else if (PlatformManager.GetInstance().IsEyouThPlatform() ) {
			// 	SetSizeDelta(this._Image2 , 56, 43)
			// 	SetAnchoredPosition(this._Image2 , 3, -6.5)
			// }
			// if (PlatformManager.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label1.size  = 20
			// 	this._Label2.size  = 20
			// }
			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			let GetPrayInfo = () => {
				if (this.gold_pray) {
					this.gold_pray.ExcuteCallback(() => {
						this.gold_pray.UptatePrayNum(model.pray_info_list, 1)
					})
				}
				if (this.exp_pray) {
					this.exp_pray.ExcuteCallback(() => {
						this.exp_pray.UptatePrayNum(model.pray_info_list, 2)
					})
				}
			}

			this.BindEvent(model, local_PrayModel.GET_PRAY_INFO, GetPrayInfo)
			let GetRewardCallBack = () => {
				//SoundManager:GetInstance():PlaySoundEffect("3_huode")
				if(!this.use_delete_method){
					let dec = (model.pray_reward_dic["type"] == 1 && ("铜币") || ("经验"))
					let crit_str = (model.pray_reward_dic["crit"] > 1 && ("(" + model.pray_reward_dic["crit"] + "倍暴击)") || (""))
					let str = "获得<font color='#b3ff48'>" + dec + "x" + model.pray_reward_dic["reward"] + crit_str + "</font>"
					Message.show(str)
					let view = (model.pray_reward_dic["type"] == 1 && (this.gold_pray) || (this.exp_pray))
					view.UptatePrayNum(model.pray_info_list, model.pray_reward_dic["type"], true, model.pray_reward_dic["crit"])
					if (model.pray_reward_dic["type"] == 2) {
						_is_getExp = _is_getExp + 1
					}
					// if(model.pray_reward_dic["crit"] > 1){
					// 	Laya.Tween.to(this.root_con,{ scaleX: 1, scaleY: 1 },700,Laya.Ease.backOut,Laya.Handler.create(this,()=>{

					// 	}))
					// }
					if(model.pray_reward_dic["type"] == 1){
						if(model.pray_reward_dic["crit"] > 1){
							this.money_baoji.skin="resource/game/pray/texture/uiqy_icon_"+(model.pray_reward_dic["crit"]-1)+".png"
							this.money_baoji.visible=true
							this.money_baoji.scaleX=0.01
							this.money_baoji.scaleY=0.01
							this.money_baoji.alpha=1
							Laya.Tween.to(this.money_baoji,{ scaleX: 0.7, scaleY: 0.7 },300,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
								Laya.Tween.to(this.money_baoji,{ alpha: 0 },500,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
								}))
							}))
						}

					}else{
						if(model.pray_reward_dic["crit"] > 1){
							this.exp_baoji.skin="resource/game/pray/texture/uiqy_icon_"+(model.pray_reward_dic["crit"]-1)+".png"
							this.exp_baoji.visible=true
							this.exp_baoji.scaleX=0.01
							this.exp_baoji.scaleY=0.01
							this.exp_baoji.alpha=1
							Laya.Tween.to(this.exp_baoji,{ scaleX: 0.7, scaleY: 0.7 },300,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
								Laya.Tween.to(this.exp_baoji,{ alpha: 0 },500,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
								}))
							}))
						}
					}
				}
			}

			this.BindEvent(model, local_PrayModel.GET_PRAY_REWARD, GetRewardCallBack)
			let exp_change = () => {
				Laya.timer.once(100,this,()=>{
					if(this.use_delete_method) return
					this.RefreshExp()
				})
			}

			this._exp_up_id = role_mgr.GetMainRoleVo().BindOne("exp", exp_change)
		}

		this.InitView = () => {
			let url = GameResPath.GetIcon("pray", "uiqy_019")
			ResManager.GetInstance().SetTexture(this,this._img_mask_bg,GameResPath.GetIcon("pray","uiqy_015"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, url)
			this.gold_pray = new PrayItemView(this._gp_pray_item, null, null, 1, model.pray_info_list)
			this.gold_pray.Load()
			this.exp_pray = new PrayItemView(this._gp_pray_item, null, null, 2, model.pray_info_list)
			this.exp_pray.Load()
			//_exp_mask = local_laya. new Rectangle(0, 0, this._img_mask.width, this._img_mask.height)
			//this._img_mask.mask = _exp_mask
			this.RefreshExp()
		}

		this.RefreshExp = () => {
			let roleInfo = role_mgr.mainRoleInfo
			// [ts2lua]lua中0和空字符串也是true，此处roleInfo.level > 370需要确认
			let level = (roleInfo.level > 370 && (roleInfo.level - 370) || (roleInfo.level))
			// [ts2lua]lua中0和空字符串也是true，此处roleInfo.level > 370需要确认
			this.destiny_gp.visible = roleInfo.level > 370 && true || false
			// [ts2lua]lua中0和空字符串也是true，此处roleInfo.level > 370需要确认
			let width = (roleInfo.level > 370 && (83) || (0))
			SetSizeDeltaX(this.destiny_gp, width)
			this._bit_lv.text = level
			let list=String(level).match(/1/g)
			let special_num=list!=null?list.length:0;
			let lv_width=special_num*24+(String(level).length-special_num)*28
			let box_width=83+lv_width
			this.level_box.x=100-box_width/2
			// LayoutRebuilder(this._bit_lv)
			// LayoutRebuilder(this._Group1)
			if(!this.destiny_gp.visible){
				this._bit_lv.x=box_width/2-lv_width/2
			}

			_last_exp = roleInfo.exp
			let _reward_list = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pray_reward", false)
			let turn = 0
			this._lb_dec_1.style.fontSize=24
			this._lb_dec_1.style.color="#663915"
			if (roleInfo.exp > roleInfo.exp_lim) {
				let rein_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_reincarnation_cfg", false)
				let career = role_mgr.mainRoleInfo.career
				let sex = role_mgr.mainRoleInfo.sex
				turn = 0
				do {
					// [ts2lua]rein_cfg下标访问可能不正确
					if (rein_cfg[career + "@" + sex + "@" + turn]) {
						turn = turn + 1
					} else {
						turn = turn - 1
						break
					}
				} while (true)
				if (roleInfo.turn < turn) {
					this._lb_dec_1.innerHTML = "完成转职任务后可继续提升等级"
				} else {
					if (this._lb_dec_1.innerHTML != "") {
						this._lb_dec_1.visible = false
						// this._lb_dec_1.innerHTML = null
					}
				}
			} else {
				for (let _index in _reward_list) {

					if ((roleInfo.level >= _reward_list[_index].min_rlv && roleInfo.level <= _reward_list[_index].max_rlv) && 2 == _reward_list[_index].type) {
						let _reward =JSON.parse(_reward_list[_index]["reward"])
						let count = Math.ceil((roleInfo.exp_lim - roleInfo.exp) / Number(_reward[0][2]))
						this._lb_dec_1.innerHTML = Util.StrToHTML("再祈愿成长" + "<font style='fontSize:28' color='#0a953e'>" + count + "</font>" + "次将升级")
						//[{text:"再祈愿成长", style:{textColor:"#4a3a32"}], {text=count, style=[textColor="#639c12", size=30]], [text="次将升级", style=[textColor="#4a3a32"]]]
						break
					}
				}
			}
			this._lb_dec_1.width=350
			this._lb_dec_1.x=175-this._lb_dec_1.contextWidth/2
			// LayoutRebuilder(this._lb_dec_1)
			// LayoutRebuilder(this._Group3)
			// LayoutRebuilder(this._gp_dec)
			let exp_length=roleInfo.exp / roleInfo.exp_lim
			if(exp_length>1){
				exp_length=1
			}
			this._lb_exp.text = "经验：" + roleInfo.exp + "/" + roleInfo.exp_lim + "(" + Math.floor(exp_length * 100) + "%)"
			if (_last_lv == 0) {
				this._img_mask.width = exp_length*516
			} else {
				this.ExpAnim(roleInfo)
			}
			_last_lv = roleInfo.level
		}

		this.ExpAnim = (roleInfo?) => {
			let last_width = this._img_mask.width
			let posX_start = this._gp_effect.x
			//local_laya.Tween.removeTweens(this._img_mask.mask)
			//local_laya.Tween.removeTweens(this._gp_effect)
			if (roleInfo.exp > roleInfo.exp_lim) {
				return
			}
			if (_last_lv == roleInfo.level) {
				let width = roleInfo.exp / roleInfo.exp_lim*516
				if(width>516){
					width=516
				}
				let func = () => {
					if (this.use_delete_method) { return }
					this.ClearExpTween()
				}
				if(last_width>width){
					last_width=0
				}
				let time = last_width == 516 && width/516 || (width - last_width)/516
				this.mask_tween_id = SYTweenLite.to(this, this._img_mask, SYTweenLite.UiAnimationType.WIDTH, width, time, func,SYTweenFunc.EASE_IN_OUT)
				// SYTweenLite.to(this,this._img_exp,SYTweenLite.UiAnimationType.WIDTH,endValue,time_interval_,onComleted,SYTweenFunc.EASE_IN_OUT)
				let func1 = () => {
					if (this.use_delete_method) { return }
					this.ClearEffectTween()
				}
				// this.effect_tween_id = SYTweenLite.to(this, this._gp_effect, SYTweenLite.UiAnimationType.POSX, posX_start + width * GetSizeDeltaX(this._img_mask), time, func1)
			} else {
				let func = () => {
					if (this.use_delete_method) { return }
					this.ClearExpTween()
					if (!this._img_mask) {
						return
					}
					this._img_mask.width = 0
					let width = roleInfo.exp / roleInfo.exp_lim*516
					if(width>516){
						width=516
					}
					let func1 = () => {
						this.ClearExpTween()
					}
					this.mask_tween_id = SYTweenLite.to(this, this._img_mask, SYTweenLite.UiAnimationType.WIDTH, width, width/516, func1)
				}
				let time = 1 - last_width/516
				this.mask_tween_id = SYTweenLite.to(this, this._img_mask, SYTweenLite.UiAnimationType.WIDTH, 516, time, func)

				// let func2 = () => {
				// 	if (this.use_delete_method) { return }
				// 	this.ClearEffectTween()
				// 	if (!this._gp_effect) {
				// 		return
				// 	}
				// 	SetAnchoredPosition(this._gp_effect, this._img_mask.anchoredPosition.x, this._gp_effect.anchoredPosition.y)
				// 	let width = roleInfo.exp / roleInfo.exp_lim
				// 	let func3 = () => {
				// 		this.ClearEffectTween()
				// 	}
				// 	this.effect_tween_id = SYTweenLite.to(this, this._gp_effect, SYTweenLite.UiAnimationType.POSX, posX_start + width * GetSizeDeltaX(this._img_mask), width, func3)
				// }
				// this.effect_tween_id = SYTweenLite.to(this, this._gp_effect, SYTweenLite.UiAnimationType.POSX, posX_start + GetSizeDeltaX(this._img_mask), time, func2)
			}
			if (_is_getExp > 0) {
				//this:AddUIEffect2("ui_progressbar_glow", this._gp_effect)
				_is_getExp = _is_getExp - 1
			}
		}


	}

	public ClearExpTween() {

		if (this.mask_tween_id) {
			SYTweenLite.Stop(this.mask_tween_id)
			this.mask_tween_id = null
		}
	}

	public ClearEffectTween() {

		if (this.effect_tween_id) {
			SYTweenLite.Stop(this.effect_tween_id)
			this.effect_tween_id = null
		}
	}

	public DeleteMe() {

		this.ClearEffectTween()
		this.ClearExpTween()
		if (this._exp_up_id) {
			RoleManager.GetInstance().GetMainRoleVo().UnBind(this._exp_up_id)
			this._exp_up_id = null
		}
		if (this.gold_pray) {
			this.gold_pray.DeleteMe()
			this.gold_pray = null
		}
		if (this.exp_pray) {
			this.exp_pray.DeleteMe()
			this.exp_pray = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_bg,
			this._gp_pray_item,
			this._Image1,
			this._Group1,
			this.destiny_gp,
			this._Image2,
			this._Image3,
			this._bit_lv,
			this._Group2,
			this._img_mask_bg,
			this._img_mask,
			this._gp_effect,
			this._lb_exp,
			this._gp_dec,
			this._lb_dec_1,
			this._Group3,
			this._Label1,
			this._Label2,
			this.level_box,
			this.money_baoji,
			this.exp_baoji
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_pray_item",
				"_Image1",
				"_Group1",
				"destiny_gp",
				"_Image2",
				"_Image3",
				"_bit_lv",
				"_Group2",
				"_img_mask_bg",
				"_img_mask",
				"_gp_effect",
				"_lb_exp",
				"_gp_dec",
				"_lb_dec_1",
				"_Group3",
				"_Label1",
				"_Label2",
				"level_box",
				"money_baoji",
				"exp_baoji"
			])

			ResManager.GetInstance().LoadFont(this, "pray", this._bit_lv, 20,true,()=>{
				console.log(this._bit_lv)
			})

	}
}
window["PrayMainView"] = PrayMainView