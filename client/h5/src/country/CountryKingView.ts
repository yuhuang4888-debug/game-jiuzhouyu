import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { SceneBaseType } from "../scene/SceneConfig"
import { TrumpetItem } from "../sysInfo/TrumpetItem"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetHtmlStyle, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class CountryKingView extends BaseItem1 {
    ClearModel
    CreateModel
    Dispose
    InitEvent
    InitView
    ReOpen_callback
    UpdateView
    itemList
    figure
    role_loaded_vo
    public constructor(parent?) {
        super(parent)

        this.base_file = "country"
        this.layout_file = "CountryKingView"
        let local_util = Util
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        let local_UI_MODEL_TYPE = UI_MODEL_TYPE
        this.preload_client_config = { "ClientSeaHegemony": false }
        this.load_callback = () => {
            this._Scroller1.hScrollBarSkin=""
			SetHtmlStyle(this.timeLb,{f:18,c:"#cecde2",ww:false})
            ResManager.GetInstance().SetImageSprite(this,this._Image2,"country","ui_shzb_013")
            this.InitEvent()
            this.InitView()
        }

        this.InitView = () => {
            this.UpdateView()
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientSeaHegemony", true)

            if(cfg){
                let rewardData = cfg.showSeaKingReward
                if (!this.itemList) {
                    this.itemList = []
                }
                this.Content.x = (this._Scroller1.width - (rewardData.length * 90 + (rewardData.length - 1) * this.Content.space)) / 2
                let i = 0
                do {
                    let vo = rewardData[i]

                    let item = this.itemList[i]
                    if(!item){
                        item = new BaseAwardItem(this.Content)
                        item.Load()
                    }
                    let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                    item.SetData(type_id, vo[2])
                    this.itemList[i] = item
                    item.SetItemSize(90, 90)
                    i = i + 1
                } while ((i < rewardData.length))
            }
          
        }

        this.InitEvent = () => {
            // Util.AddClickEvent(
            //     this.winBtn, () => {
            //         local_modelIns.Fire(local_model.OPEN_VIEW, "SeaWinRewardView")
            //     },
            //     this,
            //     true
            // )
            Util.AddClickEvent(
                this.rewardBtn, () => {
                    local_modelIns.Fire(local_model.OPEN_VIEW, "SeaReawrdPreView", 2)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.enterBtn, () => {
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18613, "i", 49001)
                },
                this,
                true
            )
            this.BindEvent(
                local_modelIns,
                local_model.KING_INFO, () => {
                    this.UpdateView()
                }
            )
            this.BindEvent(
                local_modelIns,
                local_model.START_DATA, () => {
                    if (this.use_delete_method) {
                        return
                    }
                    this.activeRed.visible = local_modelIns.kingActiveRed
                }
            )
            this.BindEvent(
                GuildFightModel.GetInstance(),
                GuildFightEvent.UPDATE_REQUEST_FIGURE, (scmd?) => {
                    if (scmd.model_id != 186) {
                        return
                    }
                    this.figure = scmd.figure
                    this.CreateModel(scmd.figure)
                    this.nameLb.text = scmd.figure.name
                }
            )
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18615)
        }

        this.ReOpen_callback = () => {
            if (this.figure) {
                this.CreateModel(this.figure, true)
            }
        }

        this.UpdateView = () => {
            let startData = local_modelIns.StartInfo
            if (startData) {
                let time_open=startData.start_time !=0&& startData.start_time < TimeUtil.getServerTime() && TimeUtil.getServerTime() < startData.end_time
                if (startData.act_type == 2&& time_open) {
                    this.timeLb.innerHTML = Util.StrToHTML("争夺时间:<font color='#a0ff67'>进行中</font>")
                } else {
                    let time = local_modelIns.activeStartTime[2]
                    if (time) {
                        // let date = os.date("*t", time.start_time)
                        let time_str = TimeUtil.timeConversion(time.start_time, "")
                        this.timeLb.innerHTML = Util.StrToHTML(`争夺时间:<font color='#a0ff67'>${time_str}</font>`)
                    }
                }
            }
            let data = local_modelIns.seaKingData
            if (data && data.camp != 0) {
                ResManager.GetInstance().SetImageSprite(this, this.seaIcon, "country", "ui_shzb_0" + (36 + data.camp))
                GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_REQUEST_PROTO, 13014, "hlh", data.server_id, data.guild_id, 186)
                this.noImg.visible = false
            } else {
                this.noImg.visible = true
                this.nameLb.text = "虚位以待"
                ResManager.GetInstance().SetOutsideImageSprite(this, this.noImg, GameResPath.GetIconOtherPath("country", "uikf1vn_003"))
				ResManager.GetInstance().SetOutsideImageSprite(this, this.no_2, GameResPath.GetIconOtherPath("country", "ui_shzb_021"))
            }
            this.activeRed.visible = local_modelIns.kingActiveRed
            // this.disRed.visible = local_modelIns.disRed  连胜奖励的按钮
        }

        this.CreateModel = (role_vo?) => {
            
			if (!role_vo) {
				return
			}
			if (this.role_loaded_vo && this.role_loaded_vo.name == role_vo.name) {
				return
			}
			this.role_loaded_vo = role_vo
			let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
			let weapon_model_id = Util.GetWeaponClotheId(role_vo)
			let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
			let wing_id = Util.GetWingClotheId(role_vo)
			let back_ornament_id = Util.GetBackOrnamentId(role_vo)
			let liveness_id = Util.GetLivenessId(role_vo)

			this.ClearModel()

			let data = {
				career: role_vo.career,
				sex: role_vo.sex,
                layer_value: this.layer_value,
				scale: 0.8,
                position: new Vector3(0, 0.7, 0),
                type: UI_MODEL_TYPE.MAINROLE,

				clothe_res_id: model_id,
				fashion_model_id: model_id,
				texture_id: texture_id,

				head_wear_id: head_id,
				head_clothe_id: head_texture_id,

				weapon_res_id: weapon_model_id,
				weapon_clothe_id: 0,
				
				wing_id: wing_id,
				back_ornament_id: back_ornament_id,
				liveness_id: liveness_id
			}
			ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
        }

        this.ClearModel = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}

        this.Dispose = () => {
            if (this.itemList) {
                for (let _tmpi in this.itemList) {
                    var vo = this.itemList[_tmpi]
                    vo.DeleteMe()
                }
                this.itemList = null
            }
            this.ClearModel()
        }
    }

    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }


    tableImg: Laya.Image
    modelGp: Laya.Box
    _Image1: Laya.Image
    seaIcon: Laya.Image
    _Image2_2: Laya.Image
    _Image3: Laya.Image
    rewardBtn: Laya.Image
    _Label1: Laya.Label
    _Image2: Laya.Image
    _Image3_3: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    titleLb: Laya.Label
    enterBtn: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    activeRed: Laya.Image
    timeLb: Laya.HTMLDivElement
    nameLb: Laya.Label
    noImg: Laya.Image
    no_2: Laya.Image
    public GetComponents() {
        [
            this.tableImg,
            this.modelGp,
            this._Image1,
            this.seaIcon,
            this._Image2_2,
            this._Image3,
            this.rewardBtn,
            this._Label1,
            this._Image2,
            this._Image3_3,
            this._Scroller1,
            this.Content,
            this.titleLb,
            this.enterBtn,
            this._Image11,
            this.labelDisplay,
            this.activeRed,
            this.timeLb,
            this.nameLb,
            this.noImg,
            this.no_2,
        ]
            = this.GetChildrenByNames([

                "tableImg",
                "modelGp",
                "_Image1",
                "seaIcon",
                "_Image2_2",
                "_Image3",
                "rewardBtn",
                "_Label1",
                "_Image2",
                "_Image3_3",
                "_Scroller1",
                "Content",
                "titleLb",
                "enterBtn",
                "_Image11",
                "labelDisplay",
                "activeRed",
                "timeLb",
                "nameLb",
                "noImg",
                "no_2",
            ])
    }
}
window["CountryKingView"] = CountryKingView