import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GuildModel } from "../commonModel/GuildModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Util } from "../util/Util"

export class SeaHegemonyJoinItem extends BaseItem1 {
    model
    hasJoin
    need_fresh
    index
    public constructor(parent?) {
        super(parent)

        this.model = SeaHegemonyModel.GetInstance()
        this.hasJoin = false
        this.base_file = "seaHegemony"
        this.layout_file = "SeaHegemonyJoinItem"
        this.need_fresh = false
        this.load_callback = () => {

            Util.AddClickEvent(
                this.joinBtn, () => {
                    if (GuildModel.IsGuildMaster()) {
                        if (this.index) {
                            if (this.hasJoin) {
                                if (this.index == this.model.seaHegemonyData.camp) {
                                    // [ts2lua]this.model.nameList下标访问可能不正确
                                    Alert.Show(
                                        "是否将本结社退出" + this.model.nameList[this.index-1] + "势力争夺？",
                                        Alert_Type.Two, () => {
                                            this.model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18620, "i", this.index)
                                            this.model.Fire(SeaHegemonyModel.CLOSE_VIEW, "SeaListView")
                                        }
                                    )
                                }
                            } else {
                                // [ts2lua]this.model.nameList下标访问可能不正确
                                Alert.Show(
                                    "是否将本结社加入至" + this.model.nameList[this.index-1] + "势力争夺？",
                                    Alert_Type.Two, () => {
                                        this.model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18619, "i", this.index)
                                        this.model.Fire(SeaHegemonyModel.CLOSE_VIEW, "SeaListView")
                                    }
                                )
                            }
                        }
                    }
                    else if (this.hasJoin) {
                        Message.show("只有会长可以选择退出海域!")
                    } else {
                        Message.show("只有会长可以选择加入海域!")
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.allLb, () => {
                    this.model.Fire(SeaHegemonyModel.OPEN_VIEW, "SeaFightGuildView", this.index)
                },
                this,
                true
            )
            this.BindEvent(
                this.model,
                SeaHegemonyModel.JOIN_VIEW_DATA, () => {
                    this.SetData(this.index)
                }
            )


            if (this.need_fresh) {
                this.need_fresh = false
                this.SetData(this.index)
            }
        }
    }

    public SetData(index?) {
        this.index = index
        if (!this.is_loaded) {
            this.need_fresh = true
            return
        }

        if (!this.model.seaHegemonyData) {
            return
        }

        
        // [ts2lua]this.model.seaPreList下标访问可能不正确
        let data = this.model.seaPreList[index]
        if (data) {
            this.nameLb.text = "S" + data.server_num + "." + data.role_name
            this.guildNameLb.text = data.guild_name
            this.fightLb.text = data.power + ""
            this.allLb.text = Util.StrToHTML("点击查看全部结社")
        } else {
            this.curImg.visible = false
            this.nameLb.text = "虚位以待"
            this.guildNameLb.text = "虚位以待"
            this.fightLb.text = "0"
            this.allLb.text = ""
        }
        let camp = this.model.seaHegemonyData.camp
        this.hasJoin = camp != 0
        Util.SetImageGray(this._Image1, this.hasJoin && camp != this.index)
        this.curImg.visible = camp == this.index
        this.labelDisplay.gray=this.hasJoin && camp != this.index
        this.labelDisplay.text = (camp == this.index && ("取消") || ("加入"))

        ResManager.GetInstance().SetOutsideImageSprite(this, this.seaBg,GameResPath.GetIconOtherPath("seaHegemony", `ui_shzb_0${36 + index}`))
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }


seaBg:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
nameLb:Laya.Label
guildNameLb:Laya.Label
fightLb:Laya.Label
allLb:Laya.Label
joinBtn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
curImg:Laya.Image
public GetComponents() {
[
this.seaBg,
this._Label1,
this._Label2,
this._Label3,
this.nameLb,
this.guildNameLb,
this.fightLb,
this.allLb,
this.joinBtn,
this._Image1,
this.labelDisplay,
this.curImg,
]
 = this.GetChildrenByNames([

"seaBg",
"_Label1",
"_Label2",
"_Label3",
"nameLb",
"guildNameLb",
"fightLb",
"allLb",
"joinBtn",
"_Image1",
"labelDisplay",
"curImg",
])
}
}
 window["SeaHegemonyJoinItem"]= SeaHegemonyJoinItem