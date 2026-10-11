import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, SetSizeDeltaY } from "../util/Util"
import { BaseAwardItem } from "./BaseAwardItem"
import { BaseView1 } from "./BaseView1"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"
import { LoopScrowViewMgr } from "./LoopScrowViewMgr"
import { MaterialsItem } from "./MaterialsItem"
import { MaterialsTool } from "./MaterialsTool"
import { ResManager } from "./ResManager"
import { table } from "./table"

export class MaterialsView extends BaseView1 {

	public _bg1: Laya.Image;
	public _bg2: Laya.Image;
	public _Image11: Laya.Image;
	public icon: Laya.Box;
	public _Group1: Laya.Box;
	public _Image2: Laya.Image;
	public _Image3: Laya.Image;
	public goodName: Laya.Label;
	public goodType: Laya.Label;
	public item_con: Laya.VBox;
	public btnClose: Laya.Image;
	public special_con: Laya.VBox;
	public goodNamehtml: Laya.HTMLDivElement
	public itemScroller: Laya.Panel;
	public spcialScroller: Laya.Panel;


	item_List = []
	updateItem
	destroy_imm
	type_id
	changeHeight
	SetData
	list_loop_mgr
	is_center
	no_show_id
	open_callback
	LoadSuccess
	click_bg_toClose
	remove
	InitEvent
	close_callback
	use_background
	goods_vo


	public constructor() {
		super()

		this.goods_vo = null;
		this.type_id = null;
		this.base_file = "common"
		this.layout_file = "MaterialsView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true
		let goods_icon = null
		let arrayCollection = null
		let _bg1_height = 0
		let _bg2_height = 0
		let material_list = []

		//未开发功能
		this.no_show_id = {
			"102": true
		}

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("common4", "uisy_026a"))
			this.LoadSuccess()
			this.InitEvent()
		}

		this.close_callback = () => {
			this.remove()
		}

		this.open_callback = () => {
			this.itemScroller.vScrollBarSkin = ""
			this.SetData()
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.btnClose, close_fun, this, true, null, null, null, null, true)
			this.BindEvent(GlobalEventSystem, EventName.MATERIAL_VIEW_CLOSE, close_fun)
		}

		this.LoadSuccess = () => {
			this.goodType.visible = false
			_bg1_height = this._bg1.height
			_bg2_height = this._bg2.height
			this.itemScroller.vScrollBarSkin = ""
		}

		this.SetData = () => {
			if (this.type_id || this.goods_vo) {
				this.goods_vo = this.goods_vo || GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.type_id)
				if (!goods_icon) {
					goods_icon = new BaseAwardItem(this.icon)
					goods_icon.Load()
					goods_icon.SetScale(0.8)
					goods_icon.ChangeCountVisible(false)
				}
				if (this.goods_vo) {
					goods_icon.SetData(this.goods_vo.type_id)
				}
				this.goodNamehtml.style.color = "#FFFFFF";
				this.goodNamehtml.style.fontSize = 22;
				let textcolor = ColorUtil.GetColorDark(this.goods_vo.color)
				this.goodName.text = ""
				let content = "<font color=" + textcolor + ">" + this.goods_vo.goods_name + "</font>"
				this.goodNamehtml.width = 500
				this.goodNamehtml.innerHTML = content
				this.goodNamehtml.x = 555 / 2 - this.goodNamehtml.contextWidth / 2;
			}
			let openList = []
			let getway_url = this.goods_vo && this.goods_vo.getway_url
			if (!getway_url || getway_url == "") {
				return
			}
			let list = ErlangParser.GetInstance().Parse(this.goods_vo.getway_url)
			for (let key in list) {
				let info = list[key]
				let info_1 = Number(info[0])
				if (this.goods_vo.type_id == 37020002 && info_1 == 70 && FirstRechargeModel.GetInstance().IsDoneFirstRecharge()) {
					continue
				}
				
				if (info_1 == 60 || info_1 >= 140 && info_1 <= 145) {
					list[key][3] = this.type_id
					table.insert(openList, list[key])
				} else if (info_1 == 172) {
					table.insert(openList, list[key])
				}
				else if (this.goods_vo.type_id == 38160001) {
					if (FirstRechargeModel.GetInstance().IsNoFirstRecharge() && Number(info_1) == 70) {
						table.insert(openList, list[key])
						break
					}
					if (!FirstRechargeModel.GetInstance().IsNoFirstRecharge() && Number(info_1) == 72 && RoleManager.GetInstance().GetMainRoleLevel() >= 90) {
						table.insert(openList, list[key])
						break
					}

				}
				else {
					//未开发功能暂时屏蔽
					if (!this.no_show_id[Number(list[key][0])]) {
						table.insert(openList, [list[key][0]])
					}
				}
			}
			this.changeHeight(openList.length)
			this.updateItem(openList)
		}

		this.changeHeight = (length?) => {
			let num = length >= 3 ? 0 : 3 - length
			let add = num > 0 ? 20 : 0
			let height = _bg1_height - num * (90 + 8) + add
			SetSizeDeltaY(this._bg1, height)
			this.display_obj.height = height
			SetSizeDeltaY(this._bg2, length != 0 && _bg2_height - num * (90 + 8) + add || 0)
		}

		this.updateItem = (openList?) => {
			//let is_in_story = FunctionOpenModel.GetInstance().IsInShowingStory(FuncOpenId.MonBook)
			let is_in_story = false
			for (let i in openList) {
				let info = openList[i]
				let item = new MaterialsItem(this.item_con)
				item.SetData(info)
				item.Load()
				this.item_List.push(item)
				// item.visible = true
			}
			// if (!this.list_loop_mgr) {
			// this.list_loop_mgr = new LoopScrowViewMgr()
			// this.list_loop_mgr.SetData(this.item_con, MaterialsItem, openList, this.itemScroller, 1)
			/////测试用
			// for(let i=0;i<10;i++){
			// 	let info
			// 	let item=new MaterialsItem(this.item_con)
			// 	item.Load()
			// 	item.SetData(i.toString())
			// 	// item.visible = true
			// }
			/////测试用
			//if (is_in_story ) {
			//this.special_con.visible = true 
			//this.itemScroller.visible = false 
			////this.special_con.dataProvider = arrayCollection
			////this.special_con.itemRenderer = MaterialsItem
			//}else{
			//this.special_con.visible = false 
			//this.itemScroller.visible = true 
			////this.item_list.dataProvider = arrayCollection
			////this.item_list.itemRenderer = MaterialsItem
			////this.itemScroller.viewport = this.item_list
			//}
			// } else {
			// 	this.list_loop_mgr.replaceAll(openList)
			// }

			let num = openList.length >= 3 && 3 || openList.length
			// if (is_in_story) {
			// 	SetSizeDeltaY(this.itemScroller, num * 98 > 270 && 270 || num * 98)
			// } else {
			// 	let cut = num >= 3 && 49 || 0
			// 	SetSizeDeltaY(this.itemScroller, num * 98 > 270 && 270 || num * 98 - cut)
			// }
			this.itemScroller.vScrollBarSkin = ""
		}

		this.remove = () => {
			let item: MaterialsItem
			for (let key in this.item_List) {
				item = this.item_List[key];
				item.DeleteMe()
			}
			this.item_List.length = 0
			if (goods_icon) {
				goods_icon.DeleteMe()
			}
			if (this.list_loop_mgr) {
				this.list_loop_mgr.DeleteMe()
				this.list_loop_mgr = null
			}
			this.goods_vo = null
			goods_icon = null
			//FunctionOpenModel:GetInstance():ClearNowStory(FuncOpenId.MonBook)
		}


	}

	public Open(...new_args) {

		this.type_id = new_args[0],
			this.goods_vo = new_args[1]
		super.Open()
	}

	public GetComponents() {

		[this._bg1,
		this._bg2,
		this._Image11,
		this.icon,
		this._Group1,
		this._Image2,
		this._Image3,
		this.goodName,
		this.goodType,
		this.item_con,
		this.btnClose,
		this.special_con,
		this.goodNamehtml,
		this.itemScroller,
		this.spcialScroller] =
			this.GetChildrenByNames(["_bg1",
				"_bg2",
				"_Image11",
				"icon",
				"_Group1",
				"_Image2",
				"_Image3",
				"goodName",
				"goodType",
				"item_con",
				"btnClose",
				"special_con",
				"goodNamehtml",
				"itemScroller",
				"spcialScroller"])
	}


}

window["MaterialsView"] = MaterialsView