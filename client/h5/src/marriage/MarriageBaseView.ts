import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { MarriageDefine, MarriageEvent, MarriageModel, MarriageRedList } from "../commonModel/MarriageModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { MarriageBaseBtn } from "./MarriageBaseBtn"
import { MarriageDunView } from "./MarriageDunView"
import { MarriageFriendView } from "./MarriageFriendView"
import { MarriageGiftView } from "./MarriageGiftView"
import { MarriageMainView } from "./MarriageMainView"
import { MarriageRingView } from "./MarriageRingView"

export class MarriageBaseView extends BaseView1 {
    CheckRedStatus
    Clear
    InitEvent
    LoadSuccess
    Local_Open
    OpenView
    SelectRadioBtn
    open_callback
    public constructor() {
        super()
        this.base_file = "marriage"
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageBaseView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.not_show_main_msg = true
        this.change_scene_close = true
        this.is_lastView_close = true
        this.click_bg_toClose=true
        
        //this.preload_server_config = [config_dungeon=false]
        let _model = MarriageModel.GetInstance()
        let role_mgr = RoleManager.GetInstance()

        let _tabDataList_ = null
        let _viewList_ = []
        let _btn_list_ = []
        let _default_index_ = 0
        let _cur_index_ = -1
        this.load_callback = () => {

            this.LoadSuccess()
        }

        this.open_callback = () => {
            this.OpenView()
        }

        this.destroy_callback = () => {
            this.Clear()
        }

        _tabDataList_ = [{ label: "大厅", title: "uijh_001c", open_lv: MarriageDefine.ICON_OPEN_LV_2, class: MarriageFriendView },
                         { label: "姻缘", title: "uijh_001c", open_lv: MarriageDefine.ICON_OPEN_LV_2, class: MarriageMainView, mtype: ModuleType.MARRIAGE_ASK },
                         { label: "指环", title: "uijh_001c", open_lv: MarriageDefine.OPEN_LV, class: MarriageRingView, mtype: ModuleType.MARRIAGE_RING },
                         { label: "锦囊", title: "uijh_001c", open_lv: MarriageDefine.OPEN_LV, class: MarriageGiftView, mtype: ModuleType.MARRIAGE_GIFT },
                         { label: "副本", title: "uijh_001c", open_lv: MarriageDefine.OPEN_LV, class: MarriageDunView }]
 
        this.Local_Open  = (parms?) => {
            let data = parms&&parms[0]||[]
            let role_vo = role_mgr.GetMainRoleVo()
            let married = role_vo.is_marriage == 2
            if(data&&data.length>0){
                _default_index_ = data[0] 
            }else{
                _default_index_ = married?1:0
            }
        }
        this.Clear = () => {
            for (let _tmpi in _viewList_) {
                var subView = _viewList_[_tmpi]
                if (!subView) {
                    break
                }
                subView.DeleteMe()
            }
            for (let btn of _btn_list_) {
                btn.DeleteMe()
            }
            _btn_list_ = []
            _viewList_ = []
            _default_index_ = 0
            _cur_index_ = -1
            //this._radioGroup.removeEventListener(Laya.UIEvent.CHANGE, this.SelectRadioBtn, this)
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img1, GameResPath.GetIcon("marriage", "ui_marry_01"))
            //this._radioGroup = eui. new RadioButtonGroup()
            //this._radioGroup.addEventListener(Laya.UIEvent.CHANGE, this.SelectRadioBtn, this)

            let item
            for (let i = 0; i < _tabDataList_.length; i++) {
                item = _btn_list_[i]
                if (!item) {
                    item = new MarriageBaseBtn(this._group_btn)
                    item.Load()
                    _btn_list_[i] = item
                }
                item.SetData(_tabDataList_[i], i)
            }

            this.InitEvent()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)


            this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mtype?) => {
                for (let k in MarriageRedList) {
                    var v = MarriageRedList[k]
                    if (v == mtype) {
                        this.CheckRedStatus()
                        return
                    }
                }
            })

            let click_fun = (index) => {
                this.SelectRadioBtn(index)
            }
            this.BindEvent(_model, MarriageEvent.TAB_BTN_CLICK, click_fun)
        }

        this.OpenView = () => {
            if (_btn_list_[_default_index_]) {
                _btn_list_[_default_index_].SetSelect(true)
            }
            this.CheckRedStatus()
        }

        this.CheckRedStatus = () => {
            let item
            let data
            for (let i = 0; i < _tabDataList_.length; i++) {
                item = _btn_list_[i]
                data = _tabDataList_[i]
                if (!item || !data) {
                    break
                }
                item.SetRedDot(_model.CheckRedStatus(data.mtype))
            }
        }

        this.SelectRadioBtn = (tab_index) => {
            if (_cur_index_ == tab_index) {
                return
            }

            let data = _tabDataList_[tab_index]
            let role_lv = role_mgr.GetMainRoleVo().level
            if (role_lv < data.open_lv) {
                Message.show("该功能" + data.open_lv + "级开启")
                if (_btn_list_[_cur_index_]) {
                    _btn_list_[_cur_index_].SetSelect(true, true)
                }
                // this.selectedValue = _cur_index_
                // setToggleOn(_cur_index_, true)
                // setToggleOn(index, false)
                return
            }
            if (_btn_list_[_cur_index_]) {
                // setToggleOn(_cur_index_, false)
                let parent: Laya.Box = this._viewStack.getChildAt(_cur_index_) as Laya.Box
                if (parent) {
                    parent.visible = false
                }
                let subView = _viewList_[_cur_index_]
                if (subView) {
                    subView.SetVisible(false)
                }
                //parent.visible = false 
                // setToggleOn(index, true)
            } else if (_cur_index_ == -1 && _btn_list_[tab_index]) {
                // setToggleOn(index, true)
            }
            _cur_index_ = tab_index
            let subView = _viewList_[tab_index]
            let parent: Laya.Box = this._viewStack.getChildAt(tab_index) as Laya.Box
            let view_class = data.class
            if ((!subView && parent) && view_class) {
                subView = new view_class(parent)
                subView.Load()
                _viewList_[tab_index] = subView
            } else {
                if (subView) {
                    subView.SetVisible(true)
                }
            }
            if (parent) {
                parent.visible = true
            }
            ResManager.GetInstance().SetImageSprite(this, this._img_title, "marriage_asset", data.title, true)
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("marriage", data.bg))
        }
    }

    public Open(...new_args) {
        this.Local_Open(new_args)
        super.Open()
    }

    con: Laya.Box
    img1: Laya.Image
    img2: Laya.Image
    _img_title: Laya.Image
    _img_bg: Laya.Image
    _viewStack: Laya.Box
    _Group1: Laya.Box
    _Group2: Laya.Box
    _Group3: Laya.Box
    _Group4: Laya.Box
    _Group5: Laya.Box
    con2: Laya.Box
    _btn_close: Laya.Image
    box_con: Laya.Box
    _group_btn: Laya.HBox
    public GetComponents() {
        [
            this.con,
            this.img1,
            this.img2,
            this._img_title,
            this._img_bg,
            this._viewStack,
            this._Group1,
            this._Group2,
            this._Group3,
            this._Group4,
            this._Group5,
            this.con2,
            this._btn_close,
            this.box_con,
            this._group_btn,
        ]
            = this.GetChildrenByNames([

                "con",
                "img1",
                "img2",
                "_img_title",
                "_img_bg",
                "_viewStack",
                "_Group1",
                "_Group2",
                "_Group3",
                "_Group4",
                "_Group5",
                "con2",
                "_btn_close",
                "box_con",
                "_group_btn",
            ])
    }
}
window["MarriageBaseView"] = MarriageBaseView