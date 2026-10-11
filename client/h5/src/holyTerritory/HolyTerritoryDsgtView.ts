import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetLocalScale, SetAnchoredPositionX, SetAnchoredPositionY, Trim } from "../util/Util"
import { GuildModel } from "../commonModel/GuildModel"
import { OpenFun } from "../common/OpenFun"
import { Alert, Alert_Type } from "../alert/Alert"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { table } from "../common/table"

export class HolyTerritoryDsgtView extends BaseItem1 {
	_Image11: Laya.Image
	rankBG: Laya.Image
	_Group1: Laya.Box
	Label1: Laya.Label
	Label2: Laya.Label
	_Label1: Laya.Label
	nameLabel1: Laya.HTMLDivElement
	fightLabel1: Laya.Label
	nameLabel2: Laya.HTMLDivElement
	fightLabel2: Laya.Label
	nameLabel3: Laya.HTMLDivElement
	fightLabel3: Laya.Label
	_Label2: Laya.Label
	guildRankLabel: Laya.HTMLDivElement
	_Label3: Laya.Label
	gTerLabel: Laya.HTMLDivElement
	_Label4: Laya.Label
	roleRankLabel: Laya.HTMLDivElement
	_Label5: Laya.Label
	rDsgtLabel: Laya.HTMLDivElement
	_Label6: Laya.Label
	_Label7: Laya.Label
	_Label8: Laya.Label
	dsgt1: Laya.Box
	dsgt2: Laya.Box
	dsgt3: Laya.Box
	guildBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	roleBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	territory2: Laya.Box
	g2a: Laya.Image
	g2b: Laya.Image
	terLabel2: Laya.HTMLDivElement
	territory3: Laya.Box
	g3a: Laya.Image
	g3b: Laya.Image
	terLabel3: Laya.HTMLDivElement
	territory1: Laya.Box
	g1a: Laya.Image
	g1b: Laya.Image
	terLabel1: Laya.HTMLDivElement
	fight1: Laya.Text
	fight2: Laya.Text
	fight3: Laya.Text
	fight_img1: Laya.Image
	fight_img2: Laya.Image
	fight_img3: Laya.Image
	bg1: Laya.Image
	bg2: Laya.Image
	InitEvent
	InitView
	LocalDeleteMe
	SelectTer
	SetFlag
	SetRank

	public constructor(parent?) {
		super(parent)

		let model = HolyTerritoryModel.GetInstance()
		let local_HTEvent = HTEvent
		let local_Util = Util
		let local_HolyTerritoryModel = HolyTerritoryModel

		let nowIndex_ = 0
		let defaultSelect_ = 2
		let dsgtCfg_ = null
		let dsgtScale_ = [1.5, 1.3, 1.2]
		let colorTo_ = ["#00fa64", "#ff4f50", "#60aeff"]
		let wordList_ = ["战力第1名", "战力第2-4名", "战力第5-10名"]
		let belongList_ = []
		this.base_file = "holyTerritory"
		this.layout_file = "HolyTerritoryDsgtView"
		this.preload_server_config = {
			"config_sanctuary_designation": false,
			"config_dsgt": false
		}
		this.load_callback = () => {

			let i = 1
			do {
				model.Fire(local_HTEvent.REQUEST_PROTO, 28301, "c", i)
				model.Fire(local_HTEvent.REQUEST_PROTO, 28312, "c", i)
				i = i + 1
			} while ((i <= 3))
			model.Fire(local_HTEvent.REQUEST_PROTO, 28314)
			this.InitView()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label7.size  = 15
			// 	this.Label1.size  = 20
			// 	this.Label2.size  = 20
			// 	this._Label1.size  = 20
			// 	this._Label2.size  = 16
			// 	this._Label8.size  = 20
			// 	let csf = this._Label8.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDelta(this._Label8,450,50)
			// 	this._Label8.lineSpacing = 0.7
			// }

			// if (PlatformMgr.GetInstance().IsEyouPlatform() ) {
			// 	this.nameLabel1.lineSpacing = 1
			// 	this.nameLabel2.lineSpacing = 1
			// 	this.nameLabel3.lineSpacing = 1
			// 	this.fightLabel1.lineSpacing = 1
			// 	this.fightLabel2.lineSpacing = 1
			// 	this.fightLabel3.lineSpacing = 1
			// }
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.territory1, () => {
				this.SelectTer(1)
			}
				, this, true)
			Util.AddClickEvent(this.territory2, () => {
				this.SelectTer(2)
			}
				, this, true)
			Util.AddClickEvent(this.territory3, () => {
				this.SelectTer(3)
			}
				, this, true)
			Util.AddClickEvent(this.guildBtn, () => {
				local_HolyTerritoryModel.BackIndex = 1
				if (GuildModel.IsHasGuild()) {
					OpenFun.OpenFunHandler(4, 2, 1)
				} else {
					Alert.Show("请先加入一个结社", Alert_Type.One, () => {
						OpenFun.OpenFunHandler(4)
					}
						, null, "前往加入")
				}
			}
				, this, true)
			Util.AddClickEvent(this.roleBtn, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 28302)
			}
				, this, true)

			this.BindEvent(model, local_HTEvent.DSGT_DATA, (scmd?) => {
				if (scmd.sanctuary_id == nowIndex_) {
					this.SelectTer(nowIndex_, true)
				}
			}
			)
			this.BindEvent(model, local_HTEvent.UPDATE_SETTLE, (scmd?) => {
				this.SetRank()
			}
			)
			this.BindEvent(model, local_HTEvent.UPDATE_MONSTER_DATA, (scmd?) => {
				if (!this.is_loaded) {
					return
				}
				this.SetFlag()
				this.SelectTer(nowIndex_, true)
			}
			)
		}

		this.InitView = () => {
			dsgtCfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sanctuary_designation", false)
			this.SetFlag()
			this.SelectTer(defaultSelect_)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.rankBG, GameResPath.GetIcon("holyTerritory", "uisy_004bb"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("holyTerritory", "bg_56"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIcon("holyTerritory", "xx_titleBg16"), true)
		}

		this.SetFlag = () => {
			let i = 1
			do {
				let monData = model.monsterData[i]
				let name = "<font color='#FFFFFF'>暂无归属</font>"
				let hasbelong = monData && monData.belong > 0
				if (hasbelong) {
					if (monData.belong) {
						name = monData.belong_name
					}
					if (monData.belong == RoleManager.GetInstance().GetMainRoleVo().guild_id) {
						defaultSelect_ = i
						name = "<font color='#00fa64'>" + monData.belong_name + "</font>"
					}
					// [ts2lua]this下标访问可能不正确
					ResManager.GetInstance().SetOutsideImageSprite(this, this["g" + i + "a"], GameResPath.GetIcon("holyTerritory", "uisy_00" + i + "bbbc"), true)
					// [ts2lua]this下标访问可能不正确
					ResManager.GetInstance().SetOutsideImageSprite(this, this["g" + i + "b"], GameResPath.GetIcon("holyTerritory", "uisy_00" + i + "bbba"), true)
				} else {
					ResManager.GetInstance().SetOutsideImageSprite(this, this["g" + i + "a"], GameResPath.GetIcon("holyTerritory", "uisy_00" + i + "bbbc"), true)
					// [ts2lua]this下标访问可能不正确
					ResManager.GetInstance().SetOutsideImageSprite(this, this["g" + i + "b"], GameResPath.GetIcon("holyTerritory", "uisy_00" + i + "bbba"), true)
					// [ts2lua]this下标访问可能不正确
					//lua_resM:SetImageSprite(this, this["imgg" + i .. "a"], "holyTerritory_asset","uisy_00" + i .. "ga",true)
					//// [ts2lua]this下标访问可能不正确
					//lua_resM:SetImageSprite(this, this["imgg" + i .. "b"], "holyTerritory_asset", "uisy_00" + i .. "gb",true)
				}
				belongList_[i] = hasbelong
				// [ts2lua]this下标访问可能不正确
				this["g" + i + "b"].visible = !hasbelong
				// [ts2lua]this下标访问可能不正确
				// [ts2lua]this下标访问可能不正确
				this["g" + i + "a"].visible = !hasbelong
				// [ts2lua]this下标访问可能不正确
				this["terLabel" + i].style.fontSize = 22
				this["terLabel" + i].style.valign = "center"
				this["terLabel" + i].style.color = "#ffffff"
				this["terLabel" + i].width = 200
				this["terLabel" + i].innerHTML = Util.StrToHTML(name)
				i = i + 1
			} while ((i <= 3))
		}

		this.SetRank = () => {
			let rankStr = "<font color='#9c9c9c'>暂无</font>"
			let rankData = model.SettleInfo
			if (rankData && rankData.guild_rank > 0) {
				if (rankData.guild_rank <= 3) {
					rankStr = "<font color='#00fa64'>前三</font>"
				} else {
					rankStr = "<font color='#00fa64'>第" + rankData.guild_rank + "名</font>"
				}
			}
			this.guildRankLabel.style.fontSize = 20
			this.guildRankLabel.style.valign = "center"
			this.guildRankLabel.style.color = "#ffffff"
			this.guildRankLabel.width = 500
			this.guildRankLabel.innerHTML = Util.StrToHTML("本结社排名:" + rankStr)
			let guildTer = "<font color='#9c9c9c'>暂无</font>"
			if (rankData.sanctuary_id > 0) {
				// [ts2lua]local_HolyTerritoryModel.IndexToWord下标访问可能不正确
				guildTer = "<font color='#00fa64'>" + (local_HolyTerritoryModel.IndexToWord[rankData.sanctuary_id - 1] || "") + "</font>"
			}
			this.gTerLabel.style.fontSize = 20
			this.gTerLabel.style.valign = "center"
			this.gTerLabel.style.color = "#ffffff"
			this.gTerLabel.width = 500
			this.gTerLabel.innerHTML = Util.StrToHTML(guildTer)
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
			let dsgt = cfg[rankData.desination_id]
			// [ts2lua]lua中0和空字符串也是true，此处rankData.person_rank需要确认
			let Str = ((rankData.person_rank && rankData.person_rank > 0) && ("<font color='#00fa64'>" + rankData.person_rank + "</font>") || ("<font color='#9c9c9c'>暂无</font>"))
			this.roleRankLabel.style.fontSize = 20
			this.roleRankLabel.style.valign = "center"
			this.roleRankLabel.style.color = "#ffffff"
			this.roleRankLabel.width = 500
			this.roleRankLabel.innerHTML = Util.StrToHTML("个人排名:" + Str)
			// [ts2lua]lua中0和空字符串也是true，此处dsgt需要确认
			this.rDsgtLabel.style.fontSize = 20
			this.rDsgtLabel.style.valign = "center"
			this.rDsgtLabel.style.color = "#ffffff"
			this.rDsgtLabel.width = 150
			this.rDsgtLabel.innerHTML = Util.StrToHTML((dsgt && ("<font color='#00fa64'>" + dsgt.name + "</font>") || ("<font color='#9c9c9c'>暂无</font>")))
		}

		this.SelectTer = (id?, froce?) => {
			if (id == nowIndex_ && !froce) {
				return
			}
			nowIndex_ = id
			let data = model.GetDsgtData(id)
			let rankEchelon = { "1": 0, "2": 1, "3": 4, "4": 10 }
			let cfgKey = { "1": `1@1`, "2": `2@4`, "3": `5@10` }
			if (data && data.length > 0) {
				let sortFunc = (a?, b?) => {
					return a.rank < b.rank
				}
				table.sort(data, sortFunc)

				let i = 1
				do {
					let nameStr = ""
					let fightStr = ""
					// [ts2lua]this下标访问可能不正确
					this["g" + i + "a"].visible = id == i
					// [ts2lua]this下标访问可能不正确
					this["g" + i + "b"].visible = id != i
					// [ts2lua]data下标访问可能不正确


					let color = ""
					switch (i) {
						case 1:
							color = "#ff6519"
							break;
						case 2:
							color = "#e036f4"
							break;
						case 3:
							color = "#2971e6"
							break;

					}
					if (data[rankEchelon[i]]) {
						let j = rankEchelon[i]
						if (j < rankEchelon[i + 1] && j < data.length) {
							do {
								nameStr = nameStr + data[j].role_name + "<br>"
								//fightStr = fightStr + data[j].power + "\n"
								if (j == data.length - 1 || j == rankEchelon[i + 1] - 1)
									fightStr = fightStr + data[j].power + ""
								else
									fightStr = fightStr + data[j].power + "\n"
								j = j + 1
								// [ts2lua]rankEchelon下标访问可能不正确 
							} while ((j < rankEchelon[i + 1] && j < data.length))
						}
						// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
						// nameStr = nameStr.gsub('\n$', "")
						// //// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
						// fightStr = fightStr.gsub('\n$', "")
					}
					if (nameStr == "") {
						nameStr = "<font color='" + color + "'>" + wordList_[i - 1] + "</font>"
					}
					// [ts2lua]this下标访问可能不正确
					this["nameLabel" + i].style.fontSize = 22
					this["nameLabel" + i].style.valign = "center"
					this["nameLabel" + i].style.color = color//2#f551ff//3#277dd6
					this["nameLabel" + i].width = 250
					this["nameLabel" + i].style.leading = 1
					//this.nameLabel1.style.leading = 1
					this["nameLabel" + i].innerHTML = nameStr

					// [ts2lua]this下标访问可能不正确
					this["fightLabel" + i].text = Trim(fightStr)

					this["nameLabel" + i].parent.refresh()
					//	this["fightLabel" + i].parent.refresh()
					if (dsgtCfg_) {
						// [ts2lua]dsgtCfg_下标访问可能不正确
						let cfg = dsgtCfg_[id + "@" + cfgKey[i]]
						if (cfg) {
							let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
							let dsgt = _cfg[cfg.designation_id]
							// [ts2lua]this下标访问可能不正确
							this.ClearUIEffect(this["dsgt" + i])
							this["dsgtimg_" + i] = undefined
							if (dsgt.type == 1) {
								// [ts2lua]this下标访问可能不正确
								// [ts2lua]this下标访问可能不正确
								// [ts2lua]this下标访问可能不正确
								this["dsgt" + i].width = 720
								this["dsgt" + i].height = 1280
								this["dsgt" + i].mouseThrough = true
								this["dsgt" + i].mouseEnabled = false
								this.AddUIEffect(dsgt.resource_id, this["dsgt" + i]) //{x=this["dsgt" + i].width / 2, y=this["dsgt" + i].height / 2}
							} else {
								let img: Laya.Image = this["dsgtimg_" + i]
								if (!img) {
									img = new Laya.Image()//UiFactory.CreateChild(this["transdsgt" + (i],UIType.Image).transform - -eui. new Image())
									// [ts2lua]this下标访问可能不正确
									img.autoSize = true
									img.centerX = 0
									let a = this["dsgt" + i]
									a.addChild(img)
									//let url = "resource/game/dsgt/dsgtIcon/" + dsgt.resource_id + ".png"
									this["dsgtimg_" + i] = img
									SetLocalScale(img, dsgtScale_[i - 1])
								}

								ResManager.GetInstance().SetOutsideImageSprite(this, img, GameResPath.GetDesignImage(dsgt.resource_id), true)
							}
						}
					}
					// [ts2lua]this下标访问可能不正确
					//SetAnchoredPositionX(this["fight" + i], 490)
					this["fight" + i].visible = true
					this["fight_img" + i].visible = false
					i = i + 1
				} while ((i <= 3))
				// [ts2lua]this下标访问可能不正确
				// SetAnchoredPositionY(this["fight1"], 481)
				// //this["fight1"].y = 481
				// // [ts2lua]this下标访问可能不正确
				// SetAnchoredPositionY(this["fight2"], 581)
				// //this["fight2"].y = 581
				// // [ts2lua]this下标访问可能不正确
				// SetAnchoredPositionY(this["fight3"], 714)
				//this["fight3"].y = 714
				this.Label1.text = "玩家名字"
				this.Label2.text = "个人战力"
			} else {
				this.Label1.text = "结社内排名"
				this.Label2.text = "称号价值"
				let i = 1
				do {
					// [ts2lua]this下标访问可能不正确
					this["g" + i + "a"].visible = id == i
					// [ts2lua]this下标访问可能不正确
					this["g" + i + "b"].visible = id != i
					// [ts2lua]this下标访问可能不正确
					this["nameLabel" + i].style.fontSize = 22
					this["nameLabel" + i].style.valign = "center"
					this["nameLabel" + i].style.color = "#ff7800"//2#f551ff//3#277dd6
					this["nameLabel" + i].width = 250
					this["nameLabel" + i].style.leading = 1
					this["nameLabel" + i].innerHTML = Util.StrToHTML(wordList_[i - 1])
					//this["nameLabel" + i].parent.centerY = 0
					let a = this["nameLabel" + i].parent
					a.refresh()
					this["fightLabel" + i].text = ""
					// [ts2lua]this下标访问可能不正确
					//this["fightLabel" + i].text =
					// [ts2lua]this下标访问可能不正确
					//SetAnchoredPositionX(this["fight" + i], 260)
					this["fight_img" + i].visible = true
					this["fight" + i].visible = false
					if (dsgtCfg_) {
						// [ts2lua]dsgtCfg_下标访问可能不正确
						let cfg = dsgtCfg_[id + "@" + cfgKey[i]]
						if (cfg) {
							let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
							let dsgt = cfg_[cfg.designation_id]
							// [ts2lua]this下标访问可能不正确
							this.ClearUIEffect(this["dsgt" + i])
							this["dsgtimg_" + i] = undefined
							if (dsgt.type == 1) {
								// [ts2lua]this下标访问可能不正确
								// [ts2lua]this下标访问可能不正确
								// [ts2lua]this下标访问可能不正确
								this["dsgt" + i].width = 720
								this["dsgt" + i].height = 1280
								this["dsgt" + i].mouseThrough = true
								this["dsgt" + i].mouseEnabled = false
								this.AddUIEffect(dsgt.resource_id, this["dsgt" + i])
								//this.AddUIEffect2(dsgt.resource_id, this["transdsgt" + i],null , {x=1.5, y=1.5}, true)//{x=this["dsgt" + i].width / 2, y=this["dsgt" + i].height / 2}
							} else {
								let img = this["dsgtimg_" + i]
								if (!img) {
									img = new Laya.Image()//UiFactory.CreateChild(this["dsgt" + (i],UIType.Image).transform - -eui. new Image())
									// [ts2lua]this下标访问可能不正确
									img.autoSize = true
									img.centerX = 0
									let a = this["dsgt" + i]
									a.addChild(img)
									//let url = "resource/game/dsgt/dsgtIcon/" + dsgt.resource_id + ".png"
									this["dsgtimg_" + i] = img
									SetLocalScale(img, dsgtScale_[i - 1])
								}
								ResManager.GetInstance().SetOutsideImageSprite(this, img, GameResPath.GetDesignImage(dsgt.resource_id), true)
							}
						}
					}
					i = i + 1
				} while ((i <= 3))
				// [ts2lua]this下标访问可能不正确
				// SetAnchoredPositionY(this.fight1, 445)
				// SetAnchoredPositionY(this.fight2, 545)
				// SetAnchoredPositionY(this.fight3, 685)
				//this["fight1"].y = 445
				//// [ts2lua]this下标访问可能不正确
				//this["fight2"].y = 545
				//// [ts2lua]this下标访问可能不正确
				//this["fight3"].y = 685
			}
		}

		this.LocalDeleteMe = () => {
			let i = 1
			do {
				// [ts2lua]this下标访问可能不正确
				if (this["dsgt" + i]) {
					// [ts2lua]this下标访问可能不正确
					this.ClearUIEffect(this["dsgt" + i])
				}
				i = i + 1
			} while ((i <= 3))
		}


	}

	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()

	}



	public GetComponents() {
		[
			this._Image11,
			this.rankBG,
			this._Group1,
			this.Label1,
			this.Label2,
			this._Label1,
			this.nameLabel1,
			this.fightLabel1,
			this.nameLabel2,
			this.fightLabel2,
			this.nameLabel3,
			this.fightLabel3,
			this._Label2,
			this.guildRankLabel,
			this._Label3,
			this.gTerLabel,
			this._Label4,
			this.roleRankLabel,
			this._Label5,
			this.rDsgtLabel,
			this._Label6,
			this._Label7,
			this._Label8,
			this.dsgt1,
			this.dsgt2,
			this.dsgt3,
			this.guildBtn,
			this._Image1,
			this.labelDisplay1,
			this.roleBtn,
			this._Image111,
			this.labelDisplay,
			this.territory2,
			this.g2a,
			this.g2b,
			this.terLabel2,
			this.territory3,
			this.g3a,
			this.g3b,
			this.terLabel3,
			this.territory1,
			this.g1a,
			this.g1b,
			this.terLabel1,
			this.fight1,
			this.fight2,
			this.fight3,
			this.fight_img1,
			this.fight_img2,
			this.fight_img3,
			this.bg1,
			this.bg2
		]
			= this.GetChildrenByNames([

				"_Image11",
				"rankBG",
				"_Group1",
				"Label1",
				"Label2",
				"_Label1",
				"nameLabel1",
				"fightLabel1",
				"nameLabel2",
				"fightLabel2",
				"nameLabel3",
				"fightLabel3",
				"_Label2",
				"guildRankLabel",
				"_Label3",
				"gTerLabel",
				"_Label4",
				"roleRankLabel",
				"_Label5",
				"rDsgtLabel",
				"_Label6",
				"_Label7",
				"_Label8",
				"dsgt1",
				"dsgt2",
				"dsgt3",
				"guildBtn",
				"_Image1",
				"labelDisplay1",
				"roleBtn",
				"_Image111",
				"labelDisplay",
				"territory2",
				"g2a",
				"g2b",
				"terLabel2",
				"territory3",
				"g3a",
				"g3b",
				"terLabel3",
				"territory1",
				"g1a",
				"g1b",
				"terLabel1",
				"fight1",
				"fight2",
				"fight3",
				"fight_img1",
				"fight_img2",
				"fight_img3",
				"bg1",
				"bg2"

			])
	}
}
window["HolyTerritoryDsgtView"] = HolyTerritoryDsgtView