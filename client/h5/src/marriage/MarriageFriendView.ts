import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { table } from "../common/table";
import { MarriageEvent, MarriageModel, MarriageRecordType } from "../commonModel/MarriageModel";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { MarriageFriendItem } from "./MarriageFriendItem";

export class MarriageFriendView extends BaseItem1 {

    LoadSuccess
    InitEvent
    UpdateView
    SwitchPage
    UpdateItems
    loop_mgr:LoopScrowViewMgr
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageFriendView"
        let _model = MarriageModel.GetInstance(),
            local_MarriageEvent = MarriageEvent,
            local_Util = Util,
            local_GlobalEventSystem = GlobalEventSystem,
            OPEN_VIEW = EventName.OPEN_VIEW,
            local_MarriageRecordType = MarriageRecordType,
            local_Math = Math,
            local_Message = Message,
            // _ac_item_: eui.ArrayCollection,
            _cur_index_ = 0,
            _per_count_ = 10,
            _max_page_ = 0,
            _player_list_ = []

        this.load_callback = function () {
            if (PlatformManager.IsEyouEnPlatform()) {
                for(let i = 0;i<this.group3.numChildren;i++){
                    let box:Laya.Box = this.group3.getChildAt(i) 
                    if(box){
                        let lb:Laya.Label = box.getChildAt(1) as Laya.Label
                        if(lb){
                            lb.fontSize = 18
                            lb.pos(1,0)
                            lb.width = 141
                            lb.height = 52
                            lb.wordWrap = true
                            lb.leading = 0.1
                        }
                    }
                }
            }
            this.LoadSuccess()
        }
        this.DeleteMe = () => {
            _cur_index_ = 0;
            _per_count_ = 10;
            _max_page_ = 0;
            _player_list_ = [];
            if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            this._list.scrollBar.visible = false

            this.InitEvent()
            _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17200, "c", 1)
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_issue, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageIssueView")
            }, this, true)

            local_Util.AddClickEvent(this._btn_flower, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageRecordFlowerView")
            }, this, true)

            local_Util.AddClickEvent(this._btn_com_self, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageRecordComView", local_MarriageRecordType.Self)
            }, this, true)

            local_Util.AddClickEvent(this._btn_com_other, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageRecordComView", local_MarriageRecordType.Other)
            }, this, true)

            local_Util.AddClickEvent(this._btn_top, () => {
                this.SwitchPage(0)
            }, this, true)

            local_Util.AddClickEvent(this._btn_left, () => {
                this.SwitchPage(_cur_index_ - 1)
            }, this, true)

            local_Util.AddClickEvent(this._btn_right, () => {
                this.SwitchPage(_cur_index_ + 1)
            }, this, true)

            local_Util.AddClickEvent(this._btn_bottom, () => {
                this.SwitchPage(_player_list_.length - 1)
            }, this, true)

            // this.BindVar(_model, "_friend_info", () => {
            //     this.UpdateView()
            // })

            this.BindEvent(_model, local_MarriageEvent.UPDATE_FRIEND_INFO, (scmd) => {
                if (scmd.page != 1) return
                this.UpdateView()
            })

            // this.BindEvent(_model, FriendEvent.FRIEND_DATA_UPDATE, (type) => {
            //     this.UpdateView()
            // })
        }

        this.UpdateView = () => {
            let friend_info = _model.GetFriendInfo(1)
            if (!friend_info) return
            let length = friend_info.player_list.length
            this._group_empty.visible = length <= 0
            let max_page = local_Math.ceil(length / _per_count_)
            _cur_index_ = local_Math.min(max_page, _cur_index_)
            _player_list_ = []
            for (let i = 0; i < max_page; i++) {
                _player_list_[i] = []
            }
            for (let i = 0; i < length; i++) {
                let info = friend_info.player_list[i]
                let index = local_Math.floor(i / _per_count_)
                _player_list_[index].push(info)
            }

            this.UpdateItems(_player_list_[_cur_index_])
            _max_page_ = max_page > 0 ? max_page : 1
            this._lb_page.text = `${_cur_index_ + 1}/${_max_page_}`
        }

        this.SwitchPage = (tar_page) => {
            if (tar_page < 0) { local_Message.show("已是最前一页"); return; }
            if (tar_page >= _player_list_.length) { local_Message.show("已是最后一页"); return; }
            if (_cur_index_ == tar_page) return
            _cur_index_ = tar_page
            this.UpdateItems(_player_list_[tar_page])
            this._lb_page.text = `${tar_page + 1}/${_max_page_}`
        }

        this.UpdateItems = (list) => {
            if (!list){
                list = []
            }

            let func=(a,b)=>{
                if(a.vip==b.vip){
                    return a.vip_exp>b.vip_exp
                }
                return a.vip>b.vip
            }
            table.sort(list,func)

            if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list, MarriageFriendItem, list, LoopScrCon.Vertical, undefined)
			} else {
				this.loop_mgr.replaceAll(list)
			}
        }
    }


_list:Laya.List
group1:Laya.HBox
_btn_top:Laya.Box
img1:Laya.Image
label1:Laya.Label
_btn_left:Laya.Box
img2:Laya.Image
label2:Laya.Label
group2:Laya.Box
img3:Laya.Image
_lb_page:Laya.Label
_btn_right:Laya.Box
img4:Laya.Image
label4:Laya.Label
_btn_bottom:Laya.Box
img5:Laya.Image
label5:Laya.Label
group3:Laya.HBox
_btn_flower:Laya.Box
img6:Laya.Image
label6:Laya.Label
_btn_com_self:Laya.Box
img7:Laya.Image
label7:Laya.Label
_btn_com_other:Laya.Box
img8:Laya.Image
label8:Laya.Label
_btn_issue:Laya.Box
img9:Laya.Image
label9:Laya.Label
_group_empty:Laya.Box
img10:Laya.Image
label10:Laya.Label
public GetComponents() {
[
this._list,
this.group1,
this._btn_top,
this.img1,
this.label1,
this._btn_left,
this.img2,
this.label2,
this.group2,
this.img3,
this._lb_page,
this._btn_right,
this.img4,
this.label4,
this._btn_bottom,
this.img5,
this.label5,
this.group3,
this._btn_flower,
this.img6,
this.label6,
this._btn_com_self,
this.img7,
this.label7,
this._btn_com_other,
this.img8,
this.label8,
this._btn_issue,
this.img9,
this.label9,
this._group_empty,
this.img10,
this.label10,
]
 = this.GetChildrenByNames([

"_list",
"group1",
"_btn_top",
"img1",
"label1",
"_btn_left",
"img2",
"label2",
"group2",
"img3",
"_lb_page",
"_btn_right",
"img4",
"label4",
"_btn_bottom",
"img5",
"label5",
"group3",
"_btn_flower",
"img6",
"label6",
"_btn_com_self",
"img7",
"label7",
"_btn_com_other",
"img8",
"label8",
"_btn_issue",
"img9",
"label9",
"_group_empty",
"img10",
"label10",
])
}
}
 window["MarriageFriendView"]= MarriageFriendView