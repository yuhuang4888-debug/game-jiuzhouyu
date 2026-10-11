import { BaseItem1 } from "../../common/BaseItem1"
import { Config } from "../../common/Config"
import { SceneEventType } from "../../common/EventName"
import { Enum_UILayer } from "../../common/LayerManager"
import { ResManager } from "../../common/ResManager"
import { table } from "../../common/table"
import { DsgtModel } from "../../commonModel/DsgtModel"
import { MedalModel } from "../../commonModel/MedalModel"
import { RoleManager } from "../../commonModel/RoleManager"
import { BigBloodBar } from "../../uiComponent/BigBloodBar"
import { ProgressBar2 } from "../../uiComponent/ProgressBar2"
import { GlobalEventSystem } from "../../util/DeclareGlobalVar"
import { GameResPath } from "../../util/GameResPath"
import { SYTweenLite } from "../../util/SYTweenLite"
import { GetSizeDeltaX, GlobalTimerQuest, RefBoxChildsLayout, SetAnchoredPositionY, SetLocalPositionX, SetLocalPositionY, SetLocalScale, SetSizeDeltaX, Trim, Util } from "../../util/Util"
import { Vector2 } from "../../util/Vector2"
import { Vector3 } from "../../util/Vector3"
import { CameraManager } from "../CameraManager"
import { SceneManager } from "../SceneManager"
import { NameBoardManager } from "./NameBoardManager"
import { SetLocalPosition } from './../../util/Util';

let local_Laya = Laya
let local_ResManager
export class NameBoard extends BaseItem1 {


	static layout_sort = {
		//[1：组件类型,2：从属(废弃),3：子节点顺序,4：宽,5：高,6：ReleaseData方法中是否销毁]

		//1 boss归属
		"_img_boss_flag": ["Image", 0, 0],

		//2 秘境远征
		"_lb_hook": ["Text", 0, 1],

		//3 海域(子节点不排序)
		"_gp_brick": ["Box", 0, 2, 200, 100],
		"_img_brick": ["Image", 2],
		"_img_brick_text": ["Image", 2],

		//4 称号 buff标志
		"_gp_title": ["Box", 0, 3, 300, 100],

		//5 婚礼称号(子节点不排序)
		"_box_dsgt": ["Box", 0, 4, 200, 50],
		"_img_dsgt": ["Image", 4, 0, 200, 100],
		"_lb_dsgt": ["Text", 4, 1],
		"_gp_dsgt_effect": ["Box", 4, 2, 237, 120],

		//6 服务器信息
		"_lb_server": ["Text", 0, 5],

		//7结社信息
		"_lb_guild": ["Text", 0, 6],

		//8采集
		"_lb_collect": ["Text", 0, 7],


		//9名字一栏(需要排序)
		"_gp_con": ["Box", 0, 8, null, 20, 1],
		// 9阵营的logo
		"_gp_zhenying": ["Box", 8, 2, 46, 20],
		"group_icon": ["Image", 2, 0, 46, 46],

		"_gp_touxian": ["Box", 8, 3, null, 30],  //天境
		"_img_medal": ["Image", 8, 5, 62, 30],//地境
		"_lb_name": ["Text", 8, 6, null, null, 1],
		"_img_vip": ["Image", 8, 7, 24, 24],


		//10 npc名字特别处理
		"_npc_name": ["Text", 0, 9, null, 18],


		//11 血条
		"_gp_hp_bar": ["Box", 0, 10, 0.1, 0.1]

	}
	/**
	 * 血条
	 */
	hp_bar: ProgressBar2
	/**
	 *  
	 */
	title_icon: Laya.Image
	/**
	 * parent下visible
	 */
	parent_children_visible_dic
	/**
	 * con下visible
	 */
	con_children_visible_dic
	/**
	*  当前显示称号方式 1 文字 2 图片 3 特效 4 文字加图片
	*/
	show_dsge_type: number = 0
	/**
	 * 额外的高度偏移量 可能是玩家被击悬空之类的
	 */
	off_height: number = 0
	/**
	 * 血条高度 有的时候是30  没的时候是0
	 */
	hp_height: number = 0
	/**
	 * 所依附的场景对象资源高度
	 */
	attach_res_height: number = 200
	/**
	 * 所依附的场景对象的坐标
	 */
	attach_pos
	/**
	 * 依附的场景对象
	 */
	attach_target
	/**
	 * 头衔
	 */
	touxian
	/**
	 * 姓名
	 */
	name
	/**
	 * 显示血条
	 */
	is_show_hp = false
	/**
	 * 结社名称
	 */
	guild_name
	/**
	 * 称号id
	 */
	dsgt_id
	/**
	 * buff叠加数
	 */
	deijia
	/**
	* 海域id
	*/
	last_brick_id
	/**
	* update_parent_layout_time_id
	*/
	update_parent_layout_time_id
	/**
	* update_con_layout_time_id
	*/
	update_con_layout_time_id
	/**
	 * 测试信息
	 */
	test_info = ""
	/***是否展示头顶特效 */
	is_show_eff
	/**Npc名字 */
	npc_name

	arrow_move_time
	arrow_max_height
	bool_arrow_play
	
	tween_id2
	tween_id3
	arrow_timer_id
	arrow_delay_time

	//动态创建
	CreatChilds
	list_comp
	IsDestoryChilds
	RemoveChilds
	bool_is_destory


	//组件
	_img_boss_flag: Laya.Image
	_lb_hook: Laya.Text
	_gp_brick: Laya.Box
	_img_brick: Laya.Image
	_img_brick_text: Laya.Image
	_gp_title: Laya.Box
	_box_dsgt: Laya.Box
	_img_dsgt: Laya.Image
	_lb_dsgt: Laya.Text
	_gp_dsgt_effect: Laya.Box
	_lb_server: Laya.Text
	_lb_guild: Laya.Text
	_lb_collect: Laya.Text
	_gp_con: Laya.Box
	_gp_touxian: Laya.Box
	_gp_zhenying: Laya.Box
	group_icon: Laya.Image
	_img_medal: Laya.Image
	_lb_name: Laya.Text
	_img_vip: Laya.Image
	_gp_hp_bar: Laya.Box
	_npc_name: Laya.Text

	public constructor(parent) {
		super(parent)
		local_ResManager = ResManager
		this.base_file = "uiComponent"
		this.layout_file = "NameBoard"
		this.is_load_res = false
		this.is_delay_callback = false

		this.attach_pos = new Vector2(0, 0)
		this.name = " "
		this.attach_target = false
		this.touxian = 0 //头衔
		this.bool_is_destory = false
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.list_comp = {}


		//filtle  对象池释放，保留部分组件true  false全部删除
		this.RemoveChilds = (filtle?) => {
			this.bool_is_destory = true
			if (this.hp_bar) {
				this.hp_bar.Recover()
				this.hp_bar = null
			}
			this.attach_target = false
			//移除创建的组件  最后移除
			for (let key in this.list_comp) {

				if (filtle && !this.IsDestoryChilds(key)) {
					//if(this.list_comp[key]&&this.layout_sort[key][1]!=0)this.list_comp[key].visible=false
					continue;
				}
				if (this.list_comp[key]) {
					this.list_comp[key].removeSelf()
					this.list_comp[key].destroy()
					this[key] = null
					delete this.list_comp[key]
				}

			}
			if (!filtle) this.list_comp = {}

			this.bool_is_destory = false
		}

		this.IsDestoryChilds = (name?) => {
			let arr = local_NameBoard.layout_sort[name]
			if (arr == null || arr.length == 0) {
				return
			}

			if (arr[5] != null && arr[5] == 1) {
				//console.warn("测试"+name)
				return false
			}

			return true
		}

		this.CreatChilds = (parent?, name?) => {

			if (this.bool_is_destory) {
				//console.warn("测试_在删除中" + name)
				return
			}
			let arr = local_NameBoard.layout_sort[name]
			if (arr == null || arr.lengt == 0) {
				return
			}

			let child = null
			switch (arr[0]) {
				case "Image":
					child = window["GetImageFromPool"]() || new local_Laya.Image()
					//child.skin = "resource/game/common/texture/com_empty.png"
					break
				case "Text":
					child = new local_Laya.Text()
					break
				case "Box":
					child = new local_Laya.Box()
					break
			}
			child.pos(0, 0)
			child.name = name
			if (arr[3] != null) child.width = arr[3]
			if (arr[4] != null) child.height = arr[4]
			parent.addChild(child)
			child.visible = false//默认不显示

			this.list_comp[name] = child
			//table.insert(this.list_comp, child)
			return child
		}
	}

	public LoadSuccess() {
		if (this._lb_name) this._lb_name.text = ""
		this.UpdateParentLayout()
		this.UpdateConLayout()
		this.InitEvent()
	}


	public SetGameObjectName(name?) {
		this.display_obj.name = "NameBoard_" + name
	}

	public DeleteMe() {

		this.RemoveChilds(false)
		super.DeleteMe()
	}
	public SetGreenBar() {
		if (this.hp_bar) {
			this.hp_bar.SetFrontImageStyle("ui_5")
		}
	}

	public SetRedBar() {
		if (this.hp_bar) {
			this.hp_bar.SetFrontImageStyle("ui_7")
		}
	}

	public SetBlueBar() {
		if (this.hp_bar) {
			this.hp_bar.SetFrontImageStyle("ui_6")
		}
	}

	public SetPurpleBar() {
		if (this.hp_bar) {
			this.hp_bar.SetFrontImageStyle("ui_13")
		}
	}

	public InitEvent() {
	}

	public SetAttachResHeight(value?) {
		if (value < 180) {
			value = 180
		}
		this.attach_res_height = value
		this.UpdatePos(null, null)
	}

	public SetOffHeight(value?) {
		this.off_height = value
		this.UpdatePos(null, null)
	}

	public UpdatePos(x?, y?) {
		this.attach_pos.x = x || this.attach_pos.x
		this.attach_pos.y = y || this.attach_pos.y
		if ((this.is_show_hp || this.name != "" || this.is_show_eff||this.npc_name!="")) {
			let height = this.attach_res_height + this.off_height - this.hp_height
			this.SetPosition(this.attach_pos.x, this.attach_pos.y - height)
		}
	}

	public UpdateDefaultPos() {
		this.SetPosition(-10, 500)
	}

	public SetParent(parent?) {
		if (parent) {
			parent.addChild(this.display_obj)
		}
	}

	public SetName(name, color = "#fffad2", font_size?) {
		if (this.name == name) { return }
		this.name = name
		if (name == "") {
			if (this._gp_con) this._gp_con.visible = false
		} else {
			this.UpdateName(color, font_size)
			if (this._gp_con) this._gp_con.visible = true
		}
		
		this.TryUpdateConLayout()
		this.TryUpdateParentLayout()
	}


	public SetNpcName(npc_name?,color?,stroke?) {
		this.npc_name = npc_name

		//npc 名字特殊处理
		if (!npc_name) {
			if (this._npc_name) this._npc_name.visible = false
		} else {
			if (!this._npc_name) {
				this.CreatNPCNameText()
			}
			this._npc_name.visible = true
			this._npc_name.changeText(npc_name)
		}
		this._npc_name.color = color?color:"#c2fdfa"
		this._npc_name.stroke = stroke?stroke:1
		this.TryUpdateParentLayout()
	}

	

	public SetTestInfo(content) {

		if (this.test_info == content) return
		this.test_info = content
		this.UpdateName()

		if (this._gp_con && !this._gp_con.visible) {
			this._gp_con.visible = true
		}

		this.TryUpdateConLayout()
		this.TryUpdateParentLayout()
	}

	public UpdateName(color?, font_size?) {
		this.CreatNameText()
		this._lb_name.width = 0
		this._lb_name.changeText(`${this.name}${this.test_info}`)
		this._lb_name.width = this._lb_name.width
		this._lb_name.visible = true
		if (color) this._lb_name.color = color
		this._lb_name.fontSize = font_size ? font_size : 40
	}

	public ShowHookText() {

		if (!this._lb_hook) {
			this._lb_hook = this.CreatChilds(this._gp_parent, "_lb_hook")
			this._lb_hook.color = "#ffffff"
			this._lb_hook.fontSize = 40
			this._lb_hook.scale(0.5, 0.5)
		}

		this._lb_hook.changeText("[秘境远征中]")
		this._lb_hook.visible = true
		this._lb_hook.height = 100
		this.TryUpdateParentLayout()
	}

	//VIP
	public SetVipLevel(lv?,is_hide_vip?) {
		this.CreatVipIcon()
		if (lv && lv > 0) {
			this._img_vip.visible = true
			// if(is_hide_vip > 0){
				// local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "VIP-x", true)
			// }
			// else{
				local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "uivip_zjm_" + lv, true)
			// }
			
			// this._img_vip.scaleX = this._img_vip.scaleY = 1
		} else {
			this._img_vip.visible = false
		}
		this.TryUpdateConLayout()
	}

	//至尊VIP
	public SetSuperVipLevel(supreme_vip?, lv?, is_hide_vip?) {
		if (supreme_vip && supreme_vip > 0) {
			this._img_vip.visible = true
			// if(is_hide_vip > 0){
				// local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "SVIP-x", true)
			// }
			// else{
				local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "VIP_" + lv, true)
			// }
			// this._img_vip.scaleX = this._img_vip.scaleY = 0.7

		} else {
			// this._img_vip.visible = false
		}
		this.TryUpdateConLayout()
	}

	//是否显示vip图标和等级
	public SetVipShowOrHide(super_vip?,state?,lv?){
		//这里写显示或者隐藏的逻辑
		if(state && state > 0){
			if(super_vip && super_vip > 0){
				local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "SVIP-x", true)
			}
			else{
				local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "VIP-x", true)
			}
		}
		else{
			if(super_vip && super_vip > 0){
				local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "VIP_" + lv, true)
			}
			else{
				local_ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "uivip_zjm_" + lv, true)
			}
		}
		this.TryUpdateConLayout()
	}

	//天境头衔
	public SetTouxian(id?, is_create?) {

		if (this.touxian && id && this.touxian == id && !is_create) { return }
		if (this._gp_touxian) this.ClearUIEffect(this._gp_touxian)
		this.touxian = id
		if (id && id > 0) {
			this.CreatTouXianBox()
			let title_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientTitleNameBordWidth[id]


			let w = 80
			let pos
			let scale = 8
			let h = 40
			if (title_cfg) {
				w = title_cfg.width
				scale = title_cfg.scale
				h = title_cfg.height
				if ((id - 1000) <= 5) {
					pos = { x: -2, y: 0 }
				} else {
					pos = { x: 0, y: 0 }
				}
			}

			this._gp_touxian.width = w
			this._gp_touxian.height = h
			let res = MedalModel.GetInstance().GetTitleEffetName(id - 1000)
			this.AddUIEffect(res, this._gp_touxian, pos, scale, true)
			this._gp_touxian.visible = true
		} else {
			if (this._gp_touxian) this._gp_touxian.visible = false
		}

		this.TryUpdateConLayout()
	}

	public SetCollectText(text?) {

		this.CreatCollectText()

		if (text && text != "") {
			this._lb_collect.visible = true
			this._lb_collect.changeText(text)
		} else {
			this._lb_collect.visible = false
		}

		this.TryUpdateParentLayout()
	}

	public SetGuildText(guild_info?) {
		guild_info = Trim(guild_info)
		// if (this.guild_name == guild_info ) { return }
		this.guild_name = guild_info

		this.CreatGuildText()
		if (guild_info == "") {
			this._lb_guild.visible = false
		} else {
			this._lb_guild.visible = true
			this._lb_guild.text = guild_info
		}

		this.TryUpdateParentLayout()
	}

	public SetGroupIcon(abName?, resName?) {
		this.CreatGroupIcon()
		this.group_icon.visible = true
		if (abName) {
			this.group_icon.y =-20
			local_ResManager.GetInstance().SetImageSprite(this, this.group_icon, abName, resName, true)
		}

		if (this._gp_zhenying.visible != true) {
			this._gp_zhenying.visible = true
			this.TryUpdateConLayout()
		}
	}

	public ClearGroupIcon() {
		if (this.group_icon) {
			this.group_icon.texture = null
			this.group_icon.visible = false
			this.group_icon.x = 0
			this.group_icon.y = 0
		}

		if (this._gp_zhenying && this._gp_zhenying.visible != false) {
			this._gp_zhenying.visible = false
			this.TryUpdateConLayout()
		}
	}

	public ClearVipIcon() {
		if (this._img_vip && this._img_vip.visible != false) {
			this._img_vip.visible = false
			this.TryUpdateConLayout()
		}
	}


	public SetTitleEff(eff_name?, pos?, scale?) {
		this.CreatGpTitle()
		let local_pos = pos != null ? pos : { x: 0, y: 0 }
		let local_scale = scale != null ? scale : 10
		this.AddUIEffect(eff_name, this._gp_title, local_pos, local_scale, true)
		this._gp_title.visible = true
		this.is_show_eff = true
		this.TryUpdateParentLayout()
	}


	//图片上下移动
	public ArrowAnimation(time?, move_time?, max_height?) {

		this.arrow_move_time = move_time || 0.5
		this.arrow_delay_time = time || 0.5
		this.arrow_max_height = max_height || 30
		if (!this.bool_arrow_play) {
			this.bool_arrow_play = true
			this.PlayArrowAnimation()
		}
	}

	public PlayArrowAnimation() {

		this.StopAnim(true)
		let call_fun = () => {
			var onCompleted = () => {
				this.PlayArrowAnimation()
			}
			this.tween_id3 = SYTweenLite.to(this, this.title_icon.transform, SYTweenLite.UiAnimationType.POSY, 0, this.arrow_move_time, onCompleted)
		}
		let onDelay = () => {
			this.tween_id2 = SYTweenLite.to(this, this.title_icon.transform, SYTweenLite.UiAnimationType.POSY, this.arrow_max_height, this.arrow_move_time, call_fun)
		}
		if (this.arrow_delay_time <= 0) {
			onDelay()
		} else {
			this.arrow_timer_id = setTimeout(onDelay, this.arrow_delay_time)
		}
	}

	public StopAnim(bool_continue?) {

		if (!bool_continue) {
			this.bool_arrow_play = false
		}
		if (this.tween_id2) {
			SYTweenLite.Stop(this.tween_id2)
			this.tween_id2 = null
		}
		if (this.tween_id3) {
			SYTweenLite.Stop(this.tween_id3)
			this.tween_id3 = null
		}
		if (this.title_icon) {
			this.title_icon.y = 0
		}
		if (this.arrow_timer_id) {
			GlobalTimerQuest.CancelQuest(this.arrow_timer_id)
			this.arrow_timer_id = null
		}
	}



	public SetDsgtImg(id?, main_type?, marriage_name?) {

		this.dsgt_id = null
		if (this._gp_dsgt_effect) {
			this.ClearUIEffect(this._gp_dsgt_effect)
			this._gp_dsgt_effect.visible = false
		}

		this.CreatDsgtImg()
		this.CreatDsgtText()
		this._img_dsgt.visible = true
		if (main_type == 7) { //伴侣动态称号
			this.show_dsge_type = 4
			this._lb_dsgt.visible = true
			this._img_dsgt.sizeGrid = "0,61,0,68"
		} else {
			this.show_dsge_type = 2
			this._lb_dsgt.visible = false
			this._img_dsgt.sizeGrid = null
		}
		local_ResManager.GetInstance().SetOutsideImageSprite(this, this._img_dsgt, GameResPath.GetDesignImage(id), true, () => {
			if (this.use_delete_method || this._box_dsgt == null) {
				return
			}
			this._box_dsgt.visible = true
			this._box_dsgt.height = this._img_dsgt.height
			if (main_type == 7) { //伴侣动态称号
				let title = marriage_name + "的伴侣"
				this._lb_dsgt.color = "#ffffff"
				this._lb_dsgt.text = Util.StrToHTML(title)
				this._img_dsgt.width = this._lb_dsgt.textWidth * this._lb_dsgt.scaleX + 100;
				this._lb_dsgt.x = (this._box_dsgt.width - this._lb_dsgt.textWidth * this._lb_dsgt.scaleX) / 2
				this._lb_dsgt.y = (this._box_dsgt.height - this._lb_dsgt.textHeight * this._lb_dsgt.scaleY) / 2 + 3
			}
			this._img_dsgt.x = (this._box_dsgt.width - this._img_dsgt.width) / 2
			this._img_dsgt.y = (this._box_dsgt.height - this._img_dsgt.height) / 2
			this.TryUpdateParentLayout()
		})
		// this.TryUpdateParentLayout()
	}

	public SetDsgtEffect(id?) {

		if (this.dsgt_id && this.dsgt_id == id) { return }

		this.dsgt_id = id


		local_ResManager.GetInstance().LoadGameConfig(this,"ClientEffDsgtShow",true,null,(ClientEffDsgtShow)=>{
			let cfg = DsgtModel.GetInstance().getDsgtCfgByID(id)
			if (cfg && ClientEffDsgtShow) {
				this.CreatDsgtEffBox()
				
				let show_cfg = ClientEffDsgtShow["NameBoard"][cfg.id]
				if(!show_cfg){
					show_cfg = ClientEffDsgtShow["NameBoard"]["def"]
				}
					
				
				let box_height = show_cfg&&show_cfg.height ||80
				let scale = show_cfg&&show_cfg.scale||7

				let h_ = 120

				let eff_box_h = 150
				scale*=(h_/eff_box_h)

				this._gp_dsgt_effect.width = 237
				this._gp_dsgt_effect.height = eff_box_h
				this._box_dsgt.height = box_height
				if((eff_box_h-box_height)>0){
					this._gp_dsgt_effect.y = -((eff_box_h-box_height)/2)
				}else{
					this._gp_dsgt_effect.y = 0
				}
				
				// this._gp_dsgt_effect.y = -20
				this._gp_dsgt_effect.x = -10

				this.AddUIEffect(Trim(cfg.resource_id), this._gp_dsgt_effect, null, scale, true, null, null, null, null, null, null, null, false)
			}
			this.show_dsge_type = 3

			if (this._lb_dsgt) this._lb_dsgt.visible = false
			if (this._img_dsgt) this._img_dsgt.visible = false
			if (this._box_dsgt) this._box_dsgt.visible = false
			if (this._gp_dsgt_effect) this._gp_dsgt_effect.visible = true
			this.TryUpdateConLayout()
			
		})
	


		// this.TryUpdateParentLayout()
	}



	public ShowDsgt(bool) {

		let func = (lb_boo, img_boo, eff_boo) => {
			if (this._lb_dsgt) this._lb_dsgt.visible = lb_boo
			if (this._img_dsgt) this._img_dsgt.visible = img_boo
			if (this._gp_dsgt_effect) this._gp_dsgt_effect.visible = eff_boo
			if (this._box_dsgt) this._box_dsgt.visible = lb_boo || img_boo || eff_boo
		}

		if (!bool) {
			func(false, false, false)
			// if(this._lb_dsgt)this._lb_dsgt.visible = false
			// if(this._img_dsgt)this._img_dsgt.visible = false
			//this._gp_dsgt_effect.visible = false
		}
		else {
			if (this.show_dsge_type == 1) {
				func(true, false, false)
				// this._lb_dsgt.visible = true
				// this._img_dsgt.visible = false
				//this._gp_dsgt_effect.visible = false
			}
			else if (this.show_dsge_type == 2) {
				func(false, true, false)
				// this._lb_dsgt.visible = false
				// this._img_dsgt.visible = true
				//this._gp_dsgt_effect.visible = false
			}
			else if (this.show_dsge_type == 3) {
				func(false, false, true)
				// this._lb_dsgt.visible = false
				// this._img_dsgt.visible = false
				//this._gp_dsgt_effect.visible = true
			}
			else if (this.show_dsge_type == 4) {
				func(true, true, false)
				// this._lb_dsgt.visible = true
				// this._img_dsgt.visible = true
				//this._gp_dsgt_effect.visible = false
			}
			else {
				func(false, false, false)
				// this._lb_dsgt.visible = false
				// this._img_dsgt.visible = false
				//this._gp_dsgt_effect.visible = false
			}
		}
		this.TryUpdateParentLayout()
	}

	public ClearDsgt() {

		this.dsgt_id = null

		if (this._lb_dsgt) this._lb_dsgt.visible = false
		if (this._img_dsgt) this._img_dsgt.visible = false
		if (this._box_dsgt) this._box_dsgt.visible = false

		if (this._gp_dsgt_effect) {
			this._gp_dsgt_effect.visible = false
			this.ClearUIEffect(this._gp_dsgt_effect)
		}

		this.TryUpdateParentLayout()
	}

	public ClearHookIcon() {
		if (this._lb_hook) {
			this._lb_hook.visible = false
		}

		this.TryUpdateParentLayout()
	}

	public ClearTitleIcon() {

		if (this.title_icon) {
			this.title_icon.visible = false
			this.ClearUIEffect(this.title_icon)
		}

		if (this._gp_title) this._gp_title.visible = false
		this.TryUpdateParentLayout()
	}

	public ClearTitleEffect() {
		if (this._gp_title) this._gp_title.visible = false
		this.TryUpdateParentLayout()
	}

	public SetHp(hp?, maxHp?) {
		//this.CreatHpBar()
		if (this.hp_bar) {
			this.hp_bar.SetValue(hp, maxHp)
		}
	}

	//设置血条的显示与否
	public SetHpVisible(hpVisible?) {
		this.is_show_hp = hpVisible
		if (hpVisible) this.CreatHpBar()
		if (this._gp_hp_bar) {
			this._gp_hp_bar.visible = hpVisible
			this.hp_height = hpVisible == true && 0 || 20
			this.UpdatePos(null, null)
			this.TryUpdateParentLayout()
		}
	}

	public SetBrickVisible(visible?, brick_id?) {

		if (visible) {
			this.CreatBrickBox()
			if (brick_id && this.last_brick_id != brick_id) {
				this.last_brick_id = brick_id

				this._img_brick.visible = this._img_brick_text.visible = true
				local_ResManager.GetInstance().SetImageSprite(this, this._img_brick, "seaAssert", "uitc_img" + brick_id)
				local_ResManager.GetInstance().SetImageSprite(this, this._img_brick_text, "seaAssert", "uisdbz_00" + (8 - brick_id))
			}
			this._gp_brick.visible = visible;
			let posList: number[] = [60, 50, 30, 30]
			SetLocalPosition(this._img_brick, 50, posList[brick_id - 1]);
			SetLocalPosition(this._img_brick_text, 90, 60);
			// RefBoxChildsLayout(this._gp_brick, 2)
			this.TryUpdateParentLayout()
		} else {
			if (this._gp_brick) this._gp_brick.visible = visible
		}

	}

	public ShowMedal(medal_id?) {
		if (medal_id > 0) {
			this.CreatMedalIcon()
			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_medal
			let medal_Cfg = cfgs && cfgs[medal_id] //MedalModel.GetInstance().medalConfig(cfgs)
			if (medal_Cfg && medal_Cfg.title > 0) {
				SetLocalScale(this._img_medal, 0.8, 0.8, 0.8)
				this._img_medal.visible = true

				local_ResManager.GetInstance().SetImageSpriteTrans(this, this._img_medal, GameResPath.GetIcon("mainUI", "tx_" + medal_Cfg.title), true, () => {
					this.TryUpdateConLayout()
				})

			} else {
				this._img_medal.visible = false
			}
		} else {
			if (this._img_medal) this._img_medal.visible = false
		}
		this.TryUpdateConLayout()
	}

	public ShowBase() {
		if (this._lb_guild) this._lb_guild.visible = false
		if (this._gp_dsgt_effect) this._gp_dsgt_effect.visible = false
		if (this._gp_title) this._gp_title.visible = false
		if (this._lb_hook) this._lb_hook.visible = false
		this.UpdateParentLayout()
	}

	//设置血条的显示与否
	public IsShowHp() {
		return this.is_show_hp
	}

	public ReleaseData() {

		if(this.update_parent_layout_time_id){
			clearTimeout(this.update_parent_layout_time_id)
			this.update_parent_layout_time_id=0
		}

		this.SetAttachResHeight(180)
		this.SetOffHeight(0)
		this.ClearTitleIcon()
		this.ClearTitleEffect()
		this.ClearDsgt()
		this.ClearGroupIcon()
		this.ClearVipIcon()
		this.ClearHookIcon()
		this.SetBossFlag(false)
		this.SetVisible(false)
		this.SetBrickVisible(false)
		this.ShowMedal(0)
		this.StopAnim()
		this.touxian = 0
		if (this._lb_guild) this._lb_guild.text = ""


		this.RemoveChilds(true)

	}

	public ResetData() {
		this.SetVisible(true)
	}

	//设置Boss归属标志
	public SetBossFlag(bool?, res?) {
		if (bool) {
			this.CreatBossFlag()
			local_ResManager.GetInstance().SetImageSprite(this, this._img_boss_flag, "mainUI", res, true)
			this._img_boss_flag.visible = true
		} else {
			if (this._img_boss_flag) this._img_boss_flag.visible = false
		}

		Laya.timer.frameOnce(20, this, this.UpdateParentLayout)
	}


	//buff层数
	public SetBuffTime(time?) {
		if (this.deijia != time && time > 0) {

			this.CreatGpTitle()
			this.deijia = time
			if (!this._gp_title.visible) {
				this._gp_title.visible = true
			}
			let res = "JDFB_diejia_00" + time
			if (time >= 10) {
				res = "JDFB_diejia_0" + time
			}
			this.AddUIEffect(res, this._gp_title, { x: 0, y: 0 }, 5, true)
			this.TryUpdateParentLayout()
		}
	}

	public ClearBuffTime() {

		if (this._gp_title && this._gp_title.visible) {
			this.deijia = 0
			this._gp_title.visible = false
			this.ClearUIEffect(this._gp_title)
			this.is_show_eff = false
			this.TryUpdateParentLayout()
		}
	}

	public ClearMaskFunc() {

	}

	public InitParentVisible() {
		if (this.parent_children_visible_dic == null) {
			this.parent_children_visible_dic = {}
		}

		for (let i = 0, n = this._gp_parent.numChildren; i < n; i++) {
			let item = (<Laya.UIComponent>this._gp_parent.getChildAt(i))
			if (item)
				this.parent_children_visible_dic[item.name] = item.visible
		}
	}

	public TryUpdateParentLayout() {
		if (this.update_parent_layout_time_id) return
		this.update_parent_layout_time_id = setTimeout(() => {
			if (this.use_delete_method) return
			this.update_parent_layout_time_id = 0
			// for (let i = 0, n = this._gp_parent.numChildren; i < n; i++) {
			// 	let item = (<Laya.UIComponent>this._gp_parent.getChildAt(i))
			// 	if(this.parent_children_visible_dic[item.name] != item.visible){
			// 		this.UpdateParentLayout()
			// 		break
			// 	}
			// }
			this.UpdateParentLayout()
		}, 50);
	}

	public UpdateParentLayout() {
		if (this.use_delete_method) return
		let maxWidth = this._gp_parent.width

		let list_temp = this.GetCompsSortLayer(this._gp_parent)
		if (!list_temp || list_temp.length == 0) return

		let top = 0
		for (let i = 0, n = list_temp.length; i < n; i++) {
			let item = list_temp[i]//(<Laya.UIComponent>this._gp_parent.getChildAt(i))
			// this.parent_children_visible_dic[item.name] = item.visible
			if (item && item.visible) {
				if (this.show_dsge_type == 4 && item.name == "_img_dsgt") {

				} else {


					let scene = SceneManager.GetInstance()
					if (item.name == "_gp_title" && (scene.IsPolarDungeon() || scene.IsKFPolarDungeon())) {
						item.y = top + 25
					} else if (item.name == "_npc_name") {
						item.y = top - 5
					} else {
						item.y = top
					}


					if (item.name == "_npc_name") {
						//为了缩小_npc_name与_lb_name组件之间的间距 特殊处理一下
						top += item.height * item.scaleY + 10
					}else if (item.name == "_gp_con") {
						//血条和其他组件的间隔需要大一点
						top += item.height * item.scaleY + 14
					}else {
						top += item.height * item.scaleY + 8
					}


					item.x = (maxWidth - item.width * item.scaleX) * 0.5
				}
			}
		}
		this._gp_parent["onCompResize"]()
	}

	public InitConVisible() {
		if (this.con_children_visible_dic == null) {
			this.con_children_visible_dic = {}
		}

		for (let i = 0, n = this._gp_con.numChildren; i < n; i++) {
			let item = (<Laya.UIComponent>this._gp_con.getChildAt(i))
			if (item)
				this.con_children_visible_dic[item.name] = item.visible
		}
	}

	public TryUpdateConLayout() {
		if (this.update_con_layout_time_id) return
		this.update_con_layout_time_id = setTimeout(() => {
			if (this.use_delete_method) return
			this.update_con_layout_time_id = 0
			// for (let i = 0, n = this._gp_con.numChildren; i < n; i++) {
			// 	let item = (<Laya.UIComponent>this._gp_con.getChildAt(i))
			// 	if(this.con_children_visible_dic[item.name] != item.visible){
			// 		this.UpdateConLayout()
			// 		break
			// 	}
			// }
			this.UpdateConLayout()
		}, 50);
	}

	public UpdateConLayout() {
		if (!this._gp_con) return
		let maxHeight = this._gp_con.height

		let list_temp = this.GetCompsSortLayer(this._gp_con)
		if (!list_temp || list_temp.length == 0) return

		let left = 0
		for (let i = 0, n = list_temp.length; i < n; i++) {
			let item = list_temp[i]//(<Laya.UIComponent>this._gp_con.getChildAt(i))
			// this.con_children_visible_dic[item.name] = item.visible
			if (item && item.visible) {
				item.x = left;
				left += item.width * item.scaleX + 10;
				item.y = (maxHeight - item.height * item.scaleY) * 0.5;
			}
		}

		this._gp_con["onCompResize"]()
	}

	//动态创建元素排序
	public GetCompsSortLayer(box: Laya.Box) {

		if (Util.IsNull(box)) return null

		//子物体排序
		let temp_list = []
		for (let k = 0; k < box.numChildren; k++) {
			let item = (<Laya.UIComponent>box.getChildAt(k))
			if (item && item.visible) {
				table.insert(temp_list, item)
			}
		}


		let sort = (a?, b?) => {
			let a_valeu = 0
			let b_value = 0

			let a_layer_data = local_NameBoard.layout_sort[a["name"]]
			if (a_layer_data) {
				a_valeu = a_layer_data[2]
			}

			let b_layer_data = local_NameBoard.layout_sort[b["name"]]
			if (b_layer_data) {
				b_value = b_layer_data[2]
			}

			return a_valeu < b_value
		}
		table.sort(temp_list, sort)

		return temp_list
	}

	//创建一些组件

	//创建Server Text
	public CreatServerText() {
		if (!this._lb_server) {
			this._lb_server = this.CreatChilds(this._gp_parent, "_lb_server")
			this._lb_server.fontSize = 40
			this._lb_server.color = "#ffffff"
			this._lb_server.stroke = 2
			this._lb_server.strokeColor = "#5dc4ef"
			this._lb_server.valign = "center"
			this._lb_server.align = "center"
			this._lb_server.scale(0.5, 0.5)
		}
	}

	//创建_lb_guild
	public CreatGuildText() {
		if (!this._lb_guild) {
			this._lb_guild = this.CreatChilds(this._gp_parent, "_lb_guild")
			this._lb_guild.fontSize = 40
			this._lb_guild.color = "#ffe362"
			this._lb_guild.stroke = 2
			this._lb_guild.strokeColor = "#000000"
			this._lb_guild.valign = "center"
			this._lb_guild.align = "center"
			this._lb_guild.scale(0.5, 0.5)
		}
	}

	//创建_lb_collect
	public CreatCollectText() {
		if (!this._lb_collect) {
			this._lb_collect = this.CreatChilds(this._gp_parent, "_lb_collect")
			this._lb_collect.fontSize = 40
			this._lb_collect.color = "#ff4f50"
			this._lb_collect.stroke = 2
			this._lb_collect.strokeColor = "#000000"
			this._lb_collect.valign = "center"
			this._lb_collect.align = "center"
			this._lb_collect.scale(0.5, 0.5)
		}
	}


	//创建_gp_con
	public CreatGpCon() {
		if (!this._gp_con) {
			this._gp_con = this.CreatChilds(this._gp_parent, "_gp_con")
			this._gp_con.centerX = 0
			this._gp_con.anchorX = 0.5
		}
	}

	//创建_gp_touxian
	public CreatTouXianBox() {
		this.CreatGpCon()
		if (!this._gp_touxian)
			this._gp_touxian = this.CreatChilds(this._gp_con, "_gp_touxian")
	}

	//创建_gp_zhenying
	public CreatZhenyingBox() {
		this.CreatGpCon()
		if (!this._gp_zhenying)
			this._gp_zhenying = this.CreatChilds(this._gp_con, "_gp_zhenying")
	}

	//创建group_icon
	public CreatGroupIcon() {
		this.CreatZhenyingBox()
		if (!this.group_icon)
			this.group_icon = this.CreatChilds(this._gp_zhenying, "group_icon")
	}


	//创建 _img_medal
	public CreatMedalIcon() {
		this.CreatGpCon()
		if (!this._img_medal) {
			this._img_medal = this.CreatChilds(this._gp_con, "_img_medal")
		}

	}

	//创建 _lb_name
	public CreatNameText() {
		this.CreatGpCon()
		if (!this._lb_name) {
			this._lb_name = this.CreatChilds(this._gp_con, "_lb_name")
			this._lb_name.fontSize = 40
			this._lb_name.color = "#fffad2"
			this._lb_name.stroke = 2
			this._lb_name.strokeColor = "#000000"
			this._lb_name.valign = "center"
			this._lb_name.align = "center"
			this._lb_name.visible = true
			this._lb_name.scale(0.5, 0.5)
		}
	}

	//创建  _img_vip
	public CreatVipIcon() {
		this.CreatGpCon()
		if (!this._img_vip) {
			this._img_vip = this.CreatChilds(this._gp_con, "_img_vip")
		}

	}

	//创建 血条
	public CreatHpBar() {
		if (!this._gp_hp_bar) {
			this._gp_hp_bar = this.CreatChilds(this._gp_parent, "_gp_hp_bar")
			//this._gp_hp_bar.visible = true
		}

		if (!this.hp_bar) {
			this.hp_bar = ProgressBar2.create(this._gp_hp_bar, 100, 100, false, false, "uiComponent", "ui_4", "ui_5")
			if(!this.hp_bar.is_loaded)
				this.hp_bar.Load()
			this.hp_bar.SetPosition(0, 0)
		}
	}

	//创建 _img_boss_flag
	public CreatBossFlag() {
		if (!this._img_boss_flag) {
			this._img_boss_flag = this.CreatChilds(this._gp_parent, "_img_boss_flag")
			this._img_boss_flag.visible = false
		}
	}

	//创建 _gp_brick
	public CreatBrickBox() {
		if (!this._gp_brick) {
			this._gp_brick = this.CreatChilds(this._gp_parent, "_gp_brick")
			this._img_brick = this.CreatChilds(this._gp_brick, "_img_brick")
			this._img_brick_text = this.CreatChilds(this._gp_brick, "_img_brick_text")
		}
	}


	//创建 _box_dsgt
	public CreatDsgtBox() {
		if (!this._box_dsgt) {
			this._box_dsgt = this.CreatChilds(this._gp_parent, "_box_dsgt")
		}
	}


	//创建_npc_name
	public CreatNPCNameText() {
		if (!this._npc_name) {
			this._npc_name = this.CreatChilds(this._gp_parent, "_npc_name")
			this._npc_name.fontSize = 40
			this._npc_name.color = "#c2fdfa"//c2fdfa
			this._npc_name.stroke = 1
			this._npc_name.strokeColor = "#000000"
			this._npc_name.valign = "center"
			this._npc_name.align = "center"
			this._npc_name.scale(0.5, 0.5)
		}
	}


	///"_gp_title"
	public CreatGpTitle() {
		if (!this._gp_title) {
			this._gp_title = this.CreatChilds(this._gp_parent, "_gp_title")
		}
	}

	public CreatDsgtEffBox() {
		this.CreatDsgtBox()
		if (!this._gp_dsgt_effect) {
			this._gp_dsgt_effect = this.CreatChilds(this._box_dsgt, "_gp_dsgt_effect")
		}
	}


	public CreatDsgtImg() {
		this.CreatDsgtBox()
		if (!this._img_dsgt) {
			this._img_dsgt = this.CreatChilds(this._box_dsgt, "_img_dsgt")
			this._img_dsgt.visible = true
			this._img_dsgt.sizeGrid = "0,61,0,68"
		}
	}

	public CreatDsgtText() {
		this.CreatDsgtBox()
		if (!this._lb_dsgt) {
			this._lb_dsgt = this.CreatChilds(this._box_dsgt, "_lb_dsgt")
			this._lb_dsgt.visible = true
			this._lb_dsgt.color = "#323232"
			this._lb_dsgt.fontSize = 40
			this._lb_dsgt.strokeColor = "#000000"
			this._lb_dsgt.stroke = 2
			this._lb_dsgt.scale(0.5, 0.5)
		}
	}



	_gp_parent: Laya.Box
	public GetComponents() {
		[
			this._gp_parent,
		]
			= this.GetChildrenByNames([

				"_gp_parent",
			])
	}
}
var local_NameBoard = NameBoard
window["NameBoard"] = NameBoard