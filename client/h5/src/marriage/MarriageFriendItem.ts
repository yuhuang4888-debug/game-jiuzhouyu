import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { EventName } from "../common/EventName";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { FriendEvent, FriendModel } from "../commonModel/FriendModel";
import { MarriageEvent, MarriageModel, MarriageStateCfg } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, RefBoxChildsLayout, Util } from "../util/Util";

export class MarriageFriendItem extends BaseItemRenderer {
    public WIDTH = 582 
    public HEIGT = 122


    private _event_1;
    private _event_2;
    _model: MarriageModel
    _head: CustomHeadItem
    public constructor() {
        super()
        this.base_file = "marriage"
        this.layout_file = "MarriageFriendItem"
        this._model = MarriageModel.GetInstance()
        this.Load()
    }

    public load_callback() {
        this._head = new CustomHeadItem(this._head_con)
        this._head.Load()

        this._event_1 = this._model.Bind(MarriageEvent.GIVE_GIFT_SUCCESS, (scmd) => {
            if (!this.data) return
            if (this.data.role_id != scmd.receive_id) return
            let fri_vo = FriendModel.GetInstance().getFriendById(scmd.receive_id)
            if (fri_vo) {
                this.data.intimacy = fri_vo.intimacy
                this._lb_intimacy.text = fri_vo.intimacy.toString()
            }
        })

        this._event_2 = this._model.Bind(MarriageEvent.GET_FLOWER, (scmd) => {
            if (!this.data) return
            if (this.data.role_id != scmd.role_id) return
            let fri_vo = FriendModel.GetInstance().getFriendById(scmd.role_id)
            if (fri_vo) {
                this.data.intimacy = fri_vo.intimacy
                this._lb_intimacy.text = fri_vo.intimacy.toString()
            }
        })

        Util.AddClickEvent(this._btn_com, () => {
            if (!this.data) return
            if (this.data.role_id == RoleManager.GetInstance().GetMainRoleId()) {
                Message.show("不能撩自己")
                return
            }
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageComView", this.data)
        }, this, true)

        Util.AddClickEvent(this.touch_gp, () => {
            if (!this.data) return
            if (RoleManager.GetInstance().GetMainRoleId() == this.data.role_id) {
                return
            }
            // FriendModel.GetInstance().Fire(FriendEvent.OPEN_FRIEND_MENU, evt,this.data)
        }
            , this)

        //不绑定亲密度变化事件了
        ResManager.GetInstance().SetImageSprite(this.base_item, this._img_bg,"marriage","uijh_034")
    }



    public DeleteMe() {
        if (this._head) {
            this._head.DeleteMe()
            this._head = undefined
        }
        if (this._event_1) {
            this._model.UnBind(this._event_1)
            this._event_1 = undefined
        }
        if (this._event_2) {
            this._model.UnBind(this._event_2)
            this._event_2 = undefined
        }
        super.DeleteMe()
    }


    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        this._lb_name.text = `${data.name} lv.${data.lv}`
        this._lb_msg.text = data.msg
        this._lb_intimacy.text = data.intimacy
        let frame_id = DressModel.GetInstance().GetDressByType(data.dress_list, DressType.Photo)
        this._head.SetRoleVoData(data)
        // this._head.setData(data.lv || data.level, data.career, data.picture, undefined, undefined, frame_id)
        let list = data.tag_list
        let length = data.tag_list.length
        if (length > 0) {
            if (length > 2) list = data.tag_list.splice(2, length - 2)
            this._lb_tag.text = this._model.GetTagsStr(list)
        }
        this._group_tag.visible = length > 0

        let state = undefined
        if (data.role_id == RoleManager.GetInstance().GetMainRoleId()) {
            state = MarriageStateCfg.Self
        } else if (data.if_marriage == 2) {
            state = MarriageStateCfg.Married
        } else if (data.if_marriage == 0) {
            state = MarriageStateCfg.Single
        }
        this._img_state.skin = AtlasUrl("marriage", state ? `${state.pic}` : "")

        //vip&&头衔
        this.vip_di1.visible = this.txt_touxian.visible=this.effect_touxian.visible=false
        if(data.vip>0){
            let source
            //需要服务端下发一个vip_hide标识
			if(data.vip_hide > 0){
				source = "VIP-x"
				if (data.is_supvip == 1) {
					source = "SVIP-x"
				}
			}
			else{
				source = "uivip_zjm_" + data.vip
				if (data.is_supvip == 1) {
					source = "VIP_" + data.vip
				}
			}
			ResManager.GetInstance().SetImageSprite(this, this.vip_di1, "mainUI", source)
            // ResManager.GetInstance().SetImageSprite(this, this.vip_di1, "mainUI", "uivip_zjm_" + data.vip)
            this.vip_di1.visible=true
            RefBoxChildsLayout(this._Group1,5,null,true,"left")
        }
      
    }


_img_bg:Laya.Image
_Group1:Laya.Box
_lb_name:Laya.Label
vip_di1:Laya.Image
txt_touxian:Laya.Label
effect_touxian:Laya.Box
_group_tag:Laya.Box
_Image1:Laya.Image
_lb_tag:Laya.Label
_lb_msg:Laya.Label
_head_con:Laya.Box
_btn_com:Laya.Image
_Group2:Laya.Box
_Image21:Laya.Image
_Image2:Laya.Image
_lb_intimacy:Laya.Label
_img_state:Laya.Image
touch_gp:Laya.Box
public GetComponents() {
[
this._img_bg,
this._Group1,
this._lb_name,
this.vip_di1,
this.txt_touxian,
this.effect_touxian,
this._group_tag,
this._Image1,
this._lb_tag,
this._lb_msg,
this._head_con,
this._btn_com,
this._Group2,
this._Image21,
this._Image2,
this._lb_intimacy,
this._img_state,
this.touch_gp,
]
 = this.GetChildrenByNames([

"_img_bg",
"_Group1",
"_lb_name",
"vip_di1",
"txt_touxian",
"effect_touxian",
"_group_tag",
"_Image1",
"_lb_tag",
"_lb_msg",
"_head_con",
"_btn_com",
"_Group2",
"_Image21",
"_Image2",
"_lb_intimacy",
"_img_state",
"touch_gp",
])
}
}
 window["MarriageFriendItem"]= MarriageFriendItem